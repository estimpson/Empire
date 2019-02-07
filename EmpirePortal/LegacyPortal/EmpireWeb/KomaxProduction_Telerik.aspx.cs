using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.Data;

public partial class KomaxProduction_Telerik : System.Web.UI.Page
{ 

    protected void Page_Load(object sender, EventArgs e)

    {
        if (!IsPostBack)
        {
            RadDatePicker2.SelectedDate = DateTime.Today;
            RadDatePicker1.SelectedDate = DateTime.Today.AddDays(-90);
        }
    }

    protected void RadPushButton1_Click(object sender, EventArgs e)
    {
        SDS_KomaxProduction2.DataBind();
        RadGrid1.Rebind();
    
    }

    protected void RadPushButton2_Click(object sender, EventArgs e)
    {
        RadGrid1.ExportToExcel();
    }

    protected void RadGrid1_ColumnCreated(object sender, Telerik.Web.UI.GridColumnCreatedEventArgs e)
    {
        if (e.Column is GridBoundColumn)
        {
            GridBoundColumn boundColumn = e.Column as GridBoundColumn;
            GridNumericColumn numCol = boundColumn as GridNumericColumn;
            if (numCol != null)
            {
                numCol.DataFormatString = "{0:N0}";
                numCol.Aggregate = GridAggregateFunction.Sum;
                numCol.FooterAggregateFormatString = "{0:N0}";                
            }
        }
    }
    
}