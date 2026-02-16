<%@ Page Title="Online Booking" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OnlineBooking.aspx.cs" Inherits="PSAUStay.OnlineBooking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="upBookingForm" runat="server">
        <ContentTemplate>
            <div class="booking-wrapper py-5 px-3 px-lg-5">
                <div class="container">
                    <div class="row g-5 justify-content-center">
                        
                        <div class="col-lg-5">
                            <asp:Panel ID="roomPreviewPanel" runat="server" Visible="false" CssClass="preview-card animate__animated animate__fadeIn">
                                <div class="image-container">
                                    <asp:Image ID="imgMainPreview" runat="server" CssClass="preview-img" />
                                    <div class="price-tag">
                                        <span class="currency">₱</span>
                                        <span class="amount"><asp:Literal ID="litPriceOverlay" runat="server" /></span>
                                        <span class="period">/ night</span>
                                    </div>
                                </div>
                                <div class="preview-content">
                                    <h3 class="preview-title">Room Details</h3>
                                    <p class="preview-text">
                                        <asp:Literal ID="litRoomDescription" runat="server" />
                                    </p>
                                    <div class="availability-status shadow-sm">
                                        <i class="fas fa-check-circle me-2 text-success"></i>
                                        Status: <span class="fw-bold ms-1"><asp:Literal ID="litAvailableCount" runat="server" /> available</span>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlPlaceholder" runat="server" CssClass="placeholder-card h-100 shadow-sm border-0">
                                <div class="text-center">
                                    <div class="icon-circle mb-4">
                                        <i class="fas fa-bed"></i>
                                    </div>
                                    <h5 class="text-muted">Explore Our Rooms</h5>
                                    <p class="small text-muted px-4">Select a room type to see high-quality photos and detailed amenities.</p>
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="col-lg-6">
                            <div class="form-card shadow-lg border-0">
                                <div class="card-header-accent"></div>
                                <div class="card-body p-4 p-md-5">
                                    <div class="mb-4">
                                        <h2 class="form-title">Room Reservation</h2>
                                        <p class="text-muted small">Fill out the details below to secure your stay.</p>
                                    </div>

                                    <asp:Label ID="lblAvailabilityMsg" runat="server" CssClass="alert alert-danger d-block mb-3" Visible="false"></asp:Label>

                                    <div class="form-group mb-4">
                                        <label class="custom-label"><i class="fas fa-hotel me-2"></i>Select Room Type <span class="text-danger">*</span></label>
                                        <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-select custom-input"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlRoomType_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvRoomType" runat="server" ControlToValidate="ddlRoomType" 
                                            InitialValue="0" ErrorMessage="Please select a room category." CssClass="validation-text" Display="Dynamic" />
                                    </div>

                                    <asp:Panel ID="pnlRoomNumber" runat="server" Visible="false" CssClass="form-group mb-4">
                                        <label class="custom-label"><i class="fas fa-door-open me-2"></i>Specific Room No. <span class="text-danger">*</span></label>
                                        <asp:DropDownList ID="ddlRoomNumber" runat="server" CssClass="form-select custom-input">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvRoomNo" runat="server" ControlToValidate="ddlRoomNumber" 
                                            InitialValue="0" ErrorMessage="Please select a room number." CssClass="validation-text" Display="Dynamic" />
                                    </asp:Panel>

                                    <asp:Panel ID="pnlInputs" runat="server" Enabled="false" CssClass="form-section-details">
                                        <div class="row g-3">
                                            <div class="col-md-12 mb-3">
                                                <label class="custom-label">Full Name <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control custom-input" placeholder="Juan Dela Cruz" />
                                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" 
                                                    ErrorMessage="Full name is required." CssClass="validation-text" Display="Dynamic" />
                                            </div>
                                            <div class="col-md-12 mb-3">
                                                <label class="custom-label">Email Address <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control custom-input" TextMode="Email" placeholder="juan@example.com" />
                                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                                    ErrorMessage="Email is required." CssClass="validation-text" Display="Dynamic" />
                                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                                    ErrorMessage="Please enter a valid email address." CssClass="validation-text" Display="Dynamic"
                                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                                <asp:CustomValidator ID="cvEmailValid" runat="server" ControlToValidate="txtEmail"
                                                    ErrorMessage="Email address must be valid and deliverable." CssClass="validation-text" Display="Dynamic"
                                                    OnServerValidate="cvEmailValid_ServerValidate" />
                                            </div>
                                            <div class="col-md-12 mb-3">
                                                <label class="custom-label">Contact Number <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="txtContact" runat="server" CssClass="form-control custom-input" placeholder="09123456789" />
                                                <asp:RequiredFieldValidator ID="rfvContact" runat="server" ControlToValidate="txtContact" 
                                                    ErrorMessage="Contact number is required." CssClass="validation-text" Display="Dynamic" />
                                                <asp:RegularExpressionValidator ID="revContact" runat="server" ControlToValidate="txtContact"
                                                    ErrorMessage="Please enter a valid contact number." CssClass="validation-text" Display="Dynamic"
                                                    ValidationExpression="^[0-9]{10,11}$" />
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="custom-label">Check-in <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="txtCheckIn" runat="server" CssClass="form-control custom-input" TextMode="Date" AutoPostBack="true" OnTextChanged="CalculateTotal" />
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="custom-label">Check-out <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="txtCheckOut" runat="server" CssClass="form-control custom-input" TextMode="Date" AutoPostBack="true" OnTextChanged="CalculateTotal" />
                                            </div>
                                        </div>

                                        <asp:Panel ID="pnlPriceSummary" runat="server" Visible="false" CssClass="summary-card mt-4 mb-4">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="summary-label">
                                                    <span class="text-uppercase tracking-wider small fw-bold">Grand Total</span>
                                                </div>
                                                <div class="summary-value">
                                                    <span class="currency">₱</span><asp:Literal ID="litTotalPrice" runat="server" />
                                                </div>
                                            </div>
                                        </asp:Panel>

                                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary-booking w-100"
                                            Text="Confirm & Book Now" OnClick="btnSubmit_Click" />
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <style>
        :root {
            --primary-green: #2d5a27;
            --accent-gold: #FFC107;
            --bg-soft: #f4f7f6;
            --white: #ffffff;
            --text-dark: #1a1a1a;
        }

        .booking-wrapper { background-color: var(--bg-soft); min-height: 90vh; }

        /* Preview Card Styles */
        .preview-card { background: var(--white); border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05); height: 100%; border: none; }
        .image-container { position: relative; height: 350px; }
        .preview-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .preview-card:hover .preview-img { transform: scale(1.05); }
        
        .price-tag { 
            position: absolute; bottom: 20px; left: 20px; 
            background: rgba(45, 90, 39, 0.9); backdrop-filter: blur(5px);
            color: white; padding: 10px 20px; border-radius: 12px; font-weight: 600;
        }
        .price-tag .amount { font-size: 1.4rem; font-weight: 700; }
        .price-tag .period { font-size: 0.85rem; opacity: 0.8; }

        .preview-content { padding: 30px; }
        .preview-title { color: var(--primary-green); font-weight: 700; border-left: 4px solid var(--primary-green); padding-left: 15px; margin-bottom: 20px; }
        .availability-status { background: #e8f5e9; padding: 12px 20px; border-radius: 10px; color: #2e7d32; display: inline-block; font-size: 0.9rem; }

        /* Form Card Styles */
        .form-card { background: var(--white); border-radius: 20px; position: relative; overflow: hidden; }
        .card-header-accent { height: 8px; background: var(--primary-green); width: 100%; }
        .form-title { color: var(--text-dark); font-weight: 800; letter-spacing: -0.5px; }
        
        .custom-label { font-size: 0.9rem; font-weight: 600; color: #444; margin-bottom: 8px; display: block; }
        .custom-input { 
            border: 2px solid #eee; padding: 12px 15px; border-radius: 10px; transition: all 0.3s ease; font-size: 1rem;
        }
        .custom-input:focus { 
            border-color: var(--primary-green); box-shadow: 0 0 0 4px rgba(45, 90, 39, 0.1); outline: none; 
        }

        /* Summary & Button */
        .summary-card { 
            background: linear-gradient(135deg, #2d5a27 0%, #1e3d1a 100%); 
            padding: 25px; border-radius: 15px; color: white;
        }
        .summary-value { font-size: 1.8rem; font-weight: 700; }
        .summary-value .currency { font-size: 1rem; margin-right: 2px; vertical-align: super; }

        .btn-primary-booking { 
            background: var(--primary-green); color: white; padding: 16px; border-radius: 12px;
            font-weight: 700; text-transform: uppercase; letter-spacing: 1px; border: none;
            transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(45, 90, 39, 0.2);
        }
        .btn-primary-booking:hover { 
            background: #1e3d1a; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(45, 90, 39, 0.3); color: white;
        }

        /* Placeholder */
        .placeholder-card { 
            border: 2px dashed #cbd5e0 !important; background: transparent; 
            display: flex; align-items: center; justify-content: center; border-radius: 20px;
        }
        .icon-circle { 
            width: 80px; height: 80px; background: #fff; border-radius: 50%; 
            display: flex; align-items: center; justify-content: center; 
            margin: 0 auto; color: #cbd5e0; font-size: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .validation-text { font-size: 0.8rem; color: #dc3545; margin-top: 5px; font-weight: 500; }
    </style>
</asp:Content>