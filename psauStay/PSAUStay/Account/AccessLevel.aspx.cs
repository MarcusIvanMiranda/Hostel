using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace PSAUStay.Account
{
    public partial class AccessLevel : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Check if user is Admin (RoleID = 1)
            int userRoleID = Convert.ToInt32(Session["RoleID"]);
            if (userRoleID != 1)
            {
                Response.Redirect("~/AccessDenied.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindAccessLevels();
            }
        }

        private void BindAccessLevels()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM AccessLevels ORDER BY AccessLevelName", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAccessLevels.DataSource = dt;
                gvAccessLevels.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAccessLevelName.Text))
            {
                lblMessage.Text = "Access Level Name is required.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO AccessLevels (AccessLevelName, Description) VALUES (@Name, @Desc)", con);
                cmd.Parameters.AddWithValue("@Name", txtAccessLevelName.Text.Trim());
                cmd.Parameters.AddWithValue("@Desc", txtDescription.Text.Trim());
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Access Level added successfully.";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            txtAccessLevelName.Text = "";
            txtDescription.Text = "";

            BindAccessLevels();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtAccessLevelName.Text = "";
            txtDescription.Text = "";
            lblMessage.Text = "";
        }

        protected void gvAccessLevels_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvAccessLevels.EditIndex = e.NewEditIndex;
            BindAccessLevels();
        }

        protected void gvAccessLevels_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvAccessLevels.EditIndex = -1;
            BindAccessLevels();
        }

        protected void gvAccessLevels_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvAccessLevels.Rows[e.RowIndex];
            int id = Convert.ToInt32(gvAccessLevels.DataKeys[e.RowIndex].Value);

            string name = ((TextBox)row.FindControl("txtNameEdit")).Text.Trim();
            string desc = ((TextBox)row.FindControl("txtDescEdit")).Text.Trim();

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("UPDATE AccessLevels SET AccessLevelName=@Name, Description=@Desc WHERE AccessLevelID=@ID", con);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Desc", desc);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvAccessLevels.EditIndex = -1;
            BindAccessLevels();
            lblMessage.Text = "Access Level updated successfully.";
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }

        protected void gvAccessLevels_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvAccessLevels.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM AccessLevels WHERE AccessLevelID=@ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindAccessLevels();
            lblMessage.Text = "Access Level deleted successfully.";
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }

        protected void gvAccessLevels_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Only allow admin to see the Delete button
                if (Session["RoleID"] == null || Convert.ToInt32(Session["RoleID"]) != 1)
                {
                    // Loop through controls in the last cell (Actions)
                    TableCell actionsCell = e.Row.Cells[e.Row.Cells.Count - 1];
                    foreach (Control ctrl in actionsCell.Controls)
                    {
                        Button btn = ctrl as Button;
                        if (btn != null && btn.CommandName == "Delete")
                        {
                            btn.Visible = false;
                        }
                    }
                }
            }
        }


    }
}
