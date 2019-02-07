<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RtvToRma.aspx.cs" Inherits="RtvToRma" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblPassword" runat="server" Text="Operator Password: "></asp:Label>
            <asp:TextBox ID="tbxOperatorPassword" TextMode="Password" runat="server"></asp:TextBox>
        </div>
        <div>
            <asp:DropDownList ID="ddlRtvShipper" runat="server" DataSourceID="TroyDataSource" DataTextField="id"/>
            <asp:Button ID="btnRun" runat="server" Text="Generate RMA" OnClick="btnRun_Clicked"/>

            <asp:SqlDataSource 
                ID="TroyDataSource" 
                runat="server"          
                ConnectionString="Data Source=eeisql1.empireelect.local;Initial Catalog=MONITOR;persist security info=True;User ID=Andre"
                SelectCommand="select id from shipper where type = 'V' and status = 'S'">
            </asp:SqlDataSource>
        </div>
        <div>
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </div>
    </form>
</body>
</html>
