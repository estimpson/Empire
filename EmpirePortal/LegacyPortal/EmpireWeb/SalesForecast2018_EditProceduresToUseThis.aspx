<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecast.aspx.cs" Inherits="SalesForecast" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Forecast</title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
        .RadInput_Default{font:12px "segoe ui",arial,sans-serif}
        .RadInput{vertical-align:middle}
        .style1
        {
            border-collapse: collapse;
            width: 100%;
            vertical-align: bottom;
            border-style: none;
            border-color: inherit;
            border-width: 0;
        }
        .style2
        {
            width: 100%;
            padding-right: 4px;
        }
        .style3 {
            display: inline-table;
        }
    </style>
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
            <telerik:AjaxSetting AjaxControlID="BasePartComboBox">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="CheckBox1" />
                    <Telerik:AjaxUpdatedControl ControlID="CheckBox1DataSource" />
                    <telerik:AjaxUpdatedControl ControlID="BasePartAttributesRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="BasePartAttributesRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="BasePartNotesRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="BasePartNotesRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="ActualDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="ActualDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="CSMDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="CSMDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="SellingPriceRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="SellingPriceRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGridDataSource" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="CSMDemandRadGrid">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="CSMDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="CSMDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGridDataSource" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="EmpireFactorRadGrid">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireFactorRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="AdjustedCSMDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGridDataSource" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="EmpireAdjustmentRadGrid">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="EmpireAdjustmentRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalDemandRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalRevenueRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="MaterialCostRadGridDataSource" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="TotalMaterialRadGridDataSource" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">
        <div>
            <!-- BASE PART DROP DOWN -->

            <strong>Choose Base Part:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox ID="BasePartComboBox" runat="server" DataSourceID="BasePartComboBoxDataSource"
                DataTextField="base_part" DataValueField="base_part" MarkFirstMatch="true" AutoPostBack="true">
            </telerik:RadComboBox>
            <asp:SqlDataSource ID="BasePartComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="SELECT DISTINCT [BASE_PART] FROM [eeiuser].[acctg_csm_base_part_mnemonic] order by 1">
            </asp:SqlDataSource>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
            <!-- RELEASE ID DROP DOWN -->
            
            <strong>Choose Release ID:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox ID="ReleaseIDComboBox" runat="server" DataSourceID="ReleaseIDComboBoxDataSource"
                DataTextField="release_id" DataValueField="release_id" MarkFirstMatch="true"
                AutoPostBack="true" MaxHeight="400px" >
            </telerik:RadComboBox>
            <asp:SqlDataSource ID="ReleaseIDComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="SELECT distinct([release_id]) FROM [eeiuser].[acctg_csm_naihs] order by 1 desc">
            </asp:SqlDataSource>
    
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" 
                Title="Notes" InitialBehaviors="Minimize" VisibleOnPageLoad="True" 
                Behaviors="Resize, Minimize, Maximize, Move" Left="900px"  Top="40px" Behavior="Resize, Minimize, Maximize, Move" InitialBehavior="Minimize">
                <Windows>
                    <telerik:RadWindow ID="NotesWindow" runat="server" Width="355px" Height ="500px" MinHeight="500px" MinWidth="355px" AutoSize="true">
                    <ContentTemplate>
                        <telerik:RadGrid    ID="BasePartNotesRadGrid" 
                                runat="server" 
                                DataSourceID="BasePartNotesRadGridDataSource" 
                                AutoGenerateColumns="False" 
                                CellSpacing="0" 
                                GridLines="None"
                                ShowHeader="false" 
                                Height="500px"
                                Width="355px" 
                                AllowAutomaticDeletes="True" 
                                AllowAutomaticInserts="True" 
                                AllowAutomaticUpdates="True"
                             
                                 >
                    
                        <MasterTableView    DataSourceID="BasePartNotesRadGridDataSource" 
                                        CommandItemDisplay="Top"
                                        CommandItemStyle-Height="40px"
                                        ShowHeader="false"
                                        TableLayout="Fixed"  >
                             
                   
                    <CommandItemSettings    ShowRefreshButton="false"
                                            AddNewRecordText="Add Note"
                                            ShowAddNewRecordButton="true"
                                        
                                            >
                    </CommandItemSettings> 
                    
                            <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                            Visible="True">
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                            Visible="True">
                        </ExpandCollapseColumn>
                        <Columns>
                            <telerik:GridTemplateColumn HeaderButtonType="None" UniqueName="TemplateColumn">
                                <InsertItemTemplate>
                                    <br />
                                    <telerik:RadTextBox ID="RadTextBox1" Runat="server" BackColor="Wheat" 
                                        BorderStyle="None" LabelWidth="75px" Rows="10" 
                                        Text='<%# Bind("note", "{0}") %>' TextMode="MultiLine" Width="320px">
                                    </telerik:RadTextBox>
                                    <br />
                                </InsertItemTemplate>
                                <EditItemTemplate>
                                    <telerik:RadDateInput ID="RadDateInput1" Runat="server" BackColor="Transparent" 
                                        BorderStyle="None" Culture="en-US" DateFormat="M/d/yyyy" 
                                        DbSelectedDate='<%# Bind("time_stamp") %>' DisplayDateFormat="M/d/yyyy h:mm tt" 
                                        LabelWidth="75px" ReadOnly="true" SelectedDate='<%# Bind("time_stamp") %>' 
                                        Width="160px">
                                    </telerik:RadDateInput>
                                    <telerik:RadComboBox ID="RadComboBox1" Runat="server" AutoPostBack="true" 
                                        SelectedValue='<%# Bind("status") %>'>
                                        <Items>
                                            <telerik:RadComboBoxItem runat="server" Text="Open" Value="Open" />
                                            <telerik:RadComboBoxItem runat="server" Text="Closed" Value="Closed" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <br />
                                    <telerik:RadTextBox ID="RadTextBox1" Runat="server" AutoPostBack="true" 
                                        BackColor="Transparent" LabelWidth="75px" Text='<%# Bind("note", "{0}") %>' 
                                        TextMode="MultiLine" Width="325px">
                                    </telerik:RadTextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <telerik:RadDateInput ID="RadDateInput1" Runat="server" AutoPostBack="True" 
                                        BackColor="Transparent" BorderStyle="None" Culture="en-US" 
                                        DateFormat="M/d/yyyy" DbSelectedDate='<%# Bind("time_stamp") %>' 
                                        DisplayDateFormat="M/d/yyyy h:mm tt" LabelCssClass="" LabelWidth="75px" 
                                        SelectedDate='<%# Bind("time_stamp") %>' Width="160px">
                                        <ReadOnlyStyle BorderStyle="None" />
                                    </telerik:RadDateInput>
                                    <telerik:RadComboBox ID="RadComboBox1" Runat="server" AutoPostBack="true" 
                                        SelectedValue='<%# Bind("status") %>' Width="160px">
                                        <Items>
                                            <telerik:RadComboBoxItem runat="server" Text="Open" Value="Open" />
                                            <telerik:RadComboBoxItem runat="server" Text="Closed" Value="Closed" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <br />
                                    <telerik:RadTextBox ID="RadTextBox1" Runat="server" AutoPostBack="true" 
                                        BackColor="Transparent" BorderStyle="None" Height="48px" LabelWidth="75px" 
                                        
                                        Rows="3" 
                                        SelectionOnFocus="CaretToBeginning" Text='<%# Bind("note", "{0}") %>' 
                                        TextMode="MultiLine" Width="100%">
                                    </telerik:RadTextBox>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                            <EditFormSettings>
                                <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                                </EditColumn>
                            </EditFormSettings>
                    
                        <CommandItemStyle Height="40px" />
                    
                    </MasterTableView>
                    
                    <ClientSettings>
                            <Scrolling  AllowScroll="True" 
                                        UseStaticHeaders="True">
                            </Scrolling>
                    </ClientSettings>             
                    
                    <FilterMenu EnableImageSprites="False">
                    </FilterMenu>
                    
            </telerik:RadGrid>

            <asp:SqlDataSource ID="BasePartNotesRadGridDataSource" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="SELECT [time_stamp], [status], [note] FROM [eeiuser].[acctg_csm_base_part_notes] WHERE (([base_part] = @base_part) AND ([release_id] = @release_id)) order by time_stamp desc"
                InsertCommand="INSERT INTO [eeiuser].[acctg_csm_base_part_notes] values (@release_id,@base_part,getdate(),'Open',@Note)"
                UpdateCommand="UPDATE [eeiuser].[acctg_csm_base_part_notes] set note=@note where (([base_part] = @base_part) and ([release_id]=@release_id) and ([time_stamp] = @time_stamp))" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" 
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" 
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue" Type="String" />
                    <asp:Parameter Name="Note" Type="String" />
                    </InsertParameters>
                <UpdateParameters>
                <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue" Type="String" />
                <asp:Parameter Name = "Time_Stamp" Type="DateTime" />
                <asp:Parameter Name = "Note" Type="String" />
                </UpdateParameters>

                    
                
            </asp:SqlDataSource>

                    </ContentTemplate>
                    </telerik:RadWindow>
                </Windows>
            </telerik:RadWindowManager>
                 
            <br />    
            <br />      
            
            <!-- BASE PART TO MNEMONIC ASSOCIATION GRID -->
            
            <strong>Part Detail:</strong>
            <telerik:RadGrid    ID="BasePartAttributesRadGrid" 
                                runat="server" 
                                DataSourceID="BasePartAttributesRadGridDataSource"
                                AutoGenerateColumns="False"
                                AllowAutomaticUpdates="True" 
                                CellSpacing="0" 
                                GridLines="None" 
                                >
                <MasterTableView    DataSourceID="BasePartAttributesRadGridDataSource" 
                                    EditMode="InPlace">

                    <CommandItemSettings    ExportToPdfText="Export to PDF" />
                    
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                        <HeaderStyle            Width="20px" />
                    </RowIndicatorColumn>
                    
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
                        <HeaderStyle            Width="20px" />
                    </ExpandCollapseColumn>
                    
                    <EditFormSettings>
                        <EditColumn         FilterControlAltText="Filter EditCommandColumn column"/>
                    </EditFormSettings>
                    
                    <Columns>
                        <telerik:GridEditCommandColumn  FilterControlAltText="Filter EditCommandColumn column">
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn        DataField="Salesperson" 
                                                        HeaderText="Salesperson" 
                                                        FilterControlAltText="Filter Salesperson column"  
                                                        SortExpression="Salesperson" 
                                                        UniqueName="Salesperson">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="date_of_award" 
                                                        HeaderText="DateofAward" 
                                                        FilterControlAltText="Filter DateOfAward column"  
                                                        SortExpression="DateOfAward" 
                                                        UniqueName="DateOfAward">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="type_of_award" 
                                                        HeaderText="TypeofAward" 
                                                        FilterControlAltText="Filter TypeOfAward column"  
                                                        SortExpression="TypeOfAward" 
                                                        UniqueName="TypeOfAward">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>                          
                        <telerik:GridBoundColumn        DataField="family" 
                                                        HeaderText="Family" 
                                                        FilterControlAltText="Filter family column"  
                                                        SortExpression="family" 
                                                        UniqueName="family">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="customer" 
                                                        HeaderText="Customer" 
                                                        FilterControlAltText="Filter customer column"  
                                                        SortExpression="customer" 
                                                        UniqueName="customer">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="parent_customer" 
                                                        HeaderText="Parent Customer" 
                                                        FilterControlAltText="Filter parent_customer column" 
                                                        SortExpression="Parent_customer" 
                                                        UniqueName="parent_customer">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="product_line" 
                            FilterControlAltText="Filter product_line column" HeaderText="Product Line" 
                            SortExpression="product_line" UniqueName="product_line">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_segment" 
                            FilterControlAltText="Filter empire_market_segment column" 
                            HeaderText="Empire Market Segment" SortExpression="empire_market_segment" 
                            UniqueName="empire_market_segment">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_subsegment" 
                            FilterControlAltText="Filter empire_market_subsegment column" 
                            HeaderText="Empire Market SubSegment" SortExpression="empire_market_subsegment" 
                            UniqueName="empire_market_subsegment">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_application" 
                            FilterControlAltText="Filter empire_application column" 
                            HeaderText="Part Description" SortExpression="empire_application" 
                            UniqueName="empire_application">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                         <Telerik:GridDateTimeColumn DataField="empire_sop" DataFormatString="{0:d}" FilterControlAltText="Filter empire_sop column" HeaderText="Empire SOP" UniqueName="empire_sop">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridDateTimeColumn>
                        <Telerik:GridDateTimeColumn DataField="empire_eop" DataFormatString="{0:d}" FilterControlAltText="Filter empire_eop column" HeaderText="Empire EOP" UniqueName="empire_eop">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridDateTimeColumn>
                        <Telerik:GridCheckBoxColumn DataField="include_in_forecast" DataType="System.Boolean" FilterControlAltText="Filter column column" HeaderText="Include in Forecast?" UniqueName="column">
                        </Telerik:GridCheckBoxColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:SqlDataSource  ID="BasePartAttributesRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.acctg_csm_sp_select_base_part_attributes" 
                                SelectCommandType="StoredProcedure"
                                UpdateCommand="eeiuser.acctg_csm_sp_update_base_part_attributes" 
                                UpdateCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="BasePartComboBox"    Name="base_part"    PropertyName="SelectedValue"    Type="String" />
                    <asp:ControlParameter   ControlID="ReleaseIDComboBox"   Name="release_id"   PropertyName="SelectedValue"    Type="String" />
                </SelectParameters>
                
                <UpdateParameters>
                    <asp:ControlParameter   ControlID="BasePartComboBox"    Name="base_part"    PropertyName="SelectedValue"    Type="String" />
                    <asp:ControlParameter   ControlID="ReleaseIDComboBox"   Name="release_id"   PropertyName="SelectedValue"    Type="String" />
                   <asp:Parameter                                           Name="salesperson"                                   Type="String" />
                    <asp:Parameter                                          Name="date_of_award"                                Type="DateTime" />
                    <asp:Parameter                                          Name="type_of_award"                                Type="String" />   
                    <asp:Parameter                                          Name="family"                                       Type="String" />
                    <asp:Parameter                                          Name="customer"                                     Type="String" />
                    <asp:Parameter                                          Name="parent_customer"                              Type="String" />
                    <asp:Parameter                                          Name="product_line"                                 Type="String" />
                    <asp:Parameter                                          Name="empire_market_segment"                        Type="String" />
                    <asp:Parameter                                          Name="empire_market_subsegment"                     Type="String" />
                    <asp:Parameter                                          Name="empire_application"                           Type="String" />
                    <asp:Parameter                                          Name="empire_sop"                                   Type="DateTime" />
                    <asp:Parameter                                          Name="empire_eop"                                   Type="DateTime" />
                    <asp:Parameter                                          Name="include_in_forecast"                          Type="Boolean" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <br />

            <!-- HISTORICAL AND PLANNING DEMAND GRID -->
            
            <strong>Actual Demand:</strong>
            <telerik:RadGrid ID="ActualDemandRadGrid" runat="server" CellSpacing="0" GridLines="None"
                AutoGenerateColumns="False" DataSourceID="ActualDemandRadGridDataSource" 
                Width="3600px">
                <MasterTableView DataSourceID="ActualDemandRadGridDataSource" AutoGenerateColumns="False"
                    ShowFooter="true" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                    AlternatingItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right"
                    TableLayout="Fixed" HeaderStyle-Width="54">
                    <CommandItemSettings ExportToPdfText="Export to PDF" ShowAddNewRecordButton="true"
                        AddNewRecordText="Click here to add a record" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column"
                            HeaderText="description"  SortExpression="description" UniqueName="description"
                            ReadOnly="True" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="Jan 2015" DataType="System.Decimal" FilterControlAltText="Filter Jan 2015 column"
                            HeaderText="Jan 2015" ReadOnly="True" SortExpression="Jan 2015" 
                            UniqueName="Jan2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2015" DataType="System.Decimal" FilterControlAltText="Filter Feb 2015 column"
                            HeaderText="Feb 2015" ReadOnly="True" SortExpression="Feb 2015" 
                            UniqueName="Feb2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2015" DataType="System.Decimal" FilterControlAltText="Filter Mar 2015 column"
                            HeaderText="Mar 2015" ReadOnly="True" SortExpression="Mar 2015" 
                            UniqueName="Mar2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2015" DataType="System.Decimal" FilterControlAltText="Filter Apr 2015 column"
                            HeaderText="Apr 2015" ReadOnly="True" SortExpression="Apr 2015" 
                            UniqueName="Apr2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2015" DataType="System.Decimal" FilterControlAltText="Filter May 2015 column"
                            HeaderText="May 2015" ReadOnly="True" SortExpression="May 2015" 
                            UniqueName="May2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2015" DataType="System.Decimal" FilterControlAltText="Filter Jun 2015 column"
                            HeaderText="Jun 2015" ReadOnly="True" SortExpression="Jun 2015" 
                            UniqueName="Jun2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2015" DataType="System.Decimal" FilterControlAltText="Filter Jul 2015 column"
                            HeaderText="Jul 2015" ReadOnly="True" SortExpression="Jul 2015" 
                            UniqueName="Jul2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2015" DataType="System.Decimal" FilterControlAltText="Filter Aug 2015 column"
                            HeaderText="Aug 2015" ReadOnly="True" SortExpression="Aug 2015" 
                            UniqueName="Aug2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2015" DataType="System.Decimal" FilterControlAltText="Filter Sep 2015 column"
                            HeaderText="Sep 2015" ReadOnly="True" SortExpression="Sep 2015" 
                            UniqueName="Sep2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2015" DataType="System.Decimal" FilterControlAltText="Filter Oct 2015 column"
                            HeaderText="Oct 2015" ReadOnly="True" SortExpression="Oct 2015" 
                            UniqueName="Oct2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2015" DataType="System.Decimal" FilterControlAltText="Filter Nov 2015 column"
                            HeaderText="Nov 2015" ReadOnly="True" SortExpression="Nov 2015" 
                            UniqueName="Nov2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2015" DataType="System.Decimal" FilterControlAltText="Filter Dec 2015 column"
                            HeaderText="Dec 2015" ReadOnly="True" SortExpression="Dec 2015" 
                            UniqueName="Dec2015" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="Jan 2016" DataType="System.Decimal" FilterControlAltText="Filter Jan 2016 column"
                            HeaderText="Jan 2016" ReadOnly="True" SortExpression="Jan 2016" 
                            UniqueName="Jan2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2016" DataType="System.Decimal" FilterControlAltText="Filter Feb 2016 column"
                            HeaderText="Feb 2016" ReadOnly="True" SortExpression="Feb 2016" 
                            UniqueName="Feb2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2016" DataType="System.Decimal" FilterControlAltText="Filter Mar 2016 column"
                            HeaderText="Mar 2016" ReadOnly="True" SortExpression="Mar 2016" 
                            UniqueName="Mar2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2016" DataType="System.Decimal" FilterControlAltText="Filter Apr 2016 column"
                            HeaderText="Apr 2016" ReadOnly="True" SortExpression="Apr 2016" 
                            UniqueName="Apr2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2016" DataType="System.Decimal" FilterControlAltText="Filter May 2016 column"
                            HeaderText="May 2016" ReadOnly="True" SortExpression="May 2016" 
                            UniqueName="May2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2016" DataType="System.Decimal" FilterControlAltText="Filter Jun 2016 column"
                            HeaderText="Jun 2016" ReadOnly="True" SortExpression="Jun 2016" 
                            UniqueName="Jun2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2016" DataType="System.Decimal" FilterControlAltText="Filter Jul 2016 column"
                            HeaderText="Jul 2016" ReadOnly="True" SortExpression="Jul 2016" 
                            UniqueName="Jul2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2016" DataType="System.Decimal" FilterControlAltText="Filter Aug 2016 column"
                            HeaderText="Aug 2016" ReadOnly="True" SortExpression="Aug 2016" 
                            UniqueName="Aug2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2016" DataType="System.Decimal" FilterControlAltText="Filter Sep 2016 column"
                            HeaderText="Sep 2016" ReadOnly="True" SortExpression="Sep 2016" 
                            UniqueName="Sep2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2016" DataType="System.Decimal" FilterControlAltText="Filter Oct 2016 column"
                            HeaderText="Oct 2016" ReadOnly="True" SortExpression="Oct 2016" 
                            UniqueName="Oct2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2016" DataType="System.Decimal" FilterControlAltText="Filter Nov 2016 column"
                            HeaderText="Nov 2016" ReadOnly="True" SortExpression="Nov 2016" 
                            UniqueName="Nov2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2016" DataType="System.Decimal" FilterControlAltText="Filter Dec 2016 column"
                            HeaderText="Dec 2016" ReadOnly="True" SortExpression="Dec 2016" 
                            UniqueName="Dec2016" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                                                
                        <telerik:GridBoundColumn DataField="Jan 2017" DataType="System.Decimal" FilterControlAltText="Filter Jan 2017 column"
                            HeaderText="Jan 2017" ReadOnly="True" SortExpression="Jan 2017" 
                            UniqueName="Jan2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2017" DataType="System.Decimal" FilterControlAltText="Filter Feb 2017 column"
                            HeaderText="Feb 2017" ReadOnly="True" SortExpression="Feb 2017" 
                            UniqueName="Feb2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2017" DataType="System.Decimal" FilterControlAltText="Filter Mar 2017 column"
                            HeaderText="Mar 2017" ReadOnly="True" SortExpression="Mar 2017" 
                            UniqueName="Mar2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2017" DataType="System.Decimal" FilterControlAltText="Filter Apr 2017 column"
                            HeaderText="Apr 2017" ReadOnly="True" SortExpression="Apr 2017" 
                            UniqueName="Apr2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2017" DataType="System.Decimal" FilterControlAltText="Filter May 2017 column"
                            HeaderText="May 2017" ReadOnly="True" SortExpression="May 2017" 
                            UniqueName="May2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2017" DataType="System.Decimal" FilterControlAltText="Filter Jun 2017 column"
                            HeaderText="Jun 2017" ReadOnly="True" SortExpression="Jun 2017" 
                            UniqueName="Jun2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2017" DataType="System.Decimal" FilterControlAltText="Filter Jul 2017 column"
                            HeaderText="Jul 2017" ReadOnly="True" SortExpression="Jul 2017" 
                            UniqueName="Jul2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2017" DataType="System.Decimal" FilterControlAltText="Filter Aug 2017 column"
                            HeaderText="Aug 2017" ReadOnly="True" SortExpression="Aug 2017" 
                            UniqueName="Aug2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2017" DataType="System.Decimal" FilterControlAltText="Filter Sep 2017 column"
                            HeaderText="Sep 2017" ReadOnly="True" SortExpression="Sep 2017" 
                            UniqueName="Sep2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2017" DataType="System.Decimal" FilterControlAltText="Filter Oct 2017 column"
                            HeaderText="Oct 2017" ReadOnly="True" SortExpression="Oct 2017" 
                            UniqueName="Oct2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2017" DataType="System.Decimal" FilterControlAltText="Filter Nov 2017 column"
                            HeaderText="Nov 2017" ReadOnly="True" SortExpression="Nov 2017" 
                            UniqueName="Nov2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2017" DataType="System.Decimal" FilterControlAltText="Filter Dec 2017 column"
                            HeaderText="Dec 2017" ReadOnly="True" SortExpression="Dec 2017" 
                            UniqueName="Dec2017" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>

                                                
                        <telerik:GridBoundColumn DataField="Jan 2018" DataType="System.Decimal" FilterControlAltText="Filter Jan 2018 column"
                            HeaderText="Jan 2018" ReadOnly="True" SortExpression="Jan 2018" 
                            UniqueName="Jan2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2018" DataType="System.Decimal" FilterControlAltText="Filter Feb 2018 column"
                            HeaderText="Feb 2018" ReadOnly="True" SortExpression="Feb 2018" 
                            UniqueName="Feb2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2018" DataType="System.Decimal" FilterControlAltText="Filter Mar 2018 column"
                            HeaderText="Mar 2018" ReadOnly="True" SortExpression="Mar 2018" 
                            UniqueName="Mar2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2018" DataType="System.Decimal" FilterControlAltText="Filter Apr 2018 column"
                            HeaderText="Apr 2018" ReadOnly="True" SortExpression="Apr 2018" 
                            UniqueName="Apr2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2018" DataType="System.Decimal" FilterControlAltText="Filter May 2018 column"
                            HeaderText="May 2018" ReadOnly="True" SortExpression="May 2018" 
                            UniqueName="May2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2018" DataType="System.Decimal" FilterControlAltText="Filter Jun 2018 column"
                            HeaderText="Jun 2018" ReadOnly="True" SortExpression="Jun 2018" 
                            UniqueName="Jun2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2018" DataType="System.Decimal" FilterControlAltText="Filter Jul 2018 column"
                            HeaderText="Jul 2018" ReadOnly="True" SortExpression="Jul 2018" 
                            UniqueName="Jul2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2018" DataType="System.Decimal" FilterControlAltText="Filter Aug 2018 column"
                            HeaderText="Aug 2018" ReadOnly="True" SortExpression="Aug 2018" 
                            UniqueName="Aug2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2018" DataType="System.Decimal" FilterControlAltText="Filter Sep 2018 column"
                            HeaderText="Sep 2018" ReadOnly="True" SortExpression="Sep 2018" 
                            UniqueName="Sep2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2018" DataType="System.Decimal" FilterControlAltText="Filter Oct 2018 column"
                            HeaderText="Oct 2018" ReadOnly="True" SortExpression="Oct 2018" 
                            UniqueName="Oct2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2018" DataType="System.Decimal" FilterControlAltText="Filter Nov 2018 column"
                            HeaderText="Nov 2018" ReadOnly="True" SortExpression="Nov 2018" 
                            UniqueName="Nov2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2018" DataType="System.Decimal" FilterControlAltText="Filter Dec 2018 column"
                            HeaderText="Dec 2018" ReadOnly="True" SortExpression="Dec 2018" 
                            UniqueName="Dec2018" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="Jan 2019" DataType="System.Decimal" FilterControlAltText="Filter Jan 2019 column"
                            HeaderText="Jan 2019" ReadOnly="True" SortExpression="Jan 2019" 
                            UniqueName="Jan2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Feb 2019" DataType="System.Decimal" FilterControlAltText="Filter Feb 2019 column"
                            HeaderText="Feb 2019" ReadOnly="True" SortExpression="Feb 2019" 
                            UniqueName="Feb2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Mar 2019" DataType="System.Decimal" FilterControlAltText="Filter Mar 2019 column"
                            HeaderText="Mar 2019" ReadOnly="True" SortExpression="Mar 2019" 
                            UniqueName="Mar2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Apr 2019" DataType="System.Decimal" FilterControlAltText="Filter Apr 2019 column"
                            HeaderText="Apr 2019" ReadOnly="True" SortExpression="Apr 2019" 
                            UniqueName="Apr2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="May 2019" DataType="System.Decimal" FilterControlAltText="Filter May 2019 column"
                            HeaderText="May 2019" ReadOnly="True" SortExpression="May 2019" 
                            UniqueName="May2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Jun 2019" DataType="System.Decimal" FilterControlAltText="Filter Jun 2019 column"
                            HeaderText="Jun 2019" ReadOnly="True" SortExpression="Jun 2019" 
                            UniqueName="Jun2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Jul 2019" DataType="System.Decimal" FilterControlAltText="Filter Jul 2019 column"
                            HeaderText="Jul 2019" ReadOnly="True" SortExpression="Jul 2019" 
                            UniqueName="Jul2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Aug 2019" DataType="System.Decimal" FilterControlAltText="Filter Aug 2019 column"
                            HeaderText="Aug 2019" ReadOnly="True" SortExpression="Aug 2019" 
                            UniqueName="Aug2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sep 2019" DataType="System.Decimal" FilterControlAltText="Filter Sep 2019 column"
                            HeaderText="Sep 2019" ReadOnly="True" SortExpression="Sep 2019" 
                            UniqueName="Sep2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Oct 2019" DataType="System.Decimal" FilterControlAltText="Filter Oct 2019 column"
                            HeaderText="Oct 2019" ReadOnly="True" SortExpression="Oct 2019" 
                            UniqueName="Oct2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Nov 2019" DataType="System.Decimal" FilterControlAltText="Filter Nov 2019 column"
                            HeaderText="Nov 2019" ReadOnly="True" SortExpression="Nov 2019" 
                            UniqueName="Nov2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Dec 2019" DataType="System.Decimal" FilterControlAltText="Filter Dec 2019 column"
                            HeaderText="Dec 2019" ReadOnly="True" SortExpression="Dec 2019" 
                            UniqueName="Dec2019" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="Jan 2020" DataType="System.Decimal" FilterControlAltText="Filter Jan 2020 column"
                            HeaderText="Jan 2020" ReadOnly="True" SortExpression="Jan 2020" 
                            UniqueName="Jan2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Feb 2020" DataType="System.Decimal" FilterControlAltText="Filter Feb 2020 column"
                            HeaderText="Feb 2020" ReadOnly="True" SortExpression="Feb 2020" 
                            UniqueName="Feb2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Mar 2020" DataType="System.Decimal" FilterControlAltText="Filter Mar 2020 column"
                            HeaderText="Mar 2020" ReadOnly="True" SortExpression="Mar 2020" 
                            UniqueName="Mar2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Apr 2020" DataType="System.Decimal" FilterControlAltText="Filter Apr 2020 column"
                            HeaderText="Apr 2020" ReadOnly="True" SortExpression="Apr 2020" 
                            UniqueName="Apr2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="May 2020" DataType="System.Decimal" FilterControlAltText="Filter May 2020 column"
                            HeaderText="May 2020" ReadOnly="True" SortExpression="May 2020" 
                            UniqueName="May2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Jun 2020" DataType="System.Decimal" FilterControlAltText="Filter Jun 2020 column"
                            HeaderText="Jun 2020" ReadOnly="True" SortExpression="Jun 2020" 
                            UniqueName="Jun2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Jul 2020" DataType="System.Decimal" FilterControlAltText="Filter Jul 2020 column"
                            HeaderText="Jul 2020" ReadOnly="True" SortExpression="Jul 2020" 
                            UniqueName="Jul2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Aug 2020" DataType="System.Decimal" FilterControlAltText="Filter Aug 2020 column"
                            HeaderText="Aug 2020" ReadOnly="True" SortExpression="Aug 2020" 
                            UniqueName="Aug2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Sep 2020" DataType="System.Decimal" FilterControlAltText="Filter Sep 2020 column"
                            HeaderText="Sep 2020" ReadOnly="True" SortExpression="Sep 2020" 
                            UniqueName="Sep2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Oct 2020" DataType="System.Decimal" FilterControlAltText="Filter Oct 2020 column"
                            HeaderText="Oct 2020" ReadOnly="True" SortExpression="Oct 2020" 
                            UniqueName="Oct2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Nov 2020" DataType="System.Decimal" FilterControlAltText="Filter Nov 2020 column"
                            HeaderText="Nov 2020" ReadOnly="True" SortExpression="Nov 2020" 
                            UniqueName="Nov2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="Dec 2020" DataType="System.Decimal" FilterControlAltText="Filter Dec 2020 column"
                            HeaderText="Dec 2020" ReadOnly="True" SortExpression="Dec 2020" 
                            UniqueName="Dec2020" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="total_2020" DataType="System.Decimal" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" ReadOnly="True" SortExpression="total_2020" UniqueName="total_2020"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="total_2021" DataType="System.Decimal" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
			<telerik:GridBoundColumn DataField="total_2022" DataType="System.Decimal" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <ItemStyle HorizontalAlign="Right" />
                    <AlternatingItemStyle HorizontalAlign="Right" />
                    <HeaderStyle HorizontalAlign="Right" Width="54px" />
                    <FooterStyle HorizontalAlign="Right" />
                </MasterTableView>
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="ActualDemandRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_total_planner_demand2" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            
            <br />

            <!-- CSM DEMAND GRID (RAW DEMAND x QTY PER x FAMILY ALLOCATION x TAKE RATE) -->
 
            <strong>Master Sales Forecast Demand:</strong>
            <telerik:RadGrid ID="CSMDemandRadGrid" runat="server" CellSpacing="0" GridLines="None"
                AutoGenerateColumns="False"  DataSourceID="CSMDemandRadGridDataSource" Width="3600px" OnItemUpdated="CsmDemandRadGrid_ItemUpdated" >
                <MasterTableView DataSourceID="CSMDemandRadGridDataSource" DataKeyNames="base_part,mnemonicvehicleplant" AutoGenerateColumns="False"
                    ShowFooter="true" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                    AlternatingItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right"
                    TableLayout="Fixed" HeaderStyle-Width="54" EditMode="InPlace" AllowAutomaticUpdates="true" CommandItemDisplay="Top" >
                    <CommandItemSettings ShowExportToExcelButton="true" ExportToPdfText="Export to PDF"  ShowAddNewRecordButton="true"
                        AddNewRecordText="Assign a New Program" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <Telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column" HeaderStyle-Width="75">
                            <HeaderStyle Width="75px" />
                        </Telerik:GridEditCommandColumn>
                        <Telerik:GridBoundColumn DataField="base_part" Display="False" FilterControlAltText="Filter base_part column" ForceExtractValue="Always" HeaderStyle-Width="75" HeaderText="Base Part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column" HeaderStyle-Width="75" HeaderText="Version" ReadOnly="true" SortExpression="version" UniqueName="version">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="release_id" Display="False" FilterControlAltText="Filter release_id column" HeaderStyle-Width="75" HeaderText="Release ID" SortExpression="release_id" UniqueName="release_id">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="MnemonicVehiclePlant" FilterControlAltText="Filter MnemonicVehiclePlant column" ForceExtractValue="Always" HeaderStyle-Width="75" HeaderText="MnemonicVehiclePlant" ReadOnly="True" SortExpression="MnemonicVehiclePlant" UniqueName="MnemonicVehiclePlant">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="platform" FilterControlAltText="Filter platform column" HeaderStyle-Width="75" HeaderText="Platform" ReadOnly="true" SortExpression="platform" UniqueName="platform">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column" HeaderStyle-Width="75" HeaderText="Program" ReadOnly="true" SortExpression="program" UniqueName="program">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="vehicle" FilterControlAltText="Filter vehicle column" HeaderStyle-Width="75" HeaderText="Vehicle" ReadOnly="True" SortExpression="vehicle" UniqueName="vehicle">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="plant" FilterControlAltText="Filter plant column" HeaderStyle-Width="75" HeaderText="Plant" ReadOnly="true" SortExpression="plant" UniqueName="plant">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="sop" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter sop column" HeaderStyle-Width="75" HeaderText="SOP" ReadOnly="true" SortExpression="sop" UniqueName="sop">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="eop" DataFormatString="{0:d}" DataType="System.DateTime" FilterControlAltText="Filter eop column" HeaderStyle-Width="75" HeaderText="EOP" ReadOnly="true" SortExpression="eop" UniqueName="eop">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="qty_per" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter qty_per column" HeaderText="Qty Per" SortExpression="qty_per" UniqueName="qty_per">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="take_rate" DataFormatString="{0:N2}" DataType="System.Decimal" FilterControlAltText="Filter take_rate column" HeaderText="Take Rate" SortExpression="take_rate" UniqueName="take_rate">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn DataField="family_allocation" DataFormatString="{0:N2}" DataType="System.Decimal" FilterControlAltText="Filter family_allocation column" HeaderStyle-Width="75" HeaderText="Family Allocation" SortExpression="family_allocation" UniqueName="family_allocation">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
  
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2015" ReadOnly="True" SortExpression="jan 2015" UniqueName="jan2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2015" ReadOnly="True" SortExpression="feb 2015" UniqueName="feb2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2015" ReadOnly="True" SortExpression="mar 2015" UniqueName="mar2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2015" ReadOnly="True" SortExpression="apr 2015" UniqueName="apr2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2015" ReadOnly="True" SortExpression="may 2015" UniqueName="may2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2015" ReadOnly="True" SortExpression="jun 2015" UniqueName="jun2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2015" ReadOnly="True" SortExpression="jul 2015" UniqueName="jul2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2015" ReadOnly="True" SortExpression="aug 2015" UniqueName="aug2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2015" ReadOnly="True" SortExpression="sep 2015" UniqueName="sep2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2015" ReadOnly="True" SortExpression="oct 2015" UniqueName="oct2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2015" ReadOnly="True" SortExpression="nov 2015" UniqueName="nov2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2015 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2015" ReadOnly="True" SortExpression="dec 2015" UniqueName="dec2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2015" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2016" ReadOnly="True" SortExpression="jan 2016" UniqueName="jan2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2016" ReadOnly="True" SortExpression="feb 2016" UniqueName="feb2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2016" ReadOnly="True" SortExpression="mar 2016" UniqueName="mar2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2016" ReadOnly="True" SortExpression="apr 2016" UniqueName="apr2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2016" ReadOnly="True" SortExpression="may 2016" UniqueName="may2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2016" ReadOnly="True" SortExpression="jun 2016" UniqueName="jun2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2016" ReadOnly="True" SortExpression="jul 2016" UniqueName="jul2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2016" ReadOnly="True" SortExpression="aug 2016" UniqueName="aug2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2016" ReadOnly="True" SortExpression="sep 2016" UniqueName="sep2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2016" ReadOnly="True" SortExpression="oct 2016" UniqueName="oct2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2016" ReadOnly="True" SortExpression="nov 2016" UniqueName="nov2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2016 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2016" ReadOnly="True" SortExpression="dec 2016" UniqueName="dec2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2016" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2017" ReadOnly="True" SortExpression="jan 2017" UniqueName="jan2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2017" ReadOnly="True" SortExpression="feb 2017" UniqueName="feb2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2017" ReadOnly="True" SortExpression="mar 2017" UniqueName="mar2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2017" ReadOnly="True" SortExpression="apr 2017" UniqueName="apr2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2017" ReadOnly="True" SortExpression="may 2017" UniqueName="may2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2017" ReadOnly="True" SortExpression="jun 2017" UniqueName="jun2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2017" ReadOnly="True" SortExpression="jul 2017" UniqueName="jul2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2017" ReadOnly="True" SortExpression="aug 2017" UniqueName="aug2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2017" ReadOnly="True" SortExpression="sep 2017" UniqueName="sep2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2017" ReadOnly="True" SortExpression="oct 2017" UniqueName="oct2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2017" ReadOnly="True" SortExpression="nov 2017" UniqueName="nov2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2017 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2017" ReadOnly="True" SortExpression="dec 2017" UniqueName="dec2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2018" ReadOnly="True" SortExpression="jan 2018" UniqueName="jan2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2018" ReadOnly="True" SortExpression="feb 2018" UniqueName="feb2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2018" ReadOnly="True" SortExpression="mar 2018" UniqueName="mar2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2018" ReadOnly="True" SortExpression="apr 2018" UniqueName="apr2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2018" ReadOnly="True" SortExpression="may 2018" UniqueName="may2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2018" ReadOnly="True" SortExpression="jun 2018" UniqueName="jun2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2018" ReadOnly="True" SortExpression="jul 2018" UniqueName="jul2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2018" ReadOnly="True" SortExpression="aug 2018" UniqueName="aug2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2018" ReadOnly="True" SortExpression="sep 2018" UniqueName="sep2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2018" ReadOnly="True" SortExpression="oct 2018" UniqueName="oct2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2018" ReadOnly="True" SortExpression="nov 2018" UniqueName="nov2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2018 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2018" ReadOnly="True" SortExpression="dec 2018" UniqueName="dec2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

			<Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2019" ReadOnly="True" SortExpression="jan 2019" UniqueName="jan2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2019" ReadOnly="True" SortExpression="feb 2019" UniqueName="feb2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2019" ReadOnly="True" SortExpression="mar 2018" UniqueName="mar2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2019" ReadOnly="True" SortExpression="apr 2019" UniqueName="apr2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2019" ReadOnly="True" SortExpression="may 2019" UniqueName="may2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2019" ReadOnly="True" SortExpression="jun 2019" UniqueName="jun2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2019" ReadOnly="True" SortExpression="jul 2019" UniqueName="jul2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2019" ReadOnly="True" SortExpression="aug 2019" UniqueName="aug2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2019" ReadOnly="True" SortExpression="sep 2019" UniqueName="sep2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2019" ReadOnly="True" SortExpression="oct 2019" UniqueName="oct2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2019" ReadOnly="True" SortExpression="nov 2019" UniqueName="nov2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2019 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2019" ReadOnly="True" SortExpression="dec 2019" UniqueName="dec2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

			<Telerik:GridBoundColumn Aggregate="Sum" DataField="jan 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jan 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jan 2020" ReadOnly="True" SortExpression="jan 2020" UniqueName="jan2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="feb 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter feb 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Feb 2020" ReadOnly="True" SortExpression="feb 2020" UniqueName="feb2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="mar 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter mar 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Mar 2020" ReadOnly="True" SortExpression="mar 2020" UniqueName="mar2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="apr 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter apr 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Apr 2020" ReadOnly="True" SortExpression="apr 2020" UniqueName="apr2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="may 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter may 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="May 2020" ReadOnly="True" SortExpression="may 2020" UniqueName="may2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jun 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jun 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jun 2020" ReadOnly="True" SortExpression="jun 2020" UniqueName="jun2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="jul 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter jul 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Jul 2020" ReadOnly="True" SortExpression="jul 2020" UniqueName="jul2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="aug 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter aug 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Aug 2020" ReadOnly="True" SortExpression="aug 2020" UniqueName="aug2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="sep 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter sep 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Sep 2020" ReadOnly="True" SortExpression="sep 2020" UniqueName="sep2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="oct 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter oct 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Oct 2020" ReadOnly="True" SortExpression="oct 2020" UniqueName="oct2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="nov 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter nov 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Nov 2020" ReadOnly="True" SortExpression="nov 2020" UniqueName="nov2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="dec 2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter dec 2020 column" FooterAggregateFormatString="{0:N0}" HeaderText="Dec 2020" ReadOnly="True" SortExpression="dec 2020" UniqueName="dec2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2020" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2020 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2020" ReadOnly="True" SortExpression="total_2020" UniqueName="total_2020">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>




                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2021" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2021 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2022" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2022 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                    <ItemStyle HorizontalAlign="Right" />
                    <AlternatingItemStyle HorizontalAlign="Right" />
                    <HeaderStyle HorizontalAlign="Right" Width="54px" />
                    <FooterStyle HorizontalAlign="Right" />
                </MasterTableView>
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="CSMDemandRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_csm_demand2" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_csm_demand" UpdateCommandType="StoredProcedure" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="2013-08" Name="release_id"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="201-08" Name="release_id"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:Parameter Name="MnemonicVehiclePlant" Type="String" />
                    <asp:Parameter Name="qty_per" Type="Decimal" />
                    <asp:Parameter Name="take_rate" Type="Decimal" />
                    <asp:Parameter Name="family_allocation" Type="Decimal" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <br />
            
            <!-- EMPIRE FACTOR GRID -->

            <telerik:RadGrid    ID="EmpireFactorRadGrid" 
                                runat="server" 
                                CellSpacing="0" 
                                DataSourceID="EmpireFactorRadGridDataSource"
                                OnItemUpdated="EmpireFactorRadGrid_ItemUpdated"
                                GridLines="None" 
                                ShowHeader="False" 
                                Width="3600px" >
                <MasterTableView    DataSourceID="EmpireFactorRadGridDataSource" 
                                    DataKeyNames="release_id,version,mnemonicvehicleplant" 
                                    AutoGenerateColumns="False" 
                                    AllowAutomaticUpdates="true"
                                    HeaderStyle-HorizontalAlign="Right" 
                                    ItemStyle-HorizontalAlign="Right" 
                                    AlternatingItemStyle-HorizontalAlign="Right"
                                    FooterStyle-HorizontalAlign="Right" 
                                    TableLayout="Fixed" 
                                    HeaderStyle-Width="54" 
                                    EditMode="InPlace" 
                                    EnableColumnsViewState="true"
                                     >
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                   
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column"
                            HeaderStyle-Width="75" >
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column"
                            HeaderText="base_part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part"
                            Display="False" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column"
                            HeaderText="version" ReadOnly="True" SortExpression="version" UniqueName="version" ForceExtractValue="Always"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_id" FilterControlAltText="Filter release_id column"
                            HeaderText="release_id" SortExpression="release_id" UniqueName="release_id" Display="false"
                            HeaderStyle-Width="75" ForceExtractValue="Always" ReadOnly="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="MnemonicVehiclePlant" FilterControlAltText="Filter MnemonicVehiclePlant column"
                            HeaderText="MnemonicVehiclePlant" SortExpression="MnemonicVehiclePlant" UniqueName="MnemonicVehiclePlant"
                            HeaderStyle-Width="75" ForceExtractValue="Always" ReadOnly="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn Headerstyle-Width="74" DataField="suggested_take_rate" DataType="System.Decimal" FilterControlAltText="Filter suggested_take_rate column"
                            HeaderText="STR" SortExpression="suggested_take_rate" UniqueName="suggested_take_rate" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2015" DataType="System.Decimal" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan2015" SortExpression="jan2015" UniqueName="jan2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2015" DataType="System.Decimal" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb2015" SortExpression="feb2015" UniqueName="feb2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2015" DataType="System.Decimal" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar2015" SortExpression="mar2015" UniqueName="mar2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2015" DataType="System.Decimal" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr2015" SortExpression="apr2015" UniqueName="apr2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2015" DataType="System.Decimal" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May2015" SortExpression="may2015" UniqueName="may2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2015" DataType="System.Decimal" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun2015" SortExpression="jun2015" UniqueName="jun2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2015" DataType="System.Decimal" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul2015" SortExpression="jul2015" UniqueName="jul2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2015" DataType="System.Decimal" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug2015" SortExpression="aug2015" UniqueName="aug2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2015" DataType="System.Decimal" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep2015" SortExpression="sep2015" UniqueName="sep2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2015" DataType="System.Decimal" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct2015" SortExpression="oct2015" UniqueName="oct2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2015" DataType="System.Decimal" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov2015" SortExpression="nov2015" UniqueName="nov2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2015" DataType="System.Decimal" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec2015" SortExpression="dec2015" UniqueName="dec2015" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" SortExpression="total_2015" UniqueName="total_2015" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2016" DataType="System.Decimal" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016" SortExpression="jan2016" UniqueName="Jan2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2016" DataType="System.Decimal" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016" SortExpression="feb2016" UniqueName="Feb2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2016" DataType="System.Decimal" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016" SortExpression="mar2016" UniqueName="Mar2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2016" DataType="System.Decimal" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016" SortExpression="apr2016" UniqueName="apr2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2016" DataType="System.Decimal" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016" SortExpression="may2016" UniqueName="may2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2016" DataType="System.Decimal" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun 2016" SortExpression="jun2016" UniqueName="jun2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2016" DataType="System.Decimal" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul 2016" SortExpression="jul2016" UniqueName="jul2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2016" DataType="System.Decimal" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug 2016" SortExpression="aug2016" UniqueName="aug2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2016" DataType="System.Decimal" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep 2016" SortExpression="sep2016" UniqueName="sep2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2016" DataType="System.Decimal" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016" SortExpression="oct2016" UniqueName="oct2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2016" DataType="System.Decimal" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016" SortExpression="nov2016" UniqueName="nov2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2016" DataType="System.Decimal" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016" SortExpression="dec2016" UniqueName="dec2016" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" SortExpression="total_2016" UniqueName="total_2016" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="jan2017" DataType="System.Decimal" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017" SortExpression="jan2017" UniqueName="Jan2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2017" DataType="System.Decimal" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017" SortExpression="feb2017" UniqueName="Feb2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2017" DataType="System.Decimal" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017" SortExpression="mar2017" UniqueName="Mar2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2017" DataType="System.Decimal" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017" SortExpression="apr2017" UniqueName="apr2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2017" DataType="System.Decimal" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017" SortExpression="may2017" UniqueName="may2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2017" DataType="System.Decimal" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun 2017" SortExpression="jun2017" UniqueName="jun2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2017" DataType="System.Decimal" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul 2017" SortExpression="jul2017" UniqueName="jul2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2017" DataType="System.Decimal" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug 2017" SortExpression="aug2017" UniqueName="aug2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2017" DataType="System.Decimal" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep 2017" SortExpression="sep2017" UniqueName="sep2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2017" DataType="System.Decimal" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017" SortExpression="oct2017" UniqueName="oct2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2017" DataType="System.Decimal" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017" SortExpression="nov2017" UniqueName="nov2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2017" DataType="System.Decimal" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017" SortExpression="dec2017" UniqueName="dec2017" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" SortExpression="total_2017" UniqueName="total_2017" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                      
                        <telerik:GridBoundColumn DataField="jan2018" DataType="System.Decimal" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018" SortExpression="jan2018" UniqueName="Jan2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2018" DataType="System.Decimal" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018" SortExpression="feb2018" UniqueName="Feb2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2018" DataType="System.Decimal" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018" SortExpression="mar2018" UniqueName="Mar2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2018" DataType="System.Decimal" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018" SortExpression="apr2018" UniqueName="apr2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2018" DataType="System.Decimal" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018" SortExpression="may2018" UniqueName="may2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2018" DataType="System.Decimal" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun 2018" SortExpression="jun2018" UniqueName="jun2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2018" DataType="System.Decimal" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul 2018" SortExpression="jul2018" UniqueName="jul2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2018" DataType="System.Decimal" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug 2018" SortExpression="aug2018" UniqueName="aug2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2018" DataType="System.Decimal" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep 2018" SortExpression="sep2018" UniqueName="sep2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2018" DataType="System.Decimal" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018" SortExpression="oct2018" UniqueName="oct2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2018" DataType="System.Decimal" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018" SortExpression="nov2018" UniqueName="nov2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2018" DataType="System.Decimal" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018" SortExpression="dec2018" UniqueName="dec2018" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" SortExpression="total_2018" UniqueName="total_2018" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

<telerik:GridBoundColumn DataField="jan2019" DataType="System.Decimal" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019" SortExpression="jan2019" UniqueName="Jan2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2019" DataType="System.Decimal" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019" SortExpression="feb2019" UniqueName="Feb2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2019" DataType="System.Decimal" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019" SortExpression="mar2019" UniqueName="Mar2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2019" DataType="System.Decimal" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019" SortExpression="apr2019" UniqueName="apr2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2019" DataType="System.Decimal" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019" SortExpression="may2019" UniqueName="may2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2019" DataType="System.Decimal" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun 2019" SortExpression="jun2019" UniqueName="jun2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2019" DataType="System.Decimal" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul 2019" SortExpression="jul2019" UniqueName="jul2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2019" DataType="System.Decimal" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug 2019" SortExpression="aug2019" UniqueName="aug2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2019" DataType="System.Decimal" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep 2019" SortExpression="sep2019" UniqueName="sep2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2019" DataType="System.Decimal" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019" SortExpression="oct2019" UniqueName="oct2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2019" DataType="System.Decimal" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019" SortExpression="nov2019" UniqueName="nov2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2019" DataType="System.Decimal" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019" SortExpression="dec2019" UniqueName="dec2019" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" SortExpression="total_2019" UniqueName="total_2019" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

<telerik:GridBoundColumn DataField="jan2020" DataType="System.Decimal" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020" SortExpression="jan2020" UniqueName="Jan2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2020" DataType="System.Decimal" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020" SortExpression="feb2020" UniqueName="Feb2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2020" DataType="System.Decimal" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020" SortExpression="mar2020" UniqueName="Mar2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2020" DataType="System.Decimal" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020" SortExpression="apr2020" UniqueName="apr2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2020" DataType="System.Decimal" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020" SortExpression="may2020" UniqueName="may2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2020" DataType="System.Decimal" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun 2020" SortExpression="jun2020" UniqueName="jun2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2020" DataType="System.Decimal" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul 2020" SortExpression="jul2020" UniqueName="jul2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2020" DataType="System.Decimal" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug 2020" SortExpression="aug2020" UniqueName="aug2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2020" DataType="System.Decimal" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep 2020" SortExpression="sep2020" UniqueName="sep2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2020" DataType="System.Decimal" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020" SortExpression="oct2020" UniqueName="oct2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2020" DataType="System.Decimal" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020" SortExpression="nov2020" UniqueName="nov2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2020" DataType="System.Decimal" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020" SortExpression="dec2020" UniqueName="dec2020" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Decimal" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" SortExpression="total_2020" UniqueName="total_2020" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Decimal" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" SortExpression="total_2021" UniqueName="total_2021" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Decimal" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" SortExpression="total_2022" UniqueName="total_2022" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="EmpireFactorRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_factor2" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_empire_factor2" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
                                <UpdateParameters>
                    <asp:Parameter Name="base_part" Type="String" />
                    <asp:Parameter Name="version" Type="String" />
                    <asp:Parameter Name="release_id" Type="String" />
                    <asp:Parameter Name="mnemonicVehiclePlant" Type="String" />
                    <asp:Parameter Name="suggested_take_rate" Type="Decimal" />
                    <asp:Parameter Name="Jan2015" Type="Decimal" />
                    <asp:Parameter Name="Feb2015" Type="Decimal" />
                    <asp:Parameter Name="Mar2015" Type="Decimal" />
                    <asp:Parameter Name="Apr2015" Type="Decimal" />
                    <asp:Parameter Name="May2015" Type="Decimal" />
                    <asp:Parameter Name="Jun2015" Type="Decimal" />
                    <asp:Parameter Name="Jul2015" Type="Decimal" />
                    <asp:Parameter Name="Aug2015" Type="Decimal" />
                    <asp:Parameter Name="Sep2015" Type="Decimal" />
                    <asp:Parameter Name="Oct2015" Type="Decimal" />
                    <asp:Parameter Name="Nov2015" Type="Decimal" />
                    <asp:Parameter Name="Dec2015" Type="Decimal" />
                    <asp:Parameter Name="Total_2015" Type="Decimal" />

                    <asp:Parameter Name="Jan2016" Type="Decimal" />
                    <asp:Parameter Name="Feb2016" Type="Decimal" />
                    <asp:Parameter Name="Mar2016" Type="Decimal" />
                    <asp:Parameter Name="Apr2016" Type="Decimal" />
                    <asp:Parameter Name="May2016" Type="Decimal" />
                    <asp:Parameter Name="Jun2016" Type="Decimal" />
                    <asp:Parameter Name="Jul2016" Type="Decimal" />
                    <asp:Parameter Name="Aug2016" Type="Decimal" />
                    <asp:Parameter Name="Sep2016" Type="Decimal" />
                    <asp:Parameter Name="Oct2016" Type="Decimal" />
                    <asp:Parameter Name="Nov2016" Type="Decimal" />
                    <asp:Parameter Name="Dec2016" Type="Decimal" />
                    <asp:Parameter Name="Total_2016" Type="Decimal" />

                    <asp:Parameter Name="Jan2017" Type="Decimal" />
                    <asp:Parameter Name="Feb2017" Type="Decimal" />
                    <asp:Parameter Name="Mar2017" Type="Decimal" />
                    <asp:Parameter Name="Apr2017" Type="Decimal" />
                    <asp:Parameter Name="May2017" Type="Decimal" />
                    <asp:Parameter Name="Jun2017" Type="Decimal" />
                    <asp:Parameter Name="Jul2017" Type="Decimal" />
                    <asp:Parameter Name="Aug2017" Type="Decimal" />
                    <asp:Parameter Name="Sep2017" Type="Decimal" />
                    <asp:Parameter Name="Oct2017" Type="Decimal" />
                    <asp:Parameter Name="Nov2017" Type="Decimal" />
                    <asp:Parameter Name="Dec2017" Type="Decimal" />                    
                    <asp:Parameter Name="Total_2017" Type="Decimal" />

                    <asp:Parameter Name="Jan2018" Type="Decimal" />
                    <asp:Parameter Name="Feb2018" Type="Decimal" />
                    <asp:Parameter Name="Mar2018" Type="Decimal" />
                    <asp:Parameter Name="Apr2018" Type="Decimal" />
                    <asp:Parameter Name="May2018" Type="Decimal" />
                    <asp:Parameter Name="Jun2018" Type="Decimal" />
                    <asp:Parameter Name="Jul2018" Type="Decimal" />
                    <asp:Parameter Name="Aug2018" Type="Decimal" />
                    <asp:Parameter Name="Sep2018" Type="Decimal" />
                    <asp:Parameter Name="Oct2018" Type="Decimal" />
                    <asp:Parameter Name="Nov2018" Type="Decimal" />
                    <asp:Parameter Name="Dec2018" Type="Decimal" />                    
                    <asp:Parameter Name="Total_2018" Type="Decimal" />

<asp:Parameter Name="Jan2019" Type="Decimal" />
                    <asp:Parameter Name="Feb2019" Type="Decimal" />
                    <asp:Parameter Name="Mar2019" Type="Decimal" />
                    <asp:Parameter Name="Apr2019" Type="Decimal" />
                    <asp:Parameter Name="May2019" Type="Decimal" />
                    <asp:Parameter Name="Jun2019" Type="Decimal" />
                    <asp:Parameter Name="Jul2019" Type="Decimal" />
                    <asp:Parameter Name="Aug2019" Type="Decimal" />
                    <asp:Parameter Name="Sep2019" Type="Decimal" />
                    <asp:Parameter Name="Oct2019" Type="Decimal" />
                    <asp:Parameter Name="Nov2019" Type="Decimal" />
                    <asp:Parameter Name="Dec2019" Type="Decimal" />                    
                    <asp:Parameter Name="Total_2019" Type="Decimal" />

<asp:Parameter Name="Jan2020" Type="Decimal" />
                    <asp:Parameter Name="Feb2020" Type="Decimal" />
                    <asp:Parameter Name="Mar2020" Type="Decimal" />
                    <asp:Parameter Name="Apr2020" Type="Decimal" />
                    <asp:Parameter Name="May2020" Type="Decimal" />
                    <asp:Parameter Name="Jun2020" Type="Decimal" />
                    <asp:Parameter Name="Jul2020" Type="Decimal" />
                    <asp:Parameter Name="Aug2020" Type="Decimal" />
                    <asp:Parameter Name="Sep2020" Type="Decimal" />
                    <asp:Parameter Name="Oct2020" Type="Decimal" />
                    <asp:Parameter Name="Nov2020" Type="Decimal" />
                    <asp:Parameter Name="Dec2020" Type="Decimal" />                    
                    <asp:Parameter Name="Total_2020" Type="Decimal" />

                    <asp:Parameter Name="Total_2021" Type="Decimal" />
                    <asp:Parameter Name="Total_2022" Type="Decimal" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <!-- ADJUSTED CSM DEMAND (CSM RAW x EMPIRE FACTOR) -->

            <telerik:RadGrid ID="AdjustedCSMDemandRadGrid" runat="server" CellSpacing="0" DataSourceID="AdjustedCSMDemandRadGridDataSource"
                GridLines="None" Width="3600px" AutoGenerateColumns="False" ShowHeader="false">
                <MasterTableView DataSourceID="AdjustedCSMDemandRadGridDataSource" HeaderStyle-HorizontalAlign="Right"
                    ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54">
                    <Columns>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column"
                            HeaderText="version" SortExpression="version" UniqueName="version" ReadOnly="True"
                            HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="Jan2015" DataType="System.Decimal" FilterControlAltText="Filter Jan2015 column"
                            HeaderText="Jan2015" ReadOnly="True" SortExpression="Jan2015" UniqueName="Jan2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2015" DataType="System.Decimal" FilterControlAltText="Filter Feb2015 column"
                            HeaderText="Feb2015" ReadOnly="True" SortExpression="Feb2015" UniqueName="Feb2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2015" DataType="System.Decimal" FilterControlAltText="Filter Mar2015 column"
                            HeaderText="Mar2015" ReadOnly="True" SortExpression="Mar2015" UniqueName="Mar2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2015" DataType="System.Decimal" FilterControlAltText="Filter Apr2015 column"
                            HeaderText="Apr2015" ReadOnly="True" SortExpression="Apr2015" UniqueName="Apr2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2015" DataType="System.Decimal" FilterControlAltText="Filter May2015 column"
                            HeaderText="May2015" ReadOnly="True" SortExpression="May2015" UniqueName="May2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2015" DataType="System.Decimal" FilterControlAltText="Filter Jun2015 column"
                            HeaderText="Jun2015" ReadOnly="True" SortExpression="Jun2015" UniqueName="Jun2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2015" DataType="System.Decimal" FilterControlAltText="Filter Jul2015 column"
                            HeaderText="Jul2015" ReadOnly="True" SortExpression="Jul2015" UniqueName="Jul2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2015" DataType="System.Decimal" FilterControlAltText="Filter Aug2015 column"
                            HeaderText="Aug2015" ReadOnly="True" SortExpression="Aug2015" UniqueName="Aug2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2015" DataType="System.Decimal" FilterControlAltText="Filter Sep2015 column"
                            HeaderText="Sep2015" ReadOnly="True" SortExpression="Sep2015" UniqueName="Sep2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2015" DataType="System.Decimal" FilterControlAltText="Filter Oct2015 column"
                            HeaderText="Oct2015" ReadOnly="True" SortExpression="Oct2015" UniqueName="Oct2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2015" DataType="System.Decimal" FilterControlAltText="Filter Nov2015 column"
                            HeaderText="Nov2015" ReadOnly="True" SortExpression="Nov2015" UniqueName="Nov2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2015" DataType="System.Decimal" FilterControlAltText="Filter Dec2015 column"
                            HeaderText="Dec2015" ReadOnly="True" SortExpression="Dec2015" UniqueName="Dec2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2015" DataType="System.Decimal" FilterControlAltText="Filter Total_2015 column"
                            HeaderText="Total_2015" ReadOnly="True" SortExpression="Total_2015" UniqueName="Total_2015"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Jan2016" DataType="System.Decimal" FilterControlAltText="Filter Jan2016 column"
                            HeaderText="Jan2016" ReadOnly="True" SortExpression="Jan2016" UniqueName="Jan2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2016" DataType="System.Decimal" FilterControlAltText="Filter Feb2016 column"
                            HeaderText="Feb2016" ReadOnly="True" SortExpression="Feb2016" UniqueName="Feb2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2016" DataType="System.Decimal" FilterControlAltText="Filter Mar2016 column"
                            HeaderText="Mar2016" ReadOnly="True" SortExpression="Mar2016" UniqueName="Mar2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2016" DataType="System.Decimal" FilterControlAltText="Filter Apr2016 column"
                            HeaderText="Apr2016" ReadOnly="True" SortExpression="Apr2016" UniqueName="Apr2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2016" DataType="System.Decimal" FilterControlAltText="Filter May2016 column"
                            HeaderText="May2016" ReadOnly="True" SortExpression="May2016" UniqueName="May2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2016" DataType="System.Decimal" FilterControlAltText="Filter Jun2016 column"
                            HeaderText="Jun2016" ReadOnly="True" SortExpression="Jun2016" UniqueName="Jun2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2016" DataType="System.Decimal" FilterControlAltText="Filter Jul2016 column"
                            HeaderText="Jul2016" ReadOnly="True" SortExpression="Jul2016" UniqueName="Jul2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2016" DataType="System.Decimal" FilterControlAltText="Filter Aug2016 column"
                            HeaderText="Aug2016" ReadOnly="True" SortExpression="Aug2016" UniqueName="Aug2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2016" DataType="System.Decimal" FilterControlAltText="Filter Sep2016 column"
                            HeaderText="Sep2016" ReadOnly="True" SortExpression="Sep2016" UniqueName="Sep2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2016" DataType="System.Decimal" FilterControlAltText="Filter Oct2016 column"
                            HeaderText="Oct2016" ReadOnly="True" SortExpression="Oct2016" UniqueName="Oct2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2016" DataType="System.Decimal" FilterControlAltText="Filter Nov2016 column"
                            HeaderText="Nov2016" ReadOnly="True" SortExpression="Nov2016" UniqueName="Nov2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2016" DataType="System.Decimal" FilterControlAltText="Filter Dec2016 column"
                            HeaderText="Dec2016" ReadOnly="True" SortExpression="Dec2016" UniqueName="Dec2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2016" DataType="System.Decimal" FilterControlAltText="Filter Total_2016 column"
                            HeaderText="Total_2016" ReadOnly="True" SortExpression="Total_2016" UniqueName="Total_2016"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Jan2017" DataType="System.Decimal" FilterControlAltText="Filter Jan2017 column"
                            HeaderText="Jan2017" ReadOnly="True" SortExpression="Jan2017" UniqueName="Jan2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2017" DataType="System.Decimal" FilterControlAltText="Filter Feb2017 column"
                            HeaderText="Feb2017" ReadOnly="True" SortExpression="Feb2017" UniqueName="Feb2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2017" DataType="System.Decimal" FilterControlAltText="Filter Mar2017 column"
                            HeaderText="Mar2017" ReadOnly="True" SortExpression="Mar2017" UniqueName="Mar2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2017" DataType="System.Decimal" FilterControlAltText="Filter Apr2017 column"
                            HeaderText="Apr2017" ReadOnly="True" SortExpression="Apr2017" UniqueName="Apr2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2017" DataType="System.Decimal" FilterControlAltText="Filter May2017 column"
                            HeaderText="May2017" ReadOnly="True" SortExpression="May2017" UniqueName="May2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2017" DataType="System.Decimal" FilterControlAltText="Filter Jun2017 column"
                            HeaderText="Jun2017" ReadOnly="True" SortExpression="Jun2017" UniqueName="Jun2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2017" DataType="System.Decimal" FilterControlAltText="Filter Jul2017 column"
                            HeaderText="Jul2017" ReadOnly="True" SortExpression="Jul2017" UniqueName="Jul2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2017" DataType="System.Decimal" FilterControlAltText="Filter Aug2017 column"
                            HeaderText="Aug2017" ReadOnly="True" SortExpression="Aug2017" UniqueName="Aug2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2017" DataType="System.Decimal" FilterControlAltText="Filter Sep2017 column"
                            HeaderText="Sep2017" ReadOnly="True" SortExpression="Sep2017" UniqueName="Sep2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2017" DataType="System.Decimal" FilterControlAltText="Filter Oct2017 column"
                            HeaderText="Oct2017" ReadOnly="True" SortExpression="Oct2017" UniqueName="Oct2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2017" DataType="System.Decimal" FilterControlAltText="Filter Nov2017 column"
                            HeaderText="Nov2017" ReadOnly="True" SortExpression="Nov2017" UniqueName="Nov2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2017" DataType="System.Decimal" FilterControlAltText="Filter Dec2017 column"
                            HeaderText="Dec2017" ReadOnly="True" SortExpression="Dec2017" UniqueName="Dec2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2017" DataType="System.Decimal" FilterControlAltText="Filter Total_2017 column"
                            HeaderText="Total_2017" ReadOnly="True" SortExpression="Total_2017" UniqueName="Total_2017"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        
                        <telerik:GridBoundColumn DataField="Jan2018" DataType="System.Decimal" FilterControlAltText="Filter Jan2018 column"
                            HeaderText="Jan2018" ReadOnly="True" SortExpression="Jan2018" UniqueName="Jan2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2018" DataType="System.Decimal" FilterControlAltText="Filter Feb2018 column"
                            HeaderText="Feb2018" ReadOnly="True" SortExpression="Feb2018" UniqueName="Feb2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2018" DataType="System.Decimal" FilterControlAltText="Filter Mar2018 column"
                            HeaderText="Mar2018" ReadOnly="True" SortExpression="Mar2018" UniqueName="Mar2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2018" DataType="System.Decimal" FilterControlAltText="Filter Apr2018 column"
                            HeaderText="Apr2018" ReadOnly="True" SortExpression="Apr2018" UniqueName="Apr2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2018" DataType="System.Decimal" FilterControlAltText="Filter May2018 column"
                            HeaderText="May2018" ReadOnly="True" SortExpression="May2018" UniqueName="May2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2018" DataType="System.Decimal" FilterControlAltText="Filter Jun2018 column"
                            HeaderText="Jun2018" ReadOnly="True" SortExpression="Jun2018" UniqueName="Jun2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2018" DataType="System.Decimal" FilterControlAltText="Filter Jul2018 column"
                            HeaderText="Jul2018" ReadOnly="True" SortExpression="Jul2018" UniqueName="Jul2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2018" DataType="System.Decimal" FilterControlAltText="Filter Aug2018 column"
                            HeaderText="Aug2018" ReadOnly="True" SortExpression="Aug2018" UniqueName="Aug2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2018" DataType="System.Decimal" FilterControlAltText="Filter Sep2018 column"
                            HeaderText="Sep2018" ReadOnly="True" SortExpression="Sep2018" UniqueName="Sep2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2018" DataType="System.Decimal" FilterControlAltText="Filter Oct2018 column"
                            HeaderText="Oct2018" ReadOnly="True" SortExpression="Oct2018" UniqueName="Oct2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2018" DataType="System.Decimal" FilterControlAltText="Filter Nov2018 column"
                            HeaderText="Nov2018" ReadOnly="True" SortExpression="Nov2018" UniqueName="Nov2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2018" DataType="System.Decimal" FilterControlAltText="Filter Dec2018 column"
                            HeaderText="Dec2018" ReadOnly="True" SortExpression="Dec2018" UniqueName="Dec2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2018" DataType="System.Decimal" FilterControlAltText="Filter Total_2018 column"
                            HeaderText="Total_2018" ReadOnly="True" SortExpression="Total_2018" UniqueName="Total_2018"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

<telerik:GridBoundColumn DataField="Jan2019" DataType="System.Decimal" FilterControlAltText="Filter Jan2019 column"
                            HeaderText="Jan2019" ReadOnly="True" SortExpression="Jan2019" UniqueName="Jan2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2019" DataType="System.Decimal" FilterControlAltText="Filter Feb2019 column"
                            HeaderText="Feb2019" ReadOnly="True" SortExpression="Feb2019" UniqueName="Feb2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2019" DataType="System.Decimal" FilterControlAltText="Filter Mar2019 column"
                            HeaderText="Mar2019" ReadOnly="True" SortExpression="Mar2019" UniqueName="Mar2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2019" DataType="System.Decimal" FilterControlAltText="Filter Apr2019 column"
                            HeaderText="Apr2019" ReadOnly="True" SortExpression="Apr2019" UniqueName="Apr2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2019" DataType="System.Decimal" FilterControlAltText="Filter May2019 column"
                            HeaderText="May2019" ReadOnly="True" SortExpression="May2019" UniqueName="May2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2019" DataType="System.Decimal" FilterControlAltText="Filter Jun2019 column"
                            HeaderText="Jun2019" ReadOnly="True" SortExpression="Jun2019" UniqueName="Jun2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2019" DataType="System.Decimal" FilterControlAltText="Filter Jul2019 column"
                            HeaderText="Jul2019" ReadOnly="True" SortExpression="Jul2019" UniqueName="Jul2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2019" DataType="System.Decimal" FilterControlAltText="Filter Aug2019 column"
                            HeaderText="Aug2019" ReadOnly="True" SortExpression="Aug2019" UniqueName="Aug2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2019" DataType="System.Decimal" FilterControlAltText="Filter Sep2019 column"
                            HeaderText="Sep2019" ReadOnly="True" SortExpression="Sep2019" UniqueName="Sep2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2019" DataType="System.Decimal" FilterControlAltText="Filter Oct2019 column"
                            HeaderText="Oct2019" ReadOnly="True" SortExpression="Oct2019" UniqueName="Oct2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2019" DataType="System.Decimal" FilterControlAltText="Filter Nov2019 column"
                            HeaderText="Nov2019" ReadOnly="True" SortExpression="Nov2019" UniqueName="Nov2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2019" DataType="System.Decimal" FilterControlAltText="Filter Dec2019 column"
                            HeaderText="Dec2019" ReadOnly="True" SortExpression="Dec2019" UniqueName="Dec2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2019" DataType="System.Decimal" FilterControlAltText="Filter Total_2019 column"
                            HeaderText="Total_2019" ReadOnly="True" SortExpression="Total_2019" UniqueName="Total_2019"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

<telerik:GridBoundColumn DataField="Jan2020" DataType="System.Decimal" FilterControlAltText="Filter Jan2020 column"
                            HeaderText="Jan2020" ReadOnly="True" SortExpression="Jan2020" UniqueName="Jan2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2020" DataType="System.Decimal" FilterControlAltText="Filter Feb2020 column"
                            HeaderText="Feb2020" ReadOnly="True" SortExpression="Feb2020" UniqueName="Feb2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2020" DataType="System.Decimal" FilterControlAltText="Filter Mar2020 column"
                            HeaderText="Mar2020" ReadOnly="True" SortExpression="Mar2020" UniqueName="Mar2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2020" DataType="System.Decimal" FilterControlAltText="Filter Apr2020 column"
                            HeaderText="Apr2020" ReadOnly="True" SortExpression="Apr2020" UniqueName="Apr2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2020" DataType="System.Decimal" FilterControlAltText="Filter May2020 column"
                            HeaderText="May2020" ReadOnly="True" SortExpression="May2020" UniqueName="May2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2020" DataType="System.Decimal" FilterControlAltText="Filter Jun2020 column"
                            HeaderText="Jun2020" ReadOnly="True" SortExpression="Jun2020" UniqueName="Jun2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2020" DataType="System.Decimal" FilterControlAltText="Filter Jul2020 column"
                            HeaderText="Jul2020" ReadOnly="True" SortExpression="Jul2020" UniqueName="Jul2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2020" DataType="System.Decimal" FilterControlAltText="Filter Aug2020 column"
                            HeaderText="Aug2020" ReadOnly="True" SortExpression="Aug2020" UniqueName="Aug2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2020" DataType="System.Decimal" FilterControlAltText="Filter Sep2020 column"
                            HeaderText="Sep2020" ReadOnly="True" SortExpression="Sep2020" UniqueName="Sep2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2020" DataType="System.Decimal" FilterControlAltText="Filter Oct2020 column"
                            HeaderText="Oct2020" ReadOnly="True" SortExpression="Oct2020" UniqueName="Oct2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2020" DataType="System.Decimal" FilterControlAltText="Filter Nov2020 column"
                            HeaderText="Nov2020" ReadOnly="True" SortExpression="Nov2020" UniqueName="Nov2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2020" DataType="System.Decimal" FilterControlAltText="Filter Dec2020 column"
                            HeaderText="Dec2020" ReadOnly="True" SortExpression="Dec2020" UniqueName="Dec2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2020" DataType="System.Decimal" FilterControlAltText="Filter Total_2020 column"
                            HeaderText="Total_2020" ReadOnly="True" SortExpression="Total_2020" UniqueName="Total_2020"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Decimal" FilterControlAltText="Filter total_2021 column"
                            HeaderText="total_2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Decimal" FilterControlAltText="Filter total_2022 column"
                            HeaderText="total_2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="AdjustedCSMDemandRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_adjusted_csm_demand2" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="2013-08" Name="release_id"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            
            <!-- EMPIRE ADJUSTMENT GRID -->

            <telerik:RadGrid    ID="EmpireAdjustmentRadGrid" 
                                runat="server" 
                                CellSpacing="0" 
                                DataSourceID="EmpireAdjustmentRadGridDataSource"
                                OnItemUpdated="EmpireAdjustmentRadGrid_ItemUpdated"
                                GridLines="None" 
                                ShowHeader="False" 
                                Width="3600px" >
                <MasterTableView    DataSourceID="EmpireAdjustmentRadGridDataSource" 
                                    DataKeyNames="release_id,version,mnemonicvehicleplant" 
                                    AutoGenerateColumns="False" 
                                    AllowAutomaticUpdates="true"
                                    HeaderStyle-HorizontalAlign="Right" 
                                    ItemStyle-HorizontalAlign="Right" 
                                    AlternatingItemStyle-HorizontalAlign="Right"
                                    FooterStyle-HorizontalAlign="Right" 
                                    TableLayout="Fixed" 
                                    HeaderStyle-Width="54" 
                                    EditMode="InPlace" 
                                    EnableColumnsViewState="true"
                                     >
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                   
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column"
                            HeaderStyle-Width="75" >
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column"
                            HeaderText="base_part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part"
                            Display="False" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column"
                            HeaderText="version" ReadOnly="True" SortExpression="version" UniqueName="version" ForceExtractValue="Always"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_id" FilterControlAltText="Filter release_id column"
                            HeaderText="release_id" SortExpression="release_id" UniqueName="release_id" Display="false"
                            HeaderStyle-Width="75" ForceExtractValue="Always" ReadOnly="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="MnemonicVehiclePlant" FilterControlAltText="Filter MnemonicVehiclePlant column"
                            HeaderText="MnemonicVehiclePlant" SortExpression="MnemonicVehiclePlant" UniqueName="MnemonicVehiclePlant"
                            HeaderStyle-Width="75" ForceExtractValue="Always" ReadOnly="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="platform" FilterControlAltText="Filter platform column"
                            HeaderText="platform" SortExpression="platform" UniqueName="platform" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column"
                            HeaderText="program" SortExpression="program" UniqueName="program" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="vehicle" FilterControlAltText="Filter vehicle column"
                            HeaderText="vehicle" SortExpression="vehicle" UniqueName="vehicle" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="plant" FilterControlAltText="Filter plant column"
                            HeaderText="plant" SortExpression="plant" UniqueName="plant" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sop" DataType="System.DateTime" FilterControlAltText="Filter sop column"
                            HeaderText="sop" ReadOnly="true" SortExpression="sop" UniqueName="sop" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="eop" DataType="System.DateTime" FilterControlAltText="Filter eop column"
                            HeaderText="eop" ReadOnly="True" SortExpression="eop" UniqueName="eop" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan2015" SortExpression="jan2015" UniqueName="jan2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb2015" SortExpression="feb2015" UniqueName="feb2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar2015" SortExpression="mar2015" UniqueName="mar2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr2015" SortExpression="apr2015" UniqueName="apr2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May2015" SortExpression="may2015" UniqueName="may2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun2015" SortExpression="jun2015" UniqueName="jun2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul2015" SortExpression="jul2015" UniqueName="jul2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug2015" SortExpression="aug2015" UniqueName="aug2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep2015" SortExpression="sep2015" UniqueName="sep2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct2015" SortExpression="oct2015" UniqueName="oct2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov2015" SortExpression="nov2015" UniqueName="nov2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec2015" SortExpression="dec2015" UniqueName="dec2015" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" SortExpression="total_2015" UniqueName="total_2015" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016" SortExpression="jan2016" UniqueName="Jan2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016" SortExpression="feb2016" UniqueName="Feb2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016" SortExpression="mar2016" UniqueName="Mar2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016" SortExpression="apr2016" UniqueName="apr2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016" SortExpression="may2016" UniqueName="may2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun 2016" SortExpression="jun2016" UniqueName="jun2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul 2016" SortExpression="jul2016" UniqueName="jul2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug 2016" SortExpression="aug2016" UniqueName="aug2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep 2016" SortExpression="sep2016" UniqueName="sep2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016" SortExpression="oct2016" UniqueName="oct2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016" SortExpression="nov2016" UniqueName="nov2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016" SortExpression="dec2016" UniqueName="dec2016" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" SortExpression="total_2016" UniqueName="total_2016" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017" SortExpression="jan2017" UniqueName="Jan2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017" SortExpression="feb2017" UniqueName="Feb2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017" SortExpression="mar2017" UniqueName="Mar2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017" SortExpression="apr2017" UniqueName="apr2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017" SortExpression="may2017" UniqueName="may2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun 2017" SortExpression="jun2017" UniqueName="jun2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul 2017" SortExpression="jul2017" UniqueName="jul2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug 2017" SortExpression="aug2017" UniqueName="aug2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep 2017" SortExpression="sep2017" UniqueName="sep2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017" SortExpression="oct2017" UniqueName="oct2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017" SortExpression="nov2017" UniqueName="nov2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017" SortExpression="dec2017" UniqueName="dec2017" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" SortExpression="total_2017" UniqueName="total_2017" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018" SortExpression="jan2018" UniqueName="Jan2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018" SortExpression="feb2018" UniqueName="Feb2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018" SortExpression="mar2018" UniqueName="Mar2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018" SortExpression="apr2018" UniqueName="apr2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018" SortExpression="may2018" UniqueName="may2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun 2018" SortExpression="jun2018" UniqueName="jun2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul 2018" SortExpression="jul2018" UniqueName="jul2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug 2018" SortExpression="aug2018" UniqueName="aug2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep 2018" SortExpression="sep2018" UniqueName="sep2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018" SortExpression="oct2018" UniqueName="oct2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018" SortExpression="nov2018" UniqueName="nov2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018" SortExpression="dec2018" UniqueName="dec2018" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" SortExpression="total_2018" UniqueName="total_2018" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="jan2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019" SortExpression="jan2019" UniqueName="Jan2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019" SortExpression="feb2019" UniqueName="Feb2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019" SortExpression="mar2019" UniqueName="Mar2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019" SortExpression="apr2019" UniqueName="apr2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019" SortExpression="may2019" UniqueName="may2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun 2019" SortExpression="jun2019" UniqueName="jun2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul 2019" SortExpression="jul2019" UniqueName="jul2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug 2019" SortExpression="aug2019" UniqueName="aug2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep 2019" SortExpression="sep2019" UniqueName="sep2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019" SortExpression="oct2019" UniqueName="oct2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019" SortExpression="nov2019" UniqueName="nov2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019" SortExpression="dec2019" UniqueName="dec2019" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" SortExpression="total_2019" UniqueName="total_2019" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020" SortExpression="jan2020" UniqueName="Jan2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020" SortExpression="feb2020" UniqueName="Feb2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020" SortExpression="mar2020" UniqueName="Mar2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020" SortExpression="apr2020" UniqueName="apr2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020" SortExpression="may2020" UniqueName="may2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun 2020" SortExpression="jun2020" UniqueName="jun2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul 2020" SortExpression="jul2020" UniqueName="jul2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug 2020" SortExpression="aug2020" UniqueName="aug2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep 2020" SortExpression="sep2020" UniqueName="sep2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020" SortExpression="oct2020" UniqueName="oct2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020" SortExpression="nov2020" UniqueName="nov2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020" SortExpression="dec2020" UniqueName="dec2020" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" SortExpression="total_2020" UniqueName="total_2020" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" SortExpression="total_2021" UniqueName="total_2021" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" SortExpression="total_2022" UniqueName="total_2022" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="EmpireAdjustmentRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_adjustment2" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_empire_adjustment2" UpdateCommandType="StoredProcedure">
                
             
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" DefaultValue="NAL0040" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" DefaultValue="2013-08" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="base_part" Type="String" />
                    <asp:Parameter Name="version" Type="String" />
                    <asp:Parameter Name="release_id" Type="String" />
                    <asp:Parameter Name="mnemonicVehiclePlant" Type="String" />
                    <asp:Parameter Name="platform" Type="String" />
                    <asp:Parameter Name="program" Type="String" />
                    <asp:Parameter Name="vehicle" Type="String" />
                    <asp:Parameter Name="plant" Type="String" />
                    <asp:Parameter Name="SOP" Type="DateTime" />
                    <asp:Parameter Name="EOP" Type="DateTime" />
                    <asp:Parameter Name="Qty_per" Type="Decimal" />
                    <asp:Parameter Name="Take_rate" Type="Decimal" />
                    <asp:Parameter Name="Family_allocation" Type="Decimal" />
                    <asp:Parameter Name="Jan2015" Type="Decimal" />
                    <asp:Parameter Name="Feb2015" Type="Decimal" />
                    <asp:Parameter Name="Mar2015" Type="Decimal" />
                    <asp:Parameter Name="Apr2015" Type="Decimal" />
                    <asp:Parameter Name="May2015" Type="Decimal" />
                    <asp:Parameter Name="Jun2015" Type="Decimal" />
                    <asp:Parameter Name="Jul2015" Type="Decimal" />
                    <asp:Parameter Name="Aug2015" Type="Decimal" />
                    <asp:Parameter Name="Sep2015" Type="Decimal" />
                    <asp:Parameter Name="Oct2015" Type="Decimal" />
                    <asp:Parameter Name="Nov2015" Type="Decimal" />
                    <asp:Parameter Name="Dec2015" Type="Decimal" />
                    <asp:Parameter Name="Total_2015" Type="Decimal" />

                    <asp:Parameter Name="Jan2016" Type="Decimal" />
                    <asp:Parameter Name="Feb2016" Type="Decimal" />
                    <asp:Parameter Name="Mar2016" Type="Decimal" />
                    <asp:Parameter Name="Apr2016" Type="Decimal" />
                    <asp:Parameter Name="May2016" Type="Decimal" />
                    <asp:Parameter Name="Jun2016" Type="Decimal" />
                    <asp:Parameter Name="Jul2016" Type="Decimal" />
                    <asp:Parameter Name="Aug2016" Type="Decimal" />
                    <asp:Parameter Name="Sep2016" Type="Decimal" />
                    <asp:Parameter Name="Oct2016" Type="Decimal" />
                    <asp:Parameter Name="Nov2016" Type="Decimal" />
                    <asp:Parameter Name="Dec2016" Type="Decimal" />
                    <asp:Parameter Name="Total_2016" Type="Decimal" />

                    <asp:Parameter Name="Jan2017" Type="Decimal" />
                    <asp:Parameter Name="Feb2017" Type="Decimal" />
                    <asp:Parameter Name="Mar2017" Type="Decimal" />
                    <asp:Parameter Name="Apr2017" Type="Decimal" />
                    <asp:Parameter Name="May2017" Type="Decimal" />
                    <asp:Parameter Name="Jun2017" Type="Decimal" />
                    <asp:Parameter Name="Jul2017" Type="Decimal" />
                    <asp:Parameter Name="Aug2017" Type="Decimal" />
                    <asp:Parameter Name="Sep2017" Type="Decimal" />
                    <asp:Parameter Name="Oct2017" Type="Decimal" />
                    <asp:Parameter Name="Nov2017" Type="Decimal" />
                    <asp:Parameter Name="Dec2017" Type="Decimal" />
                    <asp:Parameter Name="Total_2017" Type="Decimal" />
                    

                    <asp:Parameter Name="Jan2018" Type="Decimal" />
                    <asp:Parameter Name="Feb2018" Type="Decimal" />
                    <asp:Parameter Name="Mar2018" Type="Decimal" />
                    <asp:Parameter Name="Apr2018" Type="Decimal" />
                    <asp:Parameter Name="May2018" Type="Decimal" />
                    <asp:Parameter Name="Jun2018" Type="Decimal" />
                    <asp:Parameter Name="Jul2018" Type="Decimal" />
                    <asp:Parameter Name="Aug2018" Type="Decimal" />
                    <asp:Parameter Name="Sep2018" Type="Decimal" />
                    <asp:Parameter Name="Oct2018" Type="Decimal" />
                    <asp:Parameter Name="Nov2018" Type="Decimal" />
                    <asp:Parameter Name="Dec2018" Type="Decimal" />
                    <asp:Parameter Name="Total_2018" Type="Decimal" />

		    <asp:Parameter Name="Jan2019" Type="Decimal" />
                    <asp:Parameter Name="Feb2019" Type="Decimal" />
                    <asp:Parameter Name="Mar2019" Type="Decimal" />
                    <asp:Parameter Name="Apr2019" Type="Decimal" />
                    <asp:Parameter Name="May2019" Type="Decimal" />
                    <asp:Parameter Name="Jun2019" Type="Decimal" />
                    <asp:Parameter Name="Jul2019" Type="Decimal" />
                    <asp:Parameter Name="Aug2019" Type="Decimal" />
                    <asp:Parameter Name="Sep2019" Type="Decimal" />
                    <asp:Parameter Name="Oct2019" Type="Decimal" />
                    <asp:Parameter Name="Nov2019" Type="Decimal" />
                    <asp:Parameter Name="Dec2019" Type="Decimal" />
                    <asp:Parameter Name="Total_2019" Type="Decimal" />

		    <asp:Parameter Name="Jan2020" Type="Decimal" />
                    <asp:Parameter Name="Feb2020" Type="Decimal" />
                    <asp:Parameter Name="Mar2020" Type="Decimal" />
                    <asp:Parameter Name="Apr2020" Type="Decimal" />
                    <asp:Parameter Name="May2020" Type="Decimal" />
                    <asp:Parameter Name="Jun2020" Type="Decimal" />
                    <asp:Parameter Name="Jul2020" Type="Decimal" />
                    <asp:Parameter Name="Aug2020" Type="Decimal" />
                    <asp:Parameter Name="Sep2020" Type="Decimal" />
                    <asp:Parameter Name="Oct2020" Type="Decimal" />
                    <asp:Parameter Name="Nov2020" Type="Decimal" />
                    <asp:Parameter Name="Dec2020" Type="Decimal" />
                    <asp:Parameter Name="Total_2020" Type="Decimal" />

                    <asp:Parameter Name="Total_2021" Type="Decimal" />
                    <asp:Parameter Name="Total_2022" Type="Decimal" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <!-- TOTAL DEMAND (CSM RAW DEMAND x QTY PER x FAMILY ALLOCATION x TAKE RATE x EMPIRE FACTOR) +/- EMPIRE ADJUSTMENT -->

            <telerik:RadGrid ID="TotalDemandRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalDemandRadGridDataSource"
                GridLines="None" ShowHeader="false" Width="3600">
                <MasterTableView DataSourceID="TotalDemandRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54">
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                    <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column"
                            HeaderText="version" SortExpression="version" UniqueName="version" ReadOnly="True"
                            HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan 2015" ReadOnly="True" SortExpression="jan 2015" UniqueName="jan2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb 2015" ReadOnly="True" SortExpression="feb 2015" UniqueName="feb2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar 2015" ReadOnly="True" SortExpression="mar 2015" UniqueName="mar2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr 2015" ReadOnly="True" SortExpression="apr 2015" UniqueName="apr2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May 2015" ReadOnly="True" SortExpression="may 2015" UniqueName="may2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun 2015" ReadOnly="True" SortExpression="jun 2015" UniqueName="jun2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul 2015" ReadOnly="True" SortExpression="jul 2015" UniqueName="jul2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug 2015" ReadOnly="True" SortExpression="aug 2015" UniqueName="aug2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep 2015" ReadOnly="True" SortExpression="sep 2015" UniqueName="sep2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct 2015" ReadOnly="True" SortExpression="oct 2015" UniqueName="oct2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov 2015" ReadOnly="True" SortExpression="nov 2015" UniqueName="nov2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec 2015" ReadOnly="True" SortExpression="dec 2015" UniqueName="dec2015"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="jan2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016" ReadOnly="True" SortExpression="jan 2016" UniqueName="Jan2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016" ReadOnly="True" SortExpression="feb 2016" UniqueName="Feb2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016" ReadOnly="True" SortExpression="mar 2016" UniqueName="Mar2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016" ReadOnly="True" SortExpression="apr 2016" UniqueName="apr2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016" ReadOnly="True" SortExpression="may 2016" UniqueName="may2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun2016" ReadOnly="True" SortExpression="jun 2016" UniqueName="jun2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul2016" ReadOnly="True" SortExpression="jul 2016" UniqueName="jul2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug2016" ReadOnly="True" SortExpression="aug 2016" UniqueName="aug2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep2016" ReadOnly="True" SortExpression="sep 2016" UniqueName="sep2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016" ReadOnly="True" SortExpression="oct 2016" UniqueName="oct2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016" ReadOnly="True" SortExpression="nov 2016" UniqueName="nov2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016" ReadOnly="True" SortExpression="dec 2016" UniqueName="dec2016"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="jan2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017" ReadOnly="True" SortExpression="jan 2017" UniqueName="Jan2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017" ReadOnly="True" SortExpression="feb 2017" UniqueName="Feb2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017" ReadOnly="True" SortExpression="mar 2017" UniqueName="Mar2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017" ReadOnly="True" SortExpression="apr 2017" UniqueName="apr2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017" ReadOnly="True" SortExpression="may 2017" UniqueName="may2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun2017" ReadOnly="True" SortExpression="jun 2017" UniqueName="jun2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul2017" ReadOnly="True" SortExpression="jul 2017" UniqueName="jul2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug2017" ReadOnly="True" SortExpression="aug 2017" UniqueName="aug2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep2017" ReadOnly="True" SortExpression="sep 2017" UniqueName="sep2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017" ReadOnly="True" SortExpression="oct 2017" UniqueName="oct2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017" ReadOnly="True" SortExpression="nov 2017" UniqueName="nov2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017" ReadOnly="True" SortExpression="dec 2017" UniqueName="dec2017"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                                                 
                        <telerik:GridBoundColumn DataField="jan2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018" ReadOnly="True" SortExpression="jan 2018" UniqueName="Jan2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018" ReadOnly="True" SortExpression="feb 2018" UniqueName="Feb2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018" ReadOnly="True" SortExpression="mar 2018" UniqueName="Mar2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018" ReadOnly="True" SortExpression="apr 2018" UniqueName="apr2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018" ReadOnly="True" SortExpression="may 2018" UniqueName="may2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun2018" ReadOnly="True" SortExpression="jun 2018" UniqueName="jun2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul2018" ReadOnly="True" SortExpression="jul 2018" UniqueName="jul2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug2018" ReadOnly="True" SortExpression="aug 2018" UniqueName="aug2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep2018" ReadOnly="True" SortExpression="sep 2018" UniqueName="sep2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018" ReadOnly="True" SortExpression="oct 2018" UniqueName="oct2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018" ReadOnly="True" SortExpression="nov 2018" UniqueName="nov2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018" ReadOnly="True" SortExpression="dec 2018" UniqueName="dec2018"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019" ReadOnly="True" SortExpression="jan 2019" UniqueName="Jan2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019" ReadOnly="True" SortExpression="feb 2019" UniqueName="Feb2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019" ReadOnly="True" SortExpression="mar 2019" UniqueName="Mar2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019" ReadOnly="True" SortExpression="apr 2019" UniqueName="apr2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019" ReadOnly="True" SortExpression="may 2019" UniqueName="may2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun2019" ReadOnly="True" SortExpression="jun 2019" UniqueName="jun2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul2019" ReadOnly="True" SortExpression="jul 2019" UniqueName="jul2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug2019" ReadOnly="True" SortExpression="aug 2019" UniqueName="aug2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep2019" ReadOnly="True" SortExpression="sep 2019" UniqueName="sep2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019" ReadOnly="True" SortExpression="oct 2019" UniqueName="oct2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019" ReadOnly="True" SortExpression="nov 2019" UniqueName="nov2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019" ReadOnly="True" SortExpression="dec 2019" UniqueName="dec2019"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020" ReadOnly="True" SortExpression="jan 2020" UniqueName="Jan2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020" ReadOnly="True" SortExpression="feb 2020" UniqueName="Feb2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020" ReadOnly="True" SortExpression="mar 2020" UniqueName="Mar2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020" ReadOnly="True" SortExpression="apr 2020" UniqueName="apr2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020" ReadOnly="True" SortExpression="may 2020" UniqueName="may2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun2020" ReadOnly="True" SortExpression="jun 2020" UniqueName="jun2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul2020" ReadOnly="True" SortExpression="jul 2020" UniqueName="jul2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug2020" ReadOnly="True" SortExpression="aug 2020" UniqueName="aug2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep2020" ReadOnly="True" SortExpression="sep 2020" UniqueName="sep2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020" ReadOnly="True" SortExpression="oct 2020" UniqueName="oct2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020" ReadOnly="True" SortExpression="nov 2020" UniqueName="nov2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020" ReadOnly="True" SortExpression="dec 2020" UniqueName="dec2020"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" ReadOnly="True" SortExpression="total_2020" UniqueName="total_2020"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="TotalDemandRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_total_demand2" SelectCommandType="StoredProcedure"
                UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            
            <br />
            
            <!-- SELLING PRICE  -->

            <telerik:RadGrid ID="SellingPriceRadGrid" runat="server" CellSpacing="0" DataSourceID="SellingPriceRadGridDataSource"
                GridLines="None" ShowHeader="false" Width="3600">
                <MasterTableView DataSourceID="SellingPriceRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54" EditMode="InPlace" AllowAutomaticUpdates="true" >
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column"
                            HeaderStyle-Width="75" >
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column"
                            HeaderText="base_part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part"
                            HeaderStyle-Width="75" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column"
                            HeaderText="description" ReadOnly="True" SortExpression="description" UniqueName="description"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan 2015"  SortExpression="jan 2015" UniqueName="jan2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb 2015"  SortExpression="feb 2015" UniqueName="feb2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar 2015"  SortExpression="mar 2015" UniqueName="mar2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr 2015"  SortExpression="apr 2015" UniqueName="apr2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May 2015"  SortExpression="may 2015" UniqueName="may2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun 2015"  SortExpression="jun 2015" UniqueName="jun2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul 2015"  SortExpression="jul 2015" UniqueName="jul2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug 2015"  SortExpression="aug 2015" UniqueName="aug2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep 2015"  SortExpression="sep 2015" UniqueName="sep2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct 2015"  SortExpression="oct 2015" UniqueName="oct2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov 2015"  SortExpression="nov 2015" UniqueName="nov2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec 2015"  SortExpression="dec 2015" UniqueName="dec2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015"  SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016"  SortExpression="jan 2016" UniqueName="Jan2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016"  SortExpression="feb 2016" UniqueName="Feb2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016"  SortExpression="mar 2016" UniqueName="Mar2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016"  SortExpression="apr 2016" UniqueName="apr2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016"  SortExpression="may 2016" UniqueName="may2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun2016"  SortExpression="jun 2016" UniqueName="jun2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul2016"  SortExpression="jul 2016" UniqueName="jul2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug2016"  SortExpression="aug 2016" UniqueName="aug2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep2016"  SortExpression="sep 2016" UniqueName="sep2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016"  SortExpression="oct 2016" UniqueName="oct2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016"  SortExpression="nov 2016" UniqueName="nov2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016"  SortExpression="dec 2016" UniqueName="dec2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016"  SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                       
                         
                        <telerik:GridBoundColumn DataField="jan2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017"  SortExpression="jan 2017" UniqueName="Jan2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017"  SortExpression="feb 2017" UniqueName="Feb2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017"  SortExpression="mar 2017" UniqueName="Mar2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017"  SortExpression="apr 2017" UniqueName="apr2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017"  SortExpression="may 2017" UniqueName="may2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun2017"  SortExpression="jun 2017" UniqueName="jun2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul2017"  SortExpression="jul 2017" UniqueName="jul2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug2017"  SortExpression="aug 2017" UniqueName="aug2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep2017"  SortExpression="sep 2017" UniqueName="sep2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017"  SortExpression="oct 2017" UniqueName="oct2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017"  SortExpression="nov 2017" UniqueName="nov2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017"  SortExpression="dec 2017" UniqueName="dec2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017"  SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                         <telerik:GridBoundColumn DataField="jan2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018"  SortExpression="jan 2018" UniqueName="Jan2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018"  SortExpression="feb 2018" UniqueName="Feb2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018"  SortExpression="mar 2018" UniqueName="Mar2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018"  SortExpression="apr 2018" UniqueName="apr2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018"  SortExpression="may 2018" UniqueName="may2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun2018"  SortExpression="jun 2018" UniqueName="jun2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul2018"  SortExpression="jul 2018" UniqueName="jul2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug2018"  SortExpression="aug 2018" UniqueName="aug2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep2018"  SortExpression="sep 2018" UniqueName="sep2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018"  SortExpression="oct 2018" UniqueName="oct2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018"  SortExpression="nov 2018" UniqueName="nov2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018"  SortExpression="dec 2018" UniqueName="dec2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018"  SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="jan2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019"  SortExpression="jan 2019" UniqueName="Jan2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019"  SortExpression="feb 2019" UniqueName="Feb2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019"  SortExpression="mar 2019" UniqueName="Mar2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019"  SortExpression="apr 2019" UniqueName="apr2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019"  SortExpression="may 2019" UniqueName="may2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun2019"  SortExpression="jun 2019" UniqueName="jun2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul2019"  SortExpression="jul 2019" UniqueName="jul2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug2019"  SortExpression="aug 2019" UniqueName="aug2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep2019"  SortExpression="sep 2019" UniqueName="sep2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019"  SortExpression="oct 2019" UniqueName="oct2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019"  SortExpression="nov 2019" UniqueName="nov2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019"  SortExpression="dec 2019" UniqueName="dec2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019"  SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="jan2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020"  SortExpression="jan 2020" UniqueName="Jan2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020"  SortExpression="feb 2020" UniqueName="Feb2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020"  SortExpression="mar 2020" UniqueName="Mar2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020"  SortExpression="apr 2020" UniqueName="apr2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020"  SortExpression="may 2020" UniqueName="may2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun2020"  SortExpression="jun 2020" UniqueName="jun2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul2020"  SortExpression="jul 2020" UniqueName="jul2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug2020"  SortExpression="aug 2020" UniqueName="aug2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep2020"  SortExpression="sep 2020" UniqueName="sep2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020"  SortExpression="oct 2020" UniqueName="oct2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020"  SortExpression="nov 2020" UniqueName="nov2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020"  SortExpression="dec 2020" UniqueName="dec2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020"  SortExpression="total_2020" UniqueName="total_2020"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>



                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021"  SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022"  SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="SellingPriceRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_selling_prices2" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_selling_prices2" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>                
                <UpdateParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name ="jan2015" Type="Decimal" />
                    <asp:Parameter Name ="feb2015" Type="Decimal" />
                    <asp:Parameter Name ="mar2015" Type="Decimal" />
                    <asp:Parameter Name ="apr2015" Type="Decimal" />
                    <asp:Parameter Name ="may2015" Type="Decimal" />
                    <asp:Parameter Name ="jun2015" Type="Decimal" />
                    <asp:Parameter Name ="jul2015" Type="Decimal" />
                    <asp:Parameter Name ="aug2015" Type="Decimal" />
                    <asp:Parameter Name ="sep2015" Type="Decimal" />
                    <asp:Parameter Name ="oct2015" Type="Decimal" />
                    <asp:Parameter Name ="nov2015" Type="Decimal" />
                    <asp:Parameter Name ="dec2015" Type="Decimal" />
                    <asp:Parameter Name ="total_2015" Type="Decimal" />

                    <asp:Parameter Name ="jan2016" Type="Decimal" />
                    <asp:Parameter Name ="feb2016" Type="Decimal" />
                    <asp:Parameter Name ="mar2016" Type="Decimal" />
                    <asp:Parameter Name ="apr2016" Type="Decimal" />
                    <asp:Parameter Name ="may2016" Type="Decimal" />
                    <asp:Parameter Name ="jun2016" Type="Decimal" />
                    <asp:Parameter Name ="jul2016" Type="Decimal" />
                    <asp:Parameter Name ="aug2016" Type="Decimal" />
                    <asp:Parameter Name ="sep2016" Type="Decimal" />
                    <asp:Parameter Name ="oct2016" Type="Decimal" />
                    <asp:Parameter Name ="nov2016" Type="Decimal" />
                    <asp:Parameter Name ="dec2016" Type="Decimal" />
                    <asp:Parameter Name ="total_2016" Type="Decimal" />

                    <asp:Parameter Name ="jan2017" Type="Decimal" />
                    <asp:Parameter Name ="feb2017" Type="Decimal" />
                    <asp:Parameter Name ="mar2017" Type="Decimal" />
                    <asp:Parameter Name ="apr2017" Type="Decimal" />
                    <asp:Parameter Name ="may2017" Type="Decimal" />
                    <asp:Parameter Name ="jun2017" Type="Decimal" />
                    <asp:Parameter Name ="jul2017" Type="Decimal" />
                    <asp:Parameter Name ="aug2017" Type="Decimal" />
                    <asp:Parameter Name ="sep2017" Type="Decimal" />
                    <asp:Parameter Name ="oct2017" Type="Decimal" />
                    <asp:Parameter Name ="nov2017" Type="Decimal" />
                    <asp:Parameter Name ="dec2017" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2017" Type="Decimal" />

                    <asp:Parameter Name ="jan2018" Type="Decimal" />
                    <asp:Parameter Name ="feb2018" Type="Decimal" />
                    <asp:Parameter Name ="mar2018" Type="Decimal" />
                    <asp:Parameter Name ="apr2018" Type="Decimal" />
                    <asp:Parameter Name ="may2018" Type="Decimal" />
                    <asp:Parameter Name ="jun2018" Type="Decimal" />
                    <asp:Parameter Name ="jul2018" Type="Decimal" />
                    <asp:Parameter Name ="aug2018" Type="Decimal" />
                    <asp:Parameter Name ="sep2018" Type="Decimal" />
                    <asp:Parameter Name ="oct2018" Type="Decimal" />
                    <asp:Parameter Name ="nov2018" Type="Decimal" />
                    <asp:Parameter Name ="dec2018" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2018" Type="Decimal" />

		    <asp:Parameter Name ="jan2019" Type="Decimal" />
                    <asp:Parameter Name ="feb2019" Type="Decimal" />
                    <asp:Parameter Name ="mar2019" Type="Decimal" />
                    <asp:Parameter Name ="apr2019" Type="Decimal" />
                    <asp:Parameter Name ="may2019" Type="Decimal" />
                    <asp:Parameter Name ="jun2019" Type="Decimal" />
                    <asp:Parameter Name ="jul2019" Type="Decimal" />
                    <asp:Parameter Name ="aug2019" Type="Decimal" />
                    <asp:Parameter Name ="sep2019" Type="Decimal" />
                    <asp:Parameter Name ="oct2019" Type="Decimal" />
                    <asp:Parameter Name ="nov2019" Type="Decimal" />
                    <asp:Parameter Name ="dec2019" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2019" Type="Decimal" />

		    <asp:Parameter Name ="jan2020" Type="Decimal" />
                    <asp:Parameter Name ="feb2020" Type="Decimal" />
                    <asp:Parameter Name ="mar2020" Type="Decimal" />
                    <asp:Parameter Name ="apr2020" Type="Decimal" />
                    <asp:Parameter Name ="may2020" Type="Decimal" />
                    <asp:Parameter Name ="jun2020" Type="Decimal" />
                    <asp:Parameter Name ="jul2020" Type="Decimal" />
                    <asp:Parameter Name ="aug2020" Type="Decimal" />
                    <asp:Parameter Name ="sep2020" Type="Decimal" />
                    <asp:Parameter Name ="oct2020" Type="Decimal" />
                    <asp:Parameter Name ="nov2020" Type="Decimal" />
                    <asp:Parameter Name ="dec2020" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2020" Type="Decimal" />

                    <asp:Parameter Name ="total_2021" Type="Decimal" />
                    <asp:Parameter Name ="Total_2022" Type="Decimal" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <!-- TOTAL REVENUE (TOTAL DEMAND x SELLING PRICE) -->

            <telerik:RadGrid ID="TotalRevenueRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalRevenueRadGridDataSource"
                GridLines="None" ShowHeader="false" Width="3600">
                <MasterTableView DataSourceID="TotalRevenueRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54">
                    <Columns>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column"
                            HeaderText="description" SortExpression="description" UniqueName="description"
                            ReadOnly="True" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan 2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan 2015" ReadOnly="True" SortExpression="jan 2015" UniqueName="jan2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb 2015" ReadOnly="True" SortExpression="feb 2015" UniqueName="feb2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar 2015" ReadOnly="True" SortExpression="mar 2015" UniqueName="mar2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr 2015" ReadOnly="True" SortExpression="apr 2015" UniqueName="apr2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May 2015" ReadOnly="True" SortExpression="may 2015" UniqueName="may2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun 2015" ReadOnly="True" SortExpression="jun 2015" UniqueName="jun2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul 2015" ReadOnly="True" SortExpression="jul 2015" UniqueName="jul2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug 2015" ReadOnly="True" SortExpression="aug 2015" UniqueName="aug2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep 2015" ReadOnly="True" SortExpression="sep 2015" UniqueName="sep2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct 2015" ReadOnly="True" SortExpression="oct 2015" UniqueName="oct2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov 2015" ReadOnly="True" SortExpression="nov 2015" UniqueName="nov2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec 2015" ReadOnly="True" SortExpression="dec 2015" UniqueName="dec2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan 2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016" ReadOnly="True" SortExpression="jan 2016" UniqueName="Jan2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016" ReadOnly="True" SortExpression="feb 2016" UniqueName="Feb2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016" ReadOnly="True" SortExpression="mar 2016" UniqueName="Mar2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016" ReadOnly="True" SortExpression="apr 2016" UniqueName="apr2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016" ReadOnly="True" SortExpression="may 2016" UniqueName="may2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun2016" ReadOnly="True" SortExpression="jun 2016" UniqueName="jun2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul2016" ReadOnly="True" SortExpression="jul 2016" UniqueName="jul2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug2016" ReadOnly="True" SortExpression="aug 2016" UniqueName="aug2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep2016" ReadOnly="True" SortExpression="sep 2016" UniqueName="sep2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016" ReadOnly="True" SortExpression="oct 2016" UniqueName="oct2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016" ReadOnly="True" SortExpression="nov 2016" UniqueName="nov2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016" ReadOnly="True" SortExpression="dec 2016" UniqueName="dec2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan 2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017" ReadOnly="True" SortExpression="jan 2017" UniqueName="Jan2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017" ReadOnly="True" SortExpression="feb 2017" UniqueName="Feb2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017" ReadOnly="True" SortExpression="mar 2017" UniqueName="Mar2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017" ReadOnly="True" SortExpression="apr 2017" UniqueName="apr2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017" ReadOnly="True" SortExpression="may 2017" UniqueName="may2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun2017" ReadOnly="True" SortExpression="jun 2017" UniqueName="jun2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul2017" ReadOnly="True" SortExpression="jul 2017" UniqueName="jul2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug2017" ReadOnly="True" SortExpression="aug 2017" UniqueName="aug2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep2017" ReadOnly="True" SortExpression="sep 2017" UniqueName="sep2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017" ReadOnly="True" SortExpression="oct 2017" UniqueName="oct2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017" ReadOnly="True" SortExpression="nov 2017" UniqueName="nov2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017" ReadOnly="True" SortExpression="dec 2017" UniqueName="dec2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="jan 2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018" ReadOnly="True" SortExpression="jan 2018" UniqueName="Jan2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018" ReadOnly="True" SortExpression="feb 2018" UniqueName="Feb2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018" ReadOnly="True" SortExpression="mar 2018" UniqueName="Mar2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018" ReadOnly="True" SortExpression="apr 2018" UniqueName="apr2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018" ReadOnly="True" SortExpression="may 2018" UniqueName="may2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun2018" ReadOnly="True" SortExpression="jun 2018" UniqueName="jun2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul2018" ReadOnly="True" SortExpression="jul 2018" UniqueName="jul2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug2018" ReadOnly="True" SortExpression="aug 2018" UniqueName="aug2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep2018" ReadOnly="True" SortExpression="sep 2018" UniqueName="sep2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018" ReadOnly="True" SortExpression="oct 2018" UniqueName="oct2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018" ReadOnly="True" SortExpression="nov 2018" UniqueName="nov2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018" ReadOnly="True" SortExpression="dec 2018" UniqueName="dec2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan 2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019" ReadOnly="True" SortExpression="jan 2019" UniqueName="Jan2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019" ReadOnly="True" SortExpression="feb 2019" UniqueName="Feb2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019" ReadOnly="True" SortExpression="mar 2019" UniqueName="Mar2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019" ReadOnly="True" SortExpression="apr 2019" UniqueName="apr2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019" ReadOnly="True" SortExpression="may 2019" UniqueName="may2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun2019" ReadOnly="True" SortExpression="jun 2019" UniqueName="jun2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul2019" ReadOnly="True" SortExpression="jul 2019" UniqueName="jul2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug2019" ReadOnly="True" SortExpression="aug 2019" UniqueName="aug2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep2019" ReadOnly="True" SortExpression="sep 2019" UniqueName="sep2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019" ReadOnly="True" SortExpression="oct 2019" UniqueName="oct2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019" ReadOnly="True" SortExpression="nov 2019" UniqueName="nov2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019" ReadOnly="True" SortExpression="dec 2019" UniqueName="dec2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan 2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020" ReadOnly="True" SortExpression="jan 2020" UniqueName="Jan2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020" ReadOnly="True" SortExpression="feb 2020" UniqueName="Feb2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020" ReadOnly="True" SortExpression="mar 2020" UniqueName="Mar2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020" ReadOnly="True" SortExpression="apr 2020" UniqueName="apr2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020" ReadOnly="True" SortExpression="may 2020" UniqueName="may2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun2020" ReadOnly="True" SortExpression="jun 2020" UniqueName="jun2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul2020" ReadOnly="True" SortExpression="jul 2020" UniqueName="jul2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug2020" ReadOnly="True" SortExpression="aug 2020" UniqueName="aug2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep2020" ReadOnly="True" SortExpression="sep 2020" UniqueName="sep2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020" ReadOnly="True" SortExpression="oct 2020" UniqueName="oct2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020" ReadOnly="True" SortExpression="nov 2020" UniqueName="nov2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020" ReadOnly="True" SortExpression="dec 2020" UniqueName="dec2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" ReadOnly="True" SortExpression="total_2020" UniqueName="total_2020"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="TotalRevenueRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_total_revenue2" SelectCommandType="StoredProcedure"
                UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            
            <br />

            <!-- MATERIAL COST  -->

            <telerik:RadGrid ID="MaterialCostRadGrid" runat="server" CellSpacing="0" DataSourceID="MaterialCostRadGridDataSource"
                GridLines="None" ShowHeader="false" Width="3600" AllowAutomaticUpdates="true">
                <MasterTableView DataSourceID="MaterialCostRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54" EditMode="InPlace" >
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column"
                            HeaderStyle-Width="75" >
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column"
                            HeaderText="base_part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part"
                            HeaderStyle-Width="75" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column"
                            HeaderText="description" ReadOnly="True" SortExpression="description" UniqueName="description"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="partusedforcost" FilterControlAltText="Filter partusedforcost column"
                            HeaderText="Rev Level"  SortExpression="partusedforcost" UniqueName="partusedforcost"
                            HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="54">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan 2015"  SortExpression="jan 2015" UniqueName="jan2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb 2015"  SortExpression="feb 2015" UniqueName="feb2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar 2015"  SortExpression="mar 2015" UniqueName="mar2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr 2015"  SortExpression="apr 2015" UniqueName="apr2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May 2015"  SortExpression="may 2015" UniqueName="may2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun 2015"  SortExpression="jun 2015" UniqueName="jun2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul 2015"  SortExpression="jul 2015" UniqueName="jul2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug 2015"  SortExpression="aug 2015" UniqueName="aug2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep 2015"  SortExpression="sep 2015" UniqueName="sep2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct 2015"  SortExpression="oct 2015" UniqueName="oct2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov 2015"  SortExpression="nov 2015" UniqueName="nov2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec 2015"  SortExpression="dec 2015" UniqueName="dec2015"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015"  SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016"  SortExpression="jan 2016" UniqueName="Jan2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016"  SortExpression="feb 2016" UniqueName="Feb2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016"  SortExpression="mar 2016" UniqueName="Mar2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016"  SortExpression="apr 2016" UniqueName="apr2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016"  SortExpression="may 2016" UniqueName="may2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun2016"  SortExpression="jun 2016" UniqueName="jun2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul2016"  SortExpression="jul 2016" UniqueName="jul2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug2016"  SortExpression="aug 2016" UniqueName="aug2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep2016"  SortExpression="sep 2016" UniqueName="sep2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016"  SortExpression="oct 2016" UniqueName="oct2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016"  SortExpression="nov 2016" UniqueName="nov2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016"  SortExpression="dec 2016" UniqueName="dec2016"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016"  SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                                                
                        <telerik:GridBoundColumn DataField="jan2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017"  SortExpression="jan 2017" UniqueName="Jan2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017"  SortExpression="feb 2017" UniqueName="Feb2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017"  SortExpression="mar 2017" UniqueName="Mar2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017"  SortExpression="apr 2017" UniqueName="apr2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017"  SortExpression="may 2017" UniqueName="may2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun2017"  SortExpression="jun 2017" UniqueName="jun2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul2017"  SortExpression="jul 2017" UniqueName="jul2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug2017"  SortExpression="aug 2017" UniqueName="aug2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep2017"  SortExpression="sep 2017" UniqueName="sep2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017"  SortExpression="oct 2017" UniqueName="oct2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017"  SortExpression="nov 2017" UniqueName="nov2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017"  SortExpression="dec 2017" UniqueName="dec2017"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017"  SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018"  SortExpression="jan 2018" UniqueName="Jan2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018"  SortExpression="feb 2018" UniqueName="Feb2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018"  SortExpression="mar 2018" UniqueName="Mar2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018"  SortExpression="apr 2018" UniqueName="apr2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018"  SortExpression="may 2018" UniqueName="may2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun2018"  SortExpression="jun 2018" UniqueName="jun2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul2018"  SortExpression="jul 2018" UniqueName="jul2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug2018"  SortExpression="aug 2018" UniqueName="aug2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep2018"  SortExpression="sep 2018" UniqueName="sep2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018"  SortExpression="oct 2018" UniqueName="oct2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018"  SortExpression="nov 2018" UniqueName="nov2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018"  SortExpression="dec 2018" UniqueName="dec2018"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018"  SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019"  SortExpression="jan 2019" UniqueName="Jan2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019"  SortExpression="feb 2019" UniqueName="Feb2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019"  SortExpression="mar 2019" UniqueName="Mar2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019"  SortExpression="apr 2019" UniqueName="apr2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019"  SortExpression="may 2019" UniqueName="may2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun2019"  SortExpression="jun 2019" UniqueName="jun2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul2019"  SortExpression="jul 2019" UniqueName="jul2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug2019"  SortExpression="aug 2019" UniqueName="aug2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep2019"  SortExpression="sep 2019" UniqueName="sep2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019"  SortExpression="oct 2019" UniqueName="oct2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019"  SortExpression="nov 2019" UniqueName="nov2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019"  SortExpression="dec 2019" UniqueName="dec2019"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019"  SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

			<telerik:GridBoundColumn DataField="jan2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020"  SortExpression="jan 2020" UniqueName="Jan2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020"  SortExpression="feb 2020" UniqueName="Feb2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020"  SortExpression="mar 2020" UniqueName="Mar2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020"  SortExpression="apr 2020" UniqueName="apr2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020"  SortExpression="may 2020" UniqueName="may2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun2020"  SortExpression="jun 2020" UniqueName="jun2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul2020"  SortExpression="jul 2020" UniqueName="jul2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug2020"  SortExpression="aug 2020" UniqueName="aug2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep2020"  SortExpression="sep 2020" UniqueName="sep2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020"  SortExpression="oct 2020" UniqueName="oct2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020"  SortExpression="nov 2020" UniqueName="nov2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020"  SortExpression="dec 2020" UniqueName="dec2020"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020"  SortExpression="total_2020" UniqueName="total_2020"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021"  SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022"  SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="MaterialCostRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_total_material_cost2" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_material_cost2" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:Parameter Name="partusedforcost" Type="String" />
                    <asp:Parameter Name ="jan2015" Type="Decimal" />
                    <asp:Parameter Name ="feb2015" Type="Decimal" />
                    <asp:Parameter Name ="mar2015" Type="Decimal" />
                    <asp:Parameter Name ="apr2015" Type="Decimal" />
                    <asp:Parameter Name ="may2015" Type="Decimal" />
                    <asp:Parameter Name ="jun2015" Type="Decimal" />
                    <asp:Parameter Name ="jul2015" Type="Decimal" />
                    <asp:Parameter Name ="aug2015" Type="Decimal" />
                    <asp:Parameter Name ="sep2015" Type="Decimal" />
                    <asp:Parameter Name ="oct2015" Type="Decimal" />
                    <asp:Parameter Name ="nov2015" Type="Decimal" />
                    <asp:Parameter Name ="dec2015" Type="Decimal" />
                    <asp:Parameter Name ="total_2015" Type="Decimal" />

                    <asp:Parameter Name ="jan2016" Type="Decimal" />
                    <asp:Parameter Name ="feb2016" Type="Decimal" />
                    <asp:Parameter Name ="mar2016" Type="Decimal" />
                    <asp:Parameter Name ="apr2016" Type="Decimal" />
                    <asp:Parameter Name ="may2016" Type="Decimal" />
                    <asp:Parameter Name ="jun2016" Type="Decimal" />
                    <asp:Parameter Name ="jul2016" Type="Decimal" />
                    <asp:Parameter Name ="aug2016" Type="Decimal" />
                    <asp:Parameter Name ="sep2016" Type="Decimal" />
                    <asp:Parameter Name ="oct2016" Type="Decimal" />
                    <asp:Parameter Name ="nov2016" Type="Decimal" />
                    <asp:Parameter Name ="dec2016" Type="Decimal" />
                    <asp:Parameter Name ="total_2016" Type="Decimal" />

                    <asp:Parameter Name ="jan2017" Type="Decimal" />
                    <asp:Parameter Name ="feb2017" Type="Decimal" />
                    <asp:Parameter Name ="mar2017" Type="Decimal" />
                    <asp:Parameter Name ="apr2017" Type="Decimal" />
                    <asp:Parameter Name ="may2017" Type="Decimal" />
                    <asp:Parameter Name ="jun2017" Type="Decimal" />
                    <asp:Parameter Name ="jul2017" Type="Decimal" />
                    <asp:Parameter Name ="aug2017" Type="Decimal" />
                    <asp:Parameter Name ="sep2017" Type="Decimal" />
                    <asp:Parameter Name ="oct2017" Type="Decimal" />
                    <asp:Parameter Name ="nov2017" Type="Decimal" />
                    <asp:Parameter Name ="dec2017" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2017" Type="Decimal" />
                    
                    <asp:Parameter Name ="jan2018" Type="Decimal" />
                    <asp:Parameter Name ="feb2018" Type="Decimal" />
                    <asp:Parameter Name ="mar2018" Type="Decimal" />
                    <asp:Parameter Name ="apr2018" Type="Decimal" />
                    <asp:Parameter Name ="may2018" Type="Decimal" />
                    <asp:Parameter Name ="jun2018" Type="Decimal" />
                    <asp:Parameter Name ="jul2018" Type="Decimal" />
                    <asp:Parameter Name ="aug2018" Type="Decimal" />
                    <asp:Parameter Name ="sep2018" Type="Decimal" />
                    <asp:Parameter Name ="oct2018" Type="Decimal" />
                    <asp:Parameter Name ="nov2018" Type="Decimal" />
                    <asp:Parameter Name ="dec2018" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2018" Type="Decimal" />

                    <asp:Parameter Name ="jan2019" Type="Decimal" />
                    <asp:Parameter Name ="feb2019" Type="Decimal" />
                    <asp:Parameter Name ="mar2019" Type="Decimal" />
                    <asp:Parameter Name ="apr2019" Type="Decimal" />
                    <asp:Parameter Name ="may2019" Type="Decimal" />
                    <asp:Parameter Name ="jun2019" Type="Decimal" />
                    <asp:Parameter Name ="jul2019" Type="Decimal" />
                    <asp:Parameter Name ="aug2019" Type="Decimal" />
                    <asp:Parameter Name ="sep2019" Type="Decimal" />
                    <asp:Parameter Name ="oct2019" Type="Decimal" />
                    <asp:Parameter Name ="nov2019" Type="Decimal" />
                    <asp:Parameter Name ="dec2019" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2019" Type="Decimal" />

                    <asp:Parameter Name ="jan2020" Type="Decimal" />
                    <asp:Parameter Name ="feb2020" Type="Decimal" />
                    <asp:Parameter Name ="mar2020" Type="Decimal" />
                    <asp:Parameter Name ="apr2020" Type="Decimal" />
                    <asp:Parameter Name ="may2020" Type="Decimal" />
                    <asp:Parameter Name ="jun2020" Type="Decimal" />
                    <asp:Parameter Name ="jul2020" Type="Decimal" />
                    <asp:Parameter Name ="aug2020" Type="Decimal" />
                    <asp:Parameter Name ="sep2020" Type="Decimal" />
                    <asp:Parameter Name ="oct2020" Type="Decimal" />
                    <asp:Parameter Name ="nov2020" Type="Decimal" />
                    <asp:Parameter Name ="dec2020" Type="Decimal" />                   
                    <asp:Parameter Name ="total_2020" Type="Decimal" />

                    <asp:Parameter Name ="total_2021" Type="Decimal" />
                    <asp:Parameter Name ="Total_2022" Type="Decimal" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <!-- TOTAL MATERIAL (TOTAL DEMAND x MATERIAL COST) -->

            <telerik:RadGrid ID="TotalMaterialRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalMaterialRadGridDataSource"
                GridLines="None" ShowHeader="false" Width="3600">
                <MasterTableView DataSourceID="TotalMaterialRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54">
                    <Columns>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column"
                            HeaderText="description" SortExpression="description" UniqueName="description"
                            ReadOnly="True" HeaderStyle-Width="150">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75" Display="False">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="jan 2015" DataType="System.Int32" FilterControlAltText="Filter jan 2015 column"
                            HeaderText="Jan 2015" ReadOnly="True" SortExpression="jan 2015" UniqueName="jan2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2015" DataType="System.Int32" FilterControlAltText="Filter feb 2015 column"
                            HeaderText="Feb 2015" ReadOnly="True" SortExpression="feb 2015" UniqueName="feb2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2015" DataType="System.Int32" FilterControlAltText="Filter mar 2015 column"
                            HeaderText="Mar 2015" ReadOnly="True" SortExpression="mar 2015" UniqueName="mar2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2015" DataType="System.Int32" FilterControlAltText="Filter apr 2015 column"
                            HeaderText="Apr 2015" ReadOnly="True" SortExpression="apr 2015" UniqueName="apr2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2015" DataType="System.Int32" FilterControlAltText="Filter may 2015 column"
                            HeaderText="May 2015" ReadOnly="True" SortExpression="may 2015" UniqueName="may2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2015" DataType="System.Int32" FilterControlAltText="Filter jun 2015 column"
                            HeaderText="Jun 2015" ReadOnly="True" SortExpression="jun 2015" UniqueName="jun2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2015" DataType="System.Int32" FilterControlAltText="Filter jul 2015 column"
                            HeaderText="Jul 2015" ReadOnly="True" SortExpression="jul 2015" UniqueName="jul2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2015" DataType="System.Int32" FilterControlAltText="Filter aug 2015 column"
                            HeaderText="Aug 2015" ReadOnly="True" SortExpression="aug 2015" UniqueName="aug2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2015" DataType="System.Int32" FilterControlAltText="Filter sep 2015 column"
                            HeaderText="Sep 2015" ReadOnly="True" SortExpression="sep 2015" UniqueName="sep2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2015" DataType="System.Int32" FilterControlAltText="Filter oct 2015 column"
                            HeaderText="Oct 2015" ReadOnly="True" SortExpression="oct 2015" UniqueName="oct2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2015" DataType="System.Int32" FilterControlAltText="Filter nov 2015 column"
                            HeaderText="Nov 2015" ReadOnly="True" SortExpression="nov 2015" UniqueName="nov2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2015" DataType="System.Int32" FilterControlAltText="Filter dec 2015 column"
                            HeaderText="Dec 2015" ReadOnly="True" SortExpression="dec 2015" UniqueName="dec2015"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan 2016" DataType="System.Int32" FilterControlAltText="Filter jan 2016 column"
                            HeaderText="jan 2016" ReadOnly="True" SortExpression="jan 2016" UniqueName="Jan2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2016" DataType="System.Int32" FilterControlAltText="Filter feb 2016 column"
                            HeaderText="feb 2016" ReadOnly="True" SortExpression="feb 2016" UniqueName="Feb2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2016" DataType="System.Int32" FilterControlAltText="Filter mar 2016 column"
                            HeaderText="Mar 2016" ReadOnly="True" SortExpression="mar 2016" UniqueName="Mar2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2016" DataType="System.Int32" FilterControlAltText="Filter apr 2016 column"
                            HeaderText="Apr 2016" ReadOnly="True" SortExpression="apr 2016" UniqueName="apr2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2016" DataType="System.Int32" FilterControlAltText="Filter may 2016 column"
                            HeaderText="May 2016" ReadOnly="True" SortExpression="may 2016" UniqueName="may2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2016" DataType="System.Int32" FilterControlAltText="Filter jun 2016 column"
                            HeaderText="Jun2016" ReadOnly="True" SortExpression="jun 2016" UniqueName="jun2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2016" DataType="System.Int32" FilterControlAltText="Filter jul 2016 column"
                            HeaderText="Jul2016" ReadOnly="True" SortExpression="jul 2016" UniqueName="jul2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2016" DataType="System.Int32" FilterControlAltText="Filter aug 2016 column"
                            HeaderText="Aug2016" ReadOnly="True" SortExpression="aug 2016" UniqueName="aug2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2016" DataType="System.Int32" FilterControlAltText="Filter sep 2016 column"
                            HeaderText="Sep2016" ReadOnly="True" SortExpression="sep 2016" UniqueName="sep2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2016" DataType="System.Int32" FilterControlAltText="Filter oct 2016 column"
                            HeaderText="Oct 2016" ReadOnly="True" SortExpression="oct 2016" UniqueName="oct2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2016" DataType="System.Int32" FilterControlAltText="Filter nov 2016 column"
                            HeaderText="Nov 2016" ReadOnly="True" SortExpression="nov 2016" UniqueName="nov2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2016" DataType="System.Int32" FilterControlAltText="Filter dec 2016 column"
                            HeaderText="Dec 2016" ReadOnly="True" SortExpression="dec 2016" UniqueName="dec2016"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="jan 2017" DataType="System.Int32" FilterControlAltText="Filter jan 2017 column"
                            HeaderText="jan 2017" ReadOnly="True" SortExpression="jan 2017" UniqueName="Jan2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2017" DataType="System.Int32" FilterControlAltText="Filter feb 2017 column"
                            HeaderText="feb 2017" ReadOnly="True" SortExpression="feb 2017" UniqueName="Feb2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2017" DataType="System.Int32" FilterControlAltText="Filter mar 2017 column"
                            HeaderText="Mar 2017" ReadOnly="True" SortExpression="mar 2017" UniqueName="Mar2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2017" DataType="System.Int32" FilterControlAltText="Filter apr 2017 column"
                            HeaderText="Apr 2017" ReadOnly="True" SortExpression="apr 2017" UniqueName="apr2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2017" DataType="System.Int32" FilterControlAltText="Filter may 2017 column"
                            HeaderText="May 2017" ReadOnly="True" SortExpression="may 2017" UniqueName="may2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2017" DataType="System.Int32" FilterControlAltText="Filter jun 2017 column"
                            HeaderText="Jun2017" ReadOnly="True" SortExpression="jun 2017" UniqueName="jun2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2017" DataType="System.Int32" FilterControlAltText="Filter jul 2017 column"
                            HeaderText="Jul2017" ReadOnly="True" SortExpression="jul 2017" UniqueName="jul2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2017" DataType="System.Int32" FilterControlAltText="Filter aug 2017 column"
                            HeaderText="Aug2017" ReadOnly="True" SortExpression="aug 2017" UniqueName="aug2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2017" DataType="System.Int32" FilterControlAltText="Filter sep 2017 column"
                            HeaderText="Sep2017" ReadOnly="True" SortExpression="sep 2017" UniqueName="sep2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2017" DataType="System.Int32" FilterControlAltText="Filter oct 2017 column"
                            HeaderText="Oct 2017" ReadOnly="True" SortExpression="oct 2017" UniqueName="oct2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2017" DataType="System.Int32" FilterControlAltText="Filter nov 2017 column"
                            HeaderText="Nov 2017" ReadOnly="True" SortExpression="nov 2017" UniqueName="nov2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2017" DataType="System.Int32" FilterControlAltText="Filter dec 2017 column"
                            HeaderText="Dec 2017" ReadOnly="True" SortExpression="dec 2017" UniqueName="dec2017"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="jan 2018" DataType="System.Int32" FilterControlAltText="Filter jan 2018 column"
                            HeaderText="jan 2018" ReadOnly="True" SortExpression="jan 2018" UniqueName="Jan2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2018" DataType="System.Int32" FilterControlAltText="Filter feb 2018 column"
                            HeaderText="feb 2018" ReadOnly="True" SortExpression="feb 2018" UniqueName="Feb2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2018" DataType="System.Int32" FilterControlAltText="Filter mar 2018 column"
                            HeaderText="Mar 2018" ReadOnly="True" SortExpression="mar 2018" UniqueName="Mar2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2018" DataType="System.Int32" FilterControlAltText="Filter apr 2018 column"
                            HeaderText="Apr 2018" ReadOnly="True" SortExpression="apr 2018" UniqueName="apr2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2018" DataType="System.Int32" FilterControlAltText="Filter may 2018 column"
                            HeaderText="May 2018" ReadOnly="True" SortExpression="may 2018" UniqueName="may2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2018" DataType="System.Int32" FilterControlAltText="Filter jun 2018 column"
                            HeaderText="Jun2018" ReadOnly="True" SortExpression="jun 2018" UniqueName="jun2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2018" DataType="System.Int32" FilterControlAltText="Filter jul 2018 column"
                            HeaderText="Jul2018" ReadOnly="True" SortExpression="jul 2018" UniqueName="jul2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2018" DataType="System.Int32" FilterControlAltText="Filter aug 2018 column"
                            HeaderText="Aug2018" ReadOnly="True" SortExpression="aug 2018" UniqueName="aug2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2018" DataType="System.Int32" FilterControlAltText="Filter sep 2018 column"
                            HeaderText="Sep2018" ReadOnly="True" SortExpression="sep 2018" UniqueName="sep2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2018" DataType="System.Int32" FilterControlAltText="Filter oct 2018 column"
                            HeaderText="Oct 2018" ReadOnly="True" SortExpression="oct 2018" UniqueName="oct2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2018" DataType="System.Int32" FilterControlAltText="Filter nov 2018 column"
                            HeaderText="Nov 2018" ReadOnly="True" SortExpression="nov 2018" UniqueName="nov2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2018" DataType="System.Int32" FilterControlAltText="Filter dec 2018 column"
                            HeaderText="Dec 2018" ReadOnly="True" SortExpression="dec 2018" UniqueName="dec2018"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="jan 2019" DataType="System.Int32" FilterControlAltText="Filter jan 2019 column"
                            HeaderText="jan 2019" ReadOnly="True" SortExpression="jan 2019" UniqueName="Jan2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2019" DataType="System.Int32" FilterControlAltText="Filter feb 2019 column"
                            HeaderText="feb 2019" ReadOnly="True" SortExpression="feb 2019" UniqueName="Feb2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2019" DataType="System.Int32" FilterControlAltText="Filter mar 2019 column"
                            HeaderText="Mar 2019" ReadOnly="True" SortExpression="mar 2019" UniqueName="Mar2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2019" DataType="System.Int32" FilterControlAltText="Filter apr 2019 column"
                            HeaderText="Apr 2019" ReadOnly="True" SortExpression="apr 2019" UniqueName="apr2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2019" DataType="System.Int32" FilterControlAltText="Filter may 2019 column"
                            HeaderText="May 2019" ReadOnly="True" SortExpression="may 2019" UniqueName="may2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2019" DataType="System.Int32" FilterControlAltText="Filter jun 2019 column"
                            HeaderText="Jun2019" ReadOnly="True" SortExpression="jun 2019" UniqueName="jun2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2019" DataType="System.Int32" FilterControlAltText="Filter jul 2019 column"
                            HeaderText="Jul2019" ReadOnly="True" SortExpression="jul 2019" UniqueName="jul2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2019" DataType="System.Int32" FilterControlAltText="Filter aug 2019 column"
                            HeaderText="Aug2019" ReadOnly="True" SortExpression="aug 2019" UniqueName="aug2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2019" DataType="System.Int32" FilterControlAltText="Filter sep 2019 column"
                            HeaderText="Sep2019" ReadOnly="True" SortExpression="sep 2019" UniqueName="sep2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2019" DataType="System.Int32" FilterControlAltText="Filter oct 2019 column"
                            HeaderText="Oct 2019" ReadOnly="True" SortExpression="oct 2019" UniqueName="oct2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2019" DataType="System.Int32" FilterControlAltText="Filter nov 2019 column"
                            HeaderText="Nov 2019" ReadOnly="True" SortExpression="nov 2019" UniqueName="nov2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2019" DataType="System.Int32" FilterControlAltText="Filter dec 2019 column"
                            HeaderText="Dec 2019" ReadOnly="True" SortExpression="dec 2019" UniqueName="dec2019"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			<telerik:GridBoundColumn DataField="jan 2020" DataType="System.Int32" FilterControlAltText="Filter jan 2020 column"
                            HeaderText="jan 2020" ReadOnly="True" SortExpression="jan 2020" UniqueName="Jan2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2020" DataType="System.Int32" FilterControlAltText="Filter feb 2020 column"
                            HeaderText="feb 2020" ReadOnly="True" SortExpression="feb 2020" UniqueName="Feb2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2020" DataType="System.Int32" FilterControlAltText="Filter mar 2020 column"
                            HeaderText="Mar 2020" ReadOnly="True" SortExpression="mar 2020" UniqueName="Mar2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2020" DataType="System.Int32" FilterControlAltText="Filter apr 2020 column"
                            HeaderText="Apr 2020" ReadOnly="True" SortExpression="apr 2020" UniqueName="apr2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2020" DataType="System.Int32" FilterControlAltText="Filter may 2020 column"
                            HeaderText="May 2020" ReadOnly="True" SortExpression="may 2020" UniqueName="may2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2020" DataType="System.Int32" FilterControlAltText="Filter jun 2020 column"
                            HeaderText="Jun2020" ReadOnly="True" SortExpression="jun 2020" UniqueName="jun2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2020" DataType="System.Int32" FilterControlAltText="Filter jul 2020 column"
                            HeaderText="Jul2020" ReadOnly="True" SortExpression="jul 2020" UniqueName="jul2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2020" DataType="System.Int32" FilterControlAltText="Filter aug 2020 column"
                            HeaderText="Aug2020" ReadOnly="True" SortExpression="aug 2020" UniqueName="aug2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2020" DataType="System.Int32" FilterControlAltText="Filter sep 2020 column"
                            HeaderText="Sep2020" ReadOnly="True" SortExpression="sep 2020" UniqueName="sep2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2020" DataType="System.Int32" FilterControlAltText="Filter oct 2020 column"
                            HeaderText="Oct 2020" ReadOnly="True" SortExpression="oct 2020" UniqueName="oct2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2020" DataType="System.Int32" FilterControlAltText="Filter nov 2020 column"
                            HeaderText="Nov 2020" ReadOnly="True" SortExpression="nov 2020" UniqueName="nov2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2020" DataType="System.Int32" FilterControlAltText="Filter dec 2020 column"
                            HeaderText="Dec 2020" ReadOnly="True" SortExpression="dec 2020" UniqueName="dec2020"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2020" DataType="System.Int32" FilterControlAltText="Filter total_2020 column"
                            HeaderText="Total 2020" ReadOnly="True" SortExpression="total_2020" UniqueName="total_2020"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


                        <telerik:GridBoundColumn DataField="total_2021" DataType="System.Int32" FilterControlAltText="Filter total_2021 column"
                            HeaderText="Total 2021" ReadOnly="True" SortExpression="total_2021" UniqueName="total_2021"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2022" DataType="System.Int32" FilterControlAltText="Filter total_2022 column"
                            HeaderText="Total 2022" ReadOnly="True" SortExpression="total_2022" UniqueName="total_2022"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
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
            <asp:SqlDataSource ID="TotalMaterialRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_total_material2" SelectCommandType="StoredProcedure"
                UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>

        </div>
    </asp:Panel>
    </form>
</body>
</html>
