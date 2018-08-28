<%@ Page Title="Quote Transfers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QuoteTransferList.aspx.cs" Inherits="WebPortal.QuoteLogIntegration.Pages.QuoteTransferList" %>

<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script src="../../Scripts/jquery-3.3.1.js"></script>
    <script>

        $(window).ready(function() {
            DoResizeAll();
        });

        $(window).resize(function() {
            DoResizeAll();
        });

        function DoResizeAll (s, e) {
            console.log("updateGridHeight");
            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();
            quoteTransfersGrid.SetHeight(containerHeight - 130);
        }

        function OnGridRowDoubleClick(s, e) {
            quoteTransfersGrid.GetRowValues(quoteTransfersGrid.GetFocusedRowIndex(), 'QuoteNumber', OnGetRowValues);
        }

        function OnGetRowValues(value) {
            quoteTransfersGrid.PerformCallback("RowDoubleClick");
        }

    </script>

</asp:Content>

<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Quote Transfers"></asp:Label>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <script>
        function OnNewQuoteTransferClick(s, e) {
            quoteTransferCallbackPanel.PerformCallback("New");
        }
    </script>
    <dx:ASPxButton runat="server" Text="New Quote Transfer" AutoPostBack="False">
        <ClientSideEvents
            Click="OnNewQuoteTransferClick"/>
    </dx:ASPxButton>
    <div id="quoteTransferGridViewContainer" style="margin-top: 5px">
        <dx:ASPxCallbackPanel ID="QuoteTransferCallbackPanel" ClientInstanceName="quoteTransferCallbackPanel" runat="server"
                              OnCallback="QuoteTransferCallbackPanel_OnCallback">
            <PanelCollection>
                <dx:PanelContent runat="server">
                    <dx:ASPxGridView ID="QuoteTransfersGrid" ClientInstanceName="quoteTransfersGrid" runat="server"
                        Width="98%"
                        DataSourceID="ObjectDataSource1" KeyFieldName="QuoteNumber" EnableRowsCache="True" AutoGenerateColumns="False"
                        EnableCallbacks="True" AutoPostback="False"
                        OnCustomCallback="QuoteTransfersGrid_OnCustomCallback">
                        <ClientSideEvents
                            RowDblClick="OnGridRowDoubleClick" />
                        <Styles>
                            <Header Wrap="True" />
                            <Cell>
                                <Paddings PaddingTop="1px" PaddingBottom="1px"/>
                            </Cell>
                        </Styles>

                        <Settings ShowFilterRow="true"/>
                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth"/>
                        <Settings HorizontalScrollBarMode="Auto"/>
                        <SettingsBehavior AllowSelectByRowClick="false"/>
                        <SettingsBehavior AllowFocusedRow="true"/>
                        <SettingsBehavior AutoExpandAllGroups="true"/>
                        <SettingsSearchPanel Visible="false" ColumnNames="QuoteNumber; BasePart"/>
                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="DataAware"/>
                        <SettingsAdaptivity AdaptivityMode="HideDataCells">
                        </SettingsAdaptivity>
                        <SettingsPager PageSize="15"></SettingsPager>
                        <SettingsEditing Mode="Inline"></SettingsEditing>
                        <SettingsBehavior ProcessFocusedRowChangedOnServer="false"/>
                        <Columns>
                            <dx:GridViewDataTextColumn Width="120" FieldName="QuoteNumber" VisibleIndex="0">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Customer" VisibleIndex="1">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="EmpirePartNumber" VisibleIndex="2">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="CustomerPartNumber" VisibleIndex="3">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Program" VisibleIndex="4">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="240" FieldName="Application" VisibleIndex="5">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="FinancialEau" VisibleIndex="6">
                                <PropertiesTextEdit DisplayFormatString="#,###" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="CapacityEau" VisibleIndex="7">
                                <PropertiesTextEdit DisplayFormatString="#,###" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Salesman" VisibleIndex="8">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="QuoteEngineer" VisibleIndex="9">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="ProgramManager" VisibleIndex="10">
                                <Settings AutoFilterCondition="Contains" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="SalesPrice" VisibleIndex="11">
                                <PropertiesTextEdit DisplayFormatString="$#,###.00####" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="LtaYear1" VisibleIndex="12">
                                <PropertiesTextEdit DisplayFormatString="#,##0.0#%" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="LtaYear2" VisibleIndex="13">
                                <PropertiesTextEdit DisplayFormatString="#,##0.0#%" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="LtaYear3" VisibleIndex="14">
                                <PropertiesTextEdit DisplayFormatString="#,##0.0#%" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="LtaYear4" VisibleIndex="15">
                                <PropertiesTextEdit DisplayFormatString="#,##0.0#%" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="PrototypePrice" VisibleIndex="16">
                                <PropertiesTextEdit DisplayFormatString="$#,###.00####" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="MinimumOrderQuantity" VisibleIndex="17">
                                <PropertiesTextEdit DisplayFormatString="#,###" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Material" VisibleIndex="18">
                                <PropertiesTextEdit DisplayFormatString="$#,###.00####" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Labor" VisibleIndex="19">
                                <PropertiesTextEdit DisplayFormatString="$#,###.00####" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="Tooling" VisibleIndex="20">
                                <PropertiesTextEdit DisplayFormatString="$#,###.00####" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn Width="120" FieldName="SOP" VisibleIndex="21">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn Width="120" FieldName="EOP" VisibleIndex="22">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn Width="120" FieldName="QuoteTransferComplete" VisibleIndex="23"></dx:GridViewDataTextColumn>
                        </Columns>
                    </dx:ASPxGridView>
                    <asp:ObjectDataSource runat="server" ID="ObjectDataSource1" SelectMethod="GetQuoteTransfers" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.QtQuoteTransferViewModel"></asp:ObjectDataSource>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
</asp:Content>
