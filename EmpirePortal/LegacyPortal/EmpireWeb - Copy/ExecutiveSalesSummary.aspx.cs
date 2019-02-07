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


public partial class ExecutiveSalesSummary : System.Web.UI.Page 
{

	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack) // Post back
	    	{
		}
		else // Initial load
		{
		
			RadioButtonList1.SelectedIndex = 0;
					
			divButton.Visible = false;
			divSalesForecastVolumes.Visible = false;
			divSalesForecastSingleRowTreeList.Visible = false;
			divSalesForecastTreeListVolumes.Visible	= false;
			divQuoteLogGrid.Visible = false;

			SalesForecastSummariesRadGrid.Height = 628;
			SalesForecastVolumesRadGrid.Height = 628;
			
			//SalesForecastVolumesTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 0, NestedLevel = 0 });
			
			//SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 0, NestedLevel = 0 });
            //SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 1, NestedLevel = 0 });
            //SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 2, NestedLevel = 0 });
		}
	}


		protected void FilterComboBox_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
		{
			SetGridHeight(e.Text);
		}
	
	    //protected void SalesForecastSingleRowRadTreeList_NeedDataSource(object source, TreeListNeedDataSourceEventArgs e)
        //{
        //    SalesForecastSingleRowRadTreeList.DataSource = PopulateSalesForecastTree("Customer", "FNG");
        //}
		
		//protected void SalesForecastVolumesTreeList_ItemCommand(object sender, TreeListCommandEventArgs e)
	    //{
		//RadWindowManager1.RadAlert("Here", 330, 180, "Message", "");
	    //    if (e.CommandName == "ExpandCollapse")
	    //    {
	    //        TreeListDataItem dataItem = e.Item as TreeListDataItem;
	    //        if (dataItem.ParentItem != null)
	    //        {
	    //            dataItem.OwnerTreeList.ShowFooter = false;
	    //         }        
	    //       else    
	    //         {
	    //            dataItem.OwnerTreeList.ShowFooter = true;
	    //         }
	    //    }
	    //}
		
		
		private void SetGridHeight(string filter)
		{
			switch (filter)
			{
				case "Customer":
					SalesForecastSummariesRadGrid.Height = 628;
					SalesForecastVolumesRadGrid.Height = 628;
					break;
				case "Parent Customer":
					SalesForecastSummariesRadGrid.Height = 625;
					SalesForecastVolumesRadGrid.Height = 625;
					break;
				case "Product Line":
					SalesForecastSummariesRadGrid.Height = 292;
					SalesForecastVolumesRadGrid.Height = 292;
					break;
				case "Program":
					SalesForecastSummariesRadGrid.Height = 623;
					SalesForecastVolumesRadGrid.Height = 623;
					break;
				case "Salesperson":
					SalesForecastSummariesRadGrid.Height = 172;
					SalesForecastVolumesRadGrid.Height = 172;
					break;
				case "Segment":
					SalesForecastSummariesRadGrid.Height = 442;
					SalesForecastVolumesRadGrid.Height = 442;
					break;	
				case "Vehicle":
					SalesForecastSummariesRadGrid.Height = 623;
					SalesForecastVolumesRadGrid.Height = 623;
					break;	
			}
		}



	protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
		divQuoteLogGrid.Visible = false;
	
		if (RadioButtonList1.SelectedValue == "0")
		{
			// Show sales
			SalesForecastSummariesRadGrid.Rebind();
			divSalesForecast.Visible = true;
			divSalesForecastVolumes.Visible = false;
			
			SetGridHeight(FilterComboBox.Text);
		}
		else
		{	
			// Show volumes
			SalesForecastVolumesRadGrid.Rebind();
			divSalesForecastVolumes.Visible = true;
			divSalesForecast.Visible = false;
			
			SetGridHeight(FilterComboBox.Text);
		}
    }



	protected void SalesForecastSummariesRadGrid_ItemCommand(object sender, GridCommandEventArgs e)
 	{
		//RadWindowManager1.RadAlert("Here", 330, 180, "Message", "");
		//SalesForecastSingleRowRadTreeList.DataSource = PopulateSalesForecastTree("Customer", "FNG");
   		try
		{
			if (e.CommandName == "RowClick")
	   		{
	       		GridDataItem item = e.Item as GridDataItem;
				string filterValue = item["Filter"].Text;
				string filter = FilterComboBox.SelectedValue;
				
				SalesForecastSingleRowRadTreeList.DataSource = PopulateSalesForecastTree(filter, filterValue);
				//SalesForecastSingleRowRadTreeList.DataBind();
				SalesForecastSingleRowRadTreeList.ExpandAllItems();
				
				SalesForecastOneRowRadGrid.DataSource = PopulateSalesForecastOneRow(filter, filterValue);
				SalesForecastOneRowRadGrid.DataBind();

				QuoteLogRadGrid.DataSource = PopulateQuoteLogGrid(filter, filterValue);
				QuoteLogRadGrid.DataBind();

				divSalesForecast.Visible = divSalesForecastTreeListVolumes.Visible = false;
				divSalesForecastSingleRowTreeList.Visible = divQuoteLogGrid.Visible = divButton.Visible = true;
	
				divSelectFilter.Visible = false;
				
				divToggleSalesVolume.Visible = false;
				
				// Customize button text
				if (filter == "Salesperson")
				{
					RadButtonShowAll.Text = "Show All Sales People";
				}
				else
				{
					RadButtonShowAll.Text = "Show All " + filter + "s";
				}
				lblSalesTitle.Text = lblVolumesTitle.Text = filterValue;
	   		}
		}	
		catch (Exception ex)
	 	{
			RadWindowManager1.RadAlert(ex.Message, 330, 180, "Error at SalesForecastSummariesRadGrid_ItemCommand", "");
		}
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





protected void SalesForecastVolumesRadGrid_ItemCommand(object sender, GridCommandEventArgs e)
 	{
		//RadWindowManager1.RadAlert("Here", 330, 180, "Message", "");
		//SalesForecastVolumesTreeList.DataSource = PopulateSalesForecastVolumesTree("Customer", "FNG");
   		try
		{
			if (e.CommandName == "RowClick")
	   		{
	       		GridDataItem item = e.Item as GridDataItem;
				string filterValue = item["Filter"].Text;
				string filter = FilterComboBox.SelectedValue;
				
				SalesForecastVolumesTreeList.DataSource = PopulateSalesForecastVolumesTree(filter, filterValue);
				//SalesForecastVolumesTreeList.DataBind();
				SalesForecastVolumesTreeList.ExpandAllItems();
				//SalesForecastVolumesTreeList.ExpandToLevel(0);
				
				SalesForecastVolumeOneRowRadGrid.DataSource = PopulateSalesForecastVolumesOneRow(filter, filterValue);
				SalesForecastVolumeOneRowRadGrid.DataBind();

				QuoteLogRadGrid.DataSource = PopulateQuoteLogGrid(filter, filterValue);
				QuoteLogRadGrid.DataBind();

				divSalesForecastVolumes.Visible = divSalesForecastSingleRowTreeList.Visible = false;
				divSalesForecastTreeListVolumes.Visible = divQuoteLogGrid.Visible = divButton.Visible = true;
	
				divSelectFilter.Visible = false;
				
				divToggleSalesVolume.Visible = false;
				
				// Customize button text
				if (filter == "Salesperson")
				{
					RadButtonShowAll.Text = "Show All Sales People";
				}
				else
				{
					RadButtonShowAll.Text = "Show All " + filter + "s";
				}
				lblSalesTitle.Text = lblVolumesTitle.Text = filterValue;
	   		}
		}	
		catch (Exception ex)
	 	{
			RadWindowManager1.RadAlert(ex.InnerException.Message, 330, 180, "Error at SalesForecastSummariesRadGrid_ItemCommand", "");
		}
   	}
	
protected void SalesForecastVolumesRadGrid_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastVolumesRadGrid.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastVolumesRadGrid.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastVolumesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastVolumesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastVolumesRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastVolumesRadGrid.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastVolumesRadGrid.MasterTableView.Rebind();
   	}

	

protected void QuoteLogRadGrid_SortCommand(object source, GridSortCommandEventArgs e)
   	{

			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (QuoteLogRadGrid.MasterTableView.SortExpressions.Count == 0 ||
	        	QuoteLogRadGrid.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;	
    		}
        	else if (QuoteLogRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (QuoteLogRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (QuoteLogRadGrid.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		QuoteLogRadGrid.MasterTableView.SortExpressions.AddSortExpression(expression);
			
		
			string filter = FilterComboBox.SelectedValue;
			string filterValue;
			filterValue = (RadioButtonList1.SelectedValue == "0") ? lblSalesTitle.Text : lblVolumesTitle.Text;
			
			QuoteLogRadGrid.DataSource = PopulateQuoteLogGrid(filter, filterValue);
			QuoteLogRadGrid.DataBind();
   	}




	protected void RadButtonShowAll_Click(object sender, EventArgs e)
    {
		//RadButton btn = (RadButton)sender;
		//lblButtonClickMessage.Text = "<span>Server-Side Click: <strong>" + btn.Text + "</strong> was clicked.</span>";
//RadWindowManager1.RadAlert("Here", 330, 180, "Message", "");
		
		divToggleSalesVolume.Visible = true;
		
		if (RadioButtonList1.SelectedValue == "0")
		{
			divSalesForecast.Visible = true;
			divSalesForecastVolumes.Visible = false;
		}
		else
		{
			divSalesForecastVolumes.Visible = true;
			divSalesForecast.Visible = false;
		}
		
		divSalesForecastSingleRowTreeList.Visible = divSalesForecastTreeListVolumes.Visible = divQuoteLogGrid.Visible = divButton.Visible = false;
		
		divSelectFilter.Visible = true;
    }



	private List<SalesForecastTree> PopulateSalesForecastTree(string filter, string filterValue)
	{
		SalesForecastTree salesForecastTree;
		List<SalesForecastTree> treeList = new List<SalesForecastTree>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Test", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastTree = new SalesForecastTree();

						salesForecastTree.ID = Convert.ToInt32(reader["ID"]);
						salesForecastTree.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastTree.EmpireApplication = reader["empire_application"].ToString();	
						salesForecastTree.BasePart = reader["base_part"].ToString();	
							
						salesForecastTree.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastTree.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastTree.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastTree.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastTree.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastTree.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastTree.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						
						salesForecastTree.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastTree.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastTree.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastTree.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastTree.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastTree.Change_2022 = ReaderToDecimal(reader, "Change_2022");

						salesForecastTree.ParentID = Convert.ToInt32(reader["ParentID"]);	
												
						treeList.Add(salesForecastTree);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastSingleRowGrid", "");
		}
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.Filter, 330, 180, "Message", "");
		//}
		return treeList;
	}




private List<SalesForecastVolumesTree> PopulateSalesForecastVolumesTree(string filter, string filterValue)
	{
		SalesForecastVolumesTree salesForecastVolumesTree;
		List<SalesForecastVolumesTree> treeList = new List<SalesForecastVolumesTree>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Volumes_Test", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesTree = new SalesForecastVolumesTree();

						salesForecastVolumesTree.ID = Convert.ToInt32(reader["ID"]);
						salesForecastVolumesTree.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastVolumesTree.EmpireApplication = reader["empire_application"].ToString();	
						salesForecastVolumesTree.BasePart = reader["base_part"].ToString();
		
						salesForecastVolumesTree.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesTree.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesTree.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesTree.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesTree.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesTree.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesTree.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						
						salesForecastVolumesTree.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesTree.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesTree.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesTree.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesTree.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesTree.Change_2022 = ReaderToDecimal(reader, "Change_2022");

						salesForecastVolumesTree.ParentID = Convert.ToInt32(reader["ParentID"]);
												
						treeList.Add(salesForecastVolumesTree);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at Populate Volumes Tree", "");
		}
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.ID, 330, 180, "Message", "");
		//}
		return treeList;
	}
	
	private List<SalesForecastVolumesOneRow> PopulateSalesForecastVolumesOneRow(string filter, string filterValue)
	{
		SalesForecastVolumesOneRow salesForecastVolumesOneRow;
		List<SalesForecastVolumesOneRow> list = new List<SalesForecastVolumesOneRow>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Volumes", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesOneRow = new SalesForecastVolumesOneRow();

						salesForecastVolumesOneRow.Filter = reader["Filter"].ToString();
						salesForecastVolumesOneRow.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesOneRow.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesOneRow.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesOneRow.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesOneRow.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesOneRow.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesOneRow.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						
						salesForecastVolumesOneRow.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesOneRow.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesOneRow.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesOneRow.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesOneRow.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesOneRow.Change_2022 = ReaderToDecimal(reader, "Change_2022");
												
						list.Add(salesForecastVolumesOneRow);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at Populate Volumes One Row", "");
		}
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.ID, 330, 180, "Message", "");
		//}
		return list;
	}
	
 protected void SalesForecastVolumeOneRowRadGrid_ItemDataBound(object sender, GridItemEventArgs e) 
    { 
 
        if (e.Item is GridDataItem) 
        { 
         GridDataItem dataItem = e.Item as GridDataItem; 
		 
		 Color col = System.Drawing.ColorTranslator.FromHtml("#e4e4e4");

      	//dataItem.BackColor = Color.LightGray;
		dataItem.BackColor = col; 
		}
     } 



private List<SalesForecastOneRow> PopulateSalesForecastOneRow(string filter, string filterValue)
	{
		SalesForecastOneRow salesForecastOneRow;
		List<SalesForecastOneRow> list = new List<SalesForecastOneRow>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastOneRow = new SalesForecastOneRow();

						salesForecastOneRow.Filter = reader["Filter"].ToString();
						salesForecastOneRow.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastOneRow.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastOneRow.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastOneRow.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastOneRow.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastOneRow.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastOneRow.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						
						salesForecastOneRow.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastOneRow.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastOneRow.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastOneRow.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastOneRow.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastOneRow.Change_2022 = ReaderToDecimal(reader, "Change_2022");
												
						list.Add(salesForecastOneRow);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at Populate One Row", "");
		}
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.ID, 330, 180, "Message", "");
		//}
		return list;
	}
	
 protected void SalesForecastOneRowRadGrid_ItemDataBound(object sender, GridItemEventArgs e) 
    { 
 
        if (e.Item is GridDataItem) 
        { 
         GridDataItem dataItem = e.Item as GridDataItem; 
		 
		 Color col = System.Drawing.ColorTranslator.FromHtml("#e4e4e4");

      	//dataItem.BackColor = Color.LightGray;
		dataItem.BackColor = col; 
		}
     } 





	private decimal? ReaderToDecimal(SqlDataReader reader, string columnName)
	{
		return reader.IsDBNull(reader.GetOrdinal(columnName)) ? (decimal?) null : Convert.ToDecimal(reader[columnName]);
	}



	private List<QuoteLog> PopulateQuoteLogGrid(string filter, string filterValue)
	{
		QuoteLog quoteLog;
		List<QuoteLog> quoteLogList = new List<QuoteLog>();

		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
				SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_QuoteLog", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{	
						quoteLog = new QuoteLog();
						
						quoteLog.QuoteNumber = reader["QuoteNumber"].ToString();
						quoteLog.Customer = reader["Customer"].ToString();
						quoteLog.Program = reader["Program"].ToString();
						quoteLog.EEIPartNumber = reader["EEIPartNumber"].ToString();
						quoteLog.Nameplate = reader["Nameplate"].ToString();
						quoteLog.SOP = reader["SOP"].ToString();
						quoteLog.EOP = reader["EOP"].ToString();
						quoteLog.QuoteStatus = reader["QuoteStatus"].ToString();
						quoteLog.Awarded = reader["Awarded"].ToString();
						quoteLog.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						quoteLog.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						quoteLog.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						quoteLog.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						quoteLog.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						quoteLog.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						quoteLog.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						quoteLog.Variance_2017 = ReaderToDecimal(reader, "Variance_2017");
						quoteLog.Variance_2018 = ReaderToDecimal(reader, "Variance_2018");
						quoteLog.Variance_2019 = ReaderToDecimal(reader, "Variance_2019");
						quoteLog.Variance_2020 = ReaderToDecimal(reader, "Variance_2020");
						quoteLog.Variance_2021 = ReaderToDecimal(reader, "Variance_2021");
						quoteLog.Variance_2022 = ReaderToDecimal(reader, "Variance_2022");	
						
						quoteLogList.Add(quoteLog);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at PopulateQuoteLogGrid", "");
		}
		return quoteLogList;
	}


}



public class QuoteLog
{
	public string QuoteNumber { get; set; }
	public string Customer { get; set; }
	public string Program { get; set; }
	public string EEIPartNumber { get; set; }
	public string Nameplate { get; set; }
	public string SOP { get; set; }
	public string EOP { get; set; }
	public string QuoteStatus { get; set; }
	public string Awarded { get; set; }
	public decimal? Sales_2016 { get; set; }
	public decimal? Sales_2017 { get; set; }
	public decimal? Sales_2018 { get; set; }
	public decimal? Sales_2019 { get; set; }
	public decimal? Sales_2020 { get; set; }
	public decimal? Sales_2021 { get; set; }
	public decimal? Sales_2022 { get; set; }
	public decimal? Variance_2017 { get; set; }
	public decimal? Variance_2018 { get; set; }
	public decimal? Variance_2019 { get; set; }
	public decimal? Variance_2020 { get; set; }
	public decimal? Variance_2021 { get; set; }
	public decimal? Variance_2022 { get; set; }
}


public class SalesForecastTree
{
	public int ID { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public string BasePart { get; set; }
	public decimal? Sales_2016 { get; set; }
	public decimal? Sales_2017 { get; set; }
	public decimal? Sales_2018 { get; set; }
	public decimal? Sales_2019 { get; set; }
	public decimal? Sales_2020 { get; set; }
	public decimal? Sales_2021 { get; set; }
	public decimal? Sales_2022 { get; set; }
	public decimal? Change_2017 { get; set; }
	public decimal? Change_2018 { get; set; }
	public decimal? Change_2019 { get; set; }
	public decimal? Change_2020 { get; set; }
	public decimal? Change_2021 { get; set; }
	public decimal? Change_2022 { get; set; }
	public int ParentID { get; set; }
}

public class SalesForecastVolumesTree
{
	public int ID { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public string BasePart { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? Change_2017 { get; set; }
	public decimal? Change_2018 { get; set; }
	public decimal? Change_2019 { get; set; }
	public decimal? Change_2020 { get; set; }
	public decimal? Change_2021 { get; set; }
	public decimal? Change_2022 { get; set; }
	public int ParentID { get; set; }
}


public class SalesForecastVolumesOneRow
{
	public string Filter { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? Change_2017 { get; set; }
	public decimal? Change_2018 { get; set; }
	public decimal? Change_2019 { get; set; }
	public decimal? Change_2020 { get; set; }
	public decimal? Change_2021 { get; set; }
	public decimal? Change_2022 { get; set; }
}

public class SalesForecastOneRow
{
	public string Filter { get; set; }
	public decimal? Sales_2016 { get; set; }
	public decimal? Sales_2017 { get; set; }
	public decimal? Sales_2018 { get; set; }
	public decimal? Sales_2019 { get; set; }
	public decimal? Sales_2020 { get; set; }
	public decimal? Sales_2021 { get; set; }
	public decimal? Sales_2022 { get; set; }
	public decimal? Change_2017 { get; set; }
	public decimal? Change_2018 { get; set; }
	public decimal? Change_2019 { get; set; }
	public decimal? Change_2020 { get; set; }
	public decimal? Change_2021 { get; set; }
	public decimal? Change_2022 { get; set; }
}
