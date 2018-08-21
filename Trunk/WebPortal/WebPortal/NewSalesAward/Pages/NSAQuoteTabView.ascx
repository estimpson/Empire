<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAQuoteTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAQuoteTabView" %>

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
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.AwardDate'); }" />
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
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.FormOfCommitment'); }" 
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
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.QuoteReason'); }" 
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
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.ReplacingBasePart'); }" 
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
                                <dx:ASPxComboBox ID="SalespersonComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="UserName" DataSourceID="SalespeoplesDataSource"
                                                 ValueField="UserCode" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.ReplacingBasePart'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="SalespeoplesDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="Salespeoples" Select="" OrderBy="it.UserName" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Program Manager" FieldName="ProgramManager">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="ProgramManagerComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="UserName" DataSourceID="ProgramManagersEntityDataSource"
                                                 ValueField="UserCode" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'AwardedQuotes.ReplacingBasePart'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="ProgramManagersEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="ProgramManagers" Select="" OrderBy="it.UserName" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Quoted EAU" FieldName="QuotedEAU">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedEAUTextBox" ClientInstanceName="quotedEAUEditor" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.EAU'); }" 
                                        TextChanged="OnAmortizationQuantityChanged"
                                    />
                                    <MaskSettings Mask="<0..99999999g>." IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem />
                    <dx:LayoutItem Caption="Quoted Price" FieldName="QuotedPrice">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedPriceTextBox" ClientInstanceName="quotedPriceEditor" Width="100%" runat="server" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'QuoteLog.QuotedPrice'); }" 
                                    />
                                    <MaskSettings Mask="$<0..99999999g>.<000000..999999>" IncludeLiterals="DecimalSymbol" ErrorText="*"/>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Quoted Material Cost" FieldName="QuotedMaterialCost">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="QuotedMaterialCostTextBox" ClientInstanceName="quotedMaterialCostEditor" Width="100%" runat="server" ReadOnly="True">
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
                                    function onFileUploadComplete(s, e) {
                                        if(e.callbackData) {
                                            var fileData = e.callbackData.split('|');
                                            var fileName = fileData[0],
                                                fileUrl = fileData[1],
                                                fileSize = fileData[2];
                                            console.log("fileName: " + fileName);
                                            console.log("fileUrl: " + fileUrl);
                                            console.log("fileSize: " + fileSize);
                                        }
                                    }
                                </script>
                                <div style="padding-top: 10px">
                                    <div class="uploadContainer">
                                        <dx:ASPxUploadControl ID="CustomerCommitmentUploadControl" ClientInstanceName="customerCommitmentUploadControl" runat="server"
                                                              NullText="Select a file..." UploadMode="Advanced"
                                                              ShowUploadButton="True" ShowAddRemoveButtons="True" ShowProgressPanel="True"
                                                              OnFileUploadComplete="CustomerCommitmentUploadControl_OnFileUploadComplete">
                                            <AdvancedModeSettings EnableMultiSelect="False" EnableDragAndDrop="True" />
                                            <ValidationSettings MaxFileSize="41943040" />
                                            <ClientSideEvents
                                                FilesUploadStart=""
                                                FileUploadComplete="onFileUploadComplete" />
                                        </dx:ASPxUploadControl>
                                    </div>
                                    <div class="filesContainer">
                                        
                                    </div>
                                </div>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Customer Commitment File" FieldName="">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxLabel runat="server" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
               </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>

</dx:ASPxCallbackPanel>