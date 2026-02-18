<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PSAUStay.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stat-card { transition: transform 0.2s ease, box-shadow 0.2s ease; border: none !important; border-radius: 12px; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important; }
        .chart-card { border-radius: 15px; border: none; background: #fff; padding: 20px; }
        
        /* PSAU Color Vertical Bars */
        .stat-card.total-volume { border-left: 5px solid #0b6623 !important; }
        .stat-card.pending-stays { border-left: 5px solid #f1c40f !important; }
        .stat-card.approved-stays { border-left: 5px solid #0b6623 !important; }
        .stat-card.rejected-stays { border-left: 5px solid #dc3545 !important; }
        
        /* Additional styling for better visual appeal */
        .stat-card .card-body { padding: 1.5rem; }
        .stat-card h6 { letter-spacing: 0.5px; }
        .stat-card h2 { font-size: 2.5rem; font-weight: 700; }

        /* Responsive table wrapper */
        .grid-responsive-wrapper { width: 100%; overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .grid-responsive-wrapper table { min-width: 600px; }

        /* Responsive breakpoints */
        @media (max-width: 767.98px) {
            .stat-card h2 { font-size: 1.8rem; }
            .chart-card { padding: 12px; }
            #trendChart, #statusChart { max-height: 220px !important; }
            .container-fluid { padding-left: 10px; padding-right: 10px; }
            .card-header h5 { font-size: 1rem; }
            .alert.d-flex { flex-direction: column; gap: 6px; text-align: center; }
        }

        @media (max-width: 575.98px) {
            .stat-card h2 { font-size: 1.5rem; }
            .stat-card .card-body { padding: 1rem; }
        }

        /* DevExpress grid override for responsiveness */
        .dxgv { width: 100% !important; }
    </style>

    <div class="container-fluid py-4">
        <%-- Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-grid-1x2-fill me-2" style="color: var(--psau-gold);"></i>
                            Stays Analytics
                        </h2>
                        <p class="mb-0 text-white-50">Real-time performance and booking overview</p>
                    </div>
                    <div class="col-auto">
                        <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-light shadow-sm fw-bold" OnClick="btnRefresh_Click">
                            <i class="bi bi-arrow-clockwise me-2"></i> Refresh Dashboard
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <%-- Analytics Scorecards --%>
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card stat-card total-volume shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Total Volume</h6>
                        <h2 class="mb-0 fw-bold" style="color: #0b6623;"><asp:Label ID="lblTotalRequests" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card pending-stays shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Pending Stays</h6>
                        <h2 class="mb-0 fw-bold" style="color: #f1c40f;"><asp:Label ID="lblPendingRequests" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card approved-stays shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Approved Stays</h6>
                        <h2 class="mb-0 fw-bold" style="color: #0b6623;"><asp:Label ID="lblApprovedRequests" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card rejected-stays shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Rejected Stays</h6>
                        <h2 class="mb-0 fw-bold" style="color: #dc3545;"><asp:Label ID="lblRejectedRequests" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
        </div>

        <%-- Revenue Summary --%>
        <div class="alert alert-light border-0 shadow-sm d-flex justify-content-between align-items-center mb-4">
            <span class="fw-bold text-muted text-uppercase small">Estimated Lifetime Revenue</span>
            <h4 class="mb-0 fw-bold text-dark">₱<asp:Label ID="lblTotalRevenue" runat="server" Text="0.00"></asp:Label></h4>
        </div>

        <%-- Charts Section --%>
        <div class="row mb-4 g-3">
            <div class="col-12 col-lg-8">
                <div class="card chart-card shadow-sm">
                    <h6 class="mb-3 fw-bold">Monthly Booking Volume</h6>
                    <canvas id="trendChart" style="max-height: 300px;"></canvas>
                </div>
            </div>
            <div class="col-12 col-lg-4">
                <div class="card chart-card shadow-sm">
                    <h6 class="mb-3 fw-bold">Status Distribution</h6>
                    <canvas id="statusChart" style="max-height: 300px;"></canvas>
                </div>
            </div>
        </div>

        <%-- Grid Section - Approved Stays --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3 border-0">
                <h5 class="mb-0 fw-bold text-success">✅ Approved Stays</h5>
            </div>
            <div class="card-body p-0">
                <div class="grid-responsive-wrapper">
                    <dx:ASPxGridView ID="gvApprovedStays" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="CombinedID" Width="100%" Theme="MaterialCompact" 
                        OnDataBinding="gvApprovedStays_DataBinding"
                        OnHtmlDataCellPrepared="gvApprovedStays_HtmlDataCellPrepared">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" />
                            <dx:GridViewDataTextColumn FieldName="Email" Caption="Email" />
                            <dx:GridViewDataTextColumn FieldName="Contact" Caption="Contact Number" />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Room" />
                            <dx:GridViewDataDateColumn FieldName="CheckInDate" Caption="Check-In" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataDateColumn FieldName="CheckOutDate" Caption="Check-Out" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataTextColumn FieldName="TotalPrice" Caption="Total Price" HeaderStyle-HorizontalAlign="Left" CellStyle-HorizontalAlign="Left" />
                            <dx:GridViewDataTextColumn FieldName="Downpayment" Caption="Downpayment (50%)" HeaderStyle-HorizontalAlign="Left" CellStyle-HorizontalAlign="Left" />
                            <dx:GridViewDataTextColumn FieldName="PaymentStatus" Caption="Payment Status" />
                        </Columns>
                        <SettingsPager PageSize="10" />
                    </dx:ASPxGridView>
                </div>
            </div>
        </div>

        <%-- Grid Section - Rejected Stays --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3 border-0">
                <h5 class="mb-0 fw-bold text-danger">❌ Rejected Stays</h5>
            </div>
            <div class="card-body p-0">
                <div class="grid-responsive-wrapper">
                    <dx:ASPxGridView ID="gvRejectedStays" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="CombinedID" Width="100%" Theme="MaterialCompact" 
                        OnDataBinding="gvRejectedStays_DataBinding">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" />
                            <dx:GridViewDataTextColumn FieldName="Email" Caption="Email" />
                            <dx:GridViewDataTextColumn FieldName="Contact" Caption="Contact Number" />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Room" />
                            <dx:GridViewDataDateColumn FieldName="CheckInDate" Caption="Check-In" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataDateColumn FieldName="CheckOutDate" Caption="Check-Out" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                            <dx:GridViewDataDateColumn FieldName="DateRequested" Caption="Rejected Date" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy" />
                        </Columns>
                        <SettingsPager PageSize="10" />
                    </dx:ASPxGridView>
                </div>
            </div>
        </div>

        <%-- Grid Section - Recent Checkouts --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3 border-0">
                <h5 class="mb-0 fw-bold text-success">✅ Recent Checkouts</h5>
            </div>
            <div class="card-body p-0">
                <div class="grid-responsive-wrapper">
                    <dx:ASPxGridView ID="gvRecentCheckouts" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="CombinedID" Width="100%" Theme="MaterialCompact" 
                        OnDataBinding="gvRecentCheckouts_DataBinding">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FullName" Caption="Guest Name" />
                            <dx:GridViewDataTextColumn FieldName="RoomNumber" Caption="Room No." />
                            <dx:GridViewDataTextColumn FieldName="RoomName" Caption="Unit Name" CellStyle-Font-Bold="true" />
                            <dx:GridViewDataTextColumn FieldName="TotalBill" Caption="Total Collected">
                                <PropertiesTextEdit DisplayFormatString="PHP {0:N2}" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="CheckOutDate" Caption="Checkout Date" PropertiesDateEdit-DisplayFormatString="MMM dd, yyyy HH:mm" />
                        </Columns>
                        <SettingsPager PageSize="10" />
                    </dx:ASPxGridView>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const ctxStatus = document.getElementById('statusChart').getContext('2d');
            new Chart(ctxStatus, {
                type: 'doughnut',
                data: {
                    labels: ['Pending', 'Approved', 'Rejected'],
                    datasets: [{
                        data: [
                            document.getElementById('<%= lblPendingRequests.ClientID %>').innerText,
                            document.getElementById('<%= lblApprovedRequests.ClientID %>').innerText,
                            document.getElementById('<%= lblRejectedRequests.ClientID %>').innerText
                        ],
                        backgroundColor: ['#ffc107', '#157347', '#dc3545'],
                        borderWidth: 0
                    }]
                },
                options: { cutout: '75%', plugins: { legend: { position: 'bottom' } } }
            });

            const ctxTrend = document.getElementById('trendChart').getContext('2d');
            new Chart(ctxTrend, {
                type: 'bar',
                data: {
                    labels: <%= ChartLabelsJson %>,
                    datasets: [{
                        label: 'Requests',
                        data: <%= ChartDataJson %>,
                        backgroundColor: '#157347',
                        borderRadius: 5
                    }]
                },
                options: {
                    scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } },
                    plugins: { legend: { display: false } }
                }
            });
        });
    </script>
</asp:Content>
