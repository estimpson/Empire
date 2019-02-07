<%@ Page Language="C#" AutoEventWireup="true" CodeFile="KomaxProduction_Telerik.aspx.cs" Inherits="KomaxProduction_Telerik" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Komax Production by Period</title>
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
                <Telerik:AjaxUpdatedControl ControlID="SDS_KomaxProduction2" />
                <Telerik:AjaxUpdatedControl ControlID="RadGrid1" />
            </updatedcontrols>
        </telerik:AjaxSetting>
    </ajaxsettings>
</telerik:RadAjaxManager>

<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
</telerik:RadAjaxLoadingPanel>
 
<div>       

<telerik:RadDatePicker ID="RadDatePicker1" Runat="server" DateInput-Label="From Date"
                        Culture="en-US"  MaxDate="2025-12-31" MinDate="2015-01-01" RendorMode="Lightweight" Skin="Silk" Width="275px">

    <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" EnableWeekends="True" RendorMode="Lightweight" FastNavigationNextText="&amp;lt;&amp;lt;" Skin="Silk" EnableKeyboardNavigation="True">
    </Calendar>

    <DateInput runat="server" DisplayDateFormat="yyyy-MM-dd" DateFormat="yyyy-MM-dd" LabelWidth="45%" Skin="Silk" RendorMode="Lightweight">
    </DateInput>

</telerik:RadDatePicker>


<telerik:RadDatePicker ID="RadDatePicker2" Runat="server" DateInput-Label="To Date" 
                        Culture="en-US"  MaxDate="2025-12-31" MinDate="2015-01-01" Skin="Silk" Width="225px" RendorMode="Lightweight">

    <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" EnableWeekends="True" RendorMode="Lightweight" FastNavigationNextText="&amp;lt;&amp;lt;" Skin="Silk" EnableKeyboardNavigation="True">
    </Calendar>

    <DateInput runat="server" DisplayDateFormat="yyyy-MM-dd" DateFormat="yyyy-MM-dd" LabelWidth="45%" Skin="Silk" RendorMode="Lightweight">
    </DateInput>

</telerik:RadDatePicker>



<telerik:RadDropDownList ID="RadDropDownList1" runat="server" RenderMode="Lightweight" Skin="Material" AutoPostBack="true" Height="35px" >
    <Items>
        <telerik:DropDownListItem runat="server" Selected="False" Text="Day" Value="dd" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Week" Value="wk" /> 
        <telerik:DropDownListItem runat="server" Selected="False" Text="Month" Value="mm" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Quarter" Value="qq" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Year" Value="yy" />
       
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


<b>Komax Production:</b>
<Telerik:RadGrid ID="RadGrid1" runat="server" Skin="Silk" 
    AllowFilteringByColumn="True" AllowSorting="True" OnColumnCreated="RadGrid1_ColumnCreated"
    DataSourceID="SDS_KomaxProduction2" >
    <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <ClientSettings>
                <Selecting AllowRowSelect="True" />
            </ClientSettings>
          
            <MasterTableView DataSourceID="SDS_KomaxProduction2" AutoGenerateColumns="true" ShowFooter="true">
              
            </MasterTableView>
    </Telerik:RadGrid>
    <asp:SqlDataSource ID="SDS_KomaxProduction2" runat="server" ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>" SelectCommand="eeiuser.acctg_pac_production_by_machine" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID ="RadDropDownList1" PropertyName="SelectedValue" Name="Increment" Type="String" DefaultValue="wk" />
                    <asp:ControlParameter ControlID ="RadDatePicker1" PropertyName="SelectedDate" Name="Begin_date" Type="DateTime" DefaultValue="2018-05-01" />
                    <asp:ControlParameter ControlID ="RadDatePicker2" PropertyName="SelectedDate" Name="End_date" Type="DateTime" DefaultValue="2018-06-01" />
                </SelectParameters>
    </asp:SqlDataSource>

        </div>
    </form>
</body>
</html>
