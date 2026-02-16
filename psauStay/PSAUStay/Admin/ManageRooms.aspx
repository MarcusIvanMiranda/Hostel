<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ManageRooms.aspx.cs" Inherits="PSAUStay.Admin.ManageRooms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <h2 class="mb-4 text-primary">Manage Rooms</h2>

    <asp:Button ID="btnAddRoom" runat="server" Text="Add New Room Category" CssClass="btn btn-success mb-3"
        OnClick="btnAddRoom_Click" />

    <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle shadow-sm"
        OnRowCommand="gvRooms_RowCommand" DataKeyNames="RoomID">
        <HeaderStyle CssClass="table-primary" />
        <Columns>
            <asp:BoundField DataField="RoomID" HeaderText="ID" />
            <asp:BoundField DataField="RoomName" HeaderText="Room Name" />
            <asp:BoundField DataField="RoomType" HeaderText="Type" />
            <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
            <asp:BoundField DataField="Price" HeaderText="Price (₱)" DataFormatString="{0:N2}" />

            <asp:TemplateField HeaderText="Live Inventory">
                <ItemTemplate>
                    <div class="d-flex align-items-center">
                        <span class='badge <%# Convert.ToInt32(Eval("UnitsAvailable")) > 0 ? "bg-info" : "bg-secondary" %> me-2'>
                            <%# Eval("UnitsAvailable") %> Units Available
                        </span>
                        <asp:Button ID="btnViewUnits" runat="server" Text="View Units" 
                            CssClass="btn btn-sm btn-outline-primary" 
                            CommandName="ViewUnits" CommandArgument='<%# Eval("RoomID") %>' />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-sm btn-warning me-1"
                        CommandName="EditRoom" CommandArgument='<%# Eval("RoomID") %>' />

                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-sm btn-danger"
                        CommandName="DeleteRoom" CommandArgument='<%# Eval("RoomID") %>'
                        OnClientClick='<%# "return confirmDelete(this, " + Eval("RoomID") + ");" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold mt-3 d-block"></asp:Label>

    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Edit Room Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfRoomID" runat="server" />
                    <div class="mb-3">
                        <label class="fw-bold">Room Name</label>
                        <asp:TextBox ID="txtRoomName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">Room Type</label>
                            <asp:TextBox ID="txtRoomType" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">Capacity</label>
                            <asp:TextBox ID="txtCapacity" runat="server" TextMode="Number" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Features</label>
                        <asp:TextBox ID="txtFeatures" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Price (₱)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-check">
                        <asp:CheckBox ID="chkAvailable" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label">Available for public booking</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateRoom" runat="server" Text="Save Changes"
                        CssClass="btn btn-primary" OnClick="btnUpdateRoom_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showEditModal() {
            var modal = new bootstrap.Modal(document.getElementById('editModal'));
            modal.show();
        }

        // Custom Delete Confirmation
        function confirmDelete(button, roomId) {
            // If the button was already clicked and confirmed, allow the postback
            if (button.dataset.confirmed === "true") {
                return true;
            }

            Swal.fire({
                title: 'Are you sure?',
                text: "Deleting this category will also remove all associated room numbers. This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Mark as confirmed and trigger the click again
                    button.dataset.confirmed = "true";
                    button.click();
                }
            });

            // Always return false initially to prevent immediate postback
            return false;
        }
    </script>
</asp:Content>