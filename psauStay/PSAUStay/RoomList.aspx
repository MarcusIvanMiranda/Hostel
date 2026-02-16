<%@ Page Title="Manage Rooms" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="RoomList.aspx.cs" Inherits="PSAUStay.Admin.RoomList" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid py-4">
        <div class="page-header mb-4">
            <h3 class="page-title mb-3">
                <i class="bi bi-door-open me-2"></i>View Our Rooms
            </h3>
         </div>

        <div class="table-responsive">
            <asp:Label ID="lblMsg" runat="server" CssClass="alert-message mb-3" Visible="false"></asp:Label>
            <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-hover rooms-table"
                OnRowCommand="gvRooms_RowCommand" OnRowDataBound="gvRooms_RowDataBound">
                <HeaderStyle CssClass="table-header" />
                <RowStyle CssClass="table-row" />
                <AlternatingRowStyle CssClass="table-row-alt" />
                <Columns>
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <img src='<%# Eval("Image1") %>' alt="Room" 
                                 class="room-image-thumb" 
                                 data-image='<%# Eval("Image1") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RoomName" HeaderText="Room Name">
                        <ItemStyle CssClass="fw-bold text-dark" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Type">
                        <ItemTemplate>
                            <span class="badge bg-success-subtle text-success px-3 py-2">
                                <%# Eval("RoomType") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Capacity">
                        <ItemTemplate>
                            <span class="capacity-badge">
                                <i class="bi bi-people-fill me-1"></i><%# Eval("Capacity") %> pax
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate>
                            <span class="price-text">₱<%# Eval("Price", "{0:N2}") %></span>
                            <div class="small text-muted">per night</div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Available Units">
                        <ItemTemplate>
                            <%# string.IsNullOrEmpty(Eval("AvailableRoomNumbers").ToString()) ? 
                                "<span class=\"badge bg-secondary px-3 py-2\">None Available</span>" : 
                                "<span class=\"badge bg-success px-3 py-2\">" + Eval("AvailableRoomNumbers") + "</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unavailable Units">
                        <ItemTemplate>
                            <%# string.IsNullOrEmpty(Eval("UnavailableRoomNumbers").ToString()) ? 
                                "<span class=\"badge bg-light text-dark border px-3 py-2\">All Available</span>" : 
                                "<span class=\"badge bg-danger px-3 py-2\">" + Eval("UnavailableRoomNumbers") + "</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-psau-green text-white">
                    <h5 class="modal-title" id="imageModalLabel">
                        <i class="bi bi-image me-2"></i>Room Image
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center p-4">
                    <img id="modalImage" src="#" alt="Room" class="modal-room-image" />
                </div>
            </div>
        </div>
    </div>

    <style>
        :root {
            --psau-green: #1a5f3f;
            --psau-gold: #f5a623;
        }

        .page-header {
            background: linear-gradient(135deg, var(--psau-green) 0%, #2d7a5a 100%);
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(26, 95, 63, 0.15);
        }

        .page-title {
            color: white;
            font-weight: 700;
            margin: 0;
            font-size: 1.75rem;
        }

        .alert-message {
            display: inline-block;
            padding: 10px 20px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 8px;
            color: var(--psau-green);
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .table-responsive {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .rooms-table {
            margin-bottom: 0;
            border: none;
        }

        .rooms-table .table-header {
            background: var(--psau-green);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            border: none;
            padding: 18px 15px;
        }

        .rooms-table .table-row {
            background-color: #ffffff;
            transition: all 0.2s ease;
            border-bottom: 1px solid #e9ecef;
        }

        .rooms-table .table-row-alt {
            background-color: #f8f9fa;
            transition: all 0.2s ease;
            border-bottom: 1px solid #e9ecef;
        }

        .rooms-table tbody tr:hover {
            background-color: #f0f7f4 !important;
            transform: scale(1.01);
            box-shadow: 0 3px 10px rgba(26, 95, 63, 0.1);
        }

        .rooms-table td {
            vertical-align: middle;
            padding: 20px 15px;
            border-color: #e9ecef;
        }

        .room-image-thumb {
            width: 90px;
            height: 70px;
            object-fit: cover;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 3px solid #e9ecef;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .room-image-thumb:hover {
            transform: scale(1.15);
            border-color: var(--psau-gold);
            box-shadow: 0 5px 20px rgba(245, 166, 35, 0.4);
            z-index: 10;
        }

        .capacity-badge {
            color: #495057;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .capacity-badge i {
            color: var(--psau-green);
        }

        .price-text {
            color: var(--psau-green);
            font-weight: 700;
            font-size: 1.2rem;
        }

        .badge {
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 6px;
        }

        .bg-success-subtle {
            background-color: rgba(26, 95, 63, 0.1) !important;
            color: var(--psau-green) !important;
        }

        .bg-psau-green {
            background-color: var(--psau-green) !important;
        }

        .modal-content {
            border-radius: 15px;
            overflow: hidden;
        }

        .modal-header {
            border-bottom: none;
            padding: 20px 25px;
        }

        .modal-room-image {
            max-width: 100%;
            max-height: 500px;
            object-fit: contain;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .page-title {
                font-size: 1.4rem;
            }

            .room-image-thumb {
                width: 70px;
                height: 55px;
            }

            .rooms-table td {
                padding: 15px 10px;
                font-size: 0.9rem;
            }

            .price-text {
                font-size: 1rem;
            }
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Use event delegation for dynamically added images
            document.addEventListener('click', function (e) {
                if (e.target.classList.contains('room-image-thumb')) {
                    var imageSrc = e.target.getAttribute('data-image');
                    showImageModal(imageSrc);
                }
            });
        });

        function showImageModal(imageSrc) {
            document.getElementById('modalImage').src = imageSrc;
            var modal = new bootstrap.Modal(document.getElementById('imageModal'));
            modal.show();
        }
    </script>
</asp:Content>
