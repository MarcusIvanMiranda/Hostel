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

        /* Statistics Cards */
        .stat-card { 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            border: none !important; 
            border-radius: 16px; 
            background: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important; 
        }
        
        .stat-card.completed-today { border-left: 5px solid #0b6623 !important; }
        .stat-card.pending { border-left: 5px solid #f1c40f !important; }
        
        .stat-card .card-body { 
            padding: 1rem 1.25rem;
        }
        
        .stat-card h6 { 
            letter-spacing: 0.5px; 
            color: #6c757d !important;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .stat-card h2 { 
            font-size: 2rem; 
            font-weight: 800; 
            margin-bottom: 0;
            line-height: 1;
        }

        /* Modern Table Styles */
        .modern-table {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            border: none;
            margin-bottom: 1.5rem;
        }

        .modern-table .card-header {
            background: linear-gradient(135deg, var(--psau-green), var(--psau-green-dark));
            color: white;
            border: none;
            padding: 1.25rem 1.5rem;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 0.5px;
        }

        .modern-table .table {
            margin: 0;
        }

        .modern-table .table thead th {
            background: #f8f9fa;
            color: var(--psau-green);
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border: none;
            padding: 0.75rem 1rem;
        }

        .modern-table .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .modern-table .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .modern-table .table tbody td {
            padding: 0.75rem 1rem;
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
            padding: 0.4rem 0.85rem;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
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
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.82rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-modern-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-modern-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            color: white;
        }

        .btn-modern-danger {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
        }

        .btn-modern-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
            color: white;
        }

        .table-icon {
            font-size: 1.1rem;
            opacity: 0.8;
        }

        /* Table responsive wrapper */
        .table-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .table-scroll table {
            min-width: 500px;
        }

        /* Responsive stat cards - 2x2 on mobile */
        @media (max-width: 767.98px) {
            .stat-card h2 {
                font-size: 1.8rem;
            }
            .stat-card h6 {
                font-size: 0.72rem;
            }
            .stat-card .card-body {
                padding: 0.85rem 1rem;
            }
            .modern-table .table thead th,
            .modern-table .table tbody td {
                padding: 0.6rem 0.75rem;
                font-size: 0.85rem;
            }
            .btn-modern {
                padding: 0.35rem 0.75rem;
                font-size: 0.75rem;
            }
        }
    </style>

    <div class="container-fluid py-4 px-3">
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

        <%-- Stats Cards - 2 per row on mobile, 4 per row on desktop --%>
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card stat-card completed-today shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Completed</h6>
                        <h2 class="mb-0 fw-bold" style="color: #0b6623;" id="completedCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card pending shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Pending</h6>
                        <h2 class="mb-0 fw-bold" style="color: #f1c40f;" id="pendingCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card shadow-sm h-100" style="border-left: 5px solid #87CEEB !important;">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Deep Cleaning</h6>
                        <h2 class="mb-0 fw-bold" style="color: #87CEEB;" id="deepCleaningCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card shadow-sm h-100" style="border-left: 5px solid #4682B4 !important;">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Regular Cleaning</h6>
                        <h2 class="mb-0 fw-bold" style="color: #4682B4;" id="regularCleaningCount">0</h2>
                    </div>
                </div>
            </div>
        </div>

        <%-- Notifications Table --%>
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
                <div class="table-scroll">
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
                                    <div class="d-flex gap-2 flex-wrap">
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

        <%-- History Table --%>
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
                <div class="table-scroll">
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
</asp:Content>
