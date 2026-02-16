using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay.Admin
{
    public partial class RoomList : System.Web.UI.Page
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
                SqlCommand cmd = new SqlCommand("SELECT * FROM Rooms ORDER BY DateCreated DESC", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRooms.DataSource = dt;
                gvRooms.DataBind();
            }
        }

        protected void gvRooms_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int roomId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRoom")
            {
                Response.Redirect("~/Admin/AddRoom.aspx?RoomID=" + roomId);
            }
            else if (e.CommandName == "DeleteRoom")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("DELETE FROM Rooms WHERE RoomID=@RoomID", con);
                    cmd.Parameters.AddWithValue("@RoomID", roomId);
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = "Room deleted successfully.";
                LoadRooms();
            }
        }

        protected void gvRooms_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Optional: visually dim unavailable rooms
                bool isAvailable = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsAvailable"));
                if (!isAvailable)
                {
                    e.Row.Style["opacity"] = "0.6";
                }
            }
        }
    }
}
