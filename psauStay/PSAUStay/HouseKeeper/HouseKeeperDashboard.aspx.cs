using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PSAUStay.HouseKeeper
{
    public partial class HouseKeeperDashboard : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RefreshDashboard();
            }
        }

        protected void gvNotifications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Complete")
            {
                string notificationId = e.CommandArgument.ToString();
                MarkNotificationCompleted(notificationId);
                RefreshDashboard();
            }
            else if (e.CommandName == "DeleteNotification")
            {
                string notificationId = e.CommandArgument.ToString();
                DeleteNotification(notificationId);
                RefreshDashboard();
            }
        }

        private void RefreshDashboard()
        {
            LoadNotifications();
            LoadHistory();
            LoadStatistics();
        }

        private void LoadNotifications()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT hn.NotificationID, r.RoomName AS RoomDisplay, hn.Issue, hn.Status, hn.DateCreated,
                                CASE WHEN hn.Status = 'Pending' THEN 'warning' ELSE 'secondary' END AS StatusClass
                                FROM HousekeepingNotifications hn
                                LEFT JOIN Rooms r ON hn.RoomID = r.RoomID
                                WHERE hn.Status = 'Pending'
                                ORDER BY hn.DateCreated DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNotifications.DataSource = dt;
                gvNotifications.DataBind();
                notificationBadge.InnerText = dt.Rows.Count.ToString();
            }
        }

        private void LoadHistory()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT TOP 15 hn.NotificationID, r.RoomName AS RoomDisplay, hn.Issue, hn.Status, 
                                hn.DateCreated AS CompletedDate, 'Staff' AS CompletedBy
                                FROM HousekeepingNotifications hn
                                LEFT JOIN Rooms r ON hn.RoomID = r.RoomID
                                WHERE hn.Status = 'Completed'
                                ORDER BY hn.DateCreated DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvHistory.DataSource = dt;
                gvHistory.DataBind();
                historyBadge.InnerText = dt.Rows.Count.ToString();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT 
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE CAST(DateCreated AS DATE) = CAST(GETDATE() AS DATE)) AS TodayCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Pending') AS PendingCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Completed') AS CompletedCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Pending' AND Issue LIKE '%Deep%') AS DeepCount,
                    (SELECT COUNT(*) FROM HousekeepingNotifications WHERE Status = 'Pending' AND Issue LIKE '%Regular%') AS RegularCount";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                if (rdr.Read())
                {
                    // Injecting values into the HTML IDs via JavaScript
                    string script = $@"
                        document.getElementById('pendingCount').innerText = '{rdr["PendingCount"]}';
                        document.getElementById('completedCount').innerText = '{rdr["CompletedCount"]}';
                        document.getElementById('deepCleaningCount').innerText = '{rdr["DeepCount"]}';
                        document.getElementById('regularCleaningCount').innerText = '{rdr["RegularCount"]}';";

                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateStats", script, true);
                }
            }
        }

        private void MarkNotificationCompleted(string notificationId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UPDATE HousekeepingNotifications SET Status = 'Completed' WHERE NotificationID = @ID", con);
                cmd.Parameters.AddWithValue("@ID", notificationId);
                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteNotification(string notificationId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM HousekeepingNotifications WHERE NotificationID = @ID", con);
                cmd.Parameters.AddWithValue("@ID", notificationId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}