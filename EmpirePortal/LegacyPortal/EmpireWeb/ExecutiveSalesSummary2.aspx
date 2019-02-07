<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExecutiveSalesSummary2.cs" Inherits="ExecutiveSalesSummary2" %> 

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Executive Sales Summary</title>

<telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
<style type="text/css">
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
		width: 100px;
	}
	.divReturnLink:hover{
    	color:#000000 !important;
	}
</style>
<script type="text/javascript">
function pageLoad()
{
$(function(){
$(".divReturnLink").click(function(){
      $('html, body').animate({ scrollTop: 0 }, 0);
})
});
}
function pnlRequestStarted(ajaxPanel, eventArgs)
{
  if(eventArgs.get_eventTarget() == "iBtnSalesForecastSummariesRadGrid")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastCustomerSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastParentCustomerSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastProgramSalespersonSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastVolumesRadGrid")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastVolumesSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastVolumesCustomerSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastVolumesParentCustomerSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnSalesForecastVolumesProgramSalespersonSelected")
  {eventArgs.set_enableAjax(false); }
  else if (eventArgs.get_eventTarget() == "iBtnQuoteLogRadGrid")
  {eventArgs.set_enableAjax(false); } 
  else {eventArgs.set_enableAjax(true);}
}
</script>
</head>



<body>
<form id="form1" runat="server">

<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="Silk" />
<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" ClientEvents-OnRequestStart="pnlRequestStarted" LoadingPanelID="RadAjaxLoadingPanel1">

<telerik:RadScriptManager ID="RadScriptManager1" runat="server">
	<Scripts>
		<%--Needed for JavaScript IntelliSense in VS2010--%>
        <%--For VS2008 replace RadScriptManager with ScriptManager--%>
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
        <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
	</Scripts>
</telerik:RadScriptManager>

<div style="margin-bottom: 20px; padding: 10px">
	<div style="font-size: 18px; color: #81CFDC; margin-bottom: 13px;">
		<asp:label ID="lblTitle" runat="server" Text="Executive Sales Summary" />
	</div>
	<div id="divSelectFilter" runat="server" style="float: left">
		<div style="float: left">   
    		<telerik:RadComboBox ID="FilterComboBox" runat="server" DataSourceID="FilterComboBoxDataSource" OnSelectedIndexChanged="FilterComboBox_SelectedIndexChanged"
            		DataTextField="Filter" DataValueField="Filter" MarkFirstMatch="true" AutoPostBack="true" Width="220"
					Skin="Silk">
			</telerik:RadComboBox>

			<asp:SqlDataSource ID="FilterComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
				SelectCommand="select Filter from eeiuser.WP_SalesForecastSummaries_Filter where Type =2 order by Filter">
        	</asp:SqlDataSource>
		</div>
	</div>
	<div id="divButton" runat="server" style="float: left">
		<telerik:RadButton ID="RadButtonShowAll" runat="server" Text="Show All" Skin="Silk" Width="220" OnClick="RadButtonShowAll_Click" />
	</div>
	<div id="divToggleSalesVolume" runat="server" style="float: left; margin-left: 42px; margin-top: 5px; font-size: 12px;">
		<telerik:RadRadioButtonList runat="server" ID="RadioButtonList1" AutoPostBack="True" Skin="Silk" EnableViewState="True"  
			OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" Layout="Flow" Direction="Horizontal">
            <Items>
                <telerik:ButtonListItem Text="Sales" Value="0" />
                <telerik:ButtonListItem Text="Volume" Value="1" />
            </Items>
        </telerik:RadRadioButtonList>
	</div>
</div>




<div style="margin-bottom: 10px; padding: 10px">

	<telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true" DestroyOnClose="true" Modal="true" Behaviors="Close,Move" EnableViewState="false">
	</telerik:RadWindowManager>
	
	<div id="divSalesForecast" runat="server"> 
		<asp:ImageButton ID="iBtnSalesForecastSummariesRadGrid" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastSummariesRadGrid_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastSummariesRadGrid" runat="server" CellSpacing="1" DataSourceID="SalesForecastSummariesRadGridDataSource"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnItemCommand="SalesForecastSummariesRadGrid_ItemCommand" 
				AllowSorting="True" OnSortCommand="SalesForecastSummariesRadGrid_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">
				<MasterTableView HeaderStyle-HorizontalAlign="Left" DataSourceID="SalesForecastSummariesRadGridDataSource"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
            	<telerik:GridBoundColumn DataField="Filter" FilterControlAltText=""
                		HeaderText="" ReadOnly="True" SortExpression="Filter" UniqueName="Filter">
					<HeaderStyle Width="200px" />
            	</telerik:GridBoundColumn> 
				<telerik:GridBoundColumn DataField="MaterialPercentage" FilterControlAltText=""
                		HeaderText="Material %" ReadOnly="True" SortExpression="MaterialPercentage" UniqueName="MaterialPercentage">
            	</telerik:GridBoundColumn> 
			<telerik:GridBoundColumn DataField="SalesActual_2016" DataType="System.Decimal" FilterControlAltText="Filter SalesActual_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="SalesActual_2016" UniqueName="SalesActual_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="SalesActual_2017" DataType="System.Decimal" FilterControlAltText="Filter SalesActual_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="SalesActual_2017" UniqueName="SalesActual_2017" Aggregate="Sum"
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
		 	<telerik:GridBoundColumn DataField="Sales_2023" DataType="System.Decimal" FilterControlAltText="Filter Sales_2023 column"
                		HeaderText="2023 Sales" ReadOnly="True" SortExpression="Sales_2023" UniqueName="Sales_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2024" DataType="System.Decimal" FilterControlAltText="Filter Sales_2024 column"
                		HeaderText="2024 Sales" ReadOnly="True" SortExpression="Sales_2024" UniqueName="Sales_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2025" DataType="System.Decimal" FilterControlAltText="Filter Sales_2025 column"
                		HeaderText="2025 Sales" ReadOnly="True" SortExpression="Sales_2025" UniqueName="Sales_2025" Aggregate="Sum"
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
			<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
            	</telerik:GridBoundColumn>
				</Columns>
        	</MasterTableView>
            <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
            <Selecting AllowRowSelect="true"></Selecting>
			<Scrolling AllowScroll="True" UseStaticHeaders="true" />
            </ClientSettings>
        </telerik:RadGrid>
    	<asp:SqlDataSource ID="SalesForecastSummariesRadGridDataSource" OnSelecting="SalesForecastSummariesRadGridDataSource_Selecting" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
        	SelectCommand="eeiuser.usp_WP_SalesForecastSummaries_MaterialPercentage2" SelectCommandType="StoredProcedure">
        	<SelectParameters>
            	<asp:ControlParameter ControlID="FilterComboBox" DefaultValue="Customer" Name="Filter" PropertyName="SelectedValue" Type="String" />
        	</SelectParameters>
    	</asp:SqlDataSource>
	</div>
	<div id="divSalesForecastVolumes" runat="server">
		<asp:ImageButton ID="iBtnSalesForecastVolumesRadGrid" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastVolumesRadGrid_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastVolumesRadGrid" runat="server" CellSpacing="1" DataSourceID="SalesForecastVolumesRadGridDataSource"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnItemCommand="SalesForecastVolumesRadGrid_ItemCommand" 
				AllowSorting="True" OnSortCommand="SalesForecastVolumesRadGrid_SortCommand" ShowFooter="True"
				Skin="Silk" Width="100%" EnableViewState="True">
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
            		<telerik:GridBoundColumn DataField="TotalDemand_2023" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2023 column"
                		HeaderText="Total Demand 2023" ReadOnly="True" SortExpression="TotalDemand_2023" UniqueName="TotalDemand_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2024" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2024 column"
                		HeaderText="Total Demand 2024" ReadOnly="True" SortExpression="TotalDemand_2024" UniqueName="TotalDemand_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2025" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2025 column"
                		HeaderText="Total Demand 2025" ReadOnly="True" SortExpression="TotalDemand_2025" UniqueName="TotalDemand_2025" Aggregate="Sum"
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
				<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
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
	<div id="divSalesForecastSelected" style="margin-top: 0px; margin-bottom: 25px" runat="server">
		<div style="font-size: 20px; color: #000000; margin-top: 22px; margin-bottom: 7px">
			<asp:label ID="lblSalesTitle" runat="server" Skin="Silk" Text="" />
		</div>
		<div>
			<asp:ImageButton ID="iBtnSalesForecastSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastSelected_Click" AlternateText="Xlsx" Width="38" />
		</div>
		<telerik:RadGrid ID="SalesForecastSelected" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastSelected_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">    
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
            	<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
					<HeaderStyle Width="170px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            		<HeaderStyle Width="250px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2023" DataType="System.Decimal" FilterControlAltText="Filter Sales_2023 column"
                		HeaderText="2023 Sales" ReadOnly="True" SortExpression="Sales_2023" UniqueName="Sales_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2024" DataType="System.Decimal" FilterControlAltText="Filter Sales_2024 column"
                		HeaderText="2024 Sales" ReadOnly="True" SortExpression="Sales_2024" UniqueName="Sales_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2025" DataType="System.Decimal" FilterControlAltText="Filter Sales_2025 column"
                		HeaderText="2025 Sales" ReadOnly="True" SortExpression="Sales_2025" UniqueName="Sales_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>	
			<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
		    <telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">				
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastCustomerSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastCustomerSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastCustomerSelected" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastCustomerSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastCustomerSelected_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">  
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
				<telerik:GridBoundColumn DataField="Program" FilterControlAltText="" HeaderText="Program" ReadOnly="True" SortExpression="Program" UniqueName="Program">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
					<HeaderStyle Width="170px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            		<HeaderStyle Width="250px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2023" DataType="System.Decimal" FilterControlAltText="Filter Sales_2023 column"
                		HeaderText="2023 Sales" ReadOnly="True" SortExpression="Sales_2023" UniqueName="Sales_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2024" DataType="System.Decimal" FilterControlAltText="Filter Sales_2024 column"
                		HeaderText="2024 Sales" ReadOnly="True" SortExpression="Sales_2024" UniqueName="Sales_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2025" DataType="System.Decimal" FilterControlAltText="Filter Sales_2025 column"
                		HeaderText="2025 Sales" ReadOnly="True" SortExpression="Sales_2025" UniqueName="Sales_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastParentCustomerSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastParentCustomerSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastParentCustomerSelected" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastParentCustomerSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastParentCustomerSelected_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
				<telerik:GridBoundColumn DataField="Customer" FilterControlAltText="" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Program" FilterControlAltText="" HeaderText="Program" ReadOnly="True" SortExpression="Program" UniqueName="Program">
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
					<HeaderStyle Width="170px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            		<HeaderStyle Width="250px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2023" DataType="System.Decimal" FilterControlAltText="Filter Sales_2023 column"
                		HeaderText="2023 Sales" ReadOnly="True" SortExpression="Sales_2023" UniqueName="Sales_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2024" DataType="System.Decimal" FilterControlAltText="Filter Sales_2024 column"
                		HeaderText="2024 Sales" ReadOnly="True" SortExpression="Sales_2024" UniqueName="Sales_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2025" DataType="System.Decimal" FilterControlAltText="Filter Sales_2025 column"
                		HeaderText="2025 Sales" ReadOnly="True" SortExpression="Sales_2025" UniqueName="Sales_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">				
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				</Columns>
        	</MasterTableView>
            <ClientSettings>
			<Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastProgramSalespersonSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastProgramSalespersonSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastProgramSalespersonSelected" runat="server" CellSpacing="1"
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastProgramSalespersonSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastProgramSalespersonSelected_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
            	<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Customer" FilterControlAltText="" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
					<HeaderStyle Width="170px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            		<HeaderStyle Width="250px" />
				</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2016" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column"
                		HeaderText="2016 Sales" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2017" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column"
                		HeaderText="2017 Sales" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2018" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column"
                		HeaderText="2018 Sales" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2019" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column"
                		HeaderText="2019 Sales" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
            	<telerik:GridBoundColumn DataField="Sales_2020" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column"
                		HeaderText="2020 Sales" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2021" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column"
                		HeaderText="2021 Sales" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2022" DataType="System.Decimal" FilterControlAltText="Filter Sales_2022 column"
                		HeaderText="2022 Sales" ReadOnly="True" SortExpression="Sales_2022" UniqueName="Sales_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sales_2023" DataType="System.Decimal" FilterControlAltText="Filter Sales_2023 column"
                		HeaderText="2023 Sales" ReadOnly="True" SortExpression="Sales_2023" UniqueName="Sales_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2024" DataType="System.Decimal" FilterControlAltText="Filter Sales_2024 column"
                		HeaderText="2024 Sales" ReadOnly="True" SortExpression="Sales_2024" UniqueName="Sales_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Sales_2025" DataType="System.Decimal" FilterControlAltText="Filter Sales_2025 column"
                		HeaderText="2025 Sales" ReadOnly="True" SortExpression="Sales_2025" UniqueName="Sales_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:C0}">
						<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn>
				
				</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<div class="divReturnLink">
			Return to Top
		</div>
	</div>
	<div id="divSalesForecastVolumesSelected" style="margin-bottom: 30px" runat="server">
		<div style="font-size: 20px; color: #000000; margin-top: 22px; margin-bottom: 7px">
			<asp:label ID="lblVolumesTitle" runat="server" Skin="Silk" Text="" />
		</div>
		<div>
			<asp:ImageButton ID="iBtnSalesForecastVolumesSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastVolumesSelected_Click" AlternateText="Xlsx" Width="38" />
		</div>
		<telerik:RadGrid ID="SalesForecastVolumesSelected" runat="server" CellSpacing="1"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastVolumesSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastVolumesSelected_SortCommand" ShowFooter="True"
				Skin="Silk" Width="100%" EnableViewState="True">  
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
						AutoGenerateColumns="False" EnableViewState="True">
					<Columns>
            		<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            		</telerik:GridBoundColumn> 
					<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
						<HeaderStyle Width="170px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            			<HeaderStyle Width="250px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		HeaderText="Total Demand 2016" ReadOnly="True" SortExpression="TotalDemand_2016" UniqueName="TotalDemand_2016" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		HeaderText="Total Demand 2017" ReadOnly="True" SortExpression="TotalDemand_2017" UniqueName="TotalDemand_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		HeaderText="Total Demand 2018" ReadOnly="True" SortExpression="TotalDemand_2018" UniqueName="TotalDemand_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		HeaderText="Total Demand 2019" ReadOnly="True" SortExpression="TotalDemand_2019" UniqueName="TotalDemand_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		HeaderText="Total Demand 2020" ReadOnly="True" SortExpression="TotalDemand_2020" UniqueName="TotalDemand_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		HeaderText="Total Demand 2021" ReadOnly="True" SortExpression="TotalDemand_2021" UniqueName="TotalDemand_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		HeaderText="Total Demand 2022" ReadOnly="True" SortExpression="TotalDemand_2022" UniqueName="TotalDemand_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>	
				<telerik:GridBoundColumn DataField="TotalDemand_2023" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2023 column"
                		HeaderText="Total Demand 2023" ReadOnly="True" SortExpression="TotalDemand_2023" UniqueName="TotalDemand_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2024" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2024 column"
                		HeaderText="Total Demand 2024" ReadOnly="True" SortExpression="TotalDemand_2024" UniqueName="TotalDemand_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2025" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2025 column"
                		HeaderText="Total Demand 2025" ReadOnly="True" SortExpression="TotalDemand_2025" UniqueName="TotalDemand_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>	
					
					<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>	
					
					</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastVolumesCustomerSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastVolumesCustomerSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastVolumesCustomerSelected" runat="server" CellSpacing="1"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastVolumesCustomerSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastVolumesCustomerSelected_SortCommand" ShowFooter="True"
				Skin="Silk" Width="100%" EnableViewState="True"> 
			<MasterTableView HeaderStyle-HorizontalAlign="Left"
                		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
						AutoGenerateColumns="False" EnableViewState="True">
					<Columns>
					<telerik:GridBoundColumn DataField="Program" FilterControlAltText="" HeaderText="Program" ReadOnly="True" SortExpression="Program" UniqueName="Program">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            		</telerik:GridBoundColumn> 
					<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
						<HeaderStyle Width="170px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            			<HeaderStyle Width="250px" />
					</telerik:GridBoundColumn> 
					<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		HeaderText="Total Demand 2016" ReadOnly="True" SortExpression="TotalDemand_2016" UniqueName="TotalDemand_2016" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		HeaderText="Total Demand 2017" ReadOnly="True" SortExpression="TotalDemand_2017" UniqueName="TotalDemand_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		HeaderText="TotalDemand 2018" ReadOnly="True" SortExpression="TotalDemand_2018" UniqueName="TotalDemand_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		HeaderText="Total Demand 2019" ReadOnly="True" SortExpression="TotalDemand_2019" UniqueName="TotalDemand_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		HeaderText="Total Demand 2020" ReadOnly="True" SortExpression="TotalDemand_2020" UniqueName="TotalDemand_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		HeaderText="Total Demand 2021" ReadOnly="True" SortExpression="TotalDemand_2021" UniqueName="TotalDemand_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		HeaderText="Total Demand 2022" ReadOnly="True" SortExpression="TotalDemand_2022" UniqueName="TotalDemand_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2023" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2023 column"
                		HeaderText="Total Demand 2023" ReadOnly="True" SortExpression="TotalDemand_2023" UniqueName="TotalDemand_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2024" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2024 column"
                		HeaderText="Total Demand 2024" ReadOnly="True" SortExpression="TotalDemand_2024" UniqueName="TotalDemand_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2025" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2025 column"
                		HeaderText="Total Demand 2025" ReadOnly="True" SortExpression="TotalDemand_2025" UniqueName="TotalDemand_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					
					<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					
					</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastVolumesParentCustomerSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastVolumesParentCustomerSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastVolumesParentCustomerSelected" runat="server" CellSpacing="1"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastVolumesParentCustomerSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastVolumesParentCustomerSelected_SortCommand" ShowFooter="True"
				Skin="Silk" Width="100%" EnableViewState="True">
			<MasterTableView HeaderStyle-HorizontalAlign="Left"
                		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
						AutoGenerateColumns="False" EnableViewState="True">
						<Columns>
					<telerik:GridBoundColumn DataField="Customer" FilterControlAltText="" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Program" FilterControlAltText="" HeaderText="Program" ReadOnly="True" SortExpression="Program" UniqueName="Program">
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            		</telerik:GridBoundColumn> 
					<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
						<HeaderStyle Width="170px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            			<HeaderStyle Width="250px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		HeaderText="Total Demand 2016" ReadOnly="True" SortExpression="TotalDemand_2016" UniqueName="TotalDemand_2016" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		HeaderText="Total Demand 2017" ReadOnly="True" SortExpression="TotalDemand_2017" UniqueName="TotalDemand_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		HeaderText="TotalDemand 2018" ReadOnly="True" SortExpression="TotalDemand_2018" UniqueName="TotalDemand_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		HeaderText="Total Demand 2019" ReadOnly="True" SortExpression="TotalDemand_2019" UniqueName="TotalDemand_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		HeaderText="Total Demand 2020" ReadOnly="True" SortExpression="TotalDemand_2020" UniqueName="TotalDemand_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		HeaderText="Total Demand 2021" ReadOnly="True" SortExpression="TotalDemand_2021" UniqueName="TotalDemand_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		HeaderText="Total Demand 2022" ReadOnly="True" SortExpression="TotalDemand_2022" UniqueName="TotalDemand_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2023" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2023 column"
                		HeaderText="Total Demand 2023" ReadOnly="True" SortExpression="TotalDemand_2023" UniqueName="TotalDemand_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2024" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2024 column"
                		HeaderText="Total Demand 2024" ReadOnly="True" SortExpression="TotalDemand_2024" UniqueName="TotalDemand_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2025" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2025 column"
                		HeaderText="Total Demand 2025" ReadOnly="True" SortExpression="TotalDemand_2025" UniqueName="TotalDemand_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>	
					
					<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					
					</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<asp:ImageButton ID="iBtnSalesForecastVolumesProgramSalespersonSelected" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnSalesForecastVolumesProgramSalespersonSelected_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="SalesForecastVolumesProgramSalespersonSelected" runat="server" CellSpacing="1"
                	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" OnNeedDataSource="SalesForecastVolumesProgramSalespersonSelected_NeedDataSource"
				AllowSorting="True" OnSortCommand="SalesForecastVolumesProgramSalespersonSelected_SortCommand" ShowFooter="True"
				Skin="Silk" Width="100%" EnableViewState="True">   
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                		ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                		FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
						AutoGenerateColumns="False" EnableViewState="True">
					<Columns>
            		<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText="" HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
            		</telerik:GridBoundColumn> 
					<telerik:GridBoundColumn DataField="Customer" FilterControlAltText="" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="EmpireMarketSubsegment" FilterControlAltText="" HeaderText="Empire Market Subsegment" ReadOnly="True" SortExpression="EmpireMarketSubsegment" UniqueName="EmpireMarketSubsegment">
						<HeaderStyle Width="170px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="EmpireApplication" FilterControlAltText="" HeaderText="Empire Application" ReadOnly="True" SortExpression="EmpireApplication" UniqueName="EmpireApplication">
            			<HeaderStyle Width="250px" />
					</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2016" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2016 column"
                		HeaderText="Total Demand 2016" ReadOnly="True" SortExpression="TotalDemand_2016" UniqueName="TotalDemand_2016" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2017" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2017 column"
                		HeaderText="Total Demand 2017" ReadOnly="True" SortExpression="TotalDemand_2017" UniqueName="TotalDemand_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2018" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2018 column"
                		HeaderText="TotalDemand 2018" ReadOnly="True" SortExpression="TotalDemand_2018" UniqueName="TotalDemand_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2019" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2019 column"
                		HeaderText="Total Demand 2019" ReadOnly="True" SortExpression="TotalDemand_2019" UniqueName="TotalDemand_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
            		<telerik:GridBoundColumn DataField="TotalDemand_2020" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2020 column"
                		HeaderText="Total Demand 2020" ReadOnly="True" SortExpression="TotalDemand_2020" UniqueName="TotalDemand_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2021" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2021 column"
                		HeaderText="Total Demand 2021" ReadOnly="True" SortExpression="TotalDemand_2021" UniqueName="TotalDemand_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="TotalDemand_2022" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2022 column"
                		HeaderText="Total Demand 2022" ReadOnly="True" SortExpression="TotalDemand_2022" UniqueName="TotalDemand_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2023" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2023 column"
                		HeaderText="Total Demand 2023" ReadOnly="True" SortExpression="TotalDemand_2023" UniqueName="TotalDemand_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2024" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2024 column"
                		HeaderText="Total Demand 2024" ReadOnly="True" SortExpression="TotalDemand_2024" UniqueName="TotalDemand_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="TotalDemand_2025" DataType="System.Decimal" FilterControlAltText="Filter TotalDemand_2025 column"
                		HeaderText="Total Demand 2025" ReadOnly="True" SortExpression="TotalDemand_2025" UniqueName="TotalDemand_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					
					<telerik:GridBoundColumn DataField="Change_2017" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column"
                		HeaderText="2017 v 2016 Variance" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2018" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column"
                		HeaderText="2018 v 2017 Variance" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2019" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column"
                		HeaderText="2019 v 2018 Variance" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2020" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column"
                		HeaderText="2020 v 2019 Variance" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2021" DataType="System.Decimal" FilterControlAltText="Filter Change_2021 column"
                		HeaderText="2021 v 2020 Variance" ReadOnly="True" SortExpression="Change_2021" UniqueName="Change_2021" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					<telerik:GridBoundColumn DataField="Change_2022" DataType="System.Decimal" FilterControlAltText="Filter Change_2022 column"
                		HeaderText="2022 v 2021 Variance" ReadOnly="True" SortExpression="Change_2022" UniqueName="Change_2022" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2023" DataType="System.Decimal" FilterControlAltText="Filter Change_2023 column"
                		HeaderText="2023 v 2022 Variance" ReadOnly="True" SortExpression="Change_2023" UniqueName="Change_2023" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2024" DataType="System.Decimal" FilterControlAltText="Filter Change_2024 column"
                		HeaderText="2024 v 2023 Variance" ReadOnly="True" SortExpression="Change_2024" UniqueName="Change_2024" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
				<telerik:GridBoundColumn DataField="Change_2025" DataType="System.Decimal" FilterControlAltText="Filter Change_2025 column"
                		HeaderText="2025 v 2024 Variance" ReadOnly="True" SortExpression="Change_2025" UniqueName="Change_2025" Aggregate="Sum"
                		DataFormatString="{0:N0}">
						<HeaderStyle Width="90px" />
            		</telerik:GridBoundColumn>
					</Columns>
        	</MasterTableView>
            <ClientSettings>
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
        </telerik:RadGrid>
		<div class="divReturnLink">
			Return to Top
		</div>
	</div>
     <div id="divQuoteLogGrid" runat="server">
	 <asp:ImageButton ID="iBtnQuoteLogRadGrid" runat="server" ImageUrl="Excel_XLSX.png" OnClick="iBtnQuoteLogRadGrid_Click" AlternateText="Xlsx" Width="38" />
		<telerik:RadGrid ID="QuoteLogRadGrid" runat="server" CellSpacing="1" 
        	GridLines="None" AutoGenerateColumns="False" ShowHeader="True" AllowSorting="True" OnSortCommand="QuoteLogRadGrid_SortCommand"
			OnItemCommand="QuoteLogRadGrid_ItemCommand" Skin="Silk">   
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
				<telerik:GridBoundColumn DataField="ReceiptDate" FilterControlAltText="Filter ReceiptDate column"
                    HeaderText="Receipt Date" ReadOnly="True" SortExpression="ReceiptDate" UniqueName="ReceiptDate">
					<HeaderStyle Width="100px" />
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
			<ClientSettings EnablePostBackOnRowClick="true">
            <Selecting AllowRowSelect="true"></Selecting>  
            </ClientSettings>
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