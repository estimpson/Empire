using System;
using System.Web.UI;
using Telerik.Web.UI;

public partial class RadGridRelatedForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void RadButton1_InsertPart_Click(object sender, EventArgs e)
    {
        SDS_InsertPart.Insert();
    }

    protected void RadButton2_Click(object sender, EventArgs e)
    {
        SDS_AssignMnemonics.Insert();
    }

    protected void RadGrid_CSMDemand_SelectedIndexChanged(object sender, EventArgs e)
    {

        RadTextBox103.Text = RadGrid_CSMDemand.SelectedValue.ToString();
     }

    //       protected void RadButton2_Click(object sender, EventArgs e)
    //       {


    ////           foreach (GridDataItem item in this.RadGrid2.SelectedItems)
    ////           {string BasePart2 = item.GetDataKeyValue("MnemonicVehiclePlant").ToString();

    ////           SqlDataSource5.InsertParameters.Add("basepart", BasePart2.ToString());

    ////           SqlDataSource5.Insert();
    ////}

    //       }

}