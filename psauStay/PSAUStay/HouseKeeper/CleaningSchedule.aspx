<%@ Page Title="Cleaning Schedule" Language="C#" MasterPageFile="~/HouseKeeper/HouseKeeperControl.master" AutoEventWireup="true" CodeBehind="CleaningSchedule.aspx.cs" Inherits="PSAUStay.HouseKeeper.CleaningSchedule" %>

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

        .stats-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            background: white;
        }

        .stats-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }

        .stats-card.pending-cleaning {
            border-left: 5px solid #f1c40f !important;
        }

        .stats-card.completed-today {
            border-left: 5px solid #28a745 !important;
        }

        .stats-card.urgent {
            border-left: 5px solid #dc3545 !important;
        }

        .modern-table {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            border: none;
        }

        .modern-table .card-header {
            background: linear-gradient(135deg, var(--psau-green), var(--psau-green-dark));
            color: white;
            border: none;
            padding: 1.5rem;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 0.5px;
        }

        .modern-table .table {
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
            min-width: 550px;
        }

        .modern-table .table thead th {
            background: #f8f9fa;
            color: var(--psau-green);
            font-weight: 700;
            font-size: 0.9rem;
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

        .modern-badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .badge-pending {
            background: linear-gradient(135deg, var(--psau-gold), #e67e00);
            color: white;
        }

        .badge-urgent {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
        }

        .btn-modern {
            padding: 0.5rem 1.25rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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

        .table-icon {
            font-size: 1.1rem;
            opacity: 0.8;
        }

        .room-urgent {
            background-color: #fff5f5 !important;
            border-left: 4px solid #dc3545 !important;
        }

        .room-normal {
            background-color: #fffbf0 !important;
            border-left: 4px solid #f1c40f !important;
        }

        /* Table horizontal scroll */
        .table-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        @media (max-width: 767.98px) {
            .stats-card h2 { font-size: 1.8rem; }
            .stats-card h6 { font-size: 0.72rem; }
            .modern-table .table thead th,
            .modern-table .table tbody td {
                padding: 0.6rem 0.75rem;
                font-size: 0.85rem;
            }
            .btn-modern {
                padding: 0.4rem 1rem;
                font-size: 0.75rem;
            }
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <asp:HiddenField ID="hfSelectedID" runat="server" />
    <asp:Button ID="btnHiddenConfirm" runat="server" OnClick="btnMarkDone_Click" Style="display:none;" />

    <div class="container-fluid py-4">
        <%-- Modern Green Header --%>
        <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-1 fw-bold text-white">
                            <i class="bi bi-stars me-2" style="color: var(--psau-gold);"></i>
                            Cleaning Schedule
                        </h2>
                        <p class="mb-0 text-white-50">Manage room sanitation and maintenance tasks (<%= DateTime.Now.ToString("MMM dd, yyyy") %>)</p>
                    </div>
                    <div class="col-auto">
                        <a href="<%= ResolveUrl("~/HouseKeeper/HouseKeeperDashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%-- Statistics Cards - 2 per row on mobile --%>
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card stats-card pending-cleaning shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Pending Cleaning</h6>
                        <h2 class="mb-0 fw-bold" style="color: #f1c40f;" id="pendingCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stats-card completed-today shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Completed Today</h6>
                        <h2 class="mb-0 fw-bold" style="color: #28a745;" id="completedCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stats-card urgent shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Urgent (&gt;2hrs)</h6>
                        <h2 class="mb-0 fw-bold" style="color: #dc3545;" id="urgentCount">0</h2>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stats-card shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-muted small text-uppercase fw-bold">Avg. Clean Time</h6>
                        <h2 class="mb-0 fw-bold" style="color: #0b6623;" id="avgTime">0m</h2>
                    </div>
                </div>
            </div>
        </div>

        <%-- Cleaning Schedule Table --%>
        <div class="card modern-table mb-4">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="bi bi-grid-3x3-gap me-2"></i>
                        Rooms To Be Cleaned
                    </h5>
                    <span class="badge bg-light text-dark" id="roomCount">0</span>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-scroll">
                    <asp:GridView ID="gvCleaningSchedule" runat="server" AutoGenerateColumns="False" 
                        CssClass="table mb-0" GridLines="None" 
                        EmptyDataText="No rooms currently pending cleaning."
                        OnRowDataBound="gvCleaningSchedule_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="RoomName" HeaderText="Room Category" />
                            <asp:BoundField DataField="RoomNumber" HeaderText="Room No." />
                            <asp:BoundField DataField="GuestName" HeaderText="Last Guest" />
                            <asp:BoundField DataField="CheckOutDate" HeaderText="Check Out Date" DataFormatString="{0:MMM dd, yyyy HH:mm}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="modern-badge badge-pending">
                                        <i class="bi bi-clock-fill me-1"></i>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <button type="button" class="btn btn-modern btn-modern-success fw-bold" style="min-width: 110px;" 
                                            data-id='<%# Eval("UnitID") %>' 
                                            data-room='<%# Eval("RoomName") + " - " + Eval("RoomNumber") %>'
                                            onclick="markCleaningDone(this)">
                                        <i class="bi bi-check-circle me-1"></i>Done
                                    </button>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function markCleaningDone(button) {
            const unitId = button.getAttribute('data-id');
            const roomInfo = button.getAttribute('data-room');

            Swal.fire({
                title: '<h4 class="fw-bold mb-0 text-success">Confirm Cleaning Complete</h4>',
                html: `
                    <div class="text-start p-3">
                        <div class="mb-3 p-3 bg-light rounded border-start border-4 border-success">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Room</small>
                            <span class="fs-5 fw-bold text-dark">${roomInfo}</span>
                        </div>
                        <div class="mb-3 p-3 bg-info rounded border-start border-4 border-info">
                            <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">Action</small>
                            <span class="fs-6 fw-bold text-dark">Mark as Available</span>
                        </div>
                        <div class="alert alert-warning small">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            This will mark the room as available for new bookings.
                        </div>
                    </div>`,
                showCancelButton: true,
                confirmButtonColor: '#198754',
                confirmButtonText: 'Mark Done',
                cancelButtonText: 'Cancel',
                width: '450px'
            }).then((result) => {
                if (result.isConfirmed) {
                    document.getElementById('<%= hfSelectedID.ClientID %>').value = unitId;
                    document.getElementById('<%= btnHiddenConfirm.ClientID %>').click();
                }
            });
        }
    </script>
</asp:Content>
