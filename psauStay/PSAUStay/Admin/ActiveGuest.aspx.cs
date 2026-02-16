using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PSAUStay.Admin
{
    public partial class ActiveGuest : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadActiveGuests();
            }
        }

        private void LoadActiveGuests()
        {
            string searchTerm = txtSearch.Text.Trim();

            // REMOVED: AutoMoveExpiredGuests() call. 
            // We no longer want the system to automatically change status based on date.

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Updated query: Only show guests who are currently checked in
                // Today's date must be between CheckInDate and CheckOutDate
                string query = @"
                    SELECT * FROM (
                        SELECT ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, RQ.Email) as Email, ISNULL(GL.Contact, RQ.Email) as Contact, RM.RoomName, RQ.CheckInDate, RQ.CheckOutDate, RQ.DateRequested, 'Online' as Source
                        FROM RoomRequests RQ
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        WHERE RQ.Status = 'Approved' AND CAST(GETDATE() AS DATE) BETWEEN CAST(RQ.CheckInDate AS DATE) AND CAST(RQ.CheckOutDate AS DATE)
                        
                        UNION ALL

                        SELECT ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, RES.Contact) as Email, ISNULL(GL.Contact, RES.Contact) as Contact, RM.RoomName, RES.CheckInDate, RES.CheckOutDate, RES.DateCreated as DateRequested, 'Manual' as Source
                        FROM [dbo].[Reservation] RES
                        INNER JOIN Rooms RM ON RES.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RES.UserID = GL.GuestID
                        WHERE RES.Status = 'Approved' AND CAST(GETDATE() AS DATE) BETWEEN CAST(RES.CheckInDate AS DATE) AND CAST(RES.CheckOutDate AS DATE)
                    ) AS ActiveData";

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " WHERE FullName LIKE @Search OR RoomName LIKE @Search OR Email LIKE @Search OR Contact LIKE @Search";
                }

                query += " ORDER BY DateRequested DESC, CheckInDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvActiveGuests.DataSource = dt;
                gvActiveGuests.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadActiveGuests();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadActiveGuests();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadActiveGuests();
        }

        // This method is no longer used and can be deleted to prevent the DataReader error.
        private void AutoMoveExpiredGuests()
        {
            // Method body removed to satisfy the requirement of manual checkout only.
        }
    }
}