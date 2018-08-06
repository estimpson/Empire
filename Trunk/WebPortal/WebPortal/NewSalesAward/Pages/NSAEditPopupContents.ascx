<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAEditPopupContents.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAEditPopupContents" %>
<%@ Register TagPrefix="uc1" TagName="NSACustomerPOTabView" Src="~/NewSalesAward/Pages/NSACustomerPOTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSAHardToolingTabView" Src="~/NewSalesAward/Pages/NSAHardToolingTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSAToolingAmortizationTabView" Src="~/NewSalesAward/Pages/NSAToolingAmortizationTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSATesterToolingTabView" Src="~/NewSalesAward/Pages/NSATesterToolingTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSABasePartAttributesTabView" Src="~/NewSalesAward/Pages/NSABasePartAttributesTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSABasePartMnemonicsTabView" Src="~/NewSalesAward/Pages/NSABasePartMnemonicsTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSALogisticsTabView" Src="~/NewSalesAward/Pages/NSALogisticsTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="EntityNotesUserControl" Src="~/NewSalesAward/Pages/EntityNotesUserControl.ascx" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxHtmlEditor" Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveAllClicked(s, e) {
        if (NSAEditCallbackPanel.InCallback())
            postponedCallbackRequired = true;
        else
            NSAEditCallbackPanel.PerformCallback();
    }

    function OnEndNSAEditCallback(s, e) {
        if (postponedCallbackRequired) {
            NSAEditCallbackPanel.PerformCallback();
            postponedCallbackRequired = false;
        }
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="NSAEditCallbackPanel" runat="server" OnCallback="NSAEditCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndNSAEditCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout ID="NSAEditFormLayout" runat="server" ColCount="2">
                <Items>
                    <dx:LayoutItem Caption="Base Part" ShowCaption="False" FieldName="BasePart">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxLabel runat="server" Font-Size="14" ForeColor="#007bf7"/>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False" HorizontalAlign="Right">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxButton ID="SaveAllButton" runat="server" AutoPostBack="False" Text="Save All">
                                    <ClientSideEvents Click="OnSaveAllClicked"></ClientSideEvents>
                                </dx:ASPxButton>
                                <%--<dx:ASPxButton ID="SaveCheckMark" runat="server" RenderMode="Link" Enabled="False" Visible="True">
                                    <Image IconID="actions_apply_32x32office2013"/>
                                </dx:ASPxButton>--%>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False" ColSpan="2">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxPageControl runat="server" ID="NSAEditPageControl" Width="100%" ActiveTabIndex="0">
                                    <TabPages>
                                        <dx:TabPage Text="Customer PO" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSACustomerPOTabView runat="server" id="NSACustomerPOTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Hard Tooling" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSAHardToolingTabView runat="server" id="NSAHardToolingTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Tooling Amortization" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSAToolingAmortizationTabView runat="server" id="NSAToolingAmortizationTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Assembly Tester Tooling" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSATesterToolingTabView runat="server" id="NSATesterToolingTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Base Part Attributes" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSABasePartAttributesTabView runat="server" id="NSABasePartAttributesTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Base Part Mnemonics" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSABasePartMnemonicsTabView runat="server" id="NSABasePartMnemonicsTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Logistics" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSALogisticsTabView runat="server" id="NSALogisticsTabView"/>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>
                                    </TabPages>
                                </dx:ASPxPageControl>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>

<div id="divNote" style="margin-left: 40px; margin-bottom: 20px; display: none; clear: left;">
    <table>
        <tr>
            <td>
                <dx:ASPxLabel ID="lblNoteTitle" runat="server" Text="Notes / Comments / Screenshots" ForeColor="#007bf7" />
            </td>
        </tr>
        <tr>
            <td>
                <dx:ASPxHtmlEditor ID="htmlEditorNote" runat="server" Height="160" ClientInstanceName="htmlEditor">
                    <SettingsImageUpload>
                        <ValidationSettings AllowedContentTypes="image/jpeg,image/pjpeg,image/gif,image/png,image/x-png"></ValidationSettings>
                    </SettingsImageUpload>
                    <SettingsDialogs>
                        <InsertImageDialog>
                            <SettingsImageUpload>
                                <ValidationSettings AllowedContentTypes="image/jpeg, image/pjpeg, image/gif, image/png, image/x-png">
                                </ValidationSettings>
                            </SettingsImageUpload>
                        </InsertImageDialog>
                    </SettingsDialogs>
                </dx:ASPxHtmlEditor>
            </td>
            <td>
                <dx:ASPxButton ID="btnNoteOk" runat="server" Text="Ok" />
                <br />
                <br />
                <dx:ASPxButton ID="btnNoteCancel" runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false">
                    <ClientSideEvents Click="function(s, e) {ShowHideNoteForm('Hide');}" />
                </dx:ASPxButton>
            </td>
        </tr>
    </table>
</div>

<div id="divEntityNotesUserControl" style="margin-left: 40px; margin-bottom: 40px; width: 1500px; clear: left;">
    <uc1:EntityNotesUserControl runat="server" id="EntityNotesUserControl" />
</div>
