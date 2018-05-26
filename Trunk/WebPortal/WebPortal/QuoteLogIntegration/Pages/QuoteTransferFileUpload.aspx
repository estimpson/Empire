<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTransferFileUpload.aspx.cs" Inherits="WebPortal.QuoteLogIntegration.Pages.QuoteTransferFileUpload" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:FileUpload id="FileUploadControl" runat="server" BackColor="White" />
            <dx:ASPxButton ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click"></dx:ASPxButton>
            <br /><br />
            <dx:ASPxLabel ID="StatusLabel" runat="server" Text="Upload status:"></dx:ASPxLabel>
        </div>
    </form>
</body>
</html>
