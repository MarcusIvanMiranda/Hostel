<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ShowHotels.ascx.cs" Inherits="UserControls_ShowHotels" %>
<%@ Register Assembly="DevExpress.Web.v17.1" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Src="~/UserControls/StartFilter.ascx" TagPrefix="uc1" TagName="StartFilter" %>
<div class="wrapper-relative" id="content">
    <div class="results-options">
        <div class="wrapper-scroll">
            <div class="item-1">
                <div class="caption-cell">SEARCH BY CITY</div>
                <div class="control-cell">
                    <dx:ASPxComboBox ID="LocationComboBox" ClientInstanceName="LocationComboBox" runat="server" Width="100%" Height="30px" DataSourceID="LocationDataSource"
                        TextField="Area_Name" ValueField="ID" ValueType="System.Int32" Font-Size="14px">
                        <DropDownButton>
                            <Image Url="~/Content/Images/SearchPopOut_S.png"></Image>
                        </DropDownButton>
                    </dx:ASPxComboBox>
                </div>
            </div>
            <div class="item-2">
                <div class="caption-cell">NIGHTLY RATE</div>
                <div class="control-cell">
                    <div class="trackbar-container-lr">
                        <div id="NightyRateTrackBarLabel_L" class="trackbar-label-l">$100</div>
                        <div id="NightyRateTrackBarLabel_R" class="trackbar-label-r">$400</div>
                        <dx:ASPxTrackBar ID="NightyRateTrackBar" ClientInstanceName="NightyRateTrackBar" runat="server" Position="0" PositionStart="0" Step="1"
                            ShowChangeButtons="false" AllowRangeSelection="true" Width="100%" Height="25px" OnCustomJSProperties="NightyRateTrackBar_CustomJSProperties"
                            ValueToolTipPosition="None" CssClass="trackbar">
                            <MainDragHandleStyle CssClass="handle"></MainDragHandleStyle>
                            <SecondaryDragHandleStyle CssClass="handle"></SecondaryDragHandleStyle>
                            <ClientSideEvents Init="updateRatingLabels" PositionChanging="updateRatingLabels" PositionChanged="updateRatingLabels" />
                            <MainDragHandleImage Url="~/Content/Images/TrackBarHandle.png" Width="26px" Height="26px"></MainDragHandleImage>
                            <SecondaryDragHandleImage Url="~/Content/Images/TrackBarHandle.png" Width="26px" Height="26px"></SecondaryDragHandleImage>
                        </dx:ASPxTrackBar>
                    </div>
                </div>
            </div>
            <div class="item-3">
                <div class="caption-cell">CUSTOMER RATING</div>
                <div class="control-cell">
                    <div class="trackbar-container-r">
                        <div id="CustomerRatingTrackbarLabel_R" class="trackbar-label-r">$400</div>
                        <dx:ASPxTrackBar ID="CustomerRatingTrackBar" ClientInstanceName="CustomerRatingTrackBar" runat="server" Position="0" PositionStart="0"
                            Step="1" ShowChangeButtons="false" Width="100%" OnCustomJSProperties="CustomerRatingTrackBar_CustomJSProperties"
                            ValueToolTipPosition="None" MinValue="1" MaxValue="5" Height="25px" CssClass="trackbar">
                            <MainDragHandleStyle CssClass="handle"></MainDragHandleStyle>
                            <SecondaryDragHandleStyle CssClass="handle"></SecondaryDragHandleStyle>
                            <ClientSideEvents Init="updateRatingLabels" PositionChanging="updateRatingLabels" PositionChanged="updateRatingLabels" />
                            <MainDragHandleImage Url="~/Content/Images/TrackBarHandle.png" Width="26px" Height="26px"></MainDragHandleImage>
                        </dx:ASPxTrackBar>
                    </div>
                </div>
            </div>
            <div class="item-4">
                <div class="caption-cell">OUR RATING</div>
                <div class="control-cell">
                    <dx:ASPxCheckBoxList runat="server" ClientInstanceName="OurRatingCheckBoxList" ID="OurRatingCheckBoxList" ValueType="System.Int32" RepeatColumns="2">
                        <Paddings Padding="0" />
                        <Items>
                            <dx:ListEditItem ImageUrl="~/Content/Images/Star_S_1.png" Value="1" Text="" />
                            <dx:ListEditItem ImageUrl="~/Content/Images/Star_S_2.png" Value="2" Text="" />
                            <dx:ListEditItem ImageUrl="~/Content/Images/Star_S_3.png" Value="3" Text="" />
                            <dx:ListEditItem ImageUrl="~/Content/Images/Star_S_4.png" Value="4" Text="" />
                            <dx:ListEditItem ImageUrl="~/Content/Images/Star_S_5.png" Value="5" Text="" />
                        </Items>
                        <Border BorderStyle="None"></Border>
                    </dx:ASPxCheckBoxList>
                </div>
            </div>
            <ef:EntityDataSource ID="LocationDataSource" runat="server" ContextTypeName="HotelBookingContext.HotelBookingDataContext" EntitySetName="Metro_Areas" OrderBy="it.Area_Name" Select="it.ID, it.Area_Name">
            </ef:EntityDataSource>
        </div>
        <div class="button-container">
            <dx:ASPxButton runat="server" ID="FilterButton" Text="Apply" CssClass="search-button" AutoPostBack="false">
                <ClientSideEvents Click="updateSearchResults" />
                <HoverStyle CssClass="button-white-hover"></HoverStyle>
            </dx:ASPxButton>
        </div>
    </div>
    <div class="results-content" runat="server" id="ResultsPanel">
        <div class="wrapper-scroll">
            <dx:ASPxDataView runat="server" ID="SearchResultsDataView" CssClass="data-view" Width="100%">
                <ContentStyle Border-BorderStyle="None"></ContentStyle>
                <ItemStyle CssClass="results-item" />
                <SettingsTableLayout ColumnCount="1" />
                <PagerSettings ShowNumericButtons="False" EndlessPagingMode="OnScroll"></PagerSettings>
                <ItemTemplate>
                    <dx:ASPxImage runat="server" ID="HotelPicture" CssClass="picture"
                        ImageAlign="Left" ImageUrl='<%# Eval("PrimaryPicture.Url") %>'
                        ClientSideEvents-Click='<%# Eval("ID", "function() {{ onDetailsHotelButtonClick({0}); }}") %>'>
                    </dx:ASPxImage>
                    <div class="price">
                        STARTING FROM
                    <h4>
                        <%# string.Format("{0:C0}", Math.Truncate((decimal)Eval("StartPrice"))) %>
                    </h4>
                    </div>
                    <h2><a href="javascript:onDetailsHotelButtonClick(<%# Eval("ID") %>)"><%# Eval("Hotel_Name") %></a></h2>
                    <div class="grey address">
                        <%# Eval("Address") %><br />
                        <%# Eval("Cities.DisplayName") %>
                    </div>
                    <div class="description">
                        <%# Eval("Description") %>
                    </div>
                    <div class="parameters">
                        <span class="parameter">
                            <span class="grey">TYPE</span> <%# Eval("Hotel_Class") %> 
                        </span>
                        <span class="parameter">
                            <span class="grey">LOCATION</span> <%# Eval("Location_Rating") %> 
                        </span>
                        <span class="parameter" style="margin-right: 0">
                            <span class="grey">RATING</span> <%# Eval("RoundRating") %>
                        </span>
                        <dx:ASPxImage runat="server" ImageUrl="~/Content/Images/Star_S_1.png" ImageAlign="Middle"></dx:ASPxImage>
                    </div>
                    <div class="clear"></div>
                    <div class="rating grey">
                        CUSTOMER RATING
                    <dx:ASPxRatingControl runat="server" ID="CursomerRatingControl" ReadOnly="true" CssClass="cursomerRatingControl"
                        Value='<%# Convert.ToDecimal(Eval("Customer_Rating")) %>'>
                    </dx:ASPxRatingControl>
                    </div>
                    <div class="buttons">
                        <dx:ASPxButton runat="server" ID="DetailsButton" Text="Details" AutoPostBack="false" CssClass="details-button"
                            Height="40px" Width="110px" ClientSideEvents-Click='<%# Eval("ID", "function() {{ onDetailsHotelButtonClick({0}); }}") %>'>
                        </dx:ASPxButton>
                        <dx:ASPxButton runat="server" ID="BookItButton" Text="Book It" AutoPostBack="false" CssClass="book-button"
                            Height="40px" Width="110px" ClientSideEvents-Click='<%# Eval("ID", "function() {{ onBookHotelButtonClick({0}); }}") %>'>
                        </dx:ASPxButton>
                    </div>
                    <div class="clear"></div>
                </ItemTemplate>
            </dx:ASPxDataView>
        </div>
    </div>
    <div class="results-none" runat="server" visible="false" id="NoResultsPanel">
        <dx:ASPxImage runat="server" ID="NoResultsImage" ImageUrl="~/Content/Images/NoResults.png"></dx:ASPxImage>
        <br />
        No hotels meet the criteria you've specified.<br />
        Please modify your search criteria and try again.
    </div>
    <div class="results-footer">
        <dx:ASPxImage runat="server" ID="AreaMapImage" CssClass="map"></dx:ASPxImage>
        <h3><%= SearchState.Metro_Area.Area_Name %></h3>
        <div class="params"><%= SearchState.StartFilterText %></div>
        <dx:ASPxButton runat="server" ID="ShowStartFilterButton" CssClass="footerButton" Height="40px" AutoPostBack="false" BackColor="Transparent">
            <ClientSideEvents Click="onShowStartFilterButtonClick" />
            <Border BorderStyle="None" />
            <HoverStyle BackColor="Transparent"></HoverStyle>
            <Image Url="~/Content/Images/UpdateFooterFilter.png"></Image>
        </dx:ASPxButton>
    </div>
    <uc1:StartFilter runat="server" ID="StartFilter" />
</div>
