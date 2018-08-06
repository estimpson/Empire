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
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="TesterToolingCallbackPanel" runat="server" OnCallback="TesterToolingCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndTesterToolingCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="TesterToolingFormLayout" runat="server" ColCount="2">
                <Items>
                    <dx:LayoutItem Caption="Asm Tester Tooling Amount" FieldName="AssemblyTesterToolingAmount">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingAmountTextBox" Width="100%" runat="server">
                                    <MaskSettings Mask="$<0..99999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling Trigger" FieldName="AssemblyTesterToolingTrigger">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingTriggerTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling Desc" FieldName="AssemblyTesterToolingDescription">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingDescriptionTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Asm Tester Tooling CAPEXID" FieldName="AssemblyTesterToolingCAPEXID">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AssemblyTesterToolingCAPEXIDTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxButton ID="btnSaveTesterTooling" runat="server" AutoPostBack="False" Text="Save">
                                    <ClientSideEvents Click="OnSaveTesterToolingClicked"></ClientSideEvents>
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                    <Image IconID="actions_apply_32x32office2013"/>
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>
