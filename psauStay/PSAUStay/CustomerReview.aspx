<%@ Page Title="Customer Review - PSAU Hostel" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CustomerReview.aspx.cs" Inherits="PSAUStay.CustomerReview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-gradient text-white text-center py-4" style="background: linear-gradient(135deg, #198754 0%, #155724 100%);">
                        <h2 class="mb-2 fw-bold">
                            <i class="fas fa-star me-2"></i>Share Your Experience
                        </h2>
                        <p class="mb-0">Your feedback helps us improve our service</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="alert alert-info border-0 shadow-sm">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-info-circle me-3 fs-4"></i>
                                        <div>
                                            <strong>Stay Details:</strong><br>
                                            <small class="text-muted">
                                                Room: <span id="roomName" runat="server"></span> | 
                                                Check-in: <span id="checkInDate" runat="server"></span> | 
                                                Check-out: <span id="checkOutDate" runat="server"></span>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <asp:HiddenField ID="hfBookingRef" runat="server" />
                        <asp:HiddenField ID="hfGuestEmail" runat="server" />
                        <asp:HiddenField ID="hfGuestName" runat="server" />
                        <asp:HiddenField ID="hfRoomName" runat="server" />

                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-user me-2"></i>Your Name
                                </label>
                                <asp:TextBox ID="txtGuestName" runat="server" CssClass="form-control form-control-lg" placeholder="Enter your full name" required="required"></asp:TextBox>
                            </div>
                            
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-envelope me-2"></i>Email Address
                                </label>
                                <asp:TextBox ID="txtGuestEmail" runat="server" CssClass="form-control form-control-lg" placeholder="your.email@example.com" TextMode="Email" required="required"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-4">
                            <h5 class="fw-bold mb-3">
                                <i class="fas fa-star text-warning me-2"></i>Rate Your Experience
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Overall Rating</label>
                                    <div class="rating-container" data-rating="overall">
                                        <div class="star-rating">
                                            <i class="far fa-star" data-value="1"></i>
                                            <i class="far fa-star" data-value="2"></i>
                                            <i class="far fa-star" data-value="3"></i>
                                            <i class="far fa-star" data-value="4"></i>
                                            <i class="far fa-star" data-value="5"></i>
                                        </div>
                                        <small class="text-muted">Click to rate</small>
                                        <asp:HiddenField ID="hfOverallRating" runat="server" Value="0" />
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Cleanliness</label>
                                    <div class="rating-container" data-rating="cleanliness">
                                        <div class="star-rating">
                                            <i class="far fa-star" data-value="1"></i>
                                            <i class="far fa-star" data-value="2"></i>
                                            <i class="far fa-star" data-value="3"></i>
                                            <i class="far fa-star" data-value="4"></i>
                                            <i class="far fa-star" data-value="5"></i>
                                        </div>
                                        <small class="text-muted">Click to rate</small>
                                        <asp:HiddenField ID="hfCleanlinessRating" runat="server" Value="0" />
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Comfort</label>
                                    <div class="rating-container" data-rating="comfort">
                                        <div class="star-rating">
                                            <i class="far fa-star" data-value="1"></i>
                                            <i class="far fa-star" data-value="2"></i>
                                            <i class="far fa-star" data-value="3"></i>
                                            <i class="far fa-star" data-value="4"></i>
                                            <i class="far fa-star" data-value="5"></i>
                                        </div>
                                        <small class="text-muted">Click to rate</small>
                                        <asp:HiddenField ID="hfComfortRating" runat="server" Value="0" />
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Staff Service</label>
                                    <div class="rating-container" data-rating="staff">
                                        <div class="star-rating">
                                            <i class="far fa-star" data-value="1"></i>
                                            <i class="far fa-star" data-value="2"></i>
                                            <i class="far fa-star" data-value="3"></i>
                                            <i class="far fa-star" data-value="4"></i>
                                            <i class="far fa-star" data-value="5"></i>
                                        </div>
                                        <small class="text-muted">Click to rate</small>
                                        <asp:HiddenField ID="hfStaffRating" runat="server" Value="0" />
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Location</label>
                                    <div class="rating-container" data-rating="location">
                                        <div class="star-rating">
                                            <i class="far fa-star" data-value="1"></i>
                                            <i class="far fa-star" data-value="2"></i>
                                            <i class="far fa-star" data-value="3"></i>
                                            <i class="far fa-star" data-value="4"></i>
                                            <i class="far fa-star" data-value="5"></i>
                                        </div>
                                        <small class="text-muted">Click to rate</small>
                                        <asp:HiddenField ID="hfLocationRating" runat="server" Value="0" />
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Would you recommend us?</label>
                                    <div class="mt-2">
                                        <div class="form-check form-check-inline">
                                            <asp:RadioButton ID="rbRecommendYes" runat="server" GroupName="Recommend" CssClass="form-check-input" Checked="true" />
                                            <label class="form-check-label" for="rbRecommendYes">
                                                <i class="fas fa-thumbs-up text-success me-1"></i> Yes
                                            </label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <asp:RadioButton ID="rbRecommendNo" runat="server" GroupName="Recommend" CssClass="form-check-input" />
                                            <label class="form-check-label" for="rbRecommendNo">
                                                <i class="fas fa-thumbs-down text-danger me-1"></i> No
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-comment me-2"></i>Additional Comments
                            </label>
                            <asp:TextBox ID="txtComments" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Share your experience with us..."></asp:TextBox>
                            <small class="text-muted">Optional: Tell us more about your stay</small>
                        </div>

                        <div class="text-center">
                            <asp:Button ID="btnSubmitReview" runat="server" CssClass="btn btn-success btn-lg px-5 py-3 fw-bold" Text="Submit Review" OnClick="btnSubmitReview_Click" />
                            <div class="mt-3">
                                <small class="text-muted">
                                    <i class="fas fa-lock me-1"></i>Your review will be reviewed before being published
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .star-rating {
            font-size: 1.5rem;
            color: #ffc107;
        }
        
        .star-rating i {
            cursor: pointer;
            transition: all 0.2s ease;
            margin-right: 5px;
        }
        
        .star-rating i:hover {
            transform: scale(1.1);
        }
        
        .star-rating i.filled {
            color: #ffc107;
        }
        
        .star-rating i.empty {
            color: #dee2e6;
        }
        
        .rating-container {
            padding: 10px;
            border-radius: 8px;
            background-color: #f8f9fa;
            transition: background-color 0.3s ease;
        }
        
        .rating-container:hover {
            background-color: #e9ecef;
        }
        
        .card {
            border-radius: 15px;
            overflow: hidden;
        }
        
        .form-control:focus {
            border-color: #198754;
            box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.25);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #198754 0%, #155724 100%);
            border: none;
            transition: all 0.3s ease;
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(25, 135, 84, 0.3);
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize star ratings
            const ratingContainers = document.querySelectorAll('.rating-container');
            
            ratingContainers.forEach(container => {
                const stars = container.querySelectorAll('.star-rating i');
                const ratingType = container.dataset.rating;
                const hiddenField = container.querySelector('input[type="hidden"]');
                
                stars.forEach((star, index) => {
                    star.addEventListener('click', function() {
                        const rating = parseInt(this.dataset.value);
                        
                        // Update hidden field
                        if (hiddenField) {
                            hiddenField.value = rating;
                        }
                        
                        // Update star display
                        stars.forEach((s, i) => {
                            if (i < rating) {
                                s.classList.remove('far', 'empty');
                                s.classList.add('fas', 'filled');
                            } else {
                                s.classList.remove('fas', 'filled');
                                s.classList.add('far', 'empty');
                            }
                        });
                    });
                    
                    star.addEventListener('mouseenter', function() {
                        const rating = parseInt(this.dataset.value);
                        
                        stars.forEach((s, i) => {
                            if (i < rating) {
                                s.classList.remove('far', 'empty');
                                s.classList.add('fas', 'filled');
                            } else {
                                s.classList.remove('fas', 'filled');
                                s.classList.add('far', 'empty');
                            }
                        });
                    });
                });
                
                container.addEventListener('mouseleave', function() {
                    const currentRating = hiddenField ? parseInt(hiddenField.value) : 0;
                    
                    stars.forEach((s, i) => {
                        if (i < currentRating) {
                            s.classList.remove('far', 'empty');
                            s.classList.add('fas', 'filled');
                        } else {
                            s.classList.remove('fas', 'filled');
                            s.classList.add('far', 'empty');
                        }
                    });
                });
            });
        });
        
        function validateReview() {
            const overallRating = document.getElementById('<%= hfOverallRating.ClientID %>').value;
            const cleanlinessRating = document.getElementById('<%= hfCleanlinessRating.ClientID %>').value;
            const comfortRating = document.getElementById('<%= hfComfortRating.ClientID %>').value;
            const staffRating = document.getElementById('<%= hfStaffRating.ClientID %>').value;
            const locationRating = document.getElementById('<%= hfLocationRating.ClientID %>').value;
            
            if (overallRating === '0' || cleanlinessRating === '0' || comfortRating === '0' || staffRating === '0' || locationRating === '0') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Incomplete Rating',
                    text: 'Please provide ratings for all categories before submitting.',
                    confirmButtonColor: '#198754'
                });
                return false;
            }
            
            return true;
        }
    </script>
</asp:Content>
