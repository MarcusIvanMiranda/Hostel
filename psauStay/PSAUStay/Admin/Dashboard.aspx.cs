using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace PSAUStay.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        // Class-level connection string variable
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        public string ChartLabelsJson = "[]";
        public string ChartDataJson = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Account/Login.aspx");
                    return;
                }
                FullRefresh();
            }
            else
            {
                // Re-calculate chart data on PostBack to ensure JS variables are populated
                LoadChartData();
            }
        }

        private void FullRefresh()
        {
            LoadSummaryCards();
            CalculateRevenue();
            LoadChartData();

            gvApprovedStays.DataSource = GetApprovedStaysData();
            gvApprovedStays.DataBind();

            gvRejectedStays.DataSource = GetRejectedStaysData();
            gvRejectedStays.DataBind();

            gvRecentCheckouts.DataSource = GetRecentCheckoutsData();
            gvRecentCheckouts.DataBind();
        }

        private void CalculateRevenue()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Sums price * days for Approved stays only from both tables
                string query = @"
                    SELECT SUM(TotalPrice) FROM (
                        SELECT (RM.Price * DATEDIFF(DAY, RQ.CheckInDate, RQ.CheckOutDate)) as TotalPrice
                        FROM RoomRequests RQ 
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        WHERE RQ.Status = 'Approved'
                        UNION ALL
                        SELECT (RM.Price * DATEDIFF(DAY, R.CheckInDate, R.CheckOutDate)) as TotalPrice
                        FROM [dbo].[Reservation] R 
                        INNER JOIN Rooms RM ON R.RoomID = RM.RoomID
                        WHERE R.Status = 'Approved'
                    ) AS RevenueData";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                object result = cmd.ExecuteScalar();
                decimal total = (result != DBNull.Value) ? Convert.ToDecimal(result) : 0;
                lblTotalRevenue.Text = total.ToString("N2");
            }
        }

        private void LoadSummaryCards()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                // 'Total' includes everything (Pending + Approved + Rejected + Waitlisted)
                string query = @"
                    SELECT 
                        (SELECT COUNT(*) FROM RoomRequests) + (SELECT COUNT(*) FROM [dbo].[Reservation]) AS Total,
                        (SELECT COUNT(*) FROM RoomRequests WHERE Status IN ('Pending', 'Waitlist')) + 
                        (SELECT COUNT(*) FROM [dbo].[Reservation] WHERE Status IN ('Pending', 'Waitlisted')) AS Pending,
                        (SELECT COUNT(*) FROM RoomRequests WHERE Status='Approved') + 
                        (SELECT COUNT(*) FROM [dbo].[Reservation] WHERE Status='Approved') AS Approved,
                        (SELECT COUNT(*) FROM RoomRequests WHERE Status='Rejected') + 
                        (SELECT COUNT(*) FROM [dbo].[Reservation] WHERE Status='Rejected') AS Rejected";

                using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblTotalRequests.Text = dr["Total"].ToString();
                        lblPendingRequests.Text = dr["Pending"].ToString();
                        lblApprovedRequests.Text = dr["Approved"].ToString();
                        lblRejectedRequests.Text = dr["Rejected"].ToString();
                    }
                }
            }
        }

        private void LoadChartData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT MonthLabel, COUNT(*) as Count, MIN(SortDate) as SortOrder
                    FROM (
                        SELECT FORMAT(DateRequested, 'MMM yyyy') as MonthLabel, DateRequested as SortDate FROM RoomRequests
                        UNION ALL
                        SELECT FORMAT(DateCreated, 'MMM yyyy') as MonthLabel, DateCreated as SortDate FROM [dbo].[Reservation]
                    ) AS Combined
                    GROUP BY MonthLabel
                    ORDER BY SortOrder ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                List<string> labels = new List<string>();
                List<int> counts = new List<int>();

                while (dr.Read())
                {
                    labels.Add(dr["MonthLabel"].ToString());
                    counts.Add(Convert.ToInt32(dr["Count"]));
                }

                if (labels.Count == 0) { labels.Add("No Data"); counts.Add(0); }

                JavaScriptSerializer js = new JavaScriptSerializer();
                ChartLabelsJson = js.Serialize(labels);
                ChartDataJson = js.Serialize(counts);
            }
        }

        private DataTable GetApprovedStaysData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT RequestID, FullName, Email, Contact, RoomName, Price, CheckInDate, CheckOutDate, Status, DateRequested,
                           (Price * DATEDIFF(DAY, CheckInDate, CheckOutDate)) as TotalPrice,
                           (Price * DATEDIFF(DAY, CheckInDate, CheckOutDate) * 0.50) as Downpayment,
                           PaymentType as PaymentStatus,
                           (Source + CAST(RequestID AS VARCHAR)) as CombinedID
                    FROM (
                        SELECT RQ.RequestID, ISNULL(GL.FullName, 'Guest') as FullName, RQ.Email, RQ.Email as Contact, RM.RoomName, RM.Price, RQ.CheckInDate, RQ.CheckOutDate, RQ.Status, RQ.DateRequested, 
                               CASE WHEN RQ.Message LIKE '%|PaymentType:%' THEN SUBSTRING(RQ.Message, CHARINDEX('|PaymentType:', RQ.Message) + 13, 50) ELSE 'Pending' END as PaymentType,
                               'Online' as Source
                        FROM RoomRequests RQ 
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.Status = 'Approved'
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest') as FullName, R.Contact as Email, R.Contact, RM.RoomName, RM.Price, R.CheckInDate, R.CheckOutDate, R.Status, R.DateCreated,
                               ISNULL(R.PaymentStatus, 'Pending') as PaymentType,
                               'Manual' as Source
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = 'Approved'
                    ) AS CombinedData ORDER BY DateRequested DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetRejectedStaysData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT RequestID, FullName, Email, Contact, RoomName, Price, CheckInDate, CheckOutDate, Status, DateRequested,
                           (Source + CAST(RequestID AS VARCHAR)) as CombinedID
                    FROM (
                        SELECT RQ.RequestID, ISNULL(GL.FullName, 'Guest') as FullName, RQ.Email, RQ.Email as Contact, RM.RoomName, RM.Price, RQ.CheckInDate, RQ.CheckOutDate, RQ.Status, RQ.DateRequested, 'Online' as Source
                        FROM RoomRequests RQ 
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.Status = 'Rejected'
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest') as FullName, R.Contact as Email, R.Contact, RM.RoomName, RM.Price, R.CheckInDate, R.CheckOutDate, R.Status, R.DateCreated, 'Manual' as Source
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = 'Rejected'
                    ) AS CombinedData ORDER BY DateRequested DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetRecentCheckoutsData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT *, (BasePrice + ExtraTotal) as TotalBill, (Source + CAST(ID AS VARCHAR)) as CombinedID FROM (
                        SELECT RQ.RequestID as ID, ISNULL(GL.FullName, 'Guest') as FullName, RU.RoomNumber, RM.RoomName, RM.Price as BasePrice, RQ.CheckOutDate, 'Online' as Source, ISNULL(RQ.PaymentStatus, 'Pending') as PaymentStatus,
                               ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = RQ.RequestID AND Source = 'Online'), 0) as ExtraTotal
                        FROM RoomRequests RQ 
                        JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        JOIN RoomUnits RU ON RU.UnitID = TRY_CAST(SUBSTRING(RQ.Message, CHARINDEX('UnitID:', RQ.Message) + 7, 2) AS INT)
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.Status = 'CheckedOut'
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest'), RU.RoomNumber, RM.RoomName, RM.Price, R.CheckOutDate, 'Manual', ISNULL(R.PaymentStatus, 'Pending') as PaymentStatus,
                               ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = R.ReservationID AND Source = 'Manual'), 0) as ExtraTotal
                        FROM [dbo].[Reservation] R 
                        JOIN Rooms RM ON R.RoomID = RM.RoomID 
                        JOIN RoomUnits RU ON R.UnitID = RU.UnitID 
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = 'CheckedOut'
                    ) AS CombinedData ORDER BY CheckOutDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void gvApprovedStays_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "TotalPrice" || e.DataColumn.FieldName == "Downpayment")
            {
                decimal value = Convert.ToDecimal(e.CellValue ?? 0);
                string paymentStatus = e.GetValue("PaymentStatus")?.ToString() ?? "Pending";
                string formatted = "₱" + value.ToString("N2");

                if (e.DataColumn.FieldName == "TotalPrice" && paymentStatus == "Fully Paid")
                    formatted += " <span style='background-color: #28a745; color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; margin-left: 5px;'>(Paid)</span>";
                else if (e.DataColumn.FieldName == "Downpayment" && (paymentStatus == "Downpayment Paid" || paymentStatus == "Fully Paid"))
                    formatted += " <span style='background-color: #28a745; color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; margin-left: 5px;'>(Paid)</span>";

                e.Cell.Text = formatted;
            }
            else if (e.DataColumn.FieldName == "PaymentStatus")
            {
                string status = e.CellValue?.ToString() ?? "Pending";
                string badgeStyle = "padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; color: white;";

                if (status.Contains("Fully")) badgeStyle += "background-color: #28a745;";
                else if (status.Contains("Downpayment")) badgeStyle += "background-color: #ffc107; color: #212529;";
                else badgeStyle += "background-color: #6c757d;";

                e.Cell.Text = $"<span style='{badgeStyle}'>{status}</span>";
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e) => FullRefresh();

        protected void gvApprovedStays_DataBinding(object sender, EventArgs e) => gvApprovedStays.DataSource = GetApprovedStaysData();

        protected void gvRejectedStays_DataBinding(object sender, EventArgs e) => gvRejectedStays.DataSource = GetRejectedStaysData();

        protected void gvRecentCheckouts_DataBinding(object sender, EventArgs e) => gvRecentCheckouts.DataSource = GetRecentCheckoutsData();

        protected void gvApprovedStays_RowCommand(object sender, DevExpress.Web.ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Delete")
            {
                string combinedID = gvApprovedStays.GetRowValues(e.VisibleIndex, "CombinedID").ToString();
                string source = combinedID.StartsWith("Online") ? "Online" : "Manual";
                string id = combinedID.Substring(source.Length);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = (source == "Online") ? "DELETE FROM RoomRequests WHERE RequestID = @id" : "DELETE FROM [dbo].[Reservation] WHERE ReservationID = @id";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                }
                FullRefresh();
            }
        }
    }
}