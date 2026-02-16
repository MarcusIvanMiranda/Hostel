<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PSAUStay.DefaultPage" MasterPageFile="~/Site.Master" %>

<asp:content id="Content1" contentplaceholderid="MainContent" runat="server">
    <div class="hero-section">
        <div class="hero-overlay"></div>
        <div class="container hero-content text-center">
            <h1 class="display-2 fw-bold mb-3">Welcome to PSAU Hostel</h1>
            <p class="fs-4 mb-5 opacity-90">Experience comfort and convenience within the heart of the campus.</p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href='<%= ResolveUrl("~/Booking.aspx") %>' class="btn btn-psau-gold btn-lg shadow-lg">
                    <i class="bi bi-calendar-check me-2"></i>Book Your Stay Now
                </a>
                <a href='<%= ResolveUrl("~/RoomList.aspx") %>' class="btn btn-outline-light btn-lg shadow-lg">
                    <i class="bi bi-door-open me-2"></i>View All Rooms
                </a>
            </div>
        </div>
    </div>

    <div class="container py-5" id="rooms">
        <div class="text-center mb-5">
            <h2 class="section-title">Our Accommodations</h2>
            <p class="text-muted">Select from our range of well-maintained rooms.</p>
        </div>
        
        <div class="row g-4">
            <asp:Repeater ID="rptRooms" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="card h-100 room-card-static shadow-sm border-0">
                            <div class="img-wrapper">
                                <img src='<%# ResolveUrl(Eval("Image1").ToString()) %>' 
                                     class="card-img-top cycle-image" 
                                     alt="Room Image" 
                                     data-images='<%# ResolveUrl(Eval("Image1").ToString()) %>,<%# Eval("Image2") != DBNull.Value ? ResolveUrl(Eval("Image2").ToString()) : "" %>,<%# Eval("Image3") != DBNull.Value ? ResolveUrl(Eval("Image3").ToString()) : "" %>' />
                            </div>
                            <div class="card-body p-4">
                                <span class="badge bg-success-subtle text-success mb-2"><%# Eval("RoomType") %></span>
                                <h4 class="fw-bold mb-3 text-dark"><%# Eval("RoomName") %></h4>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-muted small"><i class="bi bi-people me-2"></i><%# Eval("Capacity") %> pax</span>
                                    <span class="fw-bold text-success fs-5">₱<%# Eval("Price", "{0:N2}") %></span>
                                </div>
                                <div class="text-muted small mt-1 text-end">per night</div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <div class="container py-5 border-top" id="facilities">
        <div class="text-center mb-5">
            <h2 class="section-title">Our Facilities</h2>
            <p class="text-muted">Premium spaces designed for university functions and events.</p>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptFacilities" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="card h-100 room-card-static shadow-sm border-0">
                            <div class="img-wrapper">
                                <img src='<%# ResolveUrl(Eval("Image1").ToString()) %>' 
                                     class="card-img-top cycle-image" 
                                     alt="Facility Image" 
                                     data-images='<%# ResolveUrl(Eval("Image1").ToString()) %>,<%# Eval("Image2") != DBNull.Value ? ResolveUrl(Eval("Image2").ToString()) : "" %>,<%# Eval("Image3") != DBNull.Value ? ResolveUrl(Eval("Image3").ToString()) : "" %>' />
                            </div>
                            <div class="card-body p-4">
                                <span class="badge bg-info-subtle text-info mb-2"><%# Eval("FacilityType") %></span>
                                <h4 class="fw-bold mb-3 text-dark"><%# Eval("FacilityName") %></h4>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-success fs-5">₱<%# Eval("Price", "{0:N2}") %></span>
                                    <span class="badge border text-dark"><i class="bi bi-people-fill me-1"></i><%# Eval("Capacity") %> Pax</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <style>
        .hero-section {
            position: relative;
            background: url('<%= ResolveUrl("~/images/Background01.jpg") %>') no-repeat center center;
            background-size: cover;
            min-height: 75vh;
            display: flex;
            align-items: center;
            color: white;
            margin-top: -5px;
        }

        .hero-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(0,0,0,0.65), rgba(0,0,0,0.3));
        }

        .hero-content { position: relative; z-index: 5; }

        .btn-psau-gold {
            background-color: var(--psau-gold);
            color: #212529;
            font-weight: 700;
            padding: 15px 40px;
            border-radius: 50px;
            transition: all 0.3s;
            border: none;
        }

        .btn-psau-gold:hover {
            background-color: #e69612;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .room-card-static {
            border-radius: 15px;
            overflow: hidden;
            background: #fff;
            transition: transform 0.3s ease;
        }

        .room-card-static:hover {
            transform: translateY(-5px);
        }

        .img-wrapper {
            height: 250px;
            overflow: hidden;
            background-color: #ffffff; 
        }

        .cycle-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: opacity 0.5s ease-in-out;
            opacity: 1;
        }

        .section-title {
            font-weight: 700;
            color: var(--psau-green);
            position: relative;
            padding-bottom: 15px;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 25%;
            width: 50%;
            height: 4px;
            background: var(--psau-gold);
            border-radius: 2px;
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const imagesToCycle = document.querySelectorAll('.cycle-image');

            imagesToCycle.forEach(img => {
                const imageList = img.getAttribute('data-images')
                    .split(',')
                    .map(s => s.trim())
                    .filter(path => path !== "" && !path.includes("DBNull"));

                if (imageList.length > 1) {
                    let currentIndex = 0;

                    setInterval(() => {

                        img.style.opacity = "0";

                        setTimeout(() => {
                            currentIndex = (currentIndex + 1) % imageList.length;
                            img.src = imageList[currentIndex];

                            img.style.opacity = "1";
                        }, 500);

                    }, 5000);
                }
            });
        });
    </script>
</asp:content>