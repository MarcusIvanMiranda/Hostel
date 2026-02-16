using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Text;

namespace PSAUStay.HouseKeeper
{
    public partial class Reports : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            LoadOccupiedRooms();
            LoadCheckoutHistory();
        }

        public string GetExtraChargesHtml(object bookingId, object source)
        {
            StringBuilder html = new StringBuilder();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT ChargeName, Price FROM ExtraCharges WHERE BookingID = @ID AND Source = @Source";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", bookingId);
                cmd.Parameters.AddWithValue("@Source", source);

                con.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (!rdr.HasRows) return "<span class='text-muted small'>None yet.</span>";
                    while (rdr.Read())
                    {
                        html.AppendFormat("<div class='d-flex justify-content-between small border-bottom mb-1 pb-1'>" +
                                          "<span>{0}</span><span class='fw-bold'>PHP {1:N2}</span></div>",
                                          rdr["ChargeName"], rdr["Price"]);
                    }
                }
            }
            return html.ToString();
        }

        private void LoadOccupiedRooms()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = GetStayQuery("Approved");
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptOccupiedRooms.DataSource = dt;
                rptOccupiedRooms.DataBind();
            }
        }

        private void LoadCheckoutHistory()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = GetStayQuery("CheckedOut");
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvHKHistory.DataSource = dt;
                gvHKHistory.DataBind();
            }
        }

        private string GetStayQuery(string status)
        {
            return $@"
                SELECT *, (BasePrice + ExtraTotal) as TotalBill FROM (
                    SELECT RQ.RequestID as ID, GL.FullName, RU.RoomNumber, RM.RoomName, RM.Price as BasePrice, RQ.CheckOutDate, 'Online' as Source,
                           ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = RQ.RequestID AND Source = 'Online'), 0) as ExtraTotal
                    FROM RoomRequests RQ
                    JOIN Rooms RM ON RQ.RoomID = RM.RoomID
                    JOIN RoomUnits RU ON RU.UnitID = TRY_CAST(SUBSTRING(RQ.Message, CHARINDEX('UnitID:', RQ.Message) + 7, 2) AS INT)
                    LEFT JOIN GuestList GL ON RQ.Email = GL.Email
                    WHERE RQ.Status = '{status}'
                    UNION ALL
                    SELECT R.ReservationID, ISNULL(GL.FullName, 'Guest'), RU.RoomNumber, RM.RoomName, RM.Price, R.CheckOutDate, 'Manual',
                           ISNULL((SELECT SUM(Price) FROM ExtraCharges WHERE BookingID = R.ReservationID AND Source = 'Manual'), 0) as ExtraTotal
                    FROM [dbo].[Reservation] R
                    JOIN Rooms RM ON R.RoomID = RM.RoomID
                    JOIN RoomUnits RU ON R.UnitID = RU.UnitID
                    LEFT JOIN GuestList GL ON R.UserID = GL.GuestID
                    WHERE R.Status = '{status}'
                ) AS CombinedData ORDER BY CheckOutDate DESC";
        }

        protected void btnSubmitCharge_Click(object sender, EventArgs e)
        {
            decimal price;
            if (string.IsNullOrEmpty(txtChargeName.Text) || !decimal.TryParse(txtPrice.Text, out price))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Error', 'Please enter a valid name and price', 'error');", true);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO ExtraCharges (BookingID, Source, ChargeName, Price) VALUES (@ID, @Source, @Name, @Price)";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@ID", hfBookingID.Value);
                    cmd.Parameters.AddWithValue("@Source", hfSource.Value);
                    cmd.Parameters.AddWithValue("@Name", txtChargeName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Price", price);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                txtChargeName.Text = "";
                txtPrice.Text = "";
                LoadData();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success', 'Charge Added Successfully', 'success');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"Swal.fire('Error', '{ex.Message}', 'error');", true);
            }
        }
    }
}