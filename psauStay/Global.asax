<%@ Application Language="C#" %>

<script RunAt="server">
    void Application_Start(object sender, EventArgs e) {
        RegisterRoutes(System.Web.Routing.RouteTable.Routes);
        DevExpress.Web.ASPxWebControl.CallbackError += new EventHandler(CallbackError);
    }

    void CallbackError(object sender, EventArgs e) {
        // Logging exceptions occur on callback events of DevExpress ASP.NET controls. 
        // To learn more, see http://www.devexpress.com/Support/Center/Example/Details/E2398      
    }
    void Application_End(object sender, EventArgs e) {
    }
    void Application_Error(object sender, EventArgs e) {
    }
    void Session_Start(object sender, EventArgs e) {
    }
    void Session_End(object sender, EventArgs e) {
    }
    void RegisterRoutes(System.Web.Routing.RouteCollection routes) {
        var pages = new string[] { 
            "ShowHotels", 
            "ShowDetails",
            "ShowRooms",
            "Booking",
            "PrintInvoice",
            "RoomOffers",
            "SpecialOffers"
        };
        foreach(var page in pages) {
            RegisterRoute(routes, page, page, "~/Default.aspx");
        }
    }
    void RegisterRoute(System.Web.Routing.RouteCollection routes, string key, string url, string path) {
        var route = routes.MapPageRoute(key, url, path);
        route.DataTokens = new System.Web.Routing.RouteValueDictionary();
        route.DataTokens["Key"] = key;
    }
</script>
