<%@ Page Title="Occupancy Reports" Language="C#" MasterPageFile="~/HouseKeeper/HouseKeeperControl.master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="PSAUStay.HouseKeeper.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HouseKeeperMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <div class="container-fluid py-4">
        <%-- Modern Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-door-open-fill me-2" style="color: var(--psau-gold);"></i>
                            Occupied Rooms Report
                        </h2>
                        <p class="mb-0 text-white-50">Currently active guest stays (<%= DateTime.Now.ToString("MMM dd, yyyy") %>)</p>
                    </div>
                    <div class="col-12 col-md-auto mt-3 mt-md-0 d-flex flex-row flex-wrap gap-2">
                        <a href="<%= ResolveUrl("~/HouseKeeper/HouseKeeperDashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                        <button type="button" class="btn btn-light shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#historyModal">
                            <i class="bi bi-clock-history me-2"></i> View Past Checkouts
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3">
            <asp:Repeater ID="rptOccupiedRooms" runat="server">
                <ItemTemplate>
                    <div class="col-12 col-sm-6 col-md-4 mb-4">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="fw-bold mb-0 text-dark"><%# Eval("RoomNumber") %></h5>
                                    <span class="badge bg-primary">Occupied</span>
                                </div>
                                <p class="small text-muted mb-1"><strong>Guest:</strong> <%# Eval("FullName") %></p>
                                <p class="small text-muted mb-2"><strong>Type:</strong> <%# Eval("RoomName") %></p>
                                
                                <div class="mt-3 mb-3">
                                    <label class="small fw-bold text-muted text-uppercase" style="font-size: 0.7rem;">Current Extra Charges:</label>
                                    <div class="bg-light p-2 rounded border" style="max-height: 100px; overflow-y: auto;">
                                        <%# GetExtraChargesHtml(Eval("ID"), Eval("Source")) %>
                                    </div>
                                </div>

                                <button type="button" class="btn btn-outline-success btn-sm w-100 fw-bold" 
                                    onclick='openChargeModal(<%# Eval("ID") %>, "<%# Eval("Source") %>", "<%# Eval("RoomNumber") %>")'>
                                    <i class="bi bi-plus-circle me-1"></i> Add Extra Charge
                                </button>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <div class="modal fade" id="historyModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Checkout History Log</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                        <asp:GridView ID="gvHKHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-hover border-0" Width="100%" style="min-width: 500px;">
                            <Columns>
                                <asp:BoundField DataField="FullName" HeaderText="Guest Name" />
                                <asp:BoundField DataField="RoomNumber" HeaderText="Unit #" />
                                <asp:BoundField DataField="BasePrice" HeaderText="Room Price" DataFormatString="PHP {0:N2}" />
                                <asp:BoundField DataField="ExtraTotal" HeaderText="Extra Expenses" DataFormatString="PHP {0:N2}" />
                                <asp:TemplateField HeaderText="Total Price">
                                    <ItemTemplate>
                                        <span class="fw-bold text-success">PHP <%# Eval("TotalBill", "{0:N2}") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CheckOutDate" HeaderText="Checkout Date" DataFormatString="{0:MMM dd, yyyy}" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="chargeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Add Charge for <span id="roomNoSpan"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfBookingID" runat="server" />
                    <asp:HiddenField ID="hfSource" runat="server" />
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">ITEM / SERVICE NAME</label>
                        <asp:TextBox ID="txtChargeName" runat="server" CssClass="form-control" placeholder="e.g. Mini-bar, Extra Bed"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">PRICE (PHP)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSubmitCharge" runat="server" Text="Save Charge" CssClass="btn btn-success px-4" OnClick="btnSubmitCharge_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function openChargeModal(id, source, roomNo) {
            document.getElementById('<%= hfBookingID.ClientID %>').value = id;
            document.getElementById('<%= hfSource.ClientID %>').value = source;
            document.getElementById('roomNoSpan').innerText = roomNo;
            var myModal = new bootstrap.Modal(document.getElementById('chargeModal'));
            myModal.show();
        }
    </script>
</asp:Content>
