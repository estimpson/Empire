using System;
using System.Web;
using System.Data;
using System.Design;
using System.Web.UI;
using Telerik;
using Telerik.Web.UI;
using Telerik.Web.Data;
using DevExpress.Web;
using DevExpress;

public partial class SalesForecast : System.Web.UI.Page 
   {
    protected void Page_Load(object sender, EventArgs e)
    {
        VehicleRadGridDataSource.DataBind();
        RadGrid1.Rebind();
    }
   }
