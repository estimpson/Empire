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
using System.Collections;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class SalesForecast2 : System.Web.UI.Page 
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
	   
	   
	   
	protected void BasePartAttributesRadGrid_UpdateCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
	{
			try
			{
				string basePart = BasePartComboBox.SelectedValue;
				string releaseId = ReleaseIDComboBox.SelectedValue;

    				if (e.Item is GridEditableItem && e.Item.IsInEditMode)
				{
       				GridEditableItem editableItem = e.Item as GridEditableItem;
					
					TextBox tbxSalesPerson = editableItem["Salesperson"].Controls[0] as TextBox;
					string salesperson = tbxSalesPerson.Text;
					
					DateTime? dtDateOfAward = null;
					TextBox tbxDateOfAward = editableItem["DateOfAward"].Controls[0] as TextBox;
					string dateOfAward = tbxDateOfAward.Text.Trim();		
					if (dateOfAward != "") dtDateOfAward = Convert.ToDateTime(dateOfAward);
					//RadWindowManager2.RadAlert("Date of Award: " + dateOfAward, 330, 180, "Message", "");		
       
					TextBox tbxTypeOfAward = editableItem["TypeOfAward"].Controls[0] as TextBox;
					string typeOfAward = tbxTypeOfAward.Text;

					TextBox tbxFamily = editableItem["family"].Controls[0] as TextBox;
					string family = tbxFamily.Text;
					//RadWindowManager2.RadAlert(family, 330, 180, "Message", "");
					
					TextBox tbxCustomer = editableItem["customer"].Controls[0] as TextBox;
					string customer = tbxCustomer.Text;

					TextBox tbxParentCustomer = editableItem["parent_customer"].Controls[0] as TextBox;
					string parentCustomer = tbxParentCustomer.Text;
					
					TextBox tbxProductLine = editableItem["product_line"].Controls[0] as TextBox;
					string productLine = tbxProductLine.Text;
					
					TextBox tbxEmpireMarketSegment = editableItem["empire_market_segment"].Controls[0] as TextBox;
					string empireMarketSegment = tbxEmpireMarketSegment.Text;
					
					TextBox tbxEmpireMarketSubsegment = editableItem["empire_market_subsegment"].Controls[0] as TextBox;
					string empireMarketSubsegment = tbxEmpireMarketSubsegment.Text;
					
					TextBox tbxEmpireApplication = editableItem["empire_application"].Controls[0] as TextBox;
					string empireApplication = tbxEmpireApplication.Text;
					
        				RadDatePicker pkrSop = (RadDatePicker)editableItem["empire_sop"].Controls[0]; 
					DateTime? dtEmpireSop = null;
					if (pkrSop.SelectedDate.ToString() != "") dtEmpireSop = pkrSop.SelectedDate;
					//RadWindowManager2.RadAlert(empireSop, 330, 180, "Message", "");
					
					RadDatePicker pkrMidModelYear = (RadDatePicker)editableItem["mid_model_year"].Controls[0]; 
					DateTime? dtMidModelYear = null;
					if (pkrMidModelYear.SelectedDate.ToString() != "") dtMidModelYear = pkrMidModelYear.SelectedDate;

        				RadDatePicker pkrEop = (RadDatePicker)editableItem["empire_eop"].Controls[0]; 
					DateTime? dtEmpireEop = null;
					if (pkrEop.SelectedDate.ToString() != "") dtEmpireEop = pkrEop.SelectedDate;

					TextBox tbxEmpireEopNote = editableItem["empire_eop_note"].Controls[0] as TextBox;
					string empireEopNote = tbxEmpireEopNote.Text;				
					
					bool includeInForecast = (editableItem["IncludeInForecast"].Controls[0] as CheckBox).Checked;
					
					UpdateBasePartAttributes(basePart, releaseId, salesperson, dtDateOfAward, typeOfAward, family, customer, parentCustomer, productLine,
								empireMarketSegment, empireMarketSubsegment, empireApplication, dtEmpireSop, dtMidModelYear, dtEmpireEop, empireEopNote, includeInForecast);
								
				}

			}
			catch (Exception ex)
			{
				RadWindowManager2.RadAlert("Error: " + ex.Message, 330, 180, "Error at UpdateCommand", "");
			}
	}
	   
	   

private void UpdateBasePartAttributes (string basePart, string releaseId, string salesperson, DateTime? dateOfAward, string typeOfAward, string family, string customer, string parentCustomer, string productLine,
				string empireMarketSegment, string empireMarketSubsegment, string empireApplication, DateTime? sop, DateTime? midModelYear, DateTime? eop, string note, bool includeInForecast)
	{
	//RadWindowManager2.RadAlert(basePart + ", " + releaseId + ", " + salesperson + ", " + dateOfAward.ToString() + ", " + typeOfAward + ", " + family + ", " + customer + ", " + 
	//parentCustomer + ", " + productLine + ", " + empireMarketSegment + ", " + empireMarketSubsegment + ", " + empireApplication + ", " + sop.ToString() + ", " + 
	//midModelYear.ToString() + ", " + eop.ToString() + ", " + note + ", " + includeInForecast.ToString()  , 330, 180, "Message", "");
	
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    			SqlCommand command = new SqlCommand("eeiuser.acctg_csm_sp_update_base_part_attributes", connection);
				command.CommandTimeout = 180;
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@base_part", SqlDbType.VarChar).Value = basePart;
				command.Parameters.Add("@release_id", SqlDbType.VarChar).Value = releaseId;
				command.Parameters.Add("@salesperson", SqlDbType.VarChar).Value = salesperson;
				command.Parameters.Add("@date_of_award", SqlDbType.Date).Value = dateOfAward;
				command.Parameters.Add("@type_of_award", SqlDbType.VarChar).Value = typeOfAward;
				command.Parameters.Add("@family", SqlDbType.VarChar).Value = family;
				command.Parameters.Add("@customer", SqlDbType.VarChar).Value = customer;
				command.Parameters.Add("@parent_customer", SqlDbType.VarChar).Value = parentCustomer;
				command.Parameters.Add("@product_line", SqlDbType.VarChar).Value = productLine;
				command.Parameters.Add("@empire_market_segment", SqlDbType.VarChar).Value = empireMarketSegment;
				command.Parameters.Add("@empire_market_subsegment", SqlDbType.VarChar).Value = empireMarketSubsegment;
				command.Parameters.Add("@empire_application", SqlDbType.VarChar).Value = empireApplication;
				command.Parameters.Add("@empire_sop", SqlDbType.SmallDateTime).Value = sop;
				command.Parameters.Add("@mid_model_year", SqlDbType.DateTime).Value = midModelYear;
				command.Parameters.Add("@empire_eop", SqlDbType.SmallDateTime).Value = eop;
				command.Parameters.Add("@empire_eop_note", SqlDbType.VarChar).Value = note;
				command.Parameters.Add("@include_in_forecast", SqlDbType.Bit).Value = includeInForecast;

				connection.Open();
				command.ExecuteNonQuery();
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager2.RadAlert(ex.Message, 330, 180, "Error at UpdateBasePartAttributes()", "");
		}
	}






		   

   }
