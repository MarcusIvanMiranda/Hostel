using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Web;
using PSAUStay.Helpers;

namespace PSAUStay
{
    public partial class BookingSuccess : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
        string onlineAccountInfo = "GCash/Paymaya: 09123456789 (PSAU Stay)";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string bookingRef = Request.QueryString["ref"];
                string email = Request.QueryString["email"];
                string amountStr = Request.QueryString["amount"];
                string paymentOption = Request.QueryString["payment"] ?? "downpayment";
                string roomName = Request.QueryString["room"] ?? "Standard Room";

                string fullName = Session["FullName"]?.ToString() ?? "Guest";
                litGuestName.Text = fullName;

                // Get contact number from session
                string contactNumber = Session["Contact"]?.ToString() ?? "";
                litContact.Text = contactNumber;

                string roomDetails = roomName;
                string checkIn = Session["CheckIn"]?.ToString();
                string checkOut = Session["CheckOut"]?.ToString();

                DateTime dtCheckIn, dtCheckOut;
                string formattedCheckIn = checkIn;
                string formattedCheckOut = checkOut;

                if (DateTime.TryParse(checkIn, out dtCheckIn))
                    formattedCheckIn = dtCheckIn.ToString("MMMM dd yyyy");

                if (DateTime.TryParse(checkOut, out dtCheckOut))
                    formattedCheckOut = dtCheckOut.ToString("MMMM dd yyyy");

                litDates.Text = $"{formattedCheckIn} to {formattedCheckOut}";
                litRefNumber.Text = bookingRef;

                if (!string.IsNullOrEmpty(bookingRef) && !string.IsNullOrEmpty(email))
                {
                    decimal totalPrice = 0;
                    decimal.TryParse(amountStr, out totalPrice);
                    decimal requiredPayment = (paymentOption == "full") ? totalPrice : (totalPrice * 0.50m);
                    string paymentType = (paymentOption == "full") ? "Full Payment" : "Downpayment (50%)";

                    // Populate the price literals
                    litTotalPrice.Text = totalPrice.ToString("N2");
                    litDownpayment.Text = requiredPayment.ToString("N2");
                    litPaymentInfo.Text = onlineAccountInfo;

                    ProcessPaymentRequest(bookingRef, email, requiredPayment, paymentType, formattedCheckIn, formattedCheckOut, roomDetails);
                }
            }
        }

        private void ProcessPaymentRequest(string bookingRef, string email, decimal requiredPayment, string paymentType, string checkIn, string checkOut, string roomDetails)
        {
            string token = Guid.NewGuid().ToString("N");
            DateTime expiry = DateTime.Now.AddHours(24);
            string pinCode = new Random().Next(1000, 9999).ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"INSERT INTO RoomPaymentUploads (BookingRef, Email, Token, ExpirationDate)
                               VALUES (@BookingRef, @Email, @Token, @Expiry)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@BookingRef", bookingRef);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Token", token);
                    cmd.Parameters.AddWithValue("@Expiry", expiry);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath.TrimEnd('/');

            string imgHostel = $"{baseUrl}/Content/Images/PSAULogo.png";
            string imgLocation = $"{baseUrl}/Content/Images/map-la.png";

            try
            {
                if (!System.IO.File.Exists(Server.MapPath("~/Content/Images/PSAULogo.png")))
                {
                    imgHostel = "https://via.placeholder.com/300x200/198754/ffffff?text=PSAU+Hostel";
                }
                if (!System.IO.File.Exists(Server.MapPath("~/Content/Images/map-la.png")))
                {
                    imgLocation = "https://via.placeholder.com/300x200/6c757d/ffffff?text=Location";
                }
            }
            catch
            {
                imgHostel = "https://via.placeholder.com/300x200/198754/ffffff?text=PSAU+Hostel";
                imgLocation = "https://via.placeholder.com/300x200/6c757d/ffffff?text=Location";
            }

            string link = $"{baseUrl}/UploadPayment.aspx?token={token}";
            string safeGuestName = HttpUtility.HtmlEncode(litGuestName.Text);

            string body = $@"
                <div style='background-color: #f4f4f4; padding: 40px 10px; font-family: sans-serif;'>
                    <div style='max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1);'>
                        <div style='background-color: #198754; padding: 30px; color: #ffffff;'>
                            <table width='100%' cellpadding='0' cellspacing='0' border='0'>
                                <tr>
                                    <td>
                                        <h2 style='margin: 0; font-size: 24px;'>PSAU Hostel</h2>
                                        <p style='margin: 5px 0 0 0; opacity: 0.9; font-size: 14px;'>Reservation Received</p>
                                    </td>
                                    <td style='text-align: right;'>
                                        <div style='font-size: 11px; opacity: 0.8;'>CONFIRMATION</div>
                                        <div style='font-size: 18px; font-weight: bold;'>#{bookingRef}</div>
                                        <div style='font-size: 11px; opacity: 0.8; margin-top: 5px;'>PIN CODE</div>
                                        <div style='font-size: 18px; font-weight: bold;'>{pinCode}</div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style='padding: 30px;'>
                            <h3 style='margin: 0;'>Hi {safeGuestName},</h3>
                            <p style='color: #666;'>Thank you for booking with us. Please review your stay details below.</p>
                        </div>
                        <div style='padding: 0 30px 20px 30px;'>
                            <table width='100%' cellpadding='0' cellspacing='0' border='0'>
                                <tr>
                                    <td width='49%'>
                                        <img src='{imgHostel}' alt='Hostel' style='width: 100%; border-radius: 8px; display: block; border: 1px solid #eee;' />
                                    </td>
                                    <td width='2%'>&nbsp;</td>
                                    <td width='49%'>
                                        <img src='{imgLocation}' alt='Location' style='width: 100%; border-radius: 8px; display: block; border: 1px solid #eee;' />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style='padding: 0 30px 15px 30px;'>
                            <div style='background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;'>
                                <p style='margin: 0; font-size: 12px; color: #888; text-transform: uppercase; font-weight: bold;'>Selected Room</p>
                                <p style='margin: 8px 0 0 0; font-size: 18px; font-weight: bold; color: #334155;'>{roomDetails}</p>
                            </div>
                        </div>
                        <div style='padding: 0 30px 20px 30px;'>
                            <div style='background: #f9f9f9; padding: 25px; border-radius: 12px; border: 1px solid #eee;'>
                                <table width='100%' cellpadding='0' cellspacing='0' border='0'>
                                    <tr>
                                        <td width='48%'>
                                            <p style='margin: 0; font-size: 11px; color: #888; text-transform: uppercase; font-weight: bold;'>Check-in</p>
                                            <p style='margin: 8px 0 0 0; font-size: 15px; font-weight: bold; color: #198754;'>{checkIn}</p>
                                        </td>
                                        <td width='4%' style='border-left: 1px solid #ddd;'>&nbsp;</td>
                                        <td width='48%' style='padding-left: 15px;'>
                                            <p style='margin: 0; font-size: 11px; color: #888; text-transform: uppercase; font-weight: bold;'>Check-out</p>
                                            <p style='margin: 8px 0 0 0; font-size: 15px; font-weight: bold; color: #198754;'>{checkOut}</p>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div style='padding: 0 30px 30px 30px;'>
                            <div style='border: 2px dashed #e9ecef; border-radius: 12px; padding: 25px;'>
                                <p style='margin: 0; color: #6c757d;'>{paymentType} Amount:</p>
                                <p style='margin: 10px 0; font-size: 24px; font-weight: bold; color: #198754;'>₱{requiredPayment:N2}</p>
                                <p style='margin: 0; font-size: 13px; color: #666;'>Payment Method: {onlineAccountInfo}</p>
                            </div>
                        </div>
                        <div style='padding: 0 30px 40px 30px; text-align: center;'>
                            <a href='{link}' style='display: inline-block; background-color: #198754; color: #ffffff; padding: 18px 35px; border-radius: 8px; text-decoration: none; font-weight: bold;'>Upload Proof of Payment</a>
                        </div>
                        <div style='background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #6c757d;'>
                            <strong>PSAU Stay Team</strong><br /> Magalang, Pampanga
                        </div>
                    </div>
                </div>";

            try { EmailHelper.Send(email, $"Payment Required: Booking #{bookingRef}", body, true); }
            catch (Exception ex) { /* Log ex here */ }
        }
    }
}
