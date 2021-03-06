﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAToolingAmortizationTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAToolingAmortizationTabView" %>

<script>
    var postponedCallbackRequired = false;
    function OnSaveToolingAmortizationClicked(s, e) {
        if(ToolingAmortizationCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            ToolingAmortizationCallbackPanel.PerformCallback();
    }
    function OnEndToolingAmortizationCallback(s, e) {
        if(postponedCallbackRequired) {
            ToolingAmortizationCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveToolingAmortizationCheckMark").show(50);
    }

    function OnControlsInitializedToolingAmortization() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedToolingAmortization,
            function(control) {
                return control.GetParentControl() ===
                    ToolingAmortizationFormLayout // Gets standalone editors nested inside the form layout control
            });

        //  Add an additional listener for the amortization amount and quantity editors.
        ASPxClientEdit.AttachEditorModificationListener(function () { UpdateAmortizationPrice(); },
            function(control) {
                return (control === amortizationAmountEditor) || (control === amortizationQuantityEditor)
            });

        //  Show amortized price.
        UpdateAmortizationPrice();
    }

    function OnEditorsChangedToolingAmortization(s, e) {
        $("#divSaveToolingAmortizationCheckMark").hide(50);
    }

    function OnAmortizationAmountChanged(s, e) {
        UpdateAmortizationPrice();
    }

    function OnAmortizationQuantityChanged(s, e) {
        UpdateAmortizationPrice();
    }

    function UpdateAmortizationPrice() {
        var amortizationAmount = amortizationAmountEditor.GetValue();
        var amortizationQuantity = amortizationQuantityEditor.GetValue();
        if (amortizationAmount === 0) amortizationAmount = undefined;
        amortizedPriceEditor.SetValue(amortizationAmount / amortizationQuantity);
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="ToolingAmortizationCallbackPanel" runat="server" OnCallback="ToolingAmortizationCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndToolingAmortizationCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedToolingAmortization"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="ToolingAmortizationFormLayout" runat="server" ClientInstanceName="ToolingAmortizationFormLayout" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Amortization Amount" FieldName="AmortizationAmount">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <script>
                                    function OnAmortizationTextBoxInit(s, e) {
                                        RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationAmount');

                                        //  Register a call back with the 
                                        var inputElement = s.GetInputElement();
                                        inputElement.oninput = function() {
                                            OnAmortizationAmountChanged();
                                        }
                                    }
                                </script>
                                <dx:ASPxTextBox ID="AmortizationAmountTextBox" ClientInstanceName="amortizationAmountEditor" Width="100%" runat="server"
                                                >
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationAmount'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Amortization Quantity" FieldName="AmortizationQuantity">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AmortizationQuantityTextBox" ClientInstanceName="amortizationQuantityEditor" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationQuantity'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem />
                    <dx:LayoutItem Caption="Amortization Price" FieldName="AmortizationPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AmortizationPriceTextBox" ClientInstanceName="amortizedPriceEditor" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizatedPrice'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Amortization Tooling Desc" FieldName="AmortizationToolingDescription">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AmortizationToolingDescriptionTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationToolingDescription'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Amortization CAPEXID" FieldName="AmortizationCAPEXID">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AmortizationCAPEXIDTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationCAPEXID'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnSaveToolingAmortization" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSaveToolingAmortizationClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <div id="divSaveToolingAmortizationCheckMark" style="display: none">
                                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                                    <Image IconID="actions_apply_32x32office2013" />
                                                </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
           </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>
