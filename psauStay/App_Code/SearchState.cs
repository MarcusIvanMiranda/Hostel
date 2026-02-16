using HotelBookingContext;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;

public class SearchState {
    bool validState = true;

    public SearchState(string page, NameValueCollection parameters, HotelBookingDataContext context) {
        Page = page;
        DataContext = context;
        if(!string.IsNullOrEmpty(parameters["location"])) {
            try {
                CheckInDate = DateTime.ParseExact(parameters["checkin"], "M-d-yyyy", CultureInfo.InvariantCulture);
                CheckOutDate = DateTime.ParseExact(parameters["checkout"], "M-d-yyyy", CultureInfo.InvariantCulture);
                RoomsCount = Convert.ToInt32(parameters["rooms"]);
                AdultsCount = Convert.ToInt32(parameters["adults"]);
                ChildrenCount = Convert.ToInt32(parameters["children"]);
                var id = Convert.ToInt32(parameters["location"]);
                Metro_Area = context.Metro_Areas.First(c => c.ID == id);
                if(!string.IsNullOrEmpty(parameters["hotelID"])) {
                    HotelId = Convert.ToInt32(parameters["hotelID"]);
                    Hotel = context.Hotels.First(h => h.ID == HotelId);
                }
                if(!string.IsNullOrEmpty(parameters["roomID"])) {
                    id = Convert.ToInt32(parameters["roomID"]);
                    Room = context.Rooms.First(r => r.ID == id);
                }
            } catch {
                ValidState = false;
            }
        }

        FilterCustomerRating = parameters["custrating"];
        FilterLocationRating = parameters["locrating"];
        FilterMaxPrice = parameters["maxprice"];
        FilterMinPrice = parameters["minprice"];
        FilterOurRating = parameters["ourrating"];
    }

    public string Page { get; set; }

    public HotelBookingDataContext DataContext { get; set; }
    public DateTime CheckInDate { get; set; }
    public DateTime CheckOutDate { get; set; }
    public int RoomsCount { get; set; }
    public int AdultsCount { get; set; }
    public int ChildrenCount { get; set; }

    public int HotelId { get; set; }

    public Hotel Hotel { get; set; }
    public Metro_Areas Metro_Area { get; set; }
    public Room Room { get; set; }
    public bool ValidState {
        get { return validState; }
        set { validState = value; }
    }

    public int NightsCount { get { return (CheckOutDate - CheckInDate).Days; } }

    public string StartFilterText {
        get {
            var paramsList = new List<string>();
            paramsList.Add(string.Format("{0} {1}", NightsCount, NightsCount > 1 ? "nights" : "night"));
            paramsList.Add(string.Format("{0} {1}", RoomsCount, RoomsCount > 1 ? "rooms" : "room"));
            paramsList.Add(string.Format("{0} {1}", AdultsCount, AdultsCount > 1 ? "adults" : "adult"));
            if(ChildrenCount > 0)
                paramsList.Add(string.Format("{0} {1}", ChildrenCount, ChildrenCount > 1 ? "child" : "children"));
            return string.Format("{0} - {1}<br/>{2}", CheckInDate.ToString("MMM d"), CheckOutDate.ToString("MMM d, yyyy"), string.Join(", ", paramsList));
        }
    }

    public string FilterMinPrice { get; set; }
    public string FilterMaxPrice { get; set; }
    public string FilterCustomerRating { get; set; }
    public string FilterOurRating { get; set; }
    public int[] FilterOurRatingArray {
        get {
            if(string.IsNullOrEmpty(FilterOurRating))
                return new int[] { 1, 2, 3, 4, 5 };
            else
                return FilterOurRating.Split(',').Select(s => Convert.ToInt32(s)).ToArray();
        }
    }
    public string FilterLocationRating { get; set; }

    public NameValueCollection GetQueryParameters(bool addFilterParameters) {
        var parameters = new NameValueCollection();
        parameters["location"] = Metro_Area.ID.ToString();
        parameters["checkin"] = CheckInDate.ToString("M-d-yyyy");
        parameters["checkout"] = CheckOutDate.ToString("M-d-yyyy");
        parameters["rooms"] = RoomsCount.ToString();
        parameters["adults"] = AdultsCount.ToString();
        parameters["children"] = ChildrenCount.ToString();
        if(Hotel != null)
            parameters["hotelID"] = Hotel.ID.ToString();
        if(Room != null)
            parameters["roomID"] = Room.ID.ToString();
        if(addFilterParameters) {
            if(!string.IsNullOrEmpty(FilterCustomerRating))
                parameters["custrating"] = FilterCustomerRating;
            if(!string.IsNullOrEmpty(FilterLocationRating))
                parameters["locrating"] = FilterLocationRating;
            if(!string.IsNullOrEmpty(FilterMaxPrice))
                parameters["maxprice"] = FilterMaxPrice;
            if(!string.IsNullOrEmpty(FilterMinPrice))
                parameters["minprice"] = FilterMinPrice;
            if(!string.IsNullOrEmpty(FilterOurRating))
                parameters["ourrating"] = FilterOurRating;
        }
        return parameters;
    }

    public static SearchState CreateSearchState(NameValueCollection parameters, string pageName) {
        var isValidParams = false;

        switch(pageName) {
            case "Booking":
                isValidParams = ValidateBookingPageParameters(parameters);
                break;
            case "Details":
                isValidParams = ValidateDetailsPageParameters(parameters);
                break;
            case "Results":
                isValidParams = ValidateResultsPageParameters(parameters);
                break;
        }

        return isValidParams ? new SearchState(pageName, parameters, new HotelBookingDataContext()) : null;
    }
    protected static bool ValidateResultsPageParameters(NameValueCollection parameters) {
        return
            !string.IsNullOrEmpty(parameters["rooms"]) &&
            !string.IsNullOrEmpty(parameters["adults"]) &&
            !string.IsNullOrEmpty(parameters["children"]) &&
            !string.IsNullOrEmpty(parameters["checkin"]) &&
            !string.IsNullOrEmpty(parameters["checkout"]) &&
            !string.IsNullOrEmpty(parameters["location"]);
    }
    protected static bool ValidateDetailsPageParameters(NameValueCollection parameters) {
        return
            ValidateResultsPageParameters(parameters) &&
            !string.IsNullOrEmpty(parameters["hotelID"]);
    }
    protected static bool ValidateBookingPageParameters(NameValueCollection parameters) {
        return
            ValidateDetailsPageParameters(parameters) &&
            !string.IsNullOrEmpty(parameters["roomID"]);
    }
}
