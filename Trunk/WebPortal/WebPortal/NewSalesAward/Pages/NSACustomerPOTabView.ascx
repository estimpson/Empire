<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSACustomerPOTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSACustomerPOTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnSavePOClicked(s, e) {
        if (POCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            POCallbackPanel.PerformCallback();
    }

    function OnEndPOCallback(s, e) {
        if (postponedCallbackRequired) {
            POCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="POCallbackPanel" runat="server" OnCallback="POCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndPOCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="CustomerPOFormLayout" runat="server" ColCount="2">
                <Items>
                    <dx:LayoutItem Caption="Purchase Order Date" FieldName="PurchaseOrderDate">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="PODateDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <CalendarProperties>
                                        
<FastNavProperties DisplayMode="Inline"/>
                                    
</CalendarProperties>
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Customer Production PO #" FieldName="CustomerProductionPurchaseOrderNumber">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="PONumberTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Alt Customer Commitment" FieldName="AlternativeCustomerCommitment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AltCustomerCommitmentTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="PO Selling Price" FieldName="PurchaseOrderSellingPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="POSellingPriceTextBox" Width="100%" runat="server">
                                    <MaskSettings Mask="$<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Purchase Order SOP" FieldName="PurchaseOrderSOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="POSOPDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <CalendarProperties>
                                        
<FastNavProperties DisplayMode="Inline"/>
                                    
</CalendarProperties>
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Purchase Order EOP" FieldName="PurchaseOrderEOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="POEOPDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <CalendarProperties>
                                        
<FastNavProperties DisplayMode="Inline"/>
                                    
</CalendarProperties>
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Cust Prod PO Comments" FieldName="CustomerProductionPurchaseOrderComments" ColSpan="2">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="POCommentsTextBox" Width="100%" runat="server">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxButton ID="btnSavePO" runat="server" AutoPostBack="False" Text="Save">
                                    <ClientSideEvents Click="OnSavePOClicked"></ClientSideEvents>
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