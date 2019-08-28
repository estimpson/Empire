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
        $("#divSavePOCheckMark").show(50);
    }

    function OnControlsInitialized() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChanged,
            function(control) {
                return control.GetParentControl() ===
                    CustomerPOFormLayout // Gets standalone editors nested inside the form layout control
            });
    }

    function OnEditorsChanged(s, e) {
        $("#divSavePOCheckMark").hide(50);
    }

</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="POCallbackPanel" runat="server" OnCallback="POCallback_OnCallback" >
    <ClientSideEvents EndCallback="OnEndPOCallback" Init="function () {  }"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitialized"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
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
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnSavePO" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSavePOClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <div id="divSavePOCheckMark" style="display: none">
                                                <dx:ASPxButton ID="SaveCheckMark" ClientInstanceName="SavePOCheckMark" runat="server" RenderMode="Link">
                                                    <Image IconID="actions_apply_32x32office2013"/>
                                                </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>







                    <dx:EmptyLayoutItem />
                    <dx:LayoutItem Caption="Customer PO File Upload">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <script>
                                    function onFileUploaderInit(s, e) {
                                        s.SetEnabled(!(customerCommitmentAttachmentTextBox.GetText() > ""));
                                    }

                                    function onFileUploadComplete(s, e) {
                                        console.log("onFileUploadComplete");
                                        if(e.callbackData) {
                                            var fileData = e.callbackData.split('|');
                                            var fileName = fileData[0],
                                                fileUrl = fileData[1],
                                                fileSize = fileData[2];
                                            console.log("fileName: " + fileName);
                                            console.log("fileUrl: " + fileUrl);
                                            console.log("fileSize: " + fileSize);
                                            customerCommitmentAttachmentTextBox.SetText(fileName);
                                            s.SetEnabled(false);
                                            SetCommitmentFileActionsEnabled(true);
                                        }
                                    }
                                </script>
                                <%--<div style="padding-top: 10px">--%>
                                    <div class="uploadContainer">
                                        <dx:ASPxUploadControl ID="CustomerPOUploadControl" ClientInstanceName="customerPOUploadControl" runat="server"
                                                              NullText="Select a file..." UploadMode="Advanced"
                                                              ShowUploadButton="True" ShowAddRemoveButtons="True" ShowProgressPanel="True"
                                                              OnFileUploadComplete="CustomerPOUploadControl_OnFileUploadComplete">
                                            <AdvancedModeSettings EnableMultiSelect="False" EnableDragAndDrop="True" />
                                            <ValidationSettings MaxFileSize="41943040" />
                                            <ClientSideEvents
                                                Init="onFileUploaderInit"
                                                FileUploadComplete="onFileUploadComplete" />
                                        </dx:ASPxUploadControl>
                                    </div>
                                <%--</div>--%>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Customer PO File" FieldName="CustomerPOAttachment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <div style="width: 100%">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 100%">
                                                <dx:ASPxTextBox ClientInstanceName="customerPOAttachmentTextBox" runat="server" ReadOnly="True" Width="100%"/>
                                            </td>
                                            <td>
                                                <script>
                                                    var postponedCallbackFileActions;
                                                    var callbackType;

                                                    function OnDeleteCustomerPOClick(s, e) {
                                                        ConfirmationPrompt(null,
                                                            function() {
                                                                callbackType = "Delete";
                                                                if (fileActionsCallback.InCallback()) {
                                                                    var postponedCallbackFileActions = true;
                                                                } else {
                                                                    callbackType = "Delete";
                                                                    fileActionsCallback.PerformCallback(callbackType);
                                                                }
                                                            },
                                                            null, 'Confirmation', 'Are you sure you want to delete the customer PO attachment?');
                                                    }

                                                    function OnOpenCustomerPOClick(s, e) {
                                                        callbackType = "Open";
                                                        if (fileActionsCallback.InCallback()) {
                                                            var postponedCallbackFileActions = true;
                                                        } else {
                                                            fileActionsCallback.PerformCallback(callbackType);
                                                        }
                                                    }

                                                    function OnInitFileActions(s, e) {
                                                        SetCommitmentFileActionsEnabled(customerPOAttachmentTextBox.GetText() > "");
                                                    }

                                                    function OnEndCallbackHandleFileActions(s, e) {
                                                        if (postponedCallbackFileActions) {
                                                            fileActionsCallback.PerformCallback(callbackType);
                                                            return;
                                                        }

                                                        switch (callbackType) {
                                                            case "Open":
                                                                var src = customerPOFile.cpFilePath;
                                                                window.open(src, "_blank", "resizable=true", true);
                                                                break;
                                                            case "Delete":
                                                                customerPOAttachmentTextBox.SetText("");
                                                                customerPOUploadControl.SetEnabled(true);
                                                                SetPOFileActionsEnabled(false);
                                                                break;
                                                        }
                                                    }

                                                    function SetPOFileActionsEnabled(e) {
                                                        console.log("POFileActionsEnabled: " + e);
                                                        customerPOFile.SetEnabled(e);
                                                        deletePOFile.SetEnabled(e);
                                                    }
                                                </script>
                                                <dx:ASPxCallbackPanel runat="server" ID="HandleFileActionsCallback" ClientInstanceName="fileActionsCallback"
                                                                      OnCallback="HandleFileActionsCallback_OnCallback">
                                                    <ClientSideEvents
                                                        Init="OnInitFileActions"
                                                        EndCallback="OnEndCallbackHandleFileActions"/>
                                                    <PanelCollection>
                                                        <dx:PanelContent runat="server">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <dx:ASPxButton ID="OpenCustomerPOFileButton" ClientInstanceName="customerPOFile" runat="server" 
                                                                                       RenderMode="Link" AutoPostBack="False" UseSubmitBehavior="False">
                                                                            <Image IconID="print_preview_32x32gray"></Image>
                                                                            <ClientSideEvents Click="OnOpenCustomerPOClick" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                    <td>
                                                                        <dx:ASPxButton ClientInstanceName="deletePOFile" runat="server" 
                                                                                       RenderMode="Link" AutoPostBack="False" UseSubmitBehavior="False">
                                                                            <Image IconID="actions_deleteitem_32x32gray"></Image>
                                                                            <ClientSideEvents Click="OnDeleteCustomerPOClick" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxCallbackPanel>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>





                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>