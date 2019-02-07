<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NALPivot.aspx.cs" Inherits="NALReview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
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
        <telerik:AjaxSetting AjaxControlID="RadGrid2">
            <UpdatedControls>
                <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
            </UpdatedControls>
        </telerik:AjaxSetting>
    </AjaxSettings>
   
    </telerik:RadAjaxManager>
        <div>
            <br />

            <strong>Shipments:</strong>
            <telerik:RadGrid ID="RadGrid2" ShowStatusBar="True" runat="server"
                DataSourceID="SqlDataSource2" GridLines="None" Width="100%" 
                CellSpacing="0" ShowGroupPanel="True" >
                <MasterTableView Width="100%" AutoGenerateColumns="False" 
                    DataSourceID="SqlDataSource2">
                    <CommandItemSettings ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                        Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                        Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridBoundColumn DataField="plant" 
                            FilterControlAltText="Filter plant column" HeaderText="plant" 
                            SortExpression="plant" UniqueName="plant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="id" 
                            FilterControlAltText="Filter id column" HeaderText="id" 
                            SortExpression="id" UniqueName="id" 
                            ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer" 
                            FilterControlAltText="Filter customer column" HeaderText="customer" 
                            SortExpression="customer" UniqueName="customer">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nal_destination" 
                            FilterControlAltText="Filter nal_destination column" HeaderText="nal_destination" 
                            SortExpression="nal_destination" UniqueName="nal_destination" 
                            ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="destination" 
                            FilterControlAltText="Filter destination column" HeaderText="destination" 
                            SortExpression="destination" UniqueName="destination">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="status" 
                            FilterControlAltText="Filter status column" HeaderText="status" 
                            SortExpression="status" UniqueName="status">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="date_shipped" 
                            FilterControlAltText="Filter date_shipped column" HeaderText="date_shipped" 
                            SortExpression="date_shipped" UniqueName="date_shipped" 
                            DataType="System.DateTime">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="operator" 
                            FilterControlAltText="Filter operator column" HeaderText="operator" 
                            SortExpression="operator" UniqueName="operator">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="notes" 
                            FilterControlAltText="Filter notes column" HeaderText="notes" 
                            SortExpression="notes" UniqueName="notes">
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
                        <telerik:GridBoundColumn DataField="boxes_staged" DataType="System.Int32" 
                            FilterControlAltText="Filter boxes_staged column" 
                            HeaderText="boxes_staged" SortExpression="boxes_staged" 
                            UniqueName="boxes_staged">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_packed" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_packed column" HeaderText="qty_packed" 
                            SortExpression="qty_packed" UniqueName="qty_packed">
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
<EditColumn FilterControlAltText="Filter EditCommandColumn column"></EditColumn>
</EditFormSettings>
      

     
                </MasterTableView>
                <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true" 
                    AllowDragToGroup="True">
                    <Selecting AllowRowSelect="true" />
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <br />
            <br />
            <strong>Shipment Details:</strong>
            <asp:SqlDataSource ID="SqlDataSource2" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="SELECT s.plant, convert(varchar(25),s.id) as id, s.customer, (CASE WHEN s.destination = 'NALMSHOALS' THEN 'MUSCLESHOALS' ELSE (CASE WHEN s.destination = 'ES3NORTHAL' THEN 'MUSCLESHOALS' ELSE (CASE WHEN s.destination = 'ES3NALFLORA' THEN 'FLORA' ELSE (CASE WHEN s.destination = 'ES3EEIFLORA' THEN 'FLORA' ELSE (CASE WHEN s.destination = 'NALPARIS' THEN 'PARIS' ELSE (CASE WHEN s.destination = 'ES3NALPARIS' THEN 'PARIS' ELSE (CASE WHEN s.destination = 'NALSALEM' THEN 'SALEM' ELSE (CASE WHEN s.destination = 'ES3NALSALEM' THEN 'SALEM' ELSE (CASE WHEN s.destination = 'EEANALSALEM' THEN 'SALEM' ELSE s.destination END) END) END) END) END) END) END) END) END) AS nal_destination, s.destination, s.status, s.date_shipped, sd.operator, s.notes, sd.part_original, sd.customer_part, sd.order_no, sd.customer_po, sd.release_no, sd.release_date, sd.qty_required, sd.boxes_staged, sd.qty_packed, sd.alternate_price, sd.qty_packed * sd.alternate_price AS amount FROM shipper AS s INNER JOIN shipper_detail AS sd ON s.id = sd.shipper WHERE (s.customer LIKE '%NAL%') AND (s.date_shipped &gt; '2013-02-18') AND (ISNULL(s.type, 'S') &lt;&gt; 'R') OR (s.customer LIKE '%NAL%') AND (ISNULL(s.type, 'S') &lt;&gt; 'R') AND (s.status = 'O') ORDER BY s.plant, s.status, s.id"
                runat="server">
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
