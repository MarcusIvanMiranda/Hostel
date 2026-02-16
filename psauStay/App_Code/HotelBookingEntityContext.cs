using System;
using System.Data.Entity;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;

namespace HotelBookingContext {
    public partial class HotelBookingDataContext : ContextBase {
        public HotelBookingDataContext()
            : this("HotelBookingConnectionString") {
        }
        public HotelBookingDataContext(string connectionString)
            : base(connectionString) {
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder) {
            modelBuilder.Configurations.Add(new CityMap());
            modelBuilder.Configurations.Add(new HotelMap());
            modelBuilder.Configurations.Add(new PictureMap());
            modelBuilder.Configurations.Add(new ReservationsMap());
            modelBuilder.Configurations.Add(new ReviewsMap());
            modelBuilder.Configurations.Add(new RoomMap());
            modelBuilder.Configurations.Add(new Room_FeatureMap());
            modelBuilder.Configurations.Add(new Hotel_FeaturesMap());
            modelBuilder.Configurations.Add(new Metro_AreasMap());
        }

        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<Features_List> Features_List { get; set; }
        public virtual DbSet<Guests> Guests { get; set; }
        public virtual DbSet<Hotel_Features> Hotel_Features { get; set; }
        public virtual DbSet<Hotel_Images> Hotel_Images { get; set; }
        public virtual DbSet<Hotel> Hotels { get; set; }
        public virtual DbSet<Metro_Areas> Metro_Areas { get; set; }
        public virtual DbSet<Picture> Pictures { get; set; }
        public virtual DbSet<Reservations> Reservations { get; set; }
        public virtual DbSet<Reviews> Reviews { get; set; }
        public virtual DbSet<Room_Feature> Room_Features { get; set; }
        public virtual DbSet<Room_Types> Room_Types { get; set; }
        public virtual DbSet<Room> Rooms { get; set; }
    }

    public partial class City {
        public City() {
            Hotels = new HashSet<Hotel>();
        }

        public int ID { get; set; }
        public string City_Name { get; set; }
        public string State_Province { get; set; }
        public string Country { get; set; }
        public string Offer { get; set; }
        public string City_Image { get; set; }
        public int? Metro_Area_ID { get; set; }

        public virtual Metro_Areas Metro_Areas { get; set; }
        public virtual ICollection<Hotel> Hotels { get; set; }
    }
    public partial class CityMap : EntityTypeConfiguration<City> {
        public CityMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Cities");

            this.Property(t => t.Metro_Area_ID).HasColumnName("Metro_Area_ID");

            this.HasRequired(t => t.Metro_Areas)
                .WithMany(t => t.Cities)
                .HasForeignKey(d => d.Metro_Area_ID);
        }
    }

    public partial class Features_List {
        public int ID { get; set; }
        public string Feature_Name { get; set; }
    }

    public partial class Guests {
        public int ID { get; set; }
        public string First_Name { get; set; }
        public string Last_Name { get; set; }
        public string Title { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Postal_Code { get; set; }
        public string Country { get; set; }
        public string Phone_Number { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public partial class Hotel_Features {
        public int ID { get; set; }
        public int? Hotel_ID { get; set; }
        public string Description { get; set; }

        public virtual Hotel Hotels { get; set; }
    }
    public partial class Hotel_FeaturesMap : EntityTypeConfiguration<Hotel_Features> {
        public Hotel_FeaturesMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Hotel_Features");

            this.HasRequired(t => t.Hotels)
                .WithMany(t => t.Hotel_Features)
                .HasForeignKey(d => d.Hotel_ID);
        }
    }

    public partial class Hotel_Images {
        public int ID { get; set; }
        public int? Hotel_ID { get; set; }
        public string Image_Id { get; set; }

        public virtual Hotel Hotels { get; set; }
    }
    public partial class Hotel_ImagesMap : EntityTypeConfiguration<Hotel_Images> {
        public Hotel_ImagesMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Hotel_Images");

            this.HasRequired(t => t.Hotels)
                .WithMany(t => t.Hotel_Images)
                .HasForeignKey(d => d.Hotel_ID);
        }
    }

    public partial class Hotel {
        public Hotel() {
            Hotel_Features = new HashSet<Hotel_Features>();
            Rooms = new List<Room>();
            Pictures = new List<Picture>();
            Hotel_Images = new HashSet<Hotel_Images>();
            Reviews = new HashSet<Reviews>();
        }

        public int ID { get; set; }
        public string Hotel_Name { get; set; }
        public string Description { get; set; }
        public string Hotel_Class { get; set; }
        public int? Room_Count { get; set; }
        public string Location_Rating { get; set; }
        public double? Avg_Customer_Rating { get; set; }
        public double? Our_Rating { get; set; }
        public string Address { get; set; }
        public int? City_ID { get; set; }
        public string Postal_Code { get; set; }
        public string Phone { get; set; }
        public string Website { get; set; }
        public string Metro_Area { get; set; }

        public virtual City Cities { get; set; }
        public virtual ICollection<Hotel_Features> Hotel_Features { get; set; }
        public virtual List<Room> Rooms { get; set; }
        public virtual List<Picture> Pictures { get; set; }
        public virtual ICollection<Hotel_Images> Hotel_Images { get; set; }
        public virtual ICollection<Reviews> Reviews { get; set; }
    }
    public partial class HotelMap : EntityTypeConfiguration<Hotel> {
        public HotelMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Hotels");

            this.HasRequired(t => t.Cities)
                .WithMany(t => t.Hotels)
                .HasForeignKey(d => d.City_ID);
        }
    }

    public partial class Metro_Areas {
        public Metro_Areas() {
            Cities = new HashSet<City>();
        }

        public int ID { get; set; }
        public string Area_Name { get; set; }
        public string Map_Image { get; set; }
        public string Country { get; set; }
        public string City { get; set; }

        public virtual ICollection<City> Cities { get; set; }
    }
    public partial class Metro_AreasMap : EntityTypeConfiguration<Metro_Areas> {
        public Metro_AreasMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Metro_Areas");
            this.Property(t => t.Area_Name).HasColumnName("Area_Name");
        }
    }

    public partial class Picture {
        public int ID { get; set; }
        public string Picture_Id { get; set; }
        public int? Hotel_ID { get; set; }
        public int? Room_ID { get; set; }

        public virtual Room Rooms { get; set; }
        public virtual Hotel Hotels { get; set; }
    }
    public partial class PictureMap : EntityTypeConfiguration<Picture> {
        public PictureMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Pictures");

            this.HasRequired(t => t.Hotels)
                .WithMany(t => t.Pictures)
                .HasForeignKey(t => t.Hotel_ID);

            this.HasOptional(t => t.Rooms)
                .WithMany(t => t.Pictures)
                .HasForeignKey(t => t.Room_ID);
        }
    }

    public partial class Reservations {
        public int ID { get; set; }
        public int? Room_ID { get; set; }
        public DateTime? Check_In { get; set; }
        public DateTime? Check_Out { get; set; }
        public decimal? Amount_Due { get; set; }
        public decimal? Amount_Paid { get; set; }
        public int? Reservation_Satus { get; set; }
        public int? Number_Of_Adults { get; set; }
        public int? Number_Of_Children { get; set; }
        public string Special_Requests { get; set; }

        public virtual Room Rooms { get; set; }
    }
    public partial class ReservationsMap : EntityTypeConfiguration<Reservations> {
        public ReservationsMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Reservations");

            this.HasRequired(t => t.Rooms)
                .WithMany(t => t.Reservations)
                .HasForeignKey(d => d.Room_ID);
        }
    }

    public partial class Reviews {
        public int ID { get; set; }
        public int? Hotel_ID { get; set; }
        public string Review_Text { get; set; }
        public DateTime? Posted_On { get; set; }
        public double? Rating { get; set; }
        public string Reviewer_Name { get; set; }

        public virtual Hotel Hotel { get; set; }
    }
    public partial class ReviewsMap : EntityTypeConfiguration<Reviews> {
        public ReviewsMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Reviews");

            this.Property(t => t.Hotel_ID).HasColumnName("Hotel_ID");

            this.HasOptional(t => t.Hotel)
                .WithMany(t => t.Reviews)
                .HasForeignKey(d => d.Hotel_ID);
        }
    }

    public partial class Room_Feature {
        public int ID { get; set; }
        public int? Room_ID { get; set; }
        public string Description { get; set; }
        public string Feature_Image { get; set; }

        public virtual Room Rooms { get; set; }
    }
    public partial class Room_FeatureMap : EntityTypeConfiguration<Room_Feature> {
        public Room_FeatureMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Room_Features");

            this.HasOptional(t => t.Rooms)
                .WithMany(t => t.Room_Features)
                .HasForeignKey(t => t.Room_ID);
        }
    }

    public partial class Room_Types {
        public Room_Types() {
            Rooms = new HashSet<Room>();
        }

        public int ID { get; set; }
        public string Type_Name { get; set; }

        public virtual ICollection<Room> Rooms { get; set; }
    }

    public partial class Room {
        public Room() {
            Pictures = new HashSet<Picture>();
            Room_Features = new HashSet<Room_Feature>();
            Reservations = new HashSet<Reservations>();
        }

        public int ID { get; set; }
        public int? Hotel_ID { get; set; }
        public int? Room_Type { get; set; }
        public string Room_Short_Description { get; set; }
        public decimal? Nighly_Rate { get; set; }
        public string Room_Image1 { get; set; }
        public string Room_Image2 { get; set; }
        public string Room_Image3 { get; set; }
        public string Room_Image4 { get; set; }
        public string Room_image5 { get; set; }

        public virtual ICollection<Picture> Pictures { get; set; }
        public virtual Room_Types Room_Types { get; set; }
        public virtual Hotel Hotels { get; set; }
        public virtual ICollection<Room_Feature> Room_Features { get; set; }
        public virtual ICollection<Reservations> Reservations { get; set; }
    }
    public partial class RoomMap : EntityTypeConfiguration<Room> {
        public RoomMap() {
            this.HasKey(t => t.ID);

            this.ToTable("Rooms");

            this.HasRequired(t => t.Hotels)
                .WithMany(t => t.Rooms)
                .HasForeignKey(d => d.Hotel_ID);

            this.HasOptional(t => t.Room_Types)
                .WithMany(t => t.Rooms)
                .HasForeignKey(d => d.Room_Type);
        }
    }
}
