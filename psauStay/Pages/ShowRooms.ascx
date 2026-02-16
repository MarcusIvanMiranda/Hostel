<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ShowRooms.ascx.cs" Inherits="UserControls_ShowRooms" %>
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
                        <dx:ASPxButton runat="server" ID="UpdateFilterButton" CssClass="footerButton" Height="40px" AutoPostBack="false" BackColor="Transparent">
                            <ClientSideEvents Click="onShowStartFilterButtonClick" />
                            <Border BorderStyle="None" />
                            <HoverStyle BackColor="Transparent"></HoverStyle>
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
        <dx:ASPxButton runat="server" ID="LeftButton" CssClass="nav-button"
            BackColor="Transparent" Height="100px" Width="48px" AutoPostBack="false">
            <Border BorderStyle="None" />
            <Image Url="~/Content/Images/LeftButton.png"></Image>
            <ClientSideEvents Click="onShowDetailsButtonClick" />
        </dx:ASPxButton>
    </div>
    <div class="details-content rooms-details">
        <dx:ASPxNavBar runat="server" ID="RoomsNavBar" ClientInstanceName="RoomsNavBar" CssClass="rooms-navbar" ExpandButtonPosition="Left" Width="100%" AutoCollapse="true">
            <ClientSideEvents ExpandedChanged="onRoomsNavBarExpandedChanged" />
            <GroupHeaderStyle CssClass="navbar-header" />
            <GroupContentStyle CssClass="navbar-content" />
            <CollapseImage Url="~/Content/Images/RoomColButton.png"></CollapseImage>
            <ExpandImage Url="~/Content/Images/RoomExpButton.png"></ExpandImage>
            <GroupHeaderTemplate>
                <div class="title">
                    <%# Eval("Text") %>
                </div>
                <div class="right-panel">
                    <div class="rate-date">
                        <div class="low-price">
                            LOWEST PRICE
                        </div>
                        <div class="date">
                            available on <%# Eval("DataItem.PriceAvailableDate", "{0:M/dd/yyyy}") %>
                        </div>
                    </div>
                    <div class="price">
                        <%# Eval("DataItem.Nighly_Rate", "{0:C}") %>
                    </div>
                    <dx:ASPxButton runat="server" Text="Book It" AutoPostBack="false"
                        ClientSideEvents-Click='<%# Eval("DataItem.ID", "function(s, e) {{ onBookRoomButtonClick({0}); e.cancelBubbleEvent = true; }}") %>'
                        Height="40px" Width="110px" CssClass="button-white">
                        <HoverStyle CssClass="button-white-hover"></HoverStyle>
                    </dx:ASPxButton>
                </div>
                <div class="clear"></div>
            </GroupHeaderTemplate>
            <GroupContentTemplate>
                <div class="room-info">
                    <div class="room-description">
                        <%# Eval("DataItem.Room_Short_Description") %>
                    </div>
                    <dx:ASPxDataView runat="server" ID="FeaturesDataView" OnInit="FeaturesDataView_Init" ItemSpacing="6px">
                        <ContentStyle Border-BorderStyle="None"></ContentStyle>
                        <SettingsTableLayout ColumnCount="2" RowsPerPage="3" />
                        <PagerSettings Visible="false"></PagerSettings>
                        <ItemStyle Width="152px" Height="22px" Paddings-Padding="0" />
                        <ItemTemplate>
                            <dx:ASPxImage runat="server" CssClass="feature-img" ID="RoomFeatureIcon" ImageUrl='<%# Eval("ImageUrl") %>'></dx:ASPxImage>
                            <div class="feature-description"><%# Eval("Description") %></div>
                        </ItemTemplate>
                    </dx:ASPxDataView>
                </div>
                <div class="slider-container">
                    <dx:ASPxImageSlider runat="server" ID="RoomImageSlider" CssClass="room-slider" OnInit="RoomImageSlider_Init" ShowImageArea="false"
                        NameField="Picture_Id" ThumbnailUrlField="Url" Width="100%" ClientSideEvents-ThumbnailItemClick='<%# string.Format("function(s, e) {{ onRoomImageNavItemClick({0}, e.item.name); }}", ((Room)Container.Group.DataItem).ID) %>'>
                        <SettingsNavigationBar ThumbnailsNavigationButtonPosition="Outside" ItemSpacing="10px" />
                        <Styles>
                            <NavigationBarThumbnailsModeBottom CssClass="navbar">
                            </NavigationBarThumbnailsModeBottom>
                            <Thumbnail CssClass="thumb" ImageWidth="120px" ImageHeight="70px"></Thumbnail>
                        </Styles>
                    </dx:ASPxImageSlider>
                </div>
            </GroupContentTemplate>
        </dx:ASPxNavBar>
    </div>
    <div class="details-right">
    </div>
    <dx:ASPxPopupControl ID="ImagePopupControl" ClientInstanceName="ImagePopupControl" runat="server" OnWindowCallback="ImagePopupControl_WindowCallback"
        Modal="True" PopupAnimationType="Fade" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        ShowHeader="False" Width="600px" Height="500px" CssClass="popup">
        <ModalBackgroundStyle CssClass="modal-bg" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxImageSlider ID="RoomPopupImageSlider" ClientInstanceName="RoomPopupImageSlider" Width="100%" Height="500px" runat="server" ImageUrlField="Url">
                    <SettingsAutoGeneratedImages ImageCacheFolder="~\Thumb\" />
                </dx:ASPxImageSlider>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <uc1:StartFilter runat="server" ID="StartFilter" />
</div>
