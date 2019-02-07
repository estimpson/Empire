<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAHardToolingTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAHardToolingTabView" %>

<script>
    var postponedCallbackRequired = false;
    function OnSaveHardToolingClicked(s, e) {
        if(HardToolingCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            HardToolingCallbackPanel.PerformCallback();
    }
    function OnEndHardToolingCallback(s, e) {
        if(postponedCallbackRequired) {
            HardToolingCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveHardToolingCheckMark").show(50);
    }

    function OnControlsInitializedHardTooling() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedHardTooling,
            function(control) {
                return control.GetParentControl() ===
                    HardToolingFormLayout // Gets standalone editors nested inside the form layout control
            });
    }

    function OnEditorsChangedHardTooling(s, e) {
        $("#divSaveHardToolingCheckMark").hide(50);
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="HardToolingCallbackPanel" runat="server" OnCallback="HardToolingCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndHardToolingCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedHardTooling"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="HardToolingFormLayout" ClientInstanceName="HardToolingFormLayout" runat="server" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Hard Tooling Amount" FieldName="HardToolingAmount">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="HardToolingAmountTextBox" runat="server" Width="100%" UseMaskBehavior="true">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.HardToolingAmount'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Hard Tooling Trigger" FieldName="HardToolingTrigger">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="HardToolingTriggerTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.HardToolingTrigger'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Hard Tooling Desc" FieldName="HardToolingDescription">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="HardToolingDescriptionTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.HardToolingDescription'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Hard Tooling CAPEXID" FieldName="HardToolingCAPEXID">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="HardToolingCAPEXIDTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteToolingPOs.HardToolingCAPEXID'); }" 
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
                                            <dx:ASPxButton ID="btnSaveHardTooling" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSaveHardToolingClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <div id="divSaveHardToolingCheckMark" style="display: none">
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
