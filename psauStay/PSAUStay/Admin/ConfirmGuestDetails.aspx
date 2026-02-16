<%@ Page Title="Confirm Guest Details" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="ConfirmGuestDetails.aspx.cs" Inherits="PSAUStay.Admin.ConfirmGuestDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-check-circle me-2"></i>Confirm Guest Details</h4>
                    </div>
                    <div class="card-body p-4">
                        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-3" Visible="false"></asp:Label>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="text-muted">Guest Information</h6>
                                <p><strong>Name:</strong> <asp:Label ID="lblFullName" runat="server"></asp:Label></p>
                                <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server"></asp:Label></p>
                                <p><strong>Contact:</strong> <asp:Label ID="lblContact" runat="server"></asp:Label></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-muted">Booking Details</h6>
                                <p><strong>Room Type:</strong> <asp:Label ID="lblRoomType" runat="server"></asp:Label></p>
                                <p><strong>Room Number:</strong> <asp:Label ID="lblRoomNumber" runat="server"></asp:Label></p>
                                <p><strong>Status:</strong> <asp:Label ID="lblStatus" runat="server"></asp:Label></p>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-12">
                                <h6 class="text-muted">Stay Period</h6>
                                <p><strong>Check-in:</strong> <asp:Label ID="lblCheckIn" runat="server"></asp:Label></p>
                                <p><strong>Check-out:</strong> <asp:Label ID="lblCheckOut" runat="server"></asp:Label></p>
                                <asp:Label ID="lblMessage" runat="server" Visible="false">
                                    <p><strong>Admin Notes:</strong> <asp:Literal ID="litMessage" runat="server"></asp:Literal></p>
                                </asp:Label>
                            </div>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Please review all the information above. Clicking "Confirm" will finalize this guest booking and update room availability.
                        </div>

                        <div class="d-flex justify-content-between">
                            <asp:Button ID="btnBack" runat="server" Text="← Back to Edit" CssClass="btn btn-secondary" OnClick="btnBack_Click" />
                            <asp:Button ID="btnConfirm" runat="server" Text="Confirm Booking" CssClass="btn btn-success px-4" OnClick="btnConfirm_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
