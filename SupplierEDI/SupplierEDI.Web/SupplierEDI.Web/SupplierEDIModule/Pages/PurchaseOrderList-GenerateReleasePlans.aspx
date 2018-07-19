<%@ Page Title="Purchase Order List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseOrderList-GenerateReleasePlans.aspx.cs" Inherits="SupplierEDI.Web.SupplierEDIModule.Pages.PurchaseOrderList_GenerateReleasePlans" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CustomHeaderHolder" runat="server">
    <script type="text/javascript">
        function pageLoad() {
            $(function () {
                updateGridHeight();
            });
        }

        function updateGridHeight() {
            PurchaseOrdersGrid.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            PurchaseOrdersGrid.SetHeight(containerHeight - 130);

        }

        function ShowDetailPopup(purchaseOrder) {
            window.open('Show830.aspx?PurchaseOrder=' + purchaseOrder, 'height=500,width=500,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
        }
    </script>
</asp:Content>
<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Supplier EDI - Purchase Order List"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <dx:ASPxFormLayout ID="FormLayout" runat="server">
        <Items>
            <dx:LayoutItem Caption="" ShowCaption="False">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxLabel ID="_E1" runat="server">
                        </dx:ASPxLabel>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:TabbedLayoutGroup Name="TabLayout">
                <Items>
                    <dx:LayoutGroup Caption="EDI Purchase Order List">
                        <Items>
                            <dx:LayoutItem Caption="All Enabled Suppliers">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridView runat="server" ID="PurchaseOrdersGrid" ClientInstanceName="PurchaseOrdersGrid" 
                                                         DataSourceID="ObjectDataSourcePOs" AutoGenerateColumns="False"
                                                         KeyFieldName="PurchaseOrderNumber" Width="98%" OnCustomCallback="Grid_CustomCallback" 
                                                         OnHtmlRowPrepared="Grid_HtmlRowPrepared" OnSelectionChanged="PurchaseOrdersGrid_OnSelectionChanged">
                                            <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowFilterBar="Auto" ShowGroupPanel="True" ShowHeaderFilterButton="False" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                                            <SettingsBehavior AllowSelectByRowClick="True" SortMode="Value" AutoExpandAllGroups="True"/>
                                            <SettingsSearchPanel Visible="True" />
                                            <SettingsPager PageSize="30"></SettingsPager>
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" />
                                                <dx:GridViewDataTextColumn FieldName="RowID" ReadOnly="True" VisibleIndex="0" Visible="False"/>
                                                <dx:GridViewDataTextColumn FieldName="PurchaseOrderNumber" VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="EmpireVendorCode" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="EmpireBlanketPart" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn FieldName="ReleaseCount" VisibleIndex="4">
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataTextColumn FieldName="TradingPartnerCode" VisibleIndex="5">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="OverlayGroup" GroupIndex="0" SortIndex="0" SortOrder="Ascending" VisibleIndex="6">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataHyperLinkColumn Caption="830" VisibleIndex="8" FieldName="PurchaseOrderNumber">
                                                    <PropertiesHyperLinkEdit
                                                        NavigateUrlFormatString="javascript:ShowDetailPopup('{0}');"
                                                        Text="Preview">
                                                    </PropertiesHyperLinkEdit>
                                                </dx:GridViewDataHyperLinkColumn>
                                                <dx:GridViewDataTextColumn FieldName="FunctionName" VisibleIndex="7">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                            <Templates>
                                                <GroupRowContent>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="groupCheckBox" runat="server" OnInit="groupCheckBox_OnInit"/>
                                                            </td>
                                                            <td>
                                                                <dx:ASPxLabel ID="CaptionText" runat="server" Text="<%# GetCaptionText(Container) %>"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </GroupRowContent>
                                            </Templates>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                        </dx:ASPxGridView>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                                <CaptionSettings HorizontalAlign="Center" Location="Top" />
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Selected Purchase Orders">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                                <CaptionSettings HorizontalAlign="Right" />
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                    <dx:LayoutGroup Caption="Selected Purchase Orders">
                        <Items>
                            <dx:LayoutItem>
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridView runat="server" ID="SelectedPurchaseOrdersGrid" ClientInstanceName="SelectedPurchaseOrdersGrid"
                                                         AutoGenerateColumns="False"
                                                         KeyFieldName="PurchaseOrderNumber" Width="98%">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="RowID" ReadOnly="True" VisibleIndex="0" Visible="False"/>
                                                <dx:GridViewDataTextColumn FieldName="PurchaseOrderNumber" VisibleIndex="1"/>
                                            </Columns>
                                        </dx:ASPxGridView>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:TabbedLayoutGroup>
            <dx:LayoutItem Caption="Next">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxButton ID="cbxNext" runat="server" OnClick="cbxNext_OnClick" Text="Next">
                        </dx:ASPxButton>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
        </Items>

    </dx:ASPxFormLayout>
    
    <asp:ObjectDataSource ID="ObjectDataSourcePOs" runat="server" SelectMethod="GetList" TypeName="SupplierEDI.Web.SupplierEDIModule.ViewModels.PurchaseOrdersViewModel"></asp:ObjectDataSource>

        <dx:ASPxPopupControl runat="server" ClientInstanceName="popup">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <iframe ID="xmlPreviewFrame" Name="xmlPreviewFrame"></iframe>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
