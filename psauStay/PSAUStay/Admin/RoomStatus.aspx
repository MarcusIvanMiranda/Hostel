<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="RoomStatus.aspx.cs" Inherits="PSAUStay.Admin.RoomStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
<div class="page-title-area mb-4">
        <h3>Room Status</h3>
    </div>

    <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
        <Columns>
            <asp:BoundField DataField="RoomName" HeaderText="Room Name" />
            <asp:BoundField DataField="RoomNumber" HeaderText="Room No." />
            <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
            <asp:BoundField DataField="Status" HeaderText="Room Status" />
            <asp:BoundField DataField="CurrentBooking" HeaderText="Current Booking" />
            <asp:BoundField DataField="MaintenanceStatus" HeaderText="Maintenance Status" />
        </Columns>
    </asp:GridView>
</asp:Content>
