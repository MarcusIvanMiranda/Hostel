using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PSAUStay.HouseKeeper
{
    public partial class HouseKeeperMaintenance : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FullName"] == null) { Response.Redirect("../Login.aspx"); return; }
            if (!IsPostBack) { RefreshGrids(); }
        }

        private void RefreshGrids()
        {
            LoadActiveTasks();
            LoadCompletedLogs();
        }

        void LoadActiveTasks()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT m.MaintenanceID, r.RoomName, u.RoomNumber, m.IssueDescription, m.Status 
                                 FROM MaintenanceRequests m
                                 INNER JOIN Rooms r ON m.RoomID = r.RoomID
                                 INNER JOIN RoomUnits u ON m.UnitID = u.UnitID
                                 WHERE m.AssignedTo = @MyName AND m.Status != 'Completed'
                                 ORDER BY m.DateRequested DESC";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@MyName", Session["FullName"].ToString());
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMyTasks.DataSource = dt;
                gvMyTasks.DataBind();
            }
        }

        void LoadCompletedLogs()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT m.MaintenanceID, r.RoomName, u.RoomNumber, m.IssueDescription, m.DateCompleted, m.Notes 
                                 FROM MaintenanceRequests m
                                 INNER JOIN Rooms r ON m.RoomID = r.RoomID
                                 INNER JOIN RoomUnits u ON m.UnitID = u.UnitID
                                 WHERE m.AssignedTo = @MyName AND m.Status = 'Completed'
                                 ORDER BY m.DateCompleted DESC";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@MyName", Session["FullName"].ToString());
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCompletedTasks.DataSource = dt;
                gvCompletedTasks.DataBind();
            }
        }

        protected void gvMyTasks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            string actionVerb = e.CommandName == "StartWork" ? "started" : "completed";
            string status = e.CommandName == "StartWork" ? "In Progress" : "Completed";
            string dateCol = e.CommandName == "StartWork" ? "DateStarted" : "DateCompleted";

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlTransaction transaction = con.BeginTransaction();
                try
                {
                    string worker = Session["FullName"].ToString();

                    // Retrieve Room Name and Number for the log
                    string infoQuery = @"SELECT r.RoomName, u.RoomNumber FROM MaintenanceRequests m 
                                       JOIN Rooms r ON m.RoomID = r.RoomID 
                                       JOIN RoomUnits u ON m.UnitID = u.UnitID WHERE m.MaintenanceID = @ID";
                    SqlCommand cmdInfo = new SqlCommand(infoQuery, con, transaction);
                    cmdInfo.Parameters.AddWithValue("@ID", id);
                    string roomDetails = "";
                    using (SqlDataReader dr = cmdInfo.ExecuteReader())
                    {
                        if (dr.Read()) roomDetails = $"{dr["RoomName"]} {dr["RoomNumber"]}";
                    }

                    // Log Format: Maintenance [started/completed] for [Room Name] [Room Number] by [Employee]
                    string logText = $"[{DateTime.Now:yyyy-MM-dd HH:mm}] Maintenance {actionVerb} for {roomDetails} by {worker}.";

                    string query = $@"UPDATE MaintenanceRequests SET 
                             Status = @Status, {dateCol} = GETDATE(), 
                             Notes = COALESCE(Notes, '') + CHAR(13) + CHAR(10) + @Log 
                             WHERE MaintenanceID = @ID";

                    SqlCommand cmd = new SqlCommand(query, con, transaction);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Log", logText);
                    cmd.Parameters.AddWithValue("@ID", id);
                    cmd.ExecuteNonQuery();

                    if (e.CommandName == "FinishWork")
                    {
                        string queryUnit = @"UPDATE RoomUnits SET Status = 'Available' 
                                    WHERE UnitID = (SELECT UnitID FROM MaintenanceRequests WHERE MaintenanceID = @ID)";
                        SqlCommand cmdUnit = new SqlCommand(queryUnit, con, transaction);
                        cmdUnit.Parameters.AddWithValue("@ID", id);
                        cmdUnit.ExecuteNonQuery();
                    }
                    transaction.Commit();
                }
                catch { if (transaction?.Connection != null) transaction.Rollback(); }
            }
            RefreshGrids();
        }
    }
}