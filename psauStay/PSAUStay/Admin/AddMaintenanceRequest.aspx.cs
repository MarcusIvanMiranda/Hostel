using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class AddMaintenance : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRooms();
                LoadHousekeepers();
            }
        }

        void LoadRooms()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT RoomID, RoomName FROM Rooms ORDER BY RoomName", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlRooms.DataSource = dt;
                ddlRooms.DataBind();
                ddlRooms.Items.Insert(0, new ListItem("-- Select Room Category --", ""));
            }
        }

        protected void ddlRooms_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlUnits.Items.Clear();
            if (string.IsNullOrEmpty(ddlRooms.SelectedValue)) return;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT UnitID, RoomNumber FROM RoomUnits WHERE RoomID = @RoomID AND Status = 'Available'";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@RoomID", ddlRooms.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlUnits.DataSource = dt;
                ddlUnits.DataBind();

                if (dt.Rows.Count > 0)
                    ddlUnits.Items.Insert(0, new ListItem("-- Select Unit --", ""));
                else
                    ddlUnits.Items.Insert(0, new ListItem("No available units found", ""));
            }
        }

        void LoadHousekeepers()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT FullName FROM Users WHERE Role = 7", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlHousekeepers.DataSource = dt;
                ddlHousekeepers.DataBind();
                ddlHousekeepers.Items.Insert(0, new ListItem("-- Select Staff --", ""));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlHousekeepers.SelectedValue) || string.IsNullOrEmpty(ddlUnits.SelectedValue) || ddlUnits.SelectedIndex == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select both a unit and a housekeeper.');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlTransaction transaction = con.BeginTransaction();

                try
                {
                    string adminName = Session["FullName"]?.ToString() ?? "Admin";
                    string roomCategory = ddlRooms.SelectedItem.Text;
                    string roomNum = ddlUnits.SelectedItem.Text;
                    string staff = ddlHousekeepers.SelectedValue;

                    // UPDATED LOG FORMAT: Maintenance assigned for [Employee] is [Room Name] [Room Number] by [Admin]
                    string log = $"[{DateTime.Now:yyyy-MM-dd HH:mm}] Maintenance assigned for {staff} is {roomCategory} {roomNum} by {adminName}.";

                    string queryReq = @"INSERT INTO MaintenanceRequests 
                                    (RoomID, UnitID, RequestorName, IssueDescription, Priority, Status, AssignedTo, DateRequested, CreatedBy, Notes) 
                                    VALUES (@RoomID, @UnitID, @Req, @Desc, @Pri, 'Pending', @Assign, GETDATE(), @Admin, @Log)";

                    SqlCommand cmdReq = new SqlCommand(queryReq, con, transaction);
                    cmdReq.Parameters.AddWithValue("@RoomID", ddlRooms.SelectedValue);
                    cmdReq.Parameters.AddWithValue("@UnitID", ddlUnits.SelectedValue);
                    cmdReq.Parameters.AddWithValue("@Req", adminName);
                    cmdReq.Parameters.AddWithValue("@Desc", txtIssue.Text.Trim());
                    cmdReq.Parameters.AddWithValue("@Pri", ddlPriority.SelectedValue);
                    cmdReq.Parameters.AddWithValue("@Assign", staff);
                    cmdReq.Parameters.AddWithValue("@Admin", adminName);
                    cmdReq.Parameters.AddWithValue("@Log", log);
                    cmdReq.ExecuteNonQuery();

                    string queryUnit = "UPDATE RoomUnits SET Status = 'Maintenance' WHERE UnitID = @UnitID";
                    SqlCommand cmdUnit = new SqlCommand(queryUnit, con, transaction);
                    cmdUnit.Parameters.AddWithValue("@UnitID", ddlUnits.SelectedValue);
                    cmdUnit.ExecuteNonQuery();

                    transaction.Commit();
                    Response.Redirect("Maintenance.aspx");
                }
                catch (Exception ex)
                {
                    if (transaction != null && transaction.Connection != null) transaction.Rollback();
                    string msg = ex.Message.Replace("'", "\"");
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error: {msg}');", true);
                }
            }
        }
    }
}