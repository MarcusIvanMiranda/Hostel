<%@ Page Title="Confirm Booking" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConfirmReservation.aspx.cs" Inherits="PSAUStay.ConfirmReservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <asp:Panel ID="pnlBookingDetails" runat="server">
            <div class="row justify-content-center mb-5">
                <div class="col-md-8 text-center">
                    <div class="d-flex justify-content-between position-relative">
                        <div class="step-item text-muted"><span class="badge rounded-pill bg-secondary mb-2">1</span><br />Select Room</div>
                        <div class="step-item text-muted"><span class="badge rounded-pill bg-secondary mb-2">2</span><br />Details</div>
                        <div class="step-item fw-bold text-success"><span class="badge rounded-pill bg-success mb-2">3</span><br />Confirmation</div>
                        <div class="progress position-absolute start-0 end-0 mt-2" style="height: 2px; top: 12px; z-index: -1; width: 100%;">
                            <div class="progress-bar bg-success" role="progressbar" style="width: 100%;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card border-0 shadow-lg overflow-hidden" style="border-radius: 15px;">
                        <div class="row g-0">
                            <div class="col-md-4 bg-success text-white p-5 d-flex flex-column justify-content-center">
                                <i class="bi bi-calendar-check mb-4" style="font-size: 3rem;"></i>
                                <h2 class="fw-bold">Almost Done!</h2>
                                <p class="opacity-75">Please review your reservation details carefully before confirming.</p>
                                <hr class="border-white opacity-25" />
                                <div class="mt-3">
                                    <small class="text-uppercase d-block opacity-75">Reservation Status</small>
                                    <span class="badge bg-white text-success px-3 py-2 mt-1">Reviewing</span>
                                </div>
                            </div>

                            <div class="col-md-8 p-4 p-md-5 bg-white">
                                <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block border-0 mb-4" Visible="false"></asp:Label>
                                
                                <h4 class="mb-4 fw-bold text-dark">Reservation Summary</h4>
                                
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="text-muted small text-uppercase fw-bold">Room Name / Number</label>
                                        <p class="fs-5 mb-0"><i class="bi bi-door-open text-success me-2"></i><asp:Label ID="lblRoomName" runat="server" /></p>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small text-uppercase fw-bold">Guest Email</label>
                                        <p class="fs-5 mb-0"><i class="bi bi-envelope text-success me-2"></i><asp:Label ID="lblEmail" runat="server" /></p>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small text-uppercase fw-bold">Contact Number</label>
                                        <p class="fs-5 mb-0"><i class="bi bi-telephone text-success me-2"></i><asp:Label ID="lblContact" runat="server" /></p>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="text-muted small text-uppercase fw-bold">Stay Dates</label>
                                        <div class="bg-light p-3 rounded-3 mt-2 d-flex align-items-center">
                                            <i class="bi bi-calendar3 fs-4 text-success me-3"></i>
                                            <p class="fs-5 mb-0"><asp:Label ID="lblDates" runat="server" /></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-5 pt-4 border-top">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="mb-0 fw-bold">Total Amount</h4>
                                        <asp:Label ID="lblTotalAmount" runat="server" CssClass="display-6 fw-bold text-success" />
                                    </div>

                                    <div class="mb-4">
                                        <label class="text-muted small text-uppercase fw-bold d-block mb-3">Payment Option</label>
                                        <div class="bg-light p-3 rounded-3">
                                            <div class="form-check mb-2">
                                                <asp:RadioButton ID="rbDownpayment" runat="server" GroupName="PaymentOption" Checked="true" CssClass="form-check-input" />
                                                <label class="form-check-label" for="rbDownpayment">
                                                    <strong>Downpayment Only (50%)</strong> - Pay now to confirm booking
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <asp:RadioButton ID="rbFullPayment" runat="server" GroupName="PaymentOption" CssClass="form-check-input" />
                                                <label class="form-check-label" for="rbFullPayment">
                                                    <strong>Full Payment</strong> - Pay entire amount now
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                        <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="btn btn-link text-muted text-decoration-none me-md-3">
                                            <i class="bi bi-arrow-left"></i> Modify Details
                                        </asp:LinkButton>
                                        <asp:Button ID="btnFinalConfirm" runat="server" Text="Confirm & Book Now" OnClick="btnFinalConfirm_Click" 
                                            CssClass="btn btn-success btn-lg px-5 shadow-sm rounded-pill fw-bold" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <%-- Success Panel remains similar but with updated Iconography --%>
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow border-0 p-5 text-center" style="border-radius: 20px;">
                        <div class="mb-4">
                            <div class="bg-success text-white d-inline-flex align-items-center justify-content-center rounded-circle" style="width: 100px; height: 100px;">
                                <i class="bi bi-check-lg" style="font-size: 3.5rem;"></i>
                            </div>
                        </div>
                        <h2 class="fw-bold text-success">Booking Submitted!</h2>
                        <p class="text-muted fs-5 mt-3">
                            Thank you, <strong><asp:Literal ID="litGuestName" runat="server" /></strong>. Your request is now being processed.
                        </p>
                        <hr class="my-4" />
                        <a href="OnlineBooking.aspx" class="btn btn-outline-success btn-lg px-5 rounded-pill mt-2">Finish</a>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <style>
        body { background-color: #f8f9fa; }
        .step-item { font-size: 0.85rem; width: 80px; }
        .progress-bar { transition: width .6s ease; }
    </style>
</asp:Content>