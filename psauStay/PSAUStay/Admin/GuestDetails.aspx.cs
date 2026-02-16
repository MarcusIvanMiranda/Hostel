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
                        WHERE R.Status = 'Approved'
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

        private void ShowToast(string title, string message, string type)
        {
            // Clean message for JS
            string cleanMsg = message.Replace("'", "\\'");
            string script = $"Swal.fire({{ title: '{title}', text: '{cleanMsg}', icon: '{type}', confirmButtonColor: '#198754' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }
    }
}
