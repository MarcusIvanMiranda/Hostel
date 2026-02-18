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
                EmptyDataText="No approved bookings found."
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
                            <small class="opacity-75">Manage guest feedback and reviews</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="background-color: #f8f9fa;">
                    <div class="row g-4">
                        <!-- Guest Information -->
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="rounded-circle bg-info bg-opacity-10 p-3 me-3">
                                            <i class="bi bi-person-fill text-info" style="font-size: 1.2rem;"></i>
                                        </div>
                                        <div>
                                            <h6 class="text-muted mb-1 fw-semibold">Guest Information</h6>
                                            <p class="mb-0 text-muted small">Guest details and booking summary</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row align-items-center">
                                        <div class="col-md-4">
                                            <label class="text-muted small fw-semibold d-block">Guest Name</label>
                                            <p class="fw-bold mb-0 fs-5" id="modalFullName" style="color: var(--psau-green);">-</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="text-muted small fw-semibold d-block">Email</label>
                                            <p class="fw-bold mb-0 fs-5" id="modalEmail" style="color: var(--psau-green);">-</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="text-muted small fw-semibold d-block">Contact Number</label>
                                            <p class="fw-bold mb-0 fs-5" id="modalContact" style="color: var(--psau-green);">-</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Review Section -->
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="rounded-circle bg-warning bg-opacity-10 p-3 me-3">
                                            <i class="bi bi-star-fill text-warning" style="font-size: 1.2rem;"></i>
                                        </div>
                                        <div>
                                            <h6 class="text-muted mb-1 fw-semibold">Guest Review & Feedback</h6>
                                            <p class="mb-0 text-muted small">Customer experience and rating information</p>
                                        </div>
                                    </div>
                                    
                                    <!-- Rating Stars -->
                                    <div class="mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <span class="me-2 fw-semibold">Rating:</span>
                                            <div class="text-warning">
                                                <i class="bi bi-star-fill"></i>
                                                <i class="bi bi-star-fill"></i>
                                                <i class="bi bi-star-fill"></i>
                                                <i class="bi bi-star-fill"></i>
                                                <i class="bi bi-star-half"></i>
                                                <span class="ms-2 text-muted">4.5/5.0</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Review Content -->
                                    <div class="mb-3">
                                        <label class="text-muted small fw-semibold">Guest Comments</label>
                                        <div class="border rounded p-3 bg-white" style="min-height: 120px;">
                                            <p class="mb-0 text-muted fst-italic">
                                                "Excellent stay! The room was clean and comfortable. Staff was very helpful and accommodating. 
                                                The location is perfect and the amenities exceeded our expectations. Would definitely recommend 
                                                to others and will be booking again for our next visit. The PSAU Stay facility provided 
                                                everything we needed for a comfortable and enjoyable experience."
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- Review Categories -->
                                    <div class="row g-3 mb-3">
                                        <div class="col-6 col-md-3">
                                            <div class="text-center">
                                                <div class="text-warning mb-1">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                </div>
                                                <small class="text-muted d-block">Cleanliness</small>
                                            </div>
                                        </div>
                                        <div class="col-6 col-md-3">
                                            <div class="text-center">
                                                <div class="text-warning mb-1">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star"></i>
                                                </div>
                                                <small class="text-muted d-block">Service</small>
                                            </div>
                                        </div>
                                        <div class="col-6 col-md-3">
                                            <div class="text-center">
                                                <div class="text-warning mb-1">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </div>
                                                <small class="text-muted d-block">Facilities</small>
                                            </div>
                                        </div>
                                        <div class="col-6 col-md-3">
                                            <div class="text-center">
                                                <div class="text-warning mb-1">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                </div>
                                                <small class="text-muted d-block">Location</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Review Metadata -->
                                    <div class="row g-2">
                                        <div class="col-md-4">
                                            <small class="text-muted d-block">
                                                <i class="bi bi-calendar-check me-1"></i>
                                                Review Date: <span class="fw-semibold">Dec 15, 2025</span>
                                            </small>
                                        </div>
                                        <div class="col-md-4">
                                            <small class="text-muted d-block">
                                                <i class="bi bi-person-check me-1"></i>
                                                Verified Stay: <span class="fw-semibold text-success">Yes</span>
                                            </small>
                                        </div>
                                        <div class="col-md-4">
                                            <small class="text-muted d-block">
                                                <i class="bi bi-shield-check me-1"></i>
                                                Status: <span class="fw-semibold text-success">Published</span>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 flex-wrap gap-2">
                    <button type="button" class="btn btn-lg px-4" style="background-color: var(--psau-green); color: white; border: none;" data-bs-dismiss="modal">
                        <i class="bi bi-check-circle-fill me-2"></i>Close
                    </button>
                    <button type="button" class="btn btn-lg px-4" style="background-color: #dc3545; color: white; border: none;" onclick="rejectReview()">
                        <i class="bi bi-x-circle-fill me-2"></i>Reject Review
                    </button>
                    <button type="button" class="btn btn-lg px-4" style="background-color: var(--psau-gold); color: var(--psau-green); border: none;" onclick="approveReview()">
                        <i class="bi bi-check2-square me-2"></i>Approve Review
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

            // Approve review function
            window.approveReview = function() {
                Swal.fire({
                    title: '<i class="bi bi-check-circle-fill me-2" style="color: #0b6623;"></i>Approve Review',
                    html: `
                        <div style="text-align: left; background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #0b6623;">
                            <p class="mb-3">Are you sure you want to approve this guest review?</p>
                            <div class="mb-2">
                                <strong style="color: #0b6623;"><i class="bi bi-info-circle me-2"></i>Action:</strong> 
                                <span class="text-success">Publish review publicly</span>
                            </div>
                            <div>
                                <strong style="color: #0b6623;"><i class="bi bi-shield-check me-2"></i>Verification:</strong> 
                                <span class="fw-bold">Guest stay confirmed</span>
                            </div>
                        </div>
                    `,
                    icon: undefined,
                    showCancelButton: true,
                    confirmButtonText: '<i class="bi bi-check2-square me-2"></i>Yes, Approve',
                    cancelButtonText: '<i class="bi bi-x-circle me-2"></i>Cancel',
                    confirmButtonColor: '#0b6623',
                    cancelButtonColor: '#6c757d',
                    background: '#ffffff',
                    customClass: {
                        popup: 'shadow-lg'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Trigger the hidden button to post back to server
                        $('#<%= btnHiddenConfirm.ClientID %>').click();
                    }
                });
            };

            // Reject review function
            window.rejectReview = function () {
                Swal.fire({
                    title: '<i class="bi bi-x-circle-fill me-2" style="color: #dc3545;"></i>Reject Review',
                    html: `
                        <div style="text-align: left; background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #dc3545;">
                            <p class="mb-3">Are you sure you want to reject this guest review?</p>
                            <div class="mb-2">
                                <strong style="color: #dc3545;"><i class="bi bi-info-circle me-2"></i>Action:</strong> 
                                <span class="text-danger">Remove review from public view</span>
                            </div>
                            <div>
                                <strong style="color: #dc3545;"><i class="bi bi-exclamation-triangle me-2"></i>Reason:</strong> 
                                <span class="fw-bold">Review does not meet guidelines</span>
                            </div>
                        </div>
                    `,
                    icon: undefined,
                    showCancelButton: true,
                    confirmButtonText: '<i class="bi bi-x-square me-2"></i>Yes, Reject',
                    cancelButtonText: '<i class="bi bi-check-circle me-2"></i>Cancel',
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    background: '#ffffff',
                    customClass: {
                        popup: 'shadow-lg'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        Swal.fire({
                            title: '<i class="bi bi-check-circle-fill me-2" style="color: #28a745;"></i>Review Rejected',
                            text: 'The guest review has been successfully rejected and removed from public view.',
                            icon: undefined,
                            confirmButtonColor: '#28a745',
                            background: '#ffffff',
                            customClass: {
                                popup: 'shadow-lg'
                            }
                        });
                    }
                });
            };
        });
    </script>
</asp:Content>
