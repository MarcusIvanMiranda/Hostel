using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace PSAUStay
{
    public partial class Booking : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRooms();
                LoadFacilities();
            }
        }

        private void LoadRooms()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "SELECT * FROM Rooms WHERE IsAvailable = 1";
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptRooms.DataSource = dt;
                    rptRooms.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Room Error: " + ex.Message);
            }
        }

        private void LoadFacilities()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Check your database: If 'IsAvailable' column doesn't exist, change this to 'WHERE 1=1'
                    string query = "SELECT * FROM Facilities WHERE IsAvailable = 1";

                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptFacilities.DataSource = dt;
                        rptFacilities.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                // This will show in your Visual Studio Output window if the table/column name is wrong
                System.Diagnostics.Debug.WriteLine("Facility Error: " + ex.Message);
            }
        }
    }
}