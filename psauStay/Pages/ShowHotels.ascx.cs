using HotelBookingContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class UserControls_ShowHotels : UserControl, IPageUserControl {
    public SearchState SearchState { get; set; }

    public void LoadState(SearchState state) {
        SearchState = state;
        LocationComboBox.DataBindItems();
        LocationComboBox.SelectedItem = LocationComboBox.Items.FindByValue(state.Metro_Area.ID);
        NightyRateTrackBar.MaxValue = SearchState.Metro_Area.MaxRoomPrice;
        NightyRateTrackBar.MinValue = SearchState.Metro_Area.MinRoomPrice;
        NightyRateTrackBar.PositionStart = GetDecimalValue(state.FilterMinPrice, NightyRateTrackBar.MinValue, NightyRateTrackBar.MaxValue, NightyRateTrackBar.MinValue);
        NightyRateTrackBar.PositionEnd = GetDecimalValue(state.FilterMaxPrice, NightyRateTrackBar.MinValue, NightyRateTrackBar.MaxValue, NightyRateTrackBar.MaxValue);
        AreaMapImage.ImageUrl = SearchState.Metro_Area.Map_ImageUrl;

        CustomerRatingTrackBar.Position = GetDecimalValue(state.FilterCustomerRating, CustomerRatingTrackBar.MinValue, CustomerRatingTrackBar.MaxValue, CustomerRatingTrackBar.MinValue);

        int[] stars = { 1, 2, 3, 4, 5 };
        if(!string.IsNullOrEmpty(state.FilterOurRating))
            stars = state.FilterOurRating.Split(',').Select(s => Convert.ToInt32(s)).ToArray();
        for(int i = 0; i < 5; i++)
            OurRatingCheckBoxList.Items[i].Selected = stars.Contains(i + 1);

        var hotels = FindHotels(state, state.Metro_Area.ID, stars).ToList();
        if(hotels.Any()) {
            ResultsPanel.Visible = true;
            NoResultsPanel.Visible = false;
            SearchResultsDataView.DataSource = hotels;
            SearchResultsDataView.DataBind();
        }
        else {
            ResultsPanel.Visible = false;
            NoResultsPanel.Visible = true;
        }

        StartFilter.SearchState = state;
    }

    IEnumerable<Hotel> FindHotels(SearchState state, int metroAreaID, int[] stars) {
        return state.DataContext.Hotels.ToList().Where(h => CheckHotelFilters(h, metroAreaID, stars));
    }

    bool CheckHotelFilters(Hotel hotel, int metroAreaID, int[] stars) {
        return hotel.Cities.Metro_Area_ID == metroAreaID &&
               NightyRateTrackBar.PositionStart <= hotel.EndPrice &&
               hotel.StartPrice <= (NightyRateTrackBar.PositionEnd + 1) &&
               hotel.Customer_Rating >= CustomerRatingTrackBar.Position &&
               stars.Contains((int)Math.Floor(hotel.Our_Rating.Value));
    }

    protected decimal GetDecimalValue(string textValue, decimal minValue, decimal maxValue, decimal defaultValue) {
        if(string.IsNullOrEmpty(textValue))
            return defaultValue;
        var value = Convert.ToDecimal(textValue);
        return Math.Min(Math.Max(minValue, value), maxValue);
    }

    protected void NightyRateTrackBar_CustomJSProperties(object sender, DevExpress.Web.CustomJSPropertiesEventArgs e) {
        e.Properties.Add("cpLeftLabelID", "NightyRateTrackBarLabel_L");
        e.Properties.Add("cpRightLabelID", "NightyRateTrackBarLabel_R");
        e.Properties.Add("cpLabelPrefix", "$");
    }
    protected void CustomerRatingTrackBar_CustomJSProperties(object sender, DevExpress.Web.CustomJSPropertiesEventArgs e) {
        e.Properties.Add("cpRightLabelID", "CustomerRatingTrackbarLabel_R");
    }
}
