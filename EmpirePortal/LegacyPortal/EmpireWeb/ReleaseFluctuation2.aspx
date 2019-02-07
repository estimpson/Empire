<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReleaseFluctuation2.aspx.cs" Inherits="ReleaseFluctuation" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Release Fluctuation</title>
</head>
<body>
    <form id="form1" runat="server">

        <Telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        </Telerik:RadStyleSheetManager>

<telerik:radscriptmanager runat="server"></telerik:radscriptmanager>
       
<telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
    <ajaxsettings>
        <telerik:AjaxSetting AjaxControlID="RadPushButton1">
            <updatedcontrols>
                <telerik:AjaxUpdatedControl ControlID="RadPivotGrid1" />
                <Telerik:AjaxUpdatedControl ControlID="RadGrid1" />
            </updatedcontrols>
        </telerik:AjaxSetting>
    </ajaxsettings>
</telerik:RadAjaxManager>

<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
</telerik:RadAjaxLoadingPanel>
 
<div>       

<telerik:RadDatePicker ID="RadDatePicker1" Runat="server" DateInput-Label="From Date"
                        Culture="en-US"  MaxDate="2025-12-31" MinDate="2015-01-01" RendorMode="Lightweight" Skin="Bootstrap" Width="275px">

    <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" EnableWeekends="True" RendorMode="Lightweight" FastNavigationNextText="&amp;lt;&amp;lt;" Skin="Bootstrap" EnableKeyboardNavigation="True">
    </Calendar>

    <DateInput runat="server" DisplayDateFormat="MM/dd/yyyy" DateFormat="MM/dd/yyyy" LabelWidth="45%" Skin="Bootstrap" RendorMode="Lightweight">
    </DateInput>

</telerik:RadDatePicker>


<telerik:RadDatePicker ID="RadDatePicker2" Runat="server" DateInput-Label="To Date" 
                        Culture="en-US"  MaxDate="2025-12-31" MinDate="2015-01-01" Skin="Bootstrap" Width="225px" RendorMode="Lightweight">

    <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" EnableWeekends="True" RendorMode="Lightweight" FastNavigationNextText="&amp;lt;&amp;lt;" Skin="Bootstrap" EnableKeyboardNavigation="True">
    </Calendar>

    <DateInput runat="server" DisplayDateFormat="MM/dd/yyyy" DateFormat="MM/dd/yyyy" LabelWidth="45%" Skin="Bootstrap" RendorMode="Lightweight">
    </DateInput>

</telerik:RadDatePicker>


<telerik:RadAutoCompleteBox ID="RadAutoCompleteBox1" Runat="server" AutoPostBack="True" InputType="Text" Delimiter=";" Filter="StartsWith" TextSettings-SelectionMode="Single"
    DataSourceID="BasePartDataSource" DataTextField="part" DataValueField="part" OnEntryAdded="RadAutoCompleteBox1_EntryAdded" Height="35px" Width="250px" DropDownWidth="250px" DropDownPosition="Automatic" Label="Part" Skin="Bootstrap" RenderMode="Lightweight">
</telerik:RadAutoCompleteBox>


<asp:SqlDataSource ID="BasePartDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                    SelectCommand="select distinct(part_number) as part from order_detail union select distinct(left(part_number,7)) as part from order_detail order by 1 asc">
</asp:SqlDataSource>

   <%-- <Telerik:RadComboBox ID="RadComboBox1" Runat="server" AllowCustomText="True" DataSourceID="BasePartDataSource" DataTextField="part" DataValueField="part" Filter="Contains" MarkFirstMatch="True">
    </Telerik:RadComboBox>--%>


<telerik:RadDropDownList ID="RadDropDownList1" runat="server" RenderMode="Lightweight" Skin="Material" AutoPostBack="true" Height="35px" >
    <Items>
        <telerik:DropDownListItem runat="server" Selected="False" Text="Monday" Value="1" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Tuesday" Value="2" />   
        <telerik:DropDownListItem runat="server" Selected="False" Text="Wednesday" Value="3" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Thursday" Value="4" />
        <telerik:DropDownListItem runat="server" Selected="True" Text="Friday" Value="5" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Saturday" Value="6" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Sunday" Value="7" />
    </Items>
</telerik:RadDropDownList>       


<telerik:RadPushButton ID="RadPushButton1" runat="server" Text="Refresh Data" AutoPostBack="True" OnClick="RadPushButton1_Click" Height="35px" Skin="Material" >
    <Icon CssClass="rbRefresh" ></Icon>
</telerik:RadPushButton>

    <div style="text-align:right">

        <telerik:RadPushButton ID="RadPushButton2" runat="server" Text="Export to Excel" OnClick="RadPushButton2_Click"
            Width="250px" 
            Height="60px"  Skin="Material" Icon-Height="50" Icon-Left="5" Icon-Top="5" Icon-Width="70" Icon-Url="Excel_XLSX.png" style="top: 0px; left: 0px">
        </telerik:RadPushButton>

    </div>

<telerik:RadPivotGrid ID="RadPivotGrid1" runat="server" RenderMode="Lightweight" Skin="Material"
    AllowSorting="True" EnableZoneContextMenu="True" EnableConfigurationPanel="true" 
    AggregatesPosition="Columns" AggregatesLevel="0" ClientSettings-EnableFieldsDragDrop="True" Height="60%" 
    DataSourceID="CustomerRFDataSource"
    >
    <ClientSettings EnableFieldsDragDrop="True">
        <Scrolling AllowVerticalScroll="True" />
    </ClientSettings>
    <ExportSettings Excel-Format="Xlsx" OpenInNewWindow="true">
    </ExportSettings>

    <ColumnHeaderCellStyle  Font-Size="Small" >
    </ColumnHeaderCellStyle>

    <Fields>
        <telerik:PivotGridRowField DataField="Generateddt" UniqueName="ReleaseYear" GroupInterval="Year"  DataFormatString="{0:yyyy}" >
        </telerik:PivotGridRowField> 
        
        <telerik:PivotGridRowField DataField="Generateddt" UniqueName="ReleaseDate" GroupInterval="Day"  DataFormatString="{0:dd-MMM-yyyy}">
        </telerik:PivotGridRowField>        

        <telerik:PivotGridColumnField DataField="DueDT" UniqueName="Year" GroupInterval="Year" ZoneIndex="0" DataFormatString="{0:yyyy}" >
        </telerik:PivotGridColumnField>
                
        <telerik:PivotGridColumnField DataField="DueDT" UniqueName="Month" GroupInterval="Month" ZoneIndex="0" DataFormatString="{0:MMM-yyyy}" >
        </telerik:PivotGridColumnField>
                
        <telerik:PivotGridColumnField DataField="DueDT" UniqueName="Due_Date" GroupInterval="Day" ZoneIndex="1" DataFormatString="{0:dd-MMM-yyyy}"  >
        </telerik:PivotGridColumnField>

        <telerik:PivotGridAggregateField TotalFormat-Axis="Columns" DataField="StdQty" GrandTotalAggregateFormatString="{0:N0}" UniqueName="Release_Quantity" Aggregate="Sum" DataFormatString="{0:N0}" IgnoreNullValues="True" TotalFormatString="{0:N0}">
            <TotalFormat Level="0" Axis="Rows" TotalFunction="RunningTotalsIn"  SortOrder="Ascending" >
            </TotalFormat>
        </telerik:PivotGridAggregateField>
    </Fields>
</telerik:RadPivotGrid>
       
<asp:SqlDataSource ID="CustomerRFDataSource" 
    runat="server" 
    ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
    SelectCommand="hn.SP_MAT_Releases_Shipouts_Analysis" 
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:ControlParameter ControlID="RadDatePicker1" Name="FechaInicial" PropertyName="SelectedDate" Type="DateTime" DefaultValue="2017-11-27" />
        <asp:ControlParameter ControlID="RadDatePicker2" Name="FechaFinal" PropertyName="SelectedDate" Type="DateTime" DefaultValue="2018-05-04" />
        <asp:ControlParameter ControlID="RadAutoCompleteBox1" Name="Parte" PropertyName="Text" Type="String" DefaultValue="NOR0047" />
        <asp:ControlParameter ControlID="RadDropDownList1" Name="Dia" PropertyName="SelectedValue" Type="Int32" DefaultValue="5" />
    </SelectParameters>
</asp:SqlDataSource>

<br />

<b>Long Lead Items:</b>
<Telerik:RadGrid ID="RadGrid1" runat="server" Skin="Silk" MasterTableView-TableLayout="Fixed"
    AllowFilteringByColumn="True" AllowSorting="True" AutoGenerateColumns="False" ShowFooter="true" MasterTableView-CommandItemSettings-ShowExportToExcelButton="true"
    DataSourceID="BOMDataSource" >
    <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <ClientSettings>
                <Selecting AllowRowSelect="True" />
            </ClientSettings>
            <MasterTableView DataSourceID="BOMDataSource">
                <Columns>

                    <telerik:GridBoundColumn DataField="DefaultPO" FilterControlAltText="Filter DefaultPO column" HeaderText="DefaultPO" SortExpression="DefaultPO" UniqueName="DefaultPO">
                    </telerik:GridBoundColumn> 
                    <telerik:GridBoundColumn DataField="PrimaryVendor" FilterControlAltText="Filter PrimaryVendor column" HeaderText="PrimaryVendor" SortExpression="PrimaryVendor" UniqueName="PrimaryVendor">
                    </telerik:GridBoundColumn>                  
                    <telerik:GridBoundColumn DataField="BOM_Part" FilterControlAltText="Filter BOM_Part column" HeaderText="BOM_Part" SortExpression="BOM_Part" UniqueName="BOM_Part">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BOM_Part_Description" FilterControlAltText="Filter BOM_Part_Description column" HeaderText="BOM_Part_Description" SortExpression="BOM_Part_Description" UniqueName="BOM_Part_Description">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Commodity" FilterControlAltText="Filter Commodity column" HeaderText="Commodity" SortExpression="Commodity" UniqueName="Commodity">
                    </telerik:GridBoundColumn>                    
                    <telerik:GridBoundColumn DataField="Unique_Material" FilterControlAltText="Filter Unique_Material column" HeaderText="Unique_Material" SortExpression="Unique_Material" UniqueName="Unique_Material">
                    </telerik:GridBoundColumn>  

                    <telerik:GridBoundColumn DataField="LeadTimeWeeks" DataType="System.Decimal" FilterControlAltText="Filter LeadTimeWeeks column" HeaderText="LeadTimeWeeks" ReadOnly="True" SortExpression="LeadTimeWeeks" UniqueName="LeadTimeWeeks" DataFormatString="{0:N0}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StandardPack" DataType="System.Decimal" FilterControlAltText="Filter StandardPack column" HeaderText="StandardPack" ReadOnly="True" SortExpression="StandardPack" UniqueName="StandardPack" DataFormatString="{0:N0}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BOM_Qty" DataType="System.Double" FilterControlAltText="Filter BOM_Qty column" HeaderText="BOM_Qty" ReadOnly="True" SortExpression="BOM_Qty" UniqueName="BOM_Qty" DataFormatString="{0:N6}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BOM_UOM" FilterControlAltText="Filter BOM_UOM column" HeaderText="BOM_UOM" SortExpression="BOM_UOM" UniqueName="BOM_UOM">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Part_MaterialCum" DataType="System.Decimal" FilterControlAltText="Filter Part_MaterialCum column" HeaderText="Part_MaterialCum" ReadOnly="True" SortExpression="Part_MaterialCum" UniqueName="Part_MaterialCum" DataFormatString="{0:C6}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BOM_Ext_MaterialCum" DataType="System.Double" FilterControlAltText="Filter BOM_Ext_MaterialCum column" HeaderText="BOM_Ext_MaterialCum" ReadOnly="True" SortExpression="BOM_Ext_MaterialCum" UniqueName="BOM_Ext_MaterialCum" DataFormatString="{0:C2}" Aggregate="Sum" FooterAggregateFormatString="{0:C2}">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
    </Telerik:RadGrid>
    <asp:SqlDataSource ID="BOMDataSource" 
        runat="server"
        ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>"
        SelectCommand="ft.ftsp_BOMperPart_Graph"
        SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:ControlParameter ControlID="RadAutoCompleteBox1" Name="Part" PropertyName="Text" Type="String" DefaultValue="NOR0047" />
    </SelectParameters>
    </asp:SqlDataSource>

        </div>
    </form>
</body>
</html>
