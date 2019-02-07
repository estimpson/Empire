using System;
using System.Data;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using Telerik.Web.UI;
using Telerik.Web.Data;

public partial class ContainerProgress : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)

    {

    }

    protected void RadPushButton1_Click(object sender, EventArgs e)
    {
        SDS_ContainerProgress.DataBind();
        RadGrid1.Rebind();

    }



    protected void RadComboBox1_ItemDataBound(object sender, RadComboBoxItemEventArgs e)
    {
        e.Item.Text = ((DataRowView)e.Item.DataItem)["ContenedorID"].ToString();
        // e.Item.Text = ((DataRowView)e.Item.DataItem)["FechaEEH"].ToString();
        // e.Item.Text = ((DataRowView)e.Item.DataItem)["FechaEEH"].ToString();

    }


    protected void RadGrid1_CustomAggregate(object sender, GridCustomAggregateEventArgs e)
    {
        {
            if (e.Item is GridGroupFooterItem)
            {
                GridGroupFooterItem headerItem = e.Item as GridGroupFooterItem;
                GridItem[] groups = RadGrid1.MasterTableView.GetItems(GridItemType.GroupHeader);
                foreach (GridGroupHeaderItem group in groups)
                {
                    string id = headerItem["qty_required"].Text;
           }
            }
        }
    }
}