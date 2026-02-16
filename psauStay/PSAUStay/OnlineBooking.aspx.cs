using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Net.Sockets;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay
{
    public partial class OnlineBooking : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoomTypes();
                
                // Check if RoomID is passed from Booking.aspx
                if (Request.QueryString["RoomID"] != null)
                {
                    string roomId = Request.QueryString["RoomID"];
                    if (!string.IsNullOrEmpty(roomId))
                    {
                        // Set the selected room
                        ddlRoomType.SelectedValue = roomId;
                        
                        // Load the room details and units
                        int roomID = int.Parse(roomId);
                        LoadPreviewAndUnits(roomID);
                    }
                }
            }
        }

        private void LoadRoomTypes()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // We only show rooms that are set to "IsAvailable" by Admin AND have at least one available unit
                string query = @"SELECT DISTINCT r.RoomID, r.RoomName 
                                FROM Rooms r 
                                INNER JOIN RoomUnits ru ON r.RoomID = ru.RoomID 
                                WHERE r.IsAvailable = 1 AND ru.Status = 'Available' 
                                ORDER BY r.RoomName";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                ddlRoomType.DataSource = cmd.ExecuteReader();
                ddlRoomType.DataTextField = "RoomName";
                ddlRoomType.DataValueField = "RoomID";
                ddlRoomType.DataBind();
                ddlRoomType.Items.Insert(0, new ListItem("-- Select Room Category --", "0"));
            }
        }

        protected void ddlRoomType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlRoomType.SelectedValue == "0")
            {
                ResetUI();
                return;
            }
            int roomID = int.Parse(ddlRoomType.SelectedValue);
            LoadPreviewAndUnits(roomID);
        }

        private void LoadPreviewAndUnits(int roomID)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // 1. Load Room Details (Image, Price, Description)
                SqlCommand cmd = new SqlCommand("SELECT RoomName, Image1, RoomDescription, Price FROM Rooms WHERE RoomID=@ID", con);
                cmd.Parameters.AddWithValue("@ID", roomID);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    roomPreviewPanel.Visible = true;
                    pnlPlaceholder.Visible = false;
                    imgMainPreview.ImageUrl = dr["Image1"].ToString();
                    litRoomDescription.Text = dr["RoomDescription"].ToString();
                    litPriceOverlay.Text = Convert.ToDecimal(dr["Price"]).ToString("N0");
                    ViewState["PricePerNight"] = dr["Price"];
                    Session["RoomName"] = dr["RoomName"].ToString(); // Store room name in session
                }
                dr.Close();

                // 2. Load Specific Room Numbers that are STATUS = 'Available'
                // This ensures booked rooms (status='Booked') do not show in the selection
                SqlCommand cmdUnits = new SqlCommand("SELECT UnitID, RoomNumber FROM RoomUnits WHERE RoomID=@ID AND Status='Available'", con);
                cmdUnits.Parameters.AddWithValue("@ID", roomID);
                SqlDataAdapter da = new SqlDataAdapter(cmdUnits);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Show the count of how many units are actually left
                litAvailableCount.Text = dt.Rows.Count.ToString();

                if (dt.Rows.Count > 0)
                {
                    ddlRoomNumber.DataSource = dt;
                    ddlRoomNumber.DataTextField = "RoomNumber";
                    ddlRoomNumber.DataValueField = "UnitID";
                    ddlRoomNumber.DataBind();
                    ddlRoomNumber.Items.Insert(0, new ListItem("-- Select Room No. --", "0"));

                    pnlRoomNumber.Visible = true;
                    pnlInputs.Enabled = true;
                    lblAvailabilityMsg.Visible = false;
                }
                else
                {
                    // 3. Logic for when no units are left
                    pnlRoomNumber.Visible = false;
                    pnlInputs.Enabled = false;
                    lblAvailabilityMsg.Text = "⚠️ There's no available unit on that room category.";
                    lblAvailabilityMsg.Visible = true;
                    pnlPriceSummary.Visible = false;
                }
            }
            CalculateTotal(null, null);
        }

        protected void CalculateTotal(object sender, EventArgs e)
        {
            DateTime checkIn, checkOut;
            if (DateTime.TryParse(txtCheckIn.Text, out checkIn) && DateTime.TryParse(txtCheckOut.Text, out checkOut))
            {
                if (checkOut > checkIn && ViewState["PricePerNight"] != null)
                {
                    int days = (checkOut - checkIn).Days;
                    decimal total = Convert.ToDecimal(ViewState["PricePerNight"]) * days;
                    litTotalPrice.Text = total.ToString("N2");
                    pnlPriceSummary.Visible = true;
                }
                else
                {
                    pnlPriceSummary.Visible = false;
                }
            }
        }

        protected void cvEmailValid_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string email = args.Value.Trim();
            
            try
            {
                // Basic format validation (already done by RegexValidator but double-checking)
                var addr = new System.Net.Mail.MailAddress(email);
                if (addr.Address != email)
                {
                    args.IsValid = false;
                    return;
                }

                // Check if domain has MX records (email server)
                string domain = email.Split('@')[1];
                if (!IsValidDomain(domain))
                {
                    args.IsValid = false;
                    return;
                }

                // Optional: Basic SMTP verification (commented out for performance)
                // if (!IsEmailDeliverable(email))
                // {
                //     args.IsValid = false;
                //     return;
                // }

                args.IsValid = true;
            }
            catch
            {
                args.IsValid = false;
            }
        }

        private bool IsValidDomain(string domain)
        {
            try
            {
                // Check if domain resolves to IP address
                IPHostEntry host = Dns.GetHostEntry(domain);
                return host != null && host.AddressList.Length > 0;
            }
            catch
            {
                return false;
            }
        }

        private bool IsEmailDeliverable(string email)
        {
            try
            {
                string[] parts = email.Split('@');
                string domain = parts[1];
                
                // Get MX records for the domain
                IPHostEntry hostInfo = Dns.GetHostEntry(domain);
                
                // Try to connect to SMTP server (basic check)
                using (var tcpClient = new System.Net.Sockets.TcpClient())
                {
                    // Try common SMTP ports
                    string[] smtpPorts = { "25", "587", "465" };
                    
                    foreach (string port in smtpPorts)
                    {
                        try
                        {
                            var connect = tcpClient.BeginConnect(domain, int.Parse(port), null, null);
                            var wait = connect.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(3));
                            
                            if (wait)
                            {
                                tcpClient.EndConnect(connect);
                                return true;
                            }
                        }
                        catch
                        {
                            // Try next port
                        }
                    }
                }
                
                return false;
            }
            catch
            {
                return false;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Validates all required fields before proceeding
            if (Page.IsValid)
            {
                // Calculate total again to ensure we have the correct numeric value
                DateTime checkIn, checkOut;
                decimal total = 0;
                if (DateTime.TryParse(txtCheckIn.Text, out checkIn) && DateTime.TryParse(txtCheckOut.Text, out checkOut))
                {
                    if (checkOut > checkIn && ViewState["PricePerNight"] != null)
                    {
                        int days = (checkOut - checkIn).Days;
                        total = Convert.ToDecimal(ViewState["PricePerNight"]) * days;
                    }
                }
                
                Session["FinalUnitID"] = ddlRoomNumber.SelectedValue;
                Session["RoomNumberText"] = ddlRoomNumber.SelectedItem.Text;
                Session["FullName"] = txtFullName.Text.Trim(); // Store full name
                Session["Email"] = txtEmail.Text.Trim(); // Use email as primary identifier
                Session["Contact"] = txtContact.Text.Trim(); // Store contact number
                Session["CheckIn"] = txtCheckIn.Text;
                Session["CheckOut"] = txtCheckOut.Text;
                Session["TotalPrice"] = total.ToString("F2");

                Response.Redirect("ConfirmReservation.aspx");
            }
        }

        private void ResetUI()
        {
            pnlRoomNumber.Visible = false;
            pnlInputs.Enabled = false;
            roomPreviewPanel.Visible = false;
            pnlPlaceholder.Visible = true;
            pnlPriceSummary.Visible = false;
            lblAvailabilityMsg.Visible = false;
        }
    }
}