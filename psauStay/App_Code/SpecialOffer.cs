using HotelBookingContext;

public class SpecialOffer {
    public SpecialOffer(City city, Hotel hotel) {
        City = city;
        Hotel = hotel;
    }
    public City City { get; set; }
    public Hotel Hotel { get; set; }
}
