using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PSAUStay
{
    public partial class CustomerReview : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get parameters from query string
                string bookingRef = Request.QueryString["ref"];
                string email = Request.QueryString["email"];
                string name = Request.QueryString["name"];
                string room = Request.QueryString["room"];
                string checkin = Request.QueryString["checkin"];
                string checkout = Request.QueryString["checkout"];

                if (string.IsNullOrEmpty(bookingRef) || string.IsNullOrEmpty(email))
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                // Populate hidden fields
                hfBookingRef.Value = bookingRef;
                hfGuestEmail.Value = Server.UrlDecode(email);
                hfGuestName.Value = Server.UrlDecode(name ?? "");
                hfRoomName.Value = Server.UrlDecode(room ?? "");

                // Populate form fields
                txtGuestName.Text = Server.UrlDecode(name ?? "");
                txtGuestEmail.Text = Server.UrlDecode(email);

                // Display stay details
                roomName.InnerHtml = Server.UrlDecode(room ?? "N/A");
                DateTime checkInDateValue = DateTime.MinValue;
                DateTime checkOutDateValue = DateTime.MinValue;
                if (DateTime.TryParse(checkin, out checkInDateValue))
                {
                    checkInDate.InnerHtml = checkInDateValue.ToString("MMM dd, yyyy");
                }
                if (DateTime.TryParse(checkout, out checkOutDateValue))
                {
                    checkOutDate.InnerHtml = checkOutDateValue.ToString("MMM dd, yyyy");
                }

                // Check if review already exists
                if (ReviewExists(bookingRef))
                {
                    ShowReviewAlreadySubmitted();
                }
            }
        }

        private bool ReviewExists(string bookingRef)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM RoomReviews WHERE BookingRef = @BookingRef";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@BookingRef", bookingRef);
                con.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }

        private void ShowReviewAlreadySubmitted()
        {
            // Disable form
            txtGuestName.Enabled = false;
            txtGuestEmail.Enabled = false;
            txtComments.Enabled = false;
            btnSubmitReview.Enabled = false;
            btnSubmitReview.Text = "Review Already Submitted";
            btnSubmitReview.CssClass = "btn btn-secondary btn-lg px-5 py-3 fw-bold";

            // Show message
            ClientScript.RegisterStartupScript(GetType(), "reviewExists",
                "Swal.fire({icon: 'info', title: 'Review Already Submitted', text: 'Thank you! You have already submitted a review for this stay.', confirmButtonColor: '#198754'});", true);
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate ratings
                int overallRating = Convert.ToInt32(hfOverallRating.Value);
                int cleanlinessRating = Convert.ToInt32(hfCleanlinessRating.Value);
                int comfortRating = Convert.ToInt32(hfComfortRating.Value);
                int staffRating = Convert.ToInt32(hfStaffRating.Value);
                int locationRating = Convert.ToInt32(hfLocationRating.Value);

                if (overallRating == 0 || cleanlinessRating == 0 || comfortRating == 0 || staffRating == 0 || locationRating == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "validationError",
                        "Swal.fire({icon: 'warning', title: 'Incomplete Rating', text: 'Please provide ratings for all categories before submitting.', confirmButtonColor: '#198754'});", true);
                    return;
                }

                // Check if review already exists
                if (ReviewExists(hfBookingRef.Value))
                {
                    ShowReviewAlreadySubmitted();
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                    INSERT INTO RoomReviews (
                        BookingRef, GuestName, GuestEmail, RoomName, CheckInDate, CheckOutDate,
                        OverallRating, CleanlinessRating, ComfortRating, StaffRating, LocationRating,
                        Comments, WouldRecommend, ReviewDate, IsApproved
                    ) VALUES (
                        @BookingRef, @GuestName, @GuestEmail, @RoomName, @CheckInDate, @CheckOutDate,
                        @OverallRating, @CleanlinessRating, @ComfortRating, @StaffRating, @LocationRating,
                        @Comments, @WouldRecommend, GETDATE(), 0
                    )";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@BookingRef", hfBookingRef.Value);
                    cmd.Parameters.AddWithValue("@GuestName", txtGuestName.Text.Trim());
                    cmd.Parameters.AddWithValue("@GuestEmail", txtGuestEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@RoomName", hfRoomName.Value);

                    // Parse dates from query string
                    DateTime checkInDate = DateTime.MinValue;
                    DateTime checkOutDate = DateTime.MinValue;
                    DateTime.TryParse(Request.QueryString["checkin"], out checkInDate);
                    DateTime.TryParse(Request.QueryString["checkout"], out checkOutDate);

                    cmd.Parameters.AddWithValue("@CheckInDate", checkInDate == DateTime.MinValue ? (object)DBNull.Value : checkInDate);
                    cmd.Parameters.AddWithValue("@CheckOutDate", checkOutDate == DateTime.MinValue ? (object)DBNull.Value : checkOutDate);

                    cmd.Parameters.AddWithValue("@OverallRating", overallRating);
                    cmd.Parameters.AddWithValue("@CleanlinessRating", cleanlinessRating);
                    cmd.Parameters.AddWithValue("@ComfortRating", comfortRating);
                    cmd.Parameters.AddWithValue("@StaffRating", staffRating);
                    cmd.Parameters.AddWithValue("@LocationRating", locationRating);
                    cmd.Parameters.AddWithValue("@Comments", string.IsNullOrWhiteSpace(txtComments.Text) ? (object)DBNull.Value : txtComments.Text.Trim());
                    cmd.Parameters.AddWithValue("@WouldRecommend", rbRecommendYes.Checked);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Show success message
                    string successScript = "Swal.fire({" +
                        "icon: 'success'," +
                        "title: 'Thank You!'," +
                        "text: 'Your review has been submitted successfully. It will be published after approval.'," +
                        "confirmButtonColor: '#198754'," +
                        "allowOutsideClick: false" +
                        "}).then((result) => {" +
                        "if (result.isConfirmed) {" +
                        "window.location.href = 'Default.aspx';" +
                        "}" +
                        "});";

                    ScriptManager.RegisterStartupScript(this, GetType(), "success", successScript, true);

                    // Disable form after submission
                    txtGuestName.Enabled = false;
                    txtGuestEmail.Enabled = false;
                    txtComments.Enabled = false;
                    btnSubmitReview.Enabled = false;
                    btnSubmitReview.Text = "Review Submitted";
                    btnSubmitReview.CssClass = "btn btn-success btn-lg px-5 py-3 fw-bold disabled";
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                    "Swal.fire({icon: 'error', title: 'Submission Error', text: 'An error occurred while submitting your review. Please try again.', confirmButtonColor: '#198754'});", true);
            }
        }
    }
}