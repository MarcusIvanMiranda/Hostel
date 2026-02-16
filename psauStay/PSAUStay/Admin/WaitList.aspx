<%@ Page Title="Waitlist" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="WaitList.aspx.cs" Inherits="PSAUStay.Admin.WaitList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <%-- Hidden inputs for communication between JS and Server --%>
    <asp:HiddenField ID="hfSelectedID" runat="server" />
    <asp:HiddenField ID="hfActionType" runat="server" />
    <asp:HiddenField ID="hfPaymentType" runat="server" />
    <asp:Button ID="btnHiddenConfirm" runat="server" OnClick="btnConfirmAction_Click" Style="display:none;" />

    <div class="container mt-4">
        <h3 class="mb-4 text-success"><i class="bi bi-hourglass-split me-2"></i>Waitlist Requests</h3>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3"></asp:Label>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvWaitlist" runat="server" CssClass="table table-hover mb-0"
                    GridLines="None" AutoGenerateColumns="False" DataKeyNames="ReservationID">
                    <HeaderStyle CssClass="bg-light text-muted small text-uppercase fw-bold" />
                    <Columns>
                        <asp:BoundField DataField="FullName" HeaderText="Guest Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Contact" HeaderText="Contact Number" />
                        <asp:BoundField DataField="RoomName" HeaderText="Room" />
                        <asp:BoundField DataField="CheckInDate" HeaderText="Check-In" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="CheckOutDate" HeaderText="Check-Out" DataFormatString="{0:MMM dd, yyyy}" />
                        
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='badge <%# Eval("Status").ToString() == "Pending" ? "bg-warning text-dark" : "bg-info text-dark" %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-success btn-sm" 
                                        data-id='<%# Eval("ReservationID") %>' 
                                        data-contact='<%# Eval("FullName") %>' 
                                        data-action="Approve"
                                        onclick="confirmAction(this)">
                                        <i class="bi bi-check-lg"></i> Approve
                                    </button>
                                    <button type="button" class="btn btn-outline-danger btn-sm" 
                                        data-id='<%# Eval("ReservationID") %>' 
                                        data-contact='<%# Eval("FullName") %>' 
                                        data-action="Reject"
                                        onclick="confirmAction(this)">
                                        <i class="bi bi-x-lg"></i> Reject
                                    </button>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function confirmAction(button) {
            var id = button.getAttribute('data-id');
            var contact = button.getAttribute('data-contact');
            var action = button.getAttribute('data-action');
            
            var isApprove = (action === 'Approve');

            if (isApprove) {
                // Show payment selection modal for approve actions
                showPaymentModal(id, contact);
            } else {
                // Show regular confirmation for reject actions
                showRejectConfirmation(id, contact);
            }
        }

        function showPaymentModal(id, contact) {
            Swal.fire({
                title: 'Select Payment Status',
                html: `
                    <div class="text-center mb-3">
                        <p>How would you like to mark the payment for <strong>${contact}</strong>?</p>
                    </div>
                    <div class="d-grid gap-2">
                        <button class="btn btn-success" onclick="selectPaymentType('${id}', '${contact}', 'Fully Paid')">
                            <i class="bi bi-check-circle"></i> Fully Paid
                        </button>
                        <button class="btn btn-warning" onclick="selectPaymentType('${id}', '${contact}', 'Downpayment Paid')">
                            <i class="bi bi-clock"></i> Downpayment Paid
                        </button>
                    </div>
                `,
                showConfirmButton: false,
                showCancelButton: true,
                cancelButtonText: 'Cancel',
                cancelButtonColor: '#6c757d'
            });
        }

        function selectPaymentType(id, contact, paymentType) {
            Swal.fire({
                title: 'Confirm Approval',
                html: `
                    <div class="text-center">
                        <p>Are you sure you want to approve the request for <strong>${contact}</strong>?</p>
                        <p class="text-muted">Payment Status: <strong>${paymentType}</strong></p>
                    </div>
                `,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, Approve',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Update hidden fields
                    document.getElementById('<%= hfSelectedID.ClientID %>').value = id;
                    document.getElementById('<%= hfActionType.ClientID %>').value = 'Approve';
                    document.getElementById('<%= hfPaymentType.ClientID %>').value = paymentType;
                    
                    // Fire the server-side event
                    document.getElementById('<%= btnHiddenConfirm.ClientID %>').click();
                }
            });
        }

        function showRejectConfirmation(id, contact) {
            Swal.fire({
                title: 'Reject Reservation?',
                text: "Are you sure you want to reject the request for " + contact + "?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, Reject',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Update hidden fields
                    document.getElementById('<%= hfSelectedID.ClientID %>').value = id;
                    document.getElementById('<%= hfActionType.ClientID %>').value = 'Reject';
                    document.getElementById('<%= hfPaymentType.ClientID %>').value = '';
                    
                    // Fire the server-side event
                    document.getElementById('<%= btnHiddenConfirm.ClientID %>').click();
                }
            });
        }
    </script>
</asp:Content>