<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PSAUStay.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-page-container">
        <div class="container d-flex justify-content-center align-items-center" style="min-height: 85vh;">
            <div class="login-card shadow-lg border-0 rounded-4 overflow-hidden">
                
                <div class="card-header text-center py-4 border-0">
                    <img src='<%= ResolveUrl("~/images/psau-logo.png") %>' alt="PSAU" width="60" class="mb-2 logo-drop">
                    <h3 class="mb-0 fw-bold text-white">PSAU Stay</h3>
                    <p class="text-white-50 mb-0 small">Hostel Management Portal</p>
                </div>

                <div class="card-body p-4 p-md-5 bg-white">
                    <asp:Label ID="lblMsg" runat="server" CssClass="alert alert-danger d-block mb-3 py-2 small text-center" Visible="false"></asp:Label>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtEmail" CssClass="form-control custom-input" runat="server" placeholder="Email"></asp:TextBox>
                        <label for="MainContent_txtEmail">Email Address</label>
                    </div>

                    <div class="form-floating mb-4">
                        <asp:TextBox ID="txtPassword" CssClass="form-control custom-input" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <label for="MainContent_txtPassword">Password</label>
                    </div>

                    <div class="d-grid">
                        <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                            CssClass="btn btn-psau-gold btn-lg fw-bold py-3 shadow-sm" OnClick="btnLogin_Click" />
                    </div>

                    <div class="text-center mt-4">
                        <a href='<%= ResolveUrl("~/Account/ResetPassword.aspx") %>' class="text-success small fw-semibold text-decoration-none">Forgot Password?</a>    
                        
                        <div class="mt-3 pt-3 border-top">
                            <a href='<%= ResolveUrl("~/Default.aspx") %>' class="text-muted small text-decoration-none">
                                <i class="bi bi-house-door me-1"></i>Return to Homepage
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            background: url('<%= ResolveUrl("~/images/Background01.jpg") %>') no-repeat center center fixed !important;
            background-size: cover !important;
        }
        .login-page-container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            min-height: 85vh;
        }
        .login-card { width: 100%; max-width: 420px; transition: transform 0.3s ease; }
        .card-header { background: linear-gradient(135deg, #1B5E20 0%, #0D3B10 100%); }
        .logo-drop { filter: drop-shadow(0 4px 8px rgba(0,0,0,0.3)); }
        .custom-input:focus { border-color: #F9A825; box-shadow: 0 0 0 0.25rem rgba(249, 168, 37, 0.15); }
        .btn-psau-gold { background-color: #F9A825; color: #212529; border: none; border-radius: 8px; transition: all 0.2s ease; }
        .btn-psau-gold:hover { background-color: #e69612; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(230, 150, 18, 0.3) !important; }
        .btn-psau-gold:active { transform: scale(0.96); }
    </style>
</asp:Content>