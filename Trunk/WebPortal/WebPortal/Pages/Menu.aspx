<%@ Page Title="Menu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="WebPortal.Pages.Menu" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-right: 0; margin-left: 0; margin-top: 100px">
        <dx:ASPxLabel ID="lblMessage" runat="server" Text="Logged in.  Select a page."></dx:ASPxLabel>
    </div>

</asp:Content>
