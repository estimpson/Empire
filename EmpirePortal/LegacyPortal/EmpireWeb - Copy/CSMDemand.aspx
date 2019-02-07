<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSMDemand.aspx.cs"
    Inherits="RadGridRelatedForm" %>
<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
     <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <%--Needed for JavaScript IntelliSense in VS2010--%>
            <%--For VS2008 replace RadScriptManager with ScriptManager--%>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>   
    <telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="SqlDataSource4" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="SqlDataSource5" />
                    <telerik:AjaxUpdatedControl ControlID="CSMTotalDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="SqlDataSource6" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBox2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>


    <asp:panel ID="Panel1" runat="server" Height="100%">
 
    <telerik:RadSplitter ID="RadSplitter2" Height="100%" Width="1800px" runat="server" Orientation="Vertical">
    <telerik:RadPane ID="RadPane1" runat="server" Height="800px" Width="400px" Scrolling="Y">
    Create New Base Part:
        <br />
        <br />     
    <telerik:RadTextBox ID="RadTextBox50" Label="Release_ID" Runat="server" EmptyMessage="Enter Release ID"  Width="400px" Height="20px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox51" Label="Base_Part: " Runat="server" EmptyMessage="Enter Base Part" Width="400px" Height="20px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox4" Label="Salesperson: " Runat="server" EmptyMessage="Enter Salesperson" Width="400px"/>
                    <br />
        
    <telerik:RadTextBox ID="RadTextBox5" Label="Date of Award: " Runat="server" InputType="Date" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox6" Label="Type of Award: " Runat="server" EmptyMessage="Enter Type of Award" Width="400px"/>         
                    <br />
    <telerik:RadTextBox ID="RadTextBox52" Label="Family: " Runat="server" EmptyMessage="Enter Base Part"  Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox53" Label="Customer: " Runat="server" EmptyMessage="Enter Customer" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox54" Label="Parent_Customer: " Runat="server" EmptyMessage="Enter Parent Customer" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox55" Label="Product_Line: " Runat="server" EmptyMessage="Enter Product Line" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox56" Label="Empire_Market_Segment: " Runat="server" EmptyMessage="Enter Empire Market Segment" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox57" Label="Empire_Market_Subsegment: " Runat="server" EmptyMessage="Enter Empire Market Subsegment" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox58" Label="Empire_Application: " Runat="server" EmptyMessage="Enter Empire Application" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox59" Label="Empire_SOP: " Runat="server" InputType="Date" Width="400px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox60" Label="Empire_EOP: " Runat="server" InputType="Date" Width="400px"/>         
                    <br />
    <telerik:RadNumericTextBox ID="RadNumericTextBox1" runat="server" Label="Customer Selling Price: " EmptyMessage="Enter Customer Selling price" Width="400px">
                    <NegativeStyle Resize="None" />
                    <NumberFormat DecimalDigits="4" ZeroPattern="n" />
                    <EmptyMessageStyle Resize="None" />
                    <ReadOnlyStyle Resize="None" />
                    <FocusedStyle Resize="None" />
                    <DisabledStyle Resize="None" />
                    <InvalidStyle Resize="None" />
                    <HoveredStyle Resize="None" />
                    <EnabledStyle Resize="None" />
        </Telerik:RadNumericTextBox>
                    <br />
    <telerik:RadNumericTextBox ID="RadNumericTextBox2" Runat="server" Label="Material Cost: "  EmptyMessage="Enter Material Cost" Width="400px">
                    <NegativeStyle Resize="None" />
                    <NumberFormat DecimalDigits="6" ZeroPattern="n" />
                    <EmptyMessageStyle Resize="None" />
                    <ReadOnlyStyle Resize="None" />
                    <FocusedStyle Resize="None" />
                    <DisabledStyle Resize="None" />
                    <InvalidStyle Resize="None" />
                    <HoveredStyle Resize="None" />
                    <EnabledStyle Resize="None" />
        </Telerik:RadNumericTextBox>
                    <br /> 
    <telerik:RadTextBox ID="RadTextBox61" Label="Part Used for MC: " Runat="server" EmptyMessage="Enter Part Used For Material Cost" Width="400px"/>         
                    <br />
     <asp:CheckBox ID="CheckBox1" runat="server" Text="Include in Forecast?" Checked="true" Width="400px" TextAlign="Left"/>
                    <br /> 
                    <br />
        <div id="Div1" runat="server" >
            <center>
                                
                    <telerik:RadButton  ID="RadButtonInsertPart" 
                                        runat="server"  
                                        onclick="RadButtonInsertPart_Click"
                                        Text="Create New Base Part" 
                                        Height="22px" 
                                        Width="200px">
                    </telerik:RadButton>
            <asp:SqlDataSource ID="SqlDataSourceAM" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        SelectCommand="select account_manager,account_manager_description from empower.dbo.account_managers where inactive &lt;&gt; 1"></asp:SqlDataSource>
            <asp:SqlDataSource  ID="SqlDataSourceInsertPart" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id"                 ControlID="RadTextBox50"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="base_part"                  ControlID="RadTextBox51"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="salesperson"                  ControlID="RadTextBox4"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="date_of_award"                     ControlID="RadTextBox5"        Type="DateTime"       PropertyName="Text" />
                                                <asp:ControlParameter Name="type_of_award"                   ControlID="RadTextBox6"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="family"                     ControlID="RadTextBox52"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="customer"                   ControlID="RadTextBox53"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="parent_customer"            ControlID="RadTextBox54"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="product_line"               ControlID="RadTextBox55"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_segment"      ControlID="RadTextBox56"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_subsegment"   ControlID="RadTextBox57"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_application"         ControlID="RadTextBox58"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_sop"                 ControlID="RadTextBox59"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_eop"                 ControlID="RadTextBox60"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="sp"                         ControlID="RadNumericTextBox1"  Type="Decimal"      PropertyName="Text" />
                                                <asp:controlParameter Name="mc"                         ControlID="RadNumericTextBox2"  Type="Decimal"      PropertyName="Text" />
                                                <asp:ControlParameter Name="part_used_for_mc"           ControlID="RadTextBox61"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="include_in_forecast"        ControlID="CheckBox1"           Type="Boolean"      PropertyName="Checked" />
                                            </InsertParameters>
                    </asp:SqlDataSource>
              </center>
            </div>                          
                    
   </telerik:RadPane>
    <telerik:RadSplitBar CollapseMode="Both" ID="RadSplitBar2" runat="server" EnableResize="true" BorderWidth="5px"/> 
        <telerik:RadPane ID="FormPane" runat="server" Height="800px" Width="350px" Scrolling="None" BorderColor ="Blue">
     Assign CSM Demand:      
        <br />
        <br />
    <telerik:RadTextBox ID="RadTextBox1" Label="Release_ID" Runat="server" EmptyMessage="Enter Release ID"  Width="300px" Height="20px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox3" Label="BasePart: " Runat="server" EmptyMessage="Enter Base Part" Width="300px" Height="20px"/>
                    <br />
    <telerik:RadTextBox ID="RadTextBox2" Label="Mnemonic" Runat="server" EmptyMessage="Enter Mnemonic"  Width="300px" Height="20px"/> 
                    <br />
    <telerik:RadNumericTextBox ID="RadTextBox8" Label="Qty_per: " Runat="server" EmptyMessage="Enter Qty Per" Width="300px"/>
                    <br />
    <telerik:RadNumericTextBox ID="RadTextBox10" Label="Take_Rate: " Runat="server"   EmptyMessage="Enter Take Rate" Width="300px"/>    
                    <br />
    <telerik:RadNumericTextBox ID="RadTextBox9" Label="Family_Allocation: " Runat="server"   EmptyMessage="Enter Family Allocation" Width="300px"/>
                    <br />
                    <br />
                <div id="Div2" runat="server" >
                    <center>
                      
                    <telerik:RadButton  ID="RadButton3" 
                                        runat="server" 
                                        onclick="RadButton3_Click"
                                        Text="Assign CSM Mnemonic"
                                        Height="22px" 
                                        Width="200px">
                    </telerik:RadButton>
                    
                    <asp:SqlDataSource  ID="SqlDataSource7" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part_mnemonic" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id" ControlID="RadTextBox1" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="mnemonic" ControlID="RadTextBox2" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="base_part" ControlID="RadTextBox3" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="qty_per" ControlID="RadTextBox8" Type="Decimal" PropertyName="Text" />
                                                <asp:ControlParameter Name="family_allocation" ControlID="RadTextBox9" Type="Decimal" PropertyName="Text" />
                                                <asp:ControlParameter Name="take_rate" ControlID="RadTextBox10" Type="Decimal" PropertyName="Text" />
                                            </InsertParameters>
                    </asp:SqlDataSource>
                    
                </center>
                    
            </div>

        </telerik:RadPane>
    <telerik:RadSplitBar CollapseMode="Both" ID="RadSplitBar1" runat="server" EnableResize="true" BorderWidth="5px">
    </telerik:RadSplitBar> 
    
    
    <telerik:RadPane ID="gridPane" runat="server" Height="800px" Width="1000px" Scrolling="None" >
            
            <strong>CSM Demand:</strong>
            
            <telerik:RadGrid    ID="RadGrid2" 
                                runat="server"  
                                AllowFilteringByColumn="True" 
                                AllowSorting="True" 
                                CellSpacing="0" 
                                DataSourceID="ListofCSMMnemonics" 
                                GridLines="None" 
                                EditMode="InPlace" 
                                ClientSettings-AllowRowsDragDrop="True" 
                                AllowMultiRowSelection="True" 
                                onselectedindexchanged="RadGrid2_SelectedIndexChanged" 
                                Height="800px"
                          
                               
                                >
                
                <ClientSettings EnablePostBackOnRowClick="true">
                    <Selecting AllowRowSelect="True"  />
                    <Scrolling AllowScroll="True" UseStaticHeaders="true" />
                  
                </ClientSettings>
                
                <MasterTableView    AutoGenerateColumns="False" 
                                    DataSourceID="ListofCSMMnemonics" 
                                    TableLayout="Auto"
                                    DataKeyNames="MnemonicVehiclePlant" 
                                    >
                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                        <HeaderStyle Width="20px" />
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                        <HeaderStyle Width="20px" />
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridClientSelectColumn FilterControlAltText="Filter column column" 
                        HeaderStyle-Width="50px"
                            UniqueName="column">
                        </telerik:GridClientSelectColumn>
                        <telerik:GridBoundColumn DataField="MnemonicVehiclePlant" 
                            FilterControlAltText="Filter Mnemonic-Vehicle/Plant column" 
                            HeaderStyle-Width="75px"
                            HeaderText="MnemonicVehiclePlant" SortExpression="MnemonicVehiclePlant" 
                            UniqueName="MnemonicVehiclePlant">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Platform" 
                        HeaderStyle-Width="100px"
                            FilterControlAltText="Filter Platform column" HeaderText="Platform" 
                            SortExpression="Platform" UniqueName="Platform">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Program" 
                            FilterControlAltText="Filter Program column" HeaderText="Program" 
                            SortExpression="Program" UniqueName="Program">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Vehicle" 
                            FilterControlAltText="Filter Vehicle column" HeaderText="Vehicle" 
                            SortExpression="Vehicle" UniqueName="Vehicle">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Manufacturer" 
                            FilterControlAltText="Filter Manufacturer column" HeaderText="Manufacturer" 
                            SortExpression="Manufacturer" UniqueName="Manufacturer">
                        </telerik:GridBoundColumn>
                        <Telerik:GridDateTimeColumn DataField="SOP" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter SOP column" HeaderText="SOP" SortExpression="SOP" UniqueName="SOP">
                        </Telerik:GridDateTimeColumn>
                        <Telerik:GridDateTimeColumn DataField="EOP" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter EOP column" HeaderText="EOP" SortExpression="SOP" UniqueName="EOP">
                        </Telerik:GridDateTimeColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                </MasterTableView>
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="ListofCSMMnemonics" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="select [Mnemonic-Vehicle/Plant] as [MnemonicVehiclePlant], [Platform],[Program],[Vehicle],[Manufacturer],[SOP],[EOP] from eeiuser.acctg_csm_naihs where release_id = (select max(release_id) from eeiuser.acctg_csm_naihs) and version = 'CSM'">
            </asp:SqlDataSource>

</telerik:RadPane>
</telerik:RadSplitter>

</asp:panel>
    </form>
</body>
</html>
