<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="NewSalesAwardEdit.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.NewSalesAwardEdit" %>


<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Src="EntityNotesUserControl.ascx" TagPrefix="uc1" TagName="EntityNotesUserControl" %>

<%@ Register assembly="DevExpress.Web.ASPxSpellChecker.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxSpellChecker" tagprefix="dx" %>



<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script type="text/javascript">

        function pageLoad() {
            $(function () {
            });
        }

        function ShowHideNoteForm(action) {
            if (action == 'Show') {
                //$("#divNote").show(500);
                //$("#divFilterEntityNotesUserControl").hide(200);
            }
            else {
                //btnSetUser.DoClick();
           
                //$("#divNote").hide(200);
                //htmlEditor.SetHtml('');
                //$("#divFilterEntityNotesUserControl").show(500);
            } 
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



                    <dx:ASPxPageControl runat="server" ID="pageControl" Width="100%">
                        <ClientSideEvents TabClick="function(s, e) { ShowHideNoteForm('Hide'); }" />
                        <TabPages>
                            <dx:TabPage Text="Customer PO" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPurchaseOrderDate" runat="server" Text="Purchase Order Date:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="dePurchaseOrderDate" runat="server" DisplayFormatString="yyyy-MM-dd" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPoNumber" runat="server" Text="Customer Production PO #:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxPoNumber" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAltCustCommit" runat="server" Text="Alt Customer Commitment:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAltCustCommit" runat="server" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPoSellingPrice" runat="server" Text="PO Selling Price:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxPoSellingPrice" runat="server" DisplayFormatString="{0:C}" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPoSop" runat="server" Text="Purchase Order SOP:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="dePoSop" runat="server" DisplayFormatString="yyyy-MM-dd" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPoEop" runat="server" Text="Purchase Order EOP:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="dePoEop" runat="server" DisplayFormatString="yyyy-MM-dd" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblPoComments" runat="server" Text="Cust Prod PO Comments:" Width="180" />
                                                </td>
                                                <td colspan="3">
                                                    <dx:ASPxTextBox ID="tbxPoComments" runat="server" Width="600" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSavePO" runat="server" Text="Save" OnClick="btnSavePO_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkPO" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="Hard Tooling" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblHardToolingAmount" runat="server" Text="Hard Tooling Amount:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxHardToolingAmount" runat="server" Width="200" DisplayFormatString="{0:C}" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblHardToolingTrigger" runat="server" Text="Hard Tooling Trigger:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxHardToolingTrigger" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblHardToolingDescription" runat="server" Text="Hard Tooling Desc:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxHardToolingDescription" runat="server" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblHardToolingCAPEXID" runat="server" Text="Hard Tooling CAPEXID:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxHardToolingCAPEXID" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSaveHardTooling" runat="server" Text="Save" OnClick="btnSaveHardTooling_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkHardTooling" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="Tooling Amortization" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAmortizationAmount" runat="server" Text="Amortization Amount:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAmortizationAmount" runat="server" Width="200" DisplayFormatString="{0:C}" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAmortizationQuantity" runat="server" Text="Amortization Quantity:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAmortizationQuantity" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAmortizationToolingDescription" runat="server" Text="Amortization Tooling Desc:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAmortizationToolingDescription" runat="server" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAmortizationCAPEXID" runat="server" Text="Amortization CAPEXID:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAmortizationCAPEXID" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSaveAmortization" runat="server" Text="Save" OnClick="btnSaveAmortization_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkAmortization" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="Assembly Tester Tooling" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAssemblyTesterToolingAmount" runat="server" Text="Asm Tester Tooling Amount:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAssemblyTesterToolingAmount" runat="server" Width="200" DisplayFormatString="{0:C}" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAssemblyTesterToolingTrigger" runat="server" Text="Asm Tester Tooling Trigger:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAssemblyTesterToolingTrigger" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAssemblyTesterToolingDescription" runat="server" Text="Asm Tester Tooling Desc:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAssemblyTesterToolingDescription" runat="server" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblAssemblyTesterToolingCAPEXID" runat="server" Text="Asm Tester Tooling CAPEXID:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxAssemblyTesterToolingCAPEXID" runat="server" Width="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSaveAssemblyTester" runat="server" Text="Save" OnClick="btnSaveAssemblyTester_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkAssemblyTester" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                                    

                            <dx:TabPage Text="Base Part Attributes" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblBasePartFamily" runat="server" Text="Base Part Family:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxBasePartFamily" runat="server" Width="200" />
                                                </td>
                                                <td></td>
                                                <td></td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblProductLine" runat="server" Text="Product Line:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxProductLine" runat="server" DropDownStyle="DropDown" TextField="ProductLine1" DataSourceID="edsProductLine" 
                                                        ValueField="ProductLine1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsProductLine" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="ProductLines" Select="" OrderBy="it.ProductLine1" EnableInsert="true">
                                                    </asp:EntityDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireMarketSegment" runat="server" Text="Empire Market Segment:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxEmpireMarketSegment" runat="server" DropDownStyle="DropDown" TextField="EmpireMarketSegment1" DataSourceID="edsEmpireMarketSegment" 
                                                        ValueField="EmpireMarketSegment1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsEmpireMarketSegment" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="EmpireMarketSegments" Select="" OrderBy="it.EmpireMarketSegment1">
                                                    </asp:EntityDataSource>
                                                </td>
                                                <td></td>
                                                <td></td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireMarketSubsegment" runat="server" Text="Empire Market Subsegment:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxEmpireMarketSubsegment" runat="server" DropDownStyle="DropDown" TextField="EmpireMarketSubsegment1" DataSourceID="edsEmpireMarketSubsegment" 
                                                        ValueField="EmpireMarketSubsegment1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsEmpireMarketSubsegment" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="EmpireMarketSubsegments" Select="" OrderBy="it.EmpireMarketSubsegment1">
                                                    </asp:EntityDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireApplication" runat="server" Text="Empire Application:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxEmpireApplication" runat="server" Width="200" />
                                                </td>
                                                <td></td>
                                                <td></td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireSop" runat="server" Text="Empire SOP:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="deEmpireSop" runat="server" Width="200" />
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireEop" runat="server" Text="Empire EOP:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxDateEdit ID="deEmpireEop" runat="server" Width="200" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnShowNewEopNote" runat="server" RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                                        <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Show');}" />
                                                        <Image IconID="miscellaneous_comment_32x32"></Image>
                                                    </dx:ASPxButton>   
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnShowAllEopNotes" runat="server" RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                                        <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Hide');}" />
                                                        <Image IconID="comments_editcomment_32x32"></Image>
                                                    </dx:ASPxButton>   
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblBasePartAttributesComments" runat="server" Text="Comments" Width="180" />
                                                </td>
                                                <td colspan="4">
                                                    <dx:ASPxTextBox ID="tbxBasePartAttributesComments" runat="server" Width="100%" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSaveBasePartAttr" runat="server" Text="Save" OnClick="btnSaveBasePartAttr_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkBasePartAttr" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>

                            <dx:TabPage Text="Base Part Mnemonics" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblVehiclePlantMnemonic" runat="server" Text="Vehicle Plant Mnemonic:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxVehiclePlantMnemonic" runat="server" Width="200" ReadOnly="true" ClientEnabled="false" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblQtyPer" runat="server" Text="Qty Per:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxQtyPer" runat="server" Width="200" ReadOnly="true" ClientEnabled="false" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblTakeRate" runat="server" Text="Take Rate:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxTakeRate" runat="server" Width="200" ReadOnly="true" ClientEnabled="false" />
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblFamilyAllocation" runat="server" Text="Family Allocation:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxFamilyAllocation" runat="server" Width="200" ReadOnly="true" ClientEnabled="false" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblQuotedEau" runat="server" Text="Quoted EAU:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="tbxQuotedEau" runat="server" Width="200" ReadOnly="true" ClientEnabled="false" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnEditBasePartMnemonics" runat="server" Text="Edit Mnemonics" OnClick="btnEditBasePartMnemonics_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>

                            <dx:TabPage Text="Logistics" Visible="true">
                                <ContentCollection>
                                    <dx:ContentControl runat="server">
                                        <table class="tbl">
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblEmpireFacility" runat="server" Text="Empire Facility:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxEmpireFacility" runat="server" DropDownStyle="DropDownList" TextField="Code" DataSourceID="edsEmpireFacility" 
                                                        ValueField="Code" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                        <Columns>
                                                            <dx:ListBoxColumn Caption="Code" FieldName="Code" Name="Code" Width="80" />
                                                            <dx:ListBoxColumn Caption="Name" FieldName="Name" Name="Name" Width="160" />
                                                        </Columns>
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsEmpireFacility" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="EmpireFacilities" Select="" OrderBy="it.Code">
                                                    </asp:EntityDataSource>
                                                </td>
                                                <td>
                                                    <dx:ASPxLabel ID="lblFreightTerms" runat="server" Text="Freight Terms:" Width="190" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxFreightTerms" runat="server" DropDownStyle="DropDown" TextField="Code" DataSourceID="edsFreightTerms" 
                                                        ValueField="FreightTerms" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                        <Columns>
                                                            <dx:ListBoxColumn Caption="FreightTerms" FieldName="FreightTerms" Name="FreightTerms" Width="200" />
                                                        </Columns>
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsFreightTerms" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="FreightTerms" Select="" OrderBy="it.FreightTerms">
                                                    </asp:EntityDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxLabel ID="lblCustomerShipTos" runat="server" Text="Customer Ship Tos:" Width="180" />
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="cbxCustomerShipTos" runat="server" DropDownStyle="DropDownList" TextField="Code" DataSourceID="edsCustomerShipTos" 
                                                        ValueField="ShipToCode" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith" Width="200">
                                                        <Columns>
                                                            <dx:ListBoxColumn Caption="ShipToCode" FieldName="ShipToCode" Name="ShipToCode" Width="90" />
                                                            <dx:ListBoxColumn Caption="ShipToName" FieldName="ShipToName" Name="ShipToName" Width="200" />
                                                            <dx:ListBoxColumn Caption="CustomerCode" FieldName="CustomerCode" Name="CustomerCode" Width="100" />
                                                            <dx:ListBoxColumn Caption="CustomerName" FieldName="CustomerName" Name="CustomerName" Width="220" />
                                                        </Columns>
                                                    </dx:ASPxComboBox>
                                                    <asp:EntityDataSource ID="edsCustomerShipTos" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                        EntitySetName="CustomerShipTos" Select="" OrderBy="it.ShipToCode">
                                                    </asp:EntityDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnSaveLogistics" runat="server" Text="Save" OnClick="btnSaveLogistics_Click" />
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnCheckmarkLogistics" runat="server" RenderMode="Link" Enabled="true" Visible="false">
                                                        <Image IconID="actions_apply_32x32office2013"></Image>
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>


                        </TabPages>
                    </dx:ASPxPageControl>



                </ContentTemplate>
                    <Triggers>
                    
                    </Triggers>
                </asp:UpdatePanel>



            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>

</asp:Content>