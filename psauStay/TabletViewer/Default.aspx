<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="TabletViewer_Default" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <link href="Styles/Styles.css" type="text/css" rel="stylesheet" />
    <script src="Scripts/Script.js" type="text/javascript"></script>
</head>
<body class="landscape">
    <form id="form1" runat="server">
        <div class="simulator">
            <iframe id="simulatorFrame" runat="server" src="../Default.aspx?noredirect=true" scrolling="no"></iframe>
        </div>
        <div class="qrcode" runat="server" id="qrcodeContainer" visible="false">
            <div>
                <a id="qrcodeLink" runat="server" href="#" target="_blank"><img id="qrcodeImg" runat="server" src="" alt="QRCode" /></a>
            </div>
            <div class="hint">View on a Tablet</div>
        </div>
        <div class="switcher">
            <div id="btnLandscape" class="switcherLandscape" onclick="Landscape()"></div>
            <div id="btnPortrait" class="switcherPortrait" onclick="Portrait()"></div>
        </div>
    </form>
</body>
</html>
