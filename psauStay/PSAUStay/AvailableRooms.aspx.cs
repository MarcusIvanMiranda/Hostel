using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace PSAUStay
{
    public partial class AvailableRooms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoomTypes();
                LoadRooms();
                
                // Initialize calendar to today
                calCheckoutDate.SelectedDate = DateTime.Today;
                lblSelectedCheckoutDate.Text = "Selected: " + DateTime.Today.ToString("MMMM dd, yyyy");
                LoadBookedRooms();
            }
        }

        private void LoadRoomTypes()
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT RoomType FROM Rooms ORDER BY RoomType", con))
            {
                con.Open();
                ddlRoomType.DataSource = cmd.ExecuteReader();
                ddlRoomType.DataTextField = "RoomType";
                ddlRoomType.DataValueField = "RoomType";
                ddlRoomType.DataBind();
            }
            ddlRoomType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", ""));
        }

        private void LoadRooms()
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

            string roomType = ddlRoomType.SelectedValue;
            string query = @"
                SELECT DISTINCT R.RoomName, R.RoomType, R.Price,
                       ISNULL(STUFF((
                           SELECT ', ' + RU.RoomNumber 
                           FROM RoomUnits RU 
                           WHERE RU.RoomID = R.RoomID 
                           AND RU.Status = 'Available'
                           FOR XML PATH('')
                       ), 1, 2, ''), 'No units available') AS RoomNumbers,
                       CASE WHEN EXISTS (
                           SELECT 1 FROM RoomUnits RU 
                           WHERE RU.RoomID = R.RoomID 
                           AND RU.Status = 'Available'
                       ) THEN 'Available' ELSE 'Booked' END AS Status
                FROM Rooms R
                WHERE (@RoomType = '' OR R.RoomType = @RoomType)
                AND EXISTS (
                    SELECT 1 FROM RoomUnits RU 
                    WHERE RU.RoomID = R.RoomID 
                    AND RU.Status = 'Available'
                )
                ORDER BY R.RoomName";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@RoomType", roomType);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvRooms.DataSource = dt;
                    gvRooms.DataBind();
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadRooms();
        }

        protected void tmRefresh_Tick(object sender, EventArgs e)
        {
            LoadRooms(); // Refresh results every 7 seconds
        }

        protected void txtCheckoutDate_TextChanged(object sender, EventArgs e)
        {
            LoadBookedRooms();
        }

        protected void calCheckoutDate_SelectionChanged(object sender, EventArgs e)
        {
            lblSelectedCheckoutDate.Text = "Selected: " + calCheckoutDate.SelectedDate.ToString("MMMM dd, yyyy");
            LoadBookedRooms();
        }

        protected void calCheckoutDate_DayRender(object sender, DayRenderEventArgs e)
        {
            // Get all checkout dates for the current month
            List<DateTime> checkoutDates = GetCheckoutDatesForMonth(e.Day.Date);
            
            // Check if current day has any checkouts
            if (checkoutDates.Contains(e.Day.Date))
            {
                // Add a red dot indicator for days with checkouts
                e.Cell.BackColor = System.Drawing.Color.LightCoral;
                e.Cell.ForeColor = System.Drawing.Color.White;
                e.Cell.Font.Bold = true;
                
                // Add a visual indicator
                Label dot = new Label();
                dot.Text = "●";
                dot.ForeColor = System.Drawing.Color.White;
                dot.Font.Bold = true;
                e.Cell.Controls.Add(dot);
            }
        }

        private List<DateTime> GetCheckoutDatesForMonth(DateTime monthDate)
        {
            List<DateTime> checkoutDates = new List<DateTime>();
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

            string query = @"
                SELECT DISTINCT CAST(CheckOutDate AS DATE) AS CheckoutDate
                FROM Reservation
                WHERE YEAR(CheckOutDate) = @Year AND MONTH(CheckOutDate) = @Month
                ORDER BY CheckoutDate";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Year", monthDate.Year);
                cmd.Parameters.AddWithValue("@Month", monthDate.Month);

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        checkoutDates.Add(Convert.ToDateTime(reader["CheckoutDate"]));
                    }
                }
            }

            return checkoutDates;
        }

        private void LoadBookedRooms()
        {
            string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

            string query = @"
                SELECT 
                    GL.FullName AS GuestName,
                    RU.RoomNumber,
                    RM.RoomType,
                    R.CheckInDate,
                    R.CheckOutDate,
                    GL.Contact AS ContactNumber
                FROM Reservation R
                INNER JOIN GuestList GL ON R.UserID = GL.GuestID
                INNER JOIN RoomUnits RU ON R.UnitID = RU.UnitID
                INNER JOIN Rooms RM ON RU.RoomID = RM.RoomID
                WHERE CAST(R.CheckOutDate AS DATE) = @CheckoutDate
                ORDER BY R.CheckOutDate, RU.RoomNumber";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                DateTime checkoutDate = calCheckoutDate.SelectedDate;
                if (checkoutDate == DateTime.MinValue)
                {
                    checkoutDate = DateTime.Today;
                }

                cmd.Parameters.AddWithValue("@CheckoutDate", checkoutDate);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvBookedRooms.DataSource = dt;
                    gvBookedRooms.DataBind();
                }
            }
        }
    }
}