using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.Data;

public partial class ReleaseFluctuation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    
    {
        RadPivotGrid1.OlapSettings.XmlaConnectionSettings.Encoding = System.Text.Encoding.UTF8;
        RadDatePicker2.SelectedDate = DateTime.Today;
        RadDatePicker1.SelectedDate = DateTime.Today.AddDays(-180);
    
    }

    protected void RadAutoCompleteBox1_EntryAdded(object sender, AutoCompleteEntryEventArgs e)
    {
        CustomerRFDataSource.SelectParameters[2].DefaultValue = e.Entry.Text.ToString();
        BOMDataSource.SelectParameters[0].DefaultValue = e.Entry.Text.ToString();

    }

    protected void RadPushButton1_Click(object sender, EventArgs e)
    {
 
        CustomerRFDataSource.DataBind();
        RadPivotGrid1.Rebind();

        BOMDataSource.DataBind();
        RadGrid1.Rebind();

        //SelectCommand="select distinct(part) as part from part where type = 'F' union select distinct(left(part,7)) as part from part where type = 'F' order by 1 asc">

    }
    protected void RadPushButton2_Click(object sender, EventArgs e)
    {
        RadPivotGrid1.ExportToExcel();
    }


}