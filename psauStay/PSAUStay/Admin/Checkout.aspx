<%@ Page Title="Guest Checkout" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="PSAUStay.Admin.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <asp:HiddenField ID="hfSelectedID" runat="server" />
    <asp:Button ID="btnHiddenConfirm" runat="server" OnClick="btnConfirmAction_Click" Style="display:none;" />

    <div class="container-fluid py-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-box-arrow-right me-2" style="color: var(--psau-gold);"></i>
                            Checkout Management
                        </h2>
                        <p class="mb-0 text-white-50">Manage guest checkouts and final billing</p>
                    </div>
                    <div class="col-auto">
                        <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <ul class="nav nav-tabs mb-4" id="checkoutTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link active fw-bold text-success" id="active-tab" data-bs-toggle="tab" data-bs-target="#activeContent" type="button">Active Checkouts</button>
            </li>
            <li class="nav-item">
                <button class="nav-link fw-bold text-muted" id="history-tab" data-bs-toggle="tab" data-bs-target="#historyContent" type="button">Checkout History</button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="activeContent">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body">
                        <div class="input-group">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search Guest or Room..."></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="Filter" CssClass="btn btn-success" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>

                <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                    <dx:ASPxGridView ID="gvCheckout" runat="server" AutoGenerateColumns="False" KeyFieldName="CombinedID" Width="100%" Theme="MaterialCompact" OnDataBinding="gvCheckout_DataBinding">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" />
                            <dx:GridViewDataTextColumn FieldName="RoomNumber" Caption="Room No." />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Unit Name" CellStyle-Font-Bold="true" />
                            <dx:GridViewDataTextColumn FieldName="TotalBill" Caption="Total Bill">
                                <PropertiesTextEdit DisplayFormatString="PHP {0:N2}" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataColumn Caption="Action" Width="150px">
                                <DataItemTemplate>
                                    <button type="button" class="btn btn-sm btn-primary w-100 fw-bold" 
                                            data-id='<%# Eval("Source") + "|" + Eval("ID") %>' 
                                            data-guest='<%# Eval("FullName") %>'
                                            data-base='<%# Eval("BasePrice") %>'
                                            data-extra='<%# Eval("ExtraTotal") %>'
                                            data-details='<%# Eval("ExtraDetails") %>'
                                            data-payment='<%# Eval("PaymentStatus") %>'
                                            onclick="confirmCheckout(this)">
                                        Check-out
                                    </button>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                        </Columns>
                    </dx:ASPxGridView>
                </div>
            </div>

            <div class="tab-pane fade" id="historyContent">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-hover mb-0" Width="100%" GridLines="None" EmptyDataText="No past checkouts found." style="min-width: 600px;">
                                <Columns>
                                    <asp:BoundField DataField="FullName" HeaderText="Guest Name" />
                                    <asp:BoundField DataField="RoomNumber" HeaderText="Room No." />
                                    <asp:BoundField DataField="RoomName" HeaderText="Unit Name" />
                                    <asp:BoundField DataField="BasePrice" HeaderText="Room Price" DataFormatString="PHP {0:N2}" />
                                    <asp:BoundField DataField="ExtraTotal" HeaderText="Extras" DataFormatString="PHP {0:N2}" />
                                    <asp:TemplateField HeaderText="Total Collected">
                                        <ItemTemplate>
                                            <span class="fw-bold text-success">PHP <%# Eval("TotalBill", "{0:N2}") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CheckOutDate" HeaderText="Date Processed" DataFormatString="{0:MMM dd, yyyy}" />
                                </Columns>
                                <HeaderStyle CssClass="bg-light fw-bold" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function confirmCheckout(button) {
            const id = button.getAttribute('data-id');
            const guest = button.getAttribute('data-guest');
            const basePrice = parseFloat(button.getAttribute('data-base')) || 0;
            const extraTotal = parseFloat(button.getAttribute('data-extra')) || 0;
            const paymentStatus = button.getAttribute('data-payment') || 'Pending';
            const downpayment = basePrice * 0.5;
            
            let remainingBalance = 0;
            let billingHtml = '';
            
            if (paymentStatus === 'Fully Paid') {
                // Fully paid bookings - only charge extra fees
                remainingBalance = extraTotal;
                billingHtml = `
                    <div class="text-start p-3">
                        <div class="mb-3 p-3 bg-light rounded border-start border-4 border-success">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Guest Name</small>
                            <span class="fs-5 fw-bold text-dark">${guest}</span>
                        </div>
                        <div class="mb-3 p-3 bg-info rounded border-start border-4 border-info">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Payment Status</small>
                            <span class="fs-6 fw-bold text-dark">Fully Paid</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Room Base Price:</span>
                            <span class="fw-bold text-success">PHP ${basePrice.toLocaleString(undefined, {minimumFractionDigits: 2})} <small>(Paid)</small></span>
                        </div>
                        <div class="mt-3 mb-2 fw-bold text-muted small text-uppercase">Extra Expenses:</div>
                        <div class="ps-2 mb-3 border-start border-3 border-primary" style="max-height: 150px; overflow-y: auto; background-color: #fafafa;">
                            ${extraTotal > 0 ? (extraTotal === 0 ? '<div class="small text-muted p-1">None</div>' : button.getAttribute('data-details')) : '<div class="small text-muted p-1">None</div>'}
                        </div>
                        <hr class="my-3 border-top">
                        <div class="d-flex justify-content-between align-items-center p-3 bg-dark text-white rounded shadow-sm">
                            <span class="fw-bold">AMOUNT DUE:</span>
                            <span class="fs-4 fw-bold text-warning">PHP ${remainingBalance.toLocaleString(undefined, {minimumFractionDigits: 2})}</span>
                        </div>
                    </div>`;
            } else {
                // Downpayment bookings - charge remaining balance
                remainingBalance = (basePrice + extraTotal) - downpayment;
                billingHtml = `
                    <div class="text-start p-3">
                        <div class="mb-3 p-3 bg-light rounded border-start border-4 border-success">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Guest Name</small>
                            <span class="fs-5 fw-bold text-dark">${guest}</span>
                        </div>
                        <div class="mb-3 p-3 bg-warning rounded border-start border-4 border-warning">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Payment Status</small>
                            <span class="fs-6 fw-bold text-dark">Downpayment Paid</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Room Base Price:</span>
                            <span class="fw-bold text-dark">PHP ${basePrice.toLocaleString(undefined, {minimumFractionDigits: 2})}</span>
                        </div>
                        <div class="mt-3 mb-2 fw-bold text-muted small text-uppercase">Extra Expenses:</div>
                        <div class="ps-2 mb-3 border-start border-3 border-primary" style="max-height: 150px; overflow-y: auto; background-color: #fafafa;">
                            ${extraTotal === 0 ? '<div class="small text-muted p-1">None</div>' : button.getAttribute('data-details')}
                        </div>
                        <div class="d-flex justify-content-between text-success small mb-1">
                            <span>Paid Downpayment (50%):</span>
                            <span>- PHP ${downpayment.toLocaleString(undefined, {minimumFractionDigits: 2})}</span>
                        </div>
                        <hr class="my-3 border-top">
                        <div class="d-flex justify-content-between align-items-center p-3 bg-dark text-white rounded shadow-sm">
                            <span class="fw-bold">REMAINING BALANCE:</span>
                            <span class="fs-4 fw-bold text-warning">PHP ${remainingBalance.toLocaleString(undefined, {minimumFractionDigits: 2})}</span>
                        </div>
                    </div>`;
            }

            Swal.fire({
                title: '<h4 class="fw-bold mb-0 text-success">Billing Summary</h4>',
                html: billingHtml,
                showCancelButton: true,
                confirmButtonColor: '#198754',
                confirmButtonText: remainingBalance > 0 ? 'Confirm Payment' : 'Complete Checkout',
                cancelButtonText: 'Close',
                width: '500px'
            }).then((result) => {
                if (result.isConfirmed) {
                    document.getElementById('<%= hfSelectedID.ClientID %>').value = id;
                    document.getElementById('<%= btnHiddenConfirm.ClientID %>').click();
                }
            });
        }
    </script>
</asp:Content>
