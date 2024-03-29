﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastSummarybyCustomer.aspx.cs" Inherits="SalesForecast" %>

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
            <telerik:AjaxSetting AjaxControlID="ParentCustomerComboBox">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">
        <div>
            

        	<telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="CustomerRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
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
                        
                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Sales 2016 Actual" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Sales 2017 Actual" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
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
	

		<telerik:RadGrid ID="RadGrid2" runat="server" DataSourceID="TotalRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView class=".rgCaption" Caption="Total Sales" AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="TotalRadGridDataSource" ShowGroupFooter="false">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="False" ShowRefreshButton="False" />
                    <Columns>
                       

                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Total Sales 2016 Actual" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="140px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Total Sales 2017 Actual" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
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

            
            <asp:SqlDataSource  ID="TotalRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="EEIUSER.usp_sales_forecast_summary_by_customer_totalsales" 
    				SelectCommandType="StoredProcedure" >
           
            </asp:SqlDataSource>



	</div>

    </asp:Panel>
    </form>
</body>
</html>
