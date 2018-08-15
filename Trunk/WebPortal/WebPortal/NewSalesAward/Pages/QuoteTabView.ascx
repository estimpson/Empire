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
                                            <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" ClientInstanceName="cbxQuoteNumber" EnableCallbackMode="true" CallbackPageSize="10" 
                                                ValidateRequestMode="Disabled" ValueType="System.String" ValueField="QuoteNumber" ValidationSettings-CausesValidation="false"
                                                OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                                OnItemRequestedByValue="cbxQuoteNumber_OnItemRequestedByValue_SQL" TextFormatString="{0}  {1}  {2}"
                                                Width="298px" DropDownStyle="DropDown" OnCallback="cbxQuoteNumber_Callback" TabIndex="0">
                                                <ClientSideEvents SelectedIndexChanged="QuoteNumberSelectedIndexChanged" />
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
                                                <dx:ASPxComboBox ID="cbxQuoteReason" runat="server" OnSelectedIndexChanged="cbxQuoteReason_SelectedIndexChanged" AutoPostBack="true" TabIndex="3" Width="220">
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
                                                <dx:ASPxButton ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" TabIndex="8" ValidationGroup="G"></dx:ASPxButton>
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