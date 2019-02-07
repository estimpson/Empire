<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuoteTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.QuoteTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveBasePartAttributesClicked(s, e) {
        if (ASPxCallbackPanel1.InCallback())
            postponedCallbackRequired = true;
        else
            ASPxCallbackPanel1.PerformCallback();
    }

    function OnEndBasePartAttributesCallback(s, e) {
        if (postponedCallbackRequired) {
            ASPxCallbackPanel1.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveBasePartAttributesCheckMark").show(50);
    }

    function OnControlsInitializedBasePartAttributes() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedBasePartAttributes,
            function(control) {
                return control.GetParentControl() ===
                    BasePartAttributesFormLayout // Gets standalone editors nested inside the form layout control
            });
    }

    function OnEditorsChangedBasePartAttributes(s, e) {
        $("#divSaveBasePartAttributesCheckMark").hide(50);
    }

    function QuoteNumberSelectedIndexChanged() {
        alert(cbxQuoteNumber.SelectedItem);
        if (cbxQuoteNumber.SelectedItem != null) {
            var x = cbxQuoteNumber.SelectedItem;
            alert(cbxQuoteNumber.SelectedItem);
        }
        cbxQuoteNumber.PerformCallback();
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="ASPxCallbackPanel1" runat="server" OnCallback="ASPxCallbackPanel1_Callback">
    <ClientSideEvents EndCallback="OnEndBasePartAttributesCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedBasePartAttributes"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="BasePartAttributesFormLayout" runat="server" ClientInstanceName="BasePartAttributesFormLayout" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxLabel ID="lblQuoteNumber" runat="server" Text="Quote Number:" Width="140" ></dx:ASPxLabel>
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="tbxQuoteNumber" runat="server" ReadOnly="true"></dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                </table>

                                <dx:ASPxPanel ID="pnlQuoteDetails" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblAwardDate" runat="server" Text="Award Date:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deAwardDate" runat="server" TabIndex="1" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblFormOfCommitment" runat="server" Text="Form of Commitment:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbxFormOfCommitment" runat="server" ReadOnly="false" TabIndex="2" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblQuoteReason" runat="server" Text="Quote Reason:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbxQuoteReason" runat="server" AutoPostBack="true" TabIndex="3" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblReplacingBasePart" runat="server" Text="Replacing Base Part:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbxReplacingBasePart" runat="server" TabIndex="4" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblSalesperson" runat="server" Text="Salesperson:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbxSalesperson" runat="server" TabIndex="5" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblProgramManager" runat="server" Text="Program Manager:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbxProgramManager" runat="server" TabIndex="6" Width="220">
                                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                                        <RequiredField IsRequired="True" ErrorText="" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="LightPink" />
                                                </dx:ASPxComboBox> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblQuotedEau" runat="server" Text="Quoted EAU:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbxQuotedEau" runat="server" ReadOnly="true" ClientEnabled="false" />
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblQuotedPrice" runat="server" Text="Quoted Price:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbxQuotedPrice" runat="server" ReadOnly="true" ClientEnabled="false" />
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblQuotedMaterialCost" runat="server" Text="Quoted Material Cost:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbxQuotedMaterialCost" runat="server" ReadOnly="true" ClientEnabled="false" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblComments" runat="server" Text="Comments:"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxMemo ID="memoComments" runat="server" Width="298" Height="80" TabIndex="7"></dx:ASPxMemo>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" TabIndex="8" ValidationGroup="G" Visible="false"></dx:ASPxButton>
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
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblCustCommitDoc" runat="server" Text="Customer commitment doc:" Width="140" />
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbxDocName" runat="server" ReadOnly="true" ClientEnabled="false" Width="305" />
                                            </td>
                                        </tr>
                                    </table>


                                    <div style="margin: 0px 0px 0px 140px;">
                                        <asp:Panel ID="pnlDocument" runat="server">
                                            <table class="tbl">
                                                <tr>
                                                    <td>
                                                        <dx:ASPxButton ID="btnDocSave" runat="server" Text="Upload" OnClick="btnDocSave_Click"></dx:ASPxButton>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxButton ID="btnDocDelete" runat="server" Text="Delete" OnClick="btnDocDelete_Click"></dx:ASPxButton>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxButton ID="btnDocGet" runat="server" Text="Get" OnClick="btnDocGet_Click"></dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </div>




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




                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxPanel>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                   
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>