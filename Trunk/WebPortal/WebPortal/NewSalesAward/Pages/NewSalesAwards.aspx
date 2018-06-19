<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="NewSalesAwards.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.NewSalesAwards" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script type="text/javascript">

        function pageLoad() {
            $(function () {
                updateGridHeight();
            });
        }    

        function updateCheckBoxState(s, e) {
            //var checkState = s.GetCheckState();
            //var checked = s.GetChecked();
            //var checkBoxIDParts = s.name.split("_");
            //var checkBoxID = checkBoxIDParts[checkBoxIDParts.length - 1];
            //var checkedStateSpan = document.getElementById(checkBoxID + "CheckState");
            //var checkedSpan = document.getElementById(checkBoxID + "Checked");
            //checkedStateSpan.innerHTML = "CheckState = " + checkState;
            //checkedSpan.innerHTML = "Checked = " + checked;
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

            gvQuote.PerformCallback("ClearSort");
        }

    </script>

</asp:Content>



<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="New Sales Awards"></asp:Label>
</asp:Content>



<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true">
        </dx:ASPxLoadingPanel>

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
                                 }" />
                            </dx:ASPxComboBox>
                        </td>
                        <td style="padding-left: 20px;">
                            <dx:ASPxButton ID="btnNewSalesAward" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false"
                                Text="New Quote Award" Width="100%" OnClick="btnNewSalesAward_Click">
                            </dx:ASPxButton>
                        </td>
                        <td>
                            <dx:ASPxButton ID="btnQuoteTransfer" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false" 
                                Text="Quote Transfer" Width="100%" OnClick="btnQuoteTransfer_Click">
                            </dx:ASPxButton>
                        </td>
                        <td>
                            <dx:ASPxButton ID="btnCustomerCommitment" runat="server" AutoPostBack="false" CausesValidation="false" UseSubmitBehavior="false"
                                Text="Cust Commitment" Width="100%" OnClick="btnCustomerCommitment_Click">
                            </dx:ASPxButton>
                        </td>
                        <td>
                            <dx:ASPxButton ID="btnAltCustomerCommitment" runat="server" AutoPostBack="true" CausesValidation="false" UseSubmitBehavior="false"
                                Text="Alt Cust Commitment" Width="100%" OnClick="btnAltCustomerCommitment_Click">
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>



                <div id="divGridQuote" runat="server" style="margin-top: 5px;">
                    <dx:ASPxGridView ID="gvQuote" runat="server" ClientInstanceName="gvQuote" AutoGenerateColumns="False" DataSourceID="odsQuote" 
                        SettingsBehavior-AllowGroup="false" SettingsBehavior-AllowSort="true" Settings-ShowGroupPanel="false" OnRowUpdating="gvQuote_RowUpdating"
                        KeyFieldName="QuoteNumber" SettingsEditing-Mode="Inline" EnableRowsCache="False" Width="98%" 
                        OnCustomCallback="gvQuote_CustomCallback" OnCellEditorInitialize="gvQuote_CellEditorInitialize" EnableCallBacks="false">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="1px" PaddingBottom="1px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewCommandColumn Caption=" " ShowNewButtonInHeader="false" ShowEditButton="true" Width="130" VisibleIndex="0" FixedStyle="Left" Visible="false">
                            </dx:GridViewCommandColumn>

                            <dx:GridViewDataTextColumn FieldName="" ReadOnly="True" Width="116" VisibleIndex="1" FixedStyle="Left" Visible="false">
                                <DataItemTemplate>
                                    <dx:ASPxButton ID="btnEditMnemonic" runat="server" Text="Edit" OnClick="btnEditMnemonic_Click">
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
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="FormOfCommitment" Width="220" VisibleIndex="7">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="QuoteTrasferMeetingDT" Width="190" VisibleIndex="8">
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="SalesForecastDT" Width="140" VisibleIndex="9">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
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
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="EmpireEOP" Width="120" VisibleIndex="24">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
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
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="QuotedEAU" Width="120" VisibleIndex="33">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="MinimumOrderQuantity" Width="180" VisibleIndex="34">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="QuotedPrice" Width="120" VisibleIndex="35">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="QuotedMaterialCost" Width="160" VisibleIndex="36">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="QuotedSales" Width="120" PropertiesTextEdit-DisplayFormatString ="{0:C}" VisibleIndex="37">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="QuotedLTA" Width="180" VisibleIndex="38">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="PurchaseOrderDate" Width="160" VisibleIndex="39">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="CustomerProductionPurchaseOrderNumber" Width="310" VisibleIndex="40">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AlternativeCustomerCommitment" Width="250" VisibleIndex="41">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="PurchaseOrderSellingPrice" Width="230" PropertiesTextEdit-DisplayFormatString ="{0:C}" VisibleIndex="42">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="PurchaseOrderSOP" Width="150" VisibleIndex="43">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="PurchaseOrderEOP" Width="150" VisibleIndex="44">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="PurchaseOrderPriceVariace" Width="210" VisibleIndex="45">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AmortizationAmount" Width="160" PropertiesTextEdit-DisplayFormatString ="{0:C}" VisibleIndex="46">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AmortizationQuantity" Width="160" VisibleIndex="47">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AmortizationPrice" Width="140" VisibleIndex="48">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AmortizationToolingDescription" Width="250" VisibleIndex="49">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AmortizationCAPEXID" Width="170" VisibleIndex="50">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="HardToolingAmount" Width="160" PropertiesTextEdit-DisplayFormatString ="{0:C}" VisibleIndex="51">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="HardToolingTrigger" Width="160" VisibleIndex="52">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="HardToolingDescription" Width="250" VisibleIndex="53">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="HardToolingCAPEXID" Width="170" VisibleIndex="54">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingAmount" Width="240" PropertiesTextEdit-DisplayFormatString ="{0:C}" VisibleIndex="55">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingTrigger" Width="230" VisibleIndex="56">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingDescription" Width="260" VisibleIndex="57">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="AssemblyTesterToolingCAPEXID" Width="240" VisibleIndex="58">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="EmpireFacility" Width="140" VisibleIndex="59">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="FreightTerms" Width="140" VisibleIndex="60">
                            </dx:GridViewDataTextColumn>


                            <dx:GridViewDataComboBoxColumn FieldName="CustomerShipTos" VisibleIndex="61" Width="160">
                                <PropertiesComboBox DropDownStyle="DropDown" TextField="Destination" ValueField="Destination" TextFormatString="{0}" AllowNull="true">
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="Destination" Width="130"/>
                                        <dx:ListBoxColumn FieldName="DestinationName" Width="150"/>
                                        <dx:ListBoxColumn FieldName="Customer" Width="130"/>
                                        <dx:ListBoxColumn FieldName="CustomerName" Width="220" />
                                    </Columns>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>


                            <dx:GridViewDataTextColumn FieldName="Comments" Width="350" VisibleIndex="62">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        
                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <Settings HorizontalScrollBarMode="Auto" />
                        <SettingsBehavior AllowSelectByRowClick="false" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsBehavior AutoExpandAllGroups="true" />
                        <SettingsSearchPanel Visible="false" ColumnNames="QuoteNumber; BasePart" />
                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="DataAware" />
                        <SettingsPager PageSize="30"></SettingsPager>
                        <SettingsEditing Mode="Inline"></SettingsEditing>
                    </dx:ASPxGridView>
                    <script type="text/javascript">
                        ASPxClientControl.GetControlCollection().BrowserWindowResized.AddHandler(function (s, e) {
                            updateGridHeight();
                        });
                    </script>
                    
                    <asp:ObjectDataSource ID="odsQuote" runat="server" SelectMethod="GetAwardedQuotes" TypeName="WebPortal.NewSalesAward.PageViewModels.NewSalesAwardsViewModel" 
                        UpdateMethod="" DataObjectTypeName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuotes_Result">   
                    </asp:ObjectDataSource>
                </div>

            
            </div>



            <div>
                <dx:ASPxPopupControl ID="pcError" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcError"
                    HeaderText="Error Message" AllowDragging="True" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">
                            <div style="padding: 10px 20px 20px 20px;">
                                <dx:ASPxLabel ID="lblError" runat="server" Text=""></dx:ASPxLabel>
                            </div>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
            </div>



            <div>
                <dx:ASPxPopupControl ID="pcFileUpload" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="false" Modal="True"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcFileUpload"
                    HeaderText="File Management" AllowDragging="false" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">
                            <div style="padding: 10px 20px 20px 20px;">

                                <table class="tbl">
                                    <tr>
                                        <td>
                                            <dx:ASPxTextBox ID="tbxDocName" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black" Width="240"></dx:ASPxTextBox>
                                        </td>
                                        <td>
                                            <asp:Button ID="btnDocGet" runat="server" Text="Get" OnClick="btnDocGet_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnDocDelete" runat="server" Text="Delete" OnClick="btnDocDelete_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:FileUpload id="FileUploadControl" runat="server" BackColor="White" /><br />
                                            <asp:Button ID="btnUpload" runat="server" Text="Upload" UseSubmitBehavior="false" OnClick="btnUpload_Click" />
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            <dx:ASPxLabel ID="lblUploadStatus" runat="server" Text=""></dx:ASPxLabel>
                                        </td>
                                    </tr>
                                </table>

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