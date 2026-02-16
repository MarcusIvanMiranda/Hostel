<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StartFilter.ascx.cs" Inherits="UserControls_StartFilter" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<dx:ASPxPopupControl ID="StartFilterPopupControl" ClientInstanceName="StartFilterPopupControl" CssClass="start-filter-popup popup" runat="server" Modal="true"
        PopupVerticalAlign="Middle" PopupHorizontalAlign="Center" ShowHeader="False" Width="658px" Height="358px" PopupAnimationType="Fade">
    <ModalBackgroundStyle CssClass="modal-bg" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxFormLayout ID="StartFilterFormLayout" runat="server" ColCount="3" CssClass="form-layout" RequiredMarkDisplayMode="None">
                    <Styles>
                        <LayoutItem CssClass="item">
                            <Caption CssClass="caption"></Caption>
                        </LayoutItem>
                    </Styles>
                    <Items>
                        <dx:LayoutItem Caption="CHECK IN">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxDateEdit ID="CheckInDateEdit" ClientInstanceName="CheckInDateEdit" runat="server"
                                        Width="250px" Height="50px" Font-Size="24px">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
                                        <DropDownButton Width="38px">
                                            <Image Url="~/Content/Images/DateEditPopOut.png"></Image>
                                        </DropDownButton>
                                        <ButtonStyle HoverStyle-BackColor="Transparent">
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                        <CalendarProperties ShowWeekNumbers="false">
                                            <MonthGridPaddings PaddingLeft="30px" PaddingRight="30px" PaddingTop="15px" PaddingBottom="10px" />
                                            <Style Font-Size="14px"></Style>
                                        </CalendarProperties>
                                        <ValidationSettings  ValidationGroup="DateEditors" ErrorDisplayMode="None" SetFocusOnError="true" ValidateOnLeave="False">
                                            <RequiredField IsRequired="True"></RequiredField>
                                        </ValidationSettings>
                                        <InvalidStyle>
                                            <Border BorderColor="red"></Border>
                                        </InvalidStyle>
                                    </dx:ASPxDateEdit>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="CHECK OUT" ColSpan="2">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxDateEdit ID="CheckOutDateEdit" ClientInstanceName="CheckOutDateEdit" runat="server"
                                        Width="250px" Height="50px" Font-Size="24px">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
                                        <DropDownButton Width="38px">
                                            <Image Url="~/Content/Images/DateEditPopOut.png"></Image>
                                        </DropDownButton>
                                        <ButtonStyle HoverStyle-BackColor="Transparent">
                                            <HoverStyle BackColor="Transparent"></HoverStyle>
                                        </ButtonStyle>
                                        <CalendarProperties ShowWeekNumbers="false">
                                            <MonthGridPaddings PaddingLeft="30px" PaddingRight="30px" PaddingTop="15px" PaddingBottom="10px" />
                                            <Style Font-Size="14px"></Style>
                                        </CalendarProperties>
                                        <ValidationSettings  ValidationGroup="DateEditors" ErrorDisplayMode="None" SetFocusOnError="true" ValidateOnLeave="False">
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
                        <dx:LayoutItem Caption="ROOMS">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxSpinEdit ID="RoomsNumberSpinEdit" ClientInstanceName="RoomsNumberSpinEdit" runat="server"
                                        Number="1" Width="250px" Height="50px" MinValue="1" MaxValue="5" LargeIncrement="1" Font-Size="24px">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
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
                        <dx:LayoutItem Caption="ADULTS">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxSpinEdit ID="AdultsNumberSpinEdit" ClientInstanceName="AdultsNumberSpinEdit" runat="server"
                                        Number="1" MinValue="1" MaxValue="5" Width="117px" Height="50px" LargeIncrement="1" Font-Size="24px">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
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
                        <dx:LayoutItem Caption="CHILDREN">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxSpinEdit ID="ChildrenNumberSpinEdit" ClientInstanceName="ChildrenNumberSpinEdit" runat="server"
                                        Number="0" Width="117px" Height="50px" LargeIncrement="1" Font-Size="24px" MinValue="0" MaxValue="5">
                                        <ClientSideEvents GotFocus="preventEditorFocus" KeyDown="onInputKeyDown" />
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
                        <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                        <dx:LayoutItem Caption=" " ColSpan="3">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxButton ID="ChangeButton" runat="server" Text="Change" Width="516px" Height="70px" CssClass="button button-large"
                                        Font-Size="36px" AutoPostBack="false">
                                        <ClientSideEvents Click="onChangeStartFilterButtonClick" />
                                    </dx:ASPxButton>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                    </Items>
                    <SettingsItemCaptions Location="Top" />
                </dx:ASPxFormLayout>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
