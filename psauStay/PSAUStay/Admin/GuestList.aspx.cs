using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;

namespace PSAUStay.Admin
{
    public partial class GuestList : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGuests();
            }
        }

        private void LoadGuests()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    // Enhanced query with GuestList joins to get FullName and Contact
                    string query = @"
                        SELECT 
                            MIN(R.ReservationID) as BookingID,
                            ISNULL(GL.FullName, 'Guest') as FullName,
                            ISNULL(GL.Email, R.Contact) as Email,
                            ISNULL(GL.Contact, R.Contact) as Contact,
                            MIN(R.CheckInDate) as FirstCheckIn,
                            MAX(R.CheckOutDate) as LastCheckOut,
                            COUNT(*) as BookingCount,
                            'Multiple Rooms' as AllRooms,
                            SUM(CASE 
                                WHEN R.TotalPrice > 0 THEN R.TotalPrice
                                ELSE ISNULL(DATEDIFF(day, R.CheckInDate, R.CheckOutDate) * RM.Price, 0)
                                END) as TotalPrice,
                            R.Status
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = 'Approved'
                        GROUP BY R.Contact, R.Status, ISNULL(GL.FullName, 'Guest'), ISNULL(GL.Email, R.Contact), ISNULL(GL.Contact, R.Contact)
                        ORDER BY MIN(R.CheckInDate) DESC";

                    System.Diagnostics.Debug.WriteLine("Executing query: " + query);
                    
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    System.Diagnostics.Debug.WriteLine("Rows returned: " + dt.Rows.Count);
                    
                    // Save to ViewState so RowCommand can access full data
                    ViewState["GuestData"] = dt;

                    gvGuestList.DataSource = dt;
                    gvGuestList.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                }
            }
        }

        protected void gvGuestList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvGuestList.PageIndex = e.NewPageIndex;
            LoadGuests();
        }

        protected void gvGuestList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewReview")
            {
                string email = e.CommandArgument.ToString();
                
                // Fetch all bookings for this email
                DataTable allBookings = GetAllBookingsForEmail(email);
                
                if (allBookings != null && allBookings.Rows.Count > 0)
                {
                    // Get guest info from first booking
                    DataRow firstBooking = allBookings.Rows[0];
                    string guestName = firstBooking["GuestFullName"] != DBNull.Value ? firstBooking["GuestFullName"].ToString() : "Guest";
                    string guestEmail = firstBooking["GuestEmail"] != DBNull.Value ? firstBooking["GuestEmail"].ToString() : "N/A";
                    string guestContact = firstBooking["GuestContact"] != DBNull.Value ? firstBooking["GuestContact"].ToString() : "N/A";
                    
                    // Format all bookings details for display
                    string allBookingsHtml = FormatAllBookingsHtml(allBookings);
                    
                    // Trigger JavaScript to show all bookings with guest info
                    string script = $@"showAllBookingsForEmail('{HttpUtility.JavaScriptStringEncode(email)}', '{HttpUtility.JavaScriptStringEncode(guestName)}', '{HttpUtility.JavaScriptStringEncode(guestEmail)}', '{HttpUtility.JavaScriptStringEncode(guestContact)}', `{allBookingsHtml}`);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowAllBookings_" + email.Replace("@", "_").Replace(".", "_"), script, true);
                }
            }
        }

        private DataTable GetAllBookingsForEmail(string emailOrContact)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                    
                    // Enhanced query to get bookings with GuestList joins for proper guest info
                    string query = @"
                        SELECT 
                            R.ReservationID as BookingID,
                            R.CheckInDate,
                            R.CheckOutDate,
                            R.RoomID,
                            R.UnitID,
                            DATEDIFF(day, R.CheckInDate, R.CheckOutDate) as NumberOfDays,
                            RM.Price as PricePerNight,
                            RM.RoomName,
                            RM.RoomType,
                            ru.RoomNumber,
                            ISNULL(GL.FullName, 'Guest') as GuestFullName,
                            ISNULL(GL.Email, R.Contact) as GuestEmail,
                            ISNULL(GL.Contact, R.Contact) as GuestContact,
                            CASE 
                                WHEN R.TotalPrice > 0 THEN R.TotalPrice
                                ELSE ISNULL(DATEDIFF(day, R.CheckInDate, R.CheckOutDate) * RM.Price, 0)
                            END as CalculatedTotalPrice
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN RoomUnits ru ON R.UnitID = ru.UnitID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                        WHERE R.Status = 'Approved' AND (R.Contact = @EmailOrContact OR GL.Email = @EmailOrContact)
                        ORDER BY R.CheckInDate DESC";

                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    da.SelectCommand.Parameters.AddWithValue("@EmailOrContact", emailOrContact);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    
                    // Debug: Log the results
                    System.Diagnostics.Debug.WriteLine($"Found {dt.Rows.Count} bookings for {emailOrContact}");
                    foreach (DataRow row in dt.Rows)
                    {
                        System.Diagnostics.Debug.WriteLine($"BookingID: {row["BookingID"]}, Guest: {row["GuestFullName"]}, Email: {row["GuestEmail"]}, Contact: {row["GuestContact"]}");
                    }
                    
                    conn.Close();
                    return dt;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error in GetAllBookingsForEmail: " + ex.Message);
                    conn.Close();
                    return new DataTable();
                }
            }
        }

        private string FormatAllBookingsHtml(DataTable bookings)
        {
            string html = "";
            
            foreach (DataRow row in bookings.Rows)
            {
                string checkIn = Convert.ToDateTime(row["CheckInDate"]).ToString("MMM dd, yyyy");
                string checkOut = Convert.ToDateTime(row["CheckOutDate"]).ToString("MMM dd, yyyy");
                string roomName = row["RoomName"] != DBNull.Value ? row["RoomName"].ToString() : "N/A";
                string roomType = row["RoomType"] != DBNull.Value ? row["RoomType"].ToString() : "N/A";
                string roomNumber = row["RoomNumber"] != DBNull.Value ? row["RoomNumber"].ToString() : "N/A";
                decimal price = row["CalculatedTotalPrice"] != DBNull.Value ? Convert.ToDecimal(row["CalculatedTotalPrice"]) : 0;
                string formattedPrice = "₱" + price.ToString("N2");

                html += $@"
                    <div class='col-md-6 col-lg-4'>
                        <div class='card border-0 shadow-sm rounded-3 h-100' style='transition: transform 0.2s;'>
                            <div class='card-body p-4'>
                                <!-- Room Header -->
                                <div class='d-flex align-items-center mb-3'>
                                    <div class='rounded-circle bg-success bg-opacity-10 p-2 me-3'>
                                        <i class='bi bi-door-closed-fill text-success' style='font-size: 1.2rem;'></i>
                                    </div>
                                    <div>
                                        <h6 class='card-title mb-0 fw-bold' style='color: #0b6623;'>{roomName}</h6>
                                        <small class='text-muted'>{roomType}</small>
                                    </div>
                                </div>
                                
                                <!-- Room Details -->
                                <div class='mb-3'>
                                    <div class='d-flex align-items-center mb-2'>
                                        <i class='bi bi-hash text-muted me-2'></i>
                                        <span class='fw-semibold'>Room {roomNumber}</span>
                                    </div>
                                    <div class='d-flex align-items-center mb-2'>
                                        <i class='bi bi-calendar-check text-muted me-2'></i>
                                        <span>{checkIn}</span>
                                    </div>
                                    <div class='d-flex align-items-center mb-2'>
                                        <i class='bi bi-calendar-x text-muted me-2'></i>
                                        <span>{checkOut}</span>
                                    </div>
                                </div>
                                
                                <!-- Price -->
                                <div class='p-3 bg-light rounded-2'>
                                    <div class='d-flex justify-content-between align-items-center'>
                                        <span class='text-muted fw-semibold'>Total Price</span>
                                        <span class='fw-bold fs-5 text-success'>{formattedPrice}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>";
            }
            
            return html;
        }

        protected void btnConfirmAction_Click(object sender, EventArgs e) { /* ... */ }

        private string JavaScriptStringEscape(string input)
        {
            if (string.IsNullOrEmpty(input))
                return input;

            return input.Replace("\\", "\\\\")
                        .Replace("'", "\\'")
                        .Replace("\"", "\\\"")
                        .Replace("\r", "\\r")
                        .Replace("\n", "\\n")
                        .Replace("\t", "\\t");
        }
    }
}