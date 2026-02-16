using System;
using System.Web;
using System.Web.UI;
using System.Web.Routing;
using DevExpress.Web;
using Microsoft.AspNet.FriendlyUrls;

namespace PSAUStay
{
    public class Global_asax : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Handle DevExpress callback errors
            ASPxWebControl.CallbackError += new EventHandler(Application_Error);

            // ✅ Add jQuery ScriptResourceMapping for WebForms validators
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            {
                Path = "~/Scripts/jquery-3.7.1.min.js",
                DebugPath = "~/Scripts/jquery-3.7.1.js",
                CdnPath = "https://code.jquery.com/jquery-3.7.1.min.js",
                CdnDebugPath = "https://code.jquery.com/jquery-3.7.1.js"
            });

            // ✅ Enable Friendly URLs (removes .aspx from URLs)
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            RouteTable.Routes.EnableFriendlyUrls(settings);

            // Optional: Map clean aliases for key pages
            RouteTable.Routes.MapPageRoute("Login", "Login", "~/Account/Login.aspx");
            RouteTable.Routes.MapPageRoute("Roles", "Roles", "~/Account/AccessLevel.aspx");
            RouteTable.Routes.MapPageRoute("ManageUsers", "ManageUsers", "~/Account/ManageUsers.aspx");
            RouteTable.Routes.MapPageRoute("Register", "Register", "~/Account/Register.aspx");
            RouteTable.Routes.MapPageRoute("ResetPassword", "ResetPassword", "~/Account/ResetPassword.aspx");
            RouteTable.Routes.MapPageRoute("ChangePassword", "ChangePassword", "~/Account/ChangePassword.aspx");
            RouteTable.Routes.MapPageRoute("Dashboard", "Dashboard", "~/Admin/Dashboard.aspx");
            RouteTable.Routes.MapPageRoute("RoomRequests", "RoomRequests", "~/Admin/RoomRequests.aspx");
            RouteTable.Routes.MapPageRoute("Home", "Home", "~/Default.aspx");
            RouteTable.Routes.MapPageRoute("About", "About", "~/About.aspx");
            RouteTable.Routes.MapPageRoute("Bookings", "Bookings", "~/Admin/Dashboard.aspx");
            RouteTable.Routes.MapPageRoute("ManageRooms", "ManageRooms", "~/Admin/ManageRooms.aspx");
            RouteTable.Routes.MapPageRoute("RoomUnits", "RoomUnits", "~/Admin/RoomUnits.aspx");
            RouteTable.Routes.MapPageRoute("Reservations", "Reservations", "~/Admin/RoomRequests.aspx");
            //RouteTable.Routes.MapPageRoute("ManageRooms", "ManageRooms", "~/Admin/ManageRooms.aspx");
            RouteTable.Routes.MapPageRoute("WaitList", "WaitList", "~/Admin/WaitList.aspx");
            RouteTable.Routes.MapPageRoute("AddRoom", "AddRoom", "~/Admin/AddRoom.aspx");
            RouteTable.Routes.MapPageRoute("Maintenance", "Maintenance", "~/Admin/Maintenace.aspx");
            RouteTable.Routes.MapPageRoute("RoomStatus", "RoomStatus", "~/Admin/RoomStatus.aspx");
            RouteTable.Routes.MapPageRoute("NotifyHousekeeping", "NotifyHousekeeping", "~/Admin/NotifyHousekeeping.aspx");
            RouteTable.Routes.MapPageRoute("GuestList", "GuestList", "~/Admin/GuestList.aspx");
            RouteTable.Routes.MapPageRoute("GuestDetails", "GuestDetails", "~/Admin/GuestDetails.aspx");
            RouteTable.Routes.MapPageRoute("EditRoom", "Admin/EditRoom/{RoomID}", "~/Admin/EditRoom.aspx");
        }

        void Application_End(object sender, EventArgs e)
        {
            // Code that runs on application shutdown
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
        }

        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a new session starts
        }

        void Session_End(object sender, EventArgs e)
        {
            // Note: The Session_End event is raised only when
            // the sessionstate mode is set to InProc.
        }
    }
}
