<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastSummarybyCustParentCust.aspx.cs" Inherits="SalesForecastByCustParentCust" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>


<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI.Gantt" tagprefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Forecast</title>
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
	.rgCaption 
   	{    
      	    font: normal 16px arial; 
   	} 
    </style>
</head>
<body>
    <form id="form1" runat="server">
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
       
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">
	
	
	
	
	
	<div style="margin-top: 20px">
	
	<telerik:RadTabStrip RenderMode="Lightweight" runat="server" ID="RadTabStrip1"  MultiPageID="RadMultiPage1" SelectedIndex="0" Skin="Silk">
            <Tabs>
                <telerik:RadTab Text="Customer" Width="200px"></telerik:RadTab>
                <telerik:RadTab Text="Parent Customer" Width="200px"></telerik:RadTab>
            </Tabs>
	</telerik:RadTabStrip>
	
	 <telerik:RadMultiPage runat="server" ID="RadMultiPage1"  SelectedIndex="0" CssClass="outerMultiPage">
            <telerik:RadPageView runat="server" ID="RadPageView1">
	
	
		<div>
            

        	<telerik:RadGrid ID="CustomerRadGrid" runat="server" DataSourceID="CustomerRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView class=".rgCaption" Caption="Customer Sales" AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="CustomerRadGridDataSource" ShowGroupFooter="true">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="False" ShowRefreshButton="False" />
                    <Columns>
                       
                        <telerik:GridBoundColumn DataField="customer" FilterControlAltText="Filter customer column" HeaderText="Customer" SortExpression="customer" UniqueName="customer" HeaderStyle-Width="50px">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Sales 2016" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Sales 2017" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column" HeaderText="Sales 2018" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column" HeaderText="Sales 2019" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column" HeaderText="Sales 2020" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                    </Columns>
                    
                    <FooterStyle Font-Bold="true" HorizontalAlign="Right" />
                </MasterTableView>
              </telerik:RadGrid>
            <br />      
            
            <asp:SqlDataSource  ID="CustomerRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="EEIUSER.usp_sales_forecast_summary_by_customer" 
    				SelectCommandType="StoredProcedure" >
           
            </asp:SqlDataSource>


        </div>

		<div>
	
	
	<telerik:RadGrid ID="CustomerTotalRadGrid" runat="server" DataSourceID="CustomerTotalRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView class=".rgCaption" Caption="Total Sales" AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="CustomerTotalRadGridDataSource" ShowGroupFooter="false">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="False" ShowRefreshButton="False" />
                    <Columns>
                       

                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Total Sales 2016" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="140px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Total Sales 2017" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column" HeaderText="Total Sales 2018" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column" HeaderText="Total Sales 2019" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column" HeaderText="Total Sales 2020" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                    </Columns>
                    
                    <FooterStyle Font-Bold="true" HorizontalAlign="Right" />
                </MasterTableView>
              </telerik:RadGrid>
            <br />    

	    <asp:SqlDataSource  ID="CustomerTotalRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
				SelectCommand="select 
							'',	
							sum(Cal_16_Sales) as Sales_2016,
							sum(Cal_17_Sales) as Sales_2017,
							(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017,
							sum(Cal_18_Sales) as Sales_2018,
							(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018,
							sum(Cal_19_Sales) as Sales_2019,
							(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019,
							sum(Cal_20_Sales) as Sales_2020,
							(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
						from 	eeiuser.acctg_csm_vw_select_sales_forecast " >
	    </asp:SqlDataSource>

	</div>
	
	
	
	
	
			</telerik:RadPageView>
                
            <telerik:RadPageView runat="server" ID="RadPageView2">
	
	
	
		<div>
            

        	<telerik:RadGrid ID="ParentCustomerRadGrid" runat="server" DataSourceID="ParentCustomerRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView class=".rgCaption" Caption="Parent Customer Sales" AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="ParentCustomerRadGridDataSource" ShowGroupFooter="true">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="False" ShowRefreshButton="False" />
                    <Columns>
                       
                        <telerik:GridBoundColumn DataField="parent_customer" FilterControlAltText="Filter customer column" HeaderText="Parent Customer" SortExpression="parent_customer" UniqueName="parent_customer" HeaderStyle-Width="90px">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Sales 2016" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Sales 2017" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column" HeaderText="Sales 2018" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column" HeaderText="Sales 2019" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column" HeaderText="Sales 2020" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                    </Columns>
                    
                    <FooterStyle Font-Bold="true" HorizontalAlign="Right" />
                </MasterTableView>
              </telerik:RadGrid>
            <br />      
            
            <asp:SqlDataSource  ID="ParentCustomerRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="EEIUSER.usp_sales_forecast_summary_by_parentcustomer" 
    				SelectCommandType="StoredProcedure" >
           
            </asp:SqlDataSource>


        </div>
		
		
		
		<div>

		<telerik:RadGrid ID="ParentCustomerTotalRadGrid" runat="server" DataSourceID="ParentCustomerTotalRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView class=".rgCaption" Caption="Total Sales" AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="ParentCustomerTotalRadGridDataSource" ShowGroupFooter="false">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="False" ShowRefreshButton="False" />
                    <Columns>
                       

                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Total Sales 2016" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="140px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Total Sales 2017" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2017 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2017" UniqueName="Change_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column" HeaderText="Total Sales 2018" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2018 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2018" UniqueName="Change_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column" HeaderText="Total Sales 2019" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2019 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2019" UniqueName="Change_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column" HeaderText="Total Sales 2020" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Change_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Change_2020 column" HeaderText="Gain/Loss" ReadOnly="True" SortExpression="Change_2020" UniqueName="Change_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>

                    </Columns>
                    
                    <FooterStyle Font-Bold="true" HorizontalAlign="Right" />
                </MasterTableView>
              </telerik:RadGrid>
            <br />    

	    <asp:SqlDataSource  ID="ParentCustomerTotalRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
				SelectCommand="select 
							'',	
							sum(Cal_16_Sales) as Sales_2016,
							sum(Cal_17_Sales) as Sales_2017,
							(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017,
							sum(Cal_18_Sales) as Sales_2018,
							(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018,
							sum(Cal_19_Sales) as Sales_2019,
							(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019,
							sum(Cal_20_Sales) as Sales_2020,
							(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
						from 	eeiuser.acctg_csm_vw_select_sales_forecast " >
	    </asp:SqlDataSource>

	</div>
	
	
			</telerik:RadPageView>
	
	</telerik:RadMultiPage>
	
	
</div>
	


    </asp:Panel>
    </form>
</body>
</html>
