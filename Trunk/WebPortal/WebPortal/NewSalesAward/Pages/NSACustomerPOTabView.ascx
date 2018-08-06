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

    var isDirty = false;
    var state = {};

    function OnControlsInitialized() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChanged,
            function(control) {
                return control.GetParentControl() ===
                    CustomerPOFormLayout // Gets standalone editors nested inside the form layout control
            });
        ASPxClientUtils.AttachEventToElement(window, "beforeunload", OnBeforeUnload);
        state = ASPxClientUtils.GetEditorValuesInContainer(CustomerPOFormLayout.GetMainElement());
    }

    function OnEditorsChanged(s, e) {
        isDirty = true;
        $("#divSavePOCheckMark").hide(200);
    }

    function restoreEditorsState() {
        for (var controlName in state) {
            var trackedControl = ASPxClientControl.GetControlCollection().GetNotificationOptions(controlName);
            var setValueMethod = trackedControl.SetTokenCollection ||
                trackedControl.SelectValue ||
                trackedControl.SetValue;
            if (setValueMethod === trackedControl.SelectValues)
                trackedControl.UnselectAll();
            setValueMethod.call(trackedControl, state[controlName]);
        }
    }

    function CancelChanges(s, e) {
        restoreEditorsState();
        isDirty = false;
        $("#divSavePOCheckMark").hide(200);
    }

    function OnBeforeUnload(e) {
        if (!isDirty)
            return;
        var confirmMessage = "Are you sure you want to close the form?  Any unsaved data will be lost.";
        e.returnValue = confirmMessage;
        return confirmMessage;
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="POCallbackPanel" runat="server" OnCallback="POCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndPOCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitialized"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxHiddenField runat="server" ID="QuoteNumberHiddenField" ClientInstanceName="QuoteNumberHiddenField"/>
            <dx:ASPxFormLayout ID="CustomerPOFormLayout" ClientInstanceName="CustomerPOFormLayout" runat="server" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Purchase Order Date" FieldName="PurchaseOrderDate">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="PODateDateEdit" ClientInstanceName="PODateDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.PurchaseOrderDT'); }" 
                                        />
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
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.PONumber'); }" 
                                        />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Alt Customer Commitment" FieldName="AlternativeCustomerCommitment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AltCustomerCommitmentTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.AlternativeCustomerCommitment'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="PO Selling Price" FieldName="PurchaseOrderSellingPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="POSellingPriceTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.SellingPrice'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Purchase Order SOP" FieldName="PurchaseOrderSOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="POSOPDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.PurchaseOrderSOP'); }" 
                                    />
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
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.PurchaseOrderEOP'); }" 
                                    />
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
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuoteProductionPOs.Comments'); }" 
                                    />
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
                                <div id="divSavePOCheckMark" style="display: none">
                                    <dx:ASPxButton ID="SaveCheckMark" ClientInstanceName="SavePOCheckMark" runat="server" RenderMode="Link" Enabled="False">
                                        <Image IconID="actions_apply_32x32office2013"/>
                                    </dx:ASPxButton>
                                </div>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>