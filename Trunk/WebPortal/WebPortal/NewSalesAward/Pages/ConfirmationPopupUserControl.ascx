<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConfirmationPopupUserControl.ascx.cs" Inherits="WebPortal.NewSalesAward.Pages.ConfirmationPopupUserControl" %>

<div id="ConfirmationPopupContainer">
    <script>
        var Affirmative = false;
        var PromptSender;
        var YesCallback;
        var NoCancelCallback;

        function ConfirmationPrompt(s, yCB, nCB, t, p ) {
            PromptSender = s;
            YesCallback = yCB;
            NoCancelCallback = nCB;
            ConfirmationPopup.SetHeaderText(t);
            PromptLabel.SetText(p);
            ConfirmationPopup.Show();
        }

        function OnConfirmationClose(s, e) {
            if (Affirmative) {
                if (typeof YesCallback === "function") {
                    YesCallback();
                }
            } else {
                if (typeof NoCancelCallback === "function") {
                    NoCancelCallback();
                }
            }
        }
    </script>
    <dx:ASPxPopupControl ID="ConfirmationPopup" ClientInstanceName="ConfirmationPopup" runat="server"
                         PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                         Modal="True" PopupAnimationType="Fade">
        <ClientSideEvents
            CloseUp="OnConfirmationClose" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" ColCount="2">

                    <Items>
                        <dx:LayoutItem ColSpan="2" ShowCaption="False">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxLabel ID="PromptLabel" ClientInstanceName="PromptLabel" runat="server">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:EmptyLayoutItem>
                        </dx:EmptyLayoutItem>
                        <dx:LayoutItem ShowCaption="False">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <table style="margin-top: 50px">
                                        <script>
                                            function OnYesClick(s, e) {
                                                console.log("y");
                                                Affirmative = true;
                                                ConfirmationPopup.Hide();
                                            }

                                            function OnNoClick(s, e) {
                                                console.log("n");
                                                ConfirmationPopup.Hide();
                                            }
                                        </script>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton Text="Yes" runat="server" AutoPostBack="False">
                                                    <ClientSideEvents Click="OnYesClick" />
                                                </dx:ASPxButton>
                                            </td>
                                            <td>
                                                <dx:ASPxButton Text="No" runat="server" AutoPostBack="False">
                                                    <ClientSideEvents Click="OnNoClick" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                    </Items>

                </dx:ASPxFormLayout> 
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</div>