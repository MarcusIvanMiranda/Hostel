using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace PSAUStay.Admin
{
    public partial class ConfirmGuestDetails : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["GuestUnitID"] == null)
                {
                    Response.Redirect("GuestDetails.aspx");
                    return;
                }

                // Debug: Log all session data
                System.Diagnostics.Debug.WriteLine("=== ConfirmGuestDetails Page_Load ===");
                System.Diagnostics.Debug.WriteLine($"GuestUnitID: {Session["GuestUnitID"]}");
                System.Diagnostics.Debug.WriteLine($"GuestFullName: {Session["GuestFullName"]}");
                System.Diagnostics.Debug.WriteLine($"GuestRoomNumber: {Session["GuestRoomNumber"]}");
                System.Diagnostics.Debug.WriteLine($"GuestStatus: {Session["GuestStatus"]}");

                // Display guest information from Session
                lblFullName.Text = Session["GuestFullName"]?.ToString();
                lblEmail.Text = Session["GuestEmail"]?.ToString();
                lblContact.Text = Session["GuestContact"]?.ToString();
                lblRoomType.Text = Session["GuestRoomType"]?.ToString();
                lblRoomNumber.Text = Session["GuestRoomNumber"]?.ToString();
                lblStatus.Text = Session["GuestStatus"]?.ToString();
                lblCheckIn.Text = Session["GuestCheckIn"]?.ToString();
                lblCheckOut.Text = Session["GuestCheckOut"]?.ToString();

                string message = Session["GuestMessage"]?.ToString();
                if (!string.IsNullOrEmpty(message))
                {
                    lblMessage.Visible = true;
                    litMessage.Text = message;
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("GuestDetails.aspx");
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            if (Session["GuestUnitID"] == null)
            {
                Response.Redirect("GuestDetails.aspx");
                return;
            }

            // Retrieve data from Session
            string unitID = Session["GuestUnitID"].ToString();
            string fullName = Session["GuestFullName"].ToString();
            string email = Session["GuestEmail"]?.ToString() ?? "";
            string contact = Session["GuestContact"]?.ToString() ?? "";
            string roomID = Session["GuestRoomID"]?.ToString() ?? "0";
            string roomNumber = Session["GuestRoomNumber"]?.ToString() ?? "";
            string checkIn = Session["GuestCheckIn"].ToString();
            string checkOut = Session["GuestCheckOut"].ToString();
            string status = Session["GuestStatus"]?.ToString() ?? "Pending";
            string message = Session["GuestMessage"]?.ToString() ?? "";
            bool isEdit = Session["GuestIsEdit"] != null && (bool)Session["GuestIsEdit"];
            string requestID = Session["GuestRequestID"]?.ToString() ?? "0";

            string walkInRef = "";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();
                try
                {
                    string sql;

                    if (isEdit)
                    {
                        // UPDATE for Existing Request
                        sql = @"UPDATE RoomRequests SET 
                                FullName=@Name, Email=@Email, Contact=@Contact, 
                                RoomID=@RoomID, CheckInDate=@In, CheckOutDate=@Out, 
                                Message=@Msg, Status=@Status 
                                WHERE RequestID=@ID";
                    }
                    else
                    {
                        // INSERT for New Walk-in Guest
                        walkInRef = "WALK-" + DateTime.Now.Ticks.ToString().Substring(12);
                        sql = @"INSERT INTO RoomRequests 
                               (FullName, Email, Contact, RoomID, CheckInDate, CheckOutDate, Message, Status, PaymentStatus, BookingRef, DateRequested) 
                               VALUES (@Name, @Email, @Contact, @RoomID, @In, @Out, @Msg, @Status, 'Paid', @Ref, GETDATE())";
                    }

                    using (SqlCommand cmd = new SqlCommand(sql, con, trans))
                    {
                        cmd.Parameters.AddWithValue("@Name", fullName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Contact", contact);
                        cmd.Parameters.AddWithValue("@RoomID", roomID);
                        cmd.Parameters.AddWithValue("@In", DateTime.Parse(checkIn));
                        cmd.Parameters.AddWithValue("@Out", DateTime.Parse(checkOut));
                        
                        // Store UnitID in Message field following the pattern used in GuestList
                        string messageWithUnitId = $"UnitID:{unitID}|{message}";
                        cmd.Parameters.AddWithValue("@Msg", messageWithUnitId);
                        cmd.Parameters.AddWithValue("@Status", status);

                        if (isEdit)
                        {
                            cmd.Parameters.AddWithValue("@ID", requestID);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Ref", walkInRef);
                        }

                        cmd.ExecuteNonQuery();
                    }

                    // Update RoomUnits Status - Always mark as Booked when confirmed
                    // This ensures the room is no longer available for other bookings
                    string updateUnitSql = "UPDATE RoomUnits SET Status = 'Booked' WHERE UnitID = @UID";
                    using (SqlCommand cmdUnit = new SqlCommand(updateUnitSql, con, trans))
                    {
                        cmdUnit.Parameters.AddWithValue("@UID", unitID);
                        int rowsAffected = cmdUnit.ExecuteNonQuery();
                        
                        // Debug: Log the result
                        System.Diagnostics.Debug.WriteLine($"RoomUnits update completed. UnitID={unitID}, Rows affected: {rowsAffected}");
                        
                        if (rowsAffected == 0)
                        {
                            throw new Exception($"Failed to update RoomUnits. UnitID {unitID} not found or no changes needed.");
                        }
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    lblError.Text = "An error occurred while processing the booking: " + ex.Message;
                    lblError.Visible = true;
                    return;
                }
            }

            // Clear Session to prevent duplicate bookings
            Session["GuestUnitID"] = null;
            Session["GuestFullName"] = null;
            Session["GuestEmail"] = null;
            Session["GuestContact"] = null;
            Session["GuestRoomType"] = null;
            Session["GuestRoomNumber"] = null;
            Session["GuestStatus"] = null;
            Session["GuestCheckIn"] = null;
            Session["GuestCheckOut"] = null;
            Session["GuestMessage"] = null;
            Session["GuestIsEdit"] = null;
            Session["GuestRequestID"] = null;

            // Redirect to GuestList with success message
            Response.Redirect("GuestList.aspx?success=true");
        }
    }
}