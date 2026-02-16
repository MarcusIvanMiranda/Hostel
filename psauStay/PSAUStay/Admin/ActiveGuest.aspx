<%@ Page Title="Active Guests" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ActiveGuest.aspx.cs" Inherits="PSAUStay.Admin.ActiveGuest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <div class="container-fluid py-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-people-fill me-2" style="color: var(--psau-gold);"></i>
                            Active Guests
                        </h2>
                        <p class="mb-0 text-white-50">Real-time In-House Guests (<%= DateTime.Now.ToString("MMM dd, yyyy") %>)</p>
                    </div>
                    <div class="col-auto">
                        <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold me-2">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                        <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-light shadow-sm fw-bold" OnClick="btnRefresh_Click">
                            <i class="bi bi-arrow-clockwise me-2"></i> Refresh
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <%-- Search Filter --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row align-items-end g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-uppercase text-muted">Search Active Guest</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0" placeholder="Search name or room..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-success px-4 fw-bold" OnClick="btnSearch_Click" />
                        <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary px-3" OnClick="btnClear_Click">Clear</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <%-- Grid Section --%>
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvActiveGuests" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" GridLines="None" 
                    EmptyDataText="No guests are currently checked in matching your search.">
                    <Columns>
                        <asp:TemplateField HeaderText="Guest Name">
                            <ItemTemplate>
                                <div class="fw-bold"><%# Eval("FullName") %></div>
                                <small class="badge bg-light text-dark border fw-normal"><%# Eval("Source") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Contact" HeaderText="Contact Number" />
                        <asp:BoundField DataField="RoomName" HeaderText="Room" />
                        
                        <asp:TemplateField HeaderText="Stay Period">
                            <ItemTemplate>
                                <i class="bi bi-calendar-check text-muted me-1"></i>
                                <%# Eval("CheckInDate", "{0:MMM dd}") %> - <%# Eval("CheckOutDate", "{0:MMM dd, yyyy}") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# GetStatusBadgeHtml(Eval("OriginalStatus").ToString()) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="bg-light text-muted small text-uppercase" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>