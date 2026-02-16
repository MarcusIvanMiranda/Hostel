<%@ Page Title="Booking Success" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookingSuccess.aspx.cs" Inherits="PSAUStay.BookingSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">
                <!-- Success Header Section -->
                <div class="success-header text-center mb-4">
                    <div class="success-icon-wrapper mb-3">
                        <div class="success-icon">
                            <i class="bi bi-check-circle-fill"></i>
                        </div>
                    </div>
                    <h1 class="success-title">Booking Submitted!</h1>
                    <p class="success-subtitle">Reference Number: <span class="fw-bold">#<asp:Literal ID="litRefNumber" runat="server" /></span></p>
                </div>

                <!-- Email Status Alert -->
                <asp:Label ID="lblEmailStatus" runat="server" CssClass="alert alert-info d-block small mb-4" Visible="false"></asp:Label>

                <!-- Main Content Card -->
                <div class="booking-card">
                    <div class="card-body">
                        <!-- Guest Information Section -->
                        <div class="info-section">
                            <h5 class="section-title">Reservation Details</h5>
                            <div class="info-grid">
                                <div class="info-item">
                                    <label class="info-label">Guest Name</label>
                                    <p class="info-value"><asp:Literal ID="litGuestName" runat="server" /></p>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Contact Number</label>
                                    <p class="info-value"><asp:Literal ID="litContact" runat="server" /></p>
                                </div>
                                <div class="info-item full-width">
                                    <label class="info-label">Stay Dates</label>
                                    <p class="info-value"><asp:Literal ID="litDates" runat="server" /></p>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Information Section -->
                        <div class="payment-section">
                            <div class="payment-details">
                                <div class="payment-row">
                                    <span class="payment-label">Total Room Price:</span>
                                    <span class="payment-value">₱<asp:Literal ID="litTotalPrice" runat="server" /></span>
                                </div>
                                <div class="payment-row total-row">
                                    <span class="payment-label total-label">Required Payment:</span>
                                    <span class="payment-value total-value">₱<asp:Literal ID="litDownpayment" runat="server" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- Action Required Alert -->
                        <div class="action-alert">
                            <div class="alert-icon">
                                <i class="bi bi-info-circle"></i>
                            </div>
                            <div class="alert-content">
                                <h6 class="alert-title">Action Required</h6>
                                <p class="alert-message">
                                    Please settle the downpayment to <strong><asp:Literal ID="litPaymentInfo" runat="server" /></strong>. 
                                    Send payment receipt to (<strong>mmarcusivanmiranda@gmail.com</strong>) for your proof of payment.
                                </p>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="OnlineBooking.aspx" class="btn-primary-action">
                                <i class="bi bi-house-door me-2"></i>
                                Return to Home
                            </a>
                            <button type="button" onclick="window.print();" class="btn-secondary-action">
                                <i class="bi bi-printer me-2"></i>
                                Print Receipt
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .success-header {
            background: linear-gradient(135deg, #088113 0%, #06a017 100%);
            color: white;
            padding: 3rem 2rem;
            border-radius: 20px 20px 0 0;
            margin: -1.5rem -1.5rem 0 -1.5rem;
        }

        .success-icon-wrapper {
            position: relative;
            display: inline-block;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .success-icon i {
            font-size: 3.5rem;
            color: white;
        }

        .success-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .success-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin: 0;
        }

        .booking-card {
            background: white;
            border-radius: 0 0 20px 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .card-body {
            padding: 2rem;
        }

        .info-section {
            margin-bottom: 2rem;
        }

        .section-title {
            color: #088113;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #088113;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .info-item {
            background: #f8f9fa;
            padding: 1.2rem;
            border-radius: 12px;
            border-left: 4px solid #088113;
        }

        .info-item.full-width {
            grid-column: 1 / -1;
        }

        .info-label {
            color: #6c757d;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 0.5rem;
        }

        .info-value {
            color: #2c3e50;
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
        }

        .payment-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }

        .payment-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
        }

        .payment-row:not(:last-child) {
            border-bottom: 1px solid #dee2e6;
        }

        .total-row {
            border-top: 2px solid #088113;
            padding-top: 1rem;
            margin-top: 0.5rem;
        }

        .payment-label {
            color: #6c757d;
            font-weight: 500;
        }

        .total-label {
            color: #2c3e50;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .payment-value {
            color: #2c3e50;
            font-weight: 600;
        }

        .total-value {
            color: #088113;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .action-alert {
            background: linear-gradient(135deg, #fff9e6 0%, #fef3cd 100%);
            border-left: 5px solid #ffc107;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: flex-start;
            gap: 1rem;
        }

        .alert-icon {
            color: #ffc107;
            font-size: 1.5rem;
            margin-top: 0.2rem;
        }

        .alert-content {
            flex: 1;
        }

        .alert-title {
            color: #856404;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .alert-message {
            color: #856404;
            margin: 0;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-primary-action {
            background: linear-gradient(135deg, #088113 0%, #06a017 100%);
            color: white;
            border: none;
            padding: 1rem 2.5rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(8, 129, 19, 0.3);
        }

        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(8, 129, 19, 0.4);
            color: white;
            text-decoration: none;
        }

        .btn-secondary-action {
            background: white;
            color: #6c757d;
            border: 2px solid #dee2e6;
            padding: 1rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn-secondary-action:hover {
            background: #f8f9fa;
            border-color: #adb5bd;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .success-header {
                padding: 2rem 1rem;
                margin: -1rem -1rem 0 -1rem;
            }

            .success-title {
                font-size: 2rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn-primary-action,
            .btn-secondary-action {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }

            .action-alert {
                flex-direction: column;
                text-align: center;
            }

            .alert-icon {
                align-self: center;
            }
        }
    </style>
</asp:Content>