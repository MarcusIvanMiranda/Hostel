<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="PSAUStay.Account.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">


    <h2 class="mb-4">Manage Users</h2>

    <!-- Add User Button -->
    <asp:Button ID="btnAddUser" runat="server" Text="➕ Add User" CssClass="btn btn-success mb-3"
        OnClick="btnAddUser_Click" />

    <!-- Users Grid -->
    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered"
        OnRowCommand="gvUsers_RowCommand">
        <Columns>

            <asp:BoundField DataField="UserId" HeaderText="ID" />

            <asp:BoundField DataField="FullName" HeaderText="Full Name" />

            <asp:BoundField DataField="Email" HeaderText="Email" />

            <asp:BoundField DataField="AccessLevelName" HeaderText="Role" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit"
                        CommandName="EditUser" CommandArgument='<%# Eval("UserId") %>'
                        CssClass="btn btn-primary btn-sm" />

                    <asp:Button ID="btnDelete" runat="server" Text="Delete"
                        CommandName="DeleteUser" CommandArgument='<%# Eval("UserId") %>'
                        CssClass="btn btn-danger btn-sm" />
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>

    <!-- Modal Panel for Add/Edit -->
    <asp:Panel ID="pnlModal" runat="server" CssClass="card p-4" Visible="False">

        <h4><asp:Label ID="lblModalTitle" runat="server" Text="Add User"></asp:Label></h4>

        <div class="mb-2">
            <label>Full Name</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-2">
            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="mb-2">
            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
        </div>

        <div class="mb-2">
            <label>Role</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>

        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-success"
            OnClick="btnSave_Click" />

        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary"
            OnClick="btnCancel_Click" />

    </asp:Panel>
</asp:Content>
