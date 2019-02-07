using System;
using System.Web.UI;
using Telerik.Web.UI;

public partial class RadGridRelatedForm : System.Web.UI.Page 
{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
		
		 protected void Page_PreRender(object sender, EventArgs e)
        {
            //if (RadGrid1.SelectedIndexes.Count == 0)
            //    RadGrid1.SelectedIndexes.Add(0);
            //if (RadGrid2.SelectedIndexes.Count == 0)
            //{
            //    RadGrid2.Rebind();
            //    RadGrid2.SelectedIndexes.Add(0);  
            //}
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            //RadGrid2.SelectedIndexes.Clear();
        }


        protected void MnemonicBasePartRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            CSMDemandRadGrid.Rebind();
            AdjustedCSMDemandRadGrid.Rebind();
            EmpireFactorRadGrid.Rebind();
            EmpireAdjustmentRadGrid.Rebind();
            TotalDemandRadGrid.Rebind();
            TotalRevenueRadGrid.Rebind();
        }
       
    protected void EmpireFactorRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            EmpireFactorRadGrid.Rebind();
            AdjustedCSMDemandRadGrid.Rebind();           
            EmpireAdjustmentRadGrid.Rebind();
            TotalDemandRadGrid.Rebind();
            TotalRevenueRadGridDataSource.DataBind();
        TotalRevenueRadGrid.Rebind();
        }
    protected void EmpireAdjustmentRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
    {
        EmpireAdjustmentRadGrid.Rebind();
        TotalDemandRadGrid.Rebind();
        TotalRevenueRadGridDataSource.DataBind();
        TotalRevenueRadGrid.Rebind();
    }


    //protected void RadTextBox1_TextChanged(object sender, EventArgs e)
    //{
    //    for (int i = 0; i < BasePartNotesRadGrid.PageSize; i++)
    //    {
    //        BasePartNotesRadGrid.EditIndexes.Add(i);
    //    }
    //    BasePartNotesRadGridDataSource.Update();
    //    BasePartNotesRadGrid.Rebind();
    //}





}
