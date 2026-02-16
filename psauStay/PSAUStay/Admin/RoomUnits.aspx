<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="RoomUnits.aspx.cs" Inherits="PSAUStay.Admin.RoomUnits" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <%-- Green Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-door-open-fill me-2" style="color: var(--psau-gold);"></i>
                        Manage Room Numbers
                    </h2>
                    <p class="mb-0 text-white-50">Update room units and numbers for each room category</p>
                </div>
                <div class="col-auto">
                    <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                        <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card p-4 shadow-sm">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label fw-bold">Select Room Type</label>
                <asp:DropDownList ID="ddlRoomTypes" runat="server" AutoPostBack="true" CssClass="form-control"
                    OnSelectedIndexChanged="ddlRoomTypes_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Add New Room Number/Unit</label>
                <div class="input-group">
                    <asp:TextBox ID="txtRoomNumber" runat="server" CssClass="form-control" Placeholder="e.g. Room 101"></asp:TextBox>
                    <asp:Button ID="btnAddRoom" runat="server" Text="Add Unit" CssClass="btn btn-primary"
                        OnClick="btnAddRoom_Click" />
                </div>
            </div>
        </div>
    </div>

    <br />

    <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2"></asp:Label>

    <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-striped shadow-sm"
        OnRowCommand="gvRooms_RowCommand">
        <Columns>
            <asp:BoundField DataField="RoomNumber" HeaderText="Room Number" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='badge <%# Eval("Status").ToString() == "Available" ? "bg-success" : "bg-danger" %>'>
                        <%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnDelete" runat="server" Text="Remove" CommandName="DeleteRoom"
                        CommandArgument='<%# Eval("UnitID") %>' CssClass="btn btn-outline-danger btn-sm" 
                        OnClientClick="return confirm('Are you sure you want to remove this specific unit?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">Edit Room Unit</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfUnitID" runat="server" />
                    <div class="mb-3">
                        <label class="form-label fw-bold">Room Number</label>
                        <asp:TextBox ID="txtEditRoomNumber" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Status</label>
                        <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Available" Value="Available" />
                            <asp:ListItem Text="Booked" Value="Booked" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnUpdateUnit" runat="server" Text="Update Unit" CssClass="btn btn-primary" OnClick="btnUpdateUnit_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function showEditModal() {
            var modal = new bootstrap.Modal(document.getElementById('editModal'));
            modal.show();
        }
    </script>
</asp:Content>