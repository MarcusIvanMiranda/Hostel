using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Net;
using System.Net.Mail;
using System.Text;

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

                    // Get booking details for email
                    string guestEmail = "";
                    string guestName = "";
                    string roomName = "";
                    DateTime checkInDate = DateTime.MinValue;
                    DateTime checkOutDate = DateTime.MinValue;
                    string bookingRef = source + id;

                    // Get booking information
                    string getBookingInfo = $@"
                        SELECT {(source == "Online" ? "RQ.Email, RQ.Name" : "GL.Email, ISNULL(GL.FullName, 'Guest') as FullName")}, 
                               RM.RoomName, RQ.CheckInDate, RQ.CheckOutDate
                        FROM {tbl} RQ 
                        JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        {(source == "Online" ? "LEFT JOIN GuestList GL ON RQ.Email = GL.Email" : "LEFT JOIN GuestList GL ON RQ.UserID = GL.GuestID")}
                        WHERE {col} = @ID";
                    
                    SqlCommand cmdInfo = new SqlCommand(getBookingInfo, con, trans);
                    cmdInfo.Parameters.AddWithValue("@ID", id);
                    using (SqlDataReader reader = cmdInfo.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            guestEmail = reader["Email"].ToString();
                            guestName = reader[source == "Online" ? "Name" : "FullName"].ToString();
                            roomName = reader["RoomName"].ToString();
                            checkInDate = Convert.ToDateTime(reader["CheckInDate"]);
                            checkOutDate = Convert.ToDateTime(reader["CheckOutDate"]);
                        }
                    }

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

                    // Send review email after successful commit
                    SendReviewEmail(guestEmail, guestName, roomName, checkInDate, checkOutDate, bookingRef);

                    ScriptManager.RegisterStartupScript(this, GetType(), "success", "Swal.fire('Checkout Complete!', 'Thank you for staying with us! A review link has been sent to the customer\'s email.', 'success');", true);
                }
                catch (Exception ex)
                {
                    if (trans.Connection != null) trans.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"Swal.fire('Error', 'Checkout failed: {ex.Message}', 'error');", true);
                }
            }
        }

        private void SendReviewEmail(string email, string guestName, string roomName, DateTime checkInDate, DateTime checkOutDate, string bookingRef)
        {
            try
            {
                string reviewUrl = $"{Request.Url.Scheme}://{Request.Url.Authority}{ResolveUrl("~/CustomerReview.aspx")}?ref={bookingRef}&email={Server.UrlEncode(email)}&name={Server.UrlEncode(guestName)}&room={Server.UrlEncode(roomName)}&checkin={checkInDate:yyyy-MM-dd}&checkout={checkOutDate:yyyy-MM-dd}";
                
                string subject = "Thank You for Staying at PSAU Hostel - Share Your Experience!";
                string body = $@"
<html>
<body style='font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;'>
    <div style='max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);'>
        <div style='text-align: center; margin-bottom: 30px;'>
            <h1 style='color: #198754; margin: 0;'>PSAU Hostel</h1>
            <p style='color: #666; margin: 5px 0;'>Thank You for Your Stay!</p>
        </div>
        
        <div style='background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 25px;'>
            <h3 style='color: #333; margin-top: 0;'>Hello {guestName},</h3>
            <p style='color: #555; line-height: 1.6;'>
                Thank you for choosing PSAU Hostel for your recent stay! We hope you had a wonderful experience.
                Your feedback is very important to us as it helps us improve our services.
            </p>
        </div>
        
        <div style='background-color: #e8f5e8; padding: 15px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid #198754;'>
            <h4 style='color: #333; margin-top: 0;'>Stay Details:</h4>
            <ul style='color: #555; line-height: 1.6;'>
                <li><strong>Room:</strong> {roomName}</li>
                <li><strong>Check-in:</strong> {checkInDate:MMM dd, yyyy}</li>
                <li><strong>Check-out:</strong> {checkOutDate:MMM dd, yyyy}</li>
                <li><strong>Booking Reference:</strong> {bookingRef}</li>
            </ul>
        </div>
        
        <div style='text-align: center; margin: 30px 0;'>
            <a href='{reviewUrl}' style='background-color: #198754; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;'>
                Share Your Experience
            </a>
        </div>
        
        <div style='text-align: center; color: #888; font-size: 12px; margin-top: 30px;'>
            <p>This review link will remain active for 30 days.</p>
            <p>If you didn't stay at PSAU Hostel, please disregard this email.</p>
        </div>
    </div>
</body>
</html>";

                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(ConfigurationManager.AppSettings["SmtpUser"] ?? "noreply@psauhostel.edu.ph");
                    mail.To.Add(email);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    using (SmtpClient smtp = new SmtpClient())
                    {
                        smtp.Host = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                        smtp.Port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
                        smtp.EnableSsl = true;
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new NetworkCredential(
                            ConfigurationManager.AppSettings["SmtpUser"] ?? "your-email@gmail.com",
                            ConfigurationManager.AppSettings["SmtpPass"] ?? "your-app-password"
                        );
                        smtp.Send(mail);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log email error but don't fail the checkout process
                System.Diagnostics.Debug.WriteLine($"Email sending failed: {ex.Message}");
            }
        }
    }
}