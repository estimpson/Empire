<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateAwardedQuoteTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.CreateAwardedQuoteTabView" %>


<script>
    var postponedCallbackRequired = false;

    function OnSaveBasePartAttributesClicked(s, e) {
        if (BasePartAttributesCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            BasePartAttributesCallbackPanel.PerformCallback();
    }

    function OnEndBasePartAttributesCallback(s, e) {
        if (postponedCallbackRequired) {
            BasePartAttributesCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveBasePartAttributesCheckMark").show(50);
    }

    function OnControlsInitializedBasePartAttributes() {
        ASPxClientEdit.AttachEditorModificationListener(OnEditorsChangedBasePartAttributes,
            function(control) {
                return control.GetParentControl() ===
                    BasePartAttributesFormLayout // Gets standalone editors nested inside the form layout control
            });
    }

    function OnEditorsChangedBasePartAttributes(s, e) {
        $("#divSaveBasePartAttributesCheckMark").hide(50);
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="BasePartAttributesCallbackPanel" runat="server" OnCallback="ASPxCallbackPanel1_Callback">
    <ClientSideEvents EndCallback="OnEndBasePartAttributesCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedBasePartAttributes"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="BasePartAttributesFormLayout" runat="server" ClientInstanceName="BasePartAttributesFormLayout" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Quote" FieldName="QuoteNumber">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" EnableCallbackMode="true" CallbackPageSize="10" 
                                    ValidateRequestMode="Disabled" ValueType="System.String" ValueField="QuoteNumber" ValidationSettings-CausesValidation="false"
                                    OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                    OnItemRequestedByValue="cbxQuoteNumber_OnItemRequestedByValue_SQL" TextFormatString="{0}  {1}  {2}"
                                    Width="298px" DropDownStyle="DropDown"
                                    OnSelectedIndexChanged="cbxQuoteNumber_SelectedIndexChanged" AutoPostBack="true" TabIndex="0">
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="QuoteNumber" />
                                        <dx:ListBoxColumn FieldName="EEIPartNumber" />
                                        <dx:ListBoxColumn FieldName="Program" />
                                    </Columns>
                                    <ValidationSettings CausesValidation="false">
                                    </ValidationSettings>
                                </dx:ASPxComboBox>

                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>


                    <dx:LayoutItem Caption="Base Part Family" FieldName="BasePartFamily">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="BasePartFamilyTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.BasePartFamily'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Product Line" FieldName="ProductLine">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="ProductLineComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="ProductLine1" DataSourceID="ProductLineEntityDataSource"
                                                 ValueField="ProductLine1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.ProductLine'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="ProductLineEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="ProductLines" Select="" OrderBy="it.ProductLine1" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire Market Segment" FieldName="EmpireMarketSegment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="EmpireMarketSegmentComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="EmpireMarketSegment1" DataSourceID="EmpireMarketSegmentEntityDataSource"
                                                 ValueField="EmpireMarketSegment1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireMarketSegment'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="EmpireMarketSegmentEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EmpireMarketSegments" Select="" OrderBy="it.EmpireMarketSegment1" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire Market Subegment" FieldName="EmpireMarketSubsegment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="EmpireMarketSubsegmentComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="EmpireMarketSubsegment1" DataSourceID="EmpireMarketSubsegmentEntityDataSource"
                                                 ValueField="EmpireMarketSubsegment1" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireMarketSubsegment'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="EmpireMarketSubsegmentEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EmpireMarketSubsegments" Select="" OrderBy="it.EmpireMarketSubsegment1" EnableInsert="true">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire Application" FieldName="EmpireApplication">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="EmpireApplicationTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireApplication'); }" 
                                    />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem/>
                    <dx:LayoutItem Caption="Empire SOP" FieldName="EmpireSOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="EmpireSOPDateEdit" runat="server" Width="100%" UseMaskBehavior="true">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireSOP'); }" 
                                    />
                                    <CalendarProperties>
                                        <FastNavProperties DisplayMode="Inline"/>
                                    </CalendarProperties>
                                </dx:ASPxDateEdit>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire EOP" FieldName="Empire EOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="EmpireEOPDateEdit" runat="server" Width="100%" UseMaskBehavior="true" ReadOnly="True">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireEOP'); }" 
                                    />
                                    <CalendarProperties>
                                        <FastNavProperties DisplayMode="Inline"/>
                                    </CalendarProperties>
                                </dx:ASPxDateEdit>
                                <dx:ASPxButton ID="ASPxButton2" runat="server" RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Hide');}"/>
                                    <Image IconID="comments_editcomment_32x32"></Image>
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="ASPxButton1" runat="server" RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Show');}"/>
                                    <Image IconID="miscellaneous_comment_32x32"></Image>
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Comments" FieldName="BasePart_Comments" ColSpan="2">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxTextBox ID="BasePart_CommentsTextBox" Width="100%" runat="server">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.Comments'); }" 
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
                                            <dx:ASPxButton ID="btnSaveBasePartAttributes" runat="server" AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="OnSaveBasePartAttributesClicked"></ClientSideEvents>
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <div id="divSaveBasePartAttributesCheckMark" style="display: none">
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
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>