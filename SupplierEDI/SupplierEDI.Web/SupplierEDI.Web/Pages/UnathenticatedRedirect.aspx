<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UnathenticatedRedirect.aspx.cs" Inherits="PartTracker.Pages.UnathenticatedRedirect" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Access Denied</title>
    <link href="~/Styles/Login.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="box">
            <div class="content">
                <asp:Image ID="iLogo" runat="server" ImageUrl="~/Images/logo2.png" /><br /><br />
                <dx:ASPxLabel ID="lblError" runat="server" CssClass="lbl" Text="You must be logged in to view this page."></dx:ASPxLabel>
            </div>
        </div>

    </form>
</body>
</html>
