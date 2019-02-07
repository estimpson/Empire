<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExecutiveSalesSummaryLifeCycle.aspx.cs" Inherits="ExecutiveSalesSummaryLifeCycle" %> 

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

function OnClientSelectedIndexChangedFilter(sender, args)
{
	__doPostBack('FilterComboBox','');
}
function OnClientSelectedIndexChangedParent(sender, args)
{
	__doPostBack('ParentCustComboBox','');
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
	<div style="font-size: 18px; color: #B8B8B8; margin-bottom: 13px;">
		<asp:label ID="lblTitle" runat="server" Text="Executive Sales Summary" />
	</div>
	<div id="divSelectFilter" runat="server" style="float: left">
		<div style="float: left">   
    		<telerik:RadComboBox ID="FilterComboBox" runat="server" DataSourceID="FilterComboBoxDataSource" OnSelectedIndexChanged="FilterComboBox_SelectedIndexChanged"
            		DataTextField="Filter" DataValueField="Filter" CausesValidation="false" AutoPostBack="false" OnClientSelectedIndexChanged="OnClientSelectedIndexChangedFilter" Width="200"
					Skin="Silk">
			</telerik:RadComboBox>

			<asp:SqlDataSource ID="FilterComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
				SelectCommand="select Filter from eeiuser.WP_SalesForecastSummaries_Filter where Type = 1 order by Sequence">
        	</asp:SqlDataSource>
		</div>
	</div>
	
	<div id="divParentCustLabel" runat="server" style="float: left; margin-left: 42px; margin-top: 5px; font-size: 12px;">
		<asp:label ID="lblParentCustomer" runat="server" Text="Parent Cust:" />
	</div>
	<div id="divSelectParentCust" runat="server" style="float: left; margin-left: 5px">
		<telerik:RadComboBox ID="ParentCustComboBox" runat="server" AutoPostBack="false" OnSelectedIndexChanged="ParentCustComboBox_SelectedIndexChanged"
			DataTextField="ParentCustomer" DataValueField="ParentCustomer" Width="240" Skin="Silk" OnClientSelectedIndexChanged="OnClientSelectedIndexChangedParent">
		</telerik:RadComboBox>

		<asp:SqlDataSource ID="ParentCustComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
			SelectCommand="eeiuser.usp_WP_SalesForecastSummaries_LifeCycle_GetParentCustomers" SelectCommandType="StoredProcedure">
			<SelectParameters>
            		<asp:ControlParameter ControlID="ParentCustComboBox" DefaultValue="Pre-production" Name="LifeCycleStage" PropertyName="SelectedValue" Type="String" />
			</SelectParameters>
        	</asp:SqlDataSource>
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
		
<telerik:RadGrid ID="SalesForecastSummariesRadGrid" runat="server" CellSpacing="1" 
                GridLines="None" AutoGenerateColumns="False" ShowHeader="True" 
				AllowSorting="True" OnSortCommand="SalesForecastSummariesRadGrid_SortCommand" ShowFooter="True" 
				Skin="Silk" Width="100%" EnableViewState="True">
				<MasterTableView HeaderStyle-HorizontalAlign="Left"
                ItemStyle-HorizontalAlign="Left" AlternatingItemStyle-HorizontalAlign="Left"
                FooterStyle-HorizontalAlign="Left" TableLayout="Fixed" HeaderStyle-Width="75"
				AutoGenerateColumns="False" EnableViewState="True">
				<Columns>
			<telerik:GridBoundColumn DataField="Customer" FilterControlAltText=""
                		HeaderText="Customer" ReadOnly="True" SortExpression="Customer" UniqueName="Customer">
					<HeaderStyle Width="90px" />
            	</telerik:GridBoundColumn> 
            	<telerik:GridBoundColumn DataField="BasePart" FilterControlAltText=""
                		HeaderText="Base Part" ReadOnly="True" SortExpression="BasePart" UniqueName="BasePart">
					<HeaderStyle Width="110px" />
            	</telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="DisplaySOP" FilterControlAltText=""
                		HeaderText="SOP Display" ReadOnly="True" SortExpression="DisplaySOP" UniqueName="DisplaySOP">
					<HeaderStyle Width="100px" />
            	</telerik:GridBoundColumn> 
			<telerik:GridBoundColumn DataField="DisplayEOP" FilterControlAltText=""
                		HeaderText="EOP Display" ReadOnly="True" SortExpression="DisplayEOP" UniqueName="DisplayEOP">
					<HeaderStyle Width="100px" />
            	</telerik:GridBoundColumn> 
				<telerik:GridBoundColumn DataField="MaterialPercentage" FilterControlAltText=""
                		HeaderText="Material %" ReadOnly="True" SortExpression="MaterialPercentage" UniqueName="MaterialPercentage">
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
    	<asp:SqlDataSource ID="SalesForecastSummariesRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
        	SelectCommand="eeiuser.usp_WP_SalesForecastSummaries_LifeCycle_MaterialPercentage" SelectCommandType="StoredProcedure">
        	<SelectParameters>
            	<asp:ControlParameter ControlID="FilterComboBox" DefaultValue="Pre-production" Name="Filter" PropertyName="SelectedValue" Type="String" />
			<asp:ControlParameter ControlID="ParentCustComboBox" DefaultValue=" " Name="ParentCustomerFilter" PropertyName="SelectedValue" Type="String" />
        	</SelectParameters>
    	</asp:SqlDataSource>
	</div>
	
		<div class="divReturnLink">
	 		Return to Top
	 	</div>

</div>
</telerik:RadAjaxPanel>
</form>
</body>
</html>