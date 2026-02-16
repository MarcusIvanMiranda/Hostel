
<asp:Content ID="Content1" ContentPlaceHolderID="HouseKeeperMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-success">Occupied Rooms Report</h2>
                <p class="text-muted">Currently active guest stays.</p>
            </div>
            <button type="button" class="btn btn-secondary shadow-sm" data-bs-toggle="modal" data-bs-target="#historyModal">
                <i class="bi bi-clock-history me-1"></i> View Past Checkouts
            </button>
        </div>

        <div class="row">
            <asp:Repeater ID="rptOccupiedRooms" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-4">
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
                    <div class="table-responsive">
                        <asp:GridView ID="gvHKHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-hover border-0" Width="100%">
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
