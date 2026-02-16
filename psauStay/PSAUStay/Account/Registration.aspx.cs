using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace PSAUStay.Account
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAccessLevels();
            }
        }

        private void LoadAccessLevels()
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT AccessLevelID, AccessLevelName FROM AccessLevels ORDER BY AccessLevelName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    ddlAccessLevel.DataSource = rdr;
                    ddlAccessLevel.DataValueField = "AccessLevelID";
                    ddlAccessLevel.DataTextField = "AccessLevelName";
                    ddlAccessLevel.DataBind();
                    ddlAccessLevel.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Access Level --", "0"));
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text.Trim();
            int accessLevelId = int.Parse(ddlAccessLevel.SelectedValue); // gets selected AccessLevelID

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || accessLevelId == 0)
            {
                lblMsg.Text = "⚠️ All fields are required.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Check if email exists
                    using (SqlCommand checkEmail = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@Email", con))
                    {
                        checkEmail.Parameters.AddWithValue("@Email", email);
                        int exists = (int)checkEmail.ExecuteScalar();
                        if (exists > 0)
                        {
                            lblMsg.Text = "⚠️ Email already registered.";
                            lblMsg.ForeColor = System.Drawing.Color.Red;
                            return;
                        }
                    }

                    // Generate Salt & Hash
                    string salt = GenerateSalt();
                    string hashedPassword = HashPassword(password, salt);

                    // Insert user with AccessLevelID
                    string query = @"INSERT INTO Users (FullName, Email, PasswordHash, Salt, Role, DateCreated)
                                     VALUES (@FullName, @Email, @PasswordHash, @Salt,
                                             (SELECT AccessLevelName FROM AccessLevels WHERE AccessLevelID=@AccessLevelID),
                                             GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                        cmd.Parameters.AddWithValue("@Salt", salt);
                        cmd.Parameters.AddWithValue("@AccessLevelID", accessLevelId);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblMsg.Text = "✅ Registration successful! Redirecting to Login...";
                lblMsg.ForeColor = System.Drawing.Color.Green;

                txtFullName.Text = "";
                txtEmail.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";

                ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                    "setTimeout(function(){ window.location='Login.aspx'; }, 2500);", true);
            }
            catch (Exception ex)
            {
                lblMsg.Text = "❌ Error: " + ex.Message;
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

        private string GenerateSalt()
        {
            byte[] saltBytes = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        private string HashPassword(string password, string salt)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password + salt);
                byte[] hashBytes = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hashBytes);
            }
        }
    }
}
