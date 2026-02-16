<%@ Page Title="Reservation Management" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="Reservations.aspx.cs" Inherits="PSAUStay.Admin.Reservations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- Page Title -->
    <h2 class="mb-4">Reservation Management</h2>

    <!-- Filters Section -->
    <div class="filter-section mb-3">
        <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
            <asp:ListItem Text="All Reservations" Value="All"></asp:ListItem>
            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
            <asp:ListItem Text="Confirmed" Value="Confirmed"></asp:ListItem>
            <asp:ListItem Text="Checked-in" Value="CheckedIn"></asp:ListItem>
            <asp:ListItem Text="Checked-out" Value="CheckedOut"></asp:ListItem>
            <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-primary ms-2" OnClick="btnRefresh_Click" />
    </div>

    <!-- Reservation Grid -->
    <asp:GridView ID="gvReservations" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" DataKeyNames="ReservationID" OnRowCommand="gvReservations_RowCommand">
        <Columns>
            <asp:BoundField DataField="ReservationID" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="GuestName" HeaderText="Guest Name" />
            <asp:BoundField DataField="RoomName" HeaderText="Room" />
            <asp:BoundField DataField="CheckInDate" HeaderText="Check-In" DataFormatString="{0:MMM dd, yyyy}" />
            <asp:BoundField DataField="CheckOutDate" HeaderText="Check-Out" DataFormatString="{0:MMM dd, yyyy}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnView" runat="server" CommandName="View" CommandArgument='<%# Eval("ReservationID") %>' Text="View" CssClass="btn btn-sm btn-info" />
                    <asp:Button ID="btnEdit" runat="server" CommandName="Edit" CommandArgument='<%# Eval("ReservationID") %>' Text="Edit" CssClass="btn btn-sm btn-warning" />
                    <asp:Button ID="btnCancel" runat="server" CommandName="Cancel" CommandArgument='<%# Eval("ReservationID") %>' Text="Cancel" CssClass="btn btn-sm btn-danger" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Optional: Modal or Panel for Viewing/Editing Reservation Details -->
    <asp:Panel ID="pnlReservationDetails" runat="server" Visible="false">
        <h4>Reservation Details</h4>
        <asp:Label ID="lblDetails" runat="server" Text=""></asp:Label>
    </asp:Panel>
</asp:Content>
