<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NALPlanningBoard.aspx.cs" Inherits="NALReview" %>

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
    
    
    <telerik:AjaxSetting AjaxControlID="RadComboBox1">
        <UpdatedControls>
           <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource2" />
           <telerik:AjaxUpdatedControl ControlID="SqlDataSource3" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    
    </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <span class="style1">
            <br />
            View 862 created on:&nbsp; </span>
            <telerik:RadComboBox ID="RadComboBox1" Runat="server" AutoPostBack="true" 
                DataSourceID="SqlDataSource1"  DataTextField="ReleaseCreatedDT" 
                DataValueField="ReleaseCreatedDT"  Height="175px"  
                Width="250px" DataTextFormatString="{0:f}" 
                 style="font-size: medium" > 
            </telerik:RadComboBox>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="select distinct(rowcreatedt) as ReleaseCreatedDT from edi.nal_862_releases order by 1 desc">
               
            </asp:SqlDataSource>
           
            <br />
            <span class="style1">
            <strong>
            <br />
            Releases:</strong></span>
            
            <telerik:RadGrid    ID="RadGrid2"  
                                DataSourceID="SqlDataSource2"
                                runat="server"
                                ShowStatusBar="True"                              
                                Width="99%" 
                                CellSpacing="0" 
                                ShowGroupPanel="True" 
                                AllowSorting="True" GridLines="None" Height="675px" >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Vertical"
                                    ShowHeader="true"   >
                    
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                    </RowIndicatorColumn>
                    <ItemStyle BorderStyle=Solid />
                  
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
                            <HeaderTemplate>
                                <asp:Label  ID="Day0Label" runat="server" 
                                            Text='<%# Eval("Day0") %>'>
                                </asp:Label>
                            </HeaderTemplate>
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
                                <asp:LinkButton  ID="Day1Label" runat="server" 
                                            Text="Day 1 Releases">
                                </asp:LinkButton>
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
                                <asp:LinkButton  ID="Day2Label" runat="server" 
                                            Text="Day 2 Releases">
                                </asp:LinkButton>
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
                            <HeaderTemplate>
                                <asp:LinkButton  ID="Day3Label" runat="server" 
                                            Text="Day 3 Releases">
                                </asp:LinkButton>
                            </HeaderTemplate>
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
                            <HeaderTemplate>
                                <asp:LinkButton  ID="Day4Label" runat="server" 
                                            Text="Day 4 Releases">
                                </asp:LinkButton>
                            </HeaderTemplate>
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
                            <HeaderTemplate>
                                <asp:LinkButton  ID="Day5Label" runat="server" 
                                            Text="Day 5 Releases">
                                </asp:LinkButton>
                            </HeaderTemplate>
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
                            <HeaderTemplate>
                                <asp:LinkButton  ID="Day6Label" runat="server" 
                                            Text="Day 6 Releases">
                                </asp:LinkButton>
                            </HeaderTemplate>
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
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" 
                                    EnablePostBackOnRowClick="true" 
                                    AllowDragToGroup="True">
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True" 
                                ScrollHeight="675px" 
                                UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False"/>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="SqlDataSource2" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.scheduling_view_862"
                runat="server" SelectCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox1" Name="releasecreatedDT" 
                        PropertyName="SelectedValue"  Type="DateTime" 
                        />
                </SelectParameters>
            </asp:SqlDataSource>




        </div>
    </form>
</body>
</html>
