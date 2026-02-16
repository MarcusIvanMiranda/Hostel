using DevExpress.XtraPrinting;
using DevExpress.XtraReports.UI;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Collections.Specialized;

public class DataProvider {
    const int MaxDaysCountForReport = 15;

    public static Dictionary<int, decimal> CustomRatings {
        get {
            if(HttpContext.Current.Session["CustomRatings"] == null)
                HttpContext.Current.Session["CustomRatings"] = new Dictionary<int, decimal>();
            return (Dictionary<int, decimal>)HttpContext.Current.Session["CustomRatings"];
        }
    }

    public static List<string> LocationRatings = new List<string>() { "BBB", "A", "AA", "AAA" };

    public static Dictionary<int, string> GetMonths() {
        var results = new Dictionary<int, string>();
        for(int i = 0; i < 12; i++) {
            results.Add(i, DateTimeFormatInfo.CurrentInfo.MonthNames[i]);
        }
        return results;
    }
    public static List<int> GetCardExpiredYears() {
        var years = new List<int>();
        for(int i = 0; i < 10; i++) {
            years.Add(DateTime.Now.Year + i);
        }
        return years;
    }
    public static List<string> GetStates() {
        return new List<string>() {
            "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", 
            "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", 
            "WA", "WV", "WI", "WY"
        };
    }
    public static List<string> GetLocationRatings() {
        return new List<string>() {
            "", "AAA", "AA", "A", "BBB"
        };
    }
    public static InvoiceReport CreateReport(SearchState state) {
        var report = new InvoiceReport();
        report.HotelNameLabel1.Text = state.Hotel.Hotel_Name;
        report.HotelNameLabel2.Text = state.Hotel.Hotel_Name;

        report.RatingPictureBox.ImageUrl = string.Format("~/Content/Report/Rating{0}.png", state.Hotel.RoundRating);
        report.RatingPictureBox.Location = new Point(GetTextWidth(state.Hotel.Hotel_Name, report.HotelNameLabel1.Font), report.RatingPictureBox.Location.Y);

        report.HotelAddressLine1Label.Text = state.Hotel.Address + " " + state.Hotel.Cities.City_Name;
        if(!string.IsNullOrEmpty(state.Hotel.Cities.State_Province))
            report.HotelAddressLine1Label.Text += ", " + state.Hotel.Cities.State_Province;
        report.HotelAddressLine1Label.Text += ", " + state.Hotel.Postal_Code + ",";
        report.HotelAddressLine2Label.Text = state.Hotel.Cities.Country;

        report.HotelAddressLabel.Text = state.Hotel.Address + " " + state.Hotel.DetailsCity;
        report.CheckInLabel.Text = state.CheckInDate.ToString("MMMM dd, yyyy");
        report.CheckOutLabel.Text = state.CheckOutDate.ToString("MMMM dd, yyyy");

        report.PriceTable.Rows.Clear();
        for(int i = 0; i < state.NightsCount && i < MaxDaysCountForReport; i++) {
            var date = state.CheckInDate + TimeSpan.FromDays(i);
            report.PriceTable.Rows.Add(CreateReportRow(date.ToString("MMMM dd, yyyy"), state.Room.Nighly_Rate.Value.ToString("C")));
        }
        if(state.NightsCount > MaxDaysCountForReport) {
            var remainDays = state.NightsCount - MaxDaysCountForReport;
            report.PriceTable.Rows.Add(CreateReportRow(
                string.Format("{0} days more", remainDays), 
                (state.Room.Nighly_Rate.Value * remainDays).ToString("C"))
            );
        }

        report.TotalPriceLabel.Text = string.Format("{0:C}", state.Room.Nighly_Rate.Value * state.NightsCount);

        report.HotelDescriptionLabel.Text = state.Hotel.Description;

        report.HotelSmallImagePictureBox.ImageUrl = state.Hotel.PrimaryPicture.Url;
        report.HotelLargeImagePictureBox.ImageUrl = state.Hotel.SecondaryPicture.Url;

        return report;
    }

    public static string GetQueryString(NameValueCollection parameters) {
        var array = (from key in parameters.AllKeys
                     select string.Format("{0}={1}", HttpUtility.UrlEncode(key), HttpUtility.UrlEncode(parameters[key]))).ToArray();
        return string.Join("&", array);
    }

    static int GetTextWidth(string text, Font font) {
        var gr = Graphics.FromHwnd(IntPtr.Zero);
        gr.PageUnit = GraphicsUnit.Inch;
        SizeF size = gr.MeasureString(text, font);
        return Convert.ToInt32(size.Width * 100);
    }

    static XRTableRow CreateReportRow(string text, string price) {
        var row = new DevExpress.XtraReports.UI.XRTableRow();
        var cell1 = new XRTableCell();
        var cell2 = new XRTableCell();
        cell1.Text = text;
        cell2.Text = price;
        cell2.TextAlignment = TextAlignment.MiddleRight;
        row.Cells.Add(cell1);
        row.Cells.Add(cell2);
        return row;
    }

    public static List<string> GetDefaultHotelLocations() {
        return new List<string>() {
            "Airport shuttle (available 24 hours)",
            "Cruise terminal shuttle"
        };
    }
}
