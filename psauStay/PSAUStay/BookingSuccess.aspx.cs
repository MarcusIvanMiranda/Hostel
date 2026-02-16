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

                litGuestName.Text = Session["FullName"]?.ToString() ?? "Guest";
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

            // Fixed syntax: Removed backticks and backslash
            try
            {
                if (!System.IO.File.Exists(Server.MapPath("~/Content/Images/PSAULogo.png")))
                {
                    imgHostel = "https://via.placeholder.com/300x200/198754/ffffff?text=PSAU+Hostel";
                }
                if (!System.IO.File.Exists(Server.MapPath("~/Images/location.jpg")))
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

            // ... rest of your body string and email sending logic ...
        }
    }
}