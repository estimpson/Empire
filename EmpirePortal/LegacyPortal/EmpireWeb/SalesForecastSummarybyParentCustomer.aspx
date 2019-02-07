<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastSummarybyParentCustomer.aspx.cs" Inherits="SalesForecast" %>

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
        .style4 {
            text-align: right;
            al
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
            <telerik:AjaxSetting AjaxControlID="ReleaseIDComboBox">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadPivotGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">
        <div>
            
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
                        <telerik:RadPivotGrid ID="RadPivotGrid1" runat="server" DataSourceID="VehicleRadGridDataSource" AggregatesLevel="0"  EnableCaching="True" EnableConfigurationPanel="True" EnableZoneContextMenu="False" RenderMode="Lightweight" RowGroupsDefaultExpanded="False"  ConfigurationPanelSettings-EnableDragDrop="False" ConfigurationPanelSettings-EnableOlapTreeViewLoadOnDemand="False" ColumnGroupsDefaultExpanded="False">
                            <ConfigurationPanelSettings EnableFieldsContextMenu="true" Position="FieldsWindow" />

                            <PagerStyle ChangePageSizeButtonToolTip="Change Page Size" PageSizeControlType="RadComboBox" />
                            <OlapSettings>
                                <XmlaConnectionSettings>
                                </XmlaConnectionSettings>
                            </OlapSettings>
                            <SortExpressions>
                                <Telerik:PivotGridSortExpression FieldName="Cal_17_Sales" SortOrder="Descending" />
                            </SortExpressions>
                            <Fields>
                                <telerik:PivotGridRowField DataField="parent_customer" UniqueName="Parent_Customer">
                                </telerik:PivotGridRowField>

                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_15_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="None" TotalFormatString="{0:C0}" UniqueName="Cal_15_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                </telerik:PivotGridAggregateField>
                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_16_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="None" TotalFormatString="{0:C0}" UniqueName="Cal_16_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                </telerik:PivotGridAggregateField>
                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_17_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="Descending" TotalFormatString="{0:C0}" UniqueName="Cal_17_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                </telerik:PivotGridAggregateField>
                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_18_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="None" TotalFormatString="{0:C0}" UniqueName="Cal_18_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                </telerik:PivotGridAggregateField>
                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_19_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="None" TotalFormatString="{0:C0}" UniqueName="Cal_19_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                </telerik:PivotGridAggregateField>
                                <telerik:PivotGridAggregateField CalculationExpression="Sum" DataField="Cal_20_Sales" DataFormatString="{0:C0}" GrandTotalAggregateFormatString="" IgnoreNullValues="True" SortOrder="None" TotalFormatString="{0:C0}" UniqueName="Cal_20_Sales">
                                    <TotalFormat Axis="Rows" Level="0" TotalFunction="NoCalculation" />
                                    <CellStyle CssClass="style4" />
                                </telerik:PivotGridAggregateField>
                            </Fields>
            </telerik:RadPivotGrid>
            <br />      
            
            <asp:SqlDataSource  ID="VehicleRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="select * from eeiuser.acctg_csm_vw_select_sales_forecast order by Cal_17_Sales desc" >
            </asp:SqlDataSource>
            
        </div>
    </asp:Panel>
    </form>
</body>
</html>
