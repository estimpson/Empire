<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NALReview.aspx.cs" Inherits="NALReview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
        .style1
        {
            font-family: Verdana;
            font-size: small;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
    <AjaxSettings>
    
    <telerik:AjaxSetting AjaxControlID="RadDatePicker1">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
            <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
        </UpdatedControls>
    </telerik:AjaxSetting>

    <telerik:AjaxSetting AjaxControlID="RadDatePicker2">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
            <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    <telerik:AjaxSetting AjaxControlID="RadGrid2">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
            <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    <telerik:AjaxSetting AjaxControlID="RadGrid3">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <span class="style1">Display Shipments from:</span>
            <telerik:RadDatePicker ID="RadDatePicker1" Runat="server" AutoPostBack="True" 
                Culture="en-US" 
                HiddenInputTitleAttibute="Visually hidden input created for functionality purposes." 
                SelectedDate="2013-01-01" 
                WrapperTableSummary="Table holding date picker control for selection of dates.">
                <Calendar UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" ViewSelectorText="x">
                </Calendar>

                <DateInput DisplayDateFormat="M/dd/yyyy" DateFormat="M/dd/yyyy" LabelWidth="40%" 
                    AutoPostBack="True" DisplayText="1/1/2013" SelectedDate="2013-01-01" 
                    value="1/1/2013">
                </DateInput>

                <DatePopupButton ImageUrl="" HoverImageUrl="">
                </DatePopupButton>
            </telerik:RadDatePicker>

            &nbsp;<span class="style1">to: </span>
            
            <telerik:RadDatePicker ID="RadDatePicker2" Runat="server" AutoPostBack="True" 
                Culture="en-US" 
                HiddenInputTitleAttibute="Visually hidden input created for functionality purposes." 
                SelectedDate="2013-01-01" 
                WrapperTableSummary="Table holding date picker control for selection of dates.">
                <Calendar UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" ViewSelectorText="x">
                </Calendar>

                <DateInput DisplayDateFormat="M/dd/yyyy" DateFormat="M/dd/yyyy" LabelWidth="40%" 
                    AutoPostBack="True" DisplayText="1/31/2013" SelectedDate="2013-01-31" 
                    value="1/31/2013">
                </DateInput>

                <DatePopupButton ImageUrl="" HoverImageUrl="">
                </DatePopupButton>
            </telerik:RadDatePicker>
            <br />
            <br />
            <span class="style1">
            <strong>Shipments:</strong></span>
            <telerik:RadGrid ID="RadGrid2" ShowStatusBar="True" runat="server"
                DataSourceID="SqlDataSource2" GridLines="None" Width="95%" 
                CellSpacing="0" ShowGroupPanel="True" >
                <MasterTableView Width="100%" AutoGenerateColumns="False" DataKeyNames="id" 
                    DataSourceID="SqlDataSource2" AllowSorting="True" GroupLoadMode="Client" 
                    PageSize="20">
                    <CommandItemSettings ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                        Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                        Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridHyperLinkColumn AllowSorting="False" 
                            FilterControlAltText="Filter column column" ImageUrl="~/images/invoice24x24.png" Target="_blank"
                            UniqueName="column" DataNavigateUrlFields="customer,type,id" ItemStyle-BorderStyle="None" 
                            DataNavigateUrlFormatString="file://srvdata1/data/acctng/accounts receivable/invoices/{0}/{0} {1} {2}.pdf" 
                            DataTextField="id" Groupable="False">
                        </telerik:GridHyperLinkColumn>
                        <telerik:GridBoundColumn DataField="plant" 
                            FilterControlAltText="Filter plant column" HeaderText="plant" 
                            SortExpression="plant" UniqueName="plant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="id" DataType="System.Int32" 
                            FilterControlAltText="Filter id column" HeaderText="id" ReadOnly="True" 
                            SortExpression="id" UniqueName="id">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer" 
                            FilterControlAltText="Filter customer column" HeaderText="customer" 
                            SortExpression="customer" UniqueName="customer">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nal_destination" 
                            FilterControlAltText="Filter nal_destination column" 
                            HeaderText="nal_destination" ReadOnly="True" SortExpression="nal_destination" 
                            UniqueName="nal_destination">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="status" 
                            FilterControlAltText="Filter status column" HeaderText="status" 
                            SortExpression="status" UniqueName="status">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="date_shipped" DataType="System.DateTime" 
                            FilterControlAltText="Filter date_shipped column" HeaderText="date_shipped" 
                            SortExpression="date_shipped" UniqueName="date_shipped">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="notes" 
                            FilterControlAltText="Filter notes column" HeaderText="notes" 
                            SortExpression="notes" UniqueName="notes">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true" 
                    AllowDragToGroup="True">
                    <Selecting AllowRowSelect="true" />
                    <Scrolling AllowScroll="True" ScrollHeight="500px" UseStaticHeaders="True" />
                </ClientSettings>
                <PagerStyle Mode="NextPrevAndNumeric" />
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <br />
            <br />
            <span class="style1">
            <strong>Shipment Details:</strong></span>
            <telerik:RadGrid ID="RadGrid3" ShowStatusBar="True" runat="server" 
                DataSourceID="SqlDataSource3" GridLines="None" Width="95%" 
                CellSpacing="0" AllowSorting="True">
                <ClientSettings AllowColumnsReorder="True" ReorderColumnsOnClient="True">
                    <Selecting AllowRowSelect="True" />
                </ClientSettings>
                <MasterTableView Width="100%" AutoGenerateColumns="False" 
                    DataSourceID="SqlDataSource3" AllowPaging="True" PageSize="10" 
                    ShowFooter="True">
                    <CommandItemSettings ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                        Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                        Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridBoundColumn DataField="shipper" 
                            FilterControlAltText="Filter shipper column" HeaderText="shipper" 
                            SortExpression="shipper" UniqueName="shipper" DataType="System.Int32">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="part_original" 
                            FilterControlAltText="Filter part_original column" HeaderText="part_original" 
                            SortExpression="part_original" UniqueName="part_original">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer_part" 
                            FilterControlAltText="Filter customer_part column" HeaderText="customer_part" 
                            SortExpression="customer_part" UniqueName="customer_part">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="order_no" 
                            FilterControlAltText="Filter order_no column" HeaderText="order_no" 
                            SortExpression="order_no" UniqueName="order_no" DataType="System.Decimal">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer_po" 
                            FilterControlAltText="Filter customer_po column" HeaderText="customer_po" 
                            SortExpression="customer_po" UniqueName="customer_po">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_no" 
                            FilterControlAltText="Filter release_no column" HeaderText="release_no" 
                            SortExpression="release_no" UniqueName="release_no">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_date" DataType="System.DateTime" 
                            FilterControlAltText="Filter release_date column" HeaderText="release_date" 
                            SortExpression="release_date" UniqueName="release_date">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_required" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_required column" HeaderText="qty_required" 
                            SortExpression="qty_required" UniqueName="qty_required">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="boxes_staged" 
                            FilterControlAltText="Filter boxes_staged column" HeaderText="boxes_staged" 
                            SortExpression="boxes_staged" UniqueName="boxes_staged" 
                            DataType="System.Int32">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="operator" 
                            FilterControlAltText="Filter operator column" HeaderText="operator" 
                            SortExpression="operator" UniqueName="operator">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_packed" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_packed column" 
                            HeaderText="qty_packed" SortExpression="qty_packed" 
                            UniqueName="qty_packed">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="alternate_price" DataType="System.Decimal" 
                            FilterControlAltText="Filter alternate_price column" HeaderText="alternate_price" 
                            SortExpression="alternate_price" UniqueName="alternate_price">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="amount" DataType="System.Decimal" 
                            FilterControlAltText="Filter amount column" HeaderText="amount" ReadOnly="True" 
                            SortExpression="amount" UniqueName="amount">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                </MasterTableView>
                <PagerStyle Mode="NextPrevAndNumeric" />
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="SqlDataSource2" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="SELECT s.plant, s.id, s.customer, (case when isnull(s.type,'S')='R' then 'C' else 'I' end) as type, (case when s.destination = 'NALMSHOALS' then 'MUSCLESHOALS' else 
(case when s.destination = 'ES3NORTHAL' then 'MUSCLESHOALS' else 
(case when s.destination = 'ES3NALFLORA' then 'FLORA' else 
(case when s.destination = 'ES3EEIFLORA' then 'FLORA' else
(case when s.destination = 'NALPARIS' then 'PARIS' else 
(case when s.destination = 'ES3NALPARIS' then 'PARIS' else
(case when s.destination = 'NALSALEM' then 'SALEM' else 
(case when s.destination = 'ES3NALSALEM' then 'SALEM' else 
(case when s.destination = 'EEANALSALEM' then 'SALEM' else
s.destination end)end)end)end)end)end)end)end)end) as nal_destination,
s.destination, s.status, s.date_shipped, s.notes FROM shipper AS s WHERE ((s.customer LIKE '%NAL%') AND (s.date_shipped &gt;=@fromdate) AND (s.date_shipped &lt; dateadd(d,1,@todate))) OR ((s.customer LIKE '%NAL%') AND (s.status IN ('S','O'))) ORDER BY s.plant, s.status, s.id"
                runat="server">
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadDatePicker1" Name="fromdate" 
                        PropertyName="SelectedDate" />
                    <asp:ControlParameter ControlID="RadDatePicker2" Name="todate" 
                        PropertyName="SelectedDate" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource3" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="SELECT sd.shipper, sd.part_original, sd.customer_part, sd.order_no, sd.customer_po, sd.release_no, sd.release_date, sd.qty_required, sd.boxes_staged, sd.operator, sd.qty_packed, sd.alternate_price, sd.qty_packed * sd.alternate_price AS amount FROM shipper_detail AS sd WHERE sd.shipper = @shipper"
                runat="server">
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadGrid2" Name="shipper" DefaultValue = "10643" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
