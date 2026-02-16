using DevExpress.Web;
using HotelBookingContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Pages_SpecialOffers : System.Web.UI.UserControl, IPageUserControl {
    public string[] CitiesNames = new string[] { "Paris", "New York City", "London", "Los Angeles" };

    public void LoadState(SearchState state) {
        var cities = CitiesNames.Select(cn => state.DataContext.Cities.First(c => c.City_Name == cn)).ToList();
        var offers = new List<SpecialOffer>();
        foreach(var city in cities)
            offers.Add(new SpecialOffer(city, city.CheapestHotel));

        if(PanelsRepeater.Items.Count == 0) {
            PanelsRepeater.DataSource = offers;
            PanelsRepeater.DataBind();
        }
    }
    protected void DockPanel_Init(object sender, EventArgs e) {
        var panel = (ASPxDockPanel)sender;
        var index = (panel.NamingContainer as RepeaterItem).ItemIndex + 1;
        panel.ID = "DockPanel" + index.ToString();
        panel.PanelUID = "DockPanel" + index.ToString();
        panel.ClientInstanceName = "DockPanel" + index.ToString();
        panel.OwnerZoneUID = "DockZone" + index.ToString();
    }
    protected int GetItemIndex(ASPxDockPanel panel) {
        return (panel.NamingContainer as RepeaterItem).ItemIndex + 1;
    }

    protected void OfferFormPopup_WindowCallback(object source, DevExpress.Web.PopupWindowCallbackArgs e) {
        var index = Convert.ToInt32(e.Parameter) - 1;
        var context = new HotelBookingDataContext();
        var cityName = CitiesNames[index];
        var city = context.Cities.First(c => c.City_Name == cityName);

        CheckInDateEdit.Value = DateTime.Now + TimeSpan.FromDays(1);
        CheckInDateEdit.MinDate = DateTime.Now + TimeSpan.FromDays(1);
        CheckOutDateEdit.Value = DateTime.Now + TimeSpan.FromDays(3);

        CityNameHeader.InnerHtml = city.City_Name;
        HotelNameHeader.InnerHtml = city.CheapestHotel.Hotel_Name;
        CheckButton.ClientSideEvents.Click = string.Format("function() {{ onSpecialOfferCheckButtonClick({0}, {1}) }}", city.CheapestHotel.ID, city.Metro_Area_ID);
    }
}
