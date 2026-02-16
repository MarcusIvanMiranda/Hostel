(function() {
    window.tileLayout = {
        dragging: "stopped",
        onDockManagerInit: function() {
            zones = DockManager.GetZones();
            tileLayout.updateZoneDimensionsCache();
        },
        onStartPanelDragging: function(s, e) {
            if(!tileLayout.isEnabled()) return;
            tileLayout.dragging = "started";
            var panel = e.panel,
                prevZone = panel.GetOwnerZone();

            mouseMoveHandler = function(evt) {
                var zone = getZoneUnderCursor(evt);
                if (!zone)
                    return;
                var zonePanel = zone.GetPanelCount() > 0 && zone.GetPanels()[0];
                if (!zonePanel || zonePanel.panelUID === panel.panelUID)
                    return;
                dockPanelToVacantZone(zonePanel, zone);
                zone.ShowPanelPlaceholder(panel);
            };
            ASPxClientUtils.AttachEventToElement(document, getEventName(), mouseMoveHandler);
        },
        onAfterDock: function(s, e) {
            if(!tileLayout.isEnabled()) return;
            var zone = e.panel.GetOwnerZone();
            if (zone.GetPanelCount() > 1)
                dockPanelToVacantZone(zone.GetPanels()[0]);
        },

        onEndPanelDragging: function(s, e) {
            if(!tileLayout.isEnabled()) return;
            if (!e.panel.GetOwnerZone())
                dockPanelToVacantZone(e.panel);
            ASPxClientUtils.DetachEventFromElement(document, getEventName(), mouseMoveHandler);
            tileLayout.dragging = "stopped";
        },
        updateZoneDimensionsCache: function() {
            if(!tileLayout.isEnabled()) return;
            zoneDimensionsCache = [];

            for (var i = 0; i < zones.length; i++) {
                var zoneElem = zones[i].GetMainElement();
                if(!zoneElem) continue;
                zoneDimensionsCache.push({
                    zoneUID: zones[i].zoneUID,
                    x: ASPxClientUtils.GetAbsoluteX(zoneElem),
                    y: ASPxClientUtils.GetAbsoluteY(zoneElem),
                    w: zones[i].GetWidth(),
                    h: zones[i].GetHeight()
                });
            }
        },
        isEnabled: function() {

        }
};

var zones = [],
    zoneDimensionsCache = [],
    mouseMoveHandler = null;

    function getEventName() {
        return ASPxClientUtils.androidPlatform ? "touchmove" : "mousemove";
    };
function getZoneUnderCursor(evt) {
    var evtX = ASPxClientUtils.GetEventX(evt),
        evtY = ASPxClientUtils.GetEventY(evt);
    for (var i = 0; i < zoneDimensionsCache.length; i++) {
        var zd = zoneDimensionsCache[i];
        if (evtX > zd.x && evtX < zd.x + zd.w && evtY > zd.y && evtY < zd.y + zd.h)
            return DockManager.GetZoneByUID(zd.zoneUID);
    }
    return null;
};
function getVacantZone(excludeZone) {
    for (var i = 0; i < zones.length; i++) {
        if(!zones[i].GetMainElement()) continue;
        var isExcludedZone = excludeZone && (zones[i].zoneUID === excludeZone.zoneUID);
        if (!isExcludedZone && zones[i].GetPanelCount() === 0)
            return zones[i];
    }
};
function dockPanelToVacantZone(panel, overredZone) {
    var vacantZone = getVacantZone(overredZone);
    panel.Dock(vacantZone);
    panel.GetMainElement().style.width = panel.GetMainElement().parentNode.style.width;
};
})();