<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="PSAUStay.Admin.ResetPassword" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Admin Reset Password | PSAUStay</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: linear-gradient(135deg, #004d40, #00796b); margin: 0; padding: 0; }
        .container { max-width: 480px; margin: 80px auto; background: #fff; border-radius: 14px; box-shadow: 0 4px 25px rgba(0,0,0,0.15); overflow: hidden; }
        .header { background: linear-gradient(135deg, #1B5E20, #0D3B10); color: #fff; padding: 25px; text-align: center; }
        .header h2 { margin: 0; font-size: 1.5em; }
        .content { padding: 30px; }
        label { font-weight: 600; color: #333; display: block; margin-bottom: 5px; }
        .form-control { width: 100%; padding: 12px; font-size: 14px; border: 1px solid #ccc; border-radius: 8px; margin-bottom: 15px; box-sizing: border-box; }
        .btn-primary { background: #1B5E20; color: #fff; border: none; border-radius: 8px; padding: 12px; width: 100%; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-primary:hover { background: #0D3B10; }
        .alert { padding: 12px; border-radius: 8px; margin-top: 15px; text-align: center; font-size: 14px; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .alert-danger { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
        .footer { text-align: center; font-size: 13px; padding: 20px; background: #fafafa; border-top: 1px solid #eee; }
        a { color: #1B5E20; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h2>🔐 Reset User Password</h2>
                <p style="margin: 5px 0 0 0; opacity: 0.8; font-size: 0.9em;">Administrator Control Panel</p>
            </div>

            <div class="content">
                <label>User Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Enter user email" />

                <label>New Password:</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Enter new password" />

                <asp:Button ID="btnReset" runat="server" Text="Reset Password" CssClass="btn-primary" OnClick="btnReset_Click" />

                <asp:Label ID="lblMsg" runat="server" EnableViewState="false"></asp:Label>
            </div>

            <div class="footer">
                <a href="../Account/Login.aspx">← Return to Login Page</a>
                <div style="margin-top: 10px; color: #777;">PSAUStay System &copy; <%: DateTime.Now.Year %></div>
            </div>
        </div>
    </form>
</body>
</html>