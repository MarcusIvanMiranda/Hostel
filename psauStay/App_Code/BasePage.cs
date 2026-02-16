using System;
using System.Web.UI;

public class BasePage : Page {
    public BasePage(string name) {
        Name = name;
        Init += (o, s) => {
            State = SearchState.CreateSearchState(Request.Params, Name);
            if(State == null || !State.ValidState)
                Response.Redirect("Default.aspx");
        };
    }

    string Name { get; set; }
    protected SearchState State { get; set; }
}
