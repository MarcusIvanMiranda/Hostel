using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace PSAUStay
{
    public partial class DefaultPage : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRooms();
                LoadFacilities();
                ExpirePendingRequests();
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = @"UPDATE RoomRequests 
                 SET Status='Expired'
                 WHERE Status='Pending'
                 AND ExpiresAt < GETDATE()";

                SqlCommand cmd = new SqlCommand(q, con);
                con.Open();
                cmd.ExecuteNonQuery();
            }

        }

        private void LoadFacilities()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT FacilityID, FacilityName, FacilityDescription, FacilityType, Capacity, Price, Image1, Image2, Image3
                         FROM Facilities
                         WHERE IsAvailable = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptFacilities.DataSource = dt;
                    rptFacilities.DataBind();
                }
            }
        }

        private void ExpirePendingRequests()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"UPDATE RoomRequests 
                                 SET Status='Expired'
                                 WHERE Status='Pending'
                                   AND ExpiresAt < GETDATE()";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private void LoadRooms()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT RoomID, RoomName, RoomDescription, RoomType, Capacity, Price, Image1, Image2, Image3, Image4, Image5 
                 FROM Rooms 
                 WHERE IsAvailable = 1";


                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptRooms.DataSource = dt;
                    rptRooms.DataBind();
                }
            }
        }
        protected bool HasImage(object img)
        {
            return img != DBNull.Value && !string.IsNullOrEmpty(img?.ToString());
        }


    }
}
