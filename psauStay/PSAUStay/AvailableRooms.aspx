<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AvailableRooms.aspx.cs" Inherits="PSAUStay.AvailableRooms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0 fw-bold">
            <i class="bi bi-door-closed-fill me-2" style="color: var(--psau-gold);"></i>
            Real-Time Room Availability
        </h3>
        <div class="text-muted small">
            <i class="bi bi-clock me-1"></i>
            Auto-refreshes every 7 seconds
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <!-- Available Rooms Section -->
    <div class="card shadow-sm mb-4">
        <div class="card-header py-3" style="background: linear-gradient(135deg, var(--psau-green), var(--psau-green-dark)); color: white;">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-grid-3x3-gap me-2"></i>
                Available Rooms
            </h5>
        </div>
        <div class="card-body">
            <!-- Filter Panel -->
            <div class="row mb-4">
                <div class="col-md-6 mx-auto">
                    <label class="form-label fw-semibold" style="color: var(--psau-green);">
                        <i class="bi bi-funnel me-1"></i>
                        Filter by Room Type
                    </label>
                    <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-select form-select-lg" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    </asp:DropDownList>
                </div>
            </div>

            <!-- Rooms Grid -->
            <asp:UpdatePanel ID="updRooms" runat="server">
                <ContentTemplate>
                    <div class="table-responsive">
                        <asp:GridView ID="gvRooms" runat="server" CssClass="table table-hover align-middle" AutoGenerateColumns="False" GridLines="None">
                            <HeaderStyle CssClass="table-light" />
                            <RowStyle CssClass="border-bottom" />
                            <Columns>
                                <asp:BoundField DataField="RoomName" HeaderText="Room Name" />
                                <asp:BoundField DataField="RoomType" HeaderText="Room Type" />
                                <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                                <asp:BoundField DataField="RoomNumbers" HeaderText="Available Units" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("Status").ToString() == "Available" ? "" : "bg-danger" %> rounded-pill px-3 py-2' <%# Eval("Status").ToString() == "Available" ? "style=\"background-color: var(--psau-green);\"" : "" %>>
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

    <!-- Auto Refresh Timer -->
    <asp:Timer ID="tmRefresh" runat="server" Interval="7000" OnTick="tmRefresh_Tick" />

    <!-- Scheduled Checkouts Section -->
    <div class="card shadow-sm">
        <div class="card-header py-3" style="background-color: var(--psau-gold); color: var(--psau-green);">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-calendar-check me-2"></i>
                Scheduled Checkouts
            </h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <label class="form-label fw-semibold" style="color: var(--psau-gold);">
                        <i class="bi bi-calendar-event me-1"></i>
                        Select Checkout Date
                    </label>
                    <asp:UpdatePanel ID="updCalendar" runat="server">
                        <ContentTemplate>
                            <div class="border rounded p-3 bg-light">
                                <asp:Calendar ID="calCheckoutDate" runat="server" 
                                    OnSelectionChanged="calCheckoutDate_SelectionChanged" 
                                    OnDayRender="calCheckoutDate_DayRender"
                                    CssClass="w-100"
                                    DayHeaderStyle-BackColor="#f8f9fa"
                                    DayHeaderStyle-Font-Bold="true"
                                    DayHeaderStyle-ForeColor="#6c757d"
                                    OtherMonthDayStyle-BackColor="#e9ecef"
                                    OtherMonthDayStyle-ForeColor="#adb5bd"
                                    SelectedDayStyle-BackColor="#0b6623"
                                    SelectedDayStyle-ForeColor="white"
                                    SelectedDayStyle-Font-Bold="true"
                                    TitleStyle-BackColor="#0b6623"
                                    TitleStyle-ForeColor="white"
                                    TitleStyle-Font-Bold="true"
                                    WeekendDayStyle-BackColor="#f8f9fa"
                                    TodayDayStyle-BackColor="#f1c40f"
                                    TodayDayStyle-ForeColor="#0b6623"
                                    TodayDayStyle-Font-Bold="true">
                                </asp:Calendar>
                                <div class="mt-2 text-center">
                                    <asp:Label ID="lblSelectedCheckoutDate" runat="server" Text="" CssClass="badge px-3 py-2" style="background-color: var(--psau-green); color: white;"></asp:Label>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="col-lg-8">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="mb-0 fw-semibold">
                            <i class="bi bi-people-fill me-2" style="color: var(--psau-green);"></i>
                            Guests Checking Out
                        </h6>
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            Click any date in calendar to view details
                        </small>
                    </div>
                    
                    <!-- Booked Rooms Grid -->
                    <asp:UpdatePanel ID="updBookedRooms" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView ID="gvBookedRooms" runat="server" CssClass="table table-hover align-middle" AutoGenerateColumns="False" GridLines="None" EmptyDataText="No checkouts scheduled for selected date.">
                                    <HeaderStyle CssClass="table-light" />
                                    <RowStyle CssClass="border-bottom" />
                                    <Columns>
                                        <asp:BoundField DataField="GuestName" HeaderText="Guest Name" />
                                        <asp:BoundField DataField="RoomNumber" HeaderText="Room" />
                                        <asp:BoundField DataField="RoomType" HeaderText="Type" />
                                        <asp:BoundField DataField="CheckInDate" HeaderText="Check-In" DataFormatString="{0:MM/dd/yyyy}" />
                                        <asp:BoundField DataField="CheckOutDate" HeaderText="Check-Out" DataFormatString="{0:MM/dd/yyyy}" />
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

    <!-- Legend -->
    <div class="alert d-flex align-items-center" style="background-color: #f8f9fa; border: 1px solid #dee2e6; color: var(--psau-green);" role="alert">
        <i class="bi bi-info-circle-fill me-2"></i>
        <div class="small">
            <strong>Calendar Legend:</strong> 
            <span class="badge me-2" style="background-color: #e9ecef; color: #495057;">Normal Day</span>
            <span class="badge me-2" style="background-color: var(--psau-gold); color: var(--psau-green);">● Has Checkout</span>
            <span class="badge" style="background-color: var(--psau-green); color: white;">Selected Date</span>
        </div>
    </div>
</asp:Content>