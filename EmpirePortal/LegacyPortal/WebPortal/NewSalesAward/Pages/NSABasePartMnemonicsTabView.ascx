<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSABasePartMnemonicsTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSABasePartMnemonicsTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnEditMnemonics(s, e) {
        if (PartMnemonicsCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            PartMnemonicsCallbackPanel.PerformCallback();
    }

    function OnEndPartMnemonicsCallback(s, e) {
        if (postponedCallbackRequired) {
            PartMnemonicsCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
            return;
        }
        window.open('CsmDemand.aspx', 'height=500,width=500,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes')
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="PartMnemonicsCallbackPanel" runat="server" OnCallback="PartMnemonicsCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndPartMnemonicsCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="PartMnemonicsFormLayout" runat="server" ClientInstanceName="PartMnemonicsFormLayout" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Vehicle Plant Mnemonic" FieldName="VehiclePlantMnemonic">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="VehiclePlantMnemonicTextBox" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartMnemonics.VehiclePlantMnemonic'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Qty Per" FieldName="QtyPer">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QtyPerTextBox" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartMnemonics.QtyPer'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Take Rate" FieldName="TakeRate">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="TakeRateTextBox" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartMnemonics.TakeRate'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Family Allocation" FieldName="FamilyAllocation">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="FamilyAllocationTextBox" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartMnemonics.FamilyAllocation'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Quoted EAU" FieldName="QuotedEAU">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedEAUTextBox" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartMnemonics.QuotedEAU'); }" 
                                    />
                                    <MaskSettings Mask="<0..999999999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
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
                                            <dx:ASPxButton ID="btnEditMnemonics" runat="server" AutoPostBack="False" Text="Mnemonics">
                                                <ClientSideEvents Click="OnEditMnemonics"></ClientSideEvents>
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
