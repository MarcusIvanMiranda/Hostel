<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="RoomStatus.aspx.cs" Inherits="PSAUStay.Admin.RoomStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <%-- Green Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-house-door-fill me-2" style="color: var(--psau-gold);"></i>
                        Room Status
                    </h2>
                    <p class="mb-0 text-white-50">Monitor current room availability and maintenance status</p>
                </div>
                <div class="col-auto">
                    <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                        <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
        <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" style="min-width: 550px;">
            <Columns>
                <asp:BoundField DataField="RoomName" HeaderText="Room Name" />
                <asp:BoundField DataField="RoomNumber" HeaderText="Room No." />
                <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
                <asp:BoundField DataField="Status" HeaderText="Room Status" />
                <asp:BoundField DataField="CurrentBooking" HeaderText="Current Booking" />
                <asp:BoundField DataField="MaintenanceStatus" HeaderText="Maintenance Status" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
