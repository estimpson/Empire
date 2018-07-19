<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register assembly="DevExpress.Web.v13.1" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v13.1" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <br />
        <br />
        <dx:ASPxGridView ID="Grid" runat="server" AutoGenerateColumns="False" DataSourceID="GridDataSource" 
            KeyFieldName="ProductID" ClientInstanceName="Grid" OnCustomCallback="Grid_CustomCallback" OnHtmlRowPrepared="Grid_HtmlRowPrepared">
            <Columns>
                <dx:GridViewCommandColumn ShowSelectCheckbox="true" VisibleIndex="0" />
                <dx:GridViewDataTextColumn FieldName="ProductID" ReadOnly="True" VisibleIndex="0" Visible="false" />
                <dx:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="1" />
                <dx:GridViewDataTextColumn FieldName="SupplierID" VisibleIndex="2" />
                <dx:GridViewDataComboBoxColumn Caption="Category Name" FieldName="CategoryID" VisibleIndex="3">
                    <PropertiesComboBox ValueField="CategoryID" TextField="CategoryName" 
                        DataSourceID="CategoryDataSource" ValueType="System.Int32" />
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn FieldName="QuantityPerUnit" VisibleIndex="4" />
                <dx:GridViewDataTextColumn FieldName="UnitPrice" VisibleIndex="5" />
                <dx:GridViewDataTextColumn FieldName="UnitsInStock" VisibleIndex="6" />
                <dx:GridViewDataTextColumn FieldName="UnitsOnOrder" VisibleIndex="7" />
                <dx:GridViewDataTextColumn FieldName="ReorderLevel" VisibleIndex="8" />
            </Columns>
            <Templates>
                <GroupRowContent>
                   <table>
                       <tr><td>
                            <dx:ASPxCheckBox ID="checkBox" runat="server" />
                       </td><td>
                            <dx:ASPxLabel ID="CaptionText" runat="server" Text='<%# GetCaptionText(Container) %>' />
                       </td></tr>
                   </table>
                </GroupRowContent>
            </Templates>
            <Settings ShowGroupPanel="true" />
            <GroupSummary>
                <dx:ASPxSummaryItem FieldName="CategoryName" SummaryType="Count" />
            </GroupSummary>
        </dx:ASPxGridView>
        <asp:AccessDataSource ID="GridDataSource" runat="server" DataFile="~/App_Data/nwind.mdb"
            SelectCommand="SELECT [ProductID], [ProductName], [SupplierID], [CategoryID], [QuantityPerUnit], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued] FROM [Products]" />
        <asp:AccessDataSource ID="CategoryDataSource" runat="server" DataFile="~/App_Data/nwind.mdb"
            SelectCommand="SELECT * FROM [Categories]" />
            
        <dx:ASPxButton ID="btn" runat="server" Text="PostBack" />
    </form>
</body>
</html>
