using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace PSAUStay.Admin
{
    public partial class GuestDetails : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check for success message from query string
                if (Request.QueryString["success"] == "true")
                {
                    ShowToast("Success", "Guest details have been successfully saved!", "success");
                }

                LoadGuests();
            }
        }

        private void LoadGuests()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    // Enhanced query with GuestList joins to get FullName, Email, and Contact properly separated
                    string query = @"
                        SELECT 
                            MIN(R.ReservationID) as BookingID,
                            ISNULL(GL.FullName, 'Guest') as FullName,
                            ISNULL(GL.Email, R.Contact) as Email,
                            ISNULL(GL.Contact, R.Contact) as Contact,
                            MIN(R.CheckInDate) as FirstCheckIn,
                            MAX(R.CheckOutDate) as LastCheckOut,
                            COUNT(*) as BookingCount,
                            'Multiple Rooms' as RoomName,
                            SUM(CASE 
                                WHEN R.TotalPrice > 0 THEN R.TotalPrice
                                ELSE ISNULL(DATEDIFF(day, R.CheckInDate, R.CheckOutDate) * RM.Price, 0)
                            END) as TotalPrice,
                            R.Status,
                            DATEDIFF(day, MIN(R.CheckInDate), MAX(R.CheckOutDate)) as TotalDays
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status IN ('Approved', 'CheckedOut')
                        GROUP BY R.Contact, R.Status, ISNULL(GL.FullName, 'Guest'), ISNULL(GL.Email, R.Contact), ISNULL(GL.Contact, R.Contact)
                        ORDER BY MIN(R.CheckInDate) DESC";

                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    System.Diagnostics.Debug.WriteLine($"GuestDetails query returned {dt.Rows.Count} unique guests");

                    gvGuestList.DataSource = dt;
                    gvGuestList.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error in LoadGuests: " + ex.Message);
                    gvGuestList.DataSource = new DataTable();
                    gvGuestList.DataBind();
                }
            }
        }

        protected void gvGuestList_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvGuestList.PageIndex = e.NewPageIndex;
            LoadGuests();
        }

        protected void gvGuestList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string email = e.CommandArgument.ToString();
                
                System.Diagnostics.Debug.WriteLine($"RowCommand triggered for email: {email}");
                
                // Register JavaScript to show modal with placeholder review data
                string script = $@"showGuestDetails(
                    'placeholder', 
                    '{HttpUtility.JavaScriptStringEncode(email)}', 
                    'Multiple Rooms', 
                    'Various', 
                    '₱0.00', 
                    'N/A', 
                    'N/A', 
                    '0', 
                    'Approved'
                );";

                System.Diagnostics.Debug.WriteLine($"Script to execute: {script}");
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowDetailsModal", script, true);
            }
        }

        protected void btnConfirmAction_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfSelectedID.Value) && !string.IsNullOrEmpty(hfActionType.Value))
            {
                int bookingId = Convert.ToInt32(hfSelectedID.Value);
                string action = hfActionType.Value;

                if (action == "Review")
                {
                    // Handle review action - placeholder for now
                    ShowToast("Review", "Review functionality coming soon!", "info");
                }

                hfSelectedID.Value = "";
                hfActionType.Value = "";
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetAllReviewsForDebugging()
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
            var reviews = new List<object>();

            System.Diagnostics.Debug.WriteLine("GetAllReviewsForDebugging called - checking all reviews in database");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    string query = @"
                        SELECT 
                            ReviewID,
                            BookingRef,
                            GuestName,
                            GuestEmail,
                            RoomName,
                            CheckInDate,
                            CheckOutDate,
                            OverallRating,
                            CleanlinessRating,
                            ComfortRating,
                            StaffRating,
                            LocationRating,
                            Comments,
                            WouldRecommend,
                            ReviewDate,
                            1 as IsApproved -- Auto-approve all reviews
                        FROM RoomReviews 
                        ORDER BY ReviewDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    int reviewCount = 0;
                    while (reader.Read())
                    {
                        reviewCount++;
                        reviews.Add(new
                        {
                            ReviewID = reader["ReviewID"],
                            BookingRef = reader["BookingRef"],
                            GuestName = reader["GuestName"],
                            GuestEmail = reader["GuestEmail"],
                            RoomName = reader["RoomName"],
                            CheckInDate = reader["CheckInDate"] != DBNull.Value ? Convert.ToDateTime(reader["CheckInDate"]).ToString("MMM dd, yyyy") : "",
                            CheckOutDate = reader["CheckOutDate"] != DBNull.Value ? Convert.ToDateTime(reader["CheckOutDate"]).ToString("MMM dd, yyyy") : "",
                            OverallRating = reader["OverallRating"],
                            CleanlinessRating = reader["CleanlinessRating"],
                            ComfortRating = reader["ComfortRating"],
                            StaffRating = reader["StaffRating"],
                            LocationRating = reader["LocationRating"],
                            Comments = reader["Comments"]?.ToString() ?? "",
                            WouldRecommend = reader["WouldRecommend"],
                            ReviewDate = reader["ReviewDate"] != DBNull.Value ? Convert.ToDateTime(reader["ReviewDate"]).ToString("MMM dd, yyyy") : "",
                            IsApproved = reader["IsApproved"]
                        });
                    }

                    System.Diagnostics.Debug.WriteLine($"Total reviews found in database: {reviewCount}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error in GetAllReviewsForDebugging: " + ex.Message);
                    System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
                }
            }

            string jsonResult = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(reviews);
            System.Diagnostics.Debug.WriteLine("All reviews JSON: " + jsonResult);
            return jsonResult;
        }


        [System.Web.Services.WebMethod]
        public static string GetGuestReviews(string guestEmail)
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
            var reviews = new List<object>();

            // Debug: Log incoming email
            System.Diagnostics.Debug.WriteLine("GetGuestReviews called for email: " + guestEmail);
            System.Diagnostics.Debug.WriteLine("GuestEmail parameter is null or empty: " + string.IsNullOrEmpty(guestEmail));

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    string query = @"
                        SELECT 
                            ReviewID,
                            BookingRef,
                            GuestName,
                            GuestEmail,
                            RoomName,
                            CheckInDate,
                            CheckOutDate,
                            OverallRating,
                            CleanlinessRating,
                            ComfortRating,
                            StaffRating,
                            LocationRating,
                            Comments,
                            WouldRecommend,
                            ReviewDate,
                            1 as IsApproved -- Auto-approve all reviews
                        FROM RoomReviews 
                        WHERE LOWER(LTRIM(RTRIM(GuestEmail))) = LOWER(LTRIM(RTRIM(@GuestEmail))) 
                        ORDER BY ReviewDate DESC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@GuestEmail", guestEmail);
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    int reviewCount = 0;
                    while (reader.Read())
                    {
                        reviewCount++;
                        reviews.Add(new
                        {
                            ReviewID = reader["ReviewID"],
                            BookingRef = reader["BookingRef"],
                            GuestName = reader["GuestName"],
                            GuestEmail = reader["GuestEmail"],
                            RoomName = reader["RoomName"],
                            CheckInDate = reader["CheckInDate"] != DBNull.Value ? Convert.ToDateTime(reader["CheckInDate"]).ToString("MMM dd, yyyy") : "",
                            CheckOutDate = reader["CheckOutDate"] != DBNull.Value ? Convert.ToDateTime(reader["CheckOutDate"]).ToString("MMM dd, yyyy") : "",
                            OverallRating = reader["OverallRating"],
                            CleanlinessRating = reader["CleanlinessRating"],
                            ComfortRating = reader["ComfortRating"],
                            StaffRating = reader["StaffRating"],
                            LocationRating = reader["LocationRating"],
                            Comments = reader["Comments"]?.ToString() ?? "",
                            WouldRecommend = reader["WouldRecommend"],
                            ReviewDate = reader["ReviewDate"] != DBNull.Value ? Convert.ToDateTime(reader["ReviewDate"]).ToString("MMM dd, yyyy") : "",
                            IsApproved = reader["IsApproved"]
                        });
                    }

                    // Debug: Log results
                    System.Diagnostics.Debug.WriteLine($"Found {reviewCount} reviews for {guestEmail}");
                    
                    // Debug: Log each review object
                    foreach (var review in reviews)
                    {
                        System.Diagnostics.Debug.WriteLine("Review object: " + review.ToString());
                    }
                    
                    // If no reviews found with exact match, try partial match and also check all emails
                    if (reviewCount == 0)
                    {
                        System.Diagnostics.Debug.WriteLine("No exact matches found, checking all emails in database and trying partial match...");
                        
                        // First, let's get all distinct emails to debug
                        string allEmailsDebugQuery = "SELECT DISTINCT GuestEmail FROM RoomReviews ORDER BY GuestEmail";
                        SqlCommand allEmailsDebugCmd = new SqlCommand(allEmailsDebugQuery, conn);
                        SqlDataReader allEmailsDebugReader = allEmailsDebugCmd.ExecuteReader();
                        
                        System.Diagnostics.Debug.WriteLine("All emails in RoomReviews table:");
                        while (allEmailsDebugReader.Read())
                        {
                            string dbEmail = allEmailsDebugReader["GuestEmail"].ToString();
                            System.Diagnostics.Debug.WriteLine($"  - '{dbEmail}'");
                        }
                        allEmailsDebugReader.Close();
                        
                        // Try partial match
                        string fallbackQuery = @"
                            SELECT 
                                ReviewID,
                                BookingRef,
                                GuestName,
                                GuestEmail,
                                RoomName,
                                CheckInDate,
                                CheckOutDate,
                                OverallRating,
                                CleanlinessRating,
                                ComfortRating,
                                StaffRating,
                                LocationRating,
                                Comments,
                                WouldRecommend,
                                ReviewDate,
                                1 as IsApproved -- Auto-approve all reviews
                            FROM RoomReviews 
                            WHERE GuestEmail LIKE '%' + @GuestEmail + '%' 
                            ORDER BY ReviewDate DESC";
                        
                        SqlCommand fallbackCmd = new SqlCommand(fallbackQuery, conn);
                        fallbackCmd.Parameters.AddWithValue("@GuestEmail", guestEmail);
                        
                        SqlDataReader fallbackReader = fallbackCmd.ExecuteReader();
                        int fallbackCount = 0;
                        while (fallbackReader.Read())
                        {
                            fallbackCount++;
                            reviews.Add(new
                            {
                                ReviewID = fallbackReader["ReviewID"],
                                BookingRef = fallbackReader["BookingRef"],
                                GuestName = fallbackReader["GuestName"],
                                GuestEmail = fallbackReader["GuestEmail"],
                                RoomName = fallbackReader["RoomName"],
                                CheckInDate = fallbackReader["CheckInDate"] != DBNull.Value ? Convert.ToDateTime(fallbackReader["CheckInDate"]).ToString("MMM dd, yyyy") : "",
                                CheckOutDate = fallbackReader["CheckOutDate"] != DBNull.Value ? Convert.ToDateTime(fallbackReader["CheckOutDate"]).ToString("MMM dd, yyyy") : "",
                                OverallRating = fallbackReader["OverallRating"],
                                CleanlinessRating = fallbackReader["CleanlinessRating"],
                                ComfortRating = fallbackReader["ComfortRating"],
                                StaffRating = fallbackReader["StaffRating"],
                                LocationRating = fallbackReader["LocationRating"],
                                Comments = fallbackReader["Comments"]?.ToString() ?? "",
                                WouldRecommend = fallbackReader["WouldRecommend"],
                                ReviewDate = fallbackReader["ReviewDate"] != DBNull.Value ? Convert.ToDateTime(fallbackReader["ReviewDate"]).ToString("MMM dd, yyyy") : "",
                                IsApproved = fallbackReader["IsApproved"]
                            });
                        }
                        fallbackReader.Close();
                        
                        System.Diagnostics.Debug.WriteLine($"Found {fallbackCount} reviews with partial match for '{guestEmail}'");
                        
                        // If still no matches, try matching by first few characters
                        if (fallbackCount == 0 && guestEmail.Length >= 2)
                        {
                            System.Diagnostics.Debug.WriteLine("Trying prefix match...");
                            string prefixQuery = @"
                                SELECT 
                                    ReviewID,
                                    BookingRef,
                                    GuestName,
                                    GuestEmail,
                                    RoomName,
                                    CheckInDate,
                                    CheckOutDate,
                                    OverallRating,
                                    CleanlinessRating,
                                    ComfortRating,
                                    StaffRating,
                                    LocationRating,
                                    Comments,
                                    WouldRecommend,
                                    ReviewDate,
                                    1 as IsApproved -- Auto-approve all reviews
                                FROM RoomReviews 
                                WHERE LEFT(GuestEmail, LEN(@GuestEmail)) = @GuestEmail
                                ORDER BY ReviewDate DESC";
                            
                            SqlCommand prefixCmd = new SqlCommand(prefixQuery, conn);
                            prefixCmd.Parameters.AddWithValue("@GuestEmail", guestEmail);
                            
                            SqlDataReader prefixReader = prefixCmd.ExecuteReader();
                            int prefixCount = 0;
                            while (prefixReader.Read())
                            {
                                prefixCount++;
                                reviews.Add(new
                                {
                                    ReviewID = prefixReader["ReviewID"],
                                    BookingRef = prefixReader["BookingRef"],
                                    GuestName = prefixReader["GuestName"],
                                    GuestEmail = prefixReader["GuestEmail"],
                                    RoomName = prefixReader["RoomName"],
                                    CheckInDate = prefixReader["CheckInDate"] != DBNull.Value ? Convert.ToDateTime(prefixReader["CheckInDate"]).ToString("MMM dd, yyyy") : "",
                                    CheckOutDate = prefixReader["CheckOutDate"] != DBNull.Value ? Convert.ToDateTime(prefixReader["CheckOutDate"]).ToString("MMM dd, yyyy") : "",
                                    OverallRating = prefixReader["OverallRating"],
                                    CleanlinessRating = prefixReader["CleanlinessRating"],
                                    ComfortRating = prefixReader["ComfortRating"],
                                    StaffRating = prefixReader["StaffRating"],
                                    LocationRating = prefixReader["LocationRating"],
                                    Comments = prefixReader["Comments"]?.ToString() ?? "",
                                    WouldRecommend = prefixReader["WouldRecommend"],
                                    ReviewDate = prefixReader["ReviewDate"] != DBNull.Value ? Convert.ToDateTime(prefixReader["ReviewDate"]).ToString("MMM dd, yyyy") : "",
                                    IsApproved = prefixReader["IsApproved"]
                                });
                            }
                            prefixReader.Close();
                            
                            System.Diagnostics.Debug.WriteLine($"Found {prefixCount} reviews with prefix match for '{guestEmail}'");
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error in GetGuestReviews: " + ex.Message);
                    System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
                }
            }

            string jsonResult = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(reviews);
            System.Diagnostics.Debug.WriteLine("Returning JSON: " + jsonResult);
            System.Diagnostics.Debug.WriteLine("JSON length: " + jsonResult.Length);
            return jsonResult;
        }

        private void ShowToast(string title, string message, string type)
        {
            // Clean message for JS
            string cleanMsg = message.Replace("'", "\\'");
            string script = $"Swal.fire({{ title: '{title}', text: '{cleanMsg}', icon: '{type}', confirmButtonColor: '#198754' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }
    }
}
