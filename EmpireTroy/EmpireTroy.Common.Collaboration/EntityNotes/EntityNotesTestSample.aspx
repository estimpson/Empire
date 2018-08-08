<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EntityNotesTestSample.aspx.cs" Inherits="EmpireTroy.Common.Collaboration.EntityNotes.EntityNotesTestSample" %>

<%@ Register Src="~/EntityNotes/EntityNotesUserControl.ascx" TagPrefix="uc1" TagName="EntityNotesUserControl" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <uc1:EntityNotesUserControl runat="server" ID="EntityNotesUserControl" />
        </div>
    </form>
</body>
</html>
