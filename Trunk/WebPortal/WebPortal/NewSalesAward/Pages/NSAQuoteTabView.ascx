<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAQuoteTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAQuoteTabView" %>
<%@ Register Src="~/NewSalesAward/Pages/ConfirmationPopupUserControl.ascx" TagPrefix="uc1" TagName="ConfirmationPopupUserControl" %>


<script>
    var postponedCallbackRequired = false;

    function OnSaveQuoteInfoClicked(s, e) {
        if (BasePartAttributesCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else {
            QuoteInfoCallbackPanel.PerformCallback();
        }
    }

    function OnQuoteInfoEndCallback(s, e) {
        console.log("OnEndQuoteInfoCallback");
        if (postponedCallbackRequired) {
            QuoteInfoCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
            return;
        }
        $("#divSaveQuoteInfoCheckMark").show(50);
        IndividualTabSaved(s, e);
    }

    function OnControlsInitializedQuoteInfo() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedBasePartAttributes,
            function(control) {
                return control.GetParentControl() ===
                    QuoteInfoFormLayout // Gets standalone editors nested inside the form layout control
            });
    }


</script>
<dx:ASPxCallbackPanel ID="QuoteInfoCallbackPanel" ClientInstanceName="QuoteInfoCallbackPanel" runat="server"
                      OnCallback="QuoteInfoCallback_OnCallback">
    <ClientSideEvents
        EndCallback="OnQuoteInfoEndCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents
                        ControlsInitialized="OnControlsInitializedQuoteInfo">
                </ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="QuoteInfoFormLayout" ClientInstanceName="QuoteInfoFormLayout" runat="server"
                               ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Award Date" FieldName="AwardDate">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="AwardDateEdit" ClientInstanceName="awardDateEditor" runat="server" Width="100%" UseMaskBehavior="true">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardDate'); }" />
                                    <CalendarProperties>
                                        <FastNavProperties DisplayMode="Inline" />
                                    </CalendarProperties>
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Form of Commitment" FieldName="FormOfCommitment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="FormOfCommitmentComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="FormOfCommitment" DataSourceID="FormOfCommitmentEntityDataSource"
                                                 ValueField="FormOfCommitment" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'FormOfCommitment'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="FormOfCommitmentEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="CustomerCommitmentForms" Select="" OrderBy="it.FormOfCommitment" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Quote Reason" FieldName="QuoteReason">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="QuoteReasonComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="QuoteReason1" DataSourceID="QuoteReasonsEntityDataSource"
                                                 ValueField="QuoteReason1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteReason'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="QuoteReasonsEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="QuoteReasons" Select="" OrderBy="it.QuoteReason1" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Replacing Base Part" FieldName="ReplacingBasePart">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="ReplacingBasePartComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="BasePart" DataSourceID="ActiveBasePartsEntityDataSource"
                                                 ValueField="BasePart" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'ReplacingBasePart'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="ActiveBasePartsEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="ActiveBaseParts" Select="" OrderBy="it.BasePart" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Salesperson" FieldName="Salesperson">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="SalespersonComboBox" runat="server" Width="100%" DropDownStyle="DropDownList" TextField="FullName" DataSourceID="SalespeoplesDataSource"
                                                 ValueField="RowID" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'ReplacingBasePart'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="SalespeoplesDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EditTabs_Salespeople" Select="" OrderBy="it.FullName" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Program Manager" FieldName="ProgramManager">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="ProgramManagerComboBox" runat="server" Width="100%" DropDownStyle="DropDownList" TextField="FullName" DataSourceID="ProgramManagersEntityDataSource"
                                                 ValueField="RowID" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'ReplacingBasePart'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="ProgramManagersEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EditTabs_ProgramManagers" Select="" OrderBy="it.FullName" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Quoted EAU" FieldName="QuotedEAU">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedEAUTextBox" ClientInstanceName="quotedEAUEditor" runat="server"
                                                Width="100%" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.QuotedEAU'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem />
                    <dx:LayoutItem Caption="Quoted Price" FieldName="QuotedPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedPriceTextBox" ClientInstanceName="quotedPriceEditor" runat="server"
                                                Width="100%" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.QuotedPrice'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem Caption="Awarded EAU" FieldName="AwardedEAU">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AwardedEAUTextBox" ClientInstanceName="awardedEAUEditor" runat="server"
                                                Width="100%" ReadOnly="False">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.AwardedEAU'); }" 
                                    />
                                    <MaskSettings Mask="<0..99999999g>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem />
                    <dx:LayoutItem Caption="Awarded Price" FieldName="AwardedPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="AwardedPriceTextBox" ClientInstanceName="awardedPriceEditor" runat="server"
                                                Width="100%" ReadOnly="False">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.AwardedPrice'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem Caption="Quoted Material Cost" FieldName="QuotedMaterialCost">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedMaterialCostTextBox" ClientInstanceName="quotedMaterialCostEditor" runat="server"
                                                Width="100%" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.QuotedMaterialCost'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Comments" FieldName="Comments" ColSpan="2">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="CommentsTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.Comments'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <script>

                                </script>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnSaveQuoteInfo" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSaveQuoteInfoClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <div id="divSaveQuoteInfoCheckMark" style="display: none">
                                                <dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
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
                    <dx:LayoutItem Caption="Customer Commitment File Upload">
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
                                        <dx:ASPxUploadControl ID="CustomerCommitmentUploadControl" ClientInstanceName="customerCommitmentUploadControl" runat="server"
                                                              NullText="Select a file..." UploadMode="Advanced"
                                                              ShowUploadButton="True" ShowAddRemoveButtons="True" ShowProgressPanel="True"
                                                              OnFileUploadComplete="CustomerCommitmentUploadControl_OnFileUploadComplete">
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
                    <dx:LayoutItem Caption="Customer Commitment File" FieldName="CustomerCommitmentAttachment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <div style="width: 100%">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 100%">
                                                <dx:ASPxTextBox ClientInstanceName="customerCommitmentAttachmentTextBox" runat="server" ReadOnly="True" Width="100%"/>
                                            </td>
                                            <td>
                                                <script>
                                                    var postponedCallbackFileActions;
                                                    var callbackType;

                                                    function OnDeleteCustomerCommitmentClick(s, e) {
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
                                                            null, 'Confirmation', 'Are you sure you want to delete the customer commitment attachment?');
                                                    }

                                                    function OnOpenCustomerCommitmentClick(s, e) {
                                                        callbackType = "Open";
                                                        if (fileActionsCallback.InCallback()) {
                                                            var postponedCallbackFileActions = true;
                                                        } else {
                                                            fileActionsCallback.PerformCallback(callbackType);
                                                        }
                                                    }

                                                    function OnInitFileActions(s, e) {
                                                        SetCommitmentFileActionsEnabled(customerCommitmentAttachmentTextBox.GetText() > "");
                                                    }

                                                    function OnEndCallbackHandleFileActions(s, e) {
                                                        if (postponedCallbackFileActions) {
                                                            fileActionsCallback.PerformCallback(callbackType);
                                                            return;
                                                        }

                                                        switch (callbackType) {
                                                            case "Open":
                                                                var src = customerCommitmentFile.cpFilePath;
                                                                window.open(src, "_blank", "resizable=true", true);
                                                                break;
                                                            case "Delete":
                                                                customerCommitmentAttachmentTextBox.SetText("");
                                                                customerCommitmentUploadControl.SetEnabled(true);
                                                                SetCommitmentFileActionsEnabled(false);
                                                                break;
                                                        }
                                                    }

                                                    function SetCommitmentFileActionsEnabled(e) {
                                                        console.log("CommitmentFileActionsEnabled: " + e);
                                                        customerCommitmentFile.SetEnabled(e);
                                                        deleteCommitmentFile.SetEnabled(e);
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
                                                                        <dx:ASPxButton ID="OpenCustomerCommitmentFileButton" ClientInstanceName="customerCommitmentFile" runat="server" 
                                                                                       RenderMode="Link" AutoPostBack="False" UseSubmitBehavior="False">
                                                                            <Image IconID="print_preview_32x32gray"></Image>
                                                                            <ClientSideEvents Click="OnOpenCustomerCommitmentClick" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                    <td>
                                                                        <dx:ASPxButton ClientInstanceName="deleteCommitmentFile" runat="server" 
                                                                                       RenderMode="Link" AutoPostBack="False" UseSubmitBehavior="False">
                                                                            <Image IconID="actions_deleteitem_32x32gray"></Image>
                                                                            <ClientSideEvents Click="OnDeleteCustomerCommitmentClick" />
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

<uc1:ConfirmationPopupUserControl runat="server" id="ConfirmationPopupUserControl" />
