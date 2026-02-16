using System;
using System.Linq;

namespace HotelBookingContext {
    public partial class City {
        public string DisplayName {
            get {
                if(string.IsNullOrEmpty(State_Province))
                    return string.Format("{0}, {1}", City_Name, Country);
                else
                    return string.Format("{0}, {1}, {2}", City_Name, State_Province, Country);
            }
        }
        public Hotel CheapestHotel {
            get {
                return Hotels.Aggregate((h1, h2) => {
                    return h1.StartPrice < h2.StartPrice ? h1 : h2;
                });
            }
        }
        public string City_Image_Url {
            get { return string.Format("~/Content/Cities/{0}", City_Image).Replace(".png", ".jpg"); }
        }
    }

    public partial class Hotel {
        public decimal StartPrice {
            get {
                return Rooms.Min(r => r.Nighly_Rate).Value;
            }
        }
        public decimal EndPrice {
            get {
                return Rooms.Max(r => r.Nighly_Rate).Value;
            }
        }
        public string DetailsCity {
            get {
                if(!string.IsNullOrEmpty(Cities.State_Province))
                    return string.Format("{0}, {1} {2}, {3}", Cities.City_Name, Cities.State_Province, Postal_Code, Cities.Country);
                return string.Format("{0} {1}, {2}", Cities.City_Name, Postal_Code, Cities.Country);
            }
        }
        public Picture PrimaryPicture {
            get {
                if(Pictures.Any())
                    return Pictures[0];
                return new Picture();
            }
        }
        public Picture SecondaryPicture {
            get {
                if(Pictures.Count > 1)
                    return Pictures[1];
                return new Picture();
            }
        }
        public int RoundRating {
            get {
                return (int)Math.Round(Customer_Rating);
            }
        }
        public decimal Customer_Rating {
            get {
                return DataProvider.CustomRatings.ContainsKey(ID) ? DataProvider.CustomRatings[ID] : Convert.ToDecimal(Avg_Customer_Rating.Value);
            }
        }
    }

    public partial class Picture {
        public string Url {
            get {
                if(!string.IsNullOrEmpty(Picture_Id))
                    return "~/Content/Pictures/" + Picture_Id;
                return "~/Content/Images/no-image.png";
            }
        }
    }

    public partial class Room_Feature {
        public string ImageUrl {
            get { return string.Format("~/Content/RoomFeatures/{0}", Feature_Image); }
        }
    }

    public partial class Room {
        public DateTime PriceAvailableDate {
            get { return DateTime.Now; }
        }
    }

    public partial class Metro_Areas {
        public string Map_ImageUrl {
            get {
                return string.Format("~/Content/Maps/{0}", Map_Image);
            }
        }
        public int Hotels_Count {
            get {
                return Cities.SelectMany(c => c.Hotels).Count();
            }
        }

        public decimal MinRoomPrice {
            get {
                return Cities.SelectMany(c => c.Hotels).SelectMany(h => h.Rooms).Min(r => r.Nighly_Rate).Value;
            }
        }
        public decimal MaxRoomPrice {
            get {
                return Cities.SelectMany(c => c.Hotels).SelectMany(h => h.Rooms).Max(r => r.Nighly_Rate).Value;
            }
        }
    }
}
