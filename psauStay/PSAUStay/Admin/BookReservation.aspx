<%@ Page Title="Book Reservation" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="BookReservation.aspx.cs" Inherits="PSAUStay.Admin.BookReservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <div class="container-fluid py-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-calendar-check-fill me-2" style="color: var(--psau-gold);"></i>
                            Book Reservation
                        </h2>
                        <p class="mb-0 text-white-50">View all upcoming bookings that have not started yet</p>
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

        <%-- Stats Cards --%>
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-4">
                <div class="card border-0 shadow-sm h-100" style="border-left: 5px solid #0b6623 !important;">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Total Upcoming</h6>
                        <h2 class="mb-0 fw-bold" style="color: #0b6623;"><asp:Label ID="lblTotalUpcoming" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4">
                <div class="card border-0 shadow-sm h-100" style="border-left: 5px solid #f1c40f !important;">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">This Week</h6>
                        <h2 class="mb-0 fw-bold" style="color: #f1c40f;"><asp:Label ID="lblThisWeek" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4">
                <div class="card border-0 shadow-sm h-100" style="border-left: 5px solid #3498db !important;">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Next 7 Days</h6>
                        <h2 class="mb-0 fw-bold" style="color: #3498db;"><asp:Label ID="lblNext7Days" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
        </div>

        <%-- Filter Section --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3 col-6">
                        <label class="form-label fw-bold">Status Filter</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" CssClass="form-select" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Status" Value="All"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                            <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                            <asp:ListItem Text="Waitlisted" Value="Waitlisted"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 col-6">
                        <label class="form-label fw-bold">Date Range</label>
                        <asp:DropDownList ID="ddlDateRange" runat="server" AutoPostBack="true" CssClass="form-select" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                            <asp:ListItem Text="All Upcoming" Value="All"></asp:ListItem>
                            <asp:ListItem Text="Today" Value="Today"></asp:ListItem>
                            <asp:ListItem Text="This Week" Value="ThisWeek"></asp:ListItem>
                            <asp:ListItem Text="Next 7 Days" Value="Next7Days"></asp:ListItem>
                            <asp:ListItem Text="Next 30 Days" Value="Next30Days"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 col-6">
                        <label class="form-label fw-bold">Room Type</label>
                        <asp:DropDownList ID="ddlRoomFilter" runat="server" AutoPostBack="true" CssClass="form-select" OnSelectedIndexChanged="ddlRoomFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Rooms" Value="All"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="form-check form-switch mt-4">
                            <input class="form-check-input" type="checkbox" id="chkShowOnlyPending" runat="server" autopostback="true" onserverchange="chkShowOnlyPending_ServerChange">
                            <label class="form-check-label fw-bold" for="chkShowOnlyPending">
                                Show Only Pending
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Upcoming Reservations Grid --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-0">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-success">
                        <i class="bi bi-calendar-check-fill me-2"></i>Upcoming Bookings
                    </h5>
                    <small class="text-muted">Check-in date is today or in the future</small>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                    <dx:ASPxGridView ID="gvUpcomingReservations" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="CombinedID" Width="100%" Theme="MaterialCompact" 
                        OnDataBinding="gvUpcomingReservations_DataBinding"
                        OnHtmlDataCellPrepared="gvUpcomingReservations_HtmlDataCellPrepared"
                        OnRowCommand="gvUpcomingReservations_RowCommand">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" CellStyle-CssClass="fw-bold" />
                            <dx:GridViewDataTextColumn FieldName="Email" Caption="Email" />
                            <dx:GridViewDataTextColumn FieldName="Contact" Caption="Contact Number" />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Room" />
                            <dx:GridViewDataDateColumn FieldName="CheckInDate" Caption="Check-In" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataDateColumn FieldName="CheckOutDate" Caption="Check-Out" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataTextColumn FieldName="DaysUntilCheckIn" Caption="Days Until Check-In" Width="120px">
                                <DataItemTemplate>
                                    <span class="badge bg-info text-white">
                                        <%# Eval("DaysUntilCheckIn") %> days
                                    </span>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Status" Caption="Status">
                                <DataItemTemplate>
                                    <%# GetStatusBadgeHtml(Eval("Status").ToString()) %>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="TotalPrice" Caption="Total Price" HeaderStyle-HorizontalAlign="Left" CellStyle-HorizontalAlign="Left" />
                            <dx:GridViewDataTextColumn FieldName="PaymentStatus" Caption="Payment Status" />
                            <dx:GridViewDataColumn Caption="Actions" Width="120px">
                                <DataItemTemplate>
                                    <div class="d-flex gap-1">
                                        <a href='ViewReservation.aspx?RequestID=<%# Eval("CombinedID") %>' class="btn btn-sm btn-outline-success" title="View Details">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <asp:LinkButton ID="btnQuickApprove" runat="server" CssClass="btn btn-sm btn-success" CommandName="QuickApprove" CommandArgument='<%# Eval("CombinedID") %>' title="Quick Approve" Visible='<%# Eval("Status").ToString() == "Pending" %>'>
                                            <i class="bi bi-check-circle"></i>
                                        </asp:LinkButton>
                                    </div>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                        </Columns>
                        <SettingsPager PageSize="15" />
                        <Settings ShowFilterRow="false" ShowGroupPanel="false" />
                    </dx:ASPxGridView>
                </div>
                
                <div class="text-center py-3" id="divNoRecords" runat="server" visible="false">
                    <i class="bi bi-calendar-x" style="font-size: 3rem; color: #ccc;"></i>
                    <p class="text-muted mt-3">No upcoming reservations found.</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
