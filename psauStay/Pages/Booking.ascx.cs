using System;
using System.Collections.Generic;
using System.Drawing;

public partial class UserControls_Booking : System.Web.UI.UserControl, IPageUserControl {
    public SearchState SearchState { get; set; }

    public void LoadState(SearchState state) {
        SearchState = state;
        SummaryHotelImage.ImageUrl = state.Hotel.PrimaryPicture.Url;
        RoomFeaturesDataView.DataSource = state.Room.Room_Features;
        RoomFeaturesDataView.DataBind();

        BindPriceRepeater(state);

        InvoicePanel.Visible = state.Page == "PrintInvoice";

        if(!string.IsNullOrEmpty(AccountCaptchaEditor.Text)) {
            AccountCaptchaEditor.IsValid = AccountCaptcha.Code == AccountCaptchaEditor.Text;
            AccountCaptchaHiddenField.Set("IsCaptchaValid", AccountCaptchaEditor.IsValid);
        }
    }

    private void BindPriceRepeater(SearchState state) {
        List<object> prices = new List<object>();
        if(state.NightsCount < 4) {
            for(int i = 0; i < state.NightsCount; i++) {
                var date = state.CheckInDate + TimeSpan.FromDays(i);
                prices.Add(new { Period = date.ToString("dddd, MMMM dd, yyyy"), Price = state.Room.Nighly_Rate });
            }
        }
        else {
            prices.Add(new { Period = state.CheckInDate.ToString("dddd, MMMM dd, yyyy"), Price = state.Room.Nighly_Rate });
            
            prices.Add(new {
                Period = string.Format("{0:MMM d} - {1:MMM d}", state.CheckInDate + TimeSpan.FromDays(1), state.CheckOutDate - TimeSpan.FromDays(1)),
                Price = state.Room.Nighly_Rate * (state.NightsCount - 2) 
            });

            prices.Add(new { Period = state.CheckOutDate.ToString("dddd, MMMM dd, yyyy"), Price = state.Room.Nighly_Rate });
        }
        PriceRepeater.DataSource = prices;
        PriceRepeater.DataBind();
    }
    protected void PrintInvoicePopup_WindowCallback(object source, DevExpress.Web.PopupWindowCallbackArgs e) {
        var report = DataProvider.CreateReport(SearchState);
        InvoiceDocumentViewer.Report = report;
    }
    protected void InvoiceDocumentViewer_Load(object sender, EventArgs e) {
        if(SearchState.Page == "PrintInvoice")
            InvoiceDocumentViewer.Report = DataProvider.CreateReport(SearchState);
    }
    protected void AccountCaptcha_Load(object sender, EventArgs e) {
        AccountCaptcha.ChallengeImage.BackgroundColor = Color.FromArgb(178, 178, 178);
    }
}
