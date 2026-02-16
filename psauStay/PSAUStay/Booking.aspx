<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="PSAUStay.Booking" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="text-center mb-5">
            <h2 class="section-title">Available Accommodations</h2>
            <p class="text-secondary fs-5">Choose your preferred room and start your reservation.</p>
        </div>

        <div class="row g-4 mb-5">
            <asp:Repeater ID="rptRooms" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="booking-card shadow-sm h-100">
                            <div class="position-relative overflow-hidden">
                                <img src='<%# ResolveUrl(Eval("Image1").ToString()) %>' class="img-fluid booking-img" alt="Room" />
                                <div class="price-overlay">
                                    ₱<%# Eval("Price", "{0:N0}") %> <small>/ night</small>
                                </div>
                            </div>
                            <div class="p-4">
                                <h4 class="fw-bold text-dark"><%# Eval("RoomName") %></h4>
                                <p class="text-muted small mb-3">
                                    <i class="bi bi-info-circle me-1"></i>
                                    <%# string.IsNullOrEmpty(Eval("RoomDescription").ToString()) ? "Standard university accommodation." : Eval("RoomDescription") %>
                                </p>
                                <ul class="list-unstyled mb-4 small text-secondary">
                                    <li class="mb-2"><i class="bi bi-door-open text-success me-2"></i><strong>Type:</strong> <%# Eval("RoomType") %></li>
                                    <li><i class="bi bi-people text-success me-2"></i><strong>Max Capacity:</strong> <%# Eval("Capacity") %> pax</li>
                                </ul>
                                <a href='<%# "OnlineBooking.aspx?RoomID=" + Eval("RoomID") %>' class="btn btn-booking w-100 py-2">Reserve This Room</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="text-center mb-5 mt-5 pt-4">
            <h2 class="section-title">Event Facilities</h2>
            <p class="text-secondary fs-5">Premium spaces designed for university functions and events.</p>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptFacilities" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="booking-card shadow-sm h-100 border-top border-info border-3">
                            <div class="position-relative overflow-hidden">
                                <img src='<%# ResolveUrl(Eval("Image1").ToString()) %>' class="img-fluid booking-img" alt="Facility" />
                                <div class="price-overlay bg-info text-white">
                                    ₱<%# Eval("Price", "{0:N0}") %> <small>/ event</small>
                                </div>
                            </div>
                            <div class="p-4">
                                <h4 class="fw-bold text-dark"><%# Eval("FacilityName") %></h4>
                                <span class="badge bg-info-subtle text-info mb-3"><%# Eval("FacilityType") %></span>
                                <ul class="list-unstyled mb-4 small text-secondary">
                                    <li><i class="bi bi-people-fill text-info me-2"></i><strong>Capacity:</strong> Up to <%# Eval("Capacity") %> Pax</li>
                                </ul>
                                <a href='<%# "OnlineBooking.aspx?FacilityID=" + Eval("FacilityID") %>' class="btn btn-info w-100 py-2 text-white fw-bold">Book This Facility</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <%# rptFacilities.Items.Count == 0 ? "<div class='col-12 text-center text-muted py-5'><p>No facilities available for booking at the moment.</p></div>" : "" %>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>

    <style>
        .section-title { font-weight: 700; color: #1b5e20; position: relative; padding-bottom: 15px; display: inline-block; }
        .section-title::after { content: ''; position: absolute; bottom: 0; left: 25%; width: 50%; height: 4px; background: #FFC107; border-radius: 2px; }
        .booking-card { background: #fff; border-radius: 20px; overflow: hidden; border: 1px solid rgba(0,0,0,0.05); transition: all 0.3s ease; }
        .booking-card:hover { box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important; transform: translateY(-5px); }
        .booking-img { height: 220px; width: 100%; object-fit: cover; }
        .price-overlay { position: absolute; top: 20px; right: 0; background: #FFC107; color: #212529; padding: 5px 20px; font-weight: 700; border-radius: 20px 0 0 20px; }
        .btn-booking { background-color: #1b5e20; color: white; border-radius: 10px; font-weight: 600; }
        .btn-info { background-color: #0dcaf0; border-radius: 10px; border: none; }
    </style>
</asp:Content>