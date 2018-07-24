<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GridTest.aspx.cs" Inherits="SupplierEDI.Web.SupplierEDIModule.Pages.GridTest" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CustomHeaderHolder" runat="server">
    <script type="text/javascript">
        function pageLoad() {
            $(function () {
                updateGridHeight();
            });
        }

        function updateGridHeight() {
            Grid1.SetHeight(0);
            Grid2.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            Grid1.SetHeight(containerHeight - 160);
            Grid2.SetHeight(containerHeight - 160);

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
    <dx:ASPxFormLayout runat="server" ID="MainFormLayout">
        <Items>
           <dx:TabbedLayoutGroup Name="TabLayout">
                <Items>
                    <dx:LayoutItem>
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxGridView ID="Grid1" runat="server" ClientInstanceName="Grid1"
                                                 DataSourceID="ObjectDataSourcePOs" AutoGenerateColumns="False"
                                                 KeyFieldName="PurchaseOrderNumber" Width="98%" 
                                                 OnCustomCallback="Grid_CustomCallback" 
                                                 OnHtmlRowPrepared="Grid_HtmlRowPrepared"
                                                 OnSelectionChanged="Grid1_OnSelectionChanged"
                                                 >
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowFilterBar="Auto" ShowGroupPanel="True" ShowHeaderFilterButton="False" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                                    <SettingsBehavior AllowSelectByRowClick="True" SortMode="Value" ProcessSelectionChangedOnServer="True"/>
                                    <SettingsSearchPanel Visible="True" />
                                    <SettingsPager PageSize="30"></SettingsPager>
                                    <Columns>
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" />
                                        <dx:GridViewDataTextColumn FieldName="RowID" ReadOnly="True" VisibleIndex="0" Visible="False"/>
                                        <dx:GridViewDataTextColumn FieldName="PurchaseOrderNumber" VisibleIndex="1"/>
                                        <dx:GridViewDataTextColumn FieldName="EmpireVendorCode" GroupIndex="1" SortIndex="1" VisibleIndex="2"/>
                                        <dx:GridViewDataTextColumn FieldName="EmpireBlanketPart" VisibleIndex="3"/>
                                        <dx:GridViewDataColumn FieldName="ReleaseCount" VisibleIndex="4"/>
                                        <dx:GridViewDataTextColumn FieldName="TradingPartnerCode" VisibleIndex="5"/>
                                        <dx:GridViewDataTextColumn FieldName="OverlayGroup" GroupIndex="0" SortIndex="0" SortOrder="Ascending" VisibleIndex="6"/>
                                        <dx:GridViewDataHyperLinkColumn Caption="830" VisibleIndex="8" FieldName="PurchaseOrderNumber">
                                            <PropertiesHyperLinkEdit
                                                NavigateUrlFormatString="javascript:ShowDetailPopup('{0}');"
                                                Text="Preview">
                                            </PropertiesHyperLinkEdit>
                                        </dx:GridViewDataHyperLinkColumn>
                                        <dx:GridViewDataTextColumn FieldName="FunctionName" VisibleIndex="7"/>
                                    </Columns>
                                    <GroupSummary>
                                        <dx:ASPxSummaryItem SummaryType="Count" />
                                    </GroupSummary>
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
                                </dx:ASPxGridView>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem>
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxGridView ID="Grid2" runat="server" ClientInstanceName="Grid2"
                                                 AutoGenerateColumns="False"
                                                 KeyFieldName="PurchaseOrderNumber" Width="98%" 
                                                 >
                                    <Settings ShowFilterRow="False" ShowFilterRowMenu="False" ShowFilterBar="Auto" ShowGroupPanel="True" ShowHeaderFilterButton="False" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                                    <SettingsBehavior SortMode="Value" AutoExpandAllGroups="True"/>
                                    <SettingsPager PageSize="30"></SettingsPager>
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="RowID" ReadOnly="True" VisibleIndex="0" Visible="False"/>
                                        <dx:GridViewDataTextColumn FieldName="PurchaseOrderNumber" VisibleIndex="1"/>
                                        <dx:GridViewDataTextColumn FieldName="EmpireVendorCode" GroupIndex="1" SortIndex="1" VisibleIndex="2"/>
                                        <dx:GridViewDataTextColumn FieldName="EmpireBlanketPart" VisibleIndex="3"/>
                                        <dx:GridViewDataColumn FieldName="ReleaseCount" VisibleIndex="4"/>
                                        <dx:GridViewDataTextColumn FieldName="TradingPartnerCode" VisibleIndex="5"/>
                                        <dx:GridViewDataTextColumn FieldName="OverlayGroup" GroupIndex="0" SortIndex="0" SortOrder="Ascending" VisibleIndex="6"/>
                                        <dx:GridViewDataHyperLinkColumn Caption="830" VisibleIndex="8" FieldName="PurchaseOrderNumber">
                                            <PropertiesHyperLinkEdit
                                                NavigateUrlFormatString="javascript:ShowDetailPopup('{0}');"
                                                Text="Preview">
                                            </PropertiesHyperLinkEdit>
                                        </dx:GridViewDataHyperLinkColumn>
                                        <dx:GridViewDataTextColumn FieldName="FunctionName" VisibleIndex="7"/>
                                    </Columns>
                                    <GroupSummary>
                                        <dx:ASPxSummaryItem SummaryType="Count" />
                                    </GroupSummary>
                                </dx:ASPxGridView>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:TabbedLayoutGroup>
            <dx:LayoutItem>
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxButton ID="_E1" Text="Next >>" runat="server" OnClick="_E1_OnClick">
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
