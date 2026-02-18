<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="Maintenance.aspx.cs" Inherits="PSAUStay.Admin.Maintenance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <%-- Green Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-tools me-2" style="color: var(--psau-gold);"></i>
                        Maintenance Requests
                    </h2>
                    <p class="mb-0 text-white-50">Manage and track maintenance requests and repairs</p>
                </div>
                <div class="col-auto">
                    <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold me-2">
                        <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                    </a>
                    <asp:Button ID="btnAdd" runat="server" Text="Add New Request" 
                        CssClass="btn btn-light shadow-sm fw-bold" OnClick="btnAdd_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Breadcrumb Navigation -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-4">
            <li class="breadcrumb-item">
                <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" style="color: var(--psau-green); text-decoration: none;">Dashboard</a>
            </li>
            <li class="breadcrumb-item">
                <a href="#" style="color: var(--psau-green); text-decoration: none;">Housekeeping</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Maintenance</li>
        </ol>
    </nav>

    <div class="row mb-4 g-3">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-gradient" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 text-black">
                            <i class="bi bi-list-ul me-2"></i>Active Maintenance Requests
                        </h5>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                        <asp:GridView ID="gvMaintenance" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None" UseAccessibleHeader="true"
                            style="min-width: 550px;">
                            <Columns>
                                <asp:BoundField DataField="MaintenanceID" HeaderText="ID" ItemStyle-CssClass="fw-bold" />
                                <asp:BoundField DataField="RoomName" HeaderText="Room" />
                                <asp:BoundField DataField="IssueDescription" HeaderText="Issue Description" />
                                <asp:BoundField DataField="RequestorName" HeaderText="Requested By" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class="badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %> rounded-pill">
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="AssignedTo" HeaderText="Assigned To" />
                                <asp:BoundField DataField="DateRequested" HeaderText="Date Requested" DataFormatString="{0:MMM dd, yyyy}" />
                            </Columns>
                            <HeaderStyle CssClass="bg-light text-muted small text-uppercase fw-bold" />
                            <RowStyle CssClass="align-middle" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 mb-3">
                <div class="card-header bg-light">
                    <h6 class="mb-0">
                        <i class="bi bi-info-circle-fill me-2 text-info"></i>
                        Quick Stats
                    </h6>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Pending Requests</span>
                        <span class="badge bg-warning rounded-pill"><%= PendingCount %></span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">In Progress</span>
                        <span class="badge bg-primary rounded-pill"><%= InProgressCount %></span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Completed</span>
                        <span class="badge bg-success rounded-pill"><%= CompletedTodayCount %></span>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-light">
                    <h6 class="mb-0">
                        <i class="bi bi-lightbulb-fill me-2 text-warning"></i>
                        Maintenance Tips
                    </h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0 small">
                        <li class="mb-2">Regular maintenance prevents costly repairs</li>
                        <li class="mb-2">Document all issues for future reference</li>
                        <li class="mb-2">Prioritize safety-related maintenance</li>
                        <li class="mb-0">Schedule periodic room inspections</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <style>
        .card {
            border-radius: 12px;
            transition: transform 0.2s ease-in-out;
        }
        
        .card:hover {
            transform: translateY(-2px);
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            border-top: none;
            font-weight: 600;
            color: var(--psau-green);
            background-color: #f8f9fa;
        }
        
        .table td {
            vertical-align: middle;
            border-color: #e9ecef;
        }
        
        .table tbody tr:hover {
            background-color: rgba(11, 102, 35, 0.05);
        }
        
        .badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
            font-weight: 500;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: var(--psau-green);
        }
        
        .btn-light:hover {
            background-color: var(--psau-gold) !important;
            border-color: var(--psau-gold) !important;
            color: var(--psau-green) !important;
        }
        
        /* Additional styling fixes */
        .table-responsive {
            border-radius: 0 0 12px 12px;
            overflow-x: auto;
        }
        
        .card-header {
            border-bottom: 1px solid rgba(0,0,0,0.125);
        }
    </style>
</asp:Content>
