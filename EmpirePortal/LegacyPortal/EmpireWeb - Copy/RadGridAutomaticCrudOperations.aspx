<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RadGridAutomaticCrudOperations.aspx.cs" Inherits="RadGridAutomaticCrudOperations" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .MyImageButton {
            cursor: hand;
        }

        .EditFormHeader td {
            font-size: 14px;
            padding: 4px !important;
            color: #0066cc;
        }
    </style>
    <telerik:radstylesheetmanager id="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:radscriptmanager>
    <%--    <telerik:radajaxloadingpanel id="RadAjaxLoadingPanel1" runat="server" EnableEmbeddedSkins="false"/>--%>
        <telerik:radajaxpanel id="RadAjaxPanel1" runat="server">
            <Telerik:RadComboBox ID="RadComboBox1" Runat="server" EnableEmbeddedSkins="false">
            </Telerik:RadComboBox>
            <Telerik:RadGrid ID="RadGrid1" runat="server" EnableEmbeddedSkins="false" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" DataSourceID="DataSource1" OnDataBound="RadGrid1_DataBound" OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated">
                <PagerStyle Mode="NextPrevAndNumeric" />
                <mastertableview commanditemdisplay="TopAndBottom" datakeynames="purchase_order" datasourceid="DataSource1" editmode="InPlace" horizontalalign="NotSet" width="100%" AutoGenerateColumns="False">
                    <Columns>
                        <telerik:GridBoundColumn DataField="purchase_order" FilterControlAltText="Filter purchase_order column" HeaderText="purchase_order" ReadOnly="True" SortExpression="purchase_order" UniqueName="purchase_order">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="buy_vendor" FilterControlAltText="Filter buy_vendor column" HeaderText="buy_vendor" SortExpression="buy_vendor" UniqueName="buy_vendor">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="buy_unit" FilterControlAltText="Filter buy_unit column" HeaderText="buy_unit" SortExpression="buy_unit" UniqueName="buy_unit">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="pay_vendor" FilterControlAltText="Filter pay_vendor column" HeaderText="pay_vendor" SortExpression="pay_vendor" UniqueName="pay_vendor">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="pay_unit" FilterControlAltText="Filter pay_unit column" HeaderText="pay_unit" SortExpression="pay_unit" UniqueName="pay_unit">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="po_type" FilterControlAltText="Filter po_type column" HeaderText="po_type" SortExpression="po_type" UniqueName="po_type">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="location" FilterControlAltText="Filter location column" HeaderText="location" SortExpression="location" UniqueName="location">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                    </Columns>
                    <editformsettings>
                        <formtableitemstyle wrap="False" />
                        <formcaptionstyle cssclass="EditFormHeader" />
                        <FormMainTableStyle GridLines="None" CellSpacing="0" CellPadding="3" BackColor="White"
                        Width="100%" />
                        <FormTableStyle CellSpacing="0" CellPadding="2" Height="110px" BackColor="White" />
                        <formtablealternatingitemstyle wrap="False" />
                        <editcolumn buttontype="ImageButton" canceltext="Cancel edit" uniquename="EditCommandColumn1">
                        </editcolumn>
                        <formtablebuttonrowstyle cssclass="EditFormButtonRow" horizontalalign="Right" />
                    </editformsettings>
                </mastertableview>
            </Telerik:RadGrid>
        <telerik:RadWindowManager> ID="RadWindowManager1" runat="server" EnableEmbeddedSkins="false"</telerik:RadWindowManager>
    </telerik:radajaxpanel>
        <asp:SqlDataSource SelectCommand="select purchase_order, buy_vendor, buy_unit, pay_vendor, pay_unit, po_type, location from po_headers where purchase_order = @purchase_order" UpdateCommand="update po_headers set buy_unit = @buy_unit, pay_unit = @pay_unit, po_type = @po_type, currency = @currency where purchase_order = @purchase_order" ConnectionString="Data Source=EEHSQL1;Initial Catalog=EEH;User ID=sa;Password=" ID="DataSource1" runat="server">
            <SelectParameters>
                <asp:ControlParameter ControlID="RadComboBox1" DefaultValue="35858" Name="purchase_order" PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="buy_unit" />
                <asp:Parameter Name="pay_unit" />
                <asp:Parameter Name="po_type" />
                <asp:Parameter Name="currency" />
                <asp:Parameter Name="purchase_order" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
