using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class ResetCounts : System.Web.UI.Page
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
                LoadCurrentCounts();
            }
        }

        private void LoadCurrentCounts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                
                string html = "<div class='row'>";
                
                // RoomRequests counts
                string queryRQ = "SELECT Status, COUNT(*) as Count FROM RoomRequests GROUP BY Status ORDER BY Count DESC";
                using (SqlCommand cmd = new SqlCommand(queryRQ, con))
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    html += "<div class='col-md-6'><h6>RoomRequests</h6><table class='table table-sm'>";
                    while (dr.Read())
                    {
                        html += $"<tr><td>{dr["Status"]}</td><td><span class='badge bg-primary'>{dr["Count"]}</span></td></tr>";
                    }
                    html += "</table></div>";
                }
                
                // Reservation counts
                string queryRes = "SELECT Status, COUNT(*) as Count FROM [dbo].[Reservation] GROUP BY Status ORDER BY Count DESC";
                using (SqlCommand cmd = new SqlCommand(queryRes, con))
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    html += "<div class='col-md-6'><h6>Reservation</h6><table class='table table-sm'>";
                    while (dr.Read())
                    {
                        html += $"<tr><td>{dr["Status"]}</td><td><span class='badge bg-info'>{dr["Count"]}</span></td></tr>";
                    }
                    html += "</table></div>";
                }
                
                html += "</div>";
                litCurrentCounts.Text = html;
            }
        }

        protected void btnResetToPending_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                
                // Reset RoomRequests
                string resetRQ = "UPDATE RoomRequests SET Status = 'Pending' WHERE Status NOT IN ('Approved', 'Rejected', 'Pending', 'Waitlist')";
                using (SqlCommand cmd = new SqlCommand(resetRQ, con))
                {
                    cmd.ExecuteNonQuery();
                }
                
                // Reset Reservations
                string resetRes = "UPDATE [dbo].[Reservation] SET Status = 'Pending' WHERE Status NOT IN ('Approved', 'Rejected', 'Pending', 'Waitlisted')";
                using (SqlCommand cmd = new SqlCommand(resetRes, con))
                {
                    cmd.ExecuteNonQuery();
                }
            }
            
            ShowMessage("All statuses have been reset to Pending", "success");
            LoadCurrentCounts();
        }

        protected void btnClearAll_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                
                // Clear RoomRequests
                using (SqlCommand cmd = new SqlCommand("DELETE FROM RoomRequests", con))
                {
                    cmd.ExecuteNonQuery();
                }
                
                // Clear Reservations
                using (SqlCommand cmd = new SqlCommand("DELETE FROM [dbo].[Reservation]", con))
                {
                    cmd.ExecuteNonQuery();
                }
            }
            
            ShowMessage("All data has been cleared", "success");
            LoadCurrentCounts();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadCurrentCounts();
            ShowMessage("Counts refreshed", "info");
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"alert alert-{type} d-block";
        }
    }
}
