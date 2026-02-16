<%@ Page Title="Add Maintenance" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AddMaintenanceRequest.aspx.cs" Inherits="PSAUStay.Admin.AddMaintenance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
<style>
    .maintenance-container {
        max-width: 900px;
        margin: 2rem auto;
        padding: 0 1rem;
    }
    
    .maintenance-card {
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
        overflow: hidden;
        border: 1px solid #e8f5e9;
    }
    
    .maintenance-header {
        background: linear-gradient(135deg, #1b5e20 0%, #2e7d32 100%);
        color: white;
        padding: 1.75rem 2rem;
        border-bottom: 3px solid #f9a825;
    }
    
    .maintenance-header h4 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .maintenance-header h4::before {
        content: "🔧";
        font-size: 1.75rem;
    }
    
    .maintenance-body {
        padding: 2.5rem 2rem;
        background: #fafafa;
    }
    
    .form-group-custom {
        margin-bottom: 1.75rem;
        background: white;
        padding: 1.25rem;
        border-radius: 8px;
        border-left: 4px solid #2e7d32;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04);
    }
    
    .form-label-custom {
        font-weight: 600;
        color: #1b5e20;
        margin-bottom: 0.5rem;
        display: block;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .form-select-custom,
    .form-control-custom {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 2px solid #e0e0e0;
        border-radius: 6px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background-color: #ffffff;
    }
    
    .form-select-custom:focus,
    .form-control-custom:focus {
        outline: none;
        border-color: #2e7d32;
        box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
    }
    
    .form-control-custom[type="text"] {
        min-height: 100px;
    }
    
    .btn-submit-custom {
        background: linear-gradient(135deg, #2e7d32 0%, #388e3c 100%);
        color: white;
        border: none;
        padding: 1rem 2.5rem;
        font-size: 1.1rem;
        font-weight: 600;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(46, 125, 50, 0.3);
        margin-top: 1rem;
    }
    
    .btn-submit-custom:hover {
        background: linear-gradient(135deg, #1b5e20 0%, #2e7d32 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(46, 125, 50, 0.4);
    }
    
    .btn-submit-custom:active {
        transform: translateY(0);
    }
    
    .priority-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 4px;
        font-size: 0.85rem;
        font-weight: 600;
        margin-left: 0.5rem;
    }
    
    .info-text {
        color: #616161;
        font-size: 0.9rem;
        margin-top: 0.5rem;
        font-style: italic;
    }
</style>

<div class="maintenance-container">
    <div class="maintenance-card">
        <div class="maintenance-header">
            <h4>Create Maintenance Request</h4>
        </div>
        <div class="maintenance-body">
            <div class="form-group-custom">
                <label class="form-label-custom">📍 Select Room Category</label>
                <asp:DropDownList ID="ddlRooms" runat="server" CssClass="form-select-custom" 
                    DataTextField="RoomName" DataValueField="RoomID" 
                    AutoPostBack="true" OnSelectedIndexChanged="ddlRooms_SelectedIndexChanged">
                </asp:DropDownList>
                <div class="info-text">Choose the room category to view available units</div>
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">🚪 Select Available Unit</label>
                <asp:DropDownList ID="ddlUnits" runat="server" CssClass="form-select-custom" 
                    DataTextField="RoomNumber" DataValueField="UnitID">
                </asp:DropDownList>
                <div class="info-text">Only units marked as 'Available' will appear here</div>
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">📝 Issue Description</label>
                <asp:TextBox ID="txtIssue" runat="server" TextMode="MultiLine" 
                    CssClass="form-control-custom" Rows="4" 
                    placeholder="Describe the maintenance issue in detail..."></asp:TextBox>
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">⚠️ Priority Level</label>
                <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select-custom">
                    <asp:ListItem>Normal</asp:ListItem>
                    <asp:ListItem>Urgent</asp:ListItem>
                </asp:DropDownList>
                <div class="info-text">Set priority based on urgency and impact</div>
            </div>

            <div class="form-group-custom">
                <label class="form-label-custom">👤 Assign to Housekeeper</label>
                <asp:DropDownList ID="ddlHousekeepers" runat="server" CssClass="form-select-custom" 
                    DataTextField="FullName" DataValueField="FullName">
                </asp:DropDownList>
                <div class="info-text">Select the staff member to handle this maintenance task</div>
            </div>

            <div style="text-align: center;">
                <asp:Button ID="btnSubmit" runat="server" Text="💾 Save and Assign Task" 
                    CssClass="btn-submit-custom" OnClick="btnSubmit_Click" />
            </div>
        </div>
    </div>
</div>
</asp:Content>
