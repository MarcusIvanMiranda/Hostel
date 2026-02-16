using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class ManageRooms : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadRooms();
        }

        private void LoadRooms()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        r.RoomID,
                        r.RoomName,
                        r.RoomType,
                        r.Capacity,
                        r.Price,
                        r.IsAvailable,
                        (SELECT COUNT(*) FROM RoomUnits u 
                         WHERE u.RoomID = r.RoomID AND u.Status='Available') AS UnitsAvailable
                    FROM Rooms r
                    ORDER BY r.RoomName";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRooms.DataSource = dt;
                gvRooms.DataBind();
            }
        }

        protected void gvRooms_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;

            int roomId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRoom")
            {
                Response.Redirect($"EditRoom.aspx?roomID={roomId}");
            }
            else if (e.CommandName == "DeleteRoom")
            {
                DeleteRoom(roomId);
            }
            else if (e.CommandName == "ViewUnits")
            {
                Response.Redirect($"RoomUnits.aspx?roomID={roomId}");
            }
        }

        private void LoadRoomDetails(int roomId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Rooms WHERE RoomID=@RoomID", con);
                    cmd.Parameters.AddWithValue("@RoomID", roomId);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfRoomID.Value = dr["RoomID"].ToString();
                        txtRoomName.Text = dr["RoomName"]?.ToString() ?? "";
                        txtRoomType.Text = dr["RoomType"]?.ToString() ?? "";
                        txtDescription.Text = dr["RoomDescription"]?.ToString() ?? "";
                        txtFeatures.Text = dr["Features"]?.ToString() ?? "";
                        txtCapacity.Text = dr["Capacity"]?.ToString() ?? "1";
                        txtPrice.Text = dr["Price"] != null ? string.Format("{0:F2}", dr["Price"]) : "0.00";
                        chkAvailable.Checked = dr["IsAvailable"] != null && Convert.ToBoolean(dr["IsAvailable"]);
                    }
                    dr.Close();
                }
                catch (Exception ex)
                {
                    ShowToast("Error", "Failed to load room details: " + ex.Message, "error");
                    return;
                }
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowEditModal", "showEditModal();", true);
        }

        protected void btnUpdateRoom_Click(object sender, EventArgs e)
        {
            try
            {
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
                            IsAvailable=@IsAvailable
                        WHERE RoomID=@RoomID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@RoomID", hfRoomID.Value);
                        cmd.Parameters.AddWithValue("@RoomName", txtRoomName.Text.Trim());
                        cmd.Parameters.AddWithValue("@RoomType", txtRoomType.Text.Trim());
                        cmd.Parameters.AddWithValue("@RoomDescription", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Features", txtFeatures.Text.Trim());
                        cmd.Parameters.AddWithValue("@Capacity", int.Parse(txtCapacity.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtPrice.Text.Trim()));
                        cmd.Parameters.AddWithValue("@IsAvailable", chkAvailable.Checked);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Success Popup
                ShowToast("Updated!", "Room category updated successfully.", "success");
                LoadRooms();
            }
            catch (Exception ex)
            {
                ShowToast("Error", ex.Message, "error");
            }
        }

        protected void btnAddRoom_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AddRoom.aspx");
        }

        private void DeleteRoom(int roomId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmdUnits = new SqlCommand("DELETE FROM RoomUnits WHERE RoomID=@RoomID", con);
                    cmdUnits.Parameters.AddWithValue("@RoomID", roomId);
                    cmdUnits.ExecuteNonQuery();

                    SqlCommand cmdRoom = new SqlCommand("DELETE FROM Rooms WHERE RoomID=@RoomID", con);
                    cmdRoom.Parameters.AddWithValue("@RoomID", roomId);
                    cmdRoom.ExecuteNonQuery();
                }

                ShowToast("Deleted!", "Room category and units removed.", "success");
                LoadRooms();
            }
            catch (Exception ex)
            {
                ShowToast("Error", "Could not delete: " + ex.Message, "error");
            }
        }

        // Helper method to trigger SweetAlert from C#
        private void ShowToast(string title, string message, string type)
        {
            string script = $"Swal.fire('{title}', '{message}', '{type}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerAction", script, true);
        }
    }
}