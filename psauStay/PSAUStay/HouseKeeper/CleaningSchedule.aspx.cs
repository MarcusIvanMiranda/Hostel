using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.HouseKeeper
{
    public partial class CleaningSchedule : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCleaningSchedule();
                LoadStatistics();
            }
        }

        private void BindCleaningSchedule()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        RU.UnitID,
                        RM.RoomName,
                        RU.RoomNumber,
                        ISNULL(GL.FullName, 'Checked Out') as GuestName,
                        RQ.CheckOutDate as CheckOutDate,
                        RU.Status as Status
                    FROM RoomUnits RU
                    JOIN Rooms RM ON RU.RoomID = RM.RoomID
                    LEFT JOIN RoomRequests RQ ON RU.UnitID = TRY_CAST(SUBSTRING(RQ.Message, CHARINDEX('UnitID:', RQ.Message) + 7, 2) AS INT)
                    LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                    WHERE RU.Status = 'To Be Cleaned'
                    AND RQ.Status = 'CheckedOut'
                    
                    UNION ALL
                    
                    SELECT 
                        RU.UnitID,
                        RM.RoomName,
                        RU.RoomNumber,
                        ISNULL(GL.FullName, 'Checked Out') as GuestName,
                        R.CheckOutDate,
                        RU.Status as Status
                    FROM RoomUnits RU
                    JOIN Rooms RM ON RU.RoomID = RM.RoomID
                    LEFT JOIN [dbo].[Reservation] R ON RU.UnitID = R.UnitID
                    LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                    WHERE RU.Status = 'To Be Cleaned'
                    AND R.Status = 'CheckedOut'
                    
                    ORDER BY CheckOutDate DESC, RoomName, RoomNumber";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCleaningSchedule.DataSource = dt;
                gvCleaningSchedule.DataBind();
                
                // Update room count badge
                string script = $"document.getElementById('roomCount').innerText = '{dt.Rows.Count}';";
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateRoomCount", script, true);
            }
        }
        
        private void LoadStatistics()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                
                // Get pending cleaning count
                SqlCommand pendingCmd = new SqlCommand("SELECT COUNT(*) FROM RoomUnits WHERE Status = 'To Be Cleaned'", con);
                int pendingCount = (int)pendingCmd.ExecuteScalar();
                
                // Get completed today count (rooms that were marked available today)
                // Since ModifiedDate doesn't exist, we'll use a simpler approach
                SqlCommand completedCmd = new SqlCommand("SELECT COUNT(*) FROM RoomUnits WHERE Status = 'Available'", con);
                int completedCount = (int)completedCmd.ExecuteScalar();
                
                // Get urgent count (rooms waiting more than 2 hours)
                SqlCommand urgentCmd = new SqlCommand(@"SELECT COUNT(*) FROM RoomUnits RU
                    JOIN Rooms RM ON RU.RoomID = RM.RoomID
                    LEFT JOIN RoomRequests RQ ON RU.UnitID = TRY_CAST(SUBSTRING(RQ.Message, CHARINDEX('UnitID:', RQ.Message) + 7, 2) AS INT)
                    LEFT JOIN [dbo].[Reservation] R ON RU.UnitID = R.UnitID
                    WHERE RU.Status = 'To Be Cleaned'
                    AND ((RQ.Status = 'CheckedOut' AND DATEDIFF(HOUR, RQ.CheckOutDate, GETDATE()) > 2)
                    OR (R.Status = 'CheckedOut' AND DATEDIFF(HOUR, R.CheckOutDate, GETDATE()) > 2))", con);
                int urgentCount = (int)urgentCmd.ExecuteScalar();
                
                // Calculate average cleaning time (mock calculation for now)
                double avgTime = pendingCount > 0 ? 45.5 : 0; // 45.5 minutes average
                
                // Update statistics with JavaScript
                string statsScript = $@"
                    document.getElementById('pendingCount').innerText = '{pendingCount}';
                    document.getElementById('completedCount').innerText = '{completedCount}';
                    document.getElementById('urgentCount').innerText = '{urgentCount}';
                    document.getElementById('avgTime').innerText = '{avgTime:F1}m';";
                
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateStats", statsScript, true);
            }
        }
        
        protected void gvCleaningSchedule_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get checkout date
                DateTime checkOutDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "CheckOutDate"));
                double hoursWaiting = (DateTime.Now - checkOutDate).TotalHours;
                
                // Apply row styling based on urgency
                if (hoursWaiting > 2)
                {
                    e.Row.CssClass = "room-urgent";
                }
                else
                {
                    e.Row.CssClass = "room-normal";
                }
            }
        }

        protected void btnMarkDone_Click(object sender, EventArgs e)
        {
            string unitId = hfSelectedID.Value;

            if (string.IsNullOrEmpty(unitId))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Error', 'No room selected.', 'error');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();
                try
                {
                    // Update room status from 'To Be Cleaned' to 'Available'
                    SqlCommand cmd = new SqlCommand("UPDATE RoomUnits SET Status = 'Available' WHERE UnitID = @UnitID", con, trans);
                    cmd.Parameters.AddWithValue("@UnitID", unitId);
                    cmd.ExecuteNonQuery();

                    trans.Commit();
                    BindCleaningSchedule();
                    LoadStatistics();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success', 'Room marked as available for booking.', 'success');", true);
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"Swal.fire('Error', 'Failed to update room status: {ex.Message}', 'error');", true);
                }
            }
        }
    }
}
