<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GenerateAdmin.aspx.cs" Inherits="PSAUStay.Account.GenerateAdmin" %>

<!DOCTYPE html>
<html>
<head><title>Generate Admin Hash</title></head>
<body>
    <form id="form1" runat="server">
        <asp:Button ID="btnRun" runat="server" Text="Generate Admin" OnClick="btnRun_Click" />
        <br />
        <asp:Label ID="lblResult" runat="server"></asp:Label>
    </form>
</body>
</html>