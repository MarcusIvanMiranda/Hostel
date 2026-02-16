using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.UI;

public interface IPageUserControl {
    void LoadState(SearchState state);
}
