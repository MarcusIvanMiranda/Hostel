using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSAUStay
{
    public partial class AdminControl : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Hide Security menu only for Staff Clerk users (RoleID = 2)
            int userRoleID = Convert.ToInt32(Session["RoleID"]);
            if (userRoleID == 2)
            {
                // Hide the security menu toggle
                var securityMenuToggle = FindControl("securityMenuToggle");
                if (securityMenuToggle != null)
                {
                    securityMenuToggle.Visible = false;
                }
                
                // Hide the security submenu
                var securityMenu = FindControl("securityMenu");
                if (securityMenu != null)
                {
                    securityMenu.Visible = false;
                }
            }
        }

        protected string GetRoleDisplayName()
        {
            if (Session["RoleID"] == null)
                return "User";

            int roleID = Convert.ToInt32(Session["RoleID"]);
            switch (roleID)
            {
                case 1:
                    return "Administrator";
                case 2:
                    return "Staff";
                default:
                    return "User";
            }
        }
    }
}