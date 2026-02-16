<%@ Page Title="Reservations" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ViewReservation.aspx.cs" Inherits="PSAUStay.Admin.ViewReservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <div class="container-fluid py-3">
        
        <%-- View 1: List of All Bookings --%>
        <asp:Panel ID="pnlAllBookings" runat="server" Visible="false">
            <div class="row mb-4">
                <div class="col">
                    <h2 class="fw-bold" style="color: #0b6623;">Reservation Management</h2>
                    <p class="text-muted">View details or remove booking records.</p>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <dx:ASPxGridView ID="gvAllReservations" runat="server" AutoGenerateColumns="False" KeyFieldName="RequestID" Width="100%" Theme="MaterialCompact">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" CellStyle-CssClass="fw-bold" />
                            <dx:GridViewDataTextColumn FieldName="Email" Caption="Email" />
                            <dx:GridViewDataTextColumn FieldName="Contact" Caption="Contact Number" />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Room" />
                            <dx:GridViewDataDateColumn FieldName="CheckInDate" Caption="Check-In" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataDateColumn FieldName="CheckOutDate" Caption="Check-Out" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataTextColumn FieldName="Status" Caption="Status">
                                <DataItemTemplate>
                                    <%# GetStatusBadgeHtml(Eval("Status").ToString()) %>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Actions" Width="180px">
                                <DataItemTemplate>
                                    <div class="d-flex gap-2">
                                        <a href='ViewReservation.aspx?RequestID=<%# Eval("RequestID") %>' class="btn btn-sm btn-outline-success">
                                            <i class="bi bi-eye"></i> Details
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmDeleteList('<%# Eval("RequestID") %>', '<%# Eval("FullName") %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <Settings ShowFilterRow="false" /> 
                        <SettingsPager PageSize="12" />
                    </dx:ASPxGridView>
                </div>
            </div>
        </asp:Panel>

        <%-- View 2: Single Detail View --%>
        <asp:Panel ID="pnlSingleDetails" runat="server" Visible="false">
             <div class="mb-4">
                <a href="ViewReservation.aspx" class="text-decoration-none text-success fw-bold">
                    <i class="bi bi-arrow-left"></i> Back to All Bookings
                </a>
            </div>
            <div class="row">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-bold">Guest Information</h5>
                            <asp:Label ID="lblStatusBadge" runat="server" />
                        </div>
                        <div class="card-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="text-muted small text-uppercase fw-bold">Guest Name</label>
                                    <p class="fs-5 fw-bold"><asp:Label ID="lblGuestName" runat="server" /></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small text-uppercase fw-bold">Email Address</label>
                                    <p class="fs-5"><asp:Label ID="lblEmail" runat="server" /></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small text-uppercase fw-bold">Contact Number</label>
                                    <p class="fs-5"><asp:Label ID="lblContact" runat="server" /></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small text-uppercase fw-bold">Room Type</label>
                                    <p class="fs-5"><asp:Label ID="lblRoomName" runat="server" /></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="text-muted small text-uppercase fw-bold">Stay Dates</label>
                                    <p class="fs-5"><asp:Label ID="lblDates" runat="server" /></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm border-top border-success border-4">
                        <div class="card-header bg-white py-3 text-center border-bottom">
                            <h5 class="mb-0 fw-bold">Action Center</h5>
                        </div>
                        <div class="card-body text-center py-4">
                            <div id="divActions" runat="server" class="d-grid gap-2">
                                <asp:Button ID="btnApprove" runat="server" Text="Approve Booking" CssClass="btn btn-success py-2 fw-bold" OnClick="btnApprove_Click" />
                                <asp:Button ID="btnWaitlist" runat="server" Text="Move to Waitlist" CssClass="btn btn-warning py-2 fw-bold" OnClick="btnWaitlist_Click" />
                                <asp:Button ID="btnReject" runat="server" Text="Reject Request" CssClass="btn btn-outline-danger py-2" OnClick="btnReject_Click" />
                            </div>
                            <asp:Panel ID="pnlProcessed" runat="server" Visible="false">
                                <div class="alert alert-light border-0 text-center">
                                    Status: <strong><asp:Literal ID="litCurrentStatus" runat="server" /></strong>.
                                    <br />
                                    <asp:LinkButton ID="btnResetStatus" runat="server" Text="Reset to Pending" CssClass="btn btn-link btn-sm mt-2" OnClick="btnReset_Click" />
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <%-- Hidden Fields and Trigger Button --%>
    <asp:HiddenField ID="hfDeleteID" runat="server" />
    <asp:Button ID="btnHiddenDelete" runat="server" OnClick="btnDeleteFull_Click" Style="display:none;" />

    <script>
        function confirmDeleteList(id, name) {
            Swal.fire({
                title: 'Delete Reservation?',
                text: "Are you sure you want to delete the record for " + name + "? This action cannot be undone.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Set the ID to the hidden field
                    document.getElementById('<%= hfDeleteID.ClientID %>').value = id;
                    // Trigger the hidden ASP.NET button to perform the postback
                    document.getElementById('<%= btnHiddenDelete.ClientID %>').click();
                }
            });
        }
    </script>
</asp:Content>