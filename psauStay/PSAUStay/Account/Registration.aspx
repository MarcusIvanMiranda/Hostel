<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="PSAUStay.Account.Register" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4" style="max-width: 480px;">
        <h3 class="mb-3 text-center text-primary">Create an Account</h3>

        <asp:ValidationSummary ID="ValidationSummary1" runat="server"
            ForeColor="Red" HeaderText="Please fix the following errors:" />

        <asp:Label ID="lblMsg" runat="server" CssClass="text-danger fw-bold"></asp:Label>

        <div class="form-group mb-3">
            <label for="txtFullName">Full Name</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                ControlToValidate="txtFullName" ErrorMessage="Full Name is required"
                Display="Dynamic" ForeColor="Red" />
        </div>

        <div class="form-group mb-3">
            <label for="txtEmail">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@example.com"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                ControlToValidate="txtEmail" ErrorMessage="Email is required"
                Display="Dynamic" ForeColor="Red" />
            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Invalid email format"
                Display="Dynamic" ForeColor="Red"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
        </div>

        <div class="form-group mb-3">
            <label for="txtPassword">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                TextMode="Password" placeholder="Enter a strong password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                ControlToValidate="txtPassword" ErrorMessage="Password is required"
                Display="Dynamic" ForeColor="Red" />
            <asp:RegularExpressionValidator ID="revPassword" runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password must be at least 8 chars, include upper, lower, digit, and special char"
                Display="Dynamic" ForeColor="Red"
                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$" />
        </div>

        <div class="form-group mb-3">
            <label for="txtConfirmPassword">Confirm Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control"
                TextMode="Password" placeholder="Confirm your password"></asp:TextBox>
            <asp:CompareValidator ID="cvPassword" runat="server"
                ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"
                ErrorMessage="Passwords do not match"
                Display="Dynamic" ForeColor="Red" />
        </div>

        <!-- Optional: Access Level (for admins only) -->
        <div class="form-group mb-3" runat="server" visible="false" id="divAccessLevel">
            <label for="ddlAccessLevel">Access Level</label>
            <asp:DropDownList ID="ddlAccessLevel" runat="server" CssClass="form-select" />
        </div>


        <div class="text-center mt-4">
            <asp:Button ID="btnRegister" runat="server" Text="Register"
                CssClass="btn btn-primary w-100" OnClick="btnRegister_Click" />
        </div>
    </div>
</asp:Content>
