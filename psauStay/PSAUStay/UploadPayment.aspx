<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UploadPayment.aspx.cs" Inherits="PSAUStay.UploadPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="max-width: 600px; margin-top: 20px;">
        <!-- Email Style Header -->
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
            <h3 style="color: #007bff; margin-bottom: 10px;">Action Required: Payment for Booking #218</h3>
            <h2 style="color: #28a745; font-size: 24px; margin-bottom: 15px;">Booking Received!</h2>
            <p style="margin-bottom: 15px;">Dear <strong>John Doe</strong>,</p>
            <p style="margin-bottom: 15px;">Thank you for your booking! We're pleased to confirm your reservation details below:</p>
        </div>

        <!-- Booking Details -->
        <div style="background-color: white; padding: 20px; border: 1px solid #dee2e6; border-radius: 8px; margin-bottom: 20px;">
            <h4 style="color: #495057; margin-bottom: 15px;">Booking Details</h4>
            <div style="margin-bottom: 10px;"><strong>Booking Number:</strong> #218</div>
            <div style="margin-bottom: 10px;"><strong>Check-in:</strong> March 15, 2024</div>
            <div style="margin-bottom: 10px;"><strong>Check-out:</strong> March 17, 2024</div>
            <div style="margin-bottom: 10px;"><strong>Room Type:</strong> Standard Twin Room</div>
            <div style="margin-bottom: 15px;"><strong>Total Price:</strong> <span style="color: #28a745; font-weight: bold;">₱2,000</span></div>
        </div>

        <!-- Payment Instructions -->
        <div style="background-color: #fff3cd; padding: 20px; border: 1px solid #ffeaa7; border-radius: 8px; margin-bottom: 20px;">
            <h4 style="color: #856404; margin-bottom: 15px;">Payment Instructions</h4>
            <p style="margin-bottom: 15px;">To complete your booking, please pay the total amount of <strong>₱2,000</strong> via:</p>
            <div style="background-color: white; padding: 15px; border-radius: 5px; margin-bottom: 15px;">
                <div style="margin-bottom: 10px;"><strong>GCash:</strong> 0912-345-6789</div>
                <div style="margin-bottom: 10px;"><strong>PayMaya:</strong> 0912-345-6789</div>
                <div><strong>Account Name:</strong> PSAU Stay</div>
            </div>
            <p style="margin-bottom: 15px;">After payment, please upload your proof of payment below:</p>
        </div>

        <!-- Upload Section -->
        <div style="background-color: white; padding: 20px; border: 1px solid #dee2e6; border-radius: 8px;">
            <h4 style="color: #495057; margin-bottom: 15px;">Upload Proof of Payment</h4>
            <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block"></asp:Label>

            <asp:Panel ID="pnlUpload" runat="server" Visible="false">
                <asp:FileUpload ID="fuPaymentProof" runat="server" CssClass="form-control mb-3" 
                                onchange="previewFile(this)" />
                
                <!-- Image preview -->
                <div class="mb-3">
                    <img id="imgPreview" src="#" style="display:none; max-width:100%; height:auto; border:1px solid #ccc; padding:5px;" />
                </div>

                <asp:Button ID="Button1" runat="server" Text="Upload Payment Proof" CssClass="btn btn-primary" OnClick="btnUpload_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlExpired" runat="server" Visible="false">
                <p class="text-center text-danger">
                    This upload link has expired or is invalid. Please contact support.
                </p>
            </asp:Panel>
        </div>
    </div>

    <script type="text/javascript">
        function previewFile(input) {
            var file = input.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = document.getElementById('imgPreview');
                    img.src = e.target.result;
                    img.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        }
    </script>
</asp:Content>
