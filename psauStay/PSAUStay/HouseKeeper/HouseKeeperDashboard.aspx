<%@ Page Title="Housekeeper Dashboard" Language="C#" MasterPageFile="~/HouseKeeper/HouseKeeperControl.master" AutoEventWireup="true" CodeBehind="HouseKeeperDashboard.aspx.cs" Inherits="PSAUStay.HouseKeeper.HouseKeeperDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HouseKeeperMainContent" runat="server">
    <style>
        :root {
            --psau-green: #0b6623;
            --psau-green-dark: #074217;
            --psau-gold: #f1c40f;
            --psau-gold-hover: #d4ac0d;
            --success-light: #d4edda;
            --warning-light: #fff3cd;
            --danger-light: #f8d7da;
            --info-light: #d1ecf1;
        }

        /* Statistics Cards - Modern Admin Theme */
        .stat-card { 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            border: none !important; 
            border-radius: 16px; 
            background: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 1.5rem !important;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: none;
        }
        
        .stat-card:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important; 
        }
        
        .stat-card.completed-today { 
            border-left: 5px solid #0b6623 !important; 
        }
        .stat-card.pending { 
            border-left: 5px solid #f1c40f !important; 
        }
        .stat-card.maintenance { 
            border-left: 5px solid #dc3545 !important; 
        }
        
        .stat-card .card-body { 
            padding: 1rem; 
            position: relative;
            z-index: 1;
        }
        
        .stat-card h6 { 
            letter-spacing: 0.8px; 
            color: #6c757d !important;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        
        .stat-card h2 { 
            font-size: 2.5rem; 
            font-weight: 800; 
            color: var(--psau-green) !important;
            margin-bottom: 0;
            line-height: 1;
        }
        
        .stats-container {
            max-width: 100%;
            margin: 0 auto;
        }

        /* Modern Table Styles */
        .modern-table {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            border: none;
        }

        .modern-table .card-header {
            background: linear-gradient(135deg, var(--psau-green), var(--psau-green-dark));
            color: white;
            border: none;
            padding: 1.5rem;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 0.5px;
        }

        .modern-table .table {
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .modern-table .table thead th {
            background: #f8f9fa;
            color: var(--psau-green);
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border: none;
            padding: 0.75rem 1rem;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .modern-table .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .modern-table .table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .modern-table .table tbody td {
            padding: 0.75rem 0.5rem;
            vertical-align: middle;
            border: none;
            color: #495057;
            font-size: 0.95rem;
        }

        .modern-table .table tbody tr:last-child {
            border-bottom: none;
        }

        /* Modern Badge Styles */
        .modern-badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .badge-pending {
            background: linear-gradient(135deg, var(--psau-gold), #e67e00);
            color: white;
        }

        .badge-completed {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .badge-maintenance {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
        }

        /* Modern Button Styles */
        .btn-modern {
            padding: 0.5rem 1.25rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            transition: all 0.3s ease;
            margin-right: 0.5rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-modern-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-modern-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-modern-danger {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
        }

        .btn-modern-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        /* Icon styling */
        .table-icon {
            font-size: 1.1rem;
            opacity: 0.8;
        }

        /* Section Headers */
        .section-header {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 1rem 1.5rem;
            border-radius: 12px 12px 0 0;
            border-bottom: 2px solid var(--psau-green);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .stat-card h2 {
                font-size: 2rem;
            }
            
            .modern-table .table thead th,
            .modern-table .table tbody td {
                padding: 0.75rem;
                font-size: 0.85rem;
            }
            
            .btn-modern {
                padding: 0.4rem 1rem;
                font-size: 0.75rem;
            }
        }

        /* Remove scrollbar and optimize layout - Higher specificity */
        html body, body {
            overflow-x: hidden !important;
            overflow-y: auto !important;
            scrollbar-width: none !important;
            -ms-overflow-style: none !important;
        }

        html body::-webkit-scrollbar,
        body::-webkit-scrollbar {
            display: none !important;
            width: 0 !important;
            height: 0 !important;
        }

        /* Override master page content styles */
        .content {
            min-height: auto !important;
            height: auto !important;
            padding-bottom: 2rem !important;
            max-height: none !important;
        }

        /* Make stats responsive to table width */
        .stats-container {
            max-width: 100% !important;
            margin: 0 auto !important;
            width: 100% !important;
        }

        .stat-card {
            height: 100% !important;
            min-height: 120px !important;
            max-height: none !important;
        }

        /* Match table width exactly */
        .modern-table {
            margin-bottom: 1rem !important;
            width: 100% !important;
        }

        .table-responsive {
            max-height: 60vh !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
            width: 100% !important;
        }

        /* Ensure stats and table have same width */
        .container-fluid {
            overflow: hidden !important;
            max-width: 100% !important;
            padding: 0 !important;
            width: 100% !important;
        }

        .row {
            margin: 0 !important;
            overflow: hidden !important;
            width: 100% !important;
        }

        /* Stats row to match table width */
        .stats-container .row {
            display: flex;
            flex-wrap: wrap;
            width: 100%;
            margin: 0;
        }

        .stats-container .row > div {
            flex: 1;
            min-width: 0;
        }
    </style>
<div class="container-fluid py-4">
    <%-- Modern Green Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-speedometer2 me-2" style="color: var(--psau-gold);"></i>
                        Housekeeper Dashboard
                    </h2>
                    <p class="mb-0 text-white-50">Welcome back! Here is your daily overview for <%= DateTime.Now.ToString("MMM dd, yyyy") %></p>
                </div>
 
            </div>
        </div>
    </div>
    </div>

        <div class="row mb-4">
            <div class="col-12">
                <p class="text-muted mb-4">Welcome back! Here's your cleaning overview for today.</p>
            </div>
        </div>

        <div class="row mb-4">
            <div class="stats-container">
                <div class="row">
                    <div class="col-lg-2 col-md-4 mb-3">
                        <div class="card stat-card completed-today shadow-sm h-100">
                            <div class="card-body">
                                <h6 class="text-muted small text-uppercase fw-bold">Completed</h6>
                                <h2 class="mb-0 fw-bold" style="color: #0b6623;" id="completedCount">0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 mb-3">
                        <div class="card stat-card pending shadow-sm h-100">
                            <div class="card-body">
                                <h6 class="text-muted small text-uppercase fw-bold">Pending</h6>
                                <h2 class="mb-0 fw-bold" style="color: #f1c40f;" id="pendingCount">0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 mb-3">
                        <div class="card stat-card shadow-sm h-100" style="border-left: 5px solid #87CEEB;">
                            <div class="card-body">
                                <h6 class="text-muted small text-uppercase fw-bold">Deep Cleaning</h6>
                                <h2 class="mb-0 fw-bold" style="color: #87CEEB;" id="deepCleaningCount">0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 mb-3">
                        <div class="card stat-card shadow-sm h-100" style="border-left: 5px solid #4682B4;">
                            <div class="card-body">
                                <h6 class="text-muted small text-uppercase fw-bold">Regular Cleaning</h6>
                                <h2 class="mb-0 fw-bold" style="color: #4682B4;" id="regularCleaningCount">0</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12 mb-4">
                <div class="modern-table">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-bell-fill me-2"></i>
                                Housekeeping Notifications
                            </h5>
                            <span class="badge bg-light text-dark" id="notificationBadge" runat="server">0</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gvNotifications" runat="server" AutoGenerateColumns="False" 
                                CssClass="table mb-0" GridLines="None" EmptyDataText="No pending notifications."
                                OnRowCommand="gvNotifications_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="RoomDisplay" HeaderText="Room" />
                                    <asp:TemplateField HeaderText="Issue">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-exclamation-triangle table-icon text-warning me-2"></i>
                                                <span><%# Eval("Issue") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class="modern-badge badge-<%# Eval("StatusClass") %>">
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="DateCreated" HeaderText="Received" DataFormatString="{0:MMM dd, yyyy HH:mm}" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <div class="d-flex gap-2">
                                                <asp:LinkButton ID="btnComplete" runat="server" CssClass="btn-modern btn-modern-success" 
                                                    CommandName="Complete" CommandArgument='<%# Eval("NotificationID") %>'>
                                                    <i class="bi bi-check-circle"></i> Complete
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-modern btn-modern-danger" 
                                                    CommandName="DeleteNotification" CommandArgument='<%# Eval("NotificationID") %>'
                                                    OnClientClick="return confirm('Are you sure you want to delete this notification?');">
                                                    <i class="bi bi-trash"></i> Delete
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12 mb-4">
                <div class="modern-table">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-clock-history me-2"></i>
                                Housekeeping History
                            </h5>
                            <span class="badge bg-light text-dark" id="historyBadge" runat="server">0</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" 
                                CssClass="table mb-0" GridLines="None" EmptyDataText="No history records found.">
                                <Columns>
                                    <asp:BoundField DataField="RoomDisplay" HeaderText="Room" />
                                    <asp:TemplateField HeaderText="Issue">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-check-circle table-icon text-success me-2"></i>
                                                <span><%# Eval("Issue") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class="modern-badge badge-completed">
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CompletedDate" HeaderText="Completed" DataFormatString="{0:MMM dd, yyyy HH:mm}" />
                                    <asp:BoundField DataField="CompletedBy" HeaderText="Completed By" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>