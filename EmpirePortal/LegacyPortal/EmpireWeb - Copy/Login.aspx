<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="CSS/StyleSheet.css" />
    
    <style type="text/css">
        A:link { text-decoration: none;color: #383838;}
        A:visited { text-decoration: none;color: #383838;}
        A:active { text-decoration: none;color: #383838;}
        A:hover {text-decoration: none; color: #ffffff;}
</style>
</head>
<body>
    <form id="form1" runat="server">

        <div style="background-image: url(Images/Welcome.png); background-color: #000000; height: 405px; width: 565px; margin: 30px auto 0 auto;">
            
            <asp:Login ID="Login2" runat="server" OnLoggedIn="Login2_LoggedIn">
                <LayoutTemplate>
                    <div style="margin: 160px 0 0 50px;">
                    <table style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table style="font-family: Calibri; font-size: 20px; color: #000000;">
                                    <tr>
                                        <td style="width: 110px; padding-left: 20px;">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="UserName" runat="server" Width="220"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login2">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px; padding-left: 20px;">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="220"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login2">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="Login2" BackColor="#ffffff" Width="65" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                        
                    </div>
                </LayoutTemplate>
            </asp:Login>
            
            
            <div style="font-family: Calibri; font-size: 15px; color: #ffffff; margin-top: 15px; margin-left: 70px; width: 410px;">
                <div>
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="Account/Register.aspx">Create New User</asp:HyperLink>   
                </div>    
                <div>
                    <asp:LinkButton ID="lbtnForgotPassword" runat="server" OnClick="lbtnForgotPassword_Click">Forgot Password</asp:LinkButton>
                </div>

                <div id="divPasswordRecovery" runat="server" Visible="False">
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="Email Address:"></asp:Label>
                                &nbsp;
                                <asp:TextBox ID="tbxEmail" runat="server" Width="215"></asp:TextBox>
                                &nbsp;
                                <asp:Button ID="btnRecoverPassword" runat="server" Text="Recover" BackColor="#ffffff" OnClick="btnRecoverPassword_Click" />
                                <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="Black" Font-Size="10"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
            

        </div>
    </form>
</body>
</html>
