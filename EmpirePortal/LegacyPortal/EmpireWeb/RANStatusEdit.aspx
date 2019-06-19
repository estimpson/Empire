﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RANStatusEdit.aspx.cs" Inherits="NALReview" %>

<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>



<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
        .style1
        {
            font-family: Verdana;
            font-size: small;
        }
        .style2
        {
            font-family: Verdana;
            font-size: medium;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
    <AjaxSettings>
        
    <telerik:AjaxSetting AjaxControlID="RadGrid3">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <span class="style2"><strong>NAL RAN Status Edit Form</strong></span><span class="style1">&nbsp;
            <br />
            <br />
            <dx:ASPxPanel ID="ASPxPanel1" runat="server" BackColor="#FFFFCC" Height="106px" 
                Width="1000px">
                <PanelCollection>
<dx:PanelContent runat="server" SupportsDisabledAttribute="True">
    <span class="style1">Use this form to edit the status of a NAL release.&nbsp;
    <br />
    <br />
    This should only be done if the release or release quantity received from NAL 
    via EDI was erroneous.&nbsp;<br />
    Setting the status to -1 (&quot;DISREGARD&quot;) will allow subsequent processing of the 
    862 EDI import to ignore the erroneous data.
    <br />
    <br />
    Status of 1 indicates current release and status of 2 indicates prior release</span></dx:PanelContent>
</PanelCollection>
                <Border BorderColor="#663300" BorderStyle="Solid" BorderWidth="2px" />
            </dx:ASPxPanel>
            <br />
            <br />
            Enter the Ran Number you wish to edit:</span>
            <telerik:RadTextBox ID="RadTextBox1" Runat="server" LabelWidth="64px" 
                ontextchanged="RadTextBox1_TextChanged" Width="160px" AutoPostBack="True" 
                EmptyMessage="RAN Number">
            </telerik:RadTextBox>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MonitorConnectionString %>" 
                SelectCommand="select -1 as status union select 2 as status union select 1 as status">
            </asp:SqlDataSource>
            <br />
            <br />
            <span class="style1">
            <strong>Releases Received for this RAN Number (by EDI processed date)</strong></span>
            <telerik:RadGrid ID="RadGrid3" ShowStatusBar="True" runat="server" 
                DataSourceID="SqlDataSource2" GridLines="None" Width="1000px" 
                CellSpacing="0" AllowSorting="True" EnableHeaderContextMenu="True" 
                AllowAutomaticUpdates="True" AutoGenerateColumns="False" onitemupdated="RadGrid3_ItemUpdated" 
                >
                <ClientSettings AllowColumnsReorder="True" ReorderColumnsOnClient="True">
                    <Selecting AllowRowSelect="True" />
                </ClientSettings>
                <MasterTableView Width="100%"  
                    DataSourceID="SqlDataSource2" AllowPaging="True" PageSize="10" 
                    ShowFooter="True" ClientDataKeyNames="RowID" DataKeyNames="RowID">
                    <CommandItemSettings ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                        Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                        Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column">
                        </telerik:GridEditCommandColumn>
                        <telerik:GridDropDownColumn HeaderText="Status" DataField="status" DataSourceID="SqlDataSource1" 
                            FilterControlAltText="Filter column column" ForceExtractValue="Always" 
                            ListTextField="status" ListValueField="status" UniqueName="column" DataType="System.String">
                        </telerik:GridDropDownColumn>
                        <telerik:GridBoundColumn DataField="Shiptocode" ReadOnly="true"
                            FilterControlAltText="Filter Shiptocode column" HeaderText="Shiptocode" 
                            SortExpression="Shiptocode" UniqueName="Shiptocode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Customerpart" ReadOnly="true"
                            FilterControlAltText="Filter Customerpart column" HeaderText="Customerpart" 
                            SortExpression="Customerpart" UniqueName="Customerpart">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CustomerPO" ReadOnly="true"
                            FilterControlAltText="Filter CustomerPO column" HeaderText="CustomerPO" 
                            SortExpression="CustomerPO" UniqueName="CustomerPO">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="RanNumber" ReadOnly="true"
                            FilterControlAltText="Filter RanNumber column" HeaderText="RanNumber" 
                            SortExpression="RanNumber" UniqueName="RanNumber">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="RanQty" ReadOnly="true" DataType="System.Int32" 
                            FilterControlAltText="Filter RanQty column" HeaderText="RanQty" 
                            SortExpression="RanQty" UniqueName="RanQty">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ShipmentDueDate" ReadOnly="true"
                            DataType="System.DateTime" 
                            FilterControlAltText="Filter ShipmentDueDate column" 
                            HeaderText="ShipmentDueDate" SortExpression="ShipmentDueDate" 
                            UniqueName="ShipmentDueDate">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="DateEDIProcessed" ReadOnly="true" DataType="System.DateTime" 
                            FilterControlAltText="Filter DateEDIProcessed column"
                            HeaderText="DateEDIProcessed"  SortExpression="DateEDIProcessed" 
                            UniqueName="DateEDIProcessed">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="RowID" DataType="System.Int32" ReadOnly="true"
                            FilterControlAltText="Filter RowID column" HeaderText="RowID"  
                            SortExpression="RowID" UniqueName="RowID">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column" 
                            UniqueName="EditCommandColumn1">
                        </EditColumn>
                    </EditFormSettings>

<PagerStyle PageSizeControlType="RadComboBox"></PagerStyle>
                </MasterTableView>
                <PagerStyle Mode="NextPrevAndNumeric" />
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource  ID="SqlDataSource2" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                runat="server" 
                                SelectCommand="SELECT   Status,
                                                        Shiptocode, 
                                                        Customerpart, 
                                                        CustomerPO, 
                                                        ReleaseNo as 'RanNumber',
                                                        Releaseqty as 'RanQty',
                                                        ReleaseDT as 'ShipmentDueDate',
                                                        RowCreateDT as 'DateEDIProcessed',
                                                        RowID
                                                        from edi.nal_862_releases
                                                        where releaseno = @releaseno" 
                                UpdateCommand="UPDATE   edi.nal_862_releases 
                                               SET      status = @status
                                               WHERE    rowid=@rowid"
             >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadTextBox1" Name="releaseno" 
                        PropertyName="Text" DefaultValue="KR00000093500003" Runat="server" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Status" Type="Int32"/>
                    <asp:Parameter Name="RowID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    <dx:ASPxPanel ID="ASPxPanel2" runat="server" Width="200px">
    </dx:ASPxPanel>
    </form>
</body>
</html>