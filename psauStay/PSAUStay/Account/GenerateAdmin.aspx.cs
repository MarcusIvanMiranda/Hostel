using System;
using System.Data.SqlClient;
using System.Configuration;

namespace PSAUStay.Account
{
    public partial class GenerateAdmin : System.Web.UI.Page
    {
        protected void btnRun_Click(object sender, EventArgs e)
        {
            string salt = Login.GenerateSalt();
            string hash = Login.HashPassword("Admin@123", salt);

            lblResult.Text = $"<b>Salt:</b> {salt}<br/><b>Hash:</b> {hash}";

            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string sql = "INSERT INTO Users (FullName, Email, PasswordHash, Salt, Role) VALUES (@FullName, @Email, @PasswordHash, @Salt, @Role)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", "Administrator");
                    cmd.Parameters.AddWithValue("@Email", "admin@psaustay.edu.ph");
                    cmd.Parameters.AddWithValue("@PasswordHash", hash);
                    cmd.Parameters.AddWithValue("@Salt", salt);
                    cmd.Parameters.AddWithValue("@Role", "Admin");
                    cmd.ExecuteNonQuery();
                }
            }

            lblResult.Text += "<br/><br/>✅ Admin user successfully inserted!";
        }
    }
}
