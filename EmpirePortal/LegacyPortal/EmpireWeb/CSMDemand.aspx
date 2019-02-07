<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSMDemand.aspx.cs" Inherits="RadGridRelatedForm" %>
<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New Part to Master Sales Forecast</title>
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
            <telerik:AjaxSetting AjaxControlID="RadGrid_CSMDemand">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid_CSMDemand" />
                    <telerik:AjaxUpdatedControl ControlID="SDS_CSMDemand" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBox103" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>


    <asp:panel ID="Panel1" runat="server" Height="100%">
 
        <telerik:RadSplitter ID="RadSplitter" Height="100%" Width="1800px" runat="server" Orientation="Vertical">
    
            <telerik:RadPane ID="RadPane1" runat="server" Height="800px" Width="450px" Scrolling="Y">
     
                <b>Step 1:  Add New Base Part to Master Sales Forecast:</b>
                <br />
                <br />     
                <table>
                    <tr>
                        <td width="225px"> Release ID: </td>
                        <td width="225px"><telerik:RadDropDownList ID="RadTextBox1" runat="server"  Width="220px" DataSourceID="SqlDataSource1" DataTextField="release_id" DataValueField="release_id" DefaultMessage="Select Forecast Release ID" >
                            </telerik:RadDropDownList>  
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="select top 3 release_id from eeiuser.acctg_csm_base_part_attributes group by release_id order by 1 desc">
                                </asp:SqlDataSource></td>
                    </tr>

                    <tr>
                        <td width="225px"> Base Part: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox2" Runat="server" EmptyMessage="Enter Base Part" Width="220px" /></td>
                    </tr>

                    <tr>
                        <td width="225px"> Saleperson: </td>
                        <td width="225px"><telerik:RadDropDownList ID="RadTextBox3" runat="server"  Width="220px" DefaultMessage="Select Salesperson" >
                                <Items>
                                    <Telerik:DropDownListItem Text="Brad Carson" />
                                    <Telerik:DropDownListItem Text="John F Doman" />
                                    <Telerik:DropDownListItem Text="Jeff Michaels" />
                                    <Telerik:DropDownListItem Text="Pat Traynor" />
                                </Items>
                            </telerik:RadDropDownList></td>
                    </tr>

                    <tr>
                        <td width="225px"> Date of Award: </td>
                        <td> <telerik:RadTextBox ID="RadTextBox4" Runat="server" InputType="Date" Width="220px"/> </td>
                    </tr>

                    <tr>
                        <td width="225px"> Type of Award: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox5" Runat="server" EmptyMessage="Enter Type of Award" Width="220px"/> </td>       
                    </tr>

                    <tr>
                        <td width="225px"> Family: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox6" Runat="server" EmptyMessage="Enter Family"  Width="220px"/></td>
                    </tr>

                    <tr>
                        <td width="225px"> Customer: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox7" Runat="server" EmptyMessage="Enter Customer" Width="220px"/></td>
                    </tr>

                    <tr>
                        <td width="225px"> Parent Customer: </td>
                        <td width="225px"> <telerik:RadTextBox ID="RadTextBox8" Runat="server" EmptyMessage="Enter Parent Customer" Width="220px"/> </td>
                    </tr>

                    <tr>
                        <td width="225px"> Product Line: </td>
                        <td width="225px"> <telerik:RadDropDownList ID="RadTextBox9" runat="server"  Width="220px" DefaultMessage="Select Product Line" >
                                <Items>
                                    <Telerik:DropDownListItem Text="Wire Harn - EEH" />
                                    <Telerik:DropDownListItem Text="Bulbed Wire Harn - EEH" />
                                    <Telerik:DropDownListItem Text="ES3 Components" />
                                    <Telerik:DropDownListItem Text="Bulbed ES3 Components" />
                                    <Telerik:DropDownListItem Text="PCB" />
                                </Items>
                            </telerik:RadDropDownList>  
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="225px"> Empire Market Segment: </td>
                        <td width="225px"><Telerik:RadComboBox ID="RadTextBox10" runat="server"  Width="220px" DataSourceID="SqlDataSource2"  DataTextField="empire_market_segment" DataValueField="empire_market_segment" EmptyMessage="Select Empire Market Segment" AllowCustomText="true" Filter="StartsWith" MarkFirstMatch="true" >
                            </telerik:RadComboBox>  
                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="select distinct(empire_market_segment) from eeiuser.acctg_csm_base_part_attributes where release_id = 
                                                    (select max(release_id) from eeiuser.acctg_csm_base_part_attributes) order by 1 asc">
                                </asp:SqlDataSource>
                        </td>
                    </tr>
       
                    <tr>
                        <td width="225px"> Empire Market SubSegment: </td>
                        <td width="225px"> <telerik:RadComboBox ID="RadTextBox11" runat="server"  Width="220px" DataSourceID="SqlDataSource3" DataTextField="empire_market_subsegment" DataValueField="empire_market_subsegment" EmptyMessage="Select Empire Market SubSegment" AllowCustomText="true" Filter="StartsWith" MarkFirstMatch="true" >
                            </telerik:RadComboBox>  
                                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="select distinct(empire_market_subsegment) from eeiuser.acctg_csm_base_part_attributes where release_id = 
                                                    (select max(release_id) from eeiuser.acctg_csm_base_part_attributes) order by 1 asc">
                                </asp:SqlDataSource>
                        </td>
                    </tr>
 
                     <tr>
                        <td width="225px"> Empire Application: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox12" Runat="server" EmptyMessage="Enter Empire Application" Width="220px"/></td>
                    </tr>
        
                    <tr>
                        <td width="225px"> Empire SOP: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox13"  Runat="server" InputType="Date" Width="220px"/></td>
                    </tr>

                    <tr>
                        <td width="225px"> Empire EOP: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox14" Runat="server" InputType="Date" Width="220px"/> </td>        
                    </tr>

                    <tr>
                        <td width="225px"> Customer Selling Price: </td>
                        <td width="225px"><telerik:RadNumericTextBox ID="RadTextBox15" runat="server" EmptyMessage="Enter Customer Selling price" Width="220px">
                                                <NegativeStyle Resize="None" />
                                                <NumberFormat DecimalDigits="4" ZeroPattern="n" />
                                            </Telerik:RadNumericTextBox>
                        </td>
                    </tr>

                    <tr>
                        <td width="225px"> Material Cost: </td>
                        <td width="225px"><telerik:RadNumericTextBox ID="RadTextBox16" Runat="server"  EmptyMessage="Enter Material Cost" Width="220px">
                                                <NumberFormat DecimalDigits="6" ZeroPattern="n" />
                                          </Telerik:RadNumericTextBox>
                        </td>
                    </tr>
        
                    <tr>
                        <td width="225px"> Part Used for Material Cost: </td>
                        <td width="225px"> <telerik:RadTextBox ID="RadTextBox17" Runat="server" EmptyMessage="Enter Part Used For Material Cost" Width="220px"/></td>
                    </tr>

                    <tr>
                        <td width="225px"> Include in Master Sales Forecast? </td>
                        <td width="225px"><asp:CheckBox ID="CheckBox1" runat="server" Checked="true" Width="220px" TextAlign="Left"/></td>
                    </tr>
                </table>
                <br /> 
                <br />
                
            <div id="Div1" runat="server" >
                <center>
                                
                    <telerik:RadButton  ID="RadButton1_InsertPart" 
                                        runat="server"  
                                        onclick="RadButton1_InsertPart_Click"
                                        Text="Create New Base Part" 
                                        Height="22px" 
                                        Width="200px">
                    </telerik:RadButton>
                        
                    <asp:SqlDataSource  ID="SDS_InsertPart" 
                                        runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                        InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part" 
                                        InsertCommandType="StoredProcedure" >
                                            <InsertParameters>
                                                <asp:ControlParameter Name="release_id"                 ControlID="RadTextBox1"        Type="String"     PropertyName="SelectedText" />
                                                <asp:ControlParameter Name="base_part"                  ControlID="RadTextBox2"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="salesperson"                ControlID="RadTextBox3"         Type="String"        PropertyName="SelectedText" />
                                                <asp:ControlParameter Name="date_of_award"              ControlID="RadTextBox4"         Type="DateTime"       PropertyName="Text" />
                                                <asp:ControlParameter Name="type_of_award"              ControlID="RadTextBox5"         Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="family"                     ControlID="RadTextBox6"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="customer"                   ControlID="RadTextBox7"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="parent_customer"            ControlID="RadTextBox8"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="product_line"               ControlID="RadTextBox9"        Type="String"       PropertyName="SelectedText" />
                                                <asp:ControlParameter Name="empire_market_segment"      ControlID="RadTextBox10"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_market_subsegment"   ControlID="RadTextBox11"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_application"         ControlID="RadTextBox12"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_sop"                 ControlID="RadTextBox13"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="empire_eop"                 ControlID="RadTextBox14"        Type="DateTime"     PropertyName="Text" />
                                                <asp:ControlParameter Name="sp"                         ControlID="RadTextBox15"        Type="Decimal"      PropertyName="Text" />
                                                <asp:controlParameter Name="mc"                         ControlID="RadTextBox16"        Type="Decimal"      PropertyName="Text" />
                                                <asp:ControlParameter Name="part_used_for_mc"           ControlID="RadTextBox17"        Type="String"       PropertyName="Text" />
                                                <asp:ControlParameter Name="include_in_forecast"        ControlID="CheckBox1"           Type="Boolean"      PropertyName="Checked" />
                                            </InsertParameters>
                    </asp:SqlDataSource>
                        
                </center>
            </div>                          
                    
            </telerik:RadPane>
            
                <telerik:RadSplitBar CollapseMode="Both" ID="RadSplitBar1" runat="server" EnableResize="true" BorderWidth="10px"/>
            
            <telerik:RadPane ID="RadPane2" runat="server" Height="800px" Width="350px" Scrolling="None" BorderColor ="Blue">
            
                <b> Step 2: Assign CSM Demand:</b>      
                <br />
                <br />
        
                <table>    
                    <tr>
                        <td width="225px"> Release ID: </td>
                        <td width="225px"><telerik:RadDropDownList ID="RadTextBox101" runat="server"  Width="220px" DataSourceID="SqlDataSource1" DataTextField="release_id" DataValueField="release_id" DefaultMessage="Select Forecast Release ID" >
                            </telerik:RadDropDownList>  
                                <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="select top 3 release_id from eeiuser.acctg_csm_base_part_attributes group by release_id order by 1 desc">
                                </asp:SqlDataSource></td>
                    </tr>

                    <tr>
                        <td width="225px"> Enter Base Part: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox102" Runat="server" EmptyMessage="Enter Base Part" Width="220px" /></td>
                    </tr>

                    <tr>
                        <td width="225px"> Enter Mnemonic: </td>
                        <td width="225px"><telerik:RadTextBox ID="RadTextBox103" Runat="server" EmptyMessage="Enter Mnemonic"  Width="220px" /> </td>
                    </tr>

                   <tr>
                        <td width="225px"> Enter Qty Per: </td>
                        <td width="225px"><telerik:RadNumericTextBox ID="RadTextBox104" Runat="server" EmptyMessage="Enter Qty Per" Width="220px"/></td>
                   </tr>

                    <tr>
                        <td width="225px"> Enter Take Rate: </td>
                        <td width="225px"><telerik:RadNumericTextBox ID="RadTextBox105" Runat="server"  EmptyMessage="Enter Take Rate" Width="220px"/> </td>
                   </tr>

                    <tr>
                       <td width="225px"> Enter Family Allocation: </td>
                        <td width="225px"><telerik:RadNumericTextBox ID="RadTextBox106" Runat="server"   EmptyMessage="Enter Family Allocation" Width="220px"/></td>
                    </tr>

                        </table>
                                <br />
                                <br />
                            <div id="Div2" runat="server" >
                                <center>
                      
                                <telerik:RadButton  ID="RadButton2" 
                                                    runat="server" 
                                                    onclick="RadButton2_Click"
                                                    Text="Assign CSM Mnemonic"
                                                    Height="22px" 
                                                    Width="200px">
                                </telerik:RadButton>
                    
                                <asp:SqlDataSource  ID="SDS_AssignMnemonics" 
                                                    runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                                    InsertCommand="eeiuser.acctg_csm_sp_insert_new_base_part_mnemonic" 
                                                    InsertCommandType="StoredProcedure" >
                                                        <InsertParameters>
                                                            <asp:ControlParameter Name="release_id"         ControlID="RadTextBox101"     Type="String"   PropertyName="SelectedText" />
                                                            <asp:ControlParameter Name="mnemonic"           ControlID="RadTextBox103"     Type="String"   PropertyName="Text" />
                                                            <asp:ControlParameter Name="base_part"          ControlID="RadTextBox102"     Type="String"   PropertyName="Text" />
                                                            <asp:ControlParameter Name="qty_per"            ControlID="RadTextBox104"     Type="Decimal"  PropertyName="Text" />
                                                            <asp:ControlParameter Name="family_allocation"  ControlID="RadTextBox105"     Type="Decimal"  PropertyName="Text" />
                                                            <asp:ControlParameter Name="take_rate"          ControlID="RadTextBox106"     Type="Decimal"  PropertyName="Text" />
                                                        </InsertParameters>
                                </asp:SqlDataSource>
                    
                            </center>
                    
                        </div>

                    </telerik:RadPane>
    
                <telerik:RadSplitBar CollapseMode="Both" ID="RadSplitBar2" runat="server" EnableResize="true" BorderWidth="10px"/>
    
                    <telerik:RadPane ID="RadPane3" runat="server" Height="800px" Width="1200px" Scrolling="None" >
            
                        <strong>CSM Demand:</strong>
            
                        <telerik:RadGrid    ID="RadGrid_CSMDemand" 
                                            runat="server"  
                                            AllowFilteringByColumn="True" 
                                            AllowSorting="True" 
                                            CellSpacing="0" 
                                            DataSourceID="SDS_CSMDemand" 
                                            GridLines="None" 
                                            AllowMultiRowSelection="True" 
                                            OnSelectedIndexChanged="RadGrid_CSMDemand_SelectedIndexChanged"
                                            Height="800px"
                                            ClientSettings-Resizing-AllowColumnResize="true" >
                
                            <ClientSettings EnablePostBackOnRowClick="true">
                                <Selecting AllowRowSelect="True"  />
                                <Scrolling AllowScroll="True" UseStaticHeaders="true" />
                            </ClientSettings>
                
                            <MasterTableView    AutoGenerateColumns="False" 
                                                DataSourceID="SDS_CSMDemand" 
                                                TableLayout="Auto"
                                                DataKeyNames="MnemonicVehiclePlant" 
                                                >
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
                                        HeaderStyle-Width="125px"
                                        HeaderText="MnemonicVehiclePlant" 
                                        SortExpression="MnemonicVehiclePlant" 
                                        UniqueName="MnemonicVehiclePlant">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Region" 
                                        HeaderStyle-Width="125px"
                                        FilterControlAltText="Filter Region column" 
                                        HeaderText="Region" 
                                        SortExpression="Region" 
                                        UniqueName="Region">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn    DataField="Manufacturer" 
                                                                FilterControlAltText="Filter Manufacturer column" 
                                                                HeaderStyle-Width="125px"
                                                                HeaderText="Manufacturer" 
                                                                SortExpression="Manufacturer" 
                                                                UniqueName="Manufacturer">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn    DataField="Platform" 
                                                                HeaderStyle-Width="100px"
                                                                FilterControlAltText="Filter Platform column" 
                                                                HeaderText="Platform" 
                                                                SortExpression="Platform" 
                                                                UniqueName="Platform">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn    DataField="Program" 
                                                                FilterControlAltText="Filter Program column" 
                                                                HeaderStyle-Width="100px"
                                                                HeaderText="Program" 
                                                                SortExpression="Program" 
                                                                UniqueName="Program">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn    DataField="Nameplate" 
                                                                FilterControlAltText="Filter Nameplate column" 
                                                                HeaderStyle-Width="100px"
                                                                HeaderText="Nameplate" 
                                                                SortExpression="Nameplate" 
                                                                UniqueName="Nameplate">
                                    </telerik:GridBoundColumn>           
                                    <Telerik:GridDateTimeColumn DataField="SOP" 
                                                                DataFormatString="{0:d}" 
                                                                DataType="System.DateTime" 
                                                                FilterControlAltText="Filter SOP column" 
                                                                HeaderStyle-Width="100px"
                                                                HeaderText="SOP" 
                                                                SortExpression="SOP" 
                                                                UniqueName="SOP">
                                    </Telerik:GridDateTimeColumn>
                                    <Telerik:GridDateTimeColumn DataField="EOP" 
                                                                DataFormatString="{0:d}" 
                                                                DataType="System.DateTime" 
                                                                FilterControlAltText="Filter EOP column" 
                                                                HeaderStyle-Width="100px"
                                                                HeaderText="EOP" 
                                                                SortExpression="SOP" 
                                                                UniqueName="EOP">
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
            
                        <asp:SqlDataSource  ID="SDS_CSMDemand" 
                                            runat="server" 
                                            ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                            SelectCommand="select [Mnemonic-Vehicle/Plant] as [MnemonicVehiclePlant], [Region],[Manufacturer],[Platform],[Program],[Nameplate],[SOP],[EOP] from eeiuser.acctg_csm_naihs where release_id = dbo.fn_ReturnLatestCSMRelease('CSM') and version = 'CSM'">
                        </asp:SqlDataSource>

            </telerik:RadPane>
        </telerik:RadSplitter>

    </asp:panel>
</form>
</body>
</html>
