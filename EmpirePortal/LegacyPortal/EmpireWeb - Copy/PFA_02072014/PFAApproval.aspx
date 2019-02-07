<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PFAApproval.aspx.cs" Inherits="PFAApproval" Title="Premium Freight Approval" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server"> 

    <telerik:RadScriptManager ID="RadScriptManager1" runat="server" CdnSettings-TelerikCdn="Enabled">
		<Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />    
		</Scripts>
	</telerik:RadScriptManager>
    

    <telerik:RadGrid ID="RadGrid1" runat="server">
        
    </telerik:RadGrid>
    
    <asp:SqlDataSource ID="SqlDataSourcePFAApproval" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" />
        
    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSourcePFAApproval" AutoGenerateColumns="false">
        <Columns> 
            <asp:TemplateField HeaderText="PFA ID">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ID="lbtnPFAID" Text='<%# Eval("PFA_ID") %>' PostBackUrl='<%# String.Format("PFA.aspx?Type=PFAID&amp;Value={0}",Eval("PFA_ID")) %>' />
                </ItemTemplate>
            </asp:TemplateField>
              
            <asp:BoundField DataField="FROM_NAME" HeaderText="Sender" ReadOnly="True"/>
            <asp:BoundField DataField="TO_NAME" HeaderText="Recipient" ReadOnly="True"/>
         
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="New">New</asp:ListItem>
                        <asp:ListItem Value="Approved">Approved</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
    <br/>
    <asp:Button runat="server" ID="btnCancel" Text="Cancel" OnClick="btnCancel_Clicked"/>
    <asp:Button runat="server" ID="btnSubmit" Text="Submit" OnClick="btnSubmit_Clicked"/>
    
    <asp:Label runat="server" ID="lblMessage" ForeColor="red"></asp:Label>
    
</asp:Content>

