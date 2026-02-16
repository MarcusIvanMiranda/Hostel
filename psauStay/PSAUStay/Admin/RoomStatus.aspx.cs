using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PSAUStay.Admin
{
    public partial class RoomStatus : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["PSAUStayConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoomStatus();
            }
        }

        private void LoadRoomStatus()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                    SELECT 
                        ru.UnitID,
                        r.RoomName,
                        ru.RoomNumber,
                        r.Capacity,
                        ru.Status,
                        ISNULL(res.CurrentBooking,'None') AS CurrentBooking,
                        ISNULL(mr.Status,'None') AS MaintenanceStatus
                    FROM RoomUnits ru
                    JOIN Rooms r ON ru.RoomID = r.RoomID
                    LEFT JOIN (
                        SELECT res.RoomID, 'Booked by ' + u.FullName AS CurrentBooking
                        FROM Reservation res
                        INNER JOIN Users u ON res.UserID = u.UserId
                        WHERE res.Status='Confirmed'
                        AND GETDATE() BETWEEN res.CheckInDate AND res.CheckOutDate
                    ) res ON ru.UnitID = res.RoomID
                    LEFT JOIN (
                        SELECT RoomID, Status
                        FROM MaintenanceRequests
                        WHERE Status != 'Completed'
                    ) mr ON ru.RoomID = mr.RoomID
                    ORDER BY r.RoomName, ru.RoomNumber";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRooms.DataSource = dt;
                gvRooms.DataBind();
            }
        }
    }
}