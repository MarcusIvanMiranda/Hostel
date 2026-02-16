using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PSAUStay.Admin
{
    public partial class Checkout : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindAllData();
        }

        private void BindAllData()
        {
            gvCheckout.DataBind();
            gvHistory.DataSource = GetCheckoutData("CheckedOut");
            gvHistory.DataBind();
        }

        protected void gvCheckout_DataBinding(object sender, EventArgs e)
        {
            gvCheckout.DataSource = GetCheckoutData("Approved", txtSearch.Text.Trim());
        }

        private DataTable GetCheckoutData(string status, string searchText = "")
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = $@"
                    SELECT *, (BasePrice + ExtraTotal) as TotalBill, (Source + CAST(ID AS VARCHAR)) as CombinedID FROM (
                        SELECT RQ.RequestID as ID, ISNULL(GL.FullName, 'Guest') as FullName, RU.RoomNumber, RM.RoomName, RM.Price as BasePrice, RQ.CheckInDate, RQ.CheckOutDate, 'Online' as Source, ISNULL(RQ.PaymentStatus, 'Pending') as PaymentStatus,
                               ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = RQ.RequestID AND Source = 'Online'), 0) as ExtraTotal,
                               CASE 
                                    WHEN EXISTS(SELECT 1 FROM ExtraCharges WHERE BookingID = RQ.RequestID AND Source = 'Online')
                                    THEN STUFF((SELECT '<div class=""d-flex justify-content-between small border-bottom py-1""><span>• ' + ChargeName + '</span><span class=""fw-bold"">PHP ' + CAST(CAST(Price AS DECIMAL(10,2)) AS VARCHAR) + '</span></div>'
                                               FROM ExtraCharges WHERE BookingID = RQ.RequestID AND Source = 'Online'
                                               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 0, '')
                                    ELSE 'No extra charges' 
                               END as ExtraDetails
                        FROM RoomRequests RQ 
                        JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        JOIN RoomUnits RU ON RU.UnitID = TRY_CAST(SUBSTRING(RQ.Message, CHARINDEX('UnitID:', RQ.Message) + 7, 2) AS INT)
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.Status = '{status}' AND CAST(RQ.CheckOutDate AS DATE) <= CAST(GETDATE() AS DATE)
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest'), RU.RoomNumber, RM.RoomName, RM.Price, R.CheckInDate, R.CheckOutDate, 'Manual', ISNULL(R.PaymentStatus, 'Pending') as PaymentStatus,
                               ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = R.ReservationID AND Source = 'Manual'), 0) as ExtraTotal,
                               CASE 
                                    WHEN EXISTS(SELECT 1 FROM ExtraCharges WHERE BookingID = R.ReservationID AND Source = 'Manual')
                                    THEN STUFF((SELECT '<div class=""d-flex justify-content-between small border-bottom py-1""><span>• ' + ChargeName + '</span><span class=""fw-bold"">PHP ' + CAST(CAST(Price AS DECIMAL(10,2)) AS VARCHAR) + '</span></div>'
                                               FROM ExtraCharges WHERE BookingID = R.ReservationID AND Source = 'Manual'
                                               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 0, '')
                                    ELSE 'No extra charges' 
                               END as ExtraDetails
                        FROM [dbo].[Reservation] R 
                        JOIN Rooms RM ON R.RoomID = RM.RoomID 
                        JOIN RoomUnits RU ON R.UnitID = RU.UnitID 
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = '{status}' AND CAST(R.CheckOutDate AS DATE) <= CAST(GETDATE() AS DATE)
                    ) AS CombinedData ";

                if (!string.IsNullOrEmpty(searchText))
                    query += " WHERE FullName LIKE @Search OR RoomNumber LIKE @Search";

                query += " ORDER BY CheckOutDate DESC, ID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@Search", "%" + searchText + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindAllData();
        }

        protected void btnConfirmAction_Click(object sender, EventArgs e)
        {
            string[] args = hfSelectedID.Value.Split('|');
            if (args.Length < 2) return;
            string source = args[0], id = args[1];

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();
                try
                {
                    string tbl = (source == "Online") ? "RoomRequests" : "[dbo].[Reservation]";
                    string col = (source == "Online") ? "RequestID" : "ReservationID";

                    // 1. Get the UnitID associated with the booking
                    int unitId = 0;
                    if (source == "Online")
                    {
                        string getUnitSql = "SELECT TRY_CAST(SUBSTRING(Message, CHARINDEX('UnitID:', Message) + 7, 2) AS INT) FROM RoomRequests WHERE RequestID = @ID";
                        SqlCommand cmdUnit = new SqlCommand(getUnitSql, con, trans);
                        cmdUnit.Parameters.AddWithValue("@ID", id);
                        unitId = Convert.ToInt32(cmdUnit.ExecuteScalar());
                    }
                    else
                    {
                        SqlCommand cmdUnit = new SqlCommand("SELECT UnitID FROM [dbo].[Reservation] WHERE ReservationID = @ID", con, trans);
                        cmdUnit.Parameters.AddWithValue("@ID", id);
                        unitId = Convert.ToInt32(cmdUnit.ExecuteScalar());
                    }

                    // 2. Update Booking Status to CheckedOut
                    SqlCommand cmdUpdate = new SqlCommand($"UPDATE {tbl} SET Status = 'CheckedOut', CheckOutDate = GETDATE() WHERE {col} = @ID", con, trans);
                    cmdUpdate.Parameters.AddWithValue("@ID", id);
                    cmdUpdate.ExecuteNonQuery();

                    // 3. Set Room Unit to "To Be Cleaned" instead of "Available"
                    if (unitId > 0)
                    {
                        SqlCommand cmdRoom = new SqlCommand("UPDATE RoomUnits SET Status = 'To Be Cleaned' WHERE UnitID = @UnitID", con, trans);
                        cmdRoom.Parameters.AddWithValue("@UnitID", unitId);
                        cmdRoom.ExecuteNonQuery();
                    }

                    trans.Commit();
                    BindAllData();

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success', 'Checkout complete. Room status is now: To Be Cleaned', 'success');", true);
                }
                catch (Exception ex)
                {
                    if (trans.Connection != null) trans.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"Swal.fire('Error', 'Checkout failed: {ex.Message}', 'error');", true);
                }
            }
        }
    }
}