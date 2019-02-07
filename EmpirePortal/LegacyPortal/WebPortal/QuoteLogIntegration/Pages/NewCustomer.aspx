<%@ Page Title="NewCustomer" Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="NewCustomer.aspx.cs" Inherits="WebPortal.QuoteLogIntegration.Pages.NewCustomer" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

<script type="text/javascript">

        function pageLoad() {
            $(function () {
            });
        }

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
    <asp:Label ID="lblTitle" runat="server" Text="New Customer Approval"></asp:Label>
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

              
                <div id="divCustomer" runat="server" style="border: 0px solid black; margin-bottom: 0px;">

                    <dx:ASPxRoundPanel ID="rPnl" runat="server" BackColor="#ffffff" HeaderText="" Width="98%">
                    <PanelCollection>
                        <dx:PanelContent ID="pc2" runat="server">

                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblCustomer" runat="server" Text="Customer:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxCustomer" runat="server" ReadOnly="true"></dx:ASPxTextBox>
                                </td>
                                <td style="margin-left: 20px;">
                                    <dx:ASPxLabel ID="lblCustomerNote" runat="server" Text="Reason for denial:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxCustomerNote" runat="server" Width="350"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnApproveCustomer" runat="server" Text="Approve" OnClick="btnApproveCustomer_Click"></dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnDenyCustomer" runat="server" Text="Deny" OnClick="btnDenyCustomer_Click"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                        </dx:PanelContent>
                    </PanelCollection>
                    </dx:ASPxRoundPanel>

                </div>


                <div>
                    <dx:ASPxGridView ID="gvCustomers" runat="server" ClientInstanceName="gvCustomers" AutoGenerateColumns="False" Width="98%" 
                        DataSourceID="ObjectDataSource1" OnFocusedRowChanged="gvCustomers_FocusedRowChanged" EnableCallBacks="false">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="2px" PaddingBottom="2px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewDataTextColumn Caption="Customer Code" FieldName="CustomerCode" Name="CustomerCode" VisibleIndex="0" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Customer Name" FieldName="CustomerName" Name="CustomerName" VisibleIndex="1" Width="140" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Address1" FieldName="Address1" Name="Address1" VisibleIndex="2" Width="200" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Address2" FieldName="Address2" Name="Address2" VisibleIndex="3" Width="200" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Address3" FieldName="Address3" Name="Address3" VisibleIndex="4" Width="200" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="City" FieldName="City" Name="City" VisibleIndex="5" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="State" FieldName="State" Name="State" VisibleIndex="6" Width="60" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Country" FieldName="Country" Name="Country" VisibleIndex="7" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Postal Code" FieldName="PostalCode" Name="PostalCode" VisibleIndex="8" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Terms" FieldName="Terms" Name="Terms" VisibleIndex="9" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="LTA Type" FieldName="LtaType" Name="LtaType" VisibleIndex="10" Width="120" Visible="true" />
                            <dx:GridViewDataTextColumn Caption="Requestor" FieldName="Requestor" Name="Requestor" VisibleIndex="11" Width="120" Visible="true" />
                        </Columns>
                        <ClientSideEvents FocusedRowChanged="function(s, e) {
                            btnHidFocusedRow.DoClick();
                        }" />

                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsPager PageSize="20"></SettingsPager>
                    </dx:ASPxGridView>

                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetCustomerRequests" TypeName="WebPortal.QuoteLogIntegration.PageViewModels.NewCustomerViewModel"
                        DataObjectTypeName="WebPortal.QuoteLogIntegration.Models.usp_Web_QuoteLog_NewCustomer__GetRequests_Result"></asp:ObjectDataSource>
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
