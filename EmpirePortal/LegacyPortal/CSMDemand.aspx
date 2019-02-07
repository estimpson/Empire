<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSMDemand.aspx.cs"
    Inherits="RadGridRelatedForm" %>

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


    <asp:panel ID="Panel1" runat="server">
 

<%--            <strong>Choose Base Part:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox ID="BasePartComboBox2" Runat="server" 
                DataSourceID="BasePartComboBoxDataSource2" DataTextField="base_part" 
                DataValueField="base_part" MarkFirstMatch="true" AutoPostBack="true" >
            </telerik:RadComboBox>            
            <asp:SqlDataSource ID="BasePartComboBoxDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="SELECT DISTINCT [BASE_PART] FROM [eeiuser].[acctg_csm_base_part_mnemonic] order by 1">
            </asp:SqlDataSource>

            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            


            <br />--%>

            <br />
            

    <telerik:RadSplitter ID="RadSplitter1" Width="1650px" runat="server" Orientation="Vertical">
    
    <telerik:RadPane ID="FormPane" runat="server" Height="500px" Width="350px" Scrolling="None">
           
<%--             <span class="style1">Choose Release ID:&nbsp;</span>&nbsp;
            
            <telerik:RadComboBox ID="ReleaseIDComboBox2" Runat="server" 
                DataSourceID="ReleaseIDComboBoxDataSource2" DataTextField="release_id" 
                DataValueField="release_id" MarkFirstMatch="true" AutoPostBack="true">
            </telerik:RadComboBox>
                       <asp:SqlDataSource ID="ReleaseIDComboBoxDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="SELECT distinct([release_id]) FROM [eeiuser].[acctg_csm_naihs] order by 1 desc">
            </asp:SqlDataSource>--%>        
            <telerik:RadTextBox ID="RadTextBox1" Label="Release_ID" Runat="server" EmptyMessage="Enter Release ID"  Width="300px" Height="20px">
    </telerik:RadTextBox>
                <br />
    <telerik:RadTextBox ID="RadTextBox2" Label="Mnemonic" Runat="server" EmptyMessage="Enter Mnemonic"  Width="300px" Height="20px"> 
    </telerik:RadTextBox>
                    <br />
    <telerik:RadTextBox ID="RadTextBox3" Label="BasePart: " Runat="server" EmptyMessage="Enter Base Part" Width="300px" Height="20px">
    </telerik:RadTextBox>
                    <br />
    <telerik:RadTextBox ID="RadTextBox4" Label="Family: " Runat="server" EmptyMessage="Enter Base Part"  Width="300px">
    </telerik:RadTextBox>
                    <br />
    <telerik:RadTextBox ID="RadTextBox5" Label="Customer: " Runat="server" EmptyMessage="Enter Customer" Width="300px">
    </telerik:RadTextBox>
                    <br />
    <telerik:RadTextBox ID="RadTextBox6" Label="Empire_Market_Segment: " Runat="server" EmptyMessage="Enter Empire Market Segment" Width="300px">
    </telerik:RadTextBox><br />
    <telerik:RadTextBox ID="RadTextBox7" Label="Empire_Application: " Runat="server" EmptyMessage="Enter Empire Application" Width="300px">
    </telerik:RadTextBox><br />
        <telerik:RadTextBox ID="RadTextBox8" Label="Qty_per: " Runat="server" InputType="Number" Width="300px">
    </telerik:RadTextBox><br />
        <telerik:RadTextBox ID="RadTextBox9" Label="Family_Allocation: " Runat="server" InputType="Number" Width="300px">
    </telerik:RadTextBox><br />
            <telerik:RadTextBox ID="RadTextBox10" Label="Take_Rate: " Runat="server" InputType="Number" Width="300px">
    </telerik:RadTextBox><br />
            <telerik:RadTextBox ID="RadTextBox11" Label="Empire_SOP: " Runat="server" InputType="Date" Width="300px">
    </telerik:RadTextBox><br />
            <telerik:RadTextBox ID="RadTextBox12" Label="Empire_EOP: " Runat="server" InputType="Date" Width="300px">
    </telerik:RadTextBox>           <br />
     <telerik:RadTextBox ID="RadTextBox13" Label="Customer Selling Price: " Runat="server" EmptyMessage="Enter Customer Selling Price" InputType="Number" Width="300px">
    </telerik:RadTextBox>

                    <div runat="server" ><center>
                    <br />  
                    
                    <telerik:RadButton  ID="RadButton1" 
                                        runat="server"  
                                        onclick="RadButton1_Click"
                                        Text="Submit Part Setup" 
                                        Height="20px" 
                                        Width="200px">
                    </telerik:RadButton>
                                        
                    <asp:SqlDataSource  ID="SqlDataSource5" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part_mnemonic" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id"             ControlID="RadTextBox1"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="mnemonic"               ControlID="RadTextBox2"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="base_part"              ControlID="RadTextBox3"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="family"                 ControlID="RadTextBox4"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="customer"               ControlID="RadTextBox5"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_segment"  ControlID="RadTextBox6"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_application"     ControlID="RadTextBox7"     Type="String"   PropertyName="Text" />
                                                <asp:ControlParameter Name="qty_per"                ControlID="RadTextBox8"     Type="Decimal"  PropertyName="Text" />
                                                <asp:ControlParameter Name="family_allocation"      ControlID="RadTextBox9"     Type="Decimal"  PropertyName="Text" />
                                                <asp:ControlParameter Name="take_rate"              ControlID="RadTextBox10"    Type="Decimal"  PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_sop"             ControlID="RadTextBox11"    Type="DateTime" PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_eop"             ControlID="RadTextBox12"    Type="DateTime" PropertyName="Text" />
                                                <asp:ControlParameter Name="sp"                     ControlID="RadTextBox13"    Type="Decimal"  PropertyName="Text" />
                                            </InsertParameters>
                    </asp:SqlDataSource>

                    <br />
                    <telerik:RadButton  ID="RadButton3" 
                                        runat="server" 
                                        onclick="RadButton3_Click"
                                        Text="Submit CSM Mnemonic"
                                        Height="20px" 
                                        Width="200px">
                    </telerik:RadButton>
                    
                    <asp:SqlDataSource  ID="SqlDataSource7" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part_mnemonic_2" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id" ControlID="RadTextBox1" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="mnemonic" ControlID="RadTextBox2" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="base_part" ControlID="RadTextBox3" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="family" ControlID="RadTextBox4" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="customer" ControlID="RadTextBox5" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_segment" ControlID="RadTextBox6" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_application" ControlID="RadTextBox7" Type="String" PropertyName="Text" />
                                                <asp:ControlParameter Name="qty_per" ControlID="RadTextBox8" Type="Decimal" PropertyName="Text" />
                                                <asp:ControlParameter Name="family_allocation" ControlID="RadTextBox9" Type="Decimal" PropertyName="Text" />
                                                <asp:ControlParameter Name="take_rate" ControlID="RadTextBox10" Type="Decimal" PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_sop" ControlID="RadTextBox11" Type="DateTime" PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_eop" ControlID="RadTextBox12" Type="DateTime" PropertyName="Text" />
                                                <asp:ControlParameter Name="sp" ControlID="RadTextBox13" Type = "Decimal" PropertyName="Text" />
                                            </InsertParameters>
                    </asp:SqlDataSource>
                    
                </center>
                    
            </div>

    </telerik:RadPane>
    
    <telerik:RadSplitBar CollapseMode="Both" ID="RadSplitBar2" runat="server" EnableResize="true" BorderWidth="5px">
    </telerik:RadSplitBar>
    
    <telerik:RadPane ID="gridPane" runat="server" Height="500px" Width="1300px" Scrolling="None" >
            
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
                        <telerik:GridBoundColumn DataField="SOP" DataType="System.DateTime" 
                            FilterControlAltText="Filter SOP column" HeaderText="SOP" SortExpression="SOP" 
                            UniqueName="SOP">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EOP" DataType="System.DateTime" 
                            FilterControlAltText="Filter EOP column" HeaderText="EOP" SortExpression="EOP" 
                            UniqueName="EOP">
                        </telerik:GridBoundColumn>
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


            <strong>Base Part Mnemonics:</strong>
            <telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="True" DataSourceID="SqlDataSource4"
                GridLines="None" Width="95%" Height="30%" OnItemCommand="RadGrid1_ItemCommand" 
                CellSpacing="0" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" 
                AllowAutomaticUpdates="True" AllowFilteringByColumn="True" AllowSorting="True" 
                EnableHeaderContextMenu="True" ShowFooter="True" ShowStatusBar="True" 
                AutoGenerateColumns="False" >
                <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
                    <Selecting AllowRowSelect="true" />
                </ClientSettings>
                <MasterTableView DataKeyNames="FORECAST_ID,MNEMONIC,BASE_PART" DataSourceID="SqlDataSource4" 
                    AllowMultiColumnSorting="True" ShowFooter="True"  >
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
                        <telerik:GridBoundColumn DataField="FORECAST_ID" 
                            FilterControlAltText="Filter FORECAST_ID column" HeaderText="FORECAST_ID" 
                            ReadOnly="True" SortExpression="FORECAST_ID" UniqueName="FORECAST_ID">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="MNEMONIC" 
                            FilterControlAltText="Filter MNEMONIC column" HeaderText="MNEMONIC" 
                            ReadOnly="True" SortExpression="MNEMONIC" UniqueName="MNEMONIC">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BASE_PART" 
                            FilterControlAltText="Filter BASE_PART column" HeaderText="BASE_PART" 
                            ReadOnly="True" SortExpression="BASE_PART" UniqueName="BASE_PART">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FAMILY" 
                            FilterControlAltText="Filter FAMILY column" HeaderText="FAMILY" 
                            SortExpression="FAMILY" UniqueName="FAMILY">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CUSTOMER" 
                            FilterControlAltText="Filter CUSTOMER column" HeaderText="CUSTOMER" 
                            SortExpression="CUSTOMER" UniqueName="CUSTOMER">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EMPIRE_MARKET_SEGMENT" 
                            FilterControlAltText="Filter EMPIRE_MARKET_SEGMENT column" 
                            HeaderText="EMPIRE_MARKET_SEGMENT" SortExpression="EMPIRE_MARKET_SEGMENT" 
                            UniqueName="EMPIRE_MARKET_SEGMENT">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EMPIRE_APPLICATION" 
                            FilterControlAltText="Filter EMPIRE_APPLICATION column" 
                            HeaderText="EMPIRE_APPLICATION" SortExpression="EMPIRE_APPLICATION" 
                            UniqueName="EMPIRE_APPLICATION">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="QTY_PER" DataType="System.Decimal" 
                            FilterControlAltText="Filter QTY_PER column" HeaderText="QTY_PER" 
                            SortExpression="QTY_PER" UniqueName="QTY_PER">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="TAKE_RATE" DataType="System.Decimal" 
                            FilterControlAltText="Filter TAKE_RATE column" HeaderText="TAKE_RATE" 
                            SortExpression="TAKE_RATE" UniqueName="TAKE_RATE">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FAMILY_ALLOCATION" 
                            DataType="System.Decimal" 
                            FilterControlAltText="Filter FAMILY_ALLOCATION column" 
                            HeaderText="FAMILY_ALLOCATION" SortExpression="FAMILY_ALLOCATION" 
                            UniqueName="FAMILY_ALLOCATION">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EMPIRE_SOP" DataType="System.DateTime" 
                            FilterControlAltText="Filter EMPIRE_SOP column" HeaderText="EMPIRE_SOP" 
                            SortExpression="EMPIRE_SOP" UniqueName="EMPIRE_SOP">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EMPIRE_EOP" DataType="System.DateTime" 
                            FilterControlAltText="Filter EMPIRE_EOP column" HeaderText="EMPIRE_EOP" 
                            SortExpression="EMPIRE_EOP" UniqueName="EMPIRE_EOP">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                </MasterTableView>
                <PagerStyle Mode="NextPrevAndNumeric"   />
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                ConflictDetection="CompareAllValues" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                DeleteCommand="DELETE FROM [eeiuser].[acctg_csm_base_part_mnemonic] WHERE [FORECAST_ID] = @original_FORECAST_ID AND [MNEMONIC] = @original_MNEMONIC AND [BASE_PART] = @original_BASE_PART AND (([FAMILY] = @original_FAMILY) OR ([FAMILY] IS NULL AND @original_FAMILY IS NULL)) AND (([CUSTOMER] = @original_CUSTOMER) OR ([CUSTOMER] IS NULL AND @original_CUSTOMER IS NULL)) AND (([EMPIRE_MARKET_SEGMENT] = @original_EMPIRE_MARKET_SEGMENT) OR ([EMPIRE_MARKET_SEGMENT] IS NULL AND @original_EMPIRE_MARKET_SEGMENT IS NULL)) AND (([EMPIRE_APPLICATION] = @original_EMPIRE_APPLICATION) OR ([EMPIRE_APPLICATION] IS NULL AND @original_EMPIRE_APPLICATION IS NULL)) AND (([QTY_PER] = @original_QTY_PER) OR ([QTY_PER] IS NULL AND @original_QTY_PER IS NULL)) AND (([TAKE_RATE] = @original_TAKE_RATE) OR ([TAKE_RATE] IS NULL AND @original_TAKE_RATE IS NULL)) AND (([FAMILY_ALLOCATION] = @original_FAMILY_ALLOCATION) OR ([FAMILY_ALLOCATION] IS NULL AND @original_FAMILY_ALLOCATION IS NULL)) AND (([EMPIRE_SOP] = @original_EMPIRE_SOP) OR ([EMPIRE_SOP] IS NULL AND @original_EMPIRE_SOP IS NULL)) AND (([EMPIRE_EOP] = @original_EMPIRE_EOP) OR ([EMPIRE_EOP] IS NULL AND @original_EMPIRE_EOP IS NULL))" 
                InsertCommand="INSERT INTO [eeiuser].[acctg_csm_base_part_mnemonic] ([FORECAST_ID], [MNEMONIC], [BASE_PART], [FAMILY], [CUSTOMER], [EMPIRE_MARKET_SEGMENT], [EMPIRE_APPLICATION], [QTY_PER], [TAKE_RATE], [FAMILY_ALLOCATION], [EMPIRE_SOP], [EMPIRE_EOP]) VALUES (@FORECAST_ID, @MNEMONIC, @BASE_PART, @FAMILY, @CUSTOMER, @EMPIRE_MARKET_SEGMENT, @EMPIRE_APPLICATION, @QTY_PER, @TAKE_RATE, @FAMILY_ALLOCATION, @EMPIRE_SOP, @EMPIRE_EOP)" 
                OldValuesParameterFormatString="original_{0}" 
                SelectCommand="SELECT [FORECAST_ID], [MNEMONIC], [BASE_PART], [FAMILY], [CUSTOMER], [EMPIRE_MARKET_SEGMENT], [EMPIRE_APPLICATION], [QTY_PER], [TAKE_RATE], [FAMILY_ALLOCATION], [EMPIRE_SOP], [EMPIRE_EOP] FROM [eeiuser].[acctg_csm_base_part_mnemonic]" 
                UpdateCommand="UPDATE [eeiuser].[acctg_csm_base_part_mnemonic] SET [FAMILY] = @FAMILY, [CUSTOMER] = @CUSTOMER, [EMPIRE_MARKET_SEGMENT] = @EMPIRE_MARKET_SEGMENT, [EMPIRE_APPLICATION] = @EMPIRE_APPLICATION, [QTY_PER] = @QTY_PER, [TAKE_RATE] = @TAKE_RATE, [FAMILY_ALLOCATION] = @FAMILY_ALLOCATION, [EMPIRE_SOP] = @EMPIRE_SOP, [EMPIRE_EOP] = @EMPIRE_EOP WHERE [FORECAST_ID] = @original_FORECAST_ID AND [MNEMONIC] = @original_MNEMONIC AND [BASE_PART] = @original_BASE_PART AND (([FAMILY] = @original_FAMILY) OR ([FAMILY] IS NULL AND @original_FAMILY IS NULL)) AND (([CUSTOMER] = @original_CUSTOMER) OR ([CUSTOMER] IS NULL AND @original_CUSTOMER IS NULL)) AND (([EMPIRE_MARKET_SEGMENT] = @original_EMPIRE_MARKET_SEGMENT) OR ([EMPIRE_MARKET_SEGMENT] IS NULL AND @original_EMPIRE_MARKET_SEGMENT IS NULL)) AND (([EMPIRE_APPLICATION] = @original_EMPIRE_APPLICATION) OR ([EMPIRE_APPLICATION] IS NULL AND @original_EMPIRE_APPLICATION IS NULL)) AND (([QTY_PER] = @original_QTY_PER) OR ([QTY_PER] IS NULL AND @original_QTY_PER IS NULL)) AND (([TAKE_RATE] = @original_TAKE_RATE) OR ([TAKE_RATE] IS NULL AND @original_TAKE_RATE IS NULL)) AND (([FAMILY_ALLOCATION] = @original_FAMILY_ALLOCATION) OR ([FAMILY_ALLOCATION] IS NULL AND @original_FAMILY_ALLOCATION IS NULL)) AND (([EMPIRE_SOP] = @original_EMPIRE_SOP) OR ([EMPIRE_SOP] IS NULL AND @original_EMPIRE_SOP IS NULL)) AND (([EMPIRE_EOP] = @original_EMPIRE_EOP) OR ([EMPIRE_EOP] IS NULL AND @original_EMPIRE_EOP IS NULL))">
                <DeleteParameters>
                    <asp:Parameter Name="original_FORECAST_ID" Type="String" />
                    <asp:Parameter Name="original_MNEMONIC" Type="String" />
                    <asp:Parameter Name="original_BASE_PART" Type="String" />
                    <asp:Parameter Name="original_FAMILY" Type="String" />
                    <asp:Parameter Name="original_CUSTOMER" Type="String" />
                    <asp:Parameter Name="original_EMPIRE_MARKET_SEGMENT" Type="String" />
                    <asp:Parameter Name="original_EMPIRE_APPLICATION" Type="String" />
                    <asp:Parameter Name="original_QTY_PER" Type="Decimal" />
                    <asp:Parameter Name="original_TAKE_RATE" Type="Decimal" />
                    <asp:Parameter Name="original_FAMILY_ALLOCATION" Type="Decimal" />
                    <asp:Parameter Name="original_EMPIRE_SOP" Type="DateTime" />
                    <asp:Parameter Name="original_EMPIRE_EOP" Type="DateTime" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="FORECAST_ID" Type="String" />
                    <asp:Parameter Name="MNEMONIC" Type="String" />
                    <asp:Parameter Name="BASE_PART" Type="String" />
                    <asp:Parameter Name="FAMILY" Type="String" />
                    <asp:Parameter Name="CUSTOMER" Type="String" />
                    <asp:Parameter Name="EMPIRE_MARKET_SEGMENT" Type="String" />
                    <asp:Parameter Name="EMPIRE_APPLICATION" Type="String" />
                    <asp:Parameter Name="QTY_PER" Type="Decimal" />
                    <asp:Parameter Name="TAKE_RATE" Type="Decimal" />
                    <asp:Parameter Name="FAMILY_ALLOCATION" Type="Decimal" />
                    <asp:Parameter Name="EMPIRE_SOP" Type="DateTime" />
                    <asp:Parameter Name="EMPIRE_EOP" Type="DateTime" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="FAMILY" Type="String" />
                    <asp:Parameter Name="CUSTOMER" Type="String" />
                    <asp:Parameter Name="EMPIRE_MARKET_SEGMENT" Type="String" />
                    <asp:Parameter Name="EMPIRE_APPLICATION" Type="String" />
                    <asp:Parameter Name="QTY_PER" Type="Decimal" />
                    <asp:Parameter Name="TAKE_RATE" Type="Decimal" />
                    <asp:Parameter Name="FAMILY_ALLOCATION" Type="Decimal" />
                    <asp:Parameter Name="EMPIRE_SOP" Type="DateTime" />
                    <asp:Parameter Name="EMPIRE_EOP" Type="DateTime" />
                    <asp:Parameter Name="original_FORECAST_ID" Type="String" />
                    <asp:Parameter Name="original_MNEMONIC" Type="String" />
                    <asp:Parameter Name="original_BASE_PART" Type="String" />
                    <asp:Parameter Name="original_FAMILY" Type="String" />
                    <asp:Parameter Name="original_CUSTOMER" Type="String" />
                    <asp:Parameter Name="original_EMPIRE_MARKET_SEGMENT" Type="String" />
                    <asp:Parameter Name="original_EMPIRE_APPLICATION" Type="String" />
                    <asp:Parameter Name="original_QTY_PER" Type="Decimal" />
                    <asp:Parameter Name="original_TAKE_RATE" Type="Decimal" />
                    <asp:Parameter Name="original_FAMILY_ALLOCATION" Type="Decimal" />
                    <asp:Parameter Name="original_EMPIRE_SOP" Type="DateTime" />
                    <asp:Parameter Name="original_EMPIRE_EOP" Type="DateTime" />
                </UpdateParameters>
            </asp:SqlDataSource>

    </asp:panel>
    </form>
</body>
</html>
