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
                    <dx:LayoutItem Caption="Quote" FieldName="QuoteNumber">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" EnableCallbackMode="true" CallbackPageSize="10" 
                                    ValidateRequestMode="Disabled" ValueType="System.String" ValueField="QuoteNumber" ValidationSettings-CausesValidation="false"
                                    OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                    OnItemRequestedByValue="cbxQuoteNumber_OnItemRequestedByValue_SQL" TextFormatString="{0}  {1}  {2}"
                                    Width="298px" DropDownStyle="DropDown"
                                    OnSelectedIndexChanged="cbxQuoteNumber_SelectedIndexChanged" AutoPostBack="true" TabIndex="0">
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="QuoteNumber" />
                                        <dx:ListBoxColumn FieldName="EEIPartNumber" />
                                        <dx:ListBoxColumn FieldName="Program" />
                                    </Columns>
                                    <ValidationSettings CausesValidation="false">
                                    </ValidationSettings>
                                </dx:ASPxComboBox>

                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>


                    <dx:LayoutItem Caption="Award Date" FieldName="AwardDate">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="deAwardDate" runat="server" TabIndex="1" Width="220">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem Caption="Form of Commitment" FieldName="FormOfCommitment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="cbxFormOfCommitment" runat="server" ReadOnly="false" TabIndex="2" Width="220">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem Caption="Quote Reason" FieldName="QuoteReason">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="cbxQuoteReason" runat="server" OnSelectedIndexChanged="cbxQuoteReason_SelectedIndexChanged" AutoPostBack="true" TabIndex="3" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem Caption="Replacing Base Part" FieldName="ReplacingBasePart">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                <dx:ASPxComboBox ID="cbxReplacingBasePart" runat="server" TabIndex="4" Width="220">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>    

                    <dx:LayoutItem Caption="Salesperson" FieldName="Salesperson">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                 <dx:ASPxComboBox ID="cbxSalesperson" runat="server" TabIndex="5" Width="220">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                     
                    <dx:LayoutItem Caption="Program Manager" FieldName="ProgramManager">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                <dx:ASPxComboBox ID="cbxProgramManager" runat="server" TabIndex="6" Width="220">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxComboBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>              
                 
                    <dx:LayoutItem Caption="Comments" FieldName="Comments">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                 <dx:ASPxMemo ID="memoComments" runat="server" Width="420" Height="80" TabIndex="7"></dx:ASPxMemo>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                                   
                    <dx:LayoutItem Caption="">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                 <dx:ASPxButton ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" TabIndex="8" ValidationGroup="G"></dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>      
                   
                    <dx:LayoutItem Caption="" FieldName="Document Name">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">        
                                 <dx:ASPxTextBox ID="tbxDocName" runat="server" ReadOnly="true" ClientEnabled="false" Width="305" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>     
                    


                   
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>