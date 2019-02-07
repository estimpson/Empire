<%@ Page Title="MarketSegmentSubsegment" Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="MarketSegmentSubsegment.aspx.cs" Inherits="WebPortal.QuoteLogIntegration.Pages.MarketSegmentSubsegment" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

<script type="text/javascript">

        function pageLoad() {
            $(function () {
                //updateGridHeight();
            });
        }

        //function updateGridHeight() {
        //    gvSalesForecastUpdated.SetHeight(0);

        //    var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

        //    gvSalesForecastUpdated.SetHeight(containerHeight - 130);
        //}

        var postponedCallbackRequired = false;
        function OnComboBoxIndexChanged(s, e) {
            if (CallbackPanel.InCallback())
                postponedCallbackRequired = true;
            else
                CallbackPanel.PerformCallback();
        }
        function OnEndCallback(s, e) {
            if (postponedCallbackRequired) {
                CallbackPanel.PerformCallback();
                postponedCallbackRequired = false;
            }
        }

    </script>

</asp:Content>



<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Empire Market Segment / Subsegment Approval"></asp:Label>
</asp:Content>



<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true">
        </dx:ASPxLoadingPanel>

    <dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
    <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent ID="pc1" runat="server">


            <asp:UpdatePanel ID="updatePnl" runat="server">
            <ContentTemplate>

              
                <div id="divEditSegment" runat="server" style="border: 0px solid black; margin-bottom: 0px;">

                    <dx:ASPxRoundPanel ID="rPnl" runat="server" BackColor="#ffffff" HeaderText="" Width="98%">
                    <PanelCollection>
                        <dx:PanelContent ID="pc2" runat="server">

                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblSegment" runat="server" Text="Segment:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxSegment" runat="server" ReadOnly="true"></dx:ASPxTextBox>
                                </td>
                                <td style="margin-left: 20px;">
                                    <dx:ASPxLabel ID="lblSegmentNote" runat="server" Text="Note / Reason:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxSegmentNote" runat="server" Width="350"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnApproveSegment" runat="server" Text="Approve" OnClick="btnApproveSegment_Click"></dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnDenySegment" runat="server" Text="Deny" OnClick="btnDenySegment_Click"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                        </dx:PanelContent>
                    </PanelCollection>
                    </dx:ASPxRoundPanel>

                </div>


                <div>
                    <dx:ASPxGridView ID="gvSegments" runat="server" ClientInstanceName="gvSegments" AutoGenerateColumns="False" Width="98%" 
                        DataSourceID="ObjectDataSource1" OnFocusedRowChanged="gvSegments_FocusedRowChanged" EnableCallBacks="false">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="2px" PaddingBottom="2px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewDataTextColumn Caption="Empire Market Segment" FieldName="EmpireMarketSegment" Name="EmpireMarketSegment" VisibleIndex="0" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Status" FieldName="ApprovalStatus" Name="ApprovalStatus" VisibleIndex="1" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Requestor" FieldName="Requestor" Name="Requestor" VisibleIndex="2" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Requestor Note" FieldName="RequestorNote" Name="RequestorNote" VisibleIndex="3" Width="200" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Response Note" FieldName="ResponseNote" Name="ResponseNote" VisibleIndex="4" Width="200" Visible="true" />
                        </Columns>
                        <ClientSideEvents FocusedRowChanged="function(s, e) {
                            btnHidFocusedRow.DoClick();
                        }" />

                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsPager PageSize="20"></SettingsPager>
                    </dx:ASPxGridView>

                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetSegments" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.MarketSegmentSubsegmentViewModel"
                        DataObjectTypeName="WebPortal.QuoteLogIntegration.Models.usp_Web_EmpireMarketSegment_Result"></asp:ObjectDataSource>
                </div>




                <div id="divEditSubsegment" runat="server" style="border: 0px solid black; margin-top: 40px;">

                    <dx:ASPxRoundPanel ID="rPnl2" runat="server" BackColor="#ffffff" HeaderText="" Width="98%">
                    <PanelCollection>
                        <dx:PanelContent ID="pc3" runat="server">

                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblSubsegment" runat="server" Text="Segment:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxSubsegment" runat="server" ReadOnly="true"></dx:ASPxTextBox>
                                </td>
                                <td style="margin-left: 20px;">
                                    <dx:ASPxLabel ID="lblSubsegmentNote" runat="server" Text="Note / Reason:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxSubsegmentNote" runat="server" Width="350"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnApproveSubsegment" runat="server" Text="Approve" OnClick="btnApproveSubsegment_Click"></dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnDenySubsegment" runat="server" Text="Deny" OnClick="btnDenySubsegment_Click"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                        </dx:PanelContent>
                    </PanelCollection>
                    </dx:ASPxRoundPanel>

                </div>


                <div>
                    <dx:ASPxGridView ID="gvSubsegments" runat="server" ClientInstanceName="gvSubsegments" AutoGenerateColumns="False" Width="98%" 
                        DataSourceID="ObjectDataSource2" OnFocusedRowChanged="gvSubsegments_FocusedRowChanged" EnableCallBacks="false">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="2px" PaddingBottom="2px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewDataTextColumn Caption="Empire Market Subsegment" FieldName="EmpireMarketSubsegment" Name="EmpireMarketSubsegment" VisibleIndex="0" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Status" FieldName="ApprovalStatus" Name="ApprovalStatus" VisibleIndex="1" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Requestor" FieldName="Requestor" Name="Requestor" VisibleIndex="2" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Requestor Note" FieldName="RequestorNote" Name="RequestorNote" VisibleIndex="3" Width="200" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Response Note" FieldName="ResponseNote" Name="ResponseNote" VisibleIndex="4" Width="200" Visible="true" />
                        </Columns>
                        <ClientSideEvents FocusedRowChanged="function(s, e) {
                            btnHidFocusedRow.DoClick();
                        }" />

                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsPager PageSize="20"></SettingsPager>
                    </dx:ASPxGridView>

                    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" SelectMethod="GetSubsegments" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.MarketSegmentSubsegmentViewModel"
                        DataObjectTypeName="WebPortal.QuoteLogIntegration.Models.usp_Web_EmpireMarketSubsegment_Result"></asp:ObjectDataSource>
                </div>





                <div style="display: none;">
                    <dx:ASPxButton ID="btnHidFocusedRow" ClientInstanceName="btnHidFocusedRow" runat="server" AutoPostBack="false" OnClick="btnHidFocusedRow_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
                </div>

                <div>
                    <dx:ASPxPopupControl ID="pcError" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcError"
                        HeaderText="Error Message" AllowDragging="True" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <div style="padding: 10px 20px 20px 20px;">
                                    <dx:ASPxLabel ID="lblError" runat="server" Text=""></dx:ASPxLabel>
                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </div>


            </ContentTemplate>
                <Triggers>
                    
                </Triggers>
            </asp:UpdatePanel>


        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>



</asp:Content>