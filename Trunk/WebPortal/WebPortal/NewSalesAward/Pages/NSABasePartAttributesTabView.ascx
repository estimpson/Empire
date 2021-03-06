﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSABasePartAttributesTabView.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSABasePartAttributesTabView" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveBasePartAttributesClicked(s, e) {
        if (BasePartAttributesCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else {
            var unlockNotes = "";
            if (eopDateEditor.cpUnlocked) {
                unlockNotes += eopDateEditor.cpUnlockNote;
            }
            var jsonData = {};
            jsonData["BasePartAttributes_EmpireEOPNote"] = unlockNotes;
            BasePartAttributesCallbackPanel.PerformCallback(JSON.stringify(jsonData));
            console.log(jsonData);
        }
    }

    function OnEndBasePartAttributesCallback(s, e) {
        console.log("OnEndBasePartAttributesCallback");
        if (postponedCallbackRequired) {
            BasePartAttributesCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
        $("#divSaveBasePartAttributesCheckMark").show(50);
        IndividualTabSaved(s, e);
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

    function EndMandatoryNote(s, unlocked, unlockNote) {
        console.log("EndMandatoryNote");
        console.log(s);
        console.log("unlocked: " + unlocked);
        console.log(unlockNote);

        s.cpUnlocked = unlocked;
        s.SetEnabled(unlocked);
        var inputElement = s.GetInputElement();
        inputElement.readOnly = unlocked;
        if (unlocked) {
            console.log("if (unlocked): " + true);
            s.cpUnlockNote = unlockNote;
            s.ShowDropDown();
            s.Focus();
        } else {
            console.log("if (unlocked): " + false);
            s.cpUnlockNote = undefined;
        }
    }

</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="BasePartAttributesCallbackPanel" runat="server" OnCallback="BasePartAttributesCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndBasePartAttributesCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxGlobalEvents runat="server">
                <ClientSideEvents ControlsInitialized="OnControlsInitializedBasePartAttributes"></ClientSideEvents>
            </dx:ASPxGlobalEvents>
            <dx:ASPxFormLayout ID="BasePartAttributesFormLayout" runat="server" ClientInstanceName="BasePartAttributesFormLayout"
                               ColCount="2" Width="100%"
                               OnInit="BasePartAttributesFormLayout_OnInit">
                <Items>
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
                                <dx:ASPxComboBox ID="EmpireMarketSegmentComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="EmpireMarketSegment" DataSourceID="EmpireMarketSegmentEntityDataSource"
                                                 ValueField="EmpireMarketSegment" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireMarketSegment'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="EmpireMarketSegmentEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EditTabs_EmpireMarketSegment" Select="" OrderBy="it.EmpireMarketSegment" EnableInsert="false">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire Market Subsegment" FieldName="EmpireMarketSubsegment">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxComboBox ID="EmpireMarketSubsegmentComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="EmpireMarketSubsegment" DataSourceID="EmpireMarketSubsegmentEntityDataSource"
                                                 ValueField="EmpireMarketSubsegment" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireMarketSubsegment'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="EmpireMarketSubsegmentEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EditTabs_EmpireMarketSubsegment" Select="" OrderBy="it.EmpireMarketSubsegment" EnableInsert="false">
                                </asp:EntityDataSource>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Empire Application" FieldName="EmpireApplication">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                
                                <dx:ASPxComboBox ID="EmpireApplicationComboBox" runat="server" Width="100%" DropDownStyle="DropDown" TextField="Application" DataSourceID="ApplicationEntityDataSource"
                                                 ValueField="Application" TextFormatString="{0}" AllowNull="true" IncrementalFilteringMode="StartsWith">
                                    <ClientSideEvents
                                        GotFocus="OnEditControl_GotFocus"
                                        Init="function (s,e) { RegisterURI(s, 'BasePartAttributes.EmpireApplication'); }" 
                                    />
                                </dx:ASPxComboBox>
                                <asp:EntityDataSource ID="ApplicationEntityDataSource" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                                                      EntitySetName="EditTabs_Application" Select="" OrderBy="it.Application" EnableInsert="false">
                                </asp:EntityDataSource>

                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:EmptyLayoutItem/>
                    <dx:LayoutItem Caption="Empire SOP" FieldName="EmpireSOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxDateEdit ID="EmpireSOPDateEdit" ClientInstanceName="sopDateEditor" runat="server" Width="100%" UseMaskBehavior="true">
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
                    <dx:LayoutItem Caption="Empire EOP" FieldName="EmpireEOP">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <script>
                                    function OnEOPDateEditorInit(s, e) {
                                        RegisterURI(s, 'BasePartAttributes.EmpireEOP');
                                        s.EnabledChanged.AddHandler(function () { OnEOPEnabledChanged(s, e); });
                                    }

                                    function OnEOPEnabledChanged(s, e) {
                                        console.log("EnabledChanged");
                                        if (s.GetEnabled()) {
                                            eopLockButton.SetImageUrl('../../Images/lock-unlocked-32.jpg');
                                        } else {
                                            eopLockButton.SetImageUrl('../../Images/lock-7-32.jpg');
                                        }
                                    }

                                    function onEOPLockButtonClick (s, e) {
                                        console.log("unlock clicked");
                                        ShowEditorEntityNotes(eopDateEditor);
                                        PromptMandatoryNote(eopDateEditor, EndMandatoryNote);
                                    }

                                    function onEOPCommentButtonClick (s, e) {
                                        console.log("comment clicked");
                                        ShowEditorEntityNotes(eopDateEditor);
                                    }
                                </script>
                                <div style="width:100%">
                                    <table style="width:100%">
                                        <tr>
                                            <td style="width: 100%">
                                                <dx:ASPxDateEdit ID="EmpireEOPDateEdit" ClientInstanceName="eopDateEditor" runat="server" ClientEnabled="False"
                                                                 Width="100%" UseMaskBehavior="true">
                                                    <ClientSideEvents
                                                        GotFocus="OnEditControl_GotFocus"
                                                        Init="OnEOPDateEditorInit"
                                                    />
                                                    <CalendarProperties>
                                                        <FastNavProperties DisplayMode="Inline"/>
                                                    </CalendarProperties>
                                                </dx:ASPxDateEdit>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="EOPLockButton" runat="server" ClientInstanceName="eopLockButton"
                                                               RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="onEOPLockButtonClick"/>
                                                    <Image Url="../../Images/lock-7-32.jpg" ></Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="EOPCommentButton" runat="server" ClientInstanceName="eopCommentButton"
                                                               RenderMode="Link" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="onEOPCommentButtonClick"/>
                                                    <Image Url="../../Images/comment.png" ></Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
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
