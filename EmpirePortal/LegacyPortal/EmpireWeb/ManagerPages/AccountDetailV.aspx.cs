using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class TestMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        RadComboBoxD.SelectedValue = DateTime.Today.Month.ToString();
    }
    
    
    protected void SqlDataSourceA_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
    
    }
        
    protected void RadGrid2_ItemCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
    //     if ((string)e.CommandName == "ExpandCollapse")
    //         Session["BudgetID"] = e.Item.Cells[2].Text;
    }

}
