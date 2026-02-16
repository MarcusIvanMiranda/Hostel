using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.HouseKeeper
{
    public partial class ViewAllMaintenance : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAssignedStaff();
                LoadMaintenanceData();
                
                // Set default date range to last 30 days
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            }
        }

        void LoadAssignedStaff()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT DISTINCT AssignedTo FROM MaintenanceRequests WHERE AssignedTo IS NOT NULL AND AssignedTo != '' ORDER BY AssignedTo", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                
                ddlAssignedTo.DataSource = dt;
                ddlAssignedTo.DataTextField = "AssignedTo";
                ddlAssignedTo.DataValueField = "AssignedTo";
                ddlAssignedTo.DataBind();
                
                // Preserve the "All Staff" option at the top
                if (ddlAssignedTo.Items.FindByValue("") == null)
                {
                    ddlAssignedTo.Items.Insert(0, new ListItem("All Staff", ""));
                }
            }
        }

        void LoadMaintenanceData()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT 
                        mr.MaintenanceID,
                        mr.DateRequested,
                        r.RoomName as RoomCategory,
                        ru.RoomNumber,
                        mr.AssignedTo,
                        mr.IssueDescription,
                        mr.Priority,
                        mr.Status,
                        mr.CreatedBy
                    FROM MaintenanceRequests mr
                    LEFT JOIN Rooms r ON mr.RoomID = r.RoomID
                    LEFT JOIN RoomUnits ru ON mr.UnitID = ru.UnitID
                    WHERE 1=1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtStartDate.Text))
                {
                    query += " AND CAST(mr.DateRequested AS DATE) >= @StartDate";
                }
                if (!string.IsNullOrEmpty(txtEndDate.Text))
                {
                    query += " AND CAST(mr.DateRequested AS DATE) <= @EndDate";
                }
                if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                {
                    query += " AND mr.Status = @Status";
                }
                if (!string.IsNullOrEmpty(ddlPriority.SelectedValue))
                {
                    query += " AND mr.Priority = @Priority";
                }
                if (!string.IsNullOrEmpty(ddlAssignedTo.SelectedValue))
                {
                    query += " AND mr.AssignedTo = @AssignedTo";
                }

                query += " ORDER BY mr.DateRequested DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                
                // Add parameters
                if (!string.IsNullOrEmpty(txtStartDate.Text))
                {
                    cmd.Parameters.AddWithValue("@StartDate", txtStartDate.Text);
                }
                if (!string.IsNullOrEmpty(txtEndDate.Text))
                {
                    cmd.Parameters.AddWithValue("@EndDate", txtEndDate.Text);
                }
                if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                }
                if (!string.IsNullOrEmpty(ddlPriority.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
                }
                if (!string.IsNullOrEmpty(ddlAssignedTo.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@AssignedTo", ddlAssignedTo.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                
                gvMaintenance.DataSource = dt;
                gvMaintenance.DataBind();
            }
        }

        protected string GetStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "pending":
                    return "status-pending";
                case "completed":
                    return "status-completed";
                case "in progress":
                    return "status-in-progress";
                default:
                    return "status-pending";
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadMaintenanceData();
        }

        protected void gvMaintenance_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMaintenance.PageIndex = e.NewPageIndex;
            LoadMaintenanceData();
        }
    }
}
