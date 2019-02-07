<%@ Page Title="Empire Electronics" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="OBS_Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <%--Framework scripts--%>
            <asp:ScriptReference Name="MsAjaxBundle" />
            <asp:ScriptReference Name="jquery" />
            <asp:ScriptReference Name="jquery.ui.combined" />
            <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
            <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
            <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
            <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
            <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
            <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
            <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
            <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
            <asp:ScriptReference Name="WebFormsBundle" />
            <%--Site scripts--%>
        </Scripts>
    </asp:ScriptManager>
        
        
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script>
        $(document).ready(function () {
            $("#divProfileLabel").click(function () {
                $("#divProfile").slideToggle("slow");
            });
        });
    </script>


    <div id="divProfileLabel" style="margin-top: 3px; color: #808080;">
        <asp:Label ID="lblProfile" runat="server"></asp:Label>    
    </div>

    <div id="divProfile" style="display: none;">
        <table>
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="First Name:" />
                </td>
                <td>
                    <asp:TextBox ID="tbxFirstName" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="tbxFirstName" >*</asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label ID="Label2" runat="server" Text="Last Name:" />
                </td>
                <td>
                    <asp:TextBox ID="tbxLastName" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="tbxLastName">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    <telerik:RadButton ID="btnSave" runat="server" Text="Save" OnClick="btnSave_OnClick" />
                </td>
            </tr>
        </table>       
    </div>

</asp:Content>
  