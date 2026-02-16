using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class EditRoom : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        HiddenField[] hfOldImages;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Initialize hidden field array
            hfOldImages = new HiddenField[] { hfOldImage1, hfOldImage2, hfOldImage3, hfOldImage4, hfOldImage5 };

            if (!IsPostBack)
            {
                int roomId = 0;

                // Get RoomID from route or query string
                if (Page.RouteData.Values["RoomID"] != null)
                    roomId = Convert.ToInt32(Page.RouteData.Values["RoomID"]);
                else if (Request.QueryString["RoomID"] != null)
                    roomId = Convert.ToInt32(Request.QueryString["RoomID"]);

                if (roomId > 0)
                    LoadRoom(roomId);
                else
                    Response.Redirect("~/Admin/ManageRooms.aspx");
            }
        }

        private void LoadRoom(int roomId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Rooms WHERE RoomID=@RoomID", con);
                cmd.Parameters.AddWithValue("@RoomID", roomId);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfRoomID.Value = dr["RoomID"].ToString();
                    txtRoomName.Text = dr["RoomName"].ToString();
                    txtRoomType.Text = dr["RoomType"].ToString();
                    txtDescription.Text = dr["RoomDescription"].ToString();
                    txtFeatures.Text = dr["Features"].ToString();
                    txtCapacity.Text = dr["Capacity"].ToString();
                    txtPrice.Text = dr["Price"].ToString();
                    chkAvailable.Checked = Convert.ToBoolean(dr["IsAvailable"]);

                    // Populate hidden fields for old images
                    hfOldImages[0].Value = dr["Image1"]?.ToString();
                    hfOldImages[1].Value = dr["Image2"]?.ToString();
                    hfOldImages[2].Value = dr["Image3"]?.ToString();
                    hfOldImages[3].Value = dr["Image4"]?.ToString();
                    hfOldImages[4].Value = dr["Image5"]?.ToString();
                }
                dr.Close();
            }
        }

        protected void btnUpdateRoom_Click(object sender, EventArgs e)
        {
            int roomId = int.Parse(hfRoomID.Value);

            // Directory to save images
            string uploadPath = Server.MapPath("~/RoomImages/");

            // Ensure folder exists
            if (!System.IO.Directory.Exists(uploadPath))
                System.IO.Directory.CreateDirectory(uploadPath);

            // Prepare file paths
            string[] imageFiles = new string[5];
            FileUpload[] uploads = { fuImage1, fuImage2, fuImage3, fuImage4, fuImage5 };

            for (int i = 0; i < uploads.Length; i++)
            {
                if (uploads[i].HasFile)
                {
                    string ext = System.IO.Path.GetExtension(uploads[i].FileName);
                    string fileName = $"Room_{roomId}_{i + 1}{ext}";
                    uploads[i].SaveAs(System.IO.Path.Combine(uploadPath, fileName));
                    imageFiles[i] = "/RoomImages/" + fileName;
                }
                else
                {
                    // Keep old image if no new upload
                    imageFiles[i] = hfOldImages[i].Value;
                }
            }

            // Update room in database
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE Rooms SET
                        RoomName=@RoomName,
                        RoomType=@RoomType,
                        RoomDescription=@RoomDescription,
                        Features=@Features,
                        Capacity=@Capacity,
                        Price=@Price,
                        IsAvailable=@IsAvailable,
                        Image1=@Image1,
                        Image2=@Image2,
                        Image3=@Image3,
                        Image4=@Image4,
                        Image5=@Image5
                    WHERE RoomID=@RoomID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@RoomID", roomId);
                cmd.Parameters.AddWithValue("@RoomName", txtRoomName.Text.Trim());
                cmd.Parameters.AddWithValue("@RoomType", txtRoomType.Text.Trim());
                cmd.Parameters.AddWithValue("@RoomDescription", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Features", txtFeatures.Text.Trim());
                cmd.Parameters.AddWithValue("@Capacity", int.Parse(txtCapacity.Text.Trim()));
                cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtPrice.Text.Trim()));
                cmd.Parameters.AddWithValue("@IsAvailable", chkAvailable.Checked);

                for (int i = 0; i < 5; i++)
                    cmd.Parameters.AddWithValue($"@Image{i + 1}", (object)imageFiles[i] ?? DBNull.Value);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("ManageRooms.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageRooms.aspx");
        }
    }
}
