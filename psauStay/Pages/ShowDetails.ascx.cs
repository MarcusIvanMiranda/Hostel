using DevExpress.Web;
using System;
using System.Drawing;
using System.Linq;

public partial class UserControls_ShowDetails : System.Web.UI.UserControl, IPageUserControl {
    public SearchState SearchState { get; set; } 

    public void LoadState(SearchState state) {
        SearchState = state;
        HotelRatingControl.Value = state.Hotel.Customer_Rating;

        HotelImageSlider.DataSource = state.Hotel.Pictures.Where(p => p.Rooms == null);
        HotelImageSlider.DataBind();

        CommentsDataView.DataSource = state.Hotel.Reviews;
        CommentsDataView.DataBind();

        StartFilter.SearchState = state;
    }
    protected void HotelRatingControl_Load(object sender, EventArgs e) {
        HotelRatingControl.ImageMapUrl = "~/Content/Images/rating-map.png";
        HotelRatingControl.BackColor = Color.Transparent;
        HotelRatingControl.ItemHeight = 32;
        HotelRatingControl.ItemWidth = 34;
    }
    protected void CommentRatingControl_Load(object sender, EventArgs e) {
        var ratingControl = (ASPxRatingControl)sender;
        ratingControl.ImageMapUrl = "~/Content/Images/rating-map-s.png";
        ratingControl.BackColor = Color.Transparent;
        ratingControl.ItemHeight = 24;
        ratingControl.ItemWidth = 26;
    }
    protected void HotelDetailsCallbackPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e) {
        var value = Convert.ToDecimal(e.Parameter);
        DataProvider.CustomRatings[SearchState.Hotel.ID] = value;
        HotelRatingControl.Value = SearchState.Hotel.Customer_Rating;
    }
}
