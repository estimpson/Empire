 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="View862Details.aspx.cs" Inherits="NALReview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
    </telerik:RadStyleSheetManager>   
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
     
    <telerik:AjaxSetting AjaxControlID="RadComboBox1">
        <UpdatedControls>
           <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource2" />
           <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
     
    <telerik:AjaxSetting AjaxControlID="RadGrid2">
        <UpdatedControls>
           <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource3" />
           <telerik:AjaxUpdatedControl ControlID="RadGrid4" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource4" />
           <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource5" />
        </UpdatedControls>
    </telerik:AjaxSetting> 
    
    </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <br />
            <span style=RadComboBox1>
            <span class="RadComboBox_Transparent">View EDI 862 Document created on:</span>&nbsp;</span>
            <telerik:RadComboBox ID="RadComboBox1" Runat="server" AutoPostBack="true" 
                DataSourceID="SqlDataSource1"  DataTextField="ReleaseCreatedDT" 
                DataValueField="ReleaseCreatedDT"  Height="200px"  
                Width="275px" DataTextFormatString="{0:f}" 
                ondatabound="RadComboBox1_DataBound" 
                onselectedindexchanged="RadComboBox1_SelectedIndexChanged" 
                ExpandDelay="50"  
                MarkFirstMatch="True" Skin="Transparent"
                DropDownCssClass="style2" > 
            </telerik:RadComboBox>
            <br />
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="select distinct(rowcreatedt) as ReleaseCreatedDT from edi.nal_862_releases order by 1 desc">         
            </asp:SqlDataSource>

            <telerik:RadGrid    ID="RadGrid2"  
                                DataSourceID="SqlDataSource2"
                              
                                runat="server"                              
                                Width="99%" 
                                CellSpacing="0" 
                                ShowGroupPanel="True" 
                                AllowSorting="True" Height="450px" ShowHeader="False" 
                                Skin="Transparent" GridLines="None" 
                onselectedindexchanged="RadGrid2_SelectedIndexChanged"  >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Both"
                                    ShowHeader="True" 
                                    DataKeyNames="ShipToCode, CustomerPart"
                                    onprerender="RadGrid2_PreRender" >
                    
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                    </RowIndicatorColumn>
                  
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                    </ExpandCollapseColumn>
                    
                    <Columns>
                        <telerik:GridBoundColumn    DataField="ShipToCode" 
                                                    FilterControlAltText="Filter ShipToCode column" 
                                                    HeaderText="ShipToCode" 
                                                    ReadOnly="True" 
                                                    SortExpression="ShipToCode" 
                                                    UniqueName="ShipToCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn    DataField="CustomerPart" 
                                                    FilterControlAltText="Filter CustomerPart column" 
                                                    HeaderText="CustomerPart" 
                                                    ReadOnly="True" 
                                                    SortExpression="CustomerPart" 
                                                    UniqueName="CustomerPart">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn FilterControlAltText="Filter PastDueReleaseNo column"  
                                                    SortExpression="PastDueReleaseNo" 
                                                    UniqueName="PastDueReleaseNo">
                            <HeaderTemplate>
                                <table id="Table1" style="width:auto;" >
                                <tr>
                                    <td colspan="1" style="text-align:center">
                                
                                <asp:LinkButton ID="Label1" runat="server" 
                                    Text="Past Due Releases">
                                </asp:LinkButton>
                                    </td>
                                    </tr>
                                    </table>
                            </HeaderTemplate>
                                   
                            <ItemTemplate>
                                <asp:Label ID="PastDueReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("PastDueReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="PastDueReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("PastDueReleaseQty", "{0:N0}") %>'></asp:Label> 
                                 
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                         
                         <telerik:GridTemplateColumn FilterControlAltText="Filter Day0ReleaseNo column" 
                                                    SortExpression="Day0ReleaseNo" 
                                                    UniqueName="Day0ReleaseNo">
                            <ItemTemplate>
                                <asp:Label ID="Day0ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day0ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day0ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day0ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day1ReleaseNo column" 
                                                    SortExpression="Day1ReleaseNo" 
                                                    UniqueName="Day1ReleaseNo">
                            <HeaderTemplate>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Day1ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day1ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day1ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day1ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day2ReleaseNo column" 
                                                    SortExpression="Day2ReleaseNo" 
                                                    UniqueName="Day2ReleaseNo">
                            <HeaderTemplate>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Day2ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day2ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day2ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day2ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>                 
                        
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day3ReleaseNo column" 
                                                    SortExpression="Day3ReleaseNo" 
                                                    UniqueName="Day3ReleaseNo">

                            <ItemTemplate>
                                <asp:Label ID="Day3ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day3ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day3ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day3ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>                         
                        
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day4ReleaseNo column" 
                                                    SortExpression="Day4ReleaseNo" 
                                                    UniqueName="Day4ReleaseNo">
                            <ItemTemplate>
                                <asp:Label ID="Day4ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day4ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day4ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day4ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>                                           
                        
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day5ReleaseNo column" 
                                                    SortExpression="Day5ReleaseNo" 
                                                    UniqueName="Day5ReleaseNo">
                            <ItemTemplate>
                                <asp:Label ID="Day5ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day5ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day5ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day5ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>                           
                          
                        <telerik:GridTemplateColumn FilterControlAltText="Filter Day6ReleaseNo column" 
                                                    SortExpression="Day6ReleaseNo" 
                                                    UniqueName="Day6ReleaseNo">
                            <ItemTemplate>
                                <asp:Label ID="Day6ReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("Day6ReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="Day6ReleaseQtyLabel" runat="server" 
                                    Text='<%# Eval("Day6ReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>                       
          
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <AlternatingItemStyle BackColor="#E5E5E5" />
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" 
                                    EnablePostBackOnRowClick="true" 
                                    AllowDragToGroup="True" >
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True" 
                                ScrollHeight="100%" 
                                UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False"/>
            </telerik:RadGrid>
            
            <asp:SqlDataSource ID="SqlDataSource2" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_view_862"
                runat="server" SelectCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox1" Name="releasecreatedDT" 
                        PropertyName="SelectedValue"  Type="DateTime" 
                        />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <span class="RadComboBox_Transparent">Shipped:</span>

             <telerik:RadGrid    ID="RadGrid3"  
                                DataSourceID="SqlDataSource3"
                                runat="server"                              
                                Width="99%" 
                                CellSpacing="0" 
                                AllowSorting="True" Height="130px" ShowHeader="False" 
                Skin="Transparent" GridLines="None"  >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Both"
                                    ShowHeader="True" DataSourceID="SqlDataSource3"
                                    DataKeyNames="ShipToCode, CustomerPart">
                    
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                    </RowIndicatorColumn>
                  
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                    </ExpandCollapseColumn>
                    
                    <Columns>
                        <telerik:GridBoundColumn DataField="plant" 
                            FilterControlAltText="Filter plant column" HeaderText="plant" 
                            SortExpression="plant" UniqueName="plant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ShipToCode" 
                            FilterControlAltText="Filter ShipToCode column" 
                            HeaderText="ShipToCode" SortExpression="ShipToCode" 
                            UniqueName="ShipToCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CustomerPart" 
                            FilterControlAltText="Filter CustomerPart column" HeaderText="CustomerPart" 
                            SortExpression="CustomerPart" UniqueName="CustomerPart">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="part_original" 
                            FilterControlAltText="Filter part_original column" HeaderText="part_original" 
                            SortExpression="part_original" UniqueName="part_original">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="shipper_ran" 
                            FilterControlAltText="Filter shipper_ran column" HeaderText="shipper_ran" 
                            SortExpression="shipper_ran" UniqueName="shipper_ran">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nal_ran" 
                            FilterControlAltText="Filter nal_ran column" HeaderText="nal_ran" 
                            SortExpression="nal_ran" UniqueName="nal_ran">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty column" HeaderText="qty" SortExpression="qty" 
                            UniqueName="qty">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_required" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_required column" HeaderText="qty_required" 
                            SortExpression="qty_required" UniqueName="qty_required">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_packed" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_packed column" HeaderText="qty_packed" 
                            SortExpression="qty_packed" UniqueName="qty_packed">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="id" DataType="System.Int32" 
                            FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" 
                            UniqueName="id">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="status"  
                            FilterControlAltText="Filter status column" HeaderText="status" 
                            SortExpression="status" UniqueName="status">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="date_shipped" DataType="System.DateTime" 
                            FilterControlAltText="Filter date_shipped column" HeaderText="date_shipped" 
                            SortExpression="date_shipped" UniqueName="date_shipped">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <AlternatingItemStyle BackColor="#E5E5E5" />
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" 
                                     AllowColumnsReorder="True" 
                    ReorderColumnsOnClient="True">
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True" 
                                ScrollHeight="100%" 
                                UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False"/>
            </telerik:RadGrid>
            
            <asp:SqlDataSource ID="SqlDataSource3" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_view_862b"
                runat="server" SelectCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox1" Name="ReleaseCreatedDT" 
                        PropertyName="SelectedValue"  Type="DateTime" 
                        DefaultValue="2/25/2013 9:41:55 AM"> 
                        </asp:ControlParameter>
                    <asp:ControlParameter ControlID="RadGrid2" Name="ShipToCode"
                        PropertyName="SelectedValues['ShipToCode']" Type="String" DefaultValue="ALABAMA">
                       </asp:ControlParameter>
                    <asp:ControlParameter ControlID="RadGrid2" Name="CustomerPart"
                        PropertyName="SelectedValues['CustomerPart']" Type="String" DefaultValue="938 714-13" >
                       </asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>            
            <br />
            <span class="RadComboBox_Transparent">Pending Shipments:</span>
            <telerik:RadGrid    ID="RadGrid4"  
                                DataSourceID="SqlDataSource4"
                                runat="server"                              
                                Width="99%" 
                                CellSpacing="0" 
                                AllowSorting="True" Height="75px" ShowHeader="False" 
                Skin="Transparent" GridLines="None"  >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Both"
                                    ShowHeader="True" DataSourceID="SqlDataSource4"
                                    DataKeyNames="ShipToCode, CustomerPart">
                    
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                    </RowIndicatorColumn>
                  
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                    </ExpandCollapseColumn>
                    
                    <Columns>
                        <telerik:GridBoundColumn DataField="plant" 
                            FilterControlAltText="Filter plant column" HeaderText="plant" 
                            SortExpression="plant" UniqueName="plant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ShipToCode" 
                            FilterControlAltText="Filter ShipToCode column" 
                            HeaderText="ShipToCode" SortExpression="ShipToCode" 
                            UniqueName="ShipToCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CustomerPart" 
                            FilterControlAltText="Filter CustomerPart column" HeaderText="CustomerPart" 
                            SortExpression="CustomerPart" UniqueName="CustomerPart">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="part_original" 
                            FilterControlAltText="Filter part_original column" HeaderText="part_original" 
                            SortExpression="part_original" UniqueName="part_original">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="shipper_ran" 
                            FilterControlAltText="Filter shipper_ran column" HeaderText="shipper_ran" 
                            SortExpression="shipper_ran" UniqueName="shipper_ran">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nal_ran" 
                            FilterControlAltText="Filter nal_ran column" HeaderText="nal_ran" 
                            SortExpression="nal_ran" UniqueName="nal_ran">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty column" HeaderText="qty" SortExpression="qty" 
                            UniqueName="qty">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_required" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_required column" HeaderText="qty_required" 
                            SortExpression="qty_required" UniqueName="qty_required">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_packed" DataType="System.Decimal" 
                            FilterControlAltText="Filter qty_packed column" HeaderText="qty_packed" 
                            SortExpression="qty_packed" UniqueName="qty_packed">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="id" DataType="System.Int32" 
                            FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" 
                            UniqueName="id">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="status"  
                            FilterControlAltText="Filter status column" HeaderText="status" 
                            SortExpression="status" UniqueName="status">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Picklist_printed"  
                            FilterControlAltText="Filter Picklist_printed column" HeaderText="picklist_printed" 
                            SortExpression="picklist_printed" UniqueName="picklist_printed">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <AlternatingItemStyle BackColor="#E5E5E5" />
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" 
                                     AllowColumnsReorder="True" 
                    ReorderColumnsOnClient="True">
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True" 
                                ScrollHeight="100%" 
                                UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False"/>
            </telerik:RadGrid>        
            <asp:SqlDataSource ID="SqlDataSource4" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_view_862c"
                runat="server" SelectCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox1" Name="ReleaseCreatedDT" 
                        PropertyName="SelectedValue"  Type="DateTime" 
                        DefaultValue="2/25/2013 9:41:55 AM"> 
                        </asp:ControlParameter>
                    <asp:ControlParameter ControlID="RadGrid2" Name="ShipToCode"
                        PropertyName="SelectedValues['ShipToCode']" Type="String" DefaultValue="ALABAMA">
                       </asp:ControlParameter>
                    <asp:ControlParameter ControlID="RadGrid2" Name="CustomerPart"
                        PropertyName="SelectedValues['CustomerPart']" Type="String" DefaultValue="938 714-13" >
                       </asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>
                      <br />
            <span class="RadComboBox_Transparent">On Order:</span>

             <telerik:RadGrid    ID="RadGrid5"  
                                DataSourceID="SqlDataSource5"
                                runat="server"                              
                                Width="99%" 
                                CellSpacing="0" 
                                AllowSorting="True" Height="175px" ShowHeader="False" 
                Skin="Transparent" GridLines="None"  >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Both"
                                    ShowHeader="True" DataSourceID="SqlDataSource5">
                    
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                    </RowIndicatorColumn>
                  
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                    </ExpandCollapseColumn>
                    
                    <Columns>
                        <telerik:GridBoundColumn DataField="order_no" 
                            FilterControlAltText="Filter order_no column" HeaderText="order_no" 
                            SortExpression="order_no" UniqueName="order_no" DataType="System.Decimal">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="plant" 
                            FilterControlAltText="Filter plant column" 
                            HeaderText="plant" SortExpression="plant" 
                            UniqueName="plant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer" 
                            FilterControlAltText="Filter customer column" HeaderText="customer" 
                            SortExpression="customer" UniqueName="customer">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="destination" 
                            FilterControlAltText="Filter destination column" HeaderText="destination" 
                            SortExpression="destination" UniqueName="destination">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ShipToCode" 
                            FilterControlAltText="Filter ShipToCode column" HeaderText="ShipToCode" 
                            SortExpression="ShipToCode" UniqueName="ShipToCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="notes" 
                            FilterControlAltText="Filter notes column" HeaderText="notes" 
                            SortExpression="notes" UniqueName="notes">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="part_number" 
                            FilterControlAltText="Filter part_number column" HeaderText="part_number" SortExpression="part_number" 
                            UniqueName="part_number">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CustomerPart" 
                            FilterControlAltText="Filter CustomerPart column" HeaderText="CustomerPart" 
                            SortExpression="CustomerPart" UniqueName="CustomerPart">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer_po" 
                            FilterControlAltText="Filter customer_po column" HeaderText="customer_po" 
                            SortExpression="customer_po" UniqueName="customer_po">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_no" 
                            FilterControlAltText="Filter release_no column" HeaderText="release_no" SortExpression="release_no" 
                            UniqueName="release_no">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="type"  
                            FilterControlAltText="Filter type column" HeaderText="type" 
                            SortExpression="type" UniqueName="type">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="due_date" DataType="System.DateTime" 
                            FilterControlAltText="Filter due_date column" HeaderText="due_date" 
                            SortExpression="due_date" UniqueName="due_date">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="quantity" DataType="System.Decimal" 
                            FilterControlAltText="Filter quantity column" HeaderText="quantity" 
                            SortExpression="quantity" UniqueName="quantity">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="committed_qty" DataType="System.Decimal" 
                            FilterControlAltText="Filter committed_qty column" HeaderText="committed_qty" 
                            SortExpression="committed_qty" UniqueName="committed_qty">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="standard_pack" DataType="System.Decimal" 
                            FilterControlAltText="Filter standard_pack column" HeaderText="standard_pack" 
                            SortExpression="standard_pack" UniqueName="standard_pack">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="exceptions" 
                            FilterControlAltText="Filter exceptions column" HeaderText="exceptions" 
                            SortExpression="exceptions" UniqueName="exceptions">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="last_shipper" DataType="System.Int32" 
                            FilterControlAltText="Filter last_shipper column" HeaderText="last_shipper" 
                            SortExpression="last_shipper" UniqueName="last_shipper">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <AlternatingItemStyle BackColor="#E5E5E5" />
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" 
                                     AllowColumnsReorder="True" 
                    ReorderColumnsOnClient="True">
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True" 
                                ScrollHeight="100%" 
                                UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False"/>
            </telerik:RadGrid>
            
            <asp:SqlDataSource ID="SqlDataSource5" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_view_862d"
                runat="server" SelectCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadGrid2" Name="ShipToCode"
                        PropertyName="SelectedValues['ShipToCode']" Type="String" DefaultValue="ALABAMA">
                       </asp:ControlParameter>
                    <asp:ControlParameter ControlID="RadGrid2" Name="CustomerPart"
                        PropertyName="SelectedValues['CustomerPart']" Type="String" DefaultValue="938 714-13" >
                       </asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>
 
 
 
 
        </div>
    </form>
</body>
</html>
