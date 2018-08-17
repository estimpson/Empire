<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NSAEditPopupContents.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.NSAEditPopupContents" %>
<%@ Register TagPrefix="uc1" TagName="NSACustomerPOTabView" Src="~/NewSalesAward/Pages/NSACustomerPOTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSAHardToolingTabView" Src="~/NewSalesAward/Pages/NSAHardToolingTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSAToolingAmortizationTabView" Src="~/NewSalesAward/Pages/NSAToolingAmortizationTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSATesterToolingTabView" Src="~/NewSalesAward/Pages/NSATesterToolingTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSABasePartAttributesTabView" Src="~/NewSalesAward/Pages/NSABasePartAttributesTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSABasePartMnemonicsTabView" Src="~/NewSalesAward/Pages/NSABasePartMnemonicsTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="NSALogisticsTabView" Src="~/NewSalesAward/Pages/NSALogisticsTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="QuoteTabView" Src="~/NewSalesAward/Pages/QuoteTabView.ascx" %>
<%@ Register TagPrefix="uc1" TagName="EntityNotesUserControl" Src="~/NewSalesAward/Pages/EntityNotesUserControl.ascx" %>

<script>
    var postponedCallbackRequired = false;

    function OnSaveAllClicked (s, e) {
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

    function OnEditControl_GotFocus (s, e) {
        var input = s.GetInputElement();
        var uri = $(input).attr("EntityURI");

        FilterEntityNotesUserControl(uri);
    }

    function OnActiveTabChanged (s, e) {
        var tab = e.tab;
        var uri = 'EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=' + QuoteNumberHiddenField.Get("QuoteNumber");

        switch (tab.index) {
            case 0:
                uri += '/Quote';
                break;
            case 1:
                uri += '/AwardedQuoteProductionPOs';
                break;
            case 2:
                uri += '/AwardedQuoteToolingPOs';
                break;
            case 3:
                uri += '/AwardedQuoteToolingPOs';
                break;
            case 4:
                uri += '/AwardedQuoteToolingPOs';
                break;
            case 5:
                uri += '/BasePartAttributes';
                break;
            case 6:
                uri += '/BasePartMnemonics';
                break;
            case 7:
                uri += '/AwardedQuoteLogistics';
                break;
        };
        FilterEntityNotesUserControl(uri);
    }

    function OnHeaderClick(s, e) {
        FilterEntityNotesUserControl('EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=' +
            QuoteNumberHiddenField.Get("QuoteNumber"));
    }

    function RegisterURI(s, f) {
        var input = s.GetInputElement();
        var uri = 'EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=' +
            QuoteNumberHiddenField.Get("QuoteNumber") +
            '/' +
            f;
        $(input).attr("EntityURI", uri);
    }
</script>

<dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="NSAEditCallbackPanel" runat="server" OnCallback="NSAEditCallback_OnCallback">
    <ClientSideEvents EndCallback="OnEndNSAEditCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxHiddenField runat="server" ID="QuoteNumberHiddenField" ClientInstanceName="QuoteNumberHiddenField"/>
            <dx:ASPxFormLayout ID="NSAEditFormLayout" ClientInstanceName="editFormLayout" runat="server" ColCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Base Part" ShowCaption="False" FieldName="BasePart">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxLabel runat="server" Font-Size="14" ForeColor="#007bf7" OnDataBound="OnDataBound" OnDataBinding="OnDataBinding">
                                    <ClientSideEvents Click="OnHeaderClick"></ClientSideEvents>
                                </dx:ASPxLabel>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False" HorizontalAlign="Right">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxButton ID="SaveAllButton" runat="server" AutoPostBack="False" Text="Save All">
                                    <ClientSideEvents Click="OnSaveAllClicked"></ClientSideEvents>
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem ShowCaption="False" ColSpan="2">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:ASPxPageControl runat="server" ID="NSAEditPageControl" Width="100%" ActiveTabIndex="0">
                                    <ClientSideEvents
                                        ActiveTabChanged="OnActiveTabChanged"
                                        />
                                    <TabPages>
                                        <dx:TabPage Text="Quote" Visible="true">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    

                                                  <uc1:QuoteTabView runat="server" id="QuoteTabView" />


                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>

                                        <dx:TabPage Text="Customer PO" Visible="True">
                                            <ContentCollection>
                                                <dx:ContentControl runat="server">
                                                    <uc1:NSACustomerPOTabView runat="server" id="NSACustomerPOTabView" />
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
            <dx:ASPxLabel runat="server" ID="EntityURI" ClientInstanceName="EntityURI"/>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>

<div id="divEntityNotesUserControl" style="border-top: 2px solid darkorange; margin-left: 40px; width: 1500px; clear: left; margin-top: 10px;">
    <table>
        <tr>
            <td>
                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Notes / Comments / Screenshots" Font-Size="13" ForeColor="DarkOrange" />
            </td>
        </tr>
        <tr>
            <uc1:EntityNotesUserControl runat="server" id="EntityNotesUserControl" />
        </tr>
    </table>
</div>
