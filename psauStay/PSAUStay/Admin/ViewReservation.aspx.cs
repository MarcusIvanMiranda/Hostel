using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PSAUStay.Admin
{
    public partial class ViewReservation : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Account/Login.aspx"); return; }

            if (!IsPostBack)
            {
                if (Request.QueryString["RequestID"] != null)
                {
                    pnlAllBookings.Visible = false;
                    pnlSingleDetails.Visible = true;

                    int id = 0;
                    if (int.TryParse(Request.QueryString["RequestID"], out id))
                    {
                        hfDeleteID.Value = id.ToString();
                        LoadDetails(id);
                    }
                }
                else
                {
                    pnlAllBookings.Visible = true;
                    pnlSingleDetails.Visible = false;
                    LoadAllReservations();
                }
            }
        }

        private void LoadAllReservations()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT RequestID, FullName, Email, Contact, RoomName, CheckInDate, CheckOutDate, Status, DateRequested
                    FROM (
                        SELECT RQ.RequestID, ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, RQ.Email) as Email, ISNULL(GL.Contact, RQ.Email) as Contact, RM.RoomName, RQ.CheckInDate, RQ.CheckOutDate, RQ.Status, RQ.DateRequested
                        FROM RoomRequests RQ 
                        INNER JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, R.Contact) as Email, ISNULL(GL.Contact, R.Contact) as Contact, ISNULL(RM.RoomName, 'Unknown Room') as RoomName, R.CheckInDate, R.CheckOutDate, R.Status, R.DateCreated as DateRequested
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                    ) AS CombinedData 
                    ORDER BY DateRequested DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAllReservations.DataSource = dt;
                gvAllReservations.DataBind();
            }
        }

        private void LoadDetails(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT RequestID, FullName, Email, Contact, RoomName, CheckInDate, CheckOutDate, Status
                    FROM (
                        SELECT RQ.RequestID, ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, RQ.Email) as Email, ISNULL(GL.Contact, RQ.Email) as Contact, RM.RoomName, RQ.CheckInDate, RQ.CheckOutDate, RQ.Status
                        FROM RoomRequests RQ 
                        LEFT JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                        UNION ALL
                        SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest') as FullName, ISNULL(GL.Email, R.Contact) as Email, ISNULL(GL.Contact, R.Contact) as Contact, ISNULL(RM.RoomName, 'Unknown Room') as RoomName, R.CheckInDate, R.CheckOutDate, R.Status
                        FROM [dbo].[Reservation] R 
                        LEFT JOIN Rooms RM ON R.RoomID = RM.RoomID
                        LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                    ) AS Combined 
                    WHERE RequestID = @ID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblGuestName.Text = dr["FullName"].ToString();
                        lblEmail.Text = dr["Email"].ToString();
                        lblContact.Text = dr["Contact"].ToString();
                        lblRoomName.Text = dr["RoomName"].ToString();
                        lblDates.Text = string.Format("{0:MMM dd, yyyy} - {1:MMM dd, yyyy}",
                            Convert.ToDateTime(dr["CheckInDate"]),
                            Convert.ToDateTime(dr["CheckOutDate"]));

                        string status = dr["Status"].ToString();
                        lblStatusBadge.Text = status;
                        litCurrentStatus.Text = status;
                        ApplyStatusStyle(status);

                        bool isPending = (status.Equals("Pending", StringComparison.OrdinalIgnoreCase));
                        divActions.Visible = isPending;
                        pnlProcessed.Visible = !isPending;
                    }
                    else { Response.Redirect("ViewReservation.aspx"); }
                }
            }
        }

        protected string GetStatusBadgeHtml(string status)
        {
            string css = "";
            switch (status.ToLower())
            {
                case "approved": css = "bg-success text-white"; break;
                case "pending": css = "bg-warning text-dark"; break;
                case "waitlisted": case "waitlist": css = "bg-info text-dark"; break;
                default: css = "bg-danger text-white"; break;
            }
            return string.Format("<span class='badge {0}'>{1}</span>", css, status);
        }

        private void ApplyStatusStyle(string status)
        {
            switch (status.ToLower())
            {
                case "approved": lblStatusBadge.CssClass = "badge bg-success"; break;
                case "pending": lblStatusBadge.CssClass = "badge bg-warning text-dark"; break;
                case "waitlisted": case "waitlist": lblStatusBadge.CssClass = "badge bg-info text-dark"; break;
                default: lblStatusBadge.CssClass = "badge bg-danger"; break;
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e) => UpdateStatus("Approved");
        protected void btnReject_Click(object sender, EventArgs e) => UpdateStatus("Rejected");
        protected void btnWaitlist_Click(object sender, EventArgs e) => UpdateStatus("Waitlisted");
        protected void btnReset_Click(object sender, EventArgs e) => UpdateStatus("Pending");

        private void UpdateStatus(string newStatus)
        {
            if (Request.QueryString["RequestID"] != null)
            {
                int id = Convert.ToInt32(Request.QueryString["RequestID"]);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = @"UPDATE RoomRequests SET Status = @S WHERE RequestID = @ID;
                                   UPDATE [dbo].[Reservation] SET Status = @S WHERE ReservationID = @ID;";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@S", newStatus);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowToast("Status Updated", $"Reservation is now {newStatus}.", "success");
                LoadDetails(id);
            }
        }

        protected void btnDeleteFull_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfDeleteID.Value))
            {
                try
                {
                    int id = Convert.ToInt32(hfDeleteID.Value);
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        string sql = "DELETE FROM RoomRequests WHERE RequestID = @ID; DELETE FROM [dbo].[Reservation] WHERE ReservationID = @ID;";
                        SqlCommand cmd = new SqlCommand(sql, con);
                        cmd.Parameters.AddWithValue("@ID", id);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    // We use a small hack here: redirect after the user clicks "OK" on the success alert
                    string script = "Swal.fire('Deleted!', 'The record has been removed.', 'success').then(() => { window.location.href='ViewReservation.aspx'; });";
                    ScriptManager.RegisterStartupScript(this, GetType(), "DeleteSuccess", script, true);
                }
                catch (Exception ex)
                {
                    ShowToast("Error", "Could not delete record: " + ex.Message, "error");
                }
            }
        }

        private void ShowToast(string title, string message, string type)
        {
            string script = $"Swal.fire('{title}', '{message}', '{type}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }
    }
}