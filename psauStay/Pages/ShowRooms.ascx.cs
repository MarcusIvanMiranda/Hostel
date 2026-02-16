using System;
using System.Drawing;
using System.Linq;
using DevExpress.Web;
using HotelBookingContext;

public partial class UserControls_ShowRooms : System.Web.UI.UserControl, IPageUserControl {
    public SearchState SearchState { get; set; }

    public void LoadState(SearchState state) {
        SearchState = state;
        HotelRatingControl.Value = state.Hotel.Customer_Rating;
        BindRoomsNavBar(state.Hotel);
        StartFilter.SearchState = state;
    }

    void BindRoomsNavBar(Hotel hotel) {
        RoomsNavBar.Groups.Clear();
        foreach(var room in hotel.Rooms) {
            var group = new NavBarGroup(room.Room_Types.Type_Name, room.ID.ToString());
            group.DataItem = room;
            group.Expanded = false;
            RoomsNavBar.Groups.Add(group);
            group.Items.Add();
        }
    }

    protected void FeaturesDataView_Init(object sender, EventArgs e) {
        var dv = sender as ASPxDataView;
        var room = (dv.NamingContainer as NavBarGroupTemplateContainer).Group.DataItem as Room;
        dv.DataSource = room.Room_Features;
        dv.DataBind();
    }
    protected void RoomImageSlider_Init(object sender, EventArgs e) {
        var slider = sender as ASPxImageSlider;
        var room = (slider.NamingContainer as NavBarGroupTemplateContainer).Group.DataItem as Room;
        slider.DataSource = room.Pictures;
        slider.DataBind();
    }
    protected void ImagePopupControl_WindowCallback(object source, DevExpress.Web.PopupWindowCallbackArgs e) {
        var roomID = Convert.ToInt32(e.Parameter.Substring(0, e.Parameter.IndexOf("|")));
        var imageName = e.Parameter.Substring(e.Parameter.IndexOf("|") + 1);
        var context = new HotelBookingDataContext();
        var room = context.Rooms.First(r => r.ID == roomID);

        RoomPopupImageSlider.DataSource = room.Pictures;
        RoomPopupImageSlider.DataBind();
        RoomPopupImageSlider.ActiveItemIndex = RoomPopupImageSlider.Items.IndexOf(isi => ((Picture)isi.DataItem).Picture_Id == imageName);
    }
    protected void HotelRatingControl_Load(object sender, EventArgs e) {
        HotelRatingControl.ImageMapUrl = "~/Content/Images/rating-map.png";
        HotelRatingControl.BackColor = Color.Transparent;
        HotelRatingControl.ItemHeight = 32;
        HotelRatingControl.ItemWidth = 34;
    }
    protected void HotelDetailsCallbackPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e) {
        var value = Convert.ToDecimal(e.Parameter);
        DataProvider.CustomRatings[SearchState.Hotel.ID] = value;
        HotelRatingControl.Value = SearchState.Hotel.Customer_Rating;
    }
}
