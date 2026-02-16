using System;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Linq;
using DevExpress.Web.Internal;

public partial class TabletViewer_Default : System.Web.UI.Page {
    protected void Page_Init(object sender, EventArgs e) {
        if(RenderUtils.Browser.Platform.IsTouchUI)
            Response.Redirect("../default.aspx");
        else if(RenderUtils.Browser.IsIE && RenderUtils.Browser.Version < 9)
            simulatorFrame.Attributes["src"] = "UnsupportedBrowser.aspx";
        else {
            string siteModeSetting = ConfigurationManager.AppSettings["SiteMode"];
            if(!string.IsNullOrEmpty(siteModeSetting) && siteModeSetting.Equals("true", StringComparison.InvariantCultureIgnoreCase)) {
                qrcodeContainer.Visible = true;
                string url = string.Format("http://{0}{1}", Request.Url.Host, Page.ResolveUrl("~/default.aspx"));
                qrcodeLink.Attributes["href"] = url + "?noredirect=true";
                qrcodeImg.Attributes["src"] = string.Format("http://chart.apis.google.com/chart?cht=qr&chs=140x140&chl={0}&chld=H|0", HttpUtility.UrlEncode(url));
            }
        }
        if(Application.AllKeys.Contains("PageTitle"))
            Page.Title = Application["PageTitle"].ToString();
    }
}
