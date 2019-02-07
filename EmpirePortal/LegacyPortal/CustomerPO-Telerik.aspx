<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerPO-Telerik.aspx.cs" Inherits="CustomerPO" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .MyImageButton
        {
            cursor: hand;
        }
        .EditFormHeader td
        {
            font-size: 14px;
            padding: 4px !important;
            color: #0066cc;
        }
        .style1
        {
            font-family: Consolas;
        }
    </style>
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
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <span class="style1"><strong>Customer PO Log</strong></span>
        <telerik:RadGrid ID="RadGrid1" GridLines="Vertical" runat="server" AllowAutomaticDeletes="True"
            AllowSorting="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True"
            AllowMultiRowEdit="True" DataSourceID="DataSource1" OnItemUpdated="RadGrid1_ItemUpdated"
            AllowFilteringByColumn="True" OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted"
            OnDataBound="RadGrid1_DataBound" CellSpacing="0" AutoGenerateColumns="False" 
            Height="600px" onitemcreated="RadGrid1_ItemCreated" Skin="Metro" >
            <ClientSettings AllowKeyboardNavigation="True">
                <Selecting AllowRowSelect="True" />
                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
            </ClientSettings>
            <MasterTableView CommandItemDisplay="Top" 
                DataKeyNames="CustomerCode,CustomerPO,CustomerPORev" DataSourceID="DataSource1" 
                EditMode="InPlace" HierarchyLoadMode="ServerBind" TableLayout="Fixed" Width="2500px">
                <CommandItemSettings ExportToPdfText="Export to PDF" />
                <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                    Visible="True">
                </RowIndicatorColumn>
                <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                    Visible="True">
                </ExpandCollapseColumn>
                <Columns>
               
                    <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column">
                    </telerik:GridEditCommandColumn>
               
                    <telerik:GridDropDownColumn DataSourceID = "SqlDataSourceCustomerCode" 
                        ListTextField="Customer" ListValueField="Customer"  
                        DataField="CustomerCode" HeaderStyle-Width="120px"
                        FilterControlAltText="Filter CustomerCode column" HeaderText="Customer" 
                        SortExpression="CustomerCode" UniqueName="CustomerCode" ReadOnly="False" 
                        DropDownControlType="RadComboBox">
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn DataField="CustomerPO" 
                        FilterControlAltText="Filter CustomerPO column" HeaderText="PO" 
                        SortExpression="CustomerPO" UniqueName="CustomerPO" ReadOnly="False">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPORev" HeaderStyle-Width="50px"
                        FilterControlAltText="Filter CustomerPORev column" HeaderText="PO Rev" 
                        SortExpression="CustomerPORev" UniqueName="CustomerPORev" ReadOnly="False">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID = "SqlDataSourceCustomerPOType" ListTextField="POType" ListValueField="POType" 
                     DataField="CustomerPOType" HeaderStyle-Width="80px"
                        FilterControlAltText="Filter CustomerPOType column" HeaderText="PO Type" 
                        SortExpression="CustomerPOType" UniqueName="CustomerPOType" DropDownControlType="RadComboBox">
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn DataField="CustomerPODateReceived" 
                        DataType="System.DateTime" DataFormatString="{0:d}" 
                        FilterControlAltText="Filter CustomerPODateReceived column" 
                        HeaderText="PO Date" SortExpression="CustomerPODateReceived" 
                        UniqueName="CustomerPODateReceived">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPOEffDate" 
                        DataType="System.DateTime" 
                        FilterControlAltText="Filter CustomerPOEffDate column" DataFormatString="{0:d}"
                        HeaderText="PO Eff Date" SortExpression="CustomerPOEffDate" 
                        UniqueName="CustomerPOEffDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID = "SqlDataSourceCustomerPOSalesTerms" ListTextField="Terms" ListValueField="Terms"
                     DataField="CustomerPOSalesTerms" 
                        FilterControlAltText="Filter CustomerPOSalesTerms column" 
                        HeaderText="Sales Terms" SortExpression="CustomerPOSalesTerms" 
                        UniqueName="CustomerPOSalesTerms" >
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn DataField="CustomerPOShippingTerms" 
                        FilterControlAltText="Filter CustomerPOShippingTerms column" 
                        HeaderText="Shipping Terms" SortExpression="CustomerPOShippingTerms" 
                        UniqueName="CustomerPOShippingTerms">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPOFreightPayer" 
                        FilterControlAltText="Filter CustomerPOFreightPayer column" 
                        HeaderText="Freight Payer" SortExpression="CustomerPOFreightPayer" 
                        UniqueName="CustomerPOFreightPayer">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPart" 
                        FilterControlAltText="Filter CustomerPart column" HeaderText="CustomerPart" 
                        SortExpression="Customer Part" UniqueName="CustomerPart">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPartRev" 
                        FilterControlAltText="Filter CustomerPartRev column" 
                        HeaderText="Customer Part Rev" SortExpression="CustomerPartRev" 
                        UniqueName="CustomerPartRev">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPartDescription" 
                        FilterControlAltText="Filter CustomerPartDescription column" 
                        HeaderText="Part Description" SortExpression="CustomerPartDescription" 
                        UniqueName="CustomerPartDescription">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerPOQuantity" 
                        DataType="System.Decimal" 
                        FilterControlAltText="Filter CustomerPOQuantity column" 
                        HeaderText="PO Quantity" SortExpression="CustomerPOQuantity" 
                        UniqueName="CustomerPOQuantity">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerSellingPrice" 
                        DataType="System.Decimal" 
                        FilterControlAltText="Filter CustomerSellingPrice column" 
                        HeaderText="Customer Selling Price" SortExpression="CustomerSellingPrice" 
                        UniqueName="CustomerSellingPrice">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerSellingPriceBegDate" 
                        DataType="System.DateTime" 
                        FilterControlAltText="Filter CustomerSellingPriceBegDate column" 
                        HeaderText="Price Beg Date" DataFormatString="{0:d}"
                        SortExpression="CustomerSellingPriceBegDate" 
                        UniqueName="CustomerSellingPriceBegDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CustomerSellingPriceEndDate" 
                        DataType="System.DateTime" 
                        FilterControlAltText="Filter CustomerSellingPriceEndDate column" 
                        HeaderText="Price End Date" DataFormatString="{0:d}"
                        SortExpression="CustomerSellingPriceEndDate" 
                        UniqueName="CustomerSellingPriceEndDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridHyperLinkColumn DataNavigateUrlFields="CustomerCode, CustomerPO, CustomerPORev" DataNavigateUrlFormatString="file://SRVDATA1/Data/Groups/Everyone/Customer POs/{0} PO {1} Rev {2}.pdf" DataTextField="CustomerPO"
                        Target="_Blank"  FilterControlAltText="Filter CustomerPOFileLocation column" 
                        HeaderText="CustomerPOFileLocation" SortExpression="CustomerPOFileLocation" 
                        UniqueName="CustomerPOFileLocation">
                    </telerik:GridHyperLinkColumn>
                </Columns>
                <EditFormSettings>
                    <FormTableItemStyle Wrap="False" />
                    <FormCaptionStyle CssClass="EditFormHeader" />
                    <FormMainTableStyle BackColor="White" CellPadding="3" CellSpacing="0" 
                        GridLines="None" Width="100%" />
                    <FormTableStyle BackColor="White" CellPadding="2" CellSpacing="0" 
                        Height="110px" />
                    <FormTableAlternatingItemStyle Wrap="False" />
                    <EditColumn ButtonType="ImageButton" CancelText="Cancel edit" 
                        UniqueName="EditCommandColumn1">
                    </EditColumn>
                    <FormTableButtonRowStyle CssClass="EditFormButtonRow" HorizontalAlign="Right" />
                </EditFormSettings>
                <PagerStyle PageSizeControlType="RadComboBox" />
            </MasterTableView>
            <PagerStyle Mode="NextPrevAndNumeric" />
            <FilterMenu EnableImageSprites="False">
            </FilterMenu>
        </telerik:RadGrid>
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server">
        </telerik:RadWindowManager>
    </telerik:RadAjaxPanel>
    <asp:SqlDataSource SelectCommand="SELECT * FROM [eeiuser].[customer_po]" 
        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString1 %>" 
        ID="DataSource1" runat="server" ConflictDetection="CompareAllValues" 
        DeleteCommand="DELETE FROM [eeiuser].[customer_po] WHERE [CustomerCode] = @original_CustomerCode AND [CustomerPO] = @original_CustomerPO AND [CustomerPORev] = @original_CustomerPORev AND (([CustomerPOType] = @original_CustomerPOType) OR ([CustomerPOType] IS NULL AND @original_CustomerPOType IS NULL)) AND (([CustomerPODateReceived] = @original_CustomerPODateReceived) OR ([CustomerPODateReceived] IS NULL AND @original_CustomerPODateReceived IS NULL)) AND (([CustomerPOEffDate] = @original_CustomerPOEffDate) OR ([CustomerPOEffDate] IS NULL AND @original_CustomerPOEffDate IS NULL)) AND (([CustomerPOSalesTerms] = @original_CustomerPOSalesTerms) OR ([CustomerPOSalesTerms] IS NULL AND @original_CustomerPOSalesTerms IS NULL)) AND (([CustomerPOShippingTerms] = @original_CustomerPOShippingTerms) OR ([CustomerPOShippingTerms] IS NULL AND @original_CustomerPOShippingTerms IS NULL)) AND (([CustomerPOFreightPayer] = @original_CustomerPOFreightPayer) OR ([CustomerPOFreightPayer] IS NULL AND @original_CustomerPOFreightPayer IS NULL)) AND (([CustomerPart] = @original_CustomerPart) OR ([CustomerPart] IS NULL AND @original_CustomerPart IS NULL)) AND (([CustomerPartRev] = @original_CustomerPartRev) OR ([CustomerPartRev] IS NULL AND @original_CustomerPartRev IS NULL)) AND (([CustomerPartDescription] = @original_CustomerPartDescription) OR ([CustomerPartDescription] IS NULL AND @original_CustomerPartDescription IS NULL)) AND (([CustomerPOQuantity] = @original_CustomerPOQuantity) OR ([CustomerPOQuantity] IS NULL AND @original_CustomerPOQuantity IS NULL)) AND (([CustomerSellingPrice] = @original_CustomerSellingPrice) OR ([CustomerSellingPrice] IS NULL AND @original_CustomerSellingPrice IS NULL)) AND (([CustomerSellingPriceBegDate] = @original_CustomerSellingPriceBegDate) OR ([CustomerSellingPriceBegDate] IS NULL AND @original_CustomerSellingPriceBegDate IS NULL)) AND (([CustomerSellingPriceEndDate] = @original_CustomerSellingPriceEndDate) OR ([CustomerSellingPriceEndDate] IS NULL AND @original_CustomerSellingPriceEndDate IS NULL)) AND (([CustomerPOFileLocation] = @original_CustomerPOFileLocation) OR ([CustomerPOFileLocation] IS NULL AND @original_CustomerPOFileLocation IS NULL))" 
        InsertCommand="INSERT INTO [eeiuser].[customer_po] ([CustomerCode], [CustomerPO], [CustomerPORev], [CustomerPOType], [CustomerPODateReceived], [CustomerPOEffDate], [CustomerPOSalesTerms], [CustomerPOShippingTerms], [CustomerPOFreightPayer], [CustomerPart], [CustomerPartRev], [CustomerPartDescription], [CustomerPOQuantity], [CustomerSellingPrice], [CustomerSellingPriceBegDate], [CustomerSellingPriceEndDate], [CustomerPOFileLocation]) VALUES (@CustomerCode, @CustomerPO, @CustomerPORev, @CustomerPOType, @CustomerPODateReceived, @CustomerPOEffDate, @CustomerPOSalesTerms, @CustomerPOShippingTerms, @CustomerPOFreightPayer, @CustomerPart, @CustomerPartRev, @CustomerPartDescription, @CustomerPOQuantity, @CustomerSellingPrice, @CustomerSellingPriceBegDate, @CustomerSellingPriceEndDate, @CustomerPOFileLocation)" 
        OldValuesParameterFormatString="original_{0}" 
        UpdateCommand="UPDATE [eeiuser].[customer_po] SET [CustomerCode] = @CustomerCode, [CustomerPO] = @CustomerPO, [CustomerPOType] = @CustomerPOType, [CustomerPODateReceived] = @CustomerPODateReceived, [CustomerPOEffDate] = @CustomerPOEffDate, [CustomerPOSalesTerms] = @CustomerPOSalesTerms, [CustomerPOShippingTerms] = @CustomerPOShippingTerms, [CustomerPOFreightPayer] = @CustomerPOFreightPayer, [CustomerPart] = @CustomerPart, [CustomerPartRev] = @CustomerPartRev, [CustomerPartDescription] = @CustomerPartDescription, [CustomerPOQuantity] = @CustomerPOQuantity, [CustomerSellingPrice] = @CustomerSellingPrice, [CustomerSellingPriceBegDate] = @CustomerSellingPriceBegDate, [CustomerSellingPriceEndDate] = @CustomerSellingPriceEndDate, [CustomerPOFileLocation] = @CustomerPOFileLocation WHERE [CustomerCode] = @original_CustomerCode AND [CustomerPO] = @original_CustomerPO AND [CustomerPORev] = @original_CustomerPORev AND (([CustomerPOType] = @original_CustomerPOType) OR ([CustomerPOType] IS NULL AND @original_CustomerPOType IS NULL)) AND (([CustomerPODateReceived] = @original_CustomerPODateReceived) OR ([CustomerPODateReceived] IS NULL AND @original_CustomerPODateReceived IS NULL)) AND (([CustomerPOEffDate] = @original_CustomerPOEffDate) OR ([CustomerPOEffDate] IS NULL AND @original_CustomerPOEffDate IS NULL)) AND (([CustomerPOSalesTerms] = @original_CustomerPOSalesTerms) OR ([CustomerPOSalesTerms] IS NULL AND @original_CustomerPOSalesTerms IS NULL)) AND (([CustomerPOShippingTerms] = @original_CustomerPOShippingTerms) OR ([CustomerPOShippingTerms] IS NULL AND @original_CustomerPOShippingTerms IS NULL)) AND (([CustomerPOFreightPayer] = @original_CustomerPOFreightPayer) OR ([CustomerPOFreightPayer] IS NULL AND @original_CustomerPOFreightPayer IS NULL)) AND (([CustomerPart] = @original_CustomerPart) OR ([CustomerPart] IS NULL AND @original_CustomerPart IS NULL)) AND (([CustomerPartRev] = @original_CustomerPartRev) OR ([CustomerPartRev] IS NULL AND @original_CustomerPartRev IS NULL)) AND (([CustomerPartDescription] = @original_CustomerPartDescription) OR ([CustomerPartDescription] IS NULL AND @original_CustomerPartDescription IS NULL)) AND (([CustomerPOQuantity] = @original_CustomerPOQuantity) OR ([CustomerPOQuantity] IS NULL AND @original_CustomerPOQuantity IS NULL)) AND (([CustomerSellingPrice] = @original_CustomerSellingPrice) OR ([CustomerSellingPrice] IS NULL AND @original_CustomerSellingPrice IS NULL)) AND (([CustomerSellingPriceBegDate] = @original_CustomerSellingPriceBegDate) OR ([CustomerSellingPriceBegDate] IS NULL AND @original_CustomerSellingPriceBegDate IS NULL)) AND (([CustomerSellingPriceEndDate] = @original_CustomerSellingPriceEndDate) OR ([CustomerSellingPriceEndDate] IS NULL AND @original_CustomerSellingPriceEndDate IS NULL)) AND (([CustomerPOFileLocation] = @original_CustomerPOFileLocation) OR ([CustomerPOFileLocation] IS NULL AND @original_CustomerPOFileLocation IS NULL))">
        <DeleteParameters>
            <asp:Parameter Name="original_CustomerCode" Type="String" />
            <asp:Parameter Name="original_CustomerPO" Type="String" />
            <asp:Parameter Name="original_CustomerPORev" Type="String" />
            <asp:Parameter Name="original_CustomerPOType" Type="String" />
            <asp:Parameter Name="original_CustomerPODateReceived" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOEffDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOSalesTerms" Type="String" />
            <asp:Parameter Name="original_CustomerPOShippingTerms" Type="String" />
            <asp:Parameter Name="original_CustomerPOFreightPayer" Type="String" />
            <asp:Parameter Name="original_CustomerPart" Type="String" />
            <asp:Parameter Name="original_CustomerPartRev" Type="String" />
            <asp:Parameter Name="original_CustomerPartDescription" Type="String" />
            <asp:Parameter Name="original_CustomerPOQuantity" Type="Decimal" />
            <asp:Parameter Name="original_CustomerSellingPrice" Type="Decimal" />
            <asp:Parameter Name="original_CustomerSellingPriceBegDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerSellingPriceEndDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOFileLocation" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="CustomerCode" Type="String" />
            <asp:Parameter Name="CustomerPO" Type="String" />
            <asp:Parameter Name="CustomerPORev" Type="String" />
            <asp:Parameter Name="CustomerPOType" Type="String" />
            <asp:Parameter Name="CustomerPODateReceived" Type="DateTime" />
            <asp:Parameter Name="CustomerPOEffDate" Type="DateTime" />
            <asp:Parameter Name="CustomerPOSalesTerms" Type="String" />
            <asp:Parameter Name="CustomerPOShippingTerms" Type="String" />
            <asp:Parameter Name="CustomerPOFreightPayer" Type="String" />
            <asp:Parameter Name="CustomerPart" Type="String" />
            <asp:Parameter Name="CustomerPartRev" Type="String" />
            <asp:Parameter Name="CustomerPartDescription" Type="String" />
            <asp:Parameter Name="CustomerPOQuantity" Type="Decimal" />
            <asp:Parameter Name="CustomerSellingPrice" Type="Decimal" />
            <asp:Parameter Name="CustomerSellingPriceBegDate" Type="DateTime" />
            <asp:Parameter Name="CustomerSellingPriceEndDate" Type="DateTime" />
            <asp:Parameter Name="CustomerPOFileLocation" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="CustomerCode" Type="String" />
            <asp:Parameter Name="CustomerPO" Type="String" />
            <asp:Parameter Name="CustomerPOType" Type="String" />
            <asp:Parameter Name="CustomerPODateReceived" Type="DateTime" />
            <asp:Parameter Name="CustomerPOEffDate" Type="DateTime" />
            <asp:Parameter Name="CustomerPOSalesTerms" Type="String" />
            <asp:Parameter Name="CustomerPOShippingTerms" Type="String" />
            <asp:Parameter Name="CustomerPOFreightPayer" Type="String" />
            <asp:Parameter Name="CustomerPart" Type="String" />
            <asp:Parameter Name="CustomerPartRev" Type="String" />
            <asp:Parameter Name="CustomerPartDescription" Type="String" />
            <asp:Parameter Name="CustomerPOQuantity" Type="Decimal" />
            <asp:Parameter Name="CustomerSellingPrice" Type="Decimal" />
            <asp:Parameter Name="CustomerSellingPriceBegDate" Type="DateTime" />
            <asp:Parameter Name="CustomerSellingPriceEndDate" Type="DateTime" />
            <asp:Parameter Name="CustomerPOFileLocation" Type="String" />
            <asp:Parameter Name="original_CustomerCode" Type="String" />
            <asp:Parameter Name="original_CustomerPO" Type="String" />
            <asp:Parameter Name="original_CustomerPORev" Type="String" />
            <asp:Parameter Name="original_CustomerPOType" Type="String" />
            <asp:Parameter Name="original_CustomerPODateReceived" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOEffDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOSalesTerms" Type="String" />
            <asp:Parameter Name="original_CustomerPOShippingTerms" Type="String" />
            <asp:Parameter Name="original_CustomerPOFreightPayer" Type="String" />
            <asp:Parameter Name="original_CustomerPart" Type="String" />
            <asp:Parameter Name="original_CustomerPartRev" Type="String" />
            <asp:Parameter Name="original_CustomerPartDescription" Type="String" />
            <asp:Parameter Name="original_CustomerPOQuantity" Type="Decimal" />
            <asp:Parameter Name="original_CustomerSellingPrice" Type="Decimal" />
            <asp:Parameter Name="original_CustomerSellingPriceBegDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerSellingPriceEndDate" Type="DateTime" />
            <asp:Parameter Name="original_CustomerPOFileLocation" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>     
    <asp:SqlDataSource ID="SqlDataSourceCustomerCode" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString2 %>" 
            SelectCommand="SELECT distinct(customer) FROM [ar_customers]" >
        </asp:SqlDataSource>
     <asp:SqlDataSource ID="SqlDataSourceCustomerPOSalesTerms" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString2 %>" 
            SelectCommand="SELECT distinct(terms) FROM [terms]" >
        </asp:SqlDataSource>
             <asp:SqlDataSource ID="SqlDataSourceCustomerPOType" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MonitorConnectionString2 %>" 
            SelectCommand="SELECT 'Blanket' as POType union SELECT 'Spot Buy' as POType" >
          </asp:SqlDataSource>
          </form>
  
</body>
</html>
