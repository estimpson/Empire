﻿<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PFAMenu.aspx.cs" Inherits="PremiumFreightRequestA" Title="Premium Freight Menu" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxEditors" Assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>
<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxPanel" tagprefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server"> 

	
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server" CdnSettings-TelerikCdn="Enabled">
		    <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
			    <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
			    <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />    
		    </Scripts>
	    </telerik:RadScriptManager>
                             
        Empire Electronics Premium Freight Tracking
        <br />
        <br />
          
        <telerik:RadPanelBar ID="RadPanelBar1" Runat="server" Height="750px" Width="100%" ExpandMode="SingleExpandedItem" AllowCollapseAllItems="true" Skin="Metro">
            <Items>
                <telerik:RadPanelItem runat="server" Text="Create New Premium Freight Authorization"  Expanded="true" Height="35px" Font-Size="20px"  PostBack="False">
                    <ContentTemplate>                            
                        <table style="width:100%"> 
                            <tr>
                                <td colspan="3" style="font-style:italic" ><br />Enter the person requesting the Premium Freight Authorization and the date of the request</td>
                            </tr>
                            <tr>
                                <td style="width:150px">PFA Requested By:</td>
                                <td style="width:300px" colspan="2"> 
                                    <telerik:RadTextBox ID="RadTextBox1" runat="server" Width="200px" Skin="Metro" />
                                </td>
                                <td>
                                </td>
                                </tr>
                            <tr>
                            <td style="width:150px">Date of PFA Request: </td>
                            <td style="width:300px" colspan="2">
                                <telerik:RadDatePicker ID="RadDatePicker1" Runat="server"  Width="200px" Culture="en-US" Skin="Metro">
                                    <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" EnableKeyboardNavigation="True" CalendarTableStyle-BackColor="White" DayNameFormat="Short" FirstDayOfWeek="Monday" />
                                    <DateInput runat="server" DisplayDateFormat="MM/dd/yyyy"  LabelWidth="40%" />
                                    <DatePopupButton runat="server" />
                                </telerik:RadDatePicker>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="height:10px"></td>
                            </tr>
                            <tr >
                                <td></td>
                                <td style="width:150px">
                                <telerik:RadButton ID="RadButton2" 
                                    runat="server" 
                                    Text="Next" 
                                    ButtonType="SkinnedButton" 
                                    Skin="Metro"  
                                    AutoPostBack="true"
                                    Icon-SecondaryIconCssClass="rbNext" 
                                    NavigateUrl="PFA.aspx"
                                    Targer="_blank"
                                    OnClick="RadButton2_Click" 
                                    CausesValidation= "false">

                                </telerik:RadButton>
                                    <asp:SqlDataSource  ID="SqlDataSourceNewPFA" 
                                                        runat="server" 
                                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                                        InsertCommand="eeiuser.freight_insert_pfa" 
                                                        InsertCommandType="StoredProcedure" >
                                        <InsertParameters>
                                            <asp:ControlParameter Name="pfa_date"   ControlID="RadDatePicker1"  PropertyName="SelectedDate" Type="Datetime" />
                                            <asp:ControlParameter Name="requestor"  ControlID="RadTextBox1"     PropertyName="Text"         Type="String" />
                                        </InsertParameters>
                                    </asp:SqlDataSource>
                                    </td>
                                <td></td>
                                </tr>
                            <tr>
                                <td colspan="3" style="height:45px" ></td>
                            </tr>
                            </table>
                        </ContentTemplate>
                </telerik:RadPanelItem>
                <telerik:RadPanelItem runat="server" Text="Lookup Existing Premium Freight Authorization" Expanded="true" Height="35px" Font-Size="20px" PostBack="false">  
                    <ContentTemplate> 
                        <table style="width:150px"> 
                            <tr>
                                <td colspan="3" style="font-style:italic"><br />Select a field to search by and enter the value to search into the search box</td>
                            </tr>
                            <tr>
                                <td style="width:200px">
                            <telerik:RadComboBox ID="RadComboBox1" Runat="server" Width="200px">
                            <Items>
                                <telerik:RadComboBoxItem runat="server" Selected="True" Text="Tracking Number" Value="Tracking_Number" />
                                <telerik:RadComboBoxItem runat="server" Text="Sendor" Value="Sendor_Name" />
                                <telerik:RadComboBoxItem runat="server" Text="Recipient" Value="Recipient_Name" />
                                <telerik:RadComboBoxItem runat="server" Text="Date Shipped" Value="Date_Shipped" />
                            </Items>
                            </telerik:RadComboBox>
                                    </td>
                                <td ></td>
                                <td></td>
                                </tr>
                            <tr>
                                <td style="width:923px">
                            <telerik:RadAutoCompleteBox ID="RadAutoCompleteBox1" Skin="Metro" runat="server" DataSourceID="SqlDataSourcePFAMenu" DataTextField="TRACKING_NUMBER" DataValueField="TRACKING_NUMBER" DropDownWidth="950px" DropDownHeight="350px" EmptyMessage="Search Now" Font-Size="15px" InputType="Text"  TextSettings-SelectionMode="Single" Width="100%">
                           
                                <DropDownItemTemplate>
                                  
                                    <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td headers="true" title="Tracking Number" width="150px"><%# DataBinder.Eval(Container.DataItem, "Tracking_Number") %></td>
                                        <td headers="true" title="Date" width="100px"><%# DataBinder.Eval(Container.DataItem, "PFA_Date","{0:d}") %></td>
                                        <td headers="true" title="From" width="250px"><%# DataBinder.Eval(Container.DataItem, "From_Name") %></td>
                                        <td headers="true" title="To" width="250px"><%# DataBinder.Eval(Container.DataItem, "To_Name") %></td>
                                        <td headers="true" title="Parts Shipped" width="200px"><%# DataBinder.Eval(Container.DataItem, "Part") %></td>
                                    </tr>
                                </table>
                            </DropDownItemTemplate>
                            </telerik:RadAutoCompleteBox> 

                            <asp:SqlDataSource ID="SqlDataSourcePFAMenu" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" SelectCommand="SELECT * FROM [eeiuser].[Freight_PFA] order by tracking_number ">
                            </asp:SqlDataSource>
                                    </td>
                                <td style="width:25px">
                                 <telerik:RadButton ID="RadButton1" runat="server" Height="25px" Width="25px" Image-ImageUrl="~/Images/SearchIcon.png"   >
                                 </telerik:RadButton>
                                    </td>
                                <td>

                                </td>
                                </tr>
                            <tr style="height:360px">
                            <td colspan="3"></td>
                            </tr>
                        </table>  

                    </ContentTemplate>
                </telerik:RadPanelItem>
            </Items>
        </telerik:RadPanelBar>    

</asp:Content>
