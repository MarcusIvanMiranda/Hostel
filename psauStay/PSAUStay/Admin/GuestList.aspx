<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="GuestList.aspx.cs" Inherits="PSAUStay.Admin.GuestList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <asp:HiddenField ID="hfSelectedID" runat="server" />
    <asp:HiddenField ID="hfActionType" runat="server" />
    <asp:Button ID="btnHiddenConfirm" runat="server" OnClick="btnConfirmAction_Click" Style="display:none;" />

    <div class="container mt-4">
        <h3 class="mb-4 text-success"><i class="bi bi-people-fill me-2"></i>Guest List - Approved Bookings</h3>
        
        <asp:GridView ID="gvGuestList" runat="server" CssClass="table table-bordered table-striped"
            AutoGenerateColumns="False" AllowPaging="True" PageSize="15"
            OnPageIndexChanging="gvGuestList_PageIndexChanging" 
            OnRowCommand="gvGuestList_RowCommand"
            DataKeyNames="BookingID"
            EmptyDataText="No approved bookings found.">
            <Columns>
                <asp:BoundField DataField="FullName" HeaderText="Guest Name" ItemStyle-CssClass="fw-bold" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="Contact" HeaderText="Contact Number" />
                <asp:BoundField DataField="BookingCount" HeaderText="Bookings" ItemStyle-CssClass="text-center" />
                <asp:BoundField DataField="AllRooms" HeaderText="Rooms" />
                <asp:BoundField DataField="FirstCheckIn" HeaderText="First Check-In" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:BoundField DataField="LastCheckOut" HeaderText="Last Check-Out" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:BoundField DataField="TotalPrice" HeaderText="Total Price" DataFormatString="₱{0:N2}" ItemStyle-CssClass="text-success fw-bold" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemStyle CssClass="text-center" />
                    <ItemTemplate>
                        <asp:LinkButton ID="btnViewReview" runat="server" CssClass="btn btn-sm btn-warning" 
                            CommandName="ViewReview" CommandArgument='<%# Eval("Email") %>'>
                            <i class="bi bi-eye"></i> View All Bookings
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination" HorizontalAlign="Center" />
        </asp:GridView>
    </div>

    <div class="modal fade" id="guestDetailsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%); color: white; border-radius: 0.375rem 0.375rem 0 0;">
                    <div class="d-flex align-items-center">
                        <div class="me-3">
                            <i class="bi bi-person-badge-fill" style="font-size: 1.5rem; color: var(--psau-gold);"></i>
                        </div>
                        <div>
                            <h5 class="modal-title mb-0 fw-bold">Guest Booking Details</h5>
                            <small class="opacity-75">Complete reservation information</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="background-color: #f8f9fa;">
                    <div class="container">
                        <!-- Guest Profile Header -->
                        <div class="row justify-content-center mb-4">
                            <div class="col-12">
                                <div class="card border-0 shadow-sm rounded-3">
                                    <div class="card-body p-4">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 text-center mb-3 mb-md-0">
                                                <div class="avatar-circle bg-gradient rounded-circle d-flex align-items-center justify-content-center mx-auto" style="width: 80px; height: 80px; background: linear-gradient(135deg, #0b6623 0%, #074217 100%);">
                                                    <i class="bi bi-person-fill text-white" style="font-size: 2.5rem;"></i>
                                                </div>
                                            </div>
                                            <div class="col-md-10">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="mb-3">
                                                            <label class="text-muted small fw-semibold text-uppercase">Guest Name</label>
                                                            <h4 class="fw-bold mb-0" id="modalFullName" style="color: var(--psau-green);">-</h4>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="mb-3">
                                                            <label class="text-muted small fw-semibold text-uppercase">Email Address</label>
                                                            <p class="fw-bold mb-0 fs-5" id="modalEmail" style="color: var(--psau-green);">-</p>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="mb-3">
                                                            <label class="text-muted small fw-semibold text-uppercase">Contact Number</label>
                                                            <p class="fw-bold mb-0 fs-5" id="modalContact" style="color: var(--psau-green);">-</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Booking Details Grid -->
                        <div class="row justify-content-center g-4" id="bookingsGrid">
                            <!-- Bookings will be dynamically inserted here -->
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <div class="container text-center">
                        <button type="button" class="btn btn-lg px-5" style="background-color: var(--psau-green); color: white; border: none; border-radius: 8px;" data-bs-dismiss="modal">
                            <i class="bi bi-check-circle-fill me-2"></i>Close
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function showGuestDetails(fullName, email, contact, room, type, roomNum, price, checkIn, checkOut) {
            // Clear previous content
            const modalElements = {
                'modalFullName': fullName || 'N/A',
                'modalEmail': email || 'N/A',
                'modalContact': contact || 'N/A',
                'modalRoom': room || 'N/A',
                'modalType': type || 'N/A',
                'modalRoomNumber': roomNum || 'N/A',
                'modalPrice': price || '₱0.00',
                'modalCheckIn': checkIn || 'N/A',
                'modalCheckOut': checkOut || 'N/A'
            };

            // Update modal content with null checks
            Object.keys(modalElements).forEach(elementId => {
                const element = document.getElementById(elementId);
                if (element) {
                    element.textContent = modalElements[elementId];
                }
            });

            // Show the modal with error handling
            try {
                const modalElement = document.getElementById('guestDetailsModal');
                if (modalElement) {
                    const myModal = new bootstrap.Modal(modalElement);
                    myModal.show();
                } else {
                    console.error('Modal element not found');
                }
            } catch (error) {
                console.error('Error showing modal:', error);
                // Fallback to SweetAlert if bootstrap modal fails
                Swal.fire({
                    title: '<i class="bi bi-person-badge-fill me-2"></i>Booking Details',
                    html: `
                        <div style="text-align: left; background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #0b6623;">
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-person-fill me-2"></i>Guest Name:</strong> ${fullName || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-envelope-fill me-2"></i>Email:</strong> ${email || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-telephone-fill me-2"></i>Contact Number:</strong> ${contact || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-door-closed-fill me-2"></i>Room:</strong> ${room || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-tag-fill me-2"></i>Type:</strong> ${type || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-hash me-2"></i>Room Number:</strong> ${roomNum || 'N/A'}
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-currency-peso me-2"></i>Total Price:</strong> <span style="color: #0b6623; font-weight: bold; font-size: 1.1em;">${price || '₱0.00'}</span>
                            </div>
                            <div style="margin-bottom: 15px;">
                                <strong style="color: #0b6623;"><i class="bi bi-calendar-check-fill me-2"></i>Check-In:</strong> ${checkIn || 'N/A'}
                            </div>
                            <div>
                                <strong style="color: #0b6623;"><i class="bi bi-calendar-x-fill me-2"></i>Check-Out:</strong> ${checkOut || 'N/A'}
                            </div>
                        </div>
                    `,
                    icon: undefined,
                    showConfirmButton: true,
                    confirmButtonText: '<i class="bi bi-check-circle-fill me-2"></i>Close',
                    confirmButtonColor: '#0b6623',
                    background: '#ffffff',
                    customClass: {
                        popup: 'shadow-lg'
                    }
                });
            }
        }

        function showAllBookingsForEmail(email, guestName, guestEmail, guestContact, bookingsHtml) {
            // Show all bookings with guest info at top
            Swal.fire({
                html: `
                    <div style="text-align: left; max-width: 100%; overflow-x: hidden;">
                        <!-- Guest Information Header -->
                        <div class="mb-4 p-4 bg-light rounded-3 border-start border-4 border-success">
                            <div class="d-flex align-items-center mb-3">
                                <div class="rounded-circle bg-success bg-opacity-10 p-3 me-3">
                                    <i class="bi bi-person-fill text-success" style="font-size: 1.5rem;"></i>
                                </div>
                                <div>
                                    <h4 class="mb-0 fw-bold" style="color: #0b6623;">All Bookings</h4>
                                    <small class="text-muted">Guest reservation details</small>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-2">
                                        <strong style="color: #0b6623;">Guest Name:</strong>
                                        <div class="fw-semibold">${guestName || 'N/A'}</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-2">
                                        <strong style="color: #0b6623;">Email:</strong>
                                        <div class="fw-semibold">${guestEmail || 'N/A'}</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-2">
                                        <strong style="color: #0b6623;">Contact:</strong>
                                        <div class="fw-semibold">${guestContact || 'N/A'}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Booking Cards -->
                        <div style="max-height: 50vh; overflow-y: auto; overflow-x: hidden;">
                            <div class="row g-3">
                                ${bookingsHtml}
                            </div>
                        </div>
                    </div>
                `,
                icon: undefined,
                width: '85%',
                heightAuto: true,
                showConfirmButton: true,
                confirmButtonText: '<i class="bi bi-check-circle-fill me-2"></i>Close',
                confirmButtonColor: '#0b6623',
                background: '#ffffff',
                customClass: {
                    popup: 'shadow-lg',
                    htmlContainer: 'p-0'
                }
            });
        }

        // Add event listener for modal hidden event to reset content
        document.addEventListener('DOMContentLoaded', function() {
            const modalElement = document.getElementById('guestDetailsModal');
            if (modalElement) {
                modalElement.addEventListener('hidden.bs.modal', function () {
                    // Reset modal content when closed
                    const resetElements = ['modalFullName', 'modalEmail', 'modalContact'];
                    resetElements.forEach(elementId => {
                        const element = document.getElementById(elementId);
                        if (element) {
                            element.textContent = '-';
                        }
                    });
                    
                    // Clear bookings grid
                    const bookingsGrid = document.getElementById('bookingsGrid');
                    if (bookingsGrid) {
                        bookingsGrid.innerHTML = '';
                    }
                });
            }
        });
    </script>
</asp:Content>