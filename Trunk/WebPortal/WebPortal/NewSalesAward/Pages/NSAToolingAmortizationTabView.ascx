<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAToolingAmortizationTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAToolingAmortizationTabView" %>

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
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="ToolingAmortizationCallbackPanel" runat="server" OnCallback="ToolingAmortizationCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndToolingAmortizationCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="ToolingAmortizationFormLayout" runat="server" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Amortization Amount" FieldName="AmortizationAmount">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AmortizationAmountTextBox" Width="100%" runat="server">
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
                                <dx:ASPxTextBox ID="AmortizationQuantityTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AmortizationQuantity'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
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
                                <dx:ASPxButton ID="btnSaveToolingAmortization" runat="server" AutoPostBack="False" Text="Save">
                                    <ClientSideEvents Click="OnSaveToolingAmortizationClicked"></ClientSideEvents>
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                    <Image IconID="actions_apply_32x32office2013" />
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
           </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>
