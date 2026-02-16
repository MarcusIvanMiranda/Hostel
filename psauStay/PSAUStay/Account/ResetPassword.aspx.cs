using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.UI;

namespace PSAUStay.Admin
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Protection: Ensure only logged-in Admins (RoleID = 1) can access this
            // If you want "Forgot Password" to be public, remove this block.
            if (Session["RoleID"] == null || Session["RoleID"].ToString() != "1")
            {
                Response.Redirect("~/Account/Login.aspx");
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(newPassword))
            {
                lblMsg.Text = "<div class='alert alert-danger'>⚠️ Please fill in all fields.</div>";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // 1. Verify user exists
                    SqlCommand checkUser = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@Email", con);
                    checkUser.Parameters.AddWithValue("@Email", email);
                    int exists = (int)checkUser.ExecuteScalar();

                    if (exists == 0)
                    {
                        lblMsg.Text = "<div class='alert alert-danger'>❌ No user account found with that email.</div>";
                        return;
                    }

                    // 2. Hash new password
                    string newSalt = GenerateSalt();
                    string newHash = HashPassword(newPassword, newSalt);

                    // 3. Update Database
                    string updateQuery = "UPDATE Users SET PasswordHash=@Hash, Salt=@Salt WHERE Email=@Email";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                    {
                        updateCmd.Parameters.AddWithValue("@Hash", newHash);
                        updateCmd.Parameters.AddWithValue("@Salt", newSalt);
                        updateCmd.Parameters.AddWithValue("@Email", email);
                        updateCmd.ExecuteNonQuery();
                    }

                    lblMsg.Text = "<div class='alert alert-success'>✅ Password successfully updated for " + email + ".</div>";
                    txtNewPassword.Text = ""; // Clear for security
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "<div class='alert alert-danger'>⚠️ System Error: " + ex.Message + "</div>";
            }
        }

        // Hashing Logic (Must match Login.aspx.cs)
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
            var saltBytes = Convert.FromBase64String(salt);
            using (var deriveBytes = new Rfc2898DeriveBytes(password, saltBytes, 10000))
            {
                byte[] hashBytes = deriveBytes.GetBytes(32);
                return Convert.ToBase64String(hashBytes);
            }
        }
    }
}