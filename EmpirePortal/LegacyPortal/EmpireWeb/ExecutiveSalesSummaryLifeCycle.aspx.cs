using System;
using System.Web;
using System.Data;
using System.Design;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik;
using Telerik.Web.UI;
using Telerik.Web.Data;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.Diagnostics;


public partial class ExecutiveSalesSummaryLifeCycle : System.Web.UI.Page 
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack)
	    	{
				//RadWindowManager1.RadAlert("PostBack", 330, 180, "Message", "");
		}
		else
		{
			RadioButtonList1.SelectedIndex = 0;
					
			SalesForecastSummariesRadGrid.Height = 590;
			
			
						string lifeCycleStage = "Pre-production";
			string parentCustomer = "";
	
	//RadWindowManager1.RadAlert(lifeCycleStage, 330, 180, "Message", "");
	
	    		SalesForecastSummariesRadGrid.DataSource = PopulateSalesForecast(lifeCycleStage, parentCustomer);
				SalesForecastSummariesRadGrid.DataBind();
			
			PopulateParentCustomers(lifeCycleStage);
		}
	}	
	

	//protected void SalesForecastSummariesRadGrid_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	//{
	//	string lifeCycleStage = FilterComboBox.SelectedValue;
	//	string parentCustomer = ParentCustComboBox.SelectedValue;
	//	
	//   SalesForecastSummariesRadGrid.DataSource = PopulateSalesForecast(lifeCycleStage, parentCustomer);
	//}
	
	

		protected void FilterComboBox_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
		{
			if (RadioButtonList1.SelectedValue == "0")
			{
				if (e.Text == "Customer" || e.Text == "Parent Customer")
				{
					SalesForecastSummariesRadGrid.MasterTableView.GetColumn("MaterialPercentage").Visible = true;
				}
				else
				{
					SalesForecastSummariesRadGrid.MasterTableView.GetColumn("MaterialPercentage").Visible = false;
				}			

			}
			SetGridHeight(e.Text);
			
			
			string lifeCycleStage = FilterComboBox.SelectedValue;
			string parentCustomer = "";
	
	//RadWindowManager1.RadAlert(lifeCycleStage, 330, 180, "Message", "");
	
	    		SalesForecastSummariesRadGrid.DataSource = PopulateSalesForecast(lifeCycleStage, parentCustomer);
				SalesForecastSummariesRadGrid.DataBind();
			

			PopulateParentCustomers(lifeCycleStage);
		}

		private void PopulateParentCustomers(string lifeCycleStage)
		{
			ParentCust parentCust;
			List<ParentCust> list = new List<ParentCust>();
			
			
			
			//RadWindowManager1.RadAlert(lifeCycleStage, 330, 180, "Message", "");
			
			try
			{	
				using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
				{
		    			SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_LifeCycle_GetParentCustomers", connection);
					command.CommandTimeout = 180;
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.Add("@LifeCycleStage", SqlDbType.VarChar).Value = lifeCycleStage;
					connection.Open();
					using (SqlDataReader reader = command.ExecuteReader())
					{
		    				while (reader.Read())
						{
							parentCust = new ParentCust();
							parentCust.ParentCustomer = reader["ParentCustomer"].ToString();
													
							list.Add(parentCust);
						}
					}
					connection.Close();
				}
			}
			catch (Exception ex)
			{
				RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at PopulateParentCustomers", "");
			}
			
			ParentCustComboBox.DataSource = null;
			//ParentCustComboBox.DataTextField = "ParentCustomer";
    			//ParentCustComboBox.DataValueField = "ParentCustomer";
    			ParentCustComboBox.DataSource = list;
    			ParentCustComboBox.DataBind();
		}
		
		protected void ParentCustComboBox_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
		{
			string lifeCycleStage = FilterComboBox.SelectedValue;
			string parentCustomer = ParentCustComboBox.SelectedValue;
	
	    		SalesForecastSummariesRadGrid.DataSource = PopulateSalesForecast(lifeCycleStage, parentCustomer);
				SalesForecastSummariesRadGrid.DataBind();
		}
	


	protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
		//divQuoteLogGrid.Visible = false;
	
		//if (RadioButtonList1.SelectedValue == "0")
		//{
		//	// Show sales
		//	SalesForecastSummariesRadGrid.Rebind();
		//	divSalesForecast.Visible = true;
		//	divSalesForecastVolumes.Visible = false;
		//	
		//	SetGridHeight(FilterComboBox.Text);
		//}
		//else
		//{	
		//	// Show volumes
		//	SalesForecastVolumesRadGrid.Rebind();
		//	divSalesForecastVolumes.Visible = true;
		//	divSalesForecast.Visible = false;
		//	
		//	SetGridHeight(FilterComboBox.Text);
		//}
    }


	
	protected void SalesForecastSummariesRadGrid_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastSummariesRadGrid.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastSummariesRadGrid.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastSummariesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastSummariesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastSummariesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastSummariesRadGrid.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastSummariesRadGrid.MasterTableView.Rebind();
   	}

	
	
	protected void iBtnSalesForecastSummariesRadGrid_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastSummariesRadGrid.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	//SalesForecastSummariesRadGrid.ExportSettings.IgnorePaging = CheckBox1.Checked;
    	SalesForecastSummariesRadGrid.ExportSettings.ExportOnlyData = true;
    	SalesForecastSummariesRadGrid.ExportSettings.OpenInNewWindow = true;
		SalesForecastSummariesRadGrid.MasterTableView.ExportToExcel();
	}
	


	private List<SalesForecast> PopulateSalesForecast(string lifeCycleStage, string parentCustomer)
	{
		SalesForecast salesForecast;
		List<SalesForecast> list = new List<SalesForecast>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_LifeCycle_MaterialPercentage", connection);
				command.CommandTimeout = 180;
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = lifeCycleStage;
				command.Parameters.Add("@ParentCustomerFilter", SqlDbType.VarChar).Value = parentCustomer;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecast = new SalesForecast();

						salesForecast.Customer = reader["Customer"].ToString();
						salesForecast.BasePart = reader["BasePart"].ToString();
						salesForecast.DisplaySOP = reader["DisplaySOP"].ToString();
						salesForecast.DisplayEOP = reader["DisplayEOP"].ToString();
						salesForecast.MaterialPercentage = reader["MaterialPercentage"].ToString();
						salesForecast.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecast.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecast.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecast.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecast.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecast.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecast.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						salesForecast.Sales_2023 = ReaderToDecimal(reader, "Sales_2023");
						salesForecast.Sales_2024 = ReaderToDecimal(reader, "Sales_2024");
						salesForecast.Sales_2025 = ReaderToDecimal(reader, "Sales_2025");
						
						salesForecast.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecast.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecast.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecast.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecast.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecast.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecast.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecast.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecast.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						list.Add(salesForecast);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at Summaries Material Percentage", "");
		}
		//foreach(var item in list)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.Customer, 330, 180, "Message", "");
		//}
		return list;
	}
	



private decimal? ReaderToDecimal(SqlDataReader reader, string columnName)
	{
		return reader.IsDBNull(reader.GetOrdinal(columnName)) ? (decimal?) null : Convert.ToDecimal(reader[columnName]);
	}
	
			private void SetGridHeight(string filter)
		{
			switch (filter)
			{
				case "Customer":
					SalesForecastSummariesRadGrid.Height = 590;
					//SalesForecastVolumesRadGrid.Height = 590;
					break;
				case "Parent Customer":
					SalesForecastSummariesRadGrid.Height = 580;
					//SalesForecastVolumesRadGrid.Height = 580;
					break;
				case "Product Line":
					SalesForecastSummariesRadGrid.Height = 293;
					//SalesForecastVolumesRadGrid.Height = 293;
					break;
				case "Program":
					SalesForecastSummariesRadGrid.Height = 590;
					//SalesForecastVolumesRadGrid.Height = 590;
					break;
				case "Salesperson":
					SalesForecastSummariesRadGrid.Height = 233;
					//SalesForecastVolumesRadGrid.Height = 233;
					break;
				case "Segment":
					SalesForecastSummariesRadGrid.Height = 473;
					//SalesForecastVolumesRadGrid.Height = 473;
					break;	
				case "Vehicle":
					SalesForecastSummariesRadGrid.Height = 590;
					//SalesForecastVolumesRadGrid.Height = 590;
					break;	
			}
		}
	
}































public class ParentCust
{
	public string ParentCustomer { get; set; }
}

public partial class SalesForecast
{
	public string Customer { get; set; }
	public string BasePart { get; set; }
	public string DisplaySOP { get; set; }
	public string DisplayEOP { get; set; }
	public string MaterialPercentage { get; set; }
	public decimal? Sales_2016 { get; set; }
	public decimal? Sales_2017 { get; set; }
	public decimal? Sales_2018 { get; set; }
	public decimal? Sales_2019 { get; set; }
	public decimal? Sales_2020 { get; set; }
	public decimal? Sales_2021 { get; set; }
	public decimal? Sales_2022 { get; set; }
	public decimal? Sales_2023 { get; set; }
	public decimal? Sales_2024 { get; set; }
	public decimal? Sales_2025 { get; set; }
	public decimal? Change_2017 { get; set; }
	public decimal? Change_2018 { get; set; }
	public decimal? Change_2019 { get; set; }
	public decimal? Change_2020 { get; set; }
	public decimal? Change_2021 { get; set; }
	public decimal? Change_2022 { get; set; }
    public decimal? Change_2023 { get; set; }
	public decimal? Change_2024 { get; set; }
	public decimal? Change_2025 { get; set; }
}
