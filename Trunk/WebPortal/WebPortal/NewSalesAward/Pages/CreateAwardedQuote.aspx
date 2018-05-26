<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master"  CodeBehind="CreateAwardedQuote.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.CreateAwardedQuote" %>

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
    <asp:Label ID="lblTitle" runat="server" Text="Create Awarded Quote"></asp:Label>
</asp:Content>



<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true"></dx:ASPxLoadingPanel>

    <dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
        <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent ID="pc1" runat="server">


                <asp:UpdatePanel ID="updatePnl" runat="server">
                <ContentTemplate>

              
                <div id="divMain" runat="server" style="border: 0px solid black; margin-bottom: 0px;">

                    <table class="tbl">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblQuoteNumber" runat="server" Text="Quote:" Width="138"></dx:ASPxLabel>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cbxQuoteNumber" runat="server" 
                                    EnableCallbackMode="true" CallbackPageSize="10"
                                    ValueType="System.String" ValueField="QuoteNumber"
                                    OnItemsRequestedByFilterCondition="cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL"
                                    OnItemRequestedByValue="cbxQuoteNumber_OnItemRequestedByValue_SQL" TextFormatString="{0}  {1}  {2}"
                                    Width="270px" DropDownStyle="DropDown"
                                    OnSelectedIndexChanged="cbxQuoteNumber_SelectedIndexChanged" AutoPostBack="true" TabIndex="0">
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="QuoteNumber" />
                                        <dx:ListBoxColumn FieldName="EEIPartNumber" />
                                        <dx:ListBoxColumn FieldName="Program" />
                                    </Columns>
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxComboBox>

                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" />
                            </td>
                        </tr>
                    </table>

                    <asp:Panel ID="pnlQuoteDetails" runat="server">
                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblAwardDate" runat="server" Text="Award Date:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxDateEdit ID="deAwardDate" runat="server" TabIndex="1" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxDateEdit>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblFormOfCommitment" runat="server" Text="Form of Commitment:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxFormOfCommitment" runat="server" ReadOnly="false" TabIndex="2" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblQuoteReason" runat="server" Text="QuoteReason:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxQuoteReason" runat="server" OnSelectedIndexChanged="cbxQuoteReason_SelectedIndexChanged" AutoPostBack="true" TabIndex="3" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblReplacingBasePart" runat="server" Text="Replacing BasePart:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxReplacingBasePart" runat="server" TabIndex="4" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblSalesperson" runat="server" Text="Salesperson:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxSalesperson" runat="server" TabIndex="5" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblProgramManager" runat="server" Text="Program Manager:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cbxProgramManager" runat="server" TabIndex="6" Width="220">
                                        <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblComments" runat="server" Text="Comments:"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxMemo ID="memoComments" runat="server" Width="420" Height="80" TabIndex="7"></dx:ASPxMemo>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" TabIndex="8"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                    </asp:Panel>

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
                </asp:UpdatePanel>



                    <asp:Panel ID="pnlUploadDoc" runat="server">
                        <table class="tbl">
                            <tr>
                                <td colspan="3">
                                    <dx:ASPxLabel ID="lblDocSectionTitle" runat="server" Text="Upload Customer Commitment Document" Font-Size="15" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxTextBox ID="tbxDocName" runat="server" />
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnDocSave" runat="server" Text="Save" OnClick="btnDocSave_Click"></dx:ASPxButton>
                                </td>
                                    <td>
                                    <dx:ASPxButton ID="btnDocDelete" runat="server" Text="Delete" OnClick="btnDocDelete_Click"></dx:ASPxButton>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnDocGet" runat="server" Text="Get" OnClick="btnDocGet_Click"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
              


                <div>
                    <dx:ASPxPopupControl ID="pcFileUpload" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="false" Modal="True"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcFileUpload"
                        HeaderText="File Upload" AllowDragging="True" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <div style="padding: 10px 20px 20px 20px;">

                                    <asp:FileUpload id="FileUploadControl" runat="server" BackColor="White" />
                                    <br /><br />

                                    <asp:Button ID="btnUpload" runat="server" Text="Upload" UseSubmitBehavior="false" OnClick="btnUpload_Click" />
                                    <br /><br />

                                    <dx:ASPxLabel ID="lblUploadStatus" runat="server" Text=""></dx:ASPxLabel>

                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </div>



            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>

</asp:Content>