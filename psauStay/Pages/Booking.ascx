<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Booking.ascx.cs" Inherits="UserControls_Booking" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraReports.v17.1.Web" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<div class="wrapper-relative">
    <div class="booking-summary">
        <div class="hotel-info">
            <div class="common">
                <dx:ASPxImage ID="SummaryHotelImage" CssClass="picture" runat="server" ShowLoadingImage="true">
                </dx:ASPxImage>
                <h5><%= SearchState.Hotel.Hotel_Name %></h5>
                <span class="address"><%= SearchState.Hotel.Address %><br /><%= SearchState.Hotel.DetailsCity %></span>
                <div class="clear album-clear"></div>
            </div>
            <div class="dates">
                <div class="date-container">
                    Check in<br />
                    <span class="date"><%= SearchState.CheckInDate.ToString("MMMM dd, yyyy") %></span>
                </div>
                <div class="date-container">
                    Check out<br />
                    <span class="date"><%= SearchState.CheckOutDate.ToString("MMMM dd, yyyy") %></span>
                </div>
            </div>
        </div>
        <div class="room-info">
            <h5><%= SearchState.Room.Room_Types.Type_Name %></h5>
            <dx:ASPxDataView runat="server" ID="RoomFeaturesDataView" CssClass="features-data-view" ItemSpacing="6px">
                <ContentStyle CssClass="content"></ContentStyle>
                <SettingsTableLayout ColumnCount="2" RowsPerPage="3" />
                <ItemStyle Width="148px" Height="22px" CssClass="item" />
                <PagerSettings Visible="false"></PagerSettings>
                <ItemTemplate>
                    <dx:ASPxImage runat="server" CssClass="feature-img" ImageAlign="Middle" ID="RoomFeatureIcon" ImageUrl='<%# Eval("ImageUrl") %>'></dx:ASPxImage>
                    <div class="feature-description"><%# Eval("Description") %></div>
                </ItemTemplate>
            </dx:ASPxDataView>
        </div>
        <div class="price-info">
            <table class="price-block">
                <asp:Repeater runat="server" ID="PriceRepeater">
                    <ItemTemplate>
                        <tr class="price-day">
                            <td class="period"><%# Eval("Period") %></td>
                            <td class="price"><%# Eval("Price", "{0:C}") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <tr class="price-result">
                    <td class="period">TOTAL</td>
                    <td class="price"><%= string.Format("{0:C}", SearchState.Room.Nighly_Rate.Value * SearchState.NightsCount) %></td>
                </tr>
            </table>
            <div class="small-price-block">
                TOTAL<br />
                <span class="price">
                    <%= string.Format("{0:C}", SearchState.Room.Nighly_Rate.Value * SearchState.NightsCount) %>
                </span>
            </div>
        </div>
        <div class="print-container">
            <dx:ASPxButton runat="server" ID="PrintInvoiceButton" Text="Print Invoice" CssClass="print-button" AutoPostBack="false">
                <HoverStyle CssClass="button-white-hover"></HoverStyle>
                <ClientSideEvents Click="OnPrintInvoiceButtonClick" />
            </dx:ASPxButton>
            <dx:ASPxButton runat="server" ID="PrintInvoiceButton_Portait" Text="Print Invoice" CssClass="print-button-portrait"
                Width="110px" Height="80px" AutoPostBack="false">
                <HoverStyle CssClass="button-white-hover"></HoverStyle>
                <ClientSideEvents Click="OnPrintInvoiceButtonClick" />
            </dx:ASPxButton>
        </div>
    </div>
    <div class="booking-content">
        <div class="wrapper-scroll" style="overflow-x: hidden">
            <dx:ASPxPageControl ID="BookingPageControl" ClientInstanceName="BookingPageControl" runat="server" CssClass="wizard-tab-control"
                ActiveTabIndex="0" TabAlign="Center" Width="100%" Height="100%">
                <ContentStyle CssClass="wizard-tab-content">
                    <BorderTop BorderWidth="1px" BorderStyle="Solid" BorderColor="#d9d9d9" />
                </ContentStyle>
                <TabStyle CssClass="wizard-tab">
                    <BorderBottom BorderColor="#d9d9d9" BorderStyle="Solid" BorderWidth="1px" />
                </TabStyle>
                <ActiveTabStyle BackColor="Transparent">
                </ActiveTabStyle>
                <TabPages>
                    <dx:TabPage Text="" Name="1">
                        <TabImage Url="~/Content/Images/Booking-1.png" UrlDisabled="~/Content/Images/Booking-D1.png"></TabImage>
                        <ActiveTabImage Url="~/Content/Images/Booking-A1.png"></ActiveTabImage>
                        <ContentCollection>
                            <dx:ContentControl runat="server">
                                <div class="comment">Already have a DX Hotels account? Login below.</div>
                                <dx:ASPxFormLayout ID="AccountFormLayout" runat="server" CssClass="form-layout" RequiredMarkDisplayMode="None">
                                    <Styles>
                                        <LayoutItem CssClass="item"></LayoutItem>
                                    </Styles>
                                    <Items>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="AccountEmailTextBox" ClientInstanceName="AccountEmailTextBox" NullText="Email" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Height="40px" Width="328px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Account" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RegularExpression ErrorText="" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="AccountPasswordTextBox" Password="true" NullText="Password" NullTextDisplayMode="UnfocusedAndFocused" Height="40px" runat="server" Width="328px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Account" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:EmptyLayoutItem Height="15px">
                                        </dx:EmptyLayoutItem>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxCaptcha ID="AccountCaptcha" ClientInstanceName="AccountCaptcha" runat="server" CssClass="captcha" Width="100%" OnLoad="AccountCaptcha_Load">
                                                        <ValidationSettings ValidationGroup="Account" ErrorDisplayMode="None" Display="Dynamic"></ValidationSettings>
                                                        <RefreshButton Visible="false" />
                                                        <TextBox Visible="false" />
                                                        <ChallengeImage Width="328"></ChallengeImage>
                                                        <RefreshButton Position="Right"></RefreshButton>
                                                    </dx:ASPxCaptcha>
                                                    <dx:ASPxHiddenField runat="server" ID="AccountCaptchaHiddenField" ClientInstanceName="AccountCaptchaHiddenField">
                                                        <ClientSideEvents Init="onAccountCaptchaHiddenFieldInit" />
                                                    </dx:ASPxHiddenField>
                                                    <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/captcha-refresh.png" CssClass="captcha-refresh-img">
                                                        <ClientSideEvents Click="function() { AccountCaptcha.Refresh(); }" />
                                                    </dx:ASPxImage>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="AccountCaptchaEditor" Height="40px" runat="server" Width="328px" CssClass="editor" NullText="Enter the verification code above to proceed…" NullTextDisplayMode="UnfocusedAndFocused">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Account" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:EmptyLayoutItem Height="15px">
                                        </dx:EmptyLayoutItem>
                                        <dx:LayoutItem Width="120px" HorizontalAlign="Right">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxButton runat="server" ID="ASPxButton3" Text="Next Step" AutoPostBack="false" Height="40px" Width="120px"
                                                        ValidationGroup="Account" CssClass="button">
                                                        <ClientSideEvents Click="function() { onNextBookingStepButtonClick(1); }" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                    <SettingsItems ShowCaption="False" />
                                </dx:ASPxFormLayout>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="" Name="2" ClientEnabled="false">
                        <TabImage Url="~/Content/Images/Booking-2.png" UrlDisabled="~/Content/Images/Booking-D2.png"></TabImage>
                        <ActiveTabImage Url="~/Content/Images/Booking-A2.png"></ActiveTabImage>
                        <ContentCollection>
                            <dx:ContentControl runat="server">
                                <div class="room-info">
                                    <h3><%= SearchState.Room.Room_Types.Type_Name %></h3>
                                    <div class="request-info">
                                        <div class="info-item">
                                            <h5><%= SearchState.RoomsCount %></h5>
                                            Rooms
                                        </div>
                                        <div class="info-item">
                                            <h5><%= SearchState.AdultsCount %></h5>
                                            Adults
                                        </div>
                                        <div class="info-item">
                                            <h5><%= SearchState.ChildrenCount %></h5>
                                            Children
                                        </div>
                                    </div>
                                </div>
                                <div class="room-comment">
                                    Please give us the name of one of the people<br />
                                    staying in this room.
                                </div>
                                <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" CssClass="form-layout" EncodeHtml="false"
                                    ShowItemCaptionColon="false" RequiredMarkDisplayMode="None">
                                    <Styles>
                                        <LayoutItem CssClass="item" />
                                    </Styles>
                                    <Items>
                                        <dx:LayoutItem ShowCaption="False">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="FirstNameTextBox" runat="server" Width="328px" NullText="First Name" NullTextDisplayMode="UnfocusedAndFocused" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="RoomDetails" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="False">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="LastNameTextBox" runat="server" Width="328px" NullText="Last Name" NullTextDisplayMode="UnfocusedAndFocused" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="RoomDetails" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="False">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="EmailTextBox" ClientInstanceName="EmailTextBox" runat="server" Width="328px" NullText="Email" NullTextDisplayMode="UnfocusedAndFocused" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="RoomDetails" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RegularExpression ErrorText="" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="False" Width="120px" HorizontalAlign="Right">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxButton runat="server" ID="ASPxButton1" Text="Next Step" AutoPostBack="false"
                                                        CssClass="button" Height="40px" Width="120px" ValidationGroup="RoomDetails">
                                                        <ClientSideEvents Click="function() { onNextBookingStepButtonClick(2); }" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="" Name="3" ClientEnabled="false">
                        <TabImage Url="~/Content/Images/Booking-3.png" UrlDisabled="~/Content/Images/Booking-D3.png"></TabImage>
                        <ActiveTabImage Url="~/Content/Images/Booking-A3.png"></ActiveTabImage>
                        <ContentCollection>
                            <dx:ContentControl runat="server">
                                <dx:ASPxPageControl runat="server" ID="PaymentTypePageControl" ClientInstanceName="PaymentTypePageControl" Width="100%" Height="100%"
                                    TabAlign="Center" CssClass="payment-tabcontrol">
                                    <ActiveTabStyle CssClass="active-tab">
                                        <BorderBottom BorderStyle="None" />
                                    </ActiveTabStyle>
                                    <TabStyle CssClass="tab" />
                                    <ContentStyle CssClass="tab-content">
                                        <BorderTop BorderWidth="1px" BorderColor="#d9d9d9" />
                                    </ContentStyle>
                                    <TabPages>
                                        <dx:TabPage Text="Credit Card">
                                            <ContentCollection>
                                                <dx:ContentControl>
                                                    <div class="card-types">
                                                        We accept the following payment methods<br />
                                                        <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/card_visa.png">
                                                        </dx:ASPxImage>
                                                        <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/card_ax.png">
                                                        </dx:ASPxImage>
                                                        <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/card_master.png">
                                                        </dx:ASPxImage>
                                                    </div>
                                                    <dx:ASPxFormLayout ID="CreditCardFormLayout" CssClass="form-layout" runat="server" ColCount="2" RequiredMarkDisplayMode="None">
                                                        <Styles>
                                                            <LayoutItem CssClass="item"></LayoutItem>
                                                        </Styles>
                                                        <Items>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="CreditCardNameTextBox" NullText="Name" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="328px" Height="40px" CssClass="editor">
                                                                            <ClientSideEvents KeyDown="onInputKeyDown" />
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="CreditCardEmailTextBox" ClientInstanceName="CreditCardEmailTextBox" NullText="Email" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="328px" Height="40px" CssClass="editor">
                                                                            <ClientSideEvents KeyDown="onInputKeyDown" />
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RegularExpression ErrorText="" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="CreditCardNumberTextBox" NullText="Card #" runat="server" Width="328px" Height="40px" CssClass="editor">
                                                                            <ClientSideEvents KeyDown="onInputKeyDown" />
                                                                            <MaskSettings Mask="0000 0000 0000 0009" IncludeLiterals="None" PromptChar=" " />
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="CreditCardPasswordTextBox" NullText="CVV" runat="server"
                                                                            Width="328px" Height="40px" CssClass="editor">
                                                                            <MaskSettings Mask="0009" PromptChar=" "  />
                                                                            <ClientSideEvents KeyDown="onInputKeyDown" />
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:EmptyLayoutItem ColSpan="2" Height="14px">
                                                            </dx:EmptyLayoutItem>
                                                            <dx:LayoutItem Caption="Exp. Date" CaptionSettings-VerticalAlign="Middle">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="CreditCardMonthComboBox" runat="server" NullText="Month" NullTextDisplayMode="UnfocusedAndFocused" Height="40px" Width="125px"
                                                                            ValueField="Key" TextField="Value" DataSourceID="MonthsDataSource" CssClass="editor">
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                            <DropDownButton>
                                                                                <Image Url="~/Content/Images/dropdown-s.png"></Image>
                                                                            </DropDownButton>
                                                                            <ListBoxStyle Font-Size="14px"></ListBoxStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                                <CaptionSettings VerticalAlign="Middle"></CaptionSettings>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="CreditCardYearComboBox" NullText="Year" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Height="40px" Width="125px"
                                                                            DataSourceID="CardExpiredYearsDataSource" CssClass="editor">
                                                                            <ValidationSettings ValidationGroup="CreditCard" ErrorDisplayMode="None" Display="Dynamic">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                            <DropDownButton>
                                                                                <Image Url="~/Content/Images/dropdown-s.png"></Image>
                                                                            </DropDownButton>
                                                                            <ListBoxStyle Font-Size="14px"></ListBoxStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ShowCaption="False" ColSpan="2" HorizontalAlign="Right" Width="120px">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxButton runat="server" ID="NextStepButton" Text="Next Step" AutoPostBack="false"
                                                                            CssClass="button" Height="40px" Width="120px" ValidationGroup="CreditCard">
                                                                            <ClientSideEvents Click="function() { onNextBookingStepButtonClick(3); }" />
                                                                        </dx:ASPxButton>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:ASPxFormLayout>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>
                                        <dx:TabPage Text="PayPal">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <div class="comment">
                                                        Thank you for visiting our website. At present, we do not accept PayPal payments.
                                                    </div>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>
                                    </TabPages>
                                </dx:ASPxPageControl>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="" Name="4" ClientEnabled="false">
                        <TabImage Url="~/Content/Images/Booking-4.png" UrlDisabled="~/Content/Images/Booking-D4.png"></TabImage>
                        <ActiveTabImage Url="~/Content/Images/Booking-A4.png"></ActiveTabImage>
                        <ContentCollection>
                            <dx:ContentControl runat="server">
                                <dx:ASPxFormLayout ID="BillingFormLayout" CssClass="form-layout" runat="server" ColCount="2" RequiredMarkDisplayMode="None">
                                    <Styles>
                                        <LayoutItem CssClass="item" />
                                    </Styles>
                                    <Items>
                                        <dx:LayoutItem ColSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="BillingAddressTextBox" NullText="Address" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="328px" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Billing" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ColSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="BillingCityTextBox" NullText="City" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="328px" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Billing" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxComboBox ID="BillingStateComboBox" NullText="State" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="112px" Height="40px" CssClass="editor"
                                                        DataSourceID="StatesDataSource">
                                                        <ValidationSettings ValidationGroup="Billing" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                        <ListBoxStyle Font-Size="14px"></ListBoxStyle>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem>
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="BillingZipCodeTextBox" NullText="Zip Code" NullTextDisplayMode="UnfocusedAndFocused" runat="server" Width="200px" Height="40px" CssClass="editor">
                                                        <ClientSideEvents KeyDown="onInputKeyDown" />
                                                        <ValidationSettings ValidationGroup="Billing" ErrorDisplayMode="None" Display="Dynamic">
                                                            <RequiredField IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ColSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxCheckBox ID="BillingCreateAccountCheckBox" runat="server" CssClass="editor" CheckState="Unchecked" Text="Please create an account">
                                                    </dx:ASPxCheckBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="False" ColSpan="2" HorizontalAlign="Right" Width="120px">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxButton runat="server" ID="ASPxButton2" Text="Finish" AutoPostBack="false" CssClass="button"
                                                        Height="40px" Width="120px" ValidationGroup="CreditCard">
                                                        <ClientSideEvents Click="function() { onFinishBookingStepButtonClick(); }" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                    <SettingsItems ShowCaption="False" />
                                </dx:ASPxFormLayout>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                </TabPages>
            </dx:ASPxPageControl>
        </div>
    </div>
</div>
<asp:ObjectDataSource ID="MonthsDataSource" runat="server" SelectMethod="GetMonths" TypeName="DataProvider"></asp:ObjectDataSource>
<asp:ObjectDataSource ID="CardExpiredYearsDataSource" runat="server" SelectMethod="GetCardExpiredYears" TypeName="DataProvider"></asp:ObjectDataSource>
<asp:ObjectDataSource ID="StatesDataSource" runat="server" SelectMethod="GetStates" TypeName="DataProvider"></asp:ObjectDataSource>
<div class="booking-invoice" id="InvoicePanel" runat="server">
    <div class="wrapper-scroll">
        <dx:ASPxDocumentViewer ID="InvoiceDocumentViewer" runat="server" Width="100%" OnLoad="InvoiceDocumentViewer_Load">
        </dx:ASPxDocumentViewer>
    </div>
</div>
