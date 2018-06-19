<%@ Page Title="QuoteTransfer" Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="QuoteTransfer.aspx.cs" Inherits="WebPortal.QuoteLogIntegration.Pages.QuoteTransfer" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script type="text/javascript">

        function pageLoad() {
            $(function () {
            });
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
    </script>

</asp:Content>



<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Quote Transfer Form"></asp:Label>
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

                <div>
                    <dx:ASPxButton ID="btnClose" runat="server" Text="" RenderMode="Link" ToolTip="Close" OnClick="btnClose_Click">
                        <Image IconID="actions_close_32x32gray" />
                    </dx:ASPxButton>
                </div>

                <div id="divQuote" class="Section">
                    <table class="tbl">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblQuoteNumber" runat="server" Text="Quote #:"></dx:ASPxLabel>
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxQuoteNumber" runat="server" ReadOnly="false"></dx:ASPxTextBox>
                            </td>
                            <td>
                                <dx:ASPxButton ID="btnGetQuote" runat="server" Text="Go" OnClick="btnGetQuote_Click"></dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </div>

                <dx:ASPxRoundPanel ID="rPnl" runat="server" BackColor="#ffffff" HeaderText="" Width="98%">
                <PanelCollection>
                    <dx:PanelContent ID="pc2" runat="server">


                        <div id="divQuoteDetail" class="Section">
                            <table class="tbl">
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblCustomer" runat="server" Text="Customer Name:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxCustomer" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblDate" runat="server" Text="Date:"></dx:ASPxLabel>
                                    </td>
                                     <td>
                                        <dx:ASPxTextBox ID="tbxDate" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblEmpirePart" runat="server" Text="Empire Part Number:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxEmpirePartNumber" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                     <td>
                                        <dx:ASPxLabel ID="lblSop" runat="server" Text="SOP:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxSop" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblCustomerPartNumber" runat="server" Text="Customer Part Number:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxCustomerPartNumber" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                     <td>
                                        <dx:ASPxLabel ID="lblEop" runat="server" Text="EOP:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxEop" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblProgram" runat="server" Text="Program:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxProgram" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblFinishedGoodHtsCode" runat="server" Text="Finished Good HTS Code:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxFinishedGoodHtsCode" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblApplication" runat="server" Text="Application:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxApplication" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblFinancialEau" runat="server" Text="Financial EAU:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxFinancialEau" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblCapacityEau" runat="server" Text="Capacity EAU:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxCapacityEau" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSalesman" runat="server" Text="Salesman:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxSalesman" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblEngineerAssignedToQuote" runat="server" Text="Engineer Assigned to Quote:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxEngineerAssignedToQuote" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>



                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblCustomerContactsHeader" runat="server" Text="I. Customer Contacts" Font-Size="18"></dx:ASPxLabel>
                        </div>

                        
                        <div class="Section">
                            <dx:ASPxGridView ID="dgCustomerContacts" runat="server" ClientInstanceName="gvCustomerContacts" AutoGenerateColumns="false" 
                                DataSourceID="odsCustomerContacts" KeyFieldName="RowID">
                                <Styles>
                                    <Cell>
                                        <Paddings PaddingTop="2px" PaddingBottom="2px" />
                                    </Cell>
                                </Styles>
                                <Columns>
                                    <dx:GridViewCommandColumn Caption=" " ShowNewButtonInHeader="false" ShowEditButton="true" ShowDeleteButton="false" VisibleIndex="0" Width="130" FixedStyle="Left" />

                                    <dx:GridViewDataTextColumn Caption="RowID" FieldName="RowID" Name="RowID" VisibleIndex="1" Width="80" Visible="false" />
                                    <dx:GridViewDataTextColumn Caption="Title" FieldName="Title" Name="Title" VisibleIndex="2" Width="120" Visible="true" ReadOnly="true" />
                                    <dx:GridViewDataTextColumn Caption="FirstName" FieldName="FirstName" Name="FirstName" VisibleIndex="3" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="LastName" FieldName="LastName" Name="LastName" VisibleIndex="4" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="PhoneNumber" FieldName="PhoneNumber" Name="PhoneNumber" VisibleIndex="5" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="FaxNumber" FieldName="FaxNumber" Name="FaxNumber" VisibleIndex="6" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="EmailAddress" FieldName="EmailAddress" Name="EmailAddress" VisibleIndex="7" Width="140" Visible="true" />
                                </Columns>
                                <SettingsEditing Mode="Inline"></SettingsEditing>
                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                </TotalSummary>
                            </dx:ASPxGridView>

                            <asp:ObjectDataSource ID="odsCustomerContacts" runat="server" SelectMethod="GetCustomerContacts" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.QtCustomerContactsViewModel"
                                DataObjectTypeName="WebPortal.QuoteLogIntegration.Models.usp_QL_QuoteTransfer_GetCustomerContacts_Result" 
                                UpdateMethod="CustomerContactsUpdate">
                                <SelectParameters>
                                    <asp:Parameter Name="quote" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </div>



                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblCommercialHeader" runat="server" Text="II. Commercial" Font-Size="18"></dx:ASPxLabel>
                        </div>


                        <div id="divCommercial" class="Section">
                            <table class="tbl">
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSalePrice" runat="server" Text="Sales Price"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxSalesPrice" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblPrototypePrice" runat="server" Text="Prototype Price"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxPrototypePrice" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblYear1" runat="server" Text="Year 2"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxYear1" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                     <td>
                                        <dx:ASPxLabel ID="lblMoq" runat="server" Text="MOQ"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxMoq" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblYear2" runat="server" Text="Year 3"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxYear2" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblMaterial" runat="server" Text="Material"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxMaterial" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblYear3" runat="server" Text="Year 4"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxYear3" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblLabor" runat="server" Text="Labor"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxLabor" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblYear4" runat="server" Text="Year 5"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxYear4" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>


                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblDocumentationHeader" runat="server" Text="III. Documentation" Font-Size="18"></dx:ASPxLabel>
                        </div>



                        


                        <div id="divDocumentation" class="Section">
                           

                            <table class="tbl">
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblDocDesc1" runat="server" Text="Has the PO been confirmed to the quote?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxPoConfirmed" runat="server"></dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnSaveDocDesc1Answer" runat="server" Text="Save" OnClick="btnSaveDocDesc1Answer_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblDocDesc2" runat="server" Text="Is there an approved copy of the print?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxDocName2" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocSave2" runat="server" Text="Upload" OnClick="btnDocSave2_Click"></dx:ASPxButton>
                                    </td>
                                     <td>
                                        <dx:ASPxButton ID="btnDocDelete2" runat="server" Text="Delete" OnClick="btnDocDelete2_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocGet2" runat="server" Text="Get" OnClick="btnDocGet2_Click"></dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblDocDesc3" runat="server" Text="Has a copy of the quote BOM/Labor  been provided?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxDocName3" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocSave3" runat="server" Text="Upload" OnClick="btnDocSave3_Click"></dx:ASPxButton>
                                    </td>
                                     <td>
                                        <dx:ASPxButton ID="btnDocDelete3" runat="server" Text="Delete" OnClick="btnDocDelete3_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocGet3" runat="server" Text="Get" OnClick="btnDocGet3_Click"></dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblDocDesc4" runat="server" Text="Has a copy of the Customer Quote been provided?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxDocName4" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocSave4" runat="server" Text="Upload" OnClick="btnDocSave4_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocDelete4" runat="server" Text="Delete" OnClick="btnDocDelete4_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocGet4" runat="server" Text="Get" OnClick="btnDocGet4_Click"></dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblDocDesc5" runat="server" Text="Are copies of the vendor quotes provided?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxDocName5" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocSave5" runat="server" Text="Upload" OnClick="btnDocSave5_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocDelete5" runat="server" Text="Delete" OnClick="btnDocDelete5_Click"></dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="btnDocGet5" runat="server" Text="Get" OnClick="btnDocGet5_Click"></dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </div>






                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblToolingHeader" runat="server" Text="IV. Tooling" Font-Size="18"></dx:ASPxLabel>
                        </div>

                        <div class="Section">
                            <table class="tbl">
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblTooling" runat="server" Text="How much is the Customer Paying for Tooling?"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="tbxTooling" runat="server" ClientEnabled="false" DisabledStyle-ForeColor="Black"></dx:ASPxTextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <div>
                            <dx:ASPxLabel ID="lblToolingBreakdown" runat="server" Text="Please provide a breakdown of the tooling paid."></dx:ASPxLabel>
                        </div>
                   
                        <div class="Section">
                             <dx:ASPxGridView ID="gvToolingBreakdown" runat="server" ClientInstanceName="gvToolingBreakdown" AutoGenerateColumns="false" 
                                DataSourceID="odsToolingBreakdown" KeyFieldName="RowID">
                                <Styles>
                                    <Cell>
                                        <Paddings PaddingTop="2px" PaddingBottom="2px" />
                                    </Cell>
                                </Styles>
                                <Columns>
                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0" Width="130" FixedStyle="Left" />

                                    <dx:GridViewDataTextColumn Caption="RowID" FieldName="RowID" Name="RowID" VisibleIndex="1" Width="80" Visible="false" />
                                    <dx:GridViewDataTextColumn Caption="QuoteNumber" FieldName="QuoteNumber" Name="QuoteNumber" VisibleIndex="2" Width="80" Visible="false" />
                                    <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" Name="Description" VisibleIndex="3" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="Quantity" FieldName="Quantity" Name="Quantity" VisibleIndex="4" Width="120" Visible="true" />
                                    <dx:GridViewDataTextColumn Caption="Value" FieldName="Value" Name="Value" VisibleIndex="5" Width="120" Visible="true" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                                </Columns>
                                <SettingsEditing Mode="Inline"></SettingsEditing>
                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                </TotalSummary>
                            </dx:ASPxGridView>

                            <asp:ObjectDataSource ID="odsToolingBreakdown" runat="server" SelectMethod="GetToolingBreakdown" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.QtToolingBreakdownViewModel"
                                DataObjectTypeName="WebPortal.QuoteLogIntegration.Models.usp_QL_QuoteTransfer_GetToolingBreakdown_Result" 
                                InsertMethod="ToolingBreakdownInsert" UpdateMethod="ToolingBreakdownUpdate" DeleteMethod="ToolingBreakdownDelete">
                                <SelectParameters>
                                    <asp:Parameter Name="quote" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </div>
                        





                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblNotesHeader" runat="server" Text="V. Special Requirements/Notes" Font-Size="18"></dx:ASPxLabel>
                        </div>


                        <div id="divNotes" class="Section">
                            <dx:ASPxHiddenField ID="hfNotesRowId" runat="server"></dx:ASPxHiddenField>

                            <table class="tbl" style="width: 700px;">
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc1" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer1" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes1" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc2" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer2" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes2" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc3" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer3" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes3" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc4" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer4" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes4" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc5" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer5" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes5" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc6" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer6" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes6" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc7" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer7" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes7" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc8" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer8" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes8" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblNotesDesc9" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxAnswer9" runat="server"></dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxMemo ID="memoNotes9" runat="server" Width="100%" Height="100"></dx:ASPxMemo>
                                    </td>
                                </tr>
                            </table>

                            <dx:ASPxButton ID="btnSaveNotes" runat="server" Text="Save Notes" OnClick="btnSaveNotes_Click"></dx:ASPxButton>
                        </div>



                        <div class="SectionHeader">
                            <dx:ASPxLabel ID="lblSignOffHeader" runat="server" Text="VI. Sign Off" Font-Size="18"></dx:ASPxLabel>
                        </div>


                        <div id="divSignOff" class="Section">
                            <dx:ASPxHiddenField ID="hfSignOffRowId" runat="server"></dx:ASPxHiddenField>

                            <table class="tbl">
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoInitials" runat="server" Text="Initials"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoDate" runat="server" Text="Date"></dx:ASPxLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoQuoteEngTitle" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxSoQuoteEngInitials" runat="server"></dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="deSoQuoteEngDate" runat="server"></dx:ASPxDateEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoMaterialRepTitle" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxSoMaterialRepInitials" runat="server"></dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="deSoMaterialRepDate" runat="server"></dx:ASPxDateEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoPemTitle" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxSoPemInitials" runat="server"></dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="deSoPemDate" runat="server"></dx:ASPxDateEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="lblSoProductEngTitle" runat="server"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cbxSoProductEngInitials" runat="server"></dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="deSoProductEngDate" runat="server"></dx:ASPxDateEdit>
                                    </td>
                                </tr>
                            </table>

                            <dx:ASPxButton ID="btnSaveSignOff" runat="server" Text="Save Sign Off" OnClick="btnSaveSignOff_Click"></dx:ASPxButton>
                        </div>



                        </dx:PanelContent>
                    </PanelCollection>
                    </dx:ASPxRoundPanel>

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


            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocSave2" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocSave3" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocSave4" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocSave5" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocGet2" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocGet3" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocGet4" />
                <asp:PostBackTrigger ControlID="rPnl$pc2$btnDocGet5" />
            </Triggers>
            </asp:UpdatePanel>



            <div>
                <dx:ASPxPopupControl ID="pcFileUpload" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="false" Modal="True"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcFileUpload"
                    HeaderText="File Upload" AllowDragging="True" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">
                            <div style="padding: 10px 20px 20px 20px;">

                                <asp:FileUpload id="FileUploadControl" runat="server" BackColor="White" />
                                <br /><br />

                                <asp:Button ID="btnUpload" runat="server" Text="Upload" UseSubmitBehavior="false" OnClick="btnUpload_Click" />
                                <br /><br />

                                <dx:ASPxLabel ID="lblUploadStatus" runat="server" Text=""></dx:ASPxLabel>

                            </div>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
            </div>





        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>




</asp:Content>