using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace PSAUStay.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Page Load logic
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMsg.Visible = true;
                lblMsg.Text = "⚠️ Please enter both email and password.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Fetch user info including salt + hash
                    string query = @"SELECT UserID, FullName, Role, PasswordHash, Salt 
                                     FROM Users WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedHash = reader["PasswordHash"]?.ToString();
                                string storedSalt = reader["Salt"]?.ToString();

                                // Check for empty/null stored values
                                if (string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(storedSalt))
                                {
                                    lblMsg.Visible = true;
                                    lblMsg.Text = "⚠️ Account not properly initialized. Please contact admin.";
                                    return;
                                }

                                // ✅ Verify password using PBKDF2
                                if (VerifyPassword(password, storedSalt, storedHash))
                                {
                                    Session["UserID"] = reader["UserID"].ToString();
                                    Session["FullName"] = reader["FullName"].ToString();

                                    int roleID = 0;
                                    if (reader["Role"] != DBNull.Value)
                                    {
                                        roleID = Convert.ToInt32(reader["Role"]);
                                    }
                                    Session["RoleID"] = roleID;
                                    Session["UserEmail"] = email;

                                    // Check if user was redirected from another page
                                    string returnUrl = Request.QueryString["ReturnUrl"];

                                    if (!string.IsNullOrEmpty(returnUrl))
                                    {
                                        Response.Redirect(returnUrl, false);
                                        Context.ApplicationInstance.CompleteRequest();
                                    }
                                    else
                                    {
                                        // Updated redirection logic based on Access Level IDs
                                        switch (roleID)
                                        {
                                            case 1: // Admin
                                                Response.Redirect("~/Admin/Dashboard");
                                                break;
                                            case 2: // Staff Clerk
                                                Response.Redirect("~/Admin/Dashboard");
                                                break;
                                            case 3: // Housekeeping Admin
                                                Response.Redirect("~/HouseKeeper/HouseKeeperDashboard.aspx");
                                                break;
                                            case 7: // Housekeeping Staff
                                                Response.Redirect("~/HouseKeeper/Maintenance.aspx");
                                                break;
                                            default:
                                                Response.Redirect("~/Default.aspx");
                                                break;
                                        }
                                    }
                                }
                                else
                                {
                                    lblMsg.Visible = true;
                                    lblMsg.Text = "❌ Invalid email or password.";
                                }
                            }
                            else
                            {
                                lblMsg.Visible = true;
                                lblMsg.Text = "❌ Invalid email or password.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "⚠️ Error: " + ex.Message;
            }
        }

        // 🧂 Generate Salt (for Registration)
        public static string GenerateSalt()
        {
            byte[] saltBytes = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        // 🔐 PBKDF2 Hashing
        public static string HashPassword(string password, string salt)
        {
            var saltBytes = Convert.FromBase64String(salt);
            using (var deriveBytes = new Rfc2898DeriveBytes(password, saltBytes, 10000))
            {
                byte[] hashBytes = deriveBytes.GetBytes(32); // 256-bit hash
                return Convert.ToBase64String(hashBytes);
            }
        }

        // ✅ Verify Password
        public static bool VerifyPassword(string password, string salt, string storedHash)
        {
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(salt) || string.IsNullOrEmpty(storedHash))
                return false;

            string computedHash = HashPassword(password, salt);
            return SlowEquals(Convert.FromBase64String(storedHash), Convert.FromBase64String(computedHash));
        }

        // 🧠 Prevent timing attacks
        private static bool SlowEquals(byte[] a, byte[] b)
        {
            uint diff = (uint)a.Length ^ (uint)b.Length;
            for (int i = 0; i < a.Length && i < b.Length; i++)
                diff |= (uint)(a[i] ^ b[i]);
            return diff == 0;
        }
    }
}