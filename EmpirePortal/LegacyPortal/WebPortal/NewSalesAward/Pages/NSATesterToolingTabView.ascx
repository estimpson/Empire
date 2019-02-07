<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSATesterToolingTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSATesterToolingTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveTesterToolingClicked(s, e) {
        if (TesterToolingCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            TesterToolingCallbackPanel.PerformCallback();
    }

    function OnEndTesterToolingCallback(s, e) {
        if (postponedCallbackRequired) {
            TesterToolingCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveTesterToolingCheckMark").show(50);
    }

    function OnControlsInitializedTesterTooling() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedTesterTooling,
            function(control) {
                return control.GetParentControl() ===
                    TesterToolingFormLayout // Gets standalone editors nested inside the form layout control
            });
    }

    function OnEditorsChangedTesterTooling(s, e) {
        $("#divSaveTesterToolingCheckMark").hide(50);
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="TesterToolingCallbackPanel" runat="server" OnCallback="TesterToolingCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndTesterToolingCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedTesterTooling"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="TesterToolingFormLayout" runat="server" ClientInstanceName="TesterToolingFormLayout" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Asm Tester Tooling Amount" FieldName="AssemblyTesterToolingAmount">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingAmountTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AssemblyTesterToolingAmount'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling Trigger" FieldName="AssemblyTesterToolingTrigger">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingTriggerTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AssemblyTesterToolingTrigger'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling Desc" FieldName="AssemblyTesterToolingDescription">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingDescriptionTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AssemblyTesterToolingDescription'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling CAPEXID" FieldName="AssemblyTesterToolingCAPEXID">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingCAPEXIDTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.AssemblyTesterToolingCAPEXID'); }" 
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
                                            <div id="divSaveTesterToolingCheckMark" style="display: none">
                                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                                    <Image IconID="actions_apply_32x32office2013"/>
                                                </dx:ASPxButton>
                                            </div>
                                        </td>
                                        <td>
                                            <dx:ASPxButton ID="btnSaveTesterTooling" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSaveTesterToolingClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
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
