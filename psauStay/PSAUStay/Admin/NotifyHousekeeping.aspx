<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="NotifyHousekeeping.aspx.cs" Inherits="PSAUStay.Admin.NotifyHousekeeping" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <style>
        .modern-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .modern-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        /* Vertical line colors for stats */
        .modern-card.pending { border-left: 5px solid #ffc107 !important; }
        .modern-card.completed { border-left: 5px solid #28a745 !important; }
        .modern-card.maintenance { border-left: 5px solid #dc3545 !important; }
        .modern-card.deep-cleaning { border-left: 5px solid #17a2b8 !important; }
        .modern-card.regular-cleaning { border-left: 5px solid #007bff !important; }
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #0b6623;
            box-shadow: 0 0 0 0.2rem rgba(11, 102, 35, 0.25);
        }
        .btn-modern {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
        }
        .btn-primary-modern {
            background: linear-gradient(135deg, #0b6623 0%, #0a5a1f 100%);
            color: white;
        }
        .btn-primary-modern:hover {
            background: linear-gradient(135deg, #0a5a1f 0%, #094e1b 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(11, 102, 35, 0.3);
        }
        .btn-secondary-modern {
            background: #6c757d;
            color: white;
        }
        .btn-secondary-modern:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        .page-header {
            background: linear-gradient(135deg, #0b6623 0%, #0a5a1f 100%);
            color: white;
            padding: 2rem 0;
            margin: -1.5rem -1.5rem 2rem -1.5rem;
            border-radius: 0 0 20px 20px;
        }
        .form-label-modern {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        .table-modern {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .table-modern thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        .badge-modern {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 500;
        }
        .stats-card {
            background: linear-gradient(135deg, #0b6623 0%, #0a5a1f 100%);
            color: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(11, 102, 35, 0.3);
        }
        .notification-item {
            border-left: 4px solid #0b6623;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }
        .notification-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        @media (max-width: 768px) {
            .page-header {
                margin: -1rem -1rem 1.5rem -1rem;
                padding: 1.5rem 0;
            }
            .stats-card {
                padding: 1rem;
            }
        }
    </style>

    <div class="page-header">
        <div class="container-fluid">
            <div class="row align-items-center g-3">
                <div class="col-md-8">
                    <h2 class="mb-2">
                        <i class="bi bi-bell-fill me-3"></i>Notify Housekeeping
                    </h2>
                    <p class="mb-0 opacity-75">Send notifications to housekeeping staff for room maintenance and cleaning tasks</p>
                </div>
                <div class="col-md-4 col-12 text-md-end">
                    <div class="stats-card">
                        <h4 class="mb-1" id="todayCount">0</h4>
                        <small>Today's Notifications</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats Section -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card modern-card completed text-center">
                <div class="card-body">
                    <i class="bi bi-check-circle text-success fs-2 mb-2"></i>
                    <h5 class="card-title">Completed</h5>
                    <h3 class="text-success" id="completedCount">0</h3>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card modern-card pending text-center">
                <div class="card-body">
                    <i class="bi bi-hourglass-split text-warning fs-2 mb-2"></i>
                    <h5 class="card-title">Pending</h5>
                    <h3 class="text-warning" id="pendingCount">0</h3>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card modern-card deep-cleaning text-center">
                <div class="card-body">
                    <i class="bi bi-search text-info fs-2 mb-2"></i>
                    <h5 class="card-title">Deep Cleaning</h5>
                    <h3 class="text-info" id="deepCleaningCount">0</h3>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card modern-card regular-cleaning text-center">
                <div class="card-body">
                    <i class="bi bi-brush text-primary fs-2 mb-2"></i>
                    <h5 class="card-title">Regular Cleaning</h5>
                    <h3 class="text-primary" id="regularCleaningCount">0</h3>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <!-- Notification Form -->
        <div class="col-lg-5 mb-4">
            <div class="card modern-card h-100">
                <div class="card-body p-4">
                    <h5 class="card-title mb-4">
                        <i class="bi bi-send-fill text-primary me-2"></i>
                        Create New Notification
                    </h5>
                    
                    <div class="mb-3">
                        <label for="ddlRooms" class="form-label-modern">
                            <i class="bi bi-door-open me-2"></i>Room Category
                        </label>
                        <asp:DropDownList ID="ddlRooms" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlRooms_SelectedIndexChanged">
                            <asp:ListItem Value="">-- Select Room Category --</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="mb-3">
                        <label for="ddlRoomNo" class="form-label-modern">
                            <i class="bi bi-hash me-2"></i>Room Number
                        </label>
                        <asp:DropDownList ID="ddlRoomNo" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Select Room Category First --</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="mb-3">
                        <label for="ddlTaskType" class="form-label-modern">
                            <i class="bi bi-tags me-2"></i>Task Type
                        </label>
                        <asp:DropDownList ID="ddlTaskType" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Select Task Type --</asp:ListItem>
                            <asp:ListItem Value="Regular">🧹 Regular Cleaning</asp:ListItem>
                            <asp:ListItem Value="Deep">🔍 Deep Cleaning</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="mb-4">
                        <label for="txtIssue" class="form-label-modern">
                            <i class="bi bi-chat-text me-2"></i>Issue / Task Details
                        </label>
                        <asp:TextBox ID="txtIssue" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Describe issue or task in detail..."></asp:TextBox>
                    </div>

                    <div class="d-grid gap-2">
                        <asp:Button ID="btnSend" runat="server" Text="📤 Send Notification" CssClass="btn btn-modern btn-primary-modern" OnClick="btnSend_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="🔄 Clear Form" CssClass="btn btn-modern btn-secondary-modern" OnClick="btnClear_Click" />
                    </div>

                    <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 fw-bold d-block"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Recent Notifications -->
        <div class="col-lg-7 mb-4">
            <div class="card modern-card h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-clock-history text-primary me-2"></i>
                            Recent Notifications
                        </h5>
                        <span class="badge bg-primary" id="notificationCount">0</span>
                    </div>
                    
                    <!-- Notification Cards Container -->
                    <div class="notification-cards-container" style="height: 450px; overflow-y: auto; overflow-x: hidden;">
                        <asp:Repeater ID="rptNotificationCards" runat="server">
                            <ItemTemplate>
                                <div class="notification-card mb-3 p-3 border rounded" style="background: #f8f9fa; border-left: 4px solid #0b6623;">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-light text-dark p-2 me-2">
                                                    <%# Eval("RoomDisplay") %>
                                                </span>
                                                <small class="text-muted">
                                                    <%# Eval("DateCreated", "{0:MMM dd, HH:mm}") %>
                                                </small>
                                            </div>
                                            <div class="mb-2">
                                                <span style="white-space: normal; word-wrap: break-word;">
                                                    <%# Eval("Issue") %>
                                                </span>
                                            </div>
                                            <div>
                                                <span class="badge <%# Eval("Status").ToString() == "Pending" ? "bg-warning" : "bg-success" %>">
                                                    <%# Eval("Status") %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <!-- Empty state -->
                        <div id="emptyState" runat="server" class="text-center py-5" style="display: none;">
                            <i class="bi bi-inbox text-muted fs-1 mb-3"></i>
                            <p class="text-muted">No recent notifications found.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
