<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoomOffers.ascx.cs" Inherits="Pages_SpecialOffers" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<div class="wrapper-relative special-offers-content" id="SpecialOffersContainer">
    <div class="padding-container">
        <div class="special-offer-zone-1">
            <div class="image-wrapper">
                <dx:ASPxDockZone runat="server" ID="DockZone1" ClientInstanceName="DockZone1" ZoneUID="DockZone1" CssClass="dock-zone" Orientation="Fill" Width="100%" Height="100%"></dx:ASPxDockZone>
            </div>
        </div>
        <div class="special-offer-zone-2">
            <div class="image-wrapper">
                <dx:ASPxDockZone runat="server" ID="DockZone2" ClientInstanceName="DockZone2" ZoneUID="DockZone2" CssClass="dock-zone" Orientation="Fill" Width="100%" Height="100%"></dx:ASPxDockZone>
            </div>
        </div>
        <div class="special-offer-zone-3">
            <div class="image-wrapper">
                <dx:ASPxDockZone runat="server" ID="DockZone3" ClientInstanceName="DockZone3" ZoneUID="DockZone3" CssClass="dock-zone" Orientation="Fill" Width="100%" Height="100%"></dx:ASPxDockZone>
            </div>
        </div>
        <div class="special-offer-zone-4">
            <div class="image-wrapper">
                <dx:ASPxDockZone runat="server" ID="DockZone4" ClientInstanceName="DockZone4" ZoneUID="DockZone4" CssClass="dock-zone" Orientation="Fill" Width="100%" Height="100%"></dx:ASPxDockZone>
            </div>
        </div>
    </div>
</div>
<asp:Repeater runat="server" ID="PanelsRepeater">
    <ItemTemplate>
        <dx:ASPxDockPanel runat="server" DragElement="Window" ShowHeader="false" OnInit="DockPanel_Init" AllowedDockState="DockedOnly" CssClass="offer-panel" AllowDragging="false">
            <Styles>
                <Content CssClass="offer-panel-content" />
            </Styles>
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div class="offer-container" onclick="onOfferClick(<%# GetItemIndex(Container) %>)">
                        <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/offer-close-ico.png" CssClass="close-button"
                            ClientSideEvents-Click='<%# string.Format("function(s, e) {{ onSpecialOfferClose({0}, e.htmlEvent); }}", GetItemIndex(Container)) %>'>
                        </dx:ASPxImage>
                        <div class="image-container">
                            <dx:ASPxImage runat="server" CssClass="image" ImageUrl='<%# Eval("City.City_Image_Url") %>'></dx:ASPxImage>
                        </div>
                        <div class="offer-info offer-info-bg"></div>
                        <div class="offer-info">
                            <h3>
                                <%# Eval("City.City_Name") %>
                            </h3>
                            <h4>
                                <%# Eval("Hotel.Hotel_Name") %>
                            </h4>
                            <div class="price-info">
                                Starting from <span class="price"><%# Eval("Hotel.StartPrice", "{0:C}") %></span>
                            </div>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxDockPanel>
    </ItemTemplate>
</asp:Repeater>
<dx:ASPxDockManager ID="DockManager" runat="server" ClientInstanceName="DockManager">
    <ClientSideEvents Init="tileLayout.onDockManagerInit" StartPanelDragging="tileLayout.onStartPanelDragging"
        EndPanelDragging="tileLayout.onEndPanelDragging" AfterDock="tileLayout.onAfterDock" />
</dx:ASPxDockManager>
<dx:ASPxPopupControl runat="server" ID="OfferFormPopup" ClientInstanceName="OfferFormPopup" CssClass="special-offer-popup popup"
    OnWindowCallback="OfferFormPopup_WindowCallback" ShowHeader="false" Width="330px" Height="250px" Modal="true">
    <ModalBackgroundStyle CssClass="modal-bg" />
    <ContentCollection>
        <dx:PopupControlContentControl>
            <div class="form-container" id="FormContainer">
                <h3 runat="server" id="CityNameHeader"></h3>
                <h4 runat="server" id="HotelNameHeader"></h4>
                <dx:ASPxFormLayout runat="server" CssClass="form-layout" ColCount="3" ShowItemCaptionColon="False" RequiredMarkDisplayMode="None">
                    <Styles>
                        <LayoutGroup CssClass="group">
                            <Cell CssClass="group-cell"></Cell>
                        </LayoutGroup>
                        <LayoutItem>
                            <Caption CssClass="caption"></Caption>
                        </LayoutItem>
                    </Styles>
                    <SettingsItemCaptions Location="Top" />
                    <Items>
                        <dx:LayoutItem Caption="CHECK IN" Width="130px">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxDateEdit runat="server" ID="CheckInDateEdit" ClientInstanceName="CheckInDateEdit"
                                        Width="130px" Height="30px" CssClass="editor">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
                                        <DropDownButton Width="38px">
                                            <Image Url="~/Content/Images/DateEditPopOut.png"></Image>
                                        </DropDownButton>
                                        <ButtonStyle>
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                        <CalendarProperties ShowWeekNumbers="false">
                                            <MonthGridPaddings PaddingLeft="30px" PaddingRight="30px" PaddingTop="15px" PaddingBottom="10px" />
                                        </CalendarProperties>
                                        <ValidationSettings ErrorDisplayMode="None" SetFocusOnError="true" ValidateOnLeave="False" ValidationGroup="DateEditors">
                                            <RequiredField IsRequired="True"></RequiredField>
                                        </ValidationSettings>
                                        <InvalidStyle>
                                            <Border BorderColor="red"></Border>
                                        </InvalidStyle>
                                    </dx:ASPxDateEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="CHECK OUT" ColSpan="2" Width="170px">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxDateEdit runat="server" ID="CheckOutDateEdit" ClientInstanceName="CheckOutDateEdit"
                                        Width="170px" Height="30px" CssClass="editor">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
                                        <DropDownButton Width="38px">
                                            <Image Url="~/Content/Images/DateEditPopOut.png"></Image>
                                        </DropDownButton>
                                        <ButtonStyle>
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                        <CalendarProperties ShowWeekNumbers="false">
                                            <MonthGridPaddings PaddingLeft="30px" PaddingRight="30px" PaddingTop="15px" PaddingBottom="10px" />
                                        </CalendarProperties>
                                        <ValidationSettings ErrorDisplayMode="None" SetFocusOnError="true" ValidateOnLeave="False" ValidationGroup="DateEditors">
                                            <RequiredField IsRequired="True"></RequiredField>
                                        </ValidationSettings>
                                        <DateRangeSettings StartDateEditID="CheckInDateEdit" MinDayCount="1"></DateRangeSettings>
                                        <InvalidStyle>
                                            <Border BorderColor="red"></Border>
                                        </InvalidStyle>
                                    </dx:ASPxDateEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="ROOMS" Width="130px">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxSpinEdit runat="server" ID="RoomsSpinEdit" ClientInstanceName="RoomsSpinEdit"
                                        Width="130px" Height="30px" CssClass="editor"
                                        Number="1" MinValue="1" MaxValue="5" LargeIncrement="1">
                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                        <SpinButtons ShowLargeIncrementButtons="true" ShowIncrementButtons="false">
                                            <LargeIncrementImage Url="~/Content/Images/SpinEditPlus.png"></LargeIncrementImage>
                                            <LargeDecrementImage Url="~/Content/Images/SpinEditMinus.png"></LargeDecrementImage>
                                        </SpinButtons>
                                        <ButtonStyle>
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                    </dx:ASPxSpinEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="ADULTS" Width="80px">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxSpinEdit runat="server" ID="AdultsSpinEdit" ClientInstanceName="AdultsSpinEdit"
                                        Width="80px" Height="30px" CssClass="editor"
                                        Number="1" MinValue="1" MaxValue="5" LargeIncrement="1">
                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                        <SpinButtons ShowLargeIncrementButtons="true" ShowIncrementButtons="false">
                                            <LargeIncrementImage Url="~/Content/Images/SpinEditPlus.png"></LargeIncrementImage>
                                            <LargeDecrementImage Url="~/Content/Images/SpinEditMinus.png"></LargeDecrementImage>
                                        </SpinButtons>
                                        <ButtonStyle>
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                    </dx:ASPxSpinEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="CHILDREN" Width="80px">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxSpinEdit runat="server" ID="ChildrenSpinEdit"
                                        ClientInstanceName="ChildrenSpinEdit" Width="80px" Height="30px" CssClass="editor"
                                        Number="0" MinValue="0" MaxValue="5" LargeIncrement="1">
                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                        <SpinButtons ShowLargeIncrementButtons="true" ShowIncrementButtons="false">
                                            <LargeIncrementImage Url="~/Content/Images/SpinEditPlus.png"></LargeIncrementImage>
                                            <LargeDecrementImage Url="~/Content/Images/SpinEditMinus.png"></LargeDecrementImage>
                                        </SpinButtons>
                                        <ButtonStyle>
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                    </dx:ASPxSpinEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:EmptyLayoutItem Height="16px" ColSpan="3">
                        </dx:EmptyLayoutItem>
                        <dx:LayoutItem ShowCaption="False" ColSpan="3">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxButton runat="server" ID="CheckButton" Width="308px" Height="40px" CssClass="button"
                                        Text="Check Availability" AutoPostBack="false">
                                    </dx:ASPxButton>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                    </Items>
                </dx:ASPxFormLayout>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
