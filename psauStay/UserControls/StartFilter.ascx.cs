using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_StartFilter : System.Web.UI.UserControl {
    public SearchState SearchState { get; set; }

    protected void Page_Load(object sender, EventArgs e) {
        CheckInDateEdit.Value = SearchState.CheckInDate;
        CheckInDateEdit.MinDate = DateTime.Now + TimeSpan.FromDays(1);
        CheckOutDateEdit.Value = SearchState.CheckOutDate;

        RoomsNumberSpinEdit.Value = SearchState.RoomsCount;
        AdultsNumberSpinEdit.Value = SearchState.AdultsCount;
        ChildrenNumberSpinEdit.Value = SearchState.ChildrenCount;
    }
}
