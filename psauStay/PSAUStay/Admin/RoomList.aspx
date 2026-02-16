<%@ Page Title="Manage Rooms" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="RoomList.aspx.cs" Inherits="PSAUStay.Admin.RoomList" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="mb-3">🏠 Manage Rooms</h3>

    <asp:Label ID="lblMsg" runat="server" ForeColor="Green"></asp:Label>

    <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
        OnRowCommand="gvRooms_RowCommand" OnRowDataBound="gvRooms_RowDataBound">
        <Columns>
            <asp:TemplateField HeaderText="Image">
                <ItemTemplate>
                    <img src='<%# Eval("Image1") %>' alt="Room" style="width:80px;height:60px;object-fit:cover;border-radius:6px;" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="RoomName" HeaderText="Room Name" />
            <asp:BoundField DataField="RoomType" HeaderText="Type" />
            <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
            <asp:BoundField DataField="Price" HeaderText="Price (₱)" DataFormatString="{0:N2}" />
            <asp:TemplateField HeaderText="Available">
                <ItemTemplate>
                    <asp:Label ID="lblAvail" runat="server" Text='<%# (bool)Eval("IsAvailable") ? "✅ Yes" : "❌ No" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-sm btn-warning" CommandName="EditRoom" CommandArgument='<%# Eval("RoomID") %>' />
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-sm btn-danger" CommandName="DeleteRoom" CommandArgument='<%# Eval("RoomID") %>' OnClientClick="return confirm('Are you sure you want to delete this room?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
