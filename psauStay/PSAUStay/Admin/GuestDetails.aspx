<%@ Page Title="Guest Details" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="GuestDetails.aspx.cs" Inherits="PSAUStay.Admin.GuestDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <%-- Hidden inputs for communication between JS and Server --%>
    <asp:HiddenField ID="hfSelectedID" runat="server" />
    <asp:HiddenField ID="hfActionType" runat="server" />
    <asp:Button ID="btnHiddenConfirm" runat="server" OnClick="btnConfirmAction_Click" Style="display:none;" />

    <div class="container mt-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-person-badge-fill me-2" style="color: var(--psau-gold);"></i>
                            Guest Details
                        </h2>
                        <p class="mb-0 text-white-50">View comprehensive guest information and booking history</p>
                    </div>
                    <div class="col-auto">
                        <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <asp:Label ID="lblSuccessMessage" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false"></asp:Label>

        <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
            <asp:GridView ID="gvGuestList" runat="server" CssClass="table table-bordered table-striped"
                AutoGenerateColumns="False" AllowPaging="True" PageSize="15"
                OnPageIndexChanging="gvGuestList_PageIndexChanging" 
                OnRowCommand="gvGuestList_RowCommand"
                DataKeyNames="BookingID"
                EmptyDataText="No approved or checked-out bookings found."
                style="min-width: 650px;">
                <Columns>
                    <asp:BoundField DataField="FullName" HeaderText="Guest Name" ItemStyle-CssClass="fw-bold" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:BoundField DataField="Contact" HeaderText="Contact Number" />
                    <asp:BoundField DataField="BookingCount" HeaderText="Bookings" ItemStyle-CssClass="text-center" />
                    <asp:BoundField DataField="RoomName" HeaderText="Rooms" />
                    <asp:BoundField DataField="FirstCheckIn" HeaderText="First Check-In" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:BoundField DataField="LastCheckOut" HeaderText="Last Check-Out" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" DataFormatString="₱{0:N2}" ItemStyle-CssClass="text-success fw-bold" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemStyle CssClass="text-center" />
                        <ItemTemplate>
                            <button type="button" class="btn btn-sm btn-warning me-1 review-btn" 
                                    data-email='<%# Eval("Email") %>' data-fullname='<%# Eval("FullName") %>' data-contact='<%# Eval("Contact") %>'>
                                <i class="bi bi-eye"></i> Review
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="pagination" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </div>

    <!-- Guest Details Modal -->
    <div class="modal fade" id="guestDetailsModal" tabindex="-1" aria-labelledby="guestDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%); color: white; border-radius: 0.375rem 0.375rem 0 0;">
                    <div class="d-flex align-items-center">
                        <div class="me-3">
                            <i class="bi bi-star-fill" style="font-size: 1.5rem; color: var(--psau-gold);"></i>
                        </div>
                        <div>
                            <h5 class="modal-title mb-0 fw-bold">Guest Review Management</h5>
                            <small class="opacity-75" id="modalGuestInfo">Loading guest information...</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="background-color: white;">
                    <div id="reviewSection">
                        <!-- Content will be loaded here dynamically -->
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-lg px-4" style="background-color: var(--psau-green); color: white; border: none;" data-bs-dismiss="modal">
                        <i class="bi bi-check-circle-fill me-2"></i>Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function() {
            console.log("Document ready, initializing modal functions");

            // Simple modal function for direct calls
            window.showGuestDetailsModal = function(email) {
                console.log("showGuestDetailsModal called with email:", email);
                $('#modalEmail').text(email);
                $('#guestDetailsModal').modal('show');
            };
            // Event delegation for review buttons
            $(document).on('click', '.review-btn', function(e) {
                e.preventDefault();
                var email = $(this).data('email');
                var fullName = $(this).data('fullname');
                var contact = $(this).data('contact');
                console.log("Review button clicked for email:", email, "fullName:", fullName, "contact:", contact);
                showGuestDetailsModal(email, fullName, contact);
            });

            // Simple modal function for direct calls
            window.showGuestDetailsModal = function(email, fullName, contact) {
                console.log("showGuestDetailsModal called with email:", email, "fullName:", fullName, "contact:", contact);
                $('#modalEmail').text(email || 'N/A');
                $('#modalFullName').text(fullName || 'N/A');
                $('#modalContact').text(contact || 'N/A');
                
                // Update modal header with guest info
                $('#modalGuestInfo').text(`${fullName || 'Guest'} (${email || 'N/A'})`);
                
                // Load guest reviews
                loadGuestReviews(email);
                
                $('#guestDetailsModal').modal('show');
            };

            // Main showGuestDetails function (for server-side calls)
            window.showGuestDetails = function(bookingId, email, roomName, roomNumber, price, checkIn, checkOut, days, status) {
                console.log("showGuestDetails called with email:", email);
                
                // Set modal content - only email is relevant for review placeholder
                $('#modalEmail').text(email);
                
                // Store booking ID for review action
                $('#<%= hfSelectedID.ClientID %>').val(bookingId);
                $('#<%= hfActionType.ClientID %>').val('Review');
                
                // Show modal using jQuery
                $('#guestDetailsModal').modal('show');
            };

            // Debug function to check all reviews in database
            window.debugAllReviews = function() {
                console.log("Debug: Checking all reviews in database...");
                $.ajax({
                    type: "POST",
                    url: "GuestDetails.aspx/GetAllReviewsForDebugging",
                    data: "{}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        var reviews = JSON.parse(response.d);
                        console.log("All reviews in database:", reviews);
                        console.log("Total reviews count:", reviews.length);
                        
                        if (reviews.length === 0) {
                            console.warn("No reviews found in database at all!");
                        } else {
                            console.log("Sample review:", reviews[0]);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error debugging all reviews:", error);
                        console.error("XHR status:", xhr.status);
                        console.error("XHR responseText:", xhr.responseText);
                    }
                });
            };

            // Load guest reviews from server
            window.loadGuestReviews = function(email) {
                console.log("loadGuestReviews called with email:", email);
                
                if (!email) {
                    console.log("No email provided, showing no reviews");
                    showNoReviews();
                    return;
                }

                // First, debug all reviews to see what emails exist
                debugAllReviews();
                
                $.ajax({
                    type: "POST",
                    url: "GuestDetails.aspx/GetGuestReviews",
                    data: JSON.stringify({ guestEmail: email }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        console.log("AJAX success, response:", response);
                        var reviews = JSON.parse(response.d);
                        console.log("Parsed reviews:", reviews);
                        if (reviews && reviews.length > 0) {
                            console.log("Found reviews, displaying them");
                            displayReviews(reviews);
                        } else {
                            console.log("No reviews found, showing no reviews message");
                            showNoReviews();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading reviews:", error);
                        console.error("XHR status:", xhr.status);
                        console.error("XHR responseText:", xhr.responseText);
                        showNoReviews();
                    }
                });
            };

            // Display reviews in the modal
            window.displayReviews = function(reviews) {
                console.log("displayReviews called with:", reviews);
                console.log("Number of reviews:", reviews ? reviews.length : 0);
                
                var reviewSection = $('#reviewSection');
                reviewSection.empty(); // Clear previous reviews

                if (!reviews || reviews.length === 0) {
                    console.log("No reviews to display");
                    reviewSection.html(`
                        <div class="text-center py-5">
                            <i class="bi bi-star text-muted" style="font-size: 3rem;"></i>
                            <p class="text-muted mt-3 mb-0">No reviews found for this guest.</p>
                            <small class="text-muted">Guest has not submitted any reviews yet.</small>
                        </div>
                    `);
                    return;
                }

                // Display all reviews from RoomReviews table
                var reviewsHtml = '<div class="container-fluid">';
                reviews.forEach(function(review, index) {
                    console.log("Processing review:", review);
                    
                    // Debug: Log individual review data
                    console.log("Review data:", {
                        ReviewID: review.ReviewID,
                        BookingRef: review.BookingRef,
                        GuestName: review.GuestName,
                        GuestEmail: review.GuestEmail,
                        RoomName: review.RoomName,
                        CheckInDate: review.CheckInDate,
                        CheckOutDate: review.CheckOutDate,
                        OverallRating: review.OverallRating,
                        CleanlinessRating: review.CleanlinessRating,
                        ComfortRating: review.ComfortRating,
                        StaffRating: review.StaffRating,
                        LocationRating: review.LocationRating,
                        Comments: review.Comments,
                        ReviewDate: review.ReviewDate,
                        IsApproved: review.IsApproved
                    });
                    
                    var starsOverall = generateStars(review.OverallRating);
                    var starsCleanliness = generateStars(review.CleanlinessRating);
                    var starsComfort = generateStars(review.ComfortRating);
                    var starsStaff = generateStars(review.StaffRating);
                    var starsLocation = generateStars(review.LocationRating);

                    var statusBadge = '<span class="badge bg-success">Published</span>';
                    
                    reviewsHtml += `
                        <div class="review-item mb-4 ${index > 0 ? 'border-top pt-4' : ''}" data-review-id="${review.ReviewID}">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4">
                                    <!-- Header with Review Info -->
                                    <div class="row align-items-center mb-4">
                                        <div class="col-md-8">
                                            <h5 class="mb-2 text-primary">
                                                <i class="bi bi-person-circle me-2"></i>${review.GuestName || 'N/A'}
                                            </h5>
                                            <div class="text-muted small">
                                                <i class="bi bi-envelope me-1"></i>${review.GuestEmail || 'N/A'} | 
                                                <i class="bi bi-door-closed me-1"></i>${review.RoomName || 'N/A'} | 
                                                <i class="bi bi-clipboard-check me-1"></i>${review.BookingRef || 'N/A'}
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            ${statusBadge}
                                            <div class="text-muted small mt-2">
                                                <i class="bi bi-calendar-event me-1"></i>${review.ReviewDate || 'N/A'}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Stay Dates -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <div class="p-3 bg-light rounded">
                                                <i class="bi bi-calendar-check text-success me-2"></i>
                                                <strong>Check-in:</strong> ${review.CheckInDate || 'N/A'}
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="p-3 bg-light rounded">
                                                <i class="bi bi-calendar-x text-danger me-2"></i>
                                                <strong>Check-out:</strong> ${review.CheckOutDate || 'N/A'}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Overall Rating -->
                                    <div class="row mb-4">
                                        <div class="col-12">
                                            <div class="p-4 bg-primary bg-opacity-10 rounded text-center">
                                                <div class="text-warning mb-2" style="font-size: 2rem;">
                                                    ${starsOverall}
                                                </div>
                                                <h4 class="mb-0">${review.OverallRating || 0}/5.0</h4>
                                                <small class="text-muted">Overall Rating</small>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Category Ratings -->
                                    <div class="row mb-4">
                                        <div class="col-md-3 col-6 mb-3">
                                            <div class="text-center p-3 border rounded h-100">
                                                <div class="text-warning mb-2" style="font-size: 1.2rem;">${starsCleanliness}</div>
                                                <small class="text-muted d-block">Cleanliness</small>
                                                <strong class="text-primary">${review.CleanlinessRating || 0}/5</strong>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6 mb-3">
                                            <div class="text-center p-3 border rounded h-100">
                                                <div class="text-warning mb-2" style="font-size: 1.2rem;">${starsComfort}</div>
                                                <small class="text-muted d-block">Comfort</small>
                                                <strong class="text-primary">${review.ComfortRating || 0}/5</strong>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6 mb-3">
                                            <div class="text-center p-3 border rounded h-100">
                                                <div class="text-warning mb-2" style="font-size: 1.2rem;">${starsStaff}</div>
                                                <small class="text-muted d-block">Service</small>
                                                <strong class="text-primary">${review.StaffRating || 0}/5</strong>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6 mb-3">
                                            <div class="text-center p-3 border rounded h-100">
                                                <div class="text-warning mb-2" style="font-size: 1.2rem;">${starsLocation}</div>
                                                <small class="text-muted d-block">Location</small>
                                                <strong class="text-primary">${review.LocationRating || 0}/5</strong>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Comments -->
                                    ${review.Comments && review.Comments.trim() !== '' ? `
                                        <div class="row mb-4">
                                            <div class="col-12">
                                                <div class="p-4 bg-light rounded">
                                                    <h6 class="mb-3">
                                                        <i class="bi bi-chat-quote text-info me-2"></i>Guest Comments
                                                    </h6>
                                                    <p class="mb-0 fst-italic fs-5">"${review.Comments}"</p>
                                                </div>
                                            </div>
                                        </div>
                                    ` : ''}

                                    <!-- Would Recommend -->
                                    <div class="row mb-4">
                                        <div class="col-12">
                                            <div class="p-3 ${review.WouldRecommend ? 'bg-success bg-opacity-10' : 'bg-danger bg-opacity-10'} rounded">
                                                <i class="bi bi-hand-thumbs-up ${review.WouldRecommend ? 'text-success' : 'text-danger'} me-2"></i>
                                                <strong>Would Recommend:</strong> 
                                                <span class="${review.WouldRecommend ? 'text-success fw-bold' : 'text-danger fw-bold'}">
                                                    ${review.WouldRecommend ? 'YES' : 'NO'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                                                    </div>
                            </div>
                        </div>
                    `;
                });
                reviewsHtml += '</div>';
                reviewSection.html(reviewsHtml);
                console.log("Reviews HTML set successfully");
            };

            // Show no reviews message
            window.showNoReviews = function() {
                var reviewSection = $('#reviewSection');
                
                reviewSection.html(`
                    <div class="text-center py-4">
                        <i class="bi bi-star text-muted" style="font-size: 3rem;"></i>
                        <p class="text-muted mt-3 mb-0">No reviews found for this guest.</p>
                        <small class="text-muted">Guest has not submitted any reviews yet.</small>
                    </div>
                `);
            };

            // Generate star rating HTML
            window.generateStars = function(rating) {
                console.log("generateStars called with rating:", rating);
                var stars = '';
                for (var i = 1; i <= 5; i++) {
                    if (i <= rating) {
                        stars += '<i class="bi bi-star-fill text-warning"></i>';
                    } else {
                        stars += '<i class="bi bi-star text-warning"></i>';
                    }
                }
                console.log("Generated stars:", stars);
                return stars;
            };
        });
    </script>
</asp:Content>
