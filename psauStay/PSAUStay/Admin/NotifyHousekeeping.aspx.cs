using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PSAUStay.Admin
{
    public partial class NotifyHousekeeping : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        // Manual declarations to fix CS0103 "does not exist in current context" errors
        protected global::System.Web.UI.WebControls.DropDownList ddlRooms;
        protected global::System.Web.UI.WebControls.DropDownList ddlRoomNo;
        protected global::System.Web.UI.WebControls.TextBox txtIssue;
        protected global::System.Web.UI.WebControls.DropDownList ddlTaskType;
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.Repeater rptNotificationCards;
        protected global::System.Web.UI.HtmlControls.HtmlGenericControl emptyState;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRooms();
                LoadRecentNotifications();
                LoadStatistics();
            }
        }

        protected void ddlRooms_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadRoomNumbers();
        }

        private void LoadRooms()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                // Loads Category names (Mangga, Duhat, etc.)
                SqlCommand cmd = new SqlCommand("SELECT RoomID, RoomName FROM Rooms ORDER BY RoomName", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                ddlRooms.DataSource = rdr;
                ddlRooms.DataTextField = "RoomName";
                ddlRooms.DataValueField = "RoomID";
                ddlRooms.DataBind();
                ddlRooms.Items.Insert(0, new ListItem("-- Select Room Category --", "0"));
            }
        }

        private void LoadRoomNumbers()
        {
            string categoryId = ddlRooms.SelectedValue;
            ddlRoomNo.Items.Clear();
            ddlRoomNo.Items.Add(new ListItem("-- Select Room Number --", ""));

            if (categoryId != "0" && !string.IsNullOrEmpty(categoryId))
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    // Load only available rooms (not currently under maintenance/cleaning)
                    SqlCommand cmd = new SqlCommand(@"SELECT RoomNumber FROM RoomUnits 
                        WHERE RoomID = @RoomID 
                        AND RoomNumber NOT IN (
                            SELECT DISTINCT SUBSTRING(Issue, CHARINDEX('Room ', Issue) + 5, CHARINDEX('[', Issue) - CHARINDEX('Room ', Issue) - 5)
                            FROM HousekeepingNotifications 
                            WHERE Status = 'Pending'
                        )
                        ORDER BY RoomNumber", con);
                    cmd.Parameters.AddWithValue("@RoomID", categoryId);
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    ddlRoomNo.DataSource = rdr;
                    ddlRoomNo.DataTextField = "RoomNumber";
                    ddlRoomNo.DataValueField = "RoomNumber";
                    ddlRoomNo.DataBind();
                }
            }
        }

        private void LoadRecentNotifications()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                // Get all notifications without pagination
                string query = @"SELECT hn.*, r.RoomName as RoomDisplay 
                                FROM HousekeepingNotifications hn
                                JOIN Rooms r ON hn.RoomID = r.RoomID 
                                ORDER BY hn.DateCreated DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Replace task type abbreviations with full names
                foreach (DataRow row in dt.Rows)
                {
                    if (row["Issue"] != DBNull.Value)
                    {
                        string issue = row["Issue"].ToString();
                        issue = issue.Replace("[Regular]", "Regular Cleaning");
                        issue = issue.Replace("[Deep]", "Deep Cleaning");
                        row["Issue"] = issue;
                    }
                }

                // Bind to Repeater
                rptNotificationCards.DataSource = dt;
                rptNotificationCards.DataBind();

                // Show/hide empty state
                emptyState.Style["display"] = dt.Rows.Count == 0 ? "block" : "none";
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"SELECT 
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE CAST(DateCreated AS DATE) = CAST(GETDATE() AS DATE)) AS TodayCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Pending') AS PendingCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Completed') AS CompletedCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Issue LIKE '%Deep%') AS DeepCleaningCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Issue LIKE '%Regular%') AS RegularCleaningCount", con);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                if (rdr.Read())
                {
                    // Register JavaScript to update statistics
                    string script = $@"
                        document.getElementById('todayCount').innerText = '{rdr["TodayCount"]}';
                        document.getElementById('pendingCount').innerText = '{rdr["PendingCount"]}';
                        document.getElementById('completedCount').innerText = '{rdr["CompletedCount"]}';
                        document.getElementById('deepCleaningCount').innerText = '{rdr["DeepCleaningCount"]}';
                        document.getElementById('regularCleaningCount').innerText = '{rdr["RegularCleaningCount"]}';
                        document.getElementById('notificationCount').innerText = '{rdr["PendingCount"]}';
                    ";

                    // Register script to run after page loads
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateStats", script, true);
                }
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string categoryId = ddlRooms.SelectedValue;
            string roomNo = ddlRoomNo.SelectedValue;
            string originalIssue = txtIssue.Text.Trim();
            string taskType = ddlTaskType.SelectedValue;

            if (categoryId == "0" || string.IsNullOrEmpty(roomNo) || string.IsNullOrEmpty(originalIssue) || string.IsNullOrEmpty(taskType))
            {
                lblMessage.Text = "Please fill in all fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // No need to validate room number since we're loading from database
            // WORKAROUND: Put the room number and task type into the Issue text
            // Result: "Room 2 [Deep]: Lightbulb needs replacement"
            string formattedIssue = "Room " + roomNo + " [" + taskType + "]: " + originalIssue;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Insert the notification
                SqlCommand insertCmd = new SqlCommand(@"INSERT INTO HousekeepingNotifications 
                    (RoomID, Issue, Status, DateCreated) 
                    VALUES (@RoomID, @Issue, 'Pending', GETDATE())", con);
                insertCmd.Parameters.AddWithValue("@RoomID", categoryId);
                insertCmd.Parameters.AddWithValue("@Issue", formattedIssue);
                insertCmd.ExecuteNonQuery();

                // Update room status based on task type (using existing RoomUnits table)
                string roomStatus = "";
                switch (taskType)
                {
                    case "Deep":
                        roomStatus = "Deep Cleaning";
                        break;
                    case "Regular":
                        roomStatus = "Regular Cleaning";
                        break;
                    default:
                        roomStatus = "Available";
                        break;
                }

                // Update room status in RoomUnits table
                try
                {
                    SqlCommand updateCmd = new SqlCommand(@"UPDATE RoomUnits 
                        SET Status = @Status 
                        WHERE RoomID = @RoomID AND RoomNumber = @RoomNumber", con);
                    updateCmd.Parameters.AddWithValue("@Status", roomStatus);
                    updateCmd.Parameters.AddWithValue("@RoomID", categoryId);
                    updateCmd.Parameters.AddWithValue("@RoomNumber", roomNo);
                    updateCmd.ExecuteNonQuery();
                }
                catch (SqlException)
                {
                    // If there's an error, show message but don't crash the application
                    lblMessage.Text = "Room status updated, but notification sent successfully.";
                    lblMessage.ForeColor = System.Drawing.Color.Orange;
                }

                lblMessage.Text = "Notification sent successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;

                // Refresh data immediately
                LoadRecentNotifications();
                LoadStatistics();
                LoadRoomNumbers(); // Refresh room dropdown to update availability
                btnClear_Click(null, null);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtIssue.Text = "";
            ddlRooms.SelectedIndex = 0;
            ddlRoomNo.Items.Clear();
            ddlRoomNo.Items.Add(new ListItem("-- Select Room Category First --", ""));
            ddlTaskType.SelectedIndex = 0;
            lblMessage.Text = "";
        }
    }
}