<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master"  CodeBehind="FixAwardedQuote.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.FixAwardedQuote" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Fix Awarded Quote"></asp:Label>
</asp:Content>



<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">



    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true"></dx:ASPxLoadingPanel>

    <dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
        <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent ID="pc1" runat="server">


                <asp:UpdatePanel ID="updatePnl" runat="server">
                <ContentTemplate>


                <div id="divMain" runat="server">
                    <table class="tbl">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblOldQuoteNumber" runat="server" Text="Old Quote Number:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxOldQuoteNumber" runat="server" ReadOnly="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblNewQuoteNumber" runat="server" Text="New Quote Number:" />
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" ClientInstanceName="cbxQuoteNumber" EnableCallbackMode="true" CallbackPageSize="10" 
                                    ValidateRequestMode="Disabled" ValueType="System.String" ValueField="QuoteNumber" ValidationSettings-CausesValidation="false"
                                    OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                    TextFormatString="{0}  {1}  {2}"
                                    Width="298px" DropDownStyle="DropDown" TabIndex="0">
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="QuoteNumber" />
                                        <dx:ListBoxColumn FieldName="EEIPartNumber" />
                                        <dx:ListBoxColumn FieldName="Program" />
                                    </Columns>
                                    <ValidationSettings CausesValidation="false"></ValidationSettings>
                                </dx:ASPxComboBox>

                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <dx:ASPxButton ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                            </td>
                        </tr>
                    </table>
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