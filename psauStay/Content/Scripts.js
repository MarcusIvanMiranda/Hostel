/// <reference path="jquery-1.11.1.min.js"/>
(function() {
    function showPage(page, params, skipHistory) {
        var queryString = getQueryString(params || {});

        HiddenField.Set("page", page);
        HiddenField.Set("parameters", queryString);

        hideMenu();
        var uri = queryString.length ? (page + "?" + queryString) : page;
        try {
            if (!skipHistory && window.history && window.history.pushState)
                window.history.pushState(uri, "", uri || "Default.aspx");
        } catch (e) { }
        MainCallbackPanel.PerformCallback(uri);
    }

    /* Index Page */
    window.onMainMenuItemClick = function(s, e) {
        switch (e.item.name) {
            case "login":
                hideMenu();
                setTimeout(function() { LoginPopup.ShowAtElementByID("MainCallbackPanel_ContentPane"); }, 300);
                break;
            case "offers":
                showPage("SpecialOffers", {});
                break;
            default:
                hideMenu();
                setTimeout(function() { showAboutWindow(); }, 300);
                break;
        }
    };
    window.onLoginButtonClick = function(s, e) {
        if (!ASPxClientEdit.ValidateGroup("Login"))
            return;

        LoginPopup.Hide();
        showAboutWindow();
    };
    window.onSearchButtonClick = function() {
        if (ASPxClientEdit.ValidateGroup("DateEditors")) {
            showPage("ShowHotels", {
                location: SearchComboBox.GetValue(),
                checkin: getFormattedDate(CheckInDateEdit.GetValue()),
                checkout: getFormattedDate(CheckOutDateEdit.GetValue()),
                rooms: RoomsNumberSpinEdit.GetValue() || 1,
                adults: AdultsNumberSpinEdit.GetValue() || 1,
                children: ChildrenNumberSpinEdit.GetValue() || 0
            });
        }
    };
    window.onSearchComboBoxIndexChanged = function(s, e) {
        hideMenu();
        $("#IndexContent").addClass("search-extend");
        SearchButton.AdjustControl();
    };
    window.onIndexOfferCloseClick = function(index) {
        var panel = window["OfferDockPanel" + index];
        var sibPanel = window["OfferDockPanel" + (index == 1 ? 2 : 1)];
        panel.Hide();
        sibPanel.MakeFloat();
        sibPanel.SetWidth(OffersZone.GetWidth());
        sibPanel.Dock(OffersZone);
    };
    window.onLogoClick = function() {
        showPage("", null, false);
    };

    /* Header */
    window.onMenuNavButtonCheckedChanged = function(s, e) {
        var mainContainer = MainCallbackPanel.GetMainElement();
        if (s.GetChecked()) {
            BackSlider.Pause();
            showMenu();
        }
        else {
            hideMenu();
            BackSlider.Play();
        }
    };
    window.onBackNavButtonClick = function(s, e) {
        var params = getCurrentQueryParams();
        switch (getCurrentPage()) {
            case "PrintInvoice":
                showPage("Booking", params, false);
                break;
            case "Booking":
                if (BookingPageControl.GetActiveTabIndex() > 0)
                    BookingPageControl.SetActiveTabIndex(BookingPageControl.GetActiveTabIndex() - 1);
                else
                    showPage("ShowRooms", params, false);
                break;
            case "ShowRooms":
                showPage("ShowHotels", params, false);
                break;
            case "ShowDetails":
                showPage("ShowHotels", params, false);
                break;
            case "ShowHotels":
            case "SpecialOffers":
                showPage("", null, false);
                break;
        }
    };

    /* ShowHotels */
    window.updateSearchResults = function() {
        var params = getCurrentQueryParams();
        params["location"] = LocationComboBox.GetValue();
        params["minprice"] = NightyRateTrackBar.GetPositionStart();
        params["maxprice"] = NightyRateTrackBar.GetPositionEnd();
        params["custrating"] = CustomerRatingTrackBar.GetPosition();
        params["ourrating"] = OurRatingCheckBoxList.GetSelectedValues().join(",");
        showPage("ShowHotels", params);
    };
    window.onBookHotelButtonClick = function(hotelID) {
        var queryParams = getCurrentQueryParams();
        queryParams["hotelID"] = hotelID;
        showPage("ShowRooms", queryParams);
    };
    window.onDetailsHotelButtonClick = function(hotelID) {
        var queryParams = getCurrentQueryParams();
        queryParams["hotelID"] = hotelID;
        showPage("ShowDetails", queryParams);
    };
    window.onShowStartFilterButtonClick = function(s, e) {
        StartFilterPopupControl.ShowAtElementByID("MainCallbackPanel_ContentPane");
    };
    window.onChangeStartFilterButtonClick = function(s, e) {
        if (ASPxClientEdit.ValidateGroup("DateEditors")) {
            var params = getCurrentQueryParams();
            params["checkin"] = getFormattedDate(CheckInDateEdit.GetValue());
            params["checkout"] = getFormattedDate(CheckOutDateEdit.GetValue());
            params["rooms"] = RoomsNumberSpinEdit.GetValue() || 1;
            params["adults"] = AdultsNumberSpinEdit.GetValue() || 1;
            params["children"] = ChildrenNumberSpinEdit.GetValue() || 0;
            StartFilterPopupControl.Hide();
            showPage(HiddenField.Get("page"), params);
        }
    };

    /* ShowRooms */
    window.onBookRoomButtonClick = function(roomID) {
        var params = getCurrentQueryParams();
        params["roomID"] = roomID;
        showPage("Booking", params);
    };
    window.onShowRoomsButtonClick = function() {
        var queryParams = getCurrentQueryParams();
        showPage("ShowRooms", queryParams);
    };
    window.onShowDetailsButtonClick = function() {
        var queryParams = getCurrentQueryParams();
        showPage("ShowDetails", queryParams);
    };

    window.onRoomImageNavItemClick = function(roomID, pictureName) {
        setTimeout(function() {
            ImagePopupControl.PerformCallback(roomID + "|" + pictureName);
            ImagePopupControl.ShowAtElementByID("MainCallbackPanel_ContentPane");
        }, 500);
    };
    window.onRoomsNavBarExpandedChanged = function(s, e) {
        ASPxClientControl.GetControlCollection().AdjustControls(s.GetMainElement());
    };

    /* Booking */
    window.onNextBookingStepButtonClick = function(step) {
        var valid = true;
        var validationGroup = "";
        if (step == 1)
            validationGroup = "Account";
        if (step == 2)
            validationGroup = "RoomDetails";
        if (step == 3)
            validationGroup = "PaymentDetails";

        switch (step) {
            case 1:
                valid = ASPxClientEdit.ValidateEditorsInContainer(BookingPageControl.GetMainElement(), "Account");
                if (valid) {
                    EmailTextBox.SetValue(AccountEmailTextBox.GetValue());
                    CreditCardEmailTextBox.SetValue(AccountEmailTextBox.GetValue());
                    showPage("Booking", getCurrentQueryParams());
                    return;
                }
                break;
            case 2:
                valid = ASPxClientEdit.ValidateEditorsInContainer(BookingPageControl.GetMainElement(), "RoomDetails");
                EmailTextBox.SetValue(AccountEmailTextBox.GetValue());
                break;
            case 3:
                var paymentType = PaymentTypePageControl.GetActiveTabIndex();
                if (paymentType == 0)
                    valid = ASPxClientEdit.ValidateEditorsInContainer(BookingPageControl.GetMainElement(), "CreditCard");
                else if (paymentType == 1)
                    valid = ASPxClientEdit.ValidateEditorsInContainer(BookingPageControl.GetMainElement(), "Cash");
                else if (paymentType == 2)
                    valid = ASPxClientEdit.ValidateEditorsInContainer(BookingPageControl.GetMainElement(), "PayPal");
                break;
        }
        if (valid) {
            BookingPageControl.GetTab(step).SetEnabled(true);
            BookingPageControl.SetActiveTabIndex(step);
        }
    };
    window.onAccountCaptchaHiddenFieldInit = function(s, e) {
        if (s.Get("IsCaptchaValid")) {
            BookingPageControl.GetTab(1).SetEnabled(true);
            BookingPageControl.SetActiveTabIndex(1);
        }
    };
    window.onFinishBookingStepButtonClick = function() {
        showAboutWindow();
    };
    window.OnPrintInvoiceButtonClick = function() {
        showPage("PrintInvoice", getCurrentQueryParams());
    };
    window.onOfferClick = function(offerID) {
        OfferFormPopup.SetContentHtml("");
        OfferFormPopup.PerformCallback(offerID);
        var panel = window["DockPanel" + offerID];
        var panelElement = panel.GetMainElement();
        if (panelElement.offsetWidth < 330 || panelElement.offsetHeight < 250) {
            OfferFormPopup.popupHorizontalAlign = "Center";
            OfferFormPopup.popupVerticalAlign = "Middle";
            OfferFormPopup.SetWidth(400);
            OfferFormPopup.SetHeight(280);
            OfferFormPopup.ShowAtElementByID("SpecialOffersContainer");
        }
        else {
            OfferFormPopup.popupHorizontalAlign = "LeftSides";
            OfferFormPopup.popupVerticalAlign = "TopSides";
            OfferFormPopup.SetWidth(panelElement.offsetWidth);
            OfferFormPopup.SetHeight(panelElement.offsetHeight);
            OfferFormPopup.ShowAtElement(panelElement);
        }
    };
    window.onSpecialOfferCheckButtonClick = function(hotelID, locationID) {
        if (ASPxClientEdit.ValidateGroup("DateEditors")) {
            var queryParams = {
                location: locationID,
                hotelID: hotelID,
                checkin: getFormattedDate(CheckInDateEdit.GetValue()),
                checkout: getFormattedDate(CheckOutDateEdit.GetValue()),
                rooms: RoomsSpinEdit.GetValue() || 1,
                adults: AdultsSpinEdit.GetValue() || 1,
                children: ChildrenSpinEdit.GetValue() || 0
            };
            showPage("ShowRooms", queryParams);
        }
    };
    window.onSpecialOfferClose = function(index, evt) {
        showAboutWindow();
        jQuery.event.fix(evt).stopPropagation();
    };

    window.onIndexOfferClick = function() {
        showPage("SpecialOffers", {});
    };

    /* Utils */
    window.onControlsInit = function() {
        ASPxClientUtils.AttachEventToElement(window, 'popstate', onHistoryPopState);
        var pathParts = document.location.href.split("/");
        var url = pathParts[pathParts.length - 1];
        try {
            if (window.history)
                window.history.replaceState(url, "");
        } catch(e) {}
        ASPxClientUtils.AttachEventToElement(window, "resize", onWindowResize);
        if(ASPxClientUtils.iOSPlatform) { // fix iOS height=100% bug
            $("form :input").blur(function() {
                $('html, body').animate({ scrollTop: 0 }, 0);
            });
        }
    };
    window.updateRatingLabels = function(ratingControl) {
        var prefix = ratingControl.cpLabelPrefix || "";
        if (ratingControl.cpLeftLabelID) {
            $("#" + ratingControl.cpLeftLabelID).html(prefix + ratingControl.GetPositionStart());
            $("#" + ratingControl.cpRightLabelID).html(prefix + ratingControl.GetPositionEnd());
        }
        else
            $("#" + ratingControl.cpRightLabelID).html(prefix + ratingControl.GetPosition());
    };
    window.preventEditorFocus = function() { };
    window.onAboutWindowCloseUp = function() {
        $(MainCallbackPanel.GetMainElement()).removeClass("show-about");
    };
    window.onRatingControlItemClick = function(s, e) {
        HotelDetailsCallbackPanel.PerformCallback(s.GetValue());
    };
    window.onInputKeyDown = function(s, e) {
        var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
        if (keyCode == 13) {
            jQuery.event.fix(e.htmlEvent).preventDefault();
            s.GetInputElement().blur();
        }
    };
    
    tileLayout.isEnabled = function() {
        return getCurrentPage() == "SpecialOffers";
    };

    function getCurrentPage() {
        var hfPage = HiddenField.Get("page");
        if(hfPage)
            return hfPage;
        var pathParts = document.location.pathname.split("/");
        return pathParts[pathParts.length - 1];
    };
    function showAboutWindow() {
        $(MainCallbackPanel.GetMainElement()).addClass("show-about");
        AboutWindow.ShowAtElementByID("MainCallbackPanel_ContentPane");
    }

    function hideMenu() {
        LeftPanel.Collapse();
        if (window["MenuButton"] && MenuButton.GetMainElement() && MenuButton.GetChecked())
            MenuButton.SetChecked(false);
    }

    function showMenu() {
        LeftPanel.Expand();
    }

    var _resizeSpecialOffersTimeoutID = -1;
    function onWindowResize() {
        switch (HiddenField.Get("page")) {
            case "SpecialOffers":
                if (_resizeSpecialOffersTimeoutID == -1)
                    _resizeSpecialOffersTimeoutID = setTimeout(resizeSpecialOffers, 200);
                break;
        }
        hidePopups("AboutWindow", "StartFilterPopupControl", "LoginPopup", "OfferFormPopup", "ImagePopupControl");
    }
    function hidePopups() {
        for (var i = 0; i < arguments.length; i++) {
            var name = arguments[i];
            if (window[name] && window[name].IsVisible())
                window[name].Hide();
        }
    }
    function resizeSpecialOffers() {
        for (var i = 1; i <= 4; i++) {
            var panel = window["DockPanel" + i];
            if (panel && panel.IsVisible()) {
                var zone = panel.GetOwnerZone();
                zone.SetWidth(zone.GetMainElement().parentNode.offsetWidth)
            }
        }
        tileLayout.updateZoneDimensionsCache();
        _resizeSpecialOffersTimeoutID = -1;
    }

    function getFormattedDate(date) {
        return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
    }
    function getCurrentQueryParams() {
        var hfParams = HiddenField.Get("parameters");
        if(hfParams)
            return getParamsByQueryString(hfParams);
        var query = document.location.search;
        if (query[0] === "?")
            query = query.substr(1);
        return getParamsByQueryString(query);
    }
    function getQueryString(params) {
        var queryItems = [];
        for (var key in params) {
            if (!params.hasOwnProperty(key)) continue;
            queryItems.push(key + "=" + params[key]);
        }
        if (queryItems.length > 0)
            return queryItems.join("&");
        return "";
    }
    function getParamsByQueryString(queryString) {
        var result = {};
        if (queryString) {
            queryString = queryString.split("&");
            for (var i = 0; i < queryString.length; i++) {
                var part = queryString[i].split('=');
                if (part.length != 2) continue;
                result[part[0]] = decodeURIComponent(part[1].replace(/\+/g, " "));
            }
        }
        return result;
    };
    function onHistoryPopState(evt) {
        if (evt.state !== null && evt.state !== undefined) {
            var uriParts = evt.state.split("?");
            showPage(uriParts[0], getParamsByQueryString(uriParts[1]), true);
        }
    }

    Date.prototype.addDays = function(days) {
        var dat = new Date(this.valueOf());
        dat.setDate(dat.getDate() + days);
        return dat;
    }
})();