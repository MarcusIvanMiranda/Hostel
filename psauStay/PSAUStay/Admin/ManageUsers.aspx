<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="PSAUStay.Admin.WebForm1" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users | PSAU Stay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f5f5f5;
        }

        .sidebar {
            height: 100vh;
            position: fixed;
            width: 220px;
            top: 0;
            left: 0;
            background-color: #343a40;
            color: #fff;
            padding-top: 60px;
        }

        .sidebar a {
            display: block;
            color: #fff;
            padding: 12px 20px;
            text-decoration: none;
            margin-bottom: 5px;
            border-radius: 5px;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        .content {
            margin-left: 240px;
            padding: 20px;
        }

        .card {
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .badge-pending { background-color: #ffc107; color: #fff; }
        .badge-approved { background-color: #28a745; color: #fff; }
        .badge-rejected { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <!-- Sidebar -->
        <div class="sidebar">
            <h4 class="text-center">Admin Panel</h4>
            <a href="Dashboard.aspx">Dashboard</a>
            <a href="AddRoom.aspx">Add Room</a>
            <a href="ManageUsers.aspx">Manage Users</a>
            <a href="RoomRequests.aspx">Room Requests</a>
            <a href="Reports.aspx">Reports</a>
            <a href="Logout.aspx">Logout</a>
        </div>
        
        <%--<!-- Main Content -->
        <div class="content">

            

        </div>--%>
    </form>
</body>
</html>

