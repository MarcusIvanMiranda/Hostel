using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace PSAUStay.Account
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        string conn = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

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
                LoadRoles();
                LoadUsers();
            }
        }

        // ===============================
        // LOAD ROLES DROPDOWN
        // ===============================
        private void LoadRoles()
        {
            using (SqlConnection con = new SqlConnection(conn))
            {
                string query = "Select AccessLevelID,AccessLevelName from AccessLevels";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                ddlRole.DataSource = cmd.ExecuteReader();
                ddlRole.DataTextField = "AccessLevelName";
                ddlRole.DataValueField = "AccessLevelID";
                ddlRole.DataBind();
            }
        }



        // ===============================
        // LOAD USERS GRID
        // ===============================
        private void LoadUsers()
        {
            using (SqlConnection con = new SqlConnection(conn))
            {
                string query = @"SELECT U.UserId, U.FullName, U.Email, R.AccessLevelName
                                    FROM Users U
                                    LEFT JOIN AccessLevels R 
                                    ON U.Role = R.AccessLevelID";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                gvUsers.DataSource = cmd.ExecuteReader();
                gvUsers.DataBind();
            }
        }


        // ===============================
        // ADD USER BUTTON CLICK
        // ===============================
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            lblModalTitle.Text = "Add User";
            ClearFields();
            pnlModal.Visible = true;
        }


        // ===============================
        // SAVE USER (ADD OR UPDATE)
        // ===============================
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            int roleId = int.Parse(ddlRole.SelectedValue);

            using (SqlConnection con = new SqlConnection(conn))
            {
                if (ViewState["EditUserId"] == null)
                {
                    // CREATE NEW USER
                    string salt = GenerateSalt();
                    string passwordHash = HashPassword(txtPassword.Text, salt);

                    string query = @"INSERT INTO Users (FullName, Email, PasswordHash, Salt, Role)
                                     VALUES (@FullName, @Email, @PasswordHash, @Salt, @Role)";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                    cmd.Parameters.AddWithValue("@Salt", salt);
                    cmd.Parameters.AddWithValue("@Role", roleId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    // UPDATE USER (NO password change)
                    int userId = (int)ViewState["EditUserId"];

                    string query = @"UPDATE Users
                                     SET FullName=@FullName, Email=@Email, Role=@Role
                                     WHERE UserId=@UserId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", roleId);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            pnlModal.Visible = false;
            LoadUsers();
        }


        // ===============================
        // GRID BUTTON HANDLER (EDIT/DELETE)
        // ===============================
        protected void gvUsers_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                LoadUserForEdit(userId);
            }
            else if (e.CommandName == "DeleteUser")
            {
                DeleteUser(userId);
                LoadUsers();
            }
        }


        // ===============================
        // LOAD USER FOR EDIT
        // ===============================
        private void LoadUserForEdit(int userId)
        {
            using (SqlConnection con = new SqlConnection(conn))
            {
                string query = "SELECT * FROM Users WHERE UserId=@UserId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    ViewState["EditUserId"] = userId;
                    lblModalTitle.Text = "Edit User";

                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    ddlRole.SelectedValue = reader["Role"].ToString();

                    txtPassword.Enabled = false;  // password not editable here

                    pnlModal.Visible = true;
                }
            }
        }


        // ===============================
        // DELETE USER
        // ===============================
        private void DeleteUser(int userId)
        {
            using (SqlConnection con = new SqlConnection(conn))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Users WHERE UserId=@UserId", con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }


        // ===============================
        // CANCEL BUTTON
        // ===============================
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlModal.Visible = false;
            ClearFields();
        }


        // ===============================
        // CLEAR ALL FIELDS
        // ===============================
        private void ClearFields()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtPassword.Enabled = true;
            ViewState["EditUserId"] = null;
        }


        // ===============================
        // PASSWORD HASHING METHODS
        // ===============================

        public static string GenerateSalt()
        {
            byte[] saltBytes = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        public static string HashPassword(string password, string salt)
        {
            var saltBytes = Convert.FromBase64String(salt);
            using (var deriveBytes = new Rfc2898DeriveBytes(password, saltBytes, 10000))
            {
                byte[] hashBytes = deriveBytes.GetBytes(32);
                return Convert.ToBase64String(hashBytes);
            }
        }
    }
}