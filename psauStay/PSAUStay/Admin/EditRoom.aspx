<%@ Page Title="" Language="C#" MasterPageFile="~/AdminControl.master" AutoEventWireup="true" CodeBehind="EditRoom.aspx.cs" Inherits="PSAUStay.Admin.EditRoom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminMainContent" runat="server">
    <h2>Edit Room</h2>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold mt-3 d-block"></asp:Label>

    <asp:HiddenField ID="hfRoomID" runat="server" />

    <div class="mb-3">
        <label>Room Name</label>
        <asp:TextBox ID="txtRoomName" runat="server" CssClass="form-control" />
    </div>

    <div class="mb-3">
        <label>Room Type</label>
        <asp:TextBox ID="txtRoomType" runat="server" CssClass="form-control" />
    </div>

    <div class="mb-3">
        <label>Description</label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
    </div>

    <div class="mb-3">
        <label>Features</label>
        <asp:TextBox ID="txtFeatures" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
    </div>

    <div class="mb-3">
        <label>Capacity</label>
        <asp:TextBox ID="txtCapacity" runat="server" TextMode="Number" CssClass="form-control" />
    </div>

    <div class="mb-3">
        <label>Price (₱)</label>
        <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" CssClass="form-control" />
    </div>

    <div class="form-check">
        <asp:CheckBox ID="chkAvailable" runat="server" CssClass="form-check-input" />
        <label class="form-check-label">Available for booking</label>
    </div>
    <div class="mb-3">
        <label class="form-label fw-bold">Upload Room Images (Front, Bed, TV, Bathroom, Other)</label>
        <div class="row g-2">
            <div class="col-6">
                <asp:FileUpload ID="fuImage1" runat="server" CssClass="form-control" />
            </div>
            <div class="col-6">
                <asp:FileUpload ID="fuImage2" runat="server" CssClass="form-control" />
            </div>
            <div class="col-6">
                <asp:FileUpload ID="fuImage3" runat="server" CssClass="form-control" />
            </div>
            <div class="col-6">
                <asp:FileUpload ID="fuImage4" runat="server" CssClass="form-control" />
            </div>
            <div class="col-12">
                <asp:FileUpload ID="fuImage5" runat="server" CssClass="form-control" />
            </div>
        </div>
    </div>


    <asp:Button ID="btnUpdateRoom" runat="server" Text="Save Changes" CssClass="btn btn-primary mt-3"
        OnClick="btnUpdateRoom_Click" />
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary mt-3"
        OnClick="btnCancel_Click" CausesValidation="False" />
    <asp:HiddenField ID="hfOldImage1" runat="server" />
    <asp:HiddenField ID="hfOldImage2" runat="server" />
    <asp:HiddenField ID="hfOldImage3" runat="server" />
    <asp:HiddenField ID="hfOldImage4" runat="server" />
    <asp:HiddenField ID="hfOldImage5" runat="server" />

</asp:Content>
