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

public partial class ExecutiveSalesSummary : System.Web.UI.Page 
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack)
	    	{
		}
		else
		{
			RadioButtonList1.SelectedIndex = 0;
					
			divButton.Visible = false;
			divSalesForecastVolumes.Visible = false;
			divSalesForecastSelected.Visible = false;
			divSalesForecastVolumesSelected.Visible	= false;
			divQuoteLogGrid.Visible = false;

			SalesForecastSummariesRadGrid.Height = 590;
			SalesForecastVolumesRadGrid.Height = 590;
			
			//SalesForecastVolumesTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 0, NestedLevel = 0 });
			
			//SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 0, NestedLevel = 0 });
            //SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 1, NestedLevel = 0 });
            //SalesForecastSingleRowRadTreeList.ExpandedIndexes.Add(new TreeListHierarchyIndex { LevelIndex = 2, NestedLevel = 0 });
		}
	}	
	
	//protected void Button4_Click(object sender, EventArgs e)  
//{  
    //if (test)  
    //{  
        //RadWindow newWindow = new RadWindow();  
        //newWindow.NavigateUrl = "QlTest.aspx";  
        //newWindow.VisibleOnPageLoad = true;  
	//	newWindow.Width = 1000;
	//	newWindow.Height = 600;
        //RadWindowManager1.Windows.Add(newWindow);   
    //}  
//} 
	
	protected void SalesForecastSummariesRadGrid_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		
	    SalesForecastSummariesRadGrid.DataSource = PopulateSalesForecast(filter);
	}
	
	protected void SalesForecastSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblSalesTitle.Text.Trim();
	
	    SalesForecastSelected.DataSource = PopulateSalesForecastSelected(filter, filterValue);
	}
	
	protected void SalesForecastCustomerSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblSalesTitle.Text.Trim();
	
	    SalesForecastCustomerSelected.DataSource = PopulateSalesForecastCustomerSelected(filter, filterValue);
	}
	
	protected void SalesForecastParentCustomerSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblSalesTitle.Text.Trim();
	
	    SalesForecastParentCustomerSelected.DataSource = PopulateSalesForecastParentCustomerSelected(filter, filterValue);
	}
	
	protected void SalesForecastProgramSalespersonSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblSalesTitle.Text.Trim();
	
	    SalesForecastProgramSalespersonSelected.DataSource = PopulateSalesForecastProgramSalespersonSelected(filter, filterValue);
	}
	
	protected void SalesForecastVolumeRadGrid_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
	
	    SalesForecastVolumesRadGrid.DataSource = PopulateSalesForecastVolumes(filter);
	}
	
	protected void SalesForecastVolumesSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblVolumesTitle.Text.Trim();
	
	    SalesForecastVolumesSelected.DataSource = PopulateSalesForecastVolumesSelected(filter, filterValue);
	}
	
	protected void SalesForecastVolumesCustomerSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblVolumesTitle.Text.Trim();
	
	    SalesForecastVolumesCustomerSelected.DataSource = PopulateSalesForecastVolumesCustomerSelected(filter, filterValue);
	}
	
	protected void SalesForecastVolumesParentCustomerSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblVolumesTitle.Text.Trim();
	
	    SalesForecastVolumesParentCustomerSelected.DataSource = PopulateSalesForecastVolumesParentCustomerSelected(filter, filterValue);
	}
	
	protected void SalesForecastVolumesProgramSalespersonSelected_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
	{
		string filter = FilterComboBox.SelectedValue;
		string filterValue = lblVolumesTitle.Text.Trim();
	
	    SalesForecastVolumesProgramSalespersonSelected.DataSource = PopulateSalesForecastVolumesProgramSalespersonSelected(filter, filterValue);
	}

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
	}

    
    //protected void SalesForecastSingleRowRadTreeList_NeedDataSource(object source, TreeListNeedDataSourceEventArgs e)
    //{
    //    SalesForecastSingleRowRadTreeList.DataSource = PopulateSalesForecastTree("Customer", "FNG");
    //}

    protected void SalesForecastVolumesTreeList_ItemCommand(object sender, TreeListCommandEventArgs e)
    {
        RadWindowManager1.RadAlert("Here", 330, 180, "Message", "");
        if (e.CommandName == "ExpandCollapse")
        {
            TreeListDataItem dataItem = e.Item as TreeListDataItem;
            if (dataItem.ParentItem != null)
            {
                dataItem.OwnerTreeList.ShowFooter = false;
            }
            else
            {
                dataItem.OwnerTreeList.ShowFooter = true;
            }
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

    protected void QuoteLogRadGrid_ItemCommand(object sender, GridCommandEventArgs e)
    {
	    try
	    {
		    if (e.CommandName == "RowClick")
	   	    {
	       		    GridDataItem item = e.Item as GridDataItem;
			    string quoteNumber = item["QuoteNumber"].Text;


			    RadWindow newWindow = new RadWindow();  
        		    newWindow.NavigateUrl = "ExecutiveSalesSummaryQuote.aspx?id=" + quoteNumber;  
        		    newWindow.VisibleOnPageLoad = true;  
			    newWindow.DestroyOnClose = true;
			    newWindow.VisibleStatusbar = false;
			    newWindow.EnableViewState = false;
			    newWindow.Width = 1440;
			    newWindow.Height = 600;
        		    RadWindowManager1.Windows.Add(newWindow);
		    }
	    }
	    catch(Exception ex)
	    {
		    RadWindowManager1.RadAlert(ex.Message, 330, 180, "Error at QuoteLogRadGrid_ItemCommand", "");
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
				
				if (filter == "Customer")
				{
					SalesForecastCustomerSelected.DataSource = PopulateSalesForecastCustomerSelected(filter, filterValue);
					SalesForecastCustomerSelected.DataBind();
					
					SalesForecastCustomerSelected.Visible = iBtnSalesForecastCustomerSelected.Visible = true;
					
					SalesForecastSelected.Visible = iBtnSalesForecastSelected.Visible = false;
					SalesForecastParentCustomerSelected.Visible = iBtnSalesForecastParentCustomerSelected.Visible = false;
					SalesForecastProgramSalespersonSelected.Visible = iBtnSalesForecastProgramSalespersonSelected.Visible = false;
				}
				else if (filter == "Parent Customer")
				{
					SalesForecastParentCustomerSelected.DataSource = PopulateSalesForecastParentCustomerSelected(filter, filterValue);
					SalesForecastParentCustomerSelected.DataBind();
					
					SalesForecastParentCustomerSelected.Visible = iBtnSalesForecastParentCustomerSelected.Visible = true;
					
					SalesForecastSelected.Visible = iBtnSalesForecastSelected.Visible = false;
					SalesForecastCustomerSelected.Visible = iBtnSalesForecastCustomerSelected.Visible = false;
					SalesForecastProgramSalespersonSelected.Visible = iBtnSalesForecastProgramSalespersonSelected.Visible = false;
				}
				else if (filter == "Program" || filter == "Salesperson")
				{
					//SalesForecastSingleRowProgramSalespersonRadTreeList.DataSource = PopulateSalesForecastProgramSalespersonTree(filter, filterValue);
					////SalesForecastSingleRowProgramSalespersonRadTreeList.DataBind();
					//SalesForecastSingleRowProgramSalespersonRadTreeList.ExpandAllItems();
					
					SalesForecastProgramSalespersonSelected.DataSource = PopulateSalesForecastProgramSalespersonSelected(filter, filterValue);
					SalesForecastProgramSalespersonSelected.DataBind();
					
					SalesForecastProgramSalespersonSelected.Visible = iBtnSalesForecastProgramSalespersonSelected.Visible = true;
					
					SalesForecastSelected.Visible = iBtnSalesForecastSelected.Visible = false;
					SalesForecastCustomerSelected.Visible = iBtnSalesForecastCustomerSelected.Visible = false;
					SalesForecastParentCustomerSelected.Visible = iBtnSalesForecastParentCustomerSelected.Visible = false;
				}
				else
				{
					//SalesForecastSingleRowRadTreeList.DataSource = PopulateSalesForecastTree(filter, filterValue);
					////SalesForecastSingleRowRadTreeList.DataBind();
					//SalesForecastSingleRowRadTreeList.ExpandAllItems();
					
					SalesForecastSelected.DataSource = PopulateSalesForecastSelected(filter, filterValue);
					SalesForecastSelected.DataBind();
					
					SalesForecastSelected.Visible = iBtnSalesForecastSelected.Visible = true;
					
					SalesForecastCustomerSelected.Visible = iBtnSalesForecastCustomerSelected.Visible = false;
					SalesForecastParentCustomerSelected.Visible = iBtnSalesForecastParentCustomerSelected.Visible = false;
					SalesForecastProgramSalespersonSelected.Visible = iBtnSalesForecastProgramSalespersonSelected.Visible = false;
				}
				

				QuoteLogRadGrid.DataSource = PopulateQuoteLogGrid(filter, filterValue);
				QuoteLogRadGrid.DataBind();

				divSalesForecast.Visible = divSalesForecastVolumesSelected.Visible = false;
				divSalesForecastSelected.Visible = divQuoteLogGrid.Visible = divButton.Visible = true;
	
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

	protected void SalesForecastSelected_SortCommand(object source, GridSortCommandEventArgs e)
	{
	//RadWindowManager1.RadAlert("In sort command", 330, 180, "Message", "");
	
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastSelected.MasterTableView.Rebind();
	}
	
	protected void SalesForecastCustomerSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastCustomerSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastCustomerSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastCustomerSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastCustomerSelected.MasterTableView.Rebind();
   	}
	
	protected void SalesForecastParentCustomerSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastParentCustomerSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastParentCustomerSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastParentCustomerSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastParentCustomerSelected.MasterTableView.Rebind();
   	}
	
	protected void SalesForecastProgramSalespersonSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastProgramSalespersonSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastProgramSalespersonSelected.MasterTableView.Rebind();
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
				
				
				if (filter == "Customer")
				{
					SalesForecastVolumesCustomerSelected.DataSource = PopulateSalesForecastVolumesCustomerSelected(filter, filterValue);
					SalesForecastVolumesCustomerSelected.DataBind();
					
					SalesForecastVolumesCustomerSelected.Visible = iBtnSalesForecastVolumesCustomerSelected.Visible = true;
					
					SalesForecastVolumesSelected.Visible = iBtnSalesForecastVolumesSelected.Visible = false;	
					SalesForecastVolumesParentCustomerSelected.Visible = iBtnSalesForecastVolumesParentCustomerSelected.Visible = false;
					SalesForecastVolumesProgramSalespersonSelected.Visible = iBtnSalesForecastVolumesProgramSalespersonSelected.Visible = false;			
				}
				else if (filter == "Parent Customer")
				{
					SalesForecastVolumesParentCustomerSelected.DataSource = PopulateSalesForecastVolumesParentCustomerSelected(filter, filterValue);
					SalesForecastVolumesParentCustomerSelected.DataBind();
					
					SalesForecastVolumesParentCustomerSelected.Visible = iBtnSalesForecastVolumesParentCustomerSelected.Visible = true;
					
					SalesForecastVolumesSelected.Visible = iBtnSalesForecastVolumesSelected.Visible = false;	
					SalesForecastVolumesCustomerSelected.Visible = iBtnSalesForecastVolumesCustomerSelected.Visible = false;
					SalesForecastVolumesProgramSalespersonSelected.Visible = iBtnSalesForecastVolumesProgramSalespersonSelected.Visible = false;
				}
				else if (filter == "Program" || filter == "Salesperson")
				{
					SalesForecastVolumesProgramSalespersonSelected.DataSource = PopulateSalesForecastVolumesProgramSalespersonSelected(filter, filterValue);
					SalesForecastVolumesProgramSalespersonSelected.DataBind();
					
					SalesForecastVolumesProgramSalespersonSelected.Visible = iBtnSalesForecastVolumesProgramSalespersonSelected.Visible = true;
					
					SalesForecastVolumesSelected.Visible = iBtnSalesForecastVolumesSelected.Visible = false;
					SalesForecastVolumesCustomerSelected.Visible = iBtnSalesForecastVolumesCustomerSelected.Visible = false;
					SalesForecastVolumesParentCustomerSelected.Visible = iBtnSalesForecastVolumesParentCustomerSelected.Visible = false;
				}
				else
				{
					SalesForecastVolumesSelected.DataSource = PopulateSalesForecastVolumesSelected(filter, filterValue);
					SalesForecastVolumesSelected.DataBind();
					
					SalesForecastVolumesSelected.Visible = iBtnSalesForecastVolumesSelected.Visible = true;
					
					SalesForecastVolumesCustomerSelected.Visible = iBtnSalesForecastVolumesCustomerSelected.Visible = false;
					SalesForecastVolumesParentCustomerSelected.Visible = iBtnSalesForecastVolumesParentCustomerSelected.Visible = false;
					SalesForecastVolumesProgramSalespersonSelected.Visible = iBtnSalesForecastVolumesProgramSalespersonSelected.Visible = false;
				}
				

				QuoteLogRadGrid.DataSource = PopulateQuoteLogGrid(filter, filterValue);
				QuoteLogRadGrid.DataBind();

				divSalesForecastVolumes.Visible = divSalesForecastSelected.Visible = false;
				divSalesForecastVolumesSelected.Visible = divQuoteLogGrid.Visible = divButton.Visible = true;
	
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
	
	protected void SalesForecastVolumesSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastVolumesSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastVolumesSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastVolumesSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastVolumesSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastVolumesSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastVolumesSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastVolumesSelected.MasterTableView.Rebind();
   	}
	
	protected void SalesForecastVolumesCustomerSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastVolumesCustomerSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastVolumesCustomerSelected.MasterTableView.Rebind();
   	}
	
	protected void SalesForecastVolumesParentCustomerSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastVolumesParentCustomerSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastVolumesParentCustomerSelected.MasterTableView.Rebind();
   	}
	
	protected void SalesForecastVolumesProgramSalespersonSelected_SortCommand(object source, GridSortCommandEventArgs e)
   	{
			e.Canceled = true;
	    	GridSortExpression expression = new GridSortExpression();
	    	expression.FieldName = e.SortExpression;
	    	if (SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions.Count == 0 ||
	        	SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions[0].FieldName != e.SortExpression)
    		{
        		expression.SortOrder = GridSortOrder.Descending;
    		}
        	else if (SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
        	{
         	   expression.SortOrder = GridSortOrder.Ascending;
        	}
        	else if (SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
        	{
        	    expression.SortOrder = GridSortOrder.None;
        	}
        	else if (SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions[0].SortOrder == GridSortOrder.None)
        	{
        	   expression.SortOrder = GridSortOrder.Descending;
       		}
       		SalesForecastVolumesProgramSalespersonSelected.MasterTableView.SortExpressions.AddSortExpression(expression);	
			SalesForecastVolumesProgramSalespersonSelected.MasterTableView.Rebind();
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
		
		divSalesForecastSelected.Visible = divSalesForecastVolumesSelected.Visible = divQuoteLogGrid.Visible = divButton.Visible = false;
		
		divSelectFilter.Visible = true;
    }
	
	
	protected void iBtnSalesForecastSummariesRadGrid_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastSummariesRadGrid.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	//SalesForecastSummariesRadGrid.ExportSettings.IgnorePaging = CheckBox1.Checked;
    	SalesForecastSummariesRadGrid.ExportSettings.ExportOnlyData = true;
    	SalesForecastSummariesRadGrid.ExportSettings.OpenInNewWindow = true;
		SalesForecastSummariesRadGrid.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastCustomerSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastCustomerSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastCustomerSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastCustomerSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastCustomerSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastCustomerSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastParentCustomerSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastParentCustomerSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastParentCustomerSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastParentCustomerSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastParentCustomerSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastParentCustomerSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastProgramSalespersonSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastProgramSalespersonSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastProgramSalespersonSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastProgramSalespersonSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastProgramSalespersonSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastProgramSalespersonSelected.MasterTableView.ExportToExcel();
	}	


	protected void iBtnSalesForecastVolumesRadGrid_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastVolumesRadGrid.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastVolumesRadGrid.ExportSettings.IgnorePaging = true;
    	SalesForecastVolumesRadGrid.ExportSettings.ExportOnlyData = true;
    	SalesForecastVolumesRadGrid.ExportSettings.OpenInNewWindow = true;
		SalesForecastVolumesRadGrid.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastVolumesSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastVolumesSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastVolumesSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastVolumesSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastVolumesSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastVolumesSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastVolumesCustomerSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastVolumesCustomerSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastVolumesCustomerSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastVolumesCustomerSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastVolumesCustomerSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastVolumesCustomerSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastVolumesParentCustomerSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastVolumesParentCustomerSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastVolumesParentCustomerSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastVolumesParentCustomerSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastVolumesParentCustomerSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastVolumesParentCustomerSelected.MasterTableView.ExportToExcel();
	}
	
	protected void iBtnSalesForecastVolumesProgramSalespersonSelected_Click(object sender, ImageClickEventArgs e)
	{
		SalesForecastVolumesProgramSalespersonSelected.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
    	SalesForecastVolumesProgramSalespersonSelected.ExportSettings.IgnorePaging = true;
    	SalesForecastVolumesProgramSalespersonSelected.ExportSettings.ExportOnlyData = true;
    	SalesForecastVolumesProgramSalespersonSelected.ExportSettings.OpenInNewWindow = true;
		SalesForecastVolumesProgramSalespersonSelected.MasterTableView.ExportToExcel();
	}


	protected void iBtnQuoteLogRadGrid_Click(object sender, ImageClickEventArgs e)
	{
		QuoteLogRadGrid.ExportSettings.Excel.Format = (GridExcelExportFormat)Enum.Parse(typeof(GridExcelExportFormat), "Xlsx");
   		QuoteLogRadGrid.ExportSettings.IgnorePaging = true;
    	QuoteLogRadGrid.ExportSettings.ExportOnlyData = true;
    	QuoteLogRadGrid.ExportSettings.OpenInNewWindow = true;
		QuoteLogRadGrid.MasterTableView.ExportToExcel();
	}


protected void SalesForecastSummariesRadGridDataSource_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.CommandTimeout = 120;
        }


	private List<SalesForecast> PopulateSalesForecast(string filter)
	{
		SalesForecast salesForecast;
		List<SalesForecast> list = new List<SalesForecast>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_MaterialPercentage", connection);
				command.CommandTimeout = 180;
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = null;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecast = new SalesForecast();

						salesForecast.Filter = reader["Filter"].ToString();
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
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.ID, 330, 180, "Message", "");
		//}
		return list;
	}
	
	private List<SalesForecastVolumes> PopulateSalesForecastVolumes(string filter)
	{
		SalesForecastVolumes salesForecastVolumes;
		List<SalesForecastVolumes> list = new List<SalesForecastVolumes>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Volumes", connection);
				command.CommandTimeout = 120;
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = null;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumes = new SalesForecastVolumes();

						salesForecastVolumes.Filter = reader["Filter"].ToString();
						salesForecastVolumes.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumes.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumes.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumes.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumes.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumes.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumes.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						salesForecastVolumes.TotalDemand_2023 = ReaderToDecimal(reader, "TotalDemand_2023");
						salesForecastVolumes.TotalDemand_2024 = ReaderToDecimal(reader, "TotalDemand_2024");
						salesForecastVolumes.TotalDemand_2025 = ReaderToDecimal(reader, "TotalDemand_2025");
						
						salesForecastVolumes.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumes.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumes.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumes.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumes.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumes.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastVolumes.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastVolumes.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastVolumes.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						list.Add(salesForecastVolumes);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.Message, 330, 180, "Error at Sales Forecast Volumes", "");
		}
		//foreach(var item in treeList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.ID, 330, 180, "Message", "");
		//}
		return list;
	}




	private List<SalesForecastSelected> PopulateSalesForecastSelected(string filter, string filterValue)
	{
		SalesForecastSelected salesForecastSelected;
		List<SalesForecastSelected> selectedList = new List<SalesForecastSelected>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_BasePartFirst", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastSelected = new SalesForecastSelected();

						salesForecastSelected.BasePart = reader["base_part"].ToString();
						salesForecastSelected.ProductLine = reader["product_line"].ToString();
						salesForecastSelected.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();
						salesForecastSelected.EmpireApplication = reader["empire_application"].ToString();
							
						salesForecastSelected.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastSelected.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastSelected.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastSelected.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastSelected.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastSelected.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastSelected.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						salesForecastSelected.Sales_2023 = ReaderToDecimal(reader, "Sales_2023");
						salesForecastSelected.Sales_2024 = ReaderToDecimal(reader, "Sales_2024");
						salesForecastSelected.Sales_2025 = ReaderToDecimal(reader, "Sales_2025");						
						
						salesForecastSelected.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastSelected.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastSelected.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastSelected.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastSelected.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastSelected.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastSelected.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastSelected.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastSelected.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastSelected);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastSelected", "");
		}
		//foreach(var item in selectedList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.Filter, 330, 180, "Message", "");
		//}
		return selectedList;
	}
	
	private List<SalesForecastSelectedCustomer> PopulateSalesForecastCustomerSelected(string filter, string filterValue)
	{
		SalesForecastSelectedCustomer salesForecastSelectedCustomer;
		List<SalesForecastSelectedCustomer> selectedList = new List<SalesForecastSelectedCustomer>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Customer_BasePartFirst", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastSelectedCustomer = new SalesForecastSelectedCustomer();

						salesForecastSelectedCustomer.BasePart = reader["base_part"].ToString();	
						salesForecastSelectedCustomer.Program = reader["program"].ToString();
						salesForecastSelectedCustomer.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();
						salesForecastSelectedCustomer.EmpireApplication = reader["empire_application"].ToString();
							
						salesForecastSelectedCustomer.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastSelectedCustomer.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastSelectedCustomer.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastSelectedCustomer.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastSelectedCustomer.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastSelectedCustomer.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastSelectedCustomer.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						salesForecastSelectedCustomer.Sales_2023 = ReaderToDecimal(reader, "Sales_2023");
						salesForecastSelectedCustomer.Sales_2024 = ReaderToDecimal(reader, "Sales_2024");
						salesForecastSelectedCustomer.Sales_2025 = ReaderToDecimal(reader, "Sales_2025");
						
						salesForecastSelectedCustomer.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastSelectedCustomer.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastSelectedCustomer.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastSelectedCustomer.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastSelectedCustomer.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastSelectedCustomer.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastSelectedCustomer.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastSelectedCustomer.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastSelectedCustomer.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastSelectedCustomer);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastSelectedCustomer", "");
		}
		return selectedList;
	}
	
	private List<SalesForecastSelectedParentCustomer> PopulateSalesForecastParentCustomerSelected(string filter, string filterValue)
	{
		SalesForecastSelectedParentCustomer salesForecastSelectedParentCustomer;
		List<SalesForecastSelectedParentCustomer> selectedList = new List<SalesForecastSelectedParentCustomer>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_ParentCust_BasePartFirst", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastSelectedParentCustomer = new SalesForecastSelectedParentCustomer();

						salesForecastSelectedParentCustomer.BasePart = reader["base_part"].ToString();	
						salesForecastSelectedParentCustomer.Customer = reader["customer"].ToString();
						salesForecastSelectedParentCustomer.Program = reader["program"].ToString();
						salesForecastSelectedParentCustomer.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();
						salesForecastSelectedParentCustomer.EmpireApplication = reader["empire_application"].ToString();
							
						salesForecastSelectedParentCustomer.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastSelectedParentCustomer.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastSelectedParentCustomer.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastSelectedParentCustomer.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastSelectedParentCustomer.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastSelectedParentCustomer.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastSelectedParentCustomer.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						salesForecastSelectedParentCustomer.Sales_2023 = ReaderToDecimal(reader, "Sales_2023");
						salesForecastSelectedParentCustomer.Sales_2024 = ReaderToDecimal(reader, "Sales_2024");
						salesForecastSelectedParentCustomer.Sales_2025 = ReaderToDecimal(reader, "Sales_2025");
						
						salesForecastSelectedParentCustomer.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastSelectedParentCustomer.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastSelectedParentCustomer.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastSelectedParentCustomer.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastSelectedParentCustomer.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastSelectedParentCustomer.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastSelectedParentCustomer.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastSelectedParentCustomer.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastSelectedParentCustomer.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastSelectedParentCustomer);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastSelectedParentCustomer", "");
		}
		return selectedList;
	}
	
	private List<SalesForecastSelectedProgramSalesperson> PopulateSalesForecastProgramSalespersonSelected(string filter, string filterValue)
	{
		SalesForecastSelectedProgramSalesperson salesForecastSelectedProgramSalesperson;
		List<SalesForecastSelectedProgramSalesperson> selectedList = new List<SalesForecastSelectedProgramSalesperson>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_ProgramSalesperson_BasePartFirst", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastSelectedProgramSalesperson = new SalesForecastSelectedProgramSalesperson();

						salesForecastSelectedProgramSalesperson.BasePart = reader["base_part"].ToString();	
						salesForecastSelectedProgramSalesperson.Customer = reader["customer"].ToString();
						salesForecastSelectedProgramSalesperson.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();
						salesForecastSelectedProgramSalesperson.EmpireApplication = reader["empire_application"].ToString();
							
						salesForecastSelectedProgramSalesperson.Sales_2016 = ReaderToDecimal(reader, "Sales_2016");
						salesForecastSelectedProgramSalesperson.Sales_2017 = ReaderToDecimal(reader, "Sales_2017");
						salesForecastSelectedProgramSalesperson.Sales_2018 = ReaderToDecimal(reader, "Sales_2018");
						salesForecastSelectedProgramSalesperson.Sales_2019 = ReaderToDecimal(reader, "Sales_2019");
						salesForecastSelectedProgramSalesperson.Sales_2020 = ReaderToDecimal(reader, "Sales_2020");
						salesForecastSelectedProgramSalesperson.Sales_2021 = ReaderToDecimal(reader, "Sales_2021");
						salesForecastSelectedProgramSalesperson.Sales_2022 = ReaderToDecimal(reader, "Sales_2022");
						salesForecastSelectedProgramSalesperson.Sales_2023 = ReaderToDecimal(reader, "Sales_2023");
						salesForecastSelectedProgramSalesperson.Sales_2024 = ReaderToDecimal(reader, "Sales_2024");
						salesForecastSelectedProgramSalesperson.Sales_2025 = ReaderToDecimal(reader, "Sales_2025");
						
						salesForecastSelectedProgramSalesperson.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastSelectedProgramSalesperson.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastSelectedProgramSalesperson.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastSelectedProgramSalesperson.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastSelectedProgramSalesperson.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastSelectedProgramSalesperson.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastSelectedProgramSalesperson.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastSelectedProgramSalesperson.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastSelectedProgramSalesperson.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastSelectedProgramSalesperson);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastSelectedProgramSalesperson", "");
		}
		//foreach(var item in selectedList)
		//{
		//	RadWindowManager1.RadAlert("ListItem: " + item.Filter, 330, 180, "Message", "");
		//}
		return selectedList;
	}
	



	private List<SalesForecastVolumesSelected> PopulateSalesForecastVolumesSelected(string filter, string filterValue)
	{
		SalesForecastVolumesSelected salesForecastVolumesSelected;
		List<SalesForecastVolumesSelected> selectedList = new List<SalesForecastVolumesSelected>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Volumes_BasePartFirst", connection);
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesSelected = new SalesForecastVolumesSelected();

						salesForecastVolumesSelected.BasePart = reader["base_part"].ToString();
						salesForecastVolumesSelected.ProductLine = reader["product_line"].ToString();
						salesForecastVolumesSelected.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastVolumesSelected.EmpireApplication = reader["empire_application"].ToString();	
		
						salesForecastVolumesSelected.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesSelected.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesSelected.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesSelected.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesSelected.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesSelected.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesSelected.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");						
						salesForecastVolumesSelected.TotalDemand_2023 = ReaderToDecimal(reader, "TotalDemand_2023");
						salesForecastVolumesSelected.TotalDemand_2024 = ReaderToDecimal(reader, "TotalDemand_2024");
						salesForecastVolumesSelected.TotalDemand_2025 = ReaderToDecimal(reader, "TotalDemand_2025");						
						
						salesForecastVolumesSelected.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesSelected.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesSelected.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesSelected.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesSelected.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesSelected.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastVolumesSelected.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastVolumesSelected.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastVolumesSelected.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastVolumesSelected);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "Error at PopulateSalesForecastVolumesTree", "");
		}
		return selectedList;
	}
	
	private List<SalesForecastVolumesCustomerSelected> PopulateSalesForecastVolumesCustomerSelected(string filter, string filterValue)
	{
		SalesForecastVolumesCustomerSelected salesForecastVolumesCustomerSelected;
		List<SalesForecastVolumesCustomerSelected> selectedList = new List<SalesForecastVolumesCustomerSelected>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Volumes_Customer_BasePartFirst", connection);
				command.CommandTimeout = 60; 
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesCustomerSelected = new SalesForecastVolumesCustomerSelected();

						salesForecastVolumesCustomerSelected.BasePart = reader["base_part"].ToString();
						salesForecastVolumesCustomerSelected.Program = reader["program"].ToString();	
						salesForecastVolumesCustomerSelected.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastVolumesCustomerSelected.EmpireApplication = reader["empire_application"].ToString();	
		
						salesForecastVolumesCustomerSelected.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesCustomerSelected.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesCustomerSelected.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesCustomerSelected.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesCustomerSelected.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesCustomerSelected.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesCustomerSelected.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						salesForecastVolumesCustomerSelected.TotalDemand_2023 = ReaderToDecimal(reader, "TotalDemand_2023");
						salesForecastVolumesCustomerSelected.TotalDemand_2024 = ReaderToDecimal(reader, "TotalDemand_2024");
						salesForecastVolumesCustomerSelected.TotalDemand_2025 = ReaderToDecimal(reader, "TotalDemand_2025");
						
						salesForecastVolumesCustomerSelected.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesCustomerSelected.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesCustomerSelected.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesCustomerSelected.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesCustomerSelected.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesCustomerSelected.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastVolumesCustomerSelected.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastVolumesCustomerSelected.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastVolumesCustomerSelected.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastVolumesCustomerSelected);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "PopulateSalesForecastVolumesCustomerSelected", "");
		}
		return selectedList;
	}
	
	private List<SalesForecastVolumesParentCustomerSelected> PopulateSalesForecastVolumesParentCustomerSelected(string filter, string filterValue)
	{
		SalesForecastVolumesParentCustomerSelected salesForecastVolumesParentCustomerSelected;
		List<SalesForecastVolumesParentCustomerSelected> selectedList = new List<SalesForecastVolumesParentCustomerSelected>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Volumes_ParentCust_BasePartFirst", connection);
				command.CommandTimeout = 60; 
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesParentCustomerSelected = new SalesForecastVolumesParentCustomerSelected();

						salesForecastVolumesParentCustomerSelected.BasePart = reader["base_part"].ToString();
						salesForecastVolumesParentCustomerSelected.Customer = reader["customer"].ToString();	
						salesForecastVolumesParentCustomerSelected.Program = reader["program"].ToString();	
						salesForecastVolumesParentCustomerSelected.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastVolumesParentCustomerSelected.EmpireApplication = reader["empire_application"].ToString();	
		
						salesForecastVolumesParentCustomerSelected.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2023 = ReaderToDecimal(reader, "TotalDemand_2023");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2024 = ReaderToDecimal(reader, "TotalDemand_2024");
						salesForecastVolumesParentCustomerSelected.TotalDemand_2025 = ReaderToDecimal(reader, "TotalDemand_2025");
						
						salesForecastVolumesParentCustomerSelected.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesParentCustomerSelected.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesParentCustomerSelected.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesParentCustomerSelected.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesParentCustomerSelected.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesParentCustomerSelected.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastVolumesParentCustomerSelected.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastVolumesParentCustomerSelected.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastVolumesParentCustomerSelected.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastVolumesParentCustomerSelected);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "PopulateSalesForecastVolumesParentCustomerSelected", "");
		}
		return selectedList;
	}
	
	private List<SalesForecastVolumesProgramSalespersonSelected> PopulateSalesForecastVolumesProgramSalespersonSelected(string filter, string filterValue)
	{
		SalesForecastVolumesProgramSalespersonSelected salesForecastVolumesProgramSalespersonSelected;
		List<SalesForecastVolumesProgramSalespersonSelected> selectedList = new List<SalesForecastVolumesProgramSalespersonSelected>();
			
		try
		{
			using(SqlConnection connection = new SqlConnection("Server=eeisql1;Database=MONITOR;User Id=Andre;"))
			{
	    		SqlCommand command = new SqlCommand("eeiuser.usp_WP_SalesForecastSummaries_Selected_Volumes_ProgramSalesperson_BasePartFirst", connection);
				command.CommandTimeout = 120; 
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.Add("@Filter", SqlDbType.VarChar).Value = filter;
				command.Parameters.Add("@FilterValue", SqlDbType.VarChar).Value = filterValue;
				connection.Open();
				using (SqlDataReader reader = command.ExecuteReader())
				{
	    			while (reader.Read())
					{
						salesForecastVolumesProgramSalespersonSelected = new SalesForecastVolumesProgramSalespersonSelected();

						salesForecastVolumesProgramSalespersonSelected.BasePart = reader["base_part"].ToString();
						salesForecastVolumesProgramSalespersonSelected.Customer = reader["customer"].ToString();	
						salesForecastVolumesProgramSalespersonSelected.EmpireMarketSubsegment = reader["empire_market_subsegment"].ToString();	
						salesForecastVolumesProgramSalespersonSelected.EmpireApplication = reader["empire_application"].ToString();	
		
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2016 = ReaderToDecimal(reader, "TotalDemand_2016");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2017 = ReaderToDecimal(reader, "TotalDemand_2017");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2018 = ReaderToDecimal(reader, "TotalDemand_2018");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2019 = ReaderToDecimal(reader, "TotalDemand_2019");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2020 = ReaderToDecimal(reader, "TotalDemand_2020");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2021 = ReaderToDecimal(reader, "TotalDemand_2021");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2022 = ReaderToDecimal(reader, "TotalDemand_2022");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2023 = ReaderToDecimal(reader, "TotalDemand_2023");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2024 = ReaderToDecimal(reader, "TotalDemand_2024");
						salesForecastVolumesProgramSalespersonSelected.TotalDemand_2025 = ReaderToDecimal(reader, "TotalDemand_2025");
						
						salesForecastVolumesProgramSalespersonSelected.Change_2017 = ReaderToDecimal(reader, "Change_2017");
						salesForecastVolumesProgramSalespersonSelected.Change_2018 = ReaderToDecimal(reader, "Change_2018");
						salesForecastVolumesProgramSalespersonSelected.Change_2019 = ReaderToDecimal(reader, "Change_2019");
						salesForecastVolumesProgramSalespersonSelected.Change_2020 = ReaderToDecimal(reader, "Change_2020");
						salesForecastVolumesProgramSalespersonSelected.Change_2021 = ReaderToDecimal(reader, "Change_2021");
						salesForecastVolumesProgramSalespersonSelected.Change_2022 = ReaderToDecimal(reader, "Change_2022");
						salesForecastVolumesProgramSalespersonSelected.Change_2023 = ReaderToDecimal(reader, "Change_2023");
						salesForecastVolumesProgramSalespersonSelected.Change_2024 = ReaderToDecimal(reader, "Change_2024");
						salesForecastVolumesProgramSalespersonSelected.Change_2025 = ReaderToDecimal(reader, "Change_2025");
												
						selectedList.Add(salesForecastVolumesProgramSalespersonSelected);
					}
				}
				connection.Close();
			}
		}
		catch (Exception ex)
		{
			RadWindowManager1.RadAlert("Error: " + ex.InnerException.Message, 330, 180, "PopulateSalesForecastVolumesProgramSalespersonSelected", "");
		}
		return selectedList;
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
				command.CommandTimeout = 60;
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
						quoteLog.ReceiptDate = reader["ReceiptDate"].ToString();
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
					SalesForecastVolumesRadGrid.Height = 590;
					break;
				case "Parent Customer":
					SalesForecastSummariesRadGrid.Height = 580;
					SalesForecastVolumesRadGrid.Height = 580;
					break;
				case "Product Line":
					SalesForecastSummariesRadGrid.Height = 293;
					SalesForecastVolumesRadGrid.Height = 293;
					break;
				case "Program":
					SalesForecastSummariesRadGrid.Height = 590;
					SalesForecastVolumesRadGrid.Height = 590;
					break;
				case "Salesperson":
					SalesForecastSummariesRadGrid.Height = 233;
					SalesForecastVolumesRadGrid.Height = 233;
					break;
				case "Segment":
					SalesForecastSummariesRadGrid.Height = 473;
					SalesForecastVolumesRadGrid.Height = 473;
					break;	
				case "Vehicle":
					SalesForecastSummariesRadGrid.Height = 590;
					SalesForecastVolumesRadGrid.Height = 590;
					break;	
			}
		}


}

public partial class SalesForecast
{
    public string Filter { get; set; }
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

public class SalesForecastSelected
{
	public string BasePart { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public string ProductLine {get; set;}
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

public class SalesForecastSelectedCustomer
{
	public string Program { get; set; }
	public string BasePart { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
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

public class SalesForecastSelectedParentCustomer
{
	public string Customer {get; set; }
	public string Program { get; set; }
	public string BasePart { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
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

public class SalesForecastSelectedProgramSalesperson
{
	public string BasePart { get; set; }
	public string Customer { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
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

public class SalesForecastVolumes
{
	public string Filter { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? TotalDemand_2023 { get; set; }
	public decimal? TotalDemand_2024 { get; set; }
	public decimal? TotalDemand_2025 { get; set; }
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

public class SalesForecastVolumesSelected
{
	public string BasePart { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public string ProductLine {get; set;}
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? TotalDemand_2023 { get; set; }
	public decimal? TotalDemand_2024 { get; set; }
	public decimal? TotalDemand_2025 { get; set; }
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

public class SalesForecastVolumesCustomerSelected
{
	public string BasePart { get; set; }
	public string Program { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? TotalDemand_2023 { get; set; }
	public decimal? TotalDemand_2024 { get; set; }
	public decimal? TotalDemand_2025 { get; set; }
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

public class SalesForecastVolumesParentCustomerSelected
{
	public string BasePart { get; set; }
	public string Customer { get; set; }
	public string Program { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? TotalDemand_2023 { get; set; }
	public decimal? TotalDemand_2024 { get; set; }
	public decimal? TotalDemand_2025 { get; set; }
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

public class SalesForecastVolumesProgramSalespersonSelected
{
	public string BasePart { get; set; }
	public string Customer { get; set; }
	public string EmpireMarketSubsegment { get; set; }
	public string EmpireApplication { get; set; }
	public decimal? TotalDemand_2016 { get; set; }
	public decimal? TotalDemand_2017 { get; set; }
	public decimal? TotalDemand_2018 { get; set; }
	public decimal? TotalDemand_2019 { get; set; }
	public decimal? TotalDemand_2020 { get; set; }
	public decimal? TotalDemand_2021 { get; set; }
	public decimal? TotalDemand_2022 { get; set; }
	public decimal? TotalDemand_2023 { get; set; }
	public decimal? TotalDemand_2024 { get; set; }
	public decimal? TotalDemand_2025 { get; set; }
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

public class QuoteLog
{
	public string QuoteNumber { get; set; }
	public string Customer { get; set; }
	public string Program { get; set; }
	public string EEIPartNumber { get; set; }
	public string Nameplate { get; set; }
	public string ReceiptDate { get; set; }
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
