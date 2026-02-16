<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" EnableViewState="false" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DXHotels iPad App Touch Demo | ASP.NET Controls by DevExpress</title>
    <link href="Content/Site.css" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <link rel="apple-touch-startup-image" href="Content/Images/splash/landscape.png" media="screen and (orientation:landscape) and (-webkit-min-device-pixel-ratio: 1)" />
    <link rel="apple-touch-startup-image" href="Content/Images/splash/portrait.png" media="screen and (orientation:portrait) and (-webkit-min-device-pixel-ratio: 1)" />
    <link rel="apple-touch-startup-image" href="Content/Images/splash/landscape2x.png" media="screen and (orientation:landscape) and (-webkit-min-device-pixel-ratio: 2)" />
    <link rel="apple-touch-startup-image" href="Content/Images/splash/portrait2x.png" media="screen and (orientation:portrait) and (-webkit-min-device-pixel-ratio: 2)" />
    <link rel="apple-touch-icon" sizes="76x76" href="Content/Images/ios-icon-76x76.png"/>
    <link rel="apple-touch-icon" sizes="152x152" href="Content/Images/ios-icon-152x152.png" />
    <script src="Content/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="Content/TileLayout.js" type="text/javascript"></script>
    <script src="Content/Scripts.js" type="text/javascript"></script>
</head>
<body runat="server" id="Body">
    <form id="form1" runat="server">
        <dx:ASPxCallbackPanel runat="server" ID="MainCallbackPanel" ClientInstanceName="MainCallbackPanel" CssClass="main-container" 
            OnCallback="MainCallbackPanel_Callback" EnableCallbackAnimation="true">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxPanel runat="server" ID="LeftPanel" ClientInstanceName="LeftPanel" FixedPosition="WindowLeft" CssClass="left-pane" Width="310px" Collapsible="true">
                        <SettingsCollapsing ExpandOnPageLoad="false" ExpandButton-Visible="false" ExpandEffect="Slide"  />
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxMenu runat="server" Width="100%" Orientation="Vertical" CssClass="main-menu" SeparatorHeight="0" AutoPostBack="false">
                                    <ClientSideEvents ItemClick="onMainMenuItemClick" />
                                    <ItemStyle CssClass="item">
                                        <SelectedStyle CssClass="selected-item"></SelectedStyle>
                                        <HoverStyle CssClass="hover-item"></HoverStyle>
                                    </ItemStyle>
                                    <Items>
                                        <dx:MenuItem Text="Home" Selected="true">
                                            <Image Url="~/Content/Images/ico-index-home.png" UrlSelected="~/Content/Images/ico-index-home-s.png" UrlHottracked="~/Content/Images/ico-index-home-s.png" />
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Room Offers" Name="offers">
                                            <Image Url="~/Content/Images/ico-index-offers2.png" UrlHottracked="~/Content/Images/ico-index-offers-s2.png"></Image>
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Login" Name="login">
                                            <Image Url="~/Content/Images/ico-index-login2.png" UrlHottracked="~/Content/Images/ico-index-login-s.png"></Image>
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Contact Us" Name="contact">
                                            <Image Url="~/Content/Images/ico-index-contacts2.png" UrlHottracked="~/Content/Images/ico-index-contacts-s.png"></Image>
                                        </dx:MenuItem>
                                    </Items>
                                </dx:ASPxMenu>
                                <%--<div class="app-info">
                                    <h5>Your Next Great App
                                                        <br />
                                        Starts Here</h5>
                                    <div class="slogan">Create stunning iPad-ready ASP.NET apps with the award-winning DevExpress ASP.NET Subscription.</div>
                                    <a href="<%= AssemblyInfo.DXLinkTrial %>" target="_blank">Download your free 30-day trial</a>
                                    <dx:ASPxHyperLink runat="server" ImageUrl="~/Content/Images/logo-w.png" Target="_blank" NavigateUrl="http://www.devexpress.com" CssClass="logo"></dx:ASPxHyperLink>
                                </div>--%>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                    <div class="header-pane">
                        <dx:ASPxButton ID="MenuButton" ClientInstanceName="MenuButton" runat="server" AutoPostBack="False" CssClass="button"
                            Width="50px" Height="50px" GroupName="Menu">
                            <ClientSideEvents CheckedChanged="onMenuNavButtonCheckedChanged" />
                            <Image Url="~/Content/Images/Menu.png" UrlChecked="~/Content/Images/Menu-c.png"></Image>
                        </dx:ASPxButton>
                        <dx:ASPxButton ID="BackButton" runat="server" AutoPostBack="False" CssClass="button" Width="50px" Height="50px">
                            <ClientSideEvents Click="onBackNavButtonClick" />
                            <Image Url="~/Content/Images/Back.png"></Image>
                        </dx:ASPxButton>
                        <dx:ASPxImage ID="LogoImage" runat="server" ImageUrl="~/Content/Images/PSAULogo.png" CssClass="hotels-logo">
                            <ClientSideEvents Click="onLogoClick" />
                        </dx:ASPxImage>
                        <div class="separator"></div>
                        <%--<div class="powered-text">
                            Powered by DevExpress
                                                    <br />
                            ASP.NET Controls and Libraries
                        </div>--%>
                        <%--<dx:ASPxHyperLink runat="server" ImageUrl="~/Content/Images/DevExpressHeader.png" Target="_blank" NavigateUrl="http://www.devexpress.com" CssClass="devex-logo"></dx:ASPxHyperLink>--%>
                    </div>
                    <div class="content-pane" id="ContentPane" runat="server">
                        <dx:ASPxPopupControl runat="server" ID="AboutWindow" ClientInstanceName="AboutWindow" PopupAnimationType="Fade"
                            PopupHorizontalAlign="Center" PopupVerticalAlign="Middle" Width="698px" Height="316px" Modal="true"
                            ShowHeader="false" CssClass="about-window popup">
                            <ClientSideEvents CloseUp="onAboutWindowCloseUp" />
                            <ModalBackgroundStyle CssClass="modal-bg" />
                            <ContentCollection>
                                <dx:PopupControlContentControl>
                                    <%--<h3>Your Next Great Web App Starts Here</h3>
                                    <div class="text-block">
                                        To learn more about DevExpress Subscriptions and obtain pricing information,
                                        <br />
                                        visit our <a href="<%= AssemblyInfo.DXLinkCompare %>" target="_blank">Compare Features and Pricing</a> webpage.
                                    </div>
                                    <div class="text-block">
                                        If you have any questions or require assistance, call us at +1 (818) 844-3383
                                        <br />
                                        between 7:30am and 4:30pm Pacific Time 
                                        or email <a href="<%= AssemblyInfo.DXLinkEmailInfo %>" target="_blank"><%= AssemblyInfo.DXEmailInfo %></a>
                                    </div>
                                    <div class="text-block">
                                        <a href="<%= AssemblyInfo.DXLinkTrial %>" target="_blank">Download your free 30-day trial today.</a>
                                    </div>--%>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </div>
                    <dx:ASPxHiddenField runat="server" ID="HiddenField" ClientInstanceName="HiddenField"></dx:ASPxHiddenField>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxGlobalEvents runat="server">
            <ClientSideEvents ControlsInitialized="onControlsInit" />
        </dx:ASPxGlobalEvents>
        <asp:SqlDataSource ID="SqlDataPSAUStay" runat="server" ConnectionString='<%$ ConnectionStrings:psauStayConnectionString %>' SelectCommand="SELECT * FROM [Room_Features]"></asp:SqlDataSource>
    </form>
</body>
</html>
