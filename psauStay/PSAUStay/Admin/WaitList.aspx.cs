using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class WaitList : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Account/Login.aspx"); return; }
            if (!IsPostBack) LoadWaitlist();
        }

        private void LoadWaitlist()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string combinedQuery = @"
                    SELECT r.ReservationID, ISNULL(gl.FullName, 'Guest') as FullName, ISNULL(gl.Email, r.Contact) as Email, ISNULL(gl.Contact, r.Contact) as Contact,
                           CASE WHEN r.RoomID = 0 OR r.RoomID IS NULL THEN 'Unknown Room' ELSE ISNULL(rm.RoomName, 'Unknown Room') END as RoomName, 
                           r.CheckInDate, r.CheckOutDate, r.Status 
                    FROM [dbo].[Reservation] r 
                    LEFT JOIN Rooms rm ON r.RoomID = rm.RoomID 
                    LEFT JOIN GuestList gl ON r.UserID = gl.GuestID
                    WHERE r.Status IN ('Pending', 'Waitlisted')
                    UNION ALL
                    SELECT rq.RequestID, ISNULL(gl.FullName, 'Guest') as FullName, rq.Email, rq.Email as Contact,
                           ISNULL(rm.RoomName, 'Unknown Room') as RoomName, rq.CheckInDate, rq.CheckOutDate, rq.Status
                    FROM RoomRequests rq
                    LEFT JOIN Rooms rm ON rq.RoomID = rm.RoomID
                    LEFT JOIN GuestList gl ON rq.Email = gl.Email
                    WHERE rq.Status IN ('Pending', 'Waitlist')
                    ORDER BY CheckInDate ASC";

                SqlDataAdapter da = new SqlDataAdapter(combinedQuery, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvWaitlist.DataSource = dt;
                gvWaitlist.DataBind();
            }
        }

        protected void btnConfirmAction_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hfSelectedID.Value);
            string action = hfActionType.Value;
            string paymentType = hfPaymentType.Value;

            string status = (action == "Approve") ? "Approved" : "Rejected";

            if (ProcessReservationUpdate(id, status, paymentType))
            {
                ShowToast("Success", $"Reservation has been {status.ToLower()}ed successfully.", "success");
                LoadWaitlist();
            }
        }

        private bool ProcessReservationUpdate(int resId, string status, string paymentType = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // Check if it exists in the Reservation table (Manual)
                    SqlCommand cmdCheck = new SqlCommand("SELECT UnitId FROM [dbo].[Reservation] WHERE ReservationID = @id", conn, trans);
                    cmdCheck.Parameters.AddWithValue("@id", resId);
                    object unitResult = cmdCheck.ExecuteScalar();

                    if (unitResult != null)
                    {
                        // 1. UPDATE MANUAL RESERVATION
                        SqlCommand cmdRes = new SqlCommand("UPDATE [dbo].[Reservation] SET Status = @status, PaymentStatus = @pay WHERE ReservationID = @id", conn, trans);
                        cmdRes.Parameters.AddWithValue("@status", status);
                        cmdRes.Parameters.AddWithValue("@pay", (object)paymentType ?? DBNull.Value);
                        cmdRes.Parameters.AddWithValue("@id", resId);
                        cmdRes.ExecuteNonQuery();

                        // Handle Room Unit Availability if rejected
                        if (status == "Rejected" && unitResult != DBNull.Value)
                        {
                            SqlCommand cmdUnit = new SqlCommand("UPDATE RoomUnits SET Status = 'Available' WHERE UnitID = @uid", conn, trans);
                            cmdUnit.Parameters.AddWithValue("@uid", unitResult);
                            cmdUnit.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // 2. UPDATE ONLINE REQUEST
                        SqlCommand cmdReq = new SqlCommand("UPDATE RoomRequests SET Status = @status WHERE RequestID = @id", conn, trans);
                        cmdReq.Parameters.AddWithValue("@status", status);
                        cmdReq.Parameters.AddWithValue("@id", resId);
                        cmdReq.ExecuteNonQuery();

                        if (!string.IsNullOrEmpty(paymentType) && status == "Approved")
                        {
                            // Append payment info to message for online requests
                            SqlCommand cmdGetMsg = new SqlCommand("SELECT Message FROM RoomRequests WHERE RequestID = @id", conn, trans);
                            cmdGetMsg.Parameters.AddWithValue("@id", resId);
                            string currentMessage = cmdGetMsg.ExecuteScalar()?.ToString() ?? "";
                            string newMessage = currentMessage + "|PaymentType:" + paymentType;

                            SqlCommand cmdPayment = new SqlCommand("UPDATE RoomRequests SET Message = @newMessage WHERE RequestID = @id", conn, trans);
                            cmdPayment.Parameters.AddWithValue("@newMessage", newMessage);
                            cmdPayment.Parameters.AddWithValue("@id", resId);
                            cmdPayment.ExecuteNonQuery();
                        }
                    }

                    trans.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ShowToast("Error", ex.Message, "error");
                    return false;
                }
            }
        }

        private void ShowToast(string title, string message, string type)
        {
            string cleanMsg = message.Replace("'", "\\'");
            string script = $"Swal.fire({{ title: '{title}', text: '{cleanMsg}', icon: '{type}', confirmButtonColor: '#198754' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }

        protected void gvWaitlist_RowCommand(object sender, GridViewCommandEventArgs e) { }
        protected void gvWaitlist_RowDataBound(object sender, GridViewRowEventArgs e) { }
    }
}