<%@ Page Title="New Sales Award" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewSalesAwardTest2.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.NewSalesAwardTest2" %>
<%@ Register Src="~/NewSalesAward/Pages/NSAEditPopupContents.ascx" TagPrefix="uc1" TagName="NSAEditPopupContents" %>


<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script src="../../Scripts/jquery-3.3.1.js"></script>
    <script type="text/javascript">

        $(window).ready(function() {
            DoResizeAll();
        });

        $(window).resize(function() {
            DoResizeAll();
        });

        function OnQuoteGridEndCallback(s) {
            DoResizeAll();
        }

        function DoResizeAll (s, e) {
            console.log("updateGridHeight");
            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();
            gvQuote.SetHeight(containerHeight - 130);

            //  Show the grid's container.
            $('#quoteGridViewContainer').css("visibility", "");
        }

        function OnGridRowDoubleClick(s, e) {
            gvQuote.GetRowValues(gvQuote.GetFocusedRowIndex(), 'BasePart', OnGetRowValues);
        }

        function OnGetRowValues(value) {
            if (value == null) {
                console.log("show fix quote");
                pcFixQuote.PerformCallback();
                pcFixQuote.ShowWindow();
            }
            else {
                console.log("show edit");
                pcEdit.PerformCallback("edit");
                pcEdit.ShowWindow();
            }
        }

        function OnNewSalesAwardClick(s, e) {
            pcEdit.PerformCallback("new");
            pcEdit.ShowWindow();
            postponedCallbackRequired = true;
            DoResizeAll();
        }

        function FixAwardedQuoteButtonClicked(s, e) {
            pcFixQuote.PerformCallback("fixQuoteClicked");
        }
    </script>

</asp:Content>


<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="New Sales Awards"></asp:Label>
</asp:Content>


<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true"></dx:ASPxLoadingPanel>
    <script>
        var postponedCallbackRequired = false;

        function OnComboBoxIndexChanged(s, e) {
            if (CallbackPanel.InCallback())
                postponedCallbackRequired = true;
            else
                CallbackPanel.PerformCallback();
        }

        function OnEndCallback(s, e) {
            if (postponedCallbackRequired) {
                CallbackPanel.PerformCallback();
            }
        }
    </script>
    <dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
        <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent ID="pc1" runat="server">
                <ContentTemplate>
                    <div id="divMain" runat="server" style="border: 0px solid black; margin-bottom: 0px;">
                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblMode" runat="server" Text="Mode:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxMode" runat="server" ValueType="System.String" Width="210" DropDownRows="10"
                                                     OnSelectedIndexChanged="cbxMode_SelectedIndexChanged" AutoPostBack="true">
                                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                                                lp.Show();
                                                             }"/>
                                    </dx:ASPxComboBox>
                                </td>
                                <td style="padding-left: 20px;">
                                    <dx:ASPxButton ID="btnNewSalesAward" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false"
                                        Text="Add New Quote Award" Width="100%" OnClick="btnNewSalesAward_Click">
                                    </dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnQuoteTransfer" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false" 
                                        Text="Quote Transfer" Width="100%" OnClick="btnQuoteTransfer_Click">
                                    </dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnCustomerCommitment" runat="server" AutoPostBack="false" CausesValidation="false" UseSubmitBehavior="false"
                                        Text="Cust Commitment" Width="100%" OnClick="btnCustomerCommitment_Click" Visible="false">
                                    </dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnAltCustomerCommitment" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false"
                                        Text="Alt Cust Commitment" Width="100%" OnClick="btnAltCustomerCommitment_Click" Visible="false">
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                        <div id="quoteGridViewContainer" style="margin-top: 5px; visibility: hidden;">
                            <dx:ASPxGridView ID="gvQuote" runat="server" ClientInstanceName="gvQuote" AutoGenerateColumns="False"
                                             SettingsBehavior-AllowGroup="false" SettingsBehavior-AllowSort="true" Settings-ShowGroupPanel="false"
                                             KeyFieldName="QuoteNumber" EnableRowsCache="True" Width="98%"
                                             EnableCallBacks="True"
                                             OnDataBound="gvQuote_DataBound"
                                             AutoPostBack="False">
                                <ClientSideEvents
                                    RowDblClick="OnGridRowDoubleClick"
                                    EndCallback="OnQuoteGridEndCallback"
                                    />
                                <Styles>
                                    <Cell>
                                        <Paddings PaddingTop="1px" PaddingBottom="1px"/>
                                    </Cell>
                                </Styles>

                                <Columns>
                                    <dx:GridViewCommandColumn Caption=" " ShowNewButtonInHeader="false" ShowEditButton="true" Width="130" VisibleIndex="0" FixedStyle="Left" Visible="false">
                                    </dx:GridViewCommandColumn>

                                    <dx:GridViewDataTextColumn FieldName="" ReadOnly="True" Width="116" VisibleIndex="1" FixedStyle="Left" Visible="false">
                                        <DataItemTemplate>
                                            <dx:ASPxButton ID="btnEditMnemonic" runat="server" Text="Edit">
                                            </dx:ASPxButton>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="QuoteNumber" Width="120" VisibleIndex="2">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="BasePart" Width="140" VisibleIndex="3">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ExcelSpreadsheetBasePart" Width="190" VisibleIndex="3" CellStyle-ForeColor="Red">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Salesperson" Width="150" VisibleIndex="4">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ProgramManager" Width="150" VisibleIndex="5">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="AwardDate" Width="120" VisibleIndex="6">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="FormOfCommitment" Width="220" VisibleIndex="7">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="QuoteTrasferMeetingDT" Width="190" VisibleIndex="8">
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataDateColumn FieldName="SalesForecastDT" Width="140" VisibleIndex="9">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="BasePartCustomer" Width="150" VisibleIndex="10">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuoteReason" Width="180" VisibleIndex="11">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ReplacingBasePart" Width="160" VisibleIndex="12">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="CustomerPart" Width="160" VisibleIndex="13">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="VehiclePlantMnemonic" Width="230" VisibleIndex="14">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Family" Width="120" VisibleIndex="15">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Program" Width="120" VisibleIndex="16">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Vehicle" Width="140" VisibleIndex="17">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="EmpireApplication" Width="310" VisibleIndex="18">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="BasePartFamily" Width="140" VisibleIndex="19">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="EmpireMarketSegment" Width="180" VisibleIndex="20">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="EmpireMarketSubsegment" Width="210" VisibleIndex="21">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ProductLine" Width="150" VisibleIndex="22">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="EmpireSOP" Width="120" VisibleIndex="23">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataDateColumn FieldName="EmpireEOP" Width="120" VisibleIndex="24">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="EmpireEOPNote" Width="300" VisibleIndex="25">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="BasePart_Comments" Width="300" VisibleIndex="26">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="SourcePlantRegion" Width="160" VisibleIndex="27">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QtyPer" Width="110" VisibleIndex="28">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="TakeRate" Width="110" VisibleIndex="29">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FamilyAllocation" Width="130" VisibleIndex="30">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="CSMEAU" Width="120" VisibleIndex="31">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="QuoteDate" Width="120" VisibleIndex="32">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuotedEAU" Width="120" VisibleIndex="33">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="MinimumOrderQuantity" Width="180" VisibleIndex="34">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuotedPrice" Width="120" VisibleIndex="35">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuotedMaterialCost" Width="160" VisibleIndex="36">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuotedSales" Width="120" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="37">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="QuotedLTA" Width="180" VisibleIndex="38">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="PurchaseOrderDate" Width="160" VisibleIndex="39">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="CustomerProductionPurchaseOrderNumber" Width="310" VisibleIndex="40">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AlternativeCustomerCommitment" Width="250" VisibleIndex="41">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PurchaseOrderSellingPrice" Width="230" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="42">
                                        <PropertiesTextEdit DisplayFormatString="{0:C}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="PurchaseOrderSOP" Width="150" VisibleIndex="43">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataDateColumn FieldName="PurchaseOrderEOP" Width="150" VisibleIndex="44">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="PurchaseOrderPriceVariace" Width="210" VisibleIndex="45">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="CustomerProductionPurchaseOrderComments" Width="300" VisibleIndex="46">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AmortizationAmount" Width="160" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="47">
                                        <PropertiesTextEdit DisplayFormatString="{0:C}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AmortizationQuantity" Width="160" VisibleIndex="48">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AmortizationPrice" Width="140" VisibleIndex="49">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AmortizationToolingDescription" Width="250" VisibleIndex="50">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AmortizationCAPEXID" Width="170" VisibleIndex="51">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="HardToolingAmount" Width="160" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="52">
                                        <PropertiesTextEdit DisplayFormatString="{0:C}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="HardToolingTrigger" Width="160" VisibleIndex="53">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="HardToolingDescription" Width="250" VisibleIndex="54">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="HardToolingCAPEXID" Width="170" VisibleIndex="55">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingAmount" Width="240" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="56">
                                        <PropertiesTextEdit DisplayFormatString="{0:C}"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingTrigger" Width="230" VisibleIndex="57">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingDescription" Width="260" VisibleIndex="58">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingCAPEXID" Width="240" VisibleIndex="59">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="EmpireFacility" Width="140" VisibleIndex="60">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FreightTerms" Width="140" VisibleIndex="61">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataComboBoxColumn FieldName="CustomerShipTos" VisibleIndex="62" Width="160">
                                        <PropertiesComboBox DropDownStyle="DropDown" TextField="Destination" ValueField="Destination" TextFormatString="{0}" AllowNull="true">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="Destination" Width="130"/>
                                                <dx:ListBoxColumn FieldName="DestinationName" Width="150"/>
                                                <dx:ListBoxColumn FieldName="Customer" Width="130"/>
                                                <dx:ListBoxColumn FieldName="CustomerName" Width="220"/>
                                            </Columns>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>

                                    <dx:GridViewDataTextColumn FieldName="Comments" Width="350" VisibleIndex="63">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewCommandColumn ShowClearFilterButton="true" ShowApplyFilterButton="true" VisibleIndex="64"/>
                                </Columns>

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
                            </dx:ASPxGridView>
                            <script type="text/javascript">
                                ASPxClientControl.GetControlCollection().BrowserWindowResized.AddHandler(function(s, e) {
                                    DoResizeAll();
                                });
                            </script>

                            <asp:ObjectDataSource ID="odsQuote" runat="server" SelectMethod="GetAwardedQuotes" TypeName="WebPortal.NewSalesAward.PageViewModels.NewSalesAwardsViewModel"
                                                  DataObjectTypeName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuotes_Result">
                            </asp:ObjectDataSource>
                        </div>
                    </div>
                    <div>
                        <dx:ASPxPopupControl
                            ID="pcEdit" runat="server" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="TopSides" ClientInstanceName="pcEdit"
                            HeaderText="" AllowDragging="True"
                            PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true"
                            AutoPostBack="False" EnableCallbackAnimation="True" EnableCallBacks="True" OnWindowCallback="pcEdit_OnWindowCallback"
                            >
                            <ClientSideEvents Shown="DoResizeAll">
                            </ClientSideEvents>
                            <ContentCollection>
                                <dx:PopupControlContentControl runat="server">
                                    <uc1:NSAEditPopupContents runat="server" ID="NSAEditPopupContents"/>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </div>
                    <div>
                        <dx:ASPxPopupControl ID="pcFixQuote" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcFixQuote"
                            HeaderText="Fix Awarded Quote" AllowDragging="True" PopupAnimationType="Fade" EnableViewState="False" 
                            AutoUpdatePosition="true" OnWindowCallback="pcFixQuote_WindowCallback">
                            <ContentCollection>
                                <dx:PopupControlContentControl runat="server">
                                    <div style="padding: 10px 20px 20px 20px;">
                                        
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblOldQuoteNumber" runat="server" Text="Old Quote Number:" Width="140" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxOldQuoteNumber" runat="server" ReadOnly="true" Width="298" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblNewQuoteNumber" runat="server" Text="New Quote Number:" Width="140" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" ClientInstanceName="cbxQuoteNumber" EnableCallbackMode="true" CallbackPageSize="10" 
                                                        ValidateRequestMode="Disabled" ValueType="System.String" ValueField="QuoteNumber" ValidationSettings-CausesValidation="false"
                                                        OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                                        TextFormatString="{0}  {1}  {2}"
                                                        Width="298px" DropDownStyle="DropDown" TabIndex="0">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="QuoteNumber" />
                                                            <dx:ListBoxColumn FieldName="EEIPartNumber" />
                                                            <dx:ListBoxColumn FieldName="Program" />
                                                        </Columns>
                                                        <ValidationSettings CausesValidation="false"></ValidationSettings>
                                                    </dx:ASPxComboBox>

                                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnFixAwardedQuote" runat="server" ClientInstanceName="btnFixAwardedQuote" Text="Save" AutoPostBack="false" UseSubmitBehavior="false">
                                                        <ClientSideEvents Click="FixAwardedQuoteButtonClicked" /> 
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>

                                    </div>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </div>
                </ContentTemplate>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>


</asp:Content>