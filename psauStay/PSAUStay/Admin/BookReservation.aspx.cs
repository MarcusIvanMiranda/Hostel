using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using DevExpress.Web;

namespace PSAUStay.Admin
{
    public partial class BookReservation : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Account/Login.aspx"); return; }

            if (!IsPostBack)
            {
                LoadRoomTypes();
                LoadStatistics();
                LoadUpcomingReservations();
            }
        }

        private void LoadRoomTypes()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT DISTINCT RoomName FROM Rooms ORDER BY RoomName";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlRoomFilter.Items.Add(new System.Web.UI.WebControls.ListItem(dr["RoomName"].ToString(), dr["RoomName"].ToString()));
                }
            }
        }

        private void LoadStatistics()
        {
            DateTime today = DateTime.Today;
            DateTime weekStart = today.AddDays(-(int)today.DayOfWeek);
            DateTime weekEnd = weekStart.AddDays(7);
            DateTime next7Days = today.AddDays(7);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Total upcoming
                string totalQuery = @"
                    SELECT COUNT(*) FROM (
                        SELECT RequestID, CheckInDate FROM RoomRequests WHERE CheckInDate > @Today
                        UNION ALL
                        SELECT ReservationID, CheckInDate FROM [dbo].[Reservation] WHERE CheckInDate > @Today
                    ) AS Combined";
                SqlCommand totalCmd = new SqlCommand(totalQuery, con);
                totalCmd.Parameters.AddWithValue("@Today", today);
                con.Open();
                lblTotalUpcoming.Text = totalCmd.ExecuteScalar().ToString();

                // This week
                string weekQuery = @"
                    SELECT COUNT(*) FROM (
                        SELECT RequestID, CheckInDate FROM RoomRequests WHERE CheckInDate > @WeekStart AND CheckInDate < @WeekEnd
                        UNION ALL
                        SELECT ReservationID, CheckInDate FROM [dbo].[Reservation] WHERE CheckInDate > @WeekStart AND CheckInDate < @WeekEnd
                    ) AS Combined";
                SqlCommand weekCmd = new SqlCommand(weekQuery, con);
                weekCmd.Parameters.AddWithValue("@WeekStart", weekStart);
                weekCmd.Parameters.AddWithValue("@WeekEnd", weekEnd);
                lblThisWeek.Text = weekCmd.ExecuteScalar().ToString();

                // Next 7 days
                string next7Query = @"
                    SELECT COUNT(*) FROM (
                        SELECT RequestID, CheckInDate FROM RoomRequests WHERE CheckInDate > @Today AND CheckInDate <= @Next7Days
                        UNION ALL
                        SELECT ReservationID, CheckInDate FROM [dbo].[Reservation] WHERE CheckInDate > @Today AND CheckInDate <= @Next7Days
                    ) AS Combined";
                SqlCommand next7Cmd = new SqlCommand(next7Query, con);
                next7Cmd.Parameters.AddWithValue("@Today", today);
                next7Cmd.Parameters.AddWithValue("@Next7Days", next7Days);
                lblNext7Days.Text = next7Cmd.ExecuteScalar().ToString();
            }
        }

        private void LoadUpcomingReservations()
        {
            DateTime today = DateTime.Today;
            string statusFilter = ddlStatusFilter.SelectedValue;
            string dateRange = ddlDateRange.SelectedValue;
            string roomFilter = ddlRoomFilter.SelectedValue;
            bool showOnlyPending = chkShowOnlyPending.Checked;

            DateTime startDate = today;
            DateTime endDate = DateTime.MaxValue;

            switch (dateRange)
            {
                case "Today":
                    endDate = today;
                    break;
                case "ThisWeek":
                    DateTime weekStart = today.AddDays(-(int)today.DayOfWeek);
                    startDate = weekStart;
                    endDate = weekStart.AddDays(7);
                    break;
                case "Next7Days":
                    endDate = today.AddDays(7);
                    break;
                case "Next30Days":
                    endDate = today.AddDays(30);
                    break;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT CombinedID, FullName, Email, Contact, RoomName, CheckInDate, CheckOutDate, Status, TotalPrice, PaymentStatus,
                           DATEDIFF(day, GETDATE(), CheckInDate) as DaysUntilCheckIn
                    FROM (
                        SELECT 
                            RQ.RequestID as CombinedID, 
                            ISNULL(GL.FullName, 'Guest') as FullName, 
                            ISNULL(GL.Email, RQ.Email) as Email, 
                            ISNULL(GL.Contact, RQ.Email) as Contact, 
                            RM.RoomName, 
                            RQ.CheckInDate, 
                            RQ.CheckOutDate, 
                            RQ.Status,
                            CAST(0 as decimal(10,2)) as TotalPrice,
                            'Pending' as PaymentStatus
                        FROM RoomRequests RQ 
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.CheckInDate > @StartDate AND RQ.CheckInDate <= @EndDate
                        
                        UNION ALL
                        
                        SELECT 
                            R.ReservationID as CombinedID, 
                            ISNULL(GL.FullName, 'Guest') as FullName, 
                            ISNULL(GL.Email, R.Contact) as Email, 
                            ISNULL(GL.Contact, R.Contact) as Contact, 
                            ISNULL(RM.RoomName, 'Unknown Room') as RoomName, 
                            R.CheckInDate, 
                            R.CheckOutDate, 
                            R.Status,
                            ISNULL(R.TotalPrice, 0) as TotalPrice,
                            ISNULL(R.PaymentStatus, 'Pending') as PaymentStatus
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.CheckInDate > @StartDate AND R.CheckInDate <= @EndDate
                    ) AS CombinedData 
                    WHERE 1=1";

                if (statusFilter != "All")
                {
                    query += " AND Status = @Status";
                }

                if (roomFilter != "All")
                {
                    query += " AND RoomName = @RoomName";
                }

                if (showOnlyPending)
                {
                    query += " AND Status = 'Pending'";
                }

                query += " ORDER BY CheckInDate ASC, FullName ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);

                if (statusFilter != "All")
                {
                    cmd.Parameters.AddWithValue("@Status", statusFilter);
                }

                if (roomFilter != "All")
                {
                    cmd.Parameters.AddWithValue("@RoomName", roomFilter);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUpcomingReservations.DataSource = dt;
                gvUpcomingReservations.DataBind();

                divNoRecords.Visible = dt.Rows.Count == 0;
            }
        }

        protected string GetStatusBadgeHtml(string status)
        {
            string css = "";
            switch (status.ToLower())
            {
                case "approved": css = "bg-success text-white"; break;
                case "pending": css = "bg-warning text-dark"; break;
                case "waitlisted": case "waitlist": css = "bg-info text-dark"; break;
                default: css = "bg-danger text-white"; break;
            }
            return string.Format("<span class='badge {0}'>{1}</span>", css, status);
        }

        protected void gvUpcomingReservations_HtmlDataCellPrepared(object sender, DevExpress.Web.ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "DaysUntilCheckIn")
            {
                int daysUntil = Convert.ToInt32(e.CellValue);
                if (daysUntil == 0)
                {
                    e.Cell.BackColor = System.Drawing.Color.FromArgb(255, 193, 7); // Yellow for today
                    e.Cell.ForeColor = System.Drawing.Color.Black;
                    e.Cell.Font.Bold = true;
                }
                else if (daysUntil <= 3)
                {
                    e.Cell.BackColor = System.Drawing.Color.FromArgb(220, 53, 69); // Red for urgent
                    e.Cell.ForeColor = System.Drawing.Color.White;
                    e.Cell.Font.Bold = true;
                }
                else if (daysUntil <= 7)
                {
                    e.Cell.BackColor = System.Drawing.Color.FromArgb(52, 152, 219); // Blue for soon
                    e.Cell.ForeColor = System.Drawing.Color.White;
                }
            }
        }

        protected void gvUpcomingReservations_RowCommand(object sender, DevExpress.Web.ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "QuickApprove")
            {
                string id = gvUpcomingReservations.GetRowValues(e.VisibleIndex, "CombinedID").ToString();
                UpdateReservationStatus(Convert.ToInt32(id), "Approved");
                LoadUpcomingReservations();
                LoadStatistics();
                ShowToast("Approved", "Reservation has been approved.", "success");
            }
        }

        private void UpdateReservationStatus(int id, string newStatus)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"UPDATE RoomRequests SET Status = @S WHERE RequestID = @ID;
                               UPDATE [dbo].[Reservation] SET Status = @S WHERE ReservationID = @ID;";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@S", newStatus);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadStatistics();
            LoadUpcomingReservations();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUpcomingReservations();
        }

        protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUpcomingReservations();
        }

        protected void ddlRoomFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUpcomingReservations();
        }

        protected void chkShowOnlyPending_ServerChange(object sender, EventArgs e)
        {
            LoadUpcomingReservations();
        }

        protected void gvUpcomingReservations_DataBinding(object sender, EventArgs e)
        {
            // This is handled in LoadUpcomingReservations()
        }

        private void ShowToast(string title, string message, string type)
        {
            string script = $"Swal.fire('{title}', '{message}', '{type}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }
    }
}
