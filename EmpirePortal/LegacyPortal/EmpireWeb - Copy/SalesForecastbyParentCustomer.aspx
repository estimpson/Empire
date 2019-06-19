﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastbyParentCustomer.aspx.cs" Inherits="SalesForecast" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxGridView" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>
<%@ Register tagprefix="dx" namespace="DevExpress.Web.ASPxEditors" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"  %>

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
            <!-- BASE PART DROP DOWN -->

            <strong>Choose Parent Customer:&nbsp;&nbsp;</strong>
            
            <telerik:RadComboBox ID="ParentCustomerComboBox" runat="server" DataSourceID="ParentCustomerComboBoxDataSource"
                DataTextField="ParentCustomer" DataValueField="ParentCustomer" MarkFirstMatch="True" Width="250px" AutoPostBack="True" Filter="Contains">
            </telerik:RadComboBox>
            
            <asp:SqlDataSource ID="ParentCustomerComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="select distinct(parent_customer) as ParentCustomer from eeiuser.acctg_csm_vw_select_sales_forecast where Parent_Customer is not null order by Parent_customer">
            </asp:SqlDataSource>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
            <!-- RELEASE ID DROP DOWN -->
            
            <strong>Choose Release ID:&nbsp;&nbsp;</strong>

            <telerik:RadComboBox ID="ReleaseIDComboBox" runat="server" DataSourceID="ReleaseIDComboBoxDataSource"
                DataTextField="release_id" DataValueField="release_id" MarkFirstMatch="true"
                AutoPostBack="true" MaxHeight="400px" >
            </telerik:RadComboBox>
            
            <asp:SqlDataSource ID="ReleaseIDComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="SELECT distinct([release_id]) FROM [eeiuser].[acctg_csm_naihs] order by 1 desc">
            </asp:SqlDataSource>
         
                 
            <br />    
                        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="ParentCustomerRadGridDataSource" ShowGroupPanel="False" ShowFooter="true">
                <ExportSettings>
                    <Csv EncloseDataWithQuotes="False" />
                </ExportSettings>
                <ClientSettings AllowDragToGroup="False" AllowColumnsReorder="true" Resizing-AllowColumnResize="true"  >
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" CommandItemDisplay="Top"  DataSourceID="ParentCustomerRadGridDataSource" ShowGroupFooter="true">
                    <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="True" ShowRefreshButton="False" />
                    <Columns>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column" HeaderText="base_part" SortExpression="base_part" UniqueName="base_part" HeaderStyle-Width="75px" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer" FilterControlAltText="Filter customer column" HeaderText="customer" SortExpression="customer" UniqueName="customer" HeaderStyle-Width="50px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="product_line" FilterControlAltText="Filter product_line column" HeaderText="product_line" SortExpression="product_line" UniqueName="product_line" HeaderStyle-Width="125px" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_segment" FilterControlAltText="Filter empire_market_segment column" HeaderText="Segment" SortExpression="empire_market_segment" UniqueName="empire_market_segment" HeaderStyle-Width="75px" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_subsegment" FilterControlAltText="Filter empire_market_subsegment column" HeaderText="empire_market_subsegment" SortExpression="empire_market_subsegment" UniqueName="empire_market_subsegment" Visible="false" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_application" FilterControlAltText="Filter empire_application column" HeaderText="empire_application" SortExpression="empire_application" UniqueName="empire_application" HeaderStyle-Width="300px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SOP" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter SOP column" HeaderText="SOP" ReadOnly="True" SortExpression="SOP" UniqueName="SOP" HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EOP" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter EOP column" HeaderText="EOP" ReadOnly="True" SortExpression="EOP" UniqueName="EOP" HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2015 column" HeaderText="Demand_2015" ReadOnly="True" SortExpression="Demand_2015" UniqueName="Demand_2015" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2016 column" HeaderText="Demand_2016" ReadOnly="True" SortExpression="Demand_2016" UniqueName="Demand_2016" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2017 column" HeaderText="Demand_2017" ReadOnly="True" SortExpression="Demand_2017" UniqueName="Demand_2017" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2018 column" HeaderText="Demand_2018" ReadOnly="True" SortExpression="Demand_2018" UniqueName="Demand_2018" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2019 column" HeaderText="Demand_2019" ReadOnly="True" SortExpression="Demand_2019" UniqueName="Demand_2019" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2020 column" HeaderText="Demand_2020" ReadOnly="True" SortExpression="Demand_2020" UniqueName="Demand_2020" Aggregate="Sum" FooterAggregateFormatString="{0:N0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Demand_2021" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter Demand_2021 column" HeaderText="Demand_2021" ReadOnly="True" SortExpression="Demand_2021" UniqueName="Demand_2021" Aggregate="Sum" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2015" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2015 column" HeaderText="Sales_2015" ReadOnly="True" SortExpression="Sales_2015" UniqueName="Sales_2015" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2016" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2016 column" HeaderText="Sales_2016" ReadOnly="True" SortExpression="Sales_2016" UniqueName="Sales_2016" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2017" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2017 column" HeaderText="Sales_2017" ReadOnly="True" SortExpression="Sales_2017" UniqueName="Sales_2017" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2018" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2018 column" HeaderText="Sales_2018" ReadOnly="True" SortExpression="Sales_2018" UniqueName="Sales_2018" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2019" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2019 column" HeaderText="Sales_2019" ReadOnly="True" SortExpression="Sales_2019" UniqueName="Sales_2019" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2020" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2020 column" HeaderText="Sales_2020" ReadOnly="True" SortExpression="Sales_2020" UniqueName="Sales_2020" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sales_2021" DataFormatString="{0:C0}" DataType="System.Decimal" FilterControlAltText="Filter Sales_2021 column" HeaderText="Sales_2021" ReadOnly="True" SortExpression="Sales_2021" UniqueName="Sales_2021" Aggregate="Sum" FooterAggregateFormatString="{0:C0}"  HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <GroupByExpressions>
                        <Telerik:GridGroupByExpression>
                                <selectFields>
                                    <Telerik:GridGroupByField FieldAlias="Application" FieldName="empire_market_subsegment" />

                                </selectFields>
                            
                                <GroupByFields>
                                        <Telerik:GridGroupByField FieldName="empire_market_subsegment" SortOrder="Ascending" />
                                </GroupByFields>
                                  
                        </Telerik:GridGroupByExpression>
                    </GroupByExpressions>
                    <FooterStyle Font-Bold="true" HorizontalAlign="Right" />
                </MasterTableView>
              </telerik:RadGrid>
            <br />      
            
            <asp:SqlDataSource  ID="ParentCustomerRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="select base_part, 
                                customer, 
                                product_line, 
                                empire_market_segment, 
                                empire_market_subsegment, 
                                empire_application, 
                                min(SOP_DISPLAY) as SOP, 
                                max(EOP_DISPLAY) as EOP, 
                                sum(Total_2015_Totaldemand) as Demand_2015, 
                                sum(Total_2016_TotalDemand) as Demand_2016,
                                sum(Total_2017_TotalDemand) as Demand_2017, 
                                sum(Total_2018_TotalDemand) as Demand_2018, 
                                sum(Cal19_TotalDemand)  as Demand_2019, 
                                sum(Cal20_TotalDemand)  as Demand_2020, 
                                sum(Cal21_TotalDemand) as Demand_2021,
                                sum(Cal_15_Sales) as Sales_2015,
                                sum(Cal_16_Sales) as Sales_2016,
                                sum(Cal_17_Sales) as Sales_2017,
                                sum(Cal_18_Sales) as Sales_2018,
                                sum(Cal_19_Sales) as Sales_2019,
                                sum(Cal_20_Sales) as Sales_2020,
                                sum(Cal_21_Sales) as Sales_2021
                                from eeiuser.acctg_csm_vw_select_sales_forecast 
                                where Parent_customer = @ParentCustomer
                                 group by base_part, customer, product_line, empire_market_segment, empire_market_subsegment, empire_application
	                             having (sum(Total_2015_Totaldemand)+sum(Total_2016_TotalDemand)+sum(Total_2017_TotalDemand)+sum(Total_2018_TotalDemand)+sum(Cal19_TotalDemand)+sum(Cal20_TotalDemand)+sum(Cal21_TotalDemand))>0
                                 order by empire_market_segment, empire_market_subsegment, product_line, customer, base_part" >
           
                <SelectParameters>
                    <asp:ControlParameter   ControlID="ParentCustomerComboBox" 
                                            Name="ParentCustomer" 
                                            PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            
        </div>
    </asp:Panel>
    </form>
</body>
</html>