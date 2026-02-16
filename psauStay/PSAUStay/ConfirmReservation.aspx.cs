using System;
using System.Configuration;
using System.Data.SqlClient;

namespace PSAUStay
{
    public partial class ConfirmReservation : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["FinalUnitID"] == null)
                {
                    Response.Redirect("OnlineBooking.aspx");
                    return;
                }

                lblRoomName.Text = Session["RoomNumberText"]?.ToString();
                lblEmail.Text = Session["Email"]?.ToString();
                lblContact.Text = Session["Contact"]?.ToString();
                lblDates.Text = Session["CheckIn"]?.ToString() + " to " + Session["CheckOut"]?.ToString();
                lblTotalAmount.Text = "₱" + Session["TotalPrice"]?.ToString();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("OnlineBooking.aspx");
        }

        protected void btnFinalConfirm_Click(object sender, EventArgs e)
        {
            if (Session["FinalUnitID"] == null) 
            {
                Response.Redirect("OnlineBooking.aspx");
                return;
            }

            // Retrieve data from Session
            string unitID = Session["FinalUnitID"].ToString();
            string fullName = Session["FullName"]?.ToString() ?? "Guest"; // Get full name
            string email = Session["Email"]?.ToString() ?? ""; // Use email as primary identifier
            string contact = Session["Contact"]?.ToString() ?? ""; // Get contact number
            string checkIn = Session["CheckIn"].ToString();
            string checkOut = Session["CheckOut"].ToString();
            string totalPrice = Session["TotalPrice"]?.ToString() ?? "0";
            
            // Parse totalPrice to remove commas and currency symbols before database operations
            decimal numericTotalPrice = 0;
            if (!string.IsNullOrEmpty(totalPrice))
            {
                // Remove any non-numeric characters except decimal point
                string cleanPrice = System.Text.RegularExpressions.Regex.Replace(totalPrice, @"[^\d.]", "");
                decimal.TryParse(cleanPrice, out numericTotalPrice);
            }

            string bookingRef = "0";
            
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();
                try
                {
                    // Get RoomID from UnitID first
                    string getRoomIdQuery = "SELECT RoomID FROM RoomUnits WHERE UnitID = @UID";
                    SqlCommand cmdGetRoomId = new SqlCommand(getRoomIdQuery, con, trans);
                    cmdGetRoomId.Parameters.AddWithValue("@UID", unitID);
                    object roomIdResult = cmdGetRoomId.ExecuteScalar();
                    
                    // Validate that we got a valid RoomID
                    if (roomIdResult == null || roomIdResult == DBNull.Value)
                    {
                        throw new Exception("Invalid RoomID selected from RoomUnits table.");
                    }
                    
                    string roomId = Convert.ToString(roomIdResult);

                    // 1. Insert into GuestList table first
                    string sqlGuest = @"INSERT INTO [dbo].[GuestList] (FullName, Contact, Email, Purpose) 
                                       VALUES (@FullName, @Contact, @Email, @Purpose); SELECT SCOPE_IDENTITY()";

                    SqlCommand cmdGuest = new SqlCommand(sqlGuest, con, trans);
                    cmdGuest.Parameters.AddWithValue("@FullName", fullName); // Use actual full name from form
                    cmdGuest.Parameters.AddWithValue("@Contact", contact);
                    cmdGuest.Parameters.AddWithValue("@Email", email);
                    cmdGuest.Parameters.AddWithValue("@Purpose", "Room Reservation");

                    // Execute and get the GuestID
                    object guestResult = cmdGuest.ExecuteScalar();
                    int guestId = guestResult != null ? Convert.ToInt32(guestResult) : 0;

                    // 2. Record the Booking and get the new ReservationID (Reference Number)
                    string sqlBook = @"INSERT INTO [dbo].[Reservation] (UserID, Contact, RoomID, UnitID, CheckInDate, CheckOutDate, TotalPrice, Status) 
                                     VALUES (@UserID, @Contact, @RoomID, @UnitID, @In, @Out, @TotalPrice, 'Pending'); SELECT SCOPE_IDENTITY()";

                    SqlCommand cmdBook = new SqlCommand(sqlBook, con, trans);
                    cmdBook.Parameters.AddWithValue("@UserID", guestId); // Link to GuestList
                    cmdBook.Parameters.AddWithValue("@Contact", contact); // Save contact number in Contact field
                    cmdBook.Parameters.AddWithValue("@RoomID", roomId);
                    cmdBook.Parameters.AddWithValue("@UnitID", Convert.ToInt32(unitID));
                    cmdBook.Parameters.AddWithValue("@In", checkIn);
                    cmdBook.Parameters.AddWithValue("@Out", checkOut);
                    cmdBook.Parameters.AddWithValue("@TotalPrice", numericTotalPrice);

                    // Execute and get the Reference ID
                    object result = cmdBook.ExecuteScalar();
                    bookingRef = result != null ? result.ToString() : "0";

                    // 3. Update RoomUnits Status to 'Booked'
                    string sqlUpdate = "UPDATE RoomUnits SET Status = 'Booked' WHERE UnitID = @UID";
                    SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, con, trans);
                    cmdUpdate.Parameters.AddWithValue("@UID", Convert.ToInt32(unitID));
                    cmdUpdate.ExecuteNonQuery();

                    // Commit the transaction
                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    // Show error message to user
                    System.Diagnostics.Debug.WriteLine("Database Error: " + ex.Message);
                    
                    // Show error to user
                    lblError.Text = "An error occurred while processing your booking: " + ex.Message;
                    lblError.Visible = true;
                    return; // Exit method on error
                }
            }

            // 3. Clear Session to prevent duplicate bookings on refresh
            Session["FinalUnitID"] = null;

            // 4. Navigate to BookingSuccess with query parameters required by BookingSuccess.aspx.cs
            // Ref: bookingRef, email, amount (for downpayment calculation), payment option, room name
            string paymentOption = rbFullPayment.Checked ? "full" : "downpayment";
            string roomName = Session["RoomName"]?.ToString() ?? "Standard Room";
            string redirectUrl = $"BookingSuccess.aspx?ref={bookingRef}&email={Server.UrlEncode(email)}&amount={numericTotalPrice}&payment={paymentOption}&room={Server.UrlEncode(roomName)}";
            Response.Redirect(redirectUrl);
        }
    }
}