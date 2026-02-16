<%@ Page Title="About Us | PSAU Stay" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="PSAUStay.About" %>

<asp:Content ID="ContentAbout" ContentPlaceHolderID="MainContent" runat="server">
    <div class="about-header text-center py-5 mb-5">
        <div class="container">
            <h1 class="display-4 fw-bold">About Our University Hostel</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-center bg-transparent">
                    <li class="breadcrumb-item"><a href="Default.aspx" class="text-white-50">Home</a></li>
                    <li class="breadcrumb-item active text-white" aria-current="page">About Us</li>
                </ol>
            </nav>
        </div>
    </div>

    <section class="container mb-5" id="about">
        <div class="row align-items-center mb-5 g-5">
            <div class="col-lg-6">
                <div class="image-stack position-relative">
                    <img src="Images/hostel.jpg" alt="PSAU Stay" class="img-fluid rounded-4 shadow-lg main-img">
                    <div class="experience-badge shadow-lg">
                        <span class="fs-3 fw-bold">PSAU</span>
                        <small>Stay & Relax</small>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <h2 class="section-title mb-4">Comfort Meets Convenience</h2>
                <p class="lead text-secondary mb-4">
                    PSAU Stay provides affordable and comfortable rooms for students, staff, and visitors.
                    Our facilities are designed to ensure a convenient and enjoyable stay, complete with modern 
                    amenities and a secure environment.
                </p>
                <p class="text-muted mb-5" style="line-height: 1.8;">
                    Whether you need a room for short-term visits, events, or long stays, PSAU Stay is committed 
                    to making your experience seamless and pleasant.
                    Our friendly staff is always ready to assist you with your booking and special requests.
                </p>
                <a href="Booking.aspx" class="btn btn-psau-gold btn-lg shadow">
                    <i class="bi bi-calendar-check me-2"></i>Book a Room
                </a>
            </div>
        </div>

        <div class="row g-4 mt-5">
            <div class="col-md-4">
                <div class="feature-card h-100 p-4 shadow-sm text-center">
                    <div class="feature-icon mb-3">
                        <i class="bi bi-shield-check fs-1"></i>
                    </div>
                    <h5 class="fw-bold">Safe & Secure</h5>
                    <p class="small text-muted">24/7 security and a peaceful campus environment for your peace of mind.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card h-100 p-4 shadow-sm text-center">
                    <div class="feature-icon mb-3">
                        <i class="bi bi-geo-alt fs-1"></i>
                    </div>
                    <h5 class="fw-bold">Prime Location</h5>
                    <p class="small text-muted">Located right in the heart of PSAU, giving you easy access to university halls.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card h-100 p-4 shadow-sm text-center">
                    <div class="feature-icon mb-3">
                        <i class="bi bi-stars fs-1"></i>
                    </div>
                    <h5 class="fw-bold">Modern Amenities</h5>
                    <p class="small text-muted">Enjoy well-maintained facilities and essentials designed for a modern stay.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="container mb-5 py-5 border-top">
        <div class="text-center mb-5">
            <h2 class="section-title">Development Team</h2>
            <p class="text-muted">The experts behind the PSAU Stay platform</p>
        </div>
        
        <div class="row g-4 justify-content-center">
            <div class="col-md-3">
                <div class="dev-card text-center p-4">
                    <div class="dev-avatar bg-info mx-auto mb-3">PM</div>
                    <h6 class="fw-bold mb-1">Pablo Jr. N. Mercado</h6>
                    <span class="badge rounded-pill bg-info-subtle text-info border border-info px-3">Hotel Expert</span>
                </div>
            </div>

            <div class="col-md-3">
                <div class="dev-card text-center p-4">
                    <div class="dev-avatar bg-success mx-auto mb-3">PT</div>
                    <h6 class="fw-bold mb-1">Paul Michael S. Torres</h6>
                    <span class="badge rounded-pill bg-success-subtle text-success border border-success px-3">Lead Developer</span>
                </div>
            </div>

            <div class="col-md-3">
                <div class="dev-card text-center p-4">
                    <div class="dev-avatar bg-warning text-dark mx-auto mb-3">MM</div>
                    <h6 class="fw-bold mb-1">Marcus Ivan Miranda</h6>
                    <span class="badge rounded-pill bg-warning-subtle text-dark border border-warning px-3">Co-Developer</span>
                </div>
            </div>

            <div class="col-md-3">
                <div class="dev-card text-center p-4">
                    <div class="dev-avatar bg-warning text-dark mx-auto mb-3">KD</div>
                    <h6 class="fw-bold mb-1">Kenard Vincent N. Ducut</h6>
                    <span class="badge rounded-pill bg-warning-subtle text-dark border border-warning px-3">Co-Developer</span>
                </div>
            </div>
        </div>
    </section>

    <style>
        /* Header styling */
        .about-header {
            background: linear-gradient(rgba(27, 94, 32, 0.9), rgba(13, 59, 16, 0.95)), 
                        url('Images/hostel.jpg') no-repeat center center;
            background-size: cover;
            color: white;
            margin-top: -5px;
        }

        /* Section Title */
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
            left: 0;
            width: 80px;
            height: 4px;
            background: var(--psau-gold);
            border-radius: 2px;
        }

        /* Developer Card Design */
        .dev-card {
            background: #fff;
            border-radius: 20px;
            border: 1px solid rgba(0,0,0,0.08);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
        }

        .dev-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.1);
            border-color: var(--psau-gold);
        }

        .dev-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            color: white;
            font-size: 1.25rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        /* Feature Cards */
        .feature-card {
            border-radius: 20px;
            background: #fff;
            border: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            cursor: default;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            border-color: var(--psau-gold);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important;
        }

        .feature-icon {
            color: var(--psau-green);
        }

        /* Gold Button Styling */
        .btn-psau-gold {
            background-color: var(--psau-gold);
            color: #212529;
            font-weight: 700;
            padding: 12px 35px;
            border-radius: 50px;
            border: none;
            transition: all 0.2s;
        }

        .btn-psau-gold:hover {
            background-color: #e69612;
            transform: translateY(-3px);
            color: #000;
        }
    </style>
</asp:Content>