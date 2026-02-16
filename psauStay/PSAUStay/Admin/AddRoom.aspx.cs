using System;
using System.Data.SqlClient;
using System.Configuration;

namespace PSAUStay.Admin
{
    public partial class AddRoom : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["RoomID"] != null)
            {
                int roomId = int.Parse(Request.QueryString["RoomID"]);
                LoadRoomData(roomId);
            }
        }

        private void LoadRoomData(int roomId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Rooms WHERE RoomID = @RoomID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@RoomID", roomId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtRoomName.Text = dr["RoomName"].ToString();
                    txtType.Text = dr["RoomType"].ToString();
                    txtDescription.Text = dr["RoomDescription"].ToString(); // Fix column name
                    txtFeatures.Text = dr["Features"].ToString();
                    txtCapacity.Text = dr["Capacity"].ToString();
                    txtPrice.Text = dr["Price"].ToString();
                    chkAvailable.Checked = Convert.ToBoolean(dr["IsAvailable"]);
                }
                dr.Close();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string roomName = txtRoomName.Text.Trim();
            string roomType = txtType.Text.Trim();
            string description = txtDescription.Text.Trim();
            string features = txtFeatures.Text.Trim();
            int capacity = int.Parse(txtCapacity.Text);
            decimal price = decimal.Parse(txtPrice.Text);
            bool isAvailable = chkAvailable.Checked;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd;

                    if (Request.QueryString["RoomID"] != null)
                    {
                        cmd = new SqlCommand(@"
                            UPDATE Rooms 
                            SET RoomName=@RoomName, RoomType=@RoomType, RoomDescription=@Description, Features=@Features,
                                Capacity=@Capacity, Price=@Price, IsAvailable=@IsAvailable
                            WHERE RoomID=@RoomID", conn);
                        cmd.Parameters.AddWithValue("@RoomID", Request.QueryString["RoomID"]);
                    }
                    else
                    {
                        cmd = new SqlCommand(@"
                            INSERT INTO Rooms (RoomName, RoomType, RoomDescription, Features, Capacity, Price, IsAvailable)
                            VALUES (@RoomName, @RoomType, @Description, @Features, @Capacity, @Price, @IsAvailable)", conn);
                    }

                    cmd.Parameters.AddWithValue("@RoomName", roomName);
                    cmd.Parameters.AddWithValue("@RoomType", roomType);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@Features", features);
                    cmd.Parameters.AddWithValue("@Capacity", capacity);
                    cmd.Parameters.AddWithValue("@Price", price);
                    cmd.Parameters.AddWithValue("@IsAvailable", isAvailable);

                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Room saved successfully!";
                lblMessage.CssClass = "text-success fw-bold";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        protected void btnAddRoom_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddRoom.aspx");
        }
    }
}
