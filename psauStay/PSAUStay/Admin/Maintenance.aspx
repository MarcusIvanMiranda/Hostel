<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="Maintenance.aspx.cs" Inherits="PSAUStay.Admin.Maintenance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <div class="page-title-area mb-4">
        <h3>Maintenance Requests</h3>
    </div>

    <div class="mb-3">
        <asp:Button ID="btnAdd" runat="server" Text="Add New Request" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
    </div>

    <asp:GridView ID="gvMaintenance" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-hover">
        <Columns>
            <asp:BoundField DataField="MaintenanceID" HeaderText="ID" />
            <asp:BoundField DataField="RoomName" HeaderText="Room" />
            <asp:BoundField DataField="IssueDescription" HeaderText="Issue" />
            <asp:BoundField DataField="RequestorName" HeaderText="Requested By" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:BoundField DataField="AssignedTo" HeaderText="Assigned To" />
            <asp:BoundField DataField="DateRequested" HeaderText="Date Requested" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditRequest" CommandArgument='<%# Eval("MaintenanceID") %>' CssClass="btn btn-sm btn-warning" />
                    <asp:Button ID="btnComplete" runat="server" Text="Complete" CommandName="CompleteRequest" CommandArgument='<%# Eval("MaintenanceID") %>' CssClass="btn btn-sm btn-success" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
