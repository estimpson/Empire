 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="View862NestedGrid.aspx.cs" Inherits="NALReview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
    </telerik:RadStyleSheetManager>   
    </head>
<body>
       <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server" 
           AsyncPostBackTimeout="180" >
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js"></asp:ScriptReference>
<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js"></asp:ScriptReference>
<asp:ScriptReference Assembly="Telerik.Web.UI" 
                Name="Telerik.Web.UI.Common.jQueryInclude.js"></asp:ScriptReference>
        </Scripts>
    </telerik:RadScriptManager>
    
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
     
            <telerik:AjaxSetting AjaxControlID="RadComboBox1">
                <UpdatedControls>
                   <telerik:AjaxUpdatedControl ControlID="RadGridM" />
                   <telerik:AjaxUpdatedControl ControlID="SqlDataSourceM" />
                </UpdatedControls>
            </telerik:AjaxSetting>
    
        </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <br />
            <span style=RadComboBox1>
            <span class="RadComboBox_Transparent">View EDI Document 862 created on:</span>&nbsp;</span>
            <telerik:RadComboBox    ID="RadComboBox1" 
                                    Runat="server" 
                                    AutoPostBack="True" 
                                    DataSourceID="SqlDataSourceA"  
                                    DataTextField="ReleaseCreatedDT" 
                                    DataValueField="ReleaseCreatedDT"  
                                    Height="200px"  
                                    Width="275px" 
                                    DataTextFormatString="{0:f}" 
                                    ExpandDelay="50"  
                                    MarkFirstMatch="True"
                                    DropDownCssClass="style2"                                     
                                    ondatabound="RadComboBox1_DataBound"    
                                    onselectedindexchanged="RadComboBox1_SelectedIndexChanged" > 
            </telerik:RadComboBox>
            <br />
            <br />
            <asp:SqlDataSource  ID="SqlDataSourceA" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="select distinct(rowcreatedt) as ReleaseCreatedDT from edi.nal_862_releases order by 1 desc">         
            </asp:SqlDataSource>

            <telerik:RadGrid    ID="RadGridM"  
                                DataSourceID="SqlDataSourceM"
                                runat="server"                              
                                Width="99%" 
                                CellSpacing="0" 
                                ShowGroupPanel="True" 
                                AllowSorting="True" 
                                Height="850px"  
                                onitemdatabound="RadGridM_ItemDataBound" 
                                GridLines="None" >
                                 
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Both"
                                    ShowHeader="True"
                                     
                                    DataSourceID="SqlDataSourceM"
                                    DataKeyNames="ShipToCode, CustomerPart, PastDueReleaseNo, Day0ReleaseNo, Day1ReleaseNo, Day2ReleaseNo, Day3ReleaseNo, Day4ReleaseNo"
                                     >
                    
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
                                                    UniqueName="ShipToCode"
                                                    HeaderStyle-Width = "100px"
                                                    ItemStyle-Width="100px"
                                                     >
                           
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridTemplateColumn  DataField="CustomerPart"
                                                     ReadOnly="true"
                                                     FilterControlAltText="Filter CustomerPart column" 
                                                     SortExpression="CustomerPart" 
                                                     UniqueName="CustomerPart"
                                                     HeaderText="CustomerPart / EmpirePart"
                                                     HeaderStyle-Width="120px" 
                                                     ItemStyle-Width="120px"  >
                            
                            <ItemTemplate>
                                <br />
                                <asp:Label  ID="Label1" 
                                            runat="server" 
                                            Text='<%# Eval("CustomerPart") %>'
                                            Style="width:100px">
                                </asp:Label>
                                <br />
                                <br /> 
                                <asp:Label  ID="Label2" 
                                            runat="server" 
                                            Text='<%# Eval("BasePart") %>'
                                            style="width:100px">
                                 </asp:Label>
                                 <br />                          
                                 </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn  DataField="PastDueReleaseNo"
                                                     FilterControlAltText="Filter PastDueReleaseNo column" 
                                                     SortExpression="PastDueReleaseNo" 
                                                     UniqueName="PastDueReleaseNo"
                                                     HeaderText="Past Due"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >
                            
                            
                            <ItemTemplate>
                                &nbsp;&nbsp;
                                <asp:Label  ID="PastDueReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("PastDueReleaseNo") %>'
                                            Style="width:75px">
                                </asp:Label>
                                &nbsp;&nbsp;
                                <asp:Label  ID="PastDueReleaseQtyLabel" 
                                            runat="server" 
                                            style="text-align:right; width:17px"
                                            Text='<%# Eval("PastDueReleaseQty", "{0:N0}") %>'>
                                            
                                 </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGridP" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None"
                                                    ShowHeader="False"
                                                    OnPreRender="RadGridP_PreRender">                   
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="PastDueReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="PastDueReleaseNo" 
                                                                        FilterControlAltText="Filter PastDueReleaseNo column" 
                                                                        HeaderText="PastDueReleaseNo" 
                                                                        SortExpression="PastdueReleaseNo" 
                                                                        UniqueName="PastDueReleaseNo" 
                                                                        ReadOnly="True" >
                                                <ItemStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                                       
                                                <ItemStyle Width="18px" HorizontalAlign="Right" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <ItemStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <ItemStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>
                         
                        <telerik:GridTemplateColumn  DataField="Day0ReleaseNo"
                                                     FilterControlAltText="Filter Day0ReleaseNo column" 
                                                     SortExpression="Day0ReleaseNo" 
                                                     UniqueName="Day0ReleaseNo"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >
                            <ItemTemplate>
                                <asp:Label  ID="Day0ReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day0ReleaseNo") %>'>
                                </asp:Label>
                                &nbsp;
                                <asp:Label  ID="Day0ReleaseQtyLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day0ReleaseQty", "{0:N0}") %>'>
                                </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGrid0" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None"
                                                    ShowHeader="False"
                                                    OnPreRender="RadGrid0_PreRender">             
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="Day0ReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="Day0ReleaseNo" 
                                                                        FilterControlAltText="Filter Day0ReleaseNo column" 
                                                                        HeaderText="Day0ReleaseNo" 
                                                                        SortExpression="Day0ReleaseNo" 
                                                                        UniqueName="Day0ReleaseNo" 
                                                                        ReadOnly="True" >
                                                <ItemStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                <ItemStyle Width="18px" HorizontalAlign="Right" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <ItemStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <ItemStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>
                        
                        <telerik:GridTemplateColumn  DataField="Day1ReleaseNo"
                                                     FilterControlAltText="Filter Day1ReleaseNo column" 
                                                     SortExpression="Day1ReleaseNo" 
                                                     UniqueName="Day1ReleaseNo"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >
                            <ItemTemplate>
                                <asp:Label  ID="Day1ReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day1ReleaseNo") %>'>
                                </asp:Label>
                                &nbsp;
                                <asp:Label  ID="Day1ReleaseQtyLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day1ReleaseQty", "{0:N0}") %>'>
                                </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGrid1" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None"
                                                    ShowHeader="False"
                                                    OnPreRender="RadGrid1_PreRender">               
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="Day1ReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="Day1ReleaseNo" 
                                                                        FilterControlAltText="Filter Day1ReleaseNo column" 
                                                                        HeaderText="Day1ReleaseNo" 
                                                                        SortExpression="Day1ReleaseNo" 
                                                                        UniqueName="Day1ReleaseNo" 
                                                                        ReadOnly="True" >
                                                <HeaderStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                <HeaderStyle Width="18px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <HeaderStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <HeaderStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>

                      <telerik:GridTemplateColumn  DataField="Day2ReleaseNo"
                                                     FilterControlAltText="Filter Day2ReleaseNo column" 
                                                     SortExpression="Day2ReleaseNo" 
                                                     UniqueName="Day2ReleaseNo"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >                          
                            <ItemTemplate>
                                <asp:Label  ID="Day2ReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day2ReleaseNo") %>'>
                                </asp:Label>
                                &nbsp;
                                <asp:Label  ID="Day2ReleaseQtyLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day2ReleaseQty", "{0:N0}") %>'>
                                </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGrid2" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None" 
                                                    ShowHeader="False"
                                                    OnPreRender="RadGrid2_PreRender">
                                                      
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="Day2ReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="Day2ReleaseNo" 
                                                                        FilterControlAltText="Filter Day2ReleaseNo column" 
                                                                        HeaderText="Day2ReleaseNo" 
                                                                        SortExpression="Day2ReleaseNo" 
                                                                        UniqueName="Day2ReleaseNo" 
                                                                        ReadOnly="True" >
                                                <HeaderStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                <HeaderStyle Width="18px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <HeaderStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <HeaderStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>

                     <telerik:GridTemplateColumn  DataField="Day3ReleaseNo"
                                                     FilterControlAltText="Filter Day3ReleaseNo column" 
                                                     SortExpression="Day3ReleaseNo" 
                                                     UniqueName="Day3ReleaseNo"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >
                            <ItemTemplate>
                                <asp:Label  ID="Day3ReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day3ReleaseNo") %>'>
                                </asp:Label>
                                &nbsp;
                                <asp:Label  ID="Day3ReleaseQtyLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day3ReleaseQty", "{0:N0}") %>'>
                                </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGrid3" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None"
                                                    ShowHeader="False"
                                                    OnPreRender="RadGrid3_PreRender" >                
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="Day3ReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="Day3ReleaseNo" 
                                                                        FilterControlAltText="Filter Day3ReleaseNo column" 
                                                                        HeaderText="Day3ReleaseNo" 
                                                                        SortExpression="Day3ReleaseNo" 
                                                                        UniqueName="Day3ReleaseNo" 
                                                                        ReadOnly="True" >
                                                <ItemStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                <ItemStyle Width="18px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <ItemStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <ItemStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>

                     <telerik:GridTemplateColumn  DataField="Day4ReleaseNo"
                                                     FilterControlAltText="Filter Day4ReleaseNo column" 
                                                     SortExpression="Day4ReleaseNo" 
                                                     UniqueName="Day4ReleaseNo"
                                                     HeaderStyle-Width="290px" 
                                                     ItemStyle-Width="290px"  >
                            <ItemTemplate>
                                <asp:Label  ID="Day4ReleaseNoLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day4ReleaseNo") %>'>
                                </asp:Label>
                                &nbsp;
                                <asp:Label  ID="Day4ReleaseQtyLabel" 
                                            runat="server" 
                                            Text='<%# Eval("Day4ReleaseQty", "{0:N0}") %>'>
                                </asp:Label>
                                <br />      
                                <br />
                                <telerik:RadGrid    ID="RadGrid4" 
                                                    runat="server" 
                                                    CellSpacing="0" 
                                                    GridLines="None"
                                                    ShowHeader="False"
                                                    OnPreRender="RadGrid4_PreRender" >               
                                    <ClientSettings>
                                       
                                        <Resizing   AllowColumnResize="True" 
                                                    ResizeGridOnColumnResize="True" 
                                                    ShowRowIndicatorColumn="False" />

                                    </ClientSettings>

                                    <MasterTableView    AutoGenerateColumns="False" 
                                                        DataKeyNames="Day4ReleaseNo" 
                                                        ShowHeadersWhenNoRecords="False"
                                                        NoMasterRecordsText="" 
                                                        TableLayout="Auto" >
 
                                        <Columns>
                                            
                                            <telerik:GridBoundColumn    DataField="Day4ReleaseNo" 
                                                                        FilterControlAltText="Filter Day4ReleaseNo column" 
                                                                        HeaderText="Day4ReleaseNo" 
                                                                        SortExpression="Day4ReleaseNo" 
                                                                        UniqueName="Day4ReleaseNo" 
                                                                        ReadOnly="True" >
                                                <ItemStyle Width="65px" />                              
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="qty" 
                                                                        DataType="System.Decimal" 
                                                                        FilterControlAltText="Filter qty column" 
                                                                        HeaderText="qty" 
                                                                        SortExpression="qty" 
                                                                        UniqueName="qty" 
                                                                        DataFormatString="{0:N0}">
                                                <ItemStyle Width="18px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="id" 
                                                                        FilterControlAltText="Filter id column" 
                                                                        HeaderText="id" 
                                                                        SortExpression="id" 
                                                                        UniqueName="id" 
                                                                        DataType="System.Int32">
                                                <ItemStyle Width="20px" />
                                            </telerik:GridBoundColumn>
                                            
                                            <telerik:GridBoundColumn    DataField="date_shipped" 
                                                                        DataType="System.DateTime" 
                                                                        FilterControlAltText="Filter date_shipped column" 
                                                                        HeaderText="date_shipped" 
                                                                        SortExpression="date_shipped" 
                                                                        UniqueName="date_shipped" 
                                                                        DataFormatString="{0:ddd M/d/yyy h:mm tt}">
                                                <ItemStyle Width="40px" />
                                            </telerik:GridBoundColumn>
                                            
                                        </Columns>
                                        
                                        <EditFormSettings>
                                            <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                                        </EditFormSettings>
                                   
                                        <PagerStyle PageSizeControlType="RadComboBox" />
                                   
                                    </MasterTableView>
                                    
                                    <PagerStyle PageSizeControlType="RadComboBox" />
                                    
                                    <FilterMenu EnableImageSprites="False"/>

                                </telerik:RadGrid>            
                                
                            </ItemTemplate>
                       
                        </telerik:GridTemplateColumn>

                    </Columns>
                    
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column"/>
                    </EditFormSettings>
                    
                    <AlternatingItemStyle BackColor="#E5E5E5" />

                    <PagerStyle PageSizeControlType="RadComboBox"/>
                </MasterTableView>
                
                <GroupingSettings ShowUnGroupButton="True" />
                
                <ClientSettings     AllowKeyboardNavigation="true" 
                                    EnablePostBackOnRowClick="true" 
                                    AllowDragToGroup="True">
                    <Selecting  AllowRowSelect="true" />
                    <Scrolling  AllowScroll="True"  
                                UseStaticHeaders="True"
                                FrozenColumnsCount="2"  />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                
                <PagerStyle PageSizeControlType="RadComboBox"/>

                <FilterMenu EnableImageSprites="False"/>

            </telerik:RadGrid>
            
            <asp:SqlDataSource  ID="SqlDataSourceM" 
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.acctg_scheduling_view_862"
                                SelectCommandType="StoredProcedure" >
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadComboBox1" 
                                            Name="releasecreatedDT" 
                                            PropertyName="SelectedValue"  
                                            Type="DateTime" />
                </SelectParameters>

            </asp:SqlDataSource>

            <asp:SqlDataSource  ID="SqlDataSourceP" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862PastDueNestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="PastDueReleaseNo"
                                            PropertyName="SelectedValues['PastDueReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>
 
             <asp:SqlDataSource  ID="SqlDataSource0" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862Day0NestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="Day0ReleaseNo"
                                            PropertyName="SelectedValues['Day0ReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>
 
             <asp:SqlDataSource  ID="SqlDataSource1" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862Day1NestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="Day1ReleaseNo"
                                            PropertyName="SelectedValues['Day1ReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>
 
             <asp:SqlDataSource  ID="SqlDataSource2" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862Day2NestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="Day2ReleaseNo"
                                            PropertyName="SelectedValues['Day2ReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>
 
             <asp:SqlDataSource  ID="SqlDataSource3" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862Day3NestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="Day3ReleaseNo"
                                            PropertyName="SelectedValues['Day3ReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>
             
             <asp:SqlDataSource  ID="SqlDataSource4" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.SchedulingView862Day4NestedGrid"
                                SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="RadGridM" 
                                            Name="Day4ReleaseNo"
                                            PropertyName="SelectedValues['Day4ReleaseNo']" 
                                            Type="String" 
                                            DefaultValue="KR00000082450626" />
                </SelectParameters>
            </asp:SqlDataSource>              
            
        </div>
    </form>
</body>
</html>
