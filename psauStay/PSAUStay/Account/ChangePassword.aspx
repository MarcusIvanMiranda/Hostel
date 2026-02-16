<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="PSAUStay.Account.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3>🔒 Change Password</h3>
    <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
    <div class="form-group">
        <label>Current Password:</label>
        <asp:TextBox ID="txtOldPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
    </div>
    <div class="form-group">
        <label>New Password:</label>
        <asp:TextBox ID="txtNewPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
    </div>
    <div class="form-group">
        <label>Confirm New Password:</label>
        <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
    </div>
    <asp:Button ID="btnUpdate" runat="server" Text="Update Password" CssClass="btn btn-success" OnClick="btnUpdate_Click" />
</asp:Content>
