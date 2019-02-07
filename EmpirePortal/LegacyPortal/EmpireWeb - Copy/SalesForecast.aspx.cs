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
         //DataView ds = (DataView)CheckBox1DataSource.Select(DataSourceSelectArguments.Empty);
         //string a = ds[0][0].ToString();
         //if (a=="true"){
         //CheckBox1.Checked=true;}
         //else {CheckBox1.Checked=false;}
		}

    protected void Page_PreRender(object sender, EventArgs e)
        {
        }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
         //RadGrid2.SelectedIndexes.Clear();
        }

    protected void CsmDemandRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
         CSMDemandRadGridDataSource.DataBind();
         CSMDemandRadGrid.Rebind();
         EmpireFactorRadGridDataSource.DataBind();
         EmpireFactorRadGrid.Rebind();
         AdjustedCSMDemandRadGridDataSource.DataBind();
         AdjustedCSMDemandRadGrid.Rebind();
         EmpireAdjustmentRadGridDataSource.DataBind();
         EmpireAdjustmentRadGrid.Rebind();
         TotalDemandRadGridDataSource.DataBind();
         TotalDemandRadGrid.Rebind();
         TotalRevenueRadGridDataSource.DataBind();
         TotalRevenueRadGrid.Rebind();
         TotalMaterialRadGridDataSource.DataBind();
         TotalMaterialRadGrid.Rebind();
        }   

    protected void EmpireFactorRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
         EmpireFactorRadGridDataSource.DataBind();
         EmpireFactorRadGrid.Rebind();
         AdjustedCSMDemandRadGridDataSource.DataBind();
         AdjustedCSMDemandRadGrid.Rebind();
         EmpireAdjustmentRadGridDataSource.DataBind();
         EmpireAdjustmentRadGrid.Rebind();
         TotalDemandRadGridDataSource.DataBind();
         TotalDemandRadGrid.Rebind();
         TotalRevenueRadGridDataSource.DataBind();
         TotalRevenueRadGrid.Rebind();
         TotalMaterialRadGridDataSource.DataBind();
         TotalMaterialRadGrid.Rebind();
        }

    protected void EmpireAdjustmentRadGrid_ItemUpdated(object sender, GridUpdatedEventArgs e)
       {
        EmpireAdjustmentRadGridDataSource.DataBind();
        EmpireAdjustmentRadGrid.Rebind();
        TotalDemandRadGridDataSource.DataBind();
        TotalDemandRadGrid.Rebind();
        TotalRevenueRadGridDataSource.DataBind();
        TotalRevenueRadGrid.Rebind();
        TotalMaterialRadGridDataSource.DataBind();
        TotalMaterialRadGrid.Rebind();
       }

   }
