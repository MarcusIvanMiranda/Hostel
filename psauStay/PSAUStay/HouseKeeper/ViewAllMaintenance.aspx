<%@ Page Title="View All Maintenance" Language="C#" MasterPageFile="~/HouseKeeper/HouseKeeperControl.master" AutoEventWireup="true" CodeBehind="ViewAllMaintenance.aspx.cs" Inherits="PSAUStay.HouseKeeper.ViewAllMaintenance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HouseKeeperMainContent" runat="server">
<style>
    .maintenance-container {
        max-width: 1200px;
        margin: 2rem auto;
        padding: 0 1rem;
    }
    
    .maintenance-header {
        background: linear-gradient(135deg, #2e7d32 0%, #388e3c 100%);
        color: white;
        padding: 1.75rem 2rem;
        border-radius: 12px 12px 0 0;
        margin-bottom: 0;
    }
    
    .maintenance-header h4 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .filter-section {
        background: #f8f9fa;
        padding: 1.5rem;
        border-radius: 8px;
        margin-bottom: 1.5rem;
        border-left: 4px solid #2e7d32;
    }
    
    .filter-group {
        display: flex;
        gap: 1rem;
        align-items: end;
        flex-wrap: wrap;
    }
    
    .filter-item {
        flex: 1;
        min-width: 150px;
    }
    
    .filter-label {
        font-weight: 600;
        color: #1b5e20;
        margin-bottom: 0.5rem;
        display: block;
        font-size: 0.9rem;
    }
    
    .filter-control {
        width: 100%;
        padding: 0.5rem;
        border: 2px solid #e0e0e0;
        border-radius: 6px;
        font-size: 0.9rem;
    }
    
    .btn-filter {
        background: linear-gradient(135deg, #2e7d32 0%, #388e3c 100%);
        color: white;
        border: none;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.3s ease;
        position: relative;
        padding-left: 2.5rem;
    }
    
    .btn-filter:before {
        content: "\f52a";
        font-family: "bootstrap-icons";
        position: absolute;
        left: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
    }
    
    .btn-filter:hover {
        background: linear-gradient(135deg, #1b5e20 0%, #2e7d32 100%);
        transform: translateY(-1px);
    }
    
    .maintenance-grid {
        background: white;
        border-radius: 0 0 12px 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }
    
    .status-pending {
        background-color: #fff3cd;
        color: #856404;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }
    
    .status-completed {
        background-color: #d4edda;
        color: #155724;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }
    
    .status-in-progress {
        background-color: #cce7ff;
        color: #004085;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }
    
    .priority-urgent {
        background-color: #f8d7da;
        color: #721c24;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }
    
    .priority-normal {
        background-color: #e2e3e5;
        color: #383d41;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }
    
    .table-custom {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
        min-width: 650px;
    }
    
    .table-custom th {
        background: #f8f9fa;
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        color: #1b5e20;
        border-bottom: 2px solid #2e7d32;
        font-size: 0.9rem;
    }
    
    .table-custom td {
        padding: 0.75rem 1rem;
        border-bottom: 1px solid #e0e0e0;
        vertical-align: middle;
        font-size: 0.9rem;
    }
    
    .table-custom tr:hover {
        background-color: #f8f9fa;
    }
    
    .no-data {
        text-align: center;
        padding: 3rem;
        color: #6c757d;
        font-style: italic;
    }

    @media (max-width: 767.98px) {
        .filter-item {
            min-width: 100%;
        }
        .maintenance-container {
            margin: 1rem auto;
        }
    }
</style>

<div class="maintenance-container">
<%-- Modern Green Header --%>
<div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
    <div class="card-body p-4">
        <div class="row align-items-center">
            <div class="col">
                <h2 class="mb-1 fw-bold text-white">
                    <i class="bi bi-tools me-2" style="color: var(--psau-gold);"></i>
                   View All Maintenance
                </h2>
                <p class="mb-0 text-white-50">View All Maintenance Assigned</p>
            </div>
            <div class="col-auto">
                <a href="HouseKeeperDashboard.aspx" class="btn btn-light shadow-sm fw-bold">
                    <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>
        </div>
    </div>
</div>
    
    <div class="filter-section">
        <div class="filter-group">
            <div class="filter-item">
                <label class="filter-label"><i class="bi bi-calendar-date me-1"></i> Date Range</label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="filter-control" TextMode="Date" placeholder="Start Date"></asp:TextBox>
            </div>
            <div class="filter-item">
                <label class="filter-label">To</label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="filter-control" TextMode="Date" placeholder="End Date"></asp:TextBox>
            </div>
            <div class="filter-item">
                <label class="filter-label"><i class="bi bi-funnel me-1"></i> Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-control">
                    <asp:ListItem Value="">All Status</asp:ListItem>
                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    <asp:ListItem Value="In Progress">In Progress</asp:ListItem>
                    <asp:ListItem Value="Completed">Completed</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <label class="filter-label"><i class="bi bi-exclamation-triangle me-1"></i> Priority</label>
                <asp:DropDownList ID="ddlPriority" runat="server" CssClass="filter-control">
                    <asp:ListItem Value="">All Priority</asp:ListItem>
                    <asp:ListItem Value="Normal">Normal</asp:ListItem>
                    <asp:ListItem Value="Urgent">Urgent</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <label class="filter-label"><i class="bi bi-person me-1"></i> Assigned To</label>
                <asp:DropDownList ID="ddlAssignedTo" runat="server" CssClass="filter-control">
                    <asp:ListItem Value="">All Staff</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn-filter" OnClick="btnFilter_Click" />
            </div>
        </div>
    </div>
    
    <div class="maintenance-grid">
        <asp:GridView ID="gvMaintenance" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" AllowPaging="True" PageSize="20"
            OnPageIndexChanging="gvMaintenance_PageIndexChanging"
            EmptyDataText="No maintenance requests found matching your criteria.">
            <Columns>
                <asp:BoundField DataField="MaintenanceID" HeaderText="ID" ReadOnly="True" />
                <asp:BoundField DataField="DateRequested" HeaderText="Date Requested" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="RoomCategory" HeaderText="Room Category" />
                <asp:BoundField DataField="RoomNumber" HeaderText="Room Number" />
                <asp:BoundField DataField="AssignedTo" HeaderText="Assigned To" />
                <asp:BoundField DataField="IssueDescription" HeaderText="Issue Description" />
                <asp:TemplateField HeaderText="Priority">
                    <ItemTemplate>
                        <span class='<%# Eval("Priority").ToString() == "Urgent" ? "priority-urgent" : "priority-normal" %>'>
                            <%# Eval("Priority") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
            </Columns>
            <PagerStyle CssClass="pagination" HorizontalAlign="Center" />
        </asp:GridView>
    </div>
</div>
</asp:Content>
    