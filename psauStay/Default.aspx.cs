using System;
using System.Collections.Specialized;
using System.Web;
using System.Web.UI;
using HotelBookingContext;

public partial class _Default : System.Web.UI.Page {
    protected Control UserControl { get; set; }

    protected void Page_Init(object sender, EventArgs e) {
        if((!IsPostBack && !IsCallback) || !HiddenField.Contains("page")) {
            var page = RouteData.Route != null ? RouteData.DataTokens["Key"].ToString() : string.Empty;
            LoadUserControl(page, Request.QueryString);
            HiddenField.Set("page", page);
            HiddenField.Set("parameters", Request.QueryString.ToString());
        }
        else
            LoadUserControl(HiddenField.Get("page").ToString(), HttpUtility.ParseQueryString(HiddenField.Get("parameters").ToString()));
        if(Request.UserAgent.Contains("iPad") && Request.UserAgent.Contains("Version/7"))
            Body.Attributes.Add("class", "ios");
    }
    protected void MainCallbackPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e) {
        string page = e.Parameter;
        NameValueCollection parameters = new NameValueCollection();
        if(e.Parameter.Contains("?")) {
            page = e.Parameter.Substring(0, e.Parameter.IndexOf('?'));
            string queryString = e.Parameter.Substring(e.Parameter.IndexOf('?') + 1);
            parameters = HttpUtility.ParseQueryString(queryString);
        }
        (UserControl as IPageUserControl).LoadState(new SearchState(page, parameters, new HotelBookingDataContext()));
    }

    void LoadUserControl(string page, NameValueCollection parameters) {
        MenuButton.Visible = false;
        BackButton.Visible = true;
        switch(page) {
            case "ShowHotels":
                UserControl = LoadControl("~/Pages/ShowHotels.ascx");
                break;
            case "ShowDetails":
                UserControl = LoadControl("~/Pages/ShowDetails.ascx");
                break;
            case "ShowRooms":
                UserControl = LoadControl("~/Pages/ShowRooms.ascx");
                break;
            case "Booking":
            case "PrintInvoice":
                UserControl = LoadControl("~/Pages/Booking.ascx");
                break;
            case "RoomOffers":
                UserControl = LoadControl("~/Pages/RoomOffers.ascx");
                break;
            case "SpecialOffers":
                UserControl = LoadControl("~/Pages/RoomOffers.ascx");
                break;
            default:
                UserControl = LoadControl("~/Pages/Index.ascx");
                MenuButton.Visible = true;
                BackButton.Visible = false;
                break;
        }
        ContentPane.Controls.Add(UserControl);
        (UserControl as IPageUserControl).LoadState(new SearchState(page, parameters, new HotelBookingDataContext()));
    }
}
