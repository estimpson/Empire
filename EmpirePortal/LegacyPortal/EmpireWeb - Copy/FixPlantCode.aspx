<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixPlantCode.aspx.cs" Inherits="SalesForecast" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxGridView" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>
<%@ Register tagprefix="dx" namespace="DevExpress.Web.ASPxEditors" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"  %>

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
            <telerik:AjaxSetting AjaxControlID="SalesOrder">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="OrderDetailRadGrid" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">
        <div>
            <!-- BASE PART DROP DOWN -->

            <strong>Choose Sales Order:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox ID="SalesOrder" runat="server" DataSourceID="SalesOrderDataSource"
                DataTextField="base_part" DataValueField="base_part" MarkFirstMatch="true" AutoPostBack="true">
            </telerik:RadComboBox>
            <asp:SqlDataSource ID="SalesOrderDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="SELECT DISTINCT [order_no] FROM [order_detail] order by 1">
            </asp:SqlDataSource>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
 
            <!-- BASE PART TO MNEMONIC ASSOCIATION GRID -->
            
            <strong>Part Detail:</strong>
            <telerik:RadGrid    ID="OrderDetailRadGrid" 
                                runat="server" 
                                DataSourceID="OrderDetailDataSource"
                                AutoGenerateColumns="False"
                                AllowAutomaticUpdates="True" 
                                CellSpacing="0" 
                                GridLines="None" 
                                >
                <MasterTableView    DataSourceID="OrderDetailDataSource" 
                                    EditMode="InPlace">

                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                        <HeaderStyle            Width="20px" />
                    </RowIndicatorColumn>
                    
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                        <HeaderStyle            Width="20px" />
                    </ExpandCollapseColumn>
                    
                    <EditFormSettings>
                        <EditColumn         FilterControlAltText="Filter EditCommandColumn column"/>
                    </EditFormSettings>
                    
                 </MasterTableView>
                </telerik:RadGrid>   
            <asp:SqlDataSource  ID="OrderDetailRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="SELECT [order_no], [part_number], [quantity], [price], [notes], [our_cum], [the_cum], [due_date], [row_id], [plant], [customer_part], [eeiqty] FROM [order_detail] WHERE ([order_no] = @order_no)">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="OrderDetailRadGrid" 
                                            Name="order_no" 
                                            PropertyName="SelectedValue" 
                                            Type="Decimal" />
                </SelectParameters>
                
            </asp:SqlDataSource>
            
        </div>
    </asp:Panel>
    </form>
</body>
</html>
