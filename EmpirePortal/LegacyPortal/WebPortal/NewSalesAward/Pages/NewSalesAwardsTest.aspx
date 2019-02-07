<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="NewSalesAwardsTest.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.NewSalesAwardsTest" %>

<%@ Register Src="~/NewSalesAward/Pages/NSACustomerPOTabView.ascx" TagPrefix="uc1" TagName="NSACustomerPOTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSAHardToolingTabView.ascx" TagPrefix="uc1" TagName="NSAHardToolingTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSAToolingAmortizationTabView.ascx" TagPrefix="uc1" TagName="NSAToolingAmortizationTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSATesterToolingTabView.ascx" TagPrefix="uc1" TagName="NSATesterToolingTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSABasePartAttributesTabView.ascx" TagPrefix="uc1" TagName="NSABasePartAttributesTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSABasePartMnemonicsTabView.ascx" TagPrefix="uc1" TagName="NSABasePartMnemonicsTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/NSALogisticsTabView.ascx" TagPrefix="uc1" TagName="NSALogisticsTabView" %>

<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script type="text/javascript">

        function pageLoad() {
            $(function() {


                updateGridHeight();
            });
        }

        function updateGridHeight() {
            gvQuote.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            gvQuote.SetHeight(containerHeight - 130);
        }

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
                postponedCallbackRequired = false;
            }
        }

        function RefreshGrid(s, e) {

            //gvQuote.PerformCallback("ClearSort");
        }

        function ShowHideNoteForm(action) {
            if (action == 'Show') {
                $("#divNote").show(500);
                $("#divEntityNotesUserControl").hide(200);
            } else {
                btnSetUser.DoClick();

                $("#divNote").hide(200);
                htmlEditor.SetHtml('');
                $("#divEntityNotesUserControl").show(500);
            }
        }

        function OnInit(s, e) {
            //AdjustSize();
            //ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
            //AdjustSize();
            //});
        }

        function AdjustSize() {
            var height = document.documentElement.clientHeight;
            pcEdit.SetHeight(height - 30);
        }

    </script>

</asp:Content>


<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="New Sales Awards"></asp:Label>
</asp:Content>


<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

<dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true"></dx:ASPxLoadingPanel>


<dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
<ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
<PanelCollection>
<dx:PanelContent ID="pc1" runat="server">


<asp:UpdatePanel ID="updatePnl" runat="server">
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

    </tr>
</table>


<div id="divGridQuote" runat="server" style="margin-top: 5px;">
<dx:ASPxGridView ID="gvQuote" runat="server" ClientInstanceName="gvQuote" AutoGenerateColumns="False"
                 SettingsBehavior-AllowGroup="false" SettingsBehavior-AllowSort="true" Settings-ShowGroupPanel="false"
                 KeyFieldName="QuoteNumber" EnableRowsCache="True" Width="98%"
                 EnableCallBacks="True" OnCustomCallback="gvQuote_OnCustomCallback"
                 OnDataBound="gvQuote_DataBound"
                 AutoPostBack="False">
    <%--<ClientSideEvents RowDblClick="function(s, e) { btnHid.DoClick(); }" />--%>
    <%--<ClientSideEvents RowDblClick="function(s, e) { gvQuote.PerformCallback(); }" />--%>
    <ClientSideEvents RowDblClick="function(s, e)
                            {
                                pcEdit.PerformCallback();
                                pcEdit.ShowWindow();
                            }"/>
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
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="BasePart" Width="140" VisibleIndex="3">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="Salesperson" Width="150" VisibleIndex="4">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="ProgramManager" Width="150" VisibleIndex="5">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataDateColumn FieldName="AwardDate" Width="120" VisibleIndex="6">
            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataTextColumn FieldName="FormOfCommitment" Width="220" VisibleIndex="7">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataDateColumn FieldName="QuoteTrasferMeetingDT" Width="190" VisibleIndex="8">
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataDateColumn FieldName="SalesForecastDT" Width="140" VisibleIndex="9">
            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataTextColumn FieldName="BasePartCustomer" Width="150" VisibleIndex="10">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="QuoteReason" Width="180" VisibleIndex="11">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="ReplacingBasePart" Width="160" VisibleIndex="12">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="CustomerPart" Width="160" VisibleIndex="13">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="VehiclePlantMnemonic" Width="230" VisibleIndex="14">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="Family" Width="120" VisibleIndex="15">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="Program" Width="120" VisibleIndex="16">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="Vehicle" Width="140" VisibleIndex="17">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="EmpireApplication" Width="310" VisibleIndex="18">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="BasePartFamily" Width="140" VisibleIndex="19">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="EmpireMarketSegment" Width="180" VisibleIndex="20">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="EmpireMarketSubsegment" Width="210" VisibleIndex="21">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="ProductLine" Width="150" VisibleIndex="22">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataDateColumn FieldName="EmpireSOP" Width="120" VisibleIndex="23">
            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataDateColumn FieldName="EmpireEOP" Width="120" VisibleIndex="24">
            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataTextColumn FieldName="EmpireEOPNote" Width="300" VisibleIndex="25">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="BasePart_Comments" Width="300" VisibleIndex="26">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="SourcePlantRegion" Width="160" VisibleIndex="27">
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
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="MinimumOrderQuantity" Width="180" VisibleIndex="34">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="QuotedPrice" Width="120" VisibleIndex="35">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="QuotedMaterialCost" Width="160" VisibleIndex="36">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="QuotedSales" Width="120" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="37">
            <PropertiesTextEdit DisplayFormatString="{0:C}">
            </PropertiesTextEdit>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="QuotedLTA" Width="180" VisibleIndex="38">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataDateColumn FieldName="PurchaseOrderDate" Width="160" VisibleIndex="39">
            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"/>
        </dx:GridViewDataDateColumn>
        <dx:GridViewDataTextColumn FieldName="CustomerProductionPurchaseOrderNumber" Width="310" VisibleIndex="40">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AlternativeCustomerCommitment" Width="250" VisibleIndex="41">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="PurchaseOrderSellingPrice" Width="230" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="42">
            <PropertiesTextEdit DisplayFormatString="{0:C}">
            </PropertiesTextEdit>
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
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AmortizationAmount" Width="160" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="47">
            <PropertiesTextEdit DisplayFormatString="{0:C}">
            </PropertiesTextEdit>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AmortizationQuantity" Width="160" VisibleIndex="48">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AmortizationPrice" Width="140" VisibleIndex="49">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AmortizationToolingDescription" Width="250" VisibleIndex="50">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AmortizationCAPEXID" Width="170" VisibleIndex="51">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="HardToolingAmount" Width="160" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="52">
            <PropertiesTextEdit DisplayFormatString="{0:C}">
            </PropertiesTextEdit>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="HardToolingTrigger" Width="160" VisibleIndex="53">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="HardToolingDescription" Width="250" VisibleIndex="54">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="HardToolingCAPEXID" Width="170" VisibleIndex="55">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingAmount" Width="240" PropertiesTextEdit-DisplayFormatString="{0:C}" VisibleIndex="56">
            <PropertiesTextEdit DisplayFormatString="{0:C}">
            </PropertiesTextEdit>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingTrigger" Width="230" VisibleIndex="57">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingDescription" Width="260" VisibleIndex="58">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingCAPEXID" Width="240" VisibleIndex="59">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="EmpireFacility" Width="140" VisibleIndex="60">
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="FreightTerms" Width="140" VisibleIndex="61">
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
        updateGridHeight();
    });
</script>

<asp:ObjectDataSource ID="odsQuote" runat="server" SelectMethod="GetAwardedQuotes" TypeName="WebPortal.NewSalesAward.PageViewModels.NewSalesAwardsViewModel"
                      DataObjectTypeName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuotes_Result">
</asp:ObjectDataSource>
</div>


</div>


<div>
    <dx:ASPxPopupControl ID="pcEdit" runat="server" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                         PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="TopSides" ClientInstanceName="pcEdit"
                         ScrollBars="Vertical" HeaderText="New Sales Award" AllowDragging="True"
                         PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true"
                         ResizingMode="Postponed"
                         AutoPostBack="False" EnableCallbackAnimation="True" EnableCallBacks="True" OnWindowCallback="pcEdit_OnWindowCallback">
        <ClientSideEvents Init="OnInit"/>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <div style="margin-left: 20px;">
                    <dx:ASPxLabel ID="lblBasePart" runat="server" Text="Base Part" Font-Size="14" ForeColor="#007bf7"/>
                </div>


                <div style="width: 1500px;">

                    <div style="float: left; padding: 10px 20px 10px 20px;">

                        <dx:ASPxPageControl runat="server" ID="NSAEditPageControl" Width="100%" ActiveTabIndex="0">

                            <TabPages>
                                <dx:TabPage Text="Customer PO" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSACustomerPOTabView runat="server" id="NSACustomerPOTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Hard Tooling" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSAHardToolingTabView runat="server" id="NSAHardToolingTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Tooling Amortization" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSAToolingAmortizationTabView runat="server" id="NSAToolingAmortizationTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Assembly Tester Tooling" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSATesterToolingTabView runat="server" id="NSATesterToolingTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Base Part Attributes" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSABasePartAttributesTabView runat="server" id="NSABasePartAttributesTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Base Part Mnemonics" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSABasePartMnemonicsTabView runat="server" id="NSABasePartMnemonicsTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Logistics" Visible="True">
                                    <ContentCollection>
                                        <dx:ContentControl runat="server">
                                            <uc1:NSALogisticsTabView runat="server" id="NSALogisticsTabView"/>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                            </TabPages>
                        </dx:ASPxPageControl>
                    </div>


                    <div style="float: left; margin-top: 20px;">
                        <dx:ASPxButton ID="btnSaveAll" runat="server" Text="Save All Tabs"/>
                    </div>

                </div>


                <div id="divNote" style="clear: left; display: none; margin-bottom: 20px; margin-left: 40px;">
                    <table>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblNoteTitle" runat="server" Text="Notes / Comments / Screenshots" ForeColor="#007bf7"/>
                            </td>
                        </tr>
                        <tr>


                            <td>
                                <dx:ASPxButton ID="btnNoteOk" runat="server" Text="Ok"/>
                                <br/>
                                <br/>
                                <dx:ASPxButton ID="btnNoteCancel" runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Hide');}"/>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </div>


                <div style="clear: left; display: none;">
                    <dx:ASPxButton ID="btnSetUser" runat="server" ClientInstanceName="btnSetUser" AutoPostBack="false" UseSubmitBehavior="false"></dx:ASPxButton>
                </div>


            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</div>


</ContentTemplate>
</asp:UpdatePanel>
</dx:PanelContent>
</PanelCollection>
</dx:ASPxCallbackPanel>


</asp:Content>