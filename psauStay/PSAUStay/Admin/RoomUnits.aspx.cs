using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace PSAUStay.Admin
{
    public partial class RoomUnits : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoomTypes();
                
                // Check if we have a roomID parameter for pre-selection
                string roomIdParam = Request.QueryString["roomID"];
                if (!string.IsNullOrEmpty(roomIdParam))
                {
                    ddlRoomTypes.SelectedValue = roomIdParam;
                    LoadRoomUnits();
                }
            }
        }

        void LoadRoomTypes()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                // Order by Name so it's easy for admin to find the category
                SqlCommand cmd = new SqlCommand("SELECT RoomID, RoomName FROM Rooms ORDER BY RoomName ASC", con);
                con.Open();

                ddlRoomTypes.DataSource = cmd.ExecuteReader();
                ddlRoomTypes.DataTextField = "RoomName";
                ddlRoomTypes.DataValueField = "RoomID";
                ddlRoomTypes.DataBind();

                ddlRoomTypes.Items.Insert(0, new ListItem("-- Select Room Category --", "0"));
            }
        }

        void LoadRoomUnits()
        {
            if (ddlRoomTypes.SelectedValue == "0")
            {
                gvRooms.DataSource = null;
                gvRooms.DataBind();
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                // We fetch the units for the specific selected room type
                SqlCommand cmd = new SqlCommand("SELECT UnitID, RoomNumber, Status FROM RoomUnits WHERE RoomID=@RoomID", con);
                cmd.Parameters.AddWithValue("@RoomID", ddlRoomTypes.SelectedValue);

                con.Open();
                gvRooms.DataSource = cmd.ExecuteReader();
                gvRooms.DataBind();
            }
        }

        protected void ddlRoomTypes_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMsg.Text = "";
            LoadRoomUnits();
        }

        protected void btnAddRoom_Click(object sender, EventArgs e)
        {
            if (ddlRoomTypes.SelectedValue == "0")
            {
                lblMsg.Text = "Please select a room type first.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrWhiteSpace(txtRoomNumber.Text))
            {
                lblMsg.Text = "Please enter a room/unit number.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                // Status is set to 'Available' by default so it shows up in Online Booking
                string query = "INSERT INTO RoomUnits (RoomID, RoomNumber, Status) VALUES (@RoomID, @RoomNumber, 'Available')";
                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@RoomID", ddlRoomTypes.SelectedValue);
                cmd.Parameters.AddWithValue("@RoomNumber", txtRoomNumber.Text.Trim());

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Unit " + txtRoomNumber.Text + " added successfully!";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            txtRoomNumber.Text = "";
            LoadRoomUnits();
        }

        protected void gvRooms_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRoom")
            {
                int unitID = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(conStr))
                {
                    // Deleting a unit here will automatically reduce the 'UnitsAvailable' 
                    // count in ManageRooms because that page counts active rows in this table.
                    SqlCommand cmd = new SqlCommand("DELETE FROM RoomUnits WHERE UnitID=@UnitID", con);
                    cmd.Parameters.AddWithValue("@UnitID", unitID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = "Unit removed successfully.";
                lblMsg.ForeColor = System.Drawing.Color.Orange;
                LoadRoomUnits();
            }
            else if (e.CommandName == "EditRoom")
            {
                int unitID = Convert.ToInt32(e.CommandArgument);
                LoadUnitForEdit(unitID);
            }
        }

        private void LoadUnitForEdit(int unitID)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT UnitID, RoomNumber, Status FROM RoomUnits WHERE UnitID=@UnitID", con);
                cmd.Parameters.AddWithValue("@UnitID", unitID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfUnitID.Value = dr["UnitID"].ToString();
                    txtEditRoomNumber.Text = dr["RoomNumber"].ToString();
                    ddlEditStatus.SelectedValue = dr["Status"].ToString();
                }
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowEditModal", "showEditModal();", true);
        }

        protected void btnUpdateUnit_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = "UPDATE RoomUnits SET RoomNumber=@RoomNumber, Status=@Status WHERE UnitID=@UnitID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UnitID", hfUnitID.Value);
                cmd.Parameters.AddWithValue("@RoomNumber", txtEditRoomNumber.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddlEditStatus.SelectedValue);
                
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Unit updated successfully!";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            LoadRoomUnits();
        }
    }
}