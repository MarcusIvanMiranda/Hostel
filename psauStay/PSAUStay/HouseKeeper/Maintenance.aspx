<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Maintenance.aspx.cs" Inherits="PSAUStay.HouseKeeper.HouseKeeperMaintenance" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Work Log - Maintenance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        :root {
            --psau-green: #1B5E20;
            --psau-gold: #F9A825;
            --psau-dark-green: #0D3B10;
            --psau-light-bg: #f8f9fa;
            --psau-text: #2d3436;
        }

        body {
            background-color: var(--psau-light-bg);
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: var(--psau-text);
            min-height: 100vh;
            margin: 0;
            padding: 20px 0;
        }

        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .page-header {
            background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-dark-green) 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px 12px 0 0;
            margin-bottom: 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .page-header h2 {
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .page-header h2::before {
            content: "👷";
            font-size: 2.5rem;
        }

        .section-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            margin-bottom: 2.5rem;
            border: 1px solid #e0e0e0;
        }

        .section-header {
            background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-dark-green) 100%);
            color: white;
            padding: 1.25rem 1.75rem;
            border-bottom: 3px solid var(--psau-gold);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-header h4 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .section-header.pending {
            background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-dark-green) 100%);
            border-bottom-color: var(--psau-gold);
        }

        .section-header.completed {
            background: linear-gradient(135deg, #455a64 0%, #37474f 100%);
            border-bottom-color: var(--psau-green);
        }

        .section-body {
            padding: 1.75rem;
        }

        .table-container {
            overflow-x: auto;
        }

        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .custom-table thead {
            background: linear-gradient(135deg, var(--psau-light-bg) 0%, #f1f3f4 100%);
        }

        .custom-table thead th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--psau-green);
            border-bottom: 2px solid var(--psau-green);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .custom-table tbody tr {
            border-bottom: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }

        .custom-table tbody tr:hover {
            background-color: #f5f5f5;
            transform: scale(1.01);
        }

        .custom-table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }

        .status-badge {
            display: inline-block;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 2px solid var(--psau-gold);
        }

        .status-progress {
            background: #d1ecf1;
            color: #0c5460;
            border: 2px solid #17a2b8;
        }

        .btn-action {
            padding: 0.5rem 1.25rem;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-start {
            background: linear-gradient(135deg, #1976d2 0%, #1565c0 100%);
            color: white;
            box-shadow: 0 2px 4px rgba(25, 118, 210, 0.3);
        }

        .btn-start:hover {
            background: linear-gradient(135deg, #1565c0 0%, #0d47a1 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(25, 118, 210, 0.4);
        }

        .btn-complete {
            background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-dark-green) 100%);
            color: white;
            box-shadow: 0 2px 4px rgba(27, 94, 32, 0.3);
        }

        .btn-complete:hover {
            background: linear-gradient(135deg, var(--psau-dark-green) 0%, var(--psau-green) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(27, 94, 32, 0.4);
        }

        .task-id {
            background: var(--psau-light-bg);
            color: var(--psau-green);
            padding: 0.3rem 0.75rem;
            border-radius: 6px;
            font-weight: 700;
            font-family: 'Courier New', monospace;
        }

        .room-info {
            font-weight: 600;
            color: var(--psau-green);
        }

        .log-history {
            background: var(--psau-light-bg);
            padding: 1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            color: #555;
            white-space: pre-line;
            border-left: 4px solid var(--psau-green);
            line-height: 1.6;
            max-height: 200px;
            overflow-y: auto;
        }

        .log-history::-webkit-scrollbar {
            width: 6px;
        }

        .log-history::-webkit-scrollbar-track {
            background: #e0e0e0;
            border-radius: 3px;
        }

        .log-history::-webkit-scrollbar-thumb {
            background: var(--psau-green);
            border-radius: 3px;
        }

        .date-completed {
            color: #666;
            font-size: 0.9rem;
            font-style: italic;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #757575;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .stats-bar {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--psau-green);
        }

        .user-info {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid var(--psau-gold);
        }

        .user-details {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-dark-green) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .user-name {
            font-weight: 600;
            color: var(--psau-green);
            font-size: 1.1rem;
        }

        .user-role {
            color: #666;
            font-size: 0.9rem;
        }

        .logout-btn {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logout-btn:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <div class="page-header">
                <h2>My Maintenance Work Log</h2>
            </div>
            
            <!-- User Info Section -->
            <div class="user-info">
                <div class="user-details">
                    <div class="user-avatar">
                        <%= Session["FullName"] != null ? Session["FullName"].ToString().Substring(0, 1).ToUpper() : "H" %>
                    </div>
                    <div>
                        <div class="user-name">
                            <%= Session["FullName"] != null ? Session["FullName"].ToString() : "Housekeeper" %>
                        </div>
                        <div class="user-role">Housekeeping Staff</div>
                    </div>
                </div>
                <a href="../Account/Login.aspx" class="logout-btn" onclick="clearSession()">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
            
            <!-- Active Tasks Section -->
            <div class="section-card">
                <div class="section-header pending">
                    <span style="font-size: 1.5rem;">📋</span>
                    <h4>My Assigned Tasks - To Do</h4>
                </div>
                <div class="section-body">
                    <div class="table-container">
                        <asp:GridView ID="gvMyTasks" runat="server" AutoGenerateColumns="False" 
                            CssClass="custom-table" OnRowCommand="gvMyTasks_RowCommand"
                            GridLines="None">
                            <Columns>
                                <asp:TemplateField HeaderText="Task ID">
                                    <ItemTemplate>
                                        <span class="task-id">#<%# Eval("MaintenanceID") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>
                                        <div class="room-info">
                                            🏠 <%# Eval("RoomName") %>
                                        </div>
                                        <div style="color: #666; font-size: 0.9rem;">
                                            Room: <%# Eval("RoomNumber") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="IssueDescription" HeaderText="Task Description" 
                                    ItemStyle-Width="30%" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='status-badge <%# Eval("Status").ToString() == "Pending" ? "status-pending" : "status-progress" %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Button ID="btnStart" runat="server" Text="▶️ Start Work" 
                                            CommandName="StartWork" 
                                            CommandArgument='<%# Eval("MaintenanceID") %>' 
                                            CssClass="btn-action btn-start" 
                                            Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                                        <asp:Button ID="btnFinish" runat="server" Text="✅ Mark Complete" 
                                            CommandName="FinishWork" 
                                            CommandArgument='<%# Eval("MaintenanceID") %>' 
                                            CssClass="btn-action btn-complete" 
                                            Visible='<%# Eval("Status").ToString() == "In Progress" %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-state">
                                    <div class="empty-state-icon">✨</div>
                                    <h5>No pending tasks</h5>
                                    <p>You're all caught up! Great work!</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- Completed Tasks Section -->
            <div class="section-card">
                <div class="section-header completed">
                    <span style="font-size: 1.5rem;">✅</span>
                    <h4>Completed Tasks - History</h4>
                </div>
                <div class="section-body">
                    <div class="table-container">
                        <asp:GridView ID="gvCompletedTasks" runat="server" AutoGenerateColumns="False" 
                            CssClass="custom-table" GridLines="None">
                            <Columns>
                                <asp:TemplateField HeaderText="Location">
                                    <ItemTemplate>
                                        <div class="room-info">
                                            🏠 <%# Eval("RoomName") %>
                                        </div>
                                        <div style="color: #666; font-size: 0.9rem;">
                                            Room: <%# Eval("RoomNumber") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="IssueDescription" HeaderText="Task Description" 
                                    ItemStyle-Width="25%" />
                                <asp:TemplateField HeaderText="Completed">
                                    <ItemTemplate>
                                        <div class="date-completed">
                                            📅 <%# Eval("DateCompleted", "{0:MMM dd, yyyy}") %>
                                        </div>
                                        <div class="date-completed">
                                            🕐 <%# Eval("DateCompleted", "{0:HH:mm}") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Full Activity Log">
                                    <ItemTemplate>
                                        <div class="log-history"><%# Eval("Notes") %></div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="empty-state">
                                    <div class="empty-state-icon">📝</div>
                                    <h5>No completed tasks yet</h5>
                                    <p>Your completed work will appear here</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </form>
    
    <script>
        function clearSession() {
            // Clear session storage and local storage
            sessionStorage.clear();
            localStorage.clear();
            
            // Optional: Clear any specific cookies if needed
            document.cookie.split(";").forEach(function(c) { 
                document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
            });
        }
    </script>
</body>
</html>
