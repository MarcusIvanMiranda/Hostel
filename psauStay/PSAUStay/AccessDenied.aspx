<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="PSAUStay.AccessDenied" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Access Denied</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #f8f8f8; 
            text-align: center; 
            padding-top: 100px; 
        }
        .container {
            display: inline-block;
            padding: 40px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        h1 { color: #d9534f; }
        p { color: #555; margin-top: 20px; }
        a { color: #337ab7; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>⚠️ Access Denied</h1>
        <p>You do not have permission to view this page.</p>
        <p><a href="Account/Login.aspx">Go to Login Page</a></p>
        <p><a href="Default.aspx">Go to Home Page</a></p>
    </div>
</body>
</html>

