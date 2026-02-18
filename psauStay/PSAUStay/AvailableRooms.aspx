<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AvailableRooms.aspx.cs" Inherits="PSAUStay.AvailableRooms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <%-- Modern Green Header (Matching Manage Rooms) --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-door-closed-fill me-2" style="color: var(--psau-gold);"></i>
                        Real-Time Room Availability
                    </h2>
                    <p class="mb-0 text-white-50">
                        <i class="bi bi-clock me-1"></i> Auto-refreshes every 7 seconds
                    </p>
                </div>
                <div class="col-auto">
                    <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                        <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-dark">
                        <i class="bi bi-funnel-fill me-1" style="color: var(--psau-green);"></i> Filter by Room Type
                    </label>
                    <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-select border-2" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    </asp:DropDownList>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-0">
            <asp:UpdatePanel ID="updRooms" runat="server">
                <ContentTemplate>
                    <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                        <asp:GridView ID="gvRooms" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="False" GridLines="None" style="min-width: 500px;">
                            <HeaderStyle CssClass="table-light border-bottom" />
                            <Columns>
                                <asp:BoundField DataField="RoomName" HeaderText="Room Name" ItemStyle-CssClass="fw-bold" />
                                <asp:BoundField DataField="RoomType" HeaderText="Room Type" />
                                <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                                <asp:TemplateField HeaderText="Available Units">
                                    <ItemTemplate>
                                        <span class="text-muted"><%# Eval("RoomNumbers") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge rounded-pill px-3 py-2 <%# Eval("Status").ToString() == "Available" ? "" : "bg-danger" %>' 
                                              <%# Eval("Status").ToString() == "Available" ? "style=\"background-color: var(--psau-green);\"" : "" %>>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="tmRefresh" EventName="Tick" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>

    <asp:Timer ID="tmRefresh" runat="server" Interval="7000" OnTick="tmRefresh_Tick" />

    <div class="row g-3">
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white py-3 border-0">
                    <h5 class="mb-0 fw-bold" style="color: var(--psau-green);">
                        <i class="bi bi-calendar-event-fill me-2"></i>Select Checkout Date
                    </h5>
                </div>
                <div class="card-body">
                    <asp:UpdatePanel ID="updCalendar" runat="server">
                        <ContentTemplate>
                            <div class="calendar-wrapper">
                                <asp:Calendar ID="calCheckoutDate" runat="server" 
                                    OnSelectionChanged="calCheckoutDate_SelectionChanged" 
                                    OnDayRender="calCheckoutDate_DayRender"
                                    CssClass="w-100 border-0"
                                    DayHeaderStyle-CssClass="text-muted fw-bold small py-2"
                                    TitleStyle-BackColor="White"
                                    TitleStyle-ForeColor="Black"
                                    TitleStyle-Font-Bold="true"
                                    SelectedDayStyle-BackColor="#0b6623"
                                    SelectedDayStyle-ForeColor="white"
                                    TodayDayStyle-BackColor="#f1c40f"
                                    TodayDayStyle-ForeColor="#0b6623"
                                    WeekendDayStyle-BackColor="#f8f9fa">
                                </asp:Calendar>
                                <div class="mt-3 text-center">
                                    <asp:Label ID="lblSelectedCheckoutDate" runat="server" CssClass="badge px-4 py-2 w-100" style="background-color: var(--psau-green); font-size: 0.9rem;"></asp:Label>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>

        <div class="col-lg-8 mb-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-0">
                    <h5 class="mb-0 fw-bold" style="color: var(--psau-green);">
                        <i class="bi bi-people-fill me-2"></i>Guests Checking Out
                    </h5>
                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Live View</small>
                </div>
                <div class="card-body p-0">
                    <asp:UpdatePanel ID="updBookedRooms" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive" style="-webkit-overflow-scrolling: touch;">
                                <asp:GridView ID="gvBookedRooms" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="False" GridLines="None" EmptyDataText="<div class='p-4 text-center text-muted'>No checkouts scheduled for this date.</div>" style="min-width: 450px;">
                                    <HeaderStyle CssClass="table-light" />
                                    <Columns>
                                        <asp:BoundField DataField="GuestName" HeaderText="Guest Name" ItemStyle-CssClass="fw-bold" />
                                        <asp:TemplateField HeaderText="Room">
                                            <ItemTemplate>
                                                <span class="badge bg-light text-dark border"><%# Eval("RoomNumber") %></span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="RoomType" HeaderText="Type" />
                                        <asp:BoundField DataField="CheckOutDate" HeaderText="Check-Out" DataFormatString="{0:MMM dd, yyyy}" />
                                        <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body py-2">
            <div class="d-flex align-items-center small gap-3">
                <span class="fw-bold text-muted text-uppercase">Legend:</span>
                <span><i class="bi bi-circle-fill me-1 text-light border rounded-circle"></i> Normal</span>
                <span><i class="bi bi-circle-fill me-1" style="color: var(--psau-gold);"></i> Has Checkout</span>
                <span><i class="bi bi-circle-fill me-1" style="color: var(--psau-green);"></i> Selected</span>
            </div>
        </div>
    </div>

    <style>
        /* Custom calendar styling to make it cleaner */
        .calendar-wrapper .aspNetCalendar { border-collapse: separate !important; border-spacing: 2px !important; }
        .calendar-wrapper td { padding: 5px !important; text-align: center !important; }
        .calendar-wrapper .aspNetCalendar a { text-decoration: none; color: inherit; display: block; padding: 5px; border-radius: 4px; }
        .calendar-wrapper .aspNetCalendar a:hover { background-color: #eee; }
    </style>
</asp:Content>
