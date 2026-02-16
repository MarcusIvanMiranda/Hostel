<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ShowDetails.ascx.cs" Inherits="UserControls_ShowDetails" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Src="~/UserControls/StartFilter.ascx" TagPrefix="uc1" TagName="StartFilter" %>
<div class="wrapper-relative" id="content">
    <div class="details-header">
        <dx:ASPxCallbackPanel runat="server" ID="HotelDetailsCallbackPanel" ClientInstanceName="HotelDetailsCallbackPanel" OnCallback="HotelDetailsCallbackPanel_Callback">
            <PanelCollection>
                <dx:PanelContent>
                    <h2><%= SearchState.Hotel.Hotel_Name %></h2>
                    <dx:ASPxRatingControl ID="HotelRatingControl" CssClass="rating" runat="server" OnLoad="HotelRatingControl_Load" FillPrecision="Exact">
                        <ClientSideEvents ItemClick="onRatingControlItemClick" />
                    </dx:ASPxRatingControl>
                    <div class="params-block">
                        <div class="params"><%= SearchState.StartFilterText %></div>
                        <dx:ASPxButton runat="server" ID="UpdateFooterFilterButton" CssClass="update-start-filter-button" Height="40px" AutoPostBack="false">
                            <ClientSideEvents Click="onShowStartFilterButtonClick" />
                            <Image Url="~/Content/Images/UpdateFooterFilter.png"></Image>
                        </dx:ASPxButton>
                    </div>
                    <div class="address"><%= SearchState.Hotel.Address %><br /><%= SearchState.Hotel.DetailsCity %></div>
                    <div class="description"><%= SearchState.Hotel.Description %></div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <div class="details-left">
    </div>
    <div class="details-content hotel-details">
        <div class="details-image">
            <dx:ASPxImageSlider runat="server" ID="HotelImageSlider" Height="100%" Width="100%" CssClass="details-slider" ImageUrlField="Url"></dx:ASPxImageSlider>
        </div>
        <div class="details-comments" runat="server" id="CommentsDiv">
            <h5>What our guests say...</h5>
            <dx:ASPxDataView runat="server" ID="CommentsDataView" CssClass="comments-dataview" Layout="Flow">
                <ContentStyle CssClass="comments-dataview-content" />
                <ItemStyle CssClass="comment-item" />
                <SettingsTableLayout ColumnCount="1" />
                <ItemTemplate>
                    <%# Eval("Review_Text") %><br />
                    <div class="date">
                        <%# Eval("Posted_On", "{0:MMM d, yyyy}") %>
                    </div>
                    <dx:ASPxRatingControl runat="server" ID="CommentRatingControl" ReadOnly="true" Value='<%# Convert.ToDecimal(Eval("Rating")) %>' OnLoad="CommentRatingControl_Load">
                    </dx:ASPxRatingControl>
                </ItemTemplate>
            </dx:ASPxDataView>
        </div>
    </div>
    <div class="details-right">
        <dx:ASPxButton runat="server" ID="RightButton" BackColor="Transparent" AutoPostBack="false" CssClass="nav-button">
            <Border BorderStyle="None" />
            <Image Url="~/Content/Images/RightButton.png"></Image>
            <ClientSideEvents Click="onShowRoomsButtonClick" />
        </dx:ASPxButton>
    </div>
    <uc1:StartFilter runat="server" ID="StartFilter" />
</div>
