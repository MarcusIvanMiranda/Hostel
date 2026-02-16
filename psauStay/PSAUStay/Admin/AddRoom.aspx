<%@ Page Title="Add Room" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="AddRoom.aspx.cs" Inherits="PSAUStay.Admin.AddRoom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <%-- Green Header --%>
    <div class="card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, var(--psau-green) 0%, var(--psau-green-dark) 100%);">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="mb-1 fw-bold text-white">
                        <i class="bi bi-plus-circle-fill me-2" style="color: var(--psau-gold);"></i>
                        Add New Room
                    </h2>
                    <p class="mb-0 text-white-50">Create a new room category for the accommodation system</p>
                </div>
                                         <div class="col-auto">
                        <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>" class="btn btn-light shadow-sm fw-bold me-2">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
          
                    </div>
            </div>
       
        </div>
    </div>

    <style>
        :root {
            --psau-green: #0b6623;
            --psau-gold: #f1c40f;
            --psau-light-bg: #f9f9f9;
        }

        body {
            background-color: var(--psau-light-bg);
        }

        .card {
            border: none;
            border-radius: 1rem;
            overflow: hidden;
        }

        .card-header {
            background-color: var(--psau-green) !important;
            color: #fff;
        }

        .form-label {
            color: var(--psau-green);
        }

        .form-control:focus {
            border-color: var(--psau-gold);
            box-shadow: 0 0 0 0.2rem rgba(241, 196, 15, 0.25);
        }

        .btn-primary {
            background-color: var(--psau-green);
            border: none;
            color: #fff;
            transition: all 0.3s ease-in-out;
        }

            .btn-primary:hover {
                background-color: var(--psau-gold);
                color: var(--psau-green);
                font-weight: bold;
            }

        .text-success {
            color: var(--psau-green) !important;
        }

        /* Responsive fix */
        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem;
            }
        }
    </style>

    <div class="container mt-4 mb-5">
        <div class="card shadow-lg border-0 rounded-4">
            <div class="card-header text-white text-center py-3 rounded-top-4">
                <h4 class="mb-0"><i class="bi bi-house-door"></i>Add New Room</h4>
            </div>
            <asp:Button ID="btnAddRoom" runat="server" Text="Add New Room"
                CssClass="btn btn-success mb-3"
                OnClick="btnAddRoom_Click" />

            <div class="card-body p-4">
                <div class="row">
                    <!-- Left Column -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Room Name</label>
                            <asp:TextBox ID="txtRoomName" runat="server" CssClass="form-control" placeholder="Enter room name"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Room Type</label>
                            <asp:TextBox ID="txtType" runat="server" CssClass="form-control" placeholder="e.g., Deluxe, Suite, Standard"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Capacity</label>
                            <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" TextMode="Number" placeholder="Number of occupants"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Price (₱)</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter price per night"></asp:TextBox>
                        </div>

                        <div class="form-check mb-4">
                            <asp:CheckBox ID="chkAvailable" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label fw-semibold" for="chkAvailable">Available for booking</label>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Describe the room..."></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Features</label>
                            <asp:TextBox ID="txtFeatures" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="e.g., WiFi, Aircon, TV, Hot Shower"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Upload Room Images (Front, Bed, TV, Bathroom, Other)</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <asp:FileUpload ID="fuImage1" runat="server" CssClass="form-control" /></div>
                                <div class="col-6">
                                    <asp:FileUpload ID="fuImage2" runat="server" CssClass="form-control" /></div>
                                <div class="col-6">
                                    <asp:FileUpload ID="fuImage3" runat="server" CssClass="form-control" /></div>
                                <div class="col-6">
                                    <asp:FileUpload ID="fuImage4" runat="server" CssClass="form-control" /></div>
                                <div class="col-12">
                                    <asp:FileUpload ID="fuImage5" runat="server" CssClass="form-control" /></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Save Button -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnSave" runat="server" Text="Save Room" CssClass="btn btn-primary px-5 py-2 rounded-pill fw-bold shadow-sm" OnClick="btnSave_Click" />
                </div>

                <!-- Status Message -->
                <div class="text-center mt-3">
                    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold text-success"></asp:Label>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
