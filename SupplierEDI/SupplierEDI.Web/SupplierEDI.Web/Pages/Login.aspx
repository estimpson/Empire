<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SupplierEDI.Web.Pages.Login" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Empire Web Portal Login</title>
    <link href="~/Styles/Login.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/jquery-3.2.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function pageLoad() {
            $(function () {
            });
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>


        <dx:ASPxLoadingPanel ID="ldnPanel" ClientInstanceName="ldnPanel" runat="server" Modal="true" ContainerElementID="Box"></dx:ASPxLoadingPanel>

        <div id="Box" class="box">
            <div class="content">

                <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/logo2.png" /><br /><br />

                <dx:ASPxTextBox ID="tbxUser" runat="server" CssClass="ctl" Width="170px" NullText="User Name"></dx:ASPxTextBox><br />
                <dx:ASPxTextBox ID="tbxPWord" runat="server" CssClass="ctl" Width="170px" NullText="Password" Password="true"></dx:ASPxTextBox><br />
                <dx:ASPxButton ID="btnLogin" runat="server" CssClass="ctl" Width="120" Text="Log In" OnClick="btnLogin_Click">
                    <ClientSideEvents Click="function(s, e) {ldnPanel.Show(); e.processOnServer = true;}" />
                </dx:ASPxButton><br /><br />
                <dx:ASPxCheckBox ID="cbxRememberUser" runat="server" CssClass="ctl" Text="Remember Me" OnCheckedChanged="cbxRememberUser_CheckedChanged"></dx:ASPxCheckBox><br /><br />
                <dx:ASPxLabel ID="lblError" runat="server" CssClass="lbl" Text=""></dx:ASPxLabel>
            </div>
        </div>    

        </ContentTemplate>
        </asp:UpdatePanel>
        
    </form>
</body>
</html>
