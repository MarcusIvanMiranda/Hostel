using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_Index : System.Web.UI.UserControl, IPageUserControl {
    public void LoadState(SearchState state) {
        //CheckInDateEdit.Value = DateTime.Now + TimeSpan.FromDays(1);
        //CheckInDateEdit.MinDate = DateTime.Now + TimeSpan.FromDays(1);
        //CheckOutDateEdit.Value = DateTime.Now + TimeSpan.FromDays(3);
    }
    protected void LoginCaptcha_Load(object sender, EventArgs e) {
        LoginCaptcha.ChallengeImage.BackgroundColor = Color.FromArgb(178, 178, 178);
    }
    protected void Page_Load(object sender, EventArgs e) {
        if(IsPostBack)
            LoginCaptcha.IsValid = LoginCaptcha.Code == LoginCaptchaEditor.Text;
    }
}
