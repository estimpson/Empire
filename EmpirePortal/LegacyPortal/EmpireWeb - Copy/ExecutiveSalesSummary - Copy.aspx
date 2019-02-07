<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExecutiveSalesSummary - Copy.aspx.cs" Inherits="ExecutiveSalesSummary" %> 

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Executive Sales Summary</title>


<telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" >
    <StyleSheets>
        <Telerik:StyleSheetReference Name="Telerik.Web.UI.Skins.RadGrid.Silk.css" Assembly="Telerik.Web.UI" />
    </StyleSheets>
</telerik:RadStyleSheetManager>&nbsp;<style type="text/css">
    .RadInput_Default{font:12px "segoe ui",arial,sans-serif}
    .RadInput{vertical-align:middle}
    .style1
    {
        border-collapse: collapse;
        width: 100%;
        vertical-align: bottom;
        border-style: none;
        border-color: inherit;
        border-width: 0;
    }
    .style2
    {
        width: 100%;
        padding-right: 4px;
    }
    .style3 {
        display: inline-table;
    }
	body {
    	font-family: Arial;
    	font-size: 14px;
	}
	.divReturnLink
	{
		font-size: 10px; 
		color: #ccd1d1; 
		margin-top: 3px;
		margin-bottom: 15px;
	}
	.divReturnLink:hover{
    	color:#000000 !important;
	}
</style><script type="text/javascript">
function pageLoad()
{
$(function(){
	$(".divReturnLink").click(function(){
          $('html, body').animate({ scrollTop: 0 }, 0);
	})
});
}
</script></head><body><form id="form1" runat="server">

<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">


    

<telerik:RadScriptManager ID="RadScriptManager1" runat="server">
	<Scripts>
		<%--Needed for JavaScript IntelliSense in VS2010--%>
        <%--For VS2008 replace RadScriptManager with ScriptManager--%>
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
	</Scripts>
</telerik:RadScriptManager>


<telerik:RadAjaxManager runat="server">
	<AjaxSettings>
		<telerik:AjaxSetting AjaxControlID="FilterComboBox">
			<UpdatedControls>
		        	<Telerik:AjaxUpdatedControl ControlID="FilterComboBox" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecast" />
		       		<Telerik:AjaxUpdatedControl ControlID="SalesForecastSummariesRadGrid" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastVolumes" />
				<Telerik:AjaxUpdatedControl ControlID="SalesForecastVolumesRadGrid" />
		    	</UpdatedControls>
		</telerik:AjaxSetting>

        	<telerik:AjaxSetting AjaxControlID="SalesForecastSummariesRadGrid">
            		<UpdatedControls>
                		<Telerik:AjaxUpdatedControl ControlID="divSalesForecast" />
				<Telerik:AjaxUpdatedControl ControlID="SalesForecastSummariesRadGrid" />
				<Telerik:AjaxUpdatedControl ControlID="divQuoteLogGrid" />
				<Telerik:AjaxUpdatedControl ControlID="QuoteLogRadGrid" />
	    			<Telerik:AjaxUpdatedControl ControlID="divButton" />
				<Telerik:AjaxUpdatedControl ControlID="divSelectFilter" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastSingleRowTreeList" />
				<Telerik:AjaxUpdatedControl ControlID="SalesForecastSingleRowRadTreeList" />				
				<Telerik:AjaxUpdatedControl ControlID="lblCustomer" />
				<Telerik:AjaxUpdatedControl ControlID="divToggleSalesVolume" />
			</UpdatedControls>
        	</telerik:AjaxSetting>

	    	<telerik:AjaxSetting AjaxControlID="RadButtonShowAll">
            		<UpdatedControls>
	    			<Telerik:AjaxUpdatedControl ControlID="divSalesForecast" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastSingleRowTreeList" />
				<Telerik:AjaxUpdatedControl ControlID="divQuoteLogGrid" />
				<Telerik:AjaxUpdatedControl ControlID="divButton" />
				<Telerik:AjaxUpdatedControl ControlID="RadButtonShowAll" />
				<Telerik:AjaxUpdatedControl ControlID="divSelectFilter" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastTreeListVolumes" />
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastVolumes" />
				<Telerik:AjaxUpdatedControl ControlID="divToggleSalesVolume" />
			</UpdatedControls>
        	</telerik:AjaxSetting>


		<telerik:AjaxSetting AjaxControlID="SalesForecastSingleRowRadTreeList">
            		<UpdatedControls>
	    			<Telerik:AjaxUpdatedControl ControlID="SalesForecastSingleRowRadTreeList" />
            		</UpdatedControls>
        	</telerik:AjaxSetting>


	<telerik:AjaxSetting AjaxControlID="SalesForecastVolumesRadGrid">
            <UpdatedControls>
			<Telerik:AjaxUpdatedControl ControlID="SalesForecastVolumesRadGrid" />
				<Telerik:AjaxUpdatedControl ControlID="divQuoteLogGrid" />
				<Telerik:AjaxUpdatedControl ControlID="QuoteLogRadGrid" />
	    		<Telerik:AjaxUpdatedControl ControlID="divButton" />
				<Telerik:AjaxUpdatedControl ControlID="divSelectFilter" />
				
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastTreeListVolumes" />
				<Telerik:AjaxUpdatedControl ControlID="SalesForecastVolumesTreeList" />	
				
				<Telerik:AjaxUpdatedControl ControlID="divToggleSalesVolume" />			
            </UpdatedControls>
        </telerik:AjaxSetting>


	<telerik:AjaxSetting AjaxControlID="SalesForecastVolumesTreeList">
            <UpdatedControls>
	    		<Telerik:AjaxUpdatedControl ControlID="SalesForecastVolumesTreeList" />
            </UpdatedControls>
        </telerik:AjaxSetting>
		
		
		
		<telerik:AjaxSetting AjaxControlID="RadioButtonList1">
            <UpdatedControls>
				<Telerik:AjaxUpdatedControl ControlID="RadioButtonList1" />
				
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecast" />
				
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastSingleRowTreeList" />
					
	    		<Telerik:AjaxUpdatedControl ControlID="divSalesForecastVolumes" />
				
				<Telerik:AjaxUpdatedControl ControlID="divSalesForecastTreeListVolumes" />
				
				<Telerik:AjaxUpdatedControl ControlID="divQuoteLogGrid" />
            </UpdatedControls>
        </telerik:AjaxSetting>
		
		
		
		<telerik:AjaxSetting AjaxControlID="QuoteLogRadGrid">
            <UpdatedControls>
				<Telerik:AjaxUpdatedControl ControlID="divQuoteLogGrid" />
	    		<Telerik:AjaxUpdatedControl ControlID="QuoteLogRadGrid" />
            </UpdatedControls>
        </telerik:AjaxSetting>


		

    </AjaxSettings>
</telerik:RadAjaxManager>



<div style="margin-bottom: 17px; padding: 10px">

	<div style="font-size: 18px; color: #81CFDC; margin-bottom: 13px;">
		<asp:label ID="lblTitle" runat="server" Text="Executive Sales Summary" />
	</div>

	<div id="divSelectFilter" runat="server" style="float: left">

		<div style="float: left">   
    		<telerik:RadComboBox ID="FilterComboBox" runat="server" DataSourceID="FilterComboBoxDataSource" OnSelectedIndexChanged="FilterComboBox_SelectedIndexChanged"
            		DataTextField="Filter" DataValueField="Filter" MarkFirstMatch="true" AutoPostBack="true" Width="200"
					Skin="Default">
			</telerik:RadComboBox>

			<asp:SqlDataSource ID="FilterComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
				SelectCommand="select Filter from eeiuser.WP_SalesForecastSummaries_Filter order by Filter">
        	</asp:SqlDataSource>
		</div>

	</div>
	
	<div id="divButton" runat="server" style="float: left">
		<telerik:RadButton ID="RadButtonShowAll" runat="server" Text="Show All" Skin="Default" Width="200" OnClick="RadButtonShowAll_Click" />
	</div>
	

	<div id="divToggleSalesVolume" runat="server" style="float: left; margin-left: 57px; margin-top: 5px; font-size: 12px;">
		<telerik:RadRadioButtonList runat="server" ID="RadioButtonList1" AutoPostBack="True" Skin="Default" EnableViewState="True"  
			OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" Layout="Flow" Direction="Horizontal">
            <Items>
                <telerik:ButtonListItem Text="Sales" Value="0" />
                <telerik:ButtonListItem Text="Volume" Value="1" />
            </Items>
        </telerik:RadRadioButtonList>
	</div>
	
</div>




<div style="margin-bottom: 10px; padding: 10px">

	<telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true">
	</telerik:RadWindowManager>
	

	
	<div id="divSalesForecastVolumes" runat="server">

		<telerik:RadGrid ID="SalesForecastVolumesRadGrid" runat="server" CellSpacing="1" DataSourceID="SalesForecastVolumesRadGridDataSource"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnItemCommand="SalesForecastVolumesRadGrid_ItemCommand" 
				AllowSorting="True" OnSortCommand="SalesForecastVolumesRadGrid_SortCommand" ShowFooter="True"
				 Width="100%" Height="620px" EnableViewState="True">
                
			<MasterTableView DataSourceID="SalesForecastVolumesRadGridDataSource" HeaderStyle-HorizontalAlign="Left"
                		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
						AutoGenerateColumns="False" EnableViewState="True">

			<Columns>

            		<telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                		HeaderText="" ReadOnly="True" SortExpression="Filter" UniqueName="Filter">
					<HeaderStyle Width="200px" />
            		</telerik:GridBoundColumn> 
				<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		HeaderText="Total Demand 2016" ReadOnly="True" SortExpression="TotalDemand_2016" UniqueName="TotalDemand_2016" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		HeaderText="Total Demand 2017" ReadOnly="True" SortExpression="TotalDemand_2017" UniqueName="TotalDemand_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		HeaderText="TotalDemand 2018" ReadOnly="True" SortExpression="TotalDemand_2018" UniqueName="TotalDemand_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		HeaderText="Total Demand 2019" ReadOnly="True" SortExpression="TotalDemand_2019" UniqueName="TotalDemand_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		HeaderText="Total Demand 2020" ReadOnly="True" SortExpression="TotalDemand_2020" UniqueName="TotalDemand_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		HeaderText="Total Demand 2021" ReadOnly="True" SortExpression="TotalDemand_2021" UniqueName="TotalDemand_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		HeaderText="Total Demand 2022" ReadOnly="True" SortExpression="TotalDemand_2022" UniqueName="TotalDemand_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
            
			<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
			</Columns>

        	</MasterTableView>

            <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
                <Selecting AllowRowSelect="true"></Selecting>  
				<Scrolling AllowScroll="True" UseStaticHeaders="true" />
            </ClientSettings>

        </telerik:RadGrid>


    	<asp:SqlDataSource ID="SalesForecastVolumesRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
        	SelectCommand="eeiuser.usp_WP_SalesForecastSummaries_Volumes" SelectCommandType="StoredProcedure">
        	<SelectParameters>
            	<asp:ControlParameter ControlID="FilterComboBox" DefaultValue="Customer" Name="Filter" PropertyName="SelectedValue" Type="String" />
        	</SelectParameters>
    	</asp:SqlDataSource>


	</div>




	<div id="divSalesForecast" runat="server"> 

		<telerik:RadGrid ID="SalesForecastSummariesRadGrid" runat="server" CellSpacing="1" DataSourceID="SalesForecastSummariesRadGridDataSource"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnItemCommand="SalesForecastSummariesRadGrid_ItemCommand" 
				AllowSorting="True" OnSortCommand="SalesForecastSummariesRadGrid_SortCommand" ShowFooter="True"
				Skin="Default" Width="100%" Height="620px" EnableViewState="True">
                
			<MasterTableView DataSourceID="SalesForecastSummariesRadGridDataSource" HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">

			<Columns>

            	<telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                		HeaderText="" ReadOnly="True" SortExpression="Filter" UniqueName="Filter">
					<HeaderStyle Width="200px" />
            	</telerik:GridBoundColumn> 
				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
			</Columns>

        	</MasterTableView>

            <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
                <Selecting AllowRowSelect="true"></Selecting>
				<Scrolling AllowScroll="True" UseStaticHeaders="true" />
            </ClientSettings>

        </telerik:RadGrid>


    	<asp:SqlDataSource ID="SalesForecastSummariesRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
        	SelectCommand="eeiuser.usp_WP_SalesForecastSummaries" SelectCommandType="StoredProcedure">
        	<SelectParameters>
            	<asp:ControlParameter ControlID="FilterComboBox" DefaultValue="Customer" Name="Filter" PropertyName="SelectedValue" Type="String" />
        	</SelectParameters>
    	</asp:SqlDataSource>

	</div>


	
	<div id="divSalesForecastTreeListVolumes" style="margin-bottom: 25px" runat="server">
	
		<div style="font-size: 18px; color: #000000; margin-top: 22px; margin-bottom: 7px">
			<asp:label ID="lblVolumesTitle" runat="server" Skin="Default" Text="" />
		</div>
	
		<div style="font-size: 12px; color: #81CFDC; margin-bottom: 3px">
			<asp:label ID="lblVolumesMarketSubSegments" runat="server" Skin="Default" Text="Subsegment Breakdown" />
		</div>
	

		<telerik:RadTreeList ID="SalesForecastVolumesTreeList" runat="server" ExpandCollapseMode="Client"
            		AutoGenerateColumns="False" AllowSorting="False" ShowFooter="False" ShowTreeLines="False"
					Skin="Default" ParentDataKeyNames="ParentID" DataKeyNames="ID" >
			
		<Columns>
		

		<telerik:TreeListBoundColumn DataField="ID" HeaderText="ID" UniqueName="ID" Visible="False">
		</telerik:TreeListBoundColumn>

		<telerik:TreeListBoundColumn DataField="EmpireMarketSubsegment" HeaderText="Empire Market Subsegment" UniqueName="EmpireMarketSubsegment">			
                	<HeaderStyle Width="155px" />
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="EmpireApplication" HeaderText="Empire Application" UniqueName="EmpireApplication">			
                	<HeaderStyle Width="275px" />
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="BasePart" HeaderText="Base Part" UniqueName="BasePart">	
			<HeaderStyle Width="90px" />		
		</telerik:TreeListBoundColumn>


		<telerik:TreeListBoundColumn DataField="TotalDemand_2016" HeaderText="Total Demand 2016" UniqueName="TotalDemand_2016" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2017" HeaderText="Total Demand 2017" UniqueName="TotalDemand_2017" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2018" HeaderText="Total Demand 2018" UniqueName="TotalDemand_2018" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2019" HeaderText="Total Demand 2019" UniqueName="TotalDemand_2019" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2020" HeaderText="Total Demand 2020" UniqueName="TotalDemand_2020" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2021" HeaderText="Total Demand 2021" UniqueName="TotalDemand_2021" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="TotalDemand_2022" HeaderText="Total Demand 2022" UniqueName="TotalDemand_2022" DataFormatString="{0:N0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
		</telerik:TreeListBoundColumn>

		<telerik:TreeListBoundColumn DataField="Change_2017" DataType="System.Decimal" HeaderText="2017 v 2016 Variance" UniqueName="Change_2017" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2018" DataType="System.Decimal" HeaderText="2018 v 2017 Variance" UniqueName="Change_2018" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2019" DataType="System.Decimal" HeaderText="2019 v 2018 Variance" UniqueName="Change_2019" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2020" DataType="System.Decimal" HeaderText="2020 v 2019 Variance" UniqueName="Change_2020" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2021" DataType="System.Decimal" HeaderText="2021 v 2020 Variance" UniqueName="Change_2021" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2022" DataType="System.Decimal" HeaderText="2022 v 2021 Variance" UniqueName="Change_2022" FooterAggregateFormatString="{0:N0}"
                	DataFormatString="{0:N0}" Aggregate="Sum" EmptyDataText= "">
            	</telerik:TreeListBoundColumn>

		<telerik:TreeListBoundColumn DataField="ParentID" HeaderText="ParentID" UniqueName="ParentID" Visible="False">
		</telerik:TreeListBoundColumn>
				
				
		</Columns>
		
			<ClientSettings Selecting-AllowItemSelection="true">      
            </ClientSettings>

        </telerik:RadTreeList>		
		
		
		
		
		
		
		
		<telerik:RadGrid ID="SalesForecastVolumeOneRowRadGrid" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="False"
				AllowSorting="False" ShowFooter="False" OnItemDataBound="SalesForecastVolumeOneRowRadGrid_ItemDataBound"
				Skin="Default" Width="100%" Height="30px" EnableViewState="True">
                
			<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">

			<Columns>

            	<telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                		HeaderText="" ReadOnly="True" UniqueName="Filter">
					<HeaderStyle Width="510px" />
            	</telerik:GridBoundColumn> 
		
				<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		ReadOnly="True" UniqueName="TotalDemand_2016"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		ReadOnly="True" UniqueName="TotalDemand_2017"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		ReadOnly="True" UniqueName="TotalDemand_2018"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		ReadOnly="True" UniqueName="TotalDemand_2019"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		ReadOnly="True" UniqueName="TotalDemand_2020"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		ReadOnly="True" UniqueName="TotalDemand_2021"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		ReadOnly="True" UniqueName="TotalDemand_2022"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
            
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" UniqueName="Change_2017"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" UniqueName="Change_2018"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" UniqueName="Change_2019"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" UniqueName="Change_2020"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" UniqueName="Change_2021"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" UniqueName="Change_2022"
                		DataFormatString="{0:N0}">
            	</telerik:GridBoundColumn>
		
			</Columns>

        	</MasterTableView>

        </telerik:RadGrid>
		
		
		
		
		
		
		
		
		
		<div class="divReturnLink">
			Return to Top
		</div>

	</div>




	<div id="divSalesForecastSingleRowTreeList" style="margin-top: 22px; margin-bottom: 25px" runat="server">

	<div style="font-size: 18px; color: #000000; margin-bottom: 7px">
		<asp:label ID="lblSalesTitle" runat="server" Skin="Default" Text="" />
	</div>
	
	<div style="font-size: 12px; color: #81CFDC; margin-bottom: 3px">
		<asp:label ID="lblSalesMarketSubSegments" runat="server" Skin="Default" Text="Subsegment Breakdown" />
	</div>
	

	<telerik:RadTreeList ID="SalesForecastSingleRowRadTreeList" runat="server" ExpandCollapseMode="Client"
            	AutoGenerateColumns="False" AllowSorting="False" ShowFooter="False" ShowTreeLines="False"
		Skin="Default" ParentDataKeyNames="ParentID" DataKeyNames="ID" >
			
		<Columns>
		
		<telerik:TreeListBoundColumn DataField="ID" HeaderText="ID" UniqueName="ID" Visible="False">
		</telerik:TreeListBoundColumn>

            	
		<telerik:TreeListBoundColumn DataField="EmpireMarketSubsegment" HeaderText="Empire Market Subsegment" UniqueName="EmpireMarketSubsegment">			
                	<HeaderStyle Width="155px" />
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="EmpireApplication" HeaderText="Empire Application" UniqueName="EmpireApplication">			
                	<HeaderStyle Width="275px" />
		</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="BasePart" HeaderText="Base Part" UniqueName="BasePart">	
			<HeaderStyle Width="90px" />		
		</telerik:TreeListBoundColumn>
		
		<telerik:TreeListBoundColumn DataField="Sales_2016" HeaderText="Sales 2016" UniqueName="Sales_2016" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2017" HeaderText="Sales 2017" UniqueName="Sales_2017" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2018" HeaderText="Sales 2018" UniqueName="Sales_2018" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2019" HeaderText="Sales 2019" UniqueName="Sales_2019" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2020" HeaderText="Sales 2020" UniqueName="Sales_2020" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2021" HeaderText="Sales 2021" UniqueName="Sales_2021" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 
		<telerik:TreeListBoundColumn DataField="Sales_2022" HeaderText="Sales 2022" UniqueName="Sales_2022" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "" Aggregate="Sum" FooterAggregateFormatString="{0:C0}">
		</telerik:TreeListBoundColumn> 

		<telerik:TreeListBoundColumn DataField="Change_2017" DataType="System.Decimal" HeaderText="2017 v 2016 Variance" 
			ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2018" DataType="System.Decimal" HeaderText="2018 v 2017 Variance" 
			ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2019" DataType="System.Decimal" HeaderText="2019 v 2018 Variance" 
			ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2020" DataType="System.Decimal" HeaderText="2020 v 2019 Variance" 
			ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2021" DataType="System.Decimal" HeaderText="2021 v 2020 Variance" 
			ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>
		<telerik:TreeListBoundColumn DataField="Change_2022" DataType="System.Decimal" HeaderText="2022 v 2021 Variance" 
			ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"
                	DataFormatString="{0:C0}">
            	</telerik:TreeListBoundColumn>

		<telerik:TreeListBoundColumn DataField="ParentID" HeaderText="ParentID" UniqueName="ParentID" Visible="False">			
		</telerik:TreeListBoundColumn>
           
				
		</Columns>
		
			<ClientSettings Selecting-AllowItemSelection="true">      
            </ClientSettings>

        </telerik:RadTreeList>
		
		
		
		
		
		
		<telerik:RadGrid ID="SalesForecastOneRowRadGrid" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="False"
				AllowSorting="False" ShowFooter="False" OnItemDataBound="SalesForecastOneRowRadGrid_ItemDataBound"
				Skin="Default" Width="100%" Height="30px" EnableViewState="True">
                
			<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">

			<Columns>

            	<telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                		HeaderText="" ReadOnly="True" UniqueName="Filter">
				<HeaderStyle Width="510px" />
            	</telerik:GridBoundColumn> 
		<telerik:GridBoundColumn DataField="Sales_2016" HeaderText="Sales 2016" UniqueName="Sales_2016" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2017" HeaderText="Sales 2017" UniqueName="Sales_2017" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2018" HeaderText="Sales 2018" UniqueName="Sales_2018" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2019" HeaderText="Sales 2019" UniqueName="Sales_2019" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2020" HeaderText="Sales 2020" UniqueName="Sales_2020" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2021" HeaderText="Sales 2021" UniqueName="Sales_2021" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
		<telerik:GridBoundColumn DataField="Sales_2022" HeaderText="Sales 2022" UniqueName="Sales_2022" DataFormatString="{0:C0}"
                	DataType="System.Decimal" EmptyDataText= "">
		</telerik:GridBoundColumn>
            
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" UniqueName="Change_2017"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" UniqueName="Change_2018"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" UniqueName="Change_2019"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" UniqueName="Change_2020"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" UniqueName="Change_2021"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" UniqueName="Change_2022"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
			</Columns>

        	</MasterTableView>

        </telerik:RadGrid>
		
		
		
		
		
		
		
		
		<div class="divReturnLink">
			Return to Top
		</div>
	
	</div>
	
	
	
	


     <div id="divQuoteLogGrid" runat="server">
	 
	 <div style="font-size: 12px; color: #81CFDC; margin-bottom: 3px">
		<asp:label ID="lblQuoteLog" runat="server" Skin="Default" Text="Quote Log" />
	 </div>
	 
                        		

		<telerik:RadGrid ID="QuoteLogRadGrid" runat="server" CellSpacing="1" 
        	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" AllowSorting="True" OnSortCommand="QuoteLogRadGrid_SortCommand"
			Skin="Default">
                
			<MasterTableView HeaderStyle-HorizontalAlign="Left"
        		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
        		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False">
		
			<Columns>

                <telerik:GridBoundColumn DataField="QuoteNumber" FilterControlAltText="Filter QuoteNumber column"
                    HeaderText="QuoteNumber" ReadOnly="True" SortExpression="QuoteNumber" UniqueName="QuoteNumber">
					<HeaderStyle Width="100px" />
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Customer" FilterControlAltText="Filter Customer column"
                    HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Program" FilterControlAltText="Filter Program column"
                    HeaderText="Program" ReadOnly="True" SortExpression="Program" UniqueName="Program">
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EEIPartNumber" FilterControlAltText="Filter EEIPartNumber column"
                    HeaderText="EEI Part Number" ReadOnly="True" SortExpression="EEIPartNumber" UniqueName="EEIPartNumber">
					<HeaderStyle Width="140px" />
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Nameplate" FilterControlAltText="Filter Nameplate column"
                    HeaderText="Nameplate" ReadOnly="True" SortExpression="Nameplate" UniqueName="Nameplate">
					<HeaderStyle Width="120px" />
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="SOP" FilterControlAltText="Filter SOP column"
                    HeaderText="SOP" ReadOnly="True" SortExpression="SOP" UniqueName="SOP">
					<HeaderStyle Width="100px" />
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EOP" FilterControlAltText="Filter EOP column"
                    HeaderText="EOP" ReadOnly="True" SortExpression="EOP" UniqueName="EOP">
                	<HeaderStyle Width="100px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="QuoteStatus" FilterControlAltText="Filter QuoteStatus column"
                    HeaderText="Quote Status" ReadOnly="True" SortExpression="QuoteStatus" UniqueName="QuoteStatus">
					<HeaderStyle Width="100px" />
                </telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Awarded" FilterControlAltText="Filter Awarded column"
                    HeaderText="Awarded" ReadOnly="True" SortExpression="Awarded" UniqueName="Awarded">
                </telerik:GridBoundColumn>

				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>

				<telerik:GridBoundColumn DataField="Variance_2017" DataType="System.Decimal" FilterControlAltText="Filter Variance_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Variance_2017" UniqueName="Variance_2017"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Variance_2018" DataType="System.Decimal" FilterControlAltText="Filter Variance_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Variance_2018" UniqueName="Variance_2018"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Variance_2019" DataType="System.Decimal" FilterControlAltText="Filter Variance_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Variance_2019" UniqueName="Variance_2019"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Variance_2020" DataType="System.Decimal" FilterControlAltText="Filter Variance_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Variance_2020" UniqueName="Variance_2020"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Variance_2021" DataType="System.Decimal" FilterControlAltText="Filter Variance_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Variance_2021" UniqueName="Variance_2021"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Variance_2022" DataType="System.Decimal" FilterControlAltText="Filter Variance_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Variance_2022" UniqueName="Variance_2022"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>


			</Columns>


            </MasterTableView>
			

    	</telerik:RadGrid>
		
		
		<div class="divReturnLink">
	 		Return to Top
	 	</div>
		

	</div>





</div>
</telerik:RadAjaxPanel>


</form>
</body>

</html>