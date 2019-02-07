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
                    <telerik:AjaxUpdatedControl ControlID="BasePartTimingRadGrid" />
                    <telerik:AjaxUpdatedControl ControlID="BasePartTimingRadGridDataSource" />
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
			<telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" runat="server" EnableShadow="true" DestroyOnClose="true" Modal="true" Behaviors="Close,Move" EnableViewState="false">
	</telerik:RadWindowManager>
		
            <!-- BASE PART DROP DOWN -->

            <strong>Choose Base Part:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox    ID="BasePartComboBox" 
                                    runat="server" 
                                    DataSourceID="BasePartComboBoxDataSource"
                                    DataTextField="base_part" 
                                    DataValueField="base_part" 
                                    MarkFirstMatch="true" 
                                    AutoPostBack="true">
                </telerik:RadComboBox>
            
            <asp:SqlDataSource      ID="BasePartComboBoxDataSource" 
                                    runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                                    SelectCommand="SELECT DISTINCT [BASE_PART] FROM [eeiuser].[acctg_csm_base_part_mnemonic] order by 1">
                </asp:SqlDataSource>
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
            <!-- RELEASE ID DROP DOWN -->
            
            <strong>Choose Release ID:&nbsp;&nbsp;</strong>
            <telerik:RadComboBox    ID="ReleaseIDComboBox" 
                                    runat="server" 
                                    DataSourceID="ReleaseIDComboBoxDataSource"
                                    DataTextField="release_id" 
                                    DataValueField="release_id" 
                                    MarkFirstMatch="true"
                                    AutoPostBack="true" 
                                    MaxHeight="400px" >
                </telerik:RadComboBox>
            
            <asp:SqlDataSource      ID="ReleaseIDComboBoxDataSource" 
                                    runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                                    SelectCommand="SELECT distinct([release_id]) FROM [eeiuser].[acctg_csm_naihs] order by 1 desc">
                </asp:SqlDataSource>
    
            <telerik:RadWindowManager   ID="RadWindowManager1" 
                                        runat="server" 
                                        Title="Notes" 
                                        InitialBehaviors="Minimize" 
                                        VisibleOnPageLoad="True" 
                                        Behaviors="Resize, Minimize, Maximize, Move" 
                                        Left="900px"  
                                        Top="40px" 
                                        Behavior="Resize, Minimize, Maximize, Move" 
                                        InitialBehavior="Minimize">
                <Windows>
                    <telerik:RadWindow  ID="NotesWindow" 
                                        runat="server" 
                                        Width="355px" 
                                        Height ="500px" 
                                        MinHeight="500px" 
                                        MinWidth="355px" 
                                        AutoSize="true">
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
                                AllowAutomaticUpdates="True"  >
                    
                            <MasterTableView    DataSourceID="BasePartNotesRadGridDataSource" 
                                                CommandItemDisplay="Top"
                                                CommandItemStyle-Height="40px"
                                                ShowHeader="false"
                                                TableLayout="Fixed"  >
                   
                        <CommandItemSettings    ShowRefreshButton="false"
                                                AddNewRecordText="Add Note"
                                                ShowAddNewRecordButton="true"   >
                        </CommandItemSettings> 
                    
                            <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                                                Visible="True">
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
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
            
            <!-- IHS LIFECYCLE TIMING -->
            <strong>IHS Lifecycle Timing</strong>
            <telerik:RadGrid    ID="BasePartTimingRadGrid" 
                                runat="server" 
                                DataSourceID="BasePartTimingRadGridDataSource"
                                AutoGenerateColumns="False" 
                                >
                <MasterTableView    DataSourceID="BasePartTimingRadGridDataSource" 
                                    EditMode="InPlace"
                                >

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
                        
                         <telerik:GridBoundColumn       DataField="Program" 
                                                        HeaderText="Program" 
                                                        FilterControlAltText="Filter Program column"  
                                                        SortExpression="Program" 
                                                        UniqueName="Program">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn       DataField="Brand" 
                                                        HeaderText="Brand" 
                                                        FilterControlAltText="Filter Brand column"  
                                                        SortExpression="Brand" 
                                                        UniqueName="Brand">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn       DataField="Vehicle" 
                                                        HeaderText="Vehicle" 
                                                        FilterControlAltText="Filter Vehicle column"  
                                                        SortExpression="Vehicle" 
                                                        UniqueName="Vehicle">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                         <telerik:GridBoundColumn       DataField="Assembly_Plant" 
                                                        HeaderText="Assembly Plant" 
                                                        FilterControlAltText="Filter Assembly_Plant column"  
                                                        SortExpression="Assembly_Plant" 
                                                        UniqueName="Assembly_Plant">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="CSM_SOP" 
                                                        DataFormatString="{0:d}"
                                                        HeaderText="CSM SOP" 
                                                        FilterControlAltText="Filter CSM_SOP column"  
                                                        SortExpression="CSM_SOP" 
                                                        UniqueName="CSM_SOP">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>                        
                        <telerik:GridBoundColumn        DataField="CSM_EOP" 
                                                        DataFormatString="{0:d}"
                                                        HeaderText="CSM EOP" 
                                                        FilterControlAltText="Filter CSM_EOP column"  
                                                        SortExpression="CSM_EOP" 
                                                        UniqueName="CSM_EOP">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="ChangeDate" 
                                                        DataFormatString="{0:d}"
                                                        HeaderText="CSM Change Date" 
                                                        FilterControlAltText="Filter ChangeDate column"  
                                                        SortExpression="ChangeDate" 
                                                        UniqueName="ChangeDate">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="ChangeType" 
                                                        HeaderText="Change Type" 
                                                        FilterControlAltText="Filter ChangeType column"  
                                                        SortExpression="ChangeType" 
                                                        UniqueName="ChangeType">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>                          
                        <telerik:GridBoundColumn        DataField="Exterior" 
                                                        HeaderText="Exterior" 
                                                        FilterControlAltText="Filter Exterior column"  
                                                        SortExpression="Exterior" 
                                                        UniqueName="Exterior">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Interior" 
                                                        HeaderText="Interior" 
                                                        FilterControlAltText="Filter Interior column"  
                                                        SortExpression="Interior" 
                                                        UniqueName="Interior">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Engine" 
                                                        HeaderText="Engine" 
                                                        FilterControlAltText="Filter Engine column" 
                                                        SortExpression="Engine" 
                                                        UniqueName="Engine">
                            <ColumnValidationSettings>
                                <ModelErrorMessage          Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Transmission" 
                                                        FilterControlAltText="Filter Transmission column" 
                                                        HeaderText="Transmission" 
                                                        SortExpression="Transmission" 
                                                        UniqueName="Transmission">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Chassis" 
                                                        FilterControlAltText="Filter Chassis column" 
                                                        HeaderText="Chassis" 
                                                        SortExpression="Chassis" 
                                                        UniqueName="Chassis">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Suspension" 
                                                        FilterControlAltText="Filter Suspension column" 
                                                        HeaderText="Suspension" 
                                                        SortExpression="Suspension" 
                                                        UniqueName="Suspension">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn        DataField="Location" 
                                                        FilterControlAltText="Filter Location column" 
                                                        HeaderText="Location" 
                                                        SortExpression="Location" 
                                                        UniqueName="Location">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
                        
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:SqlDataSource  ID="BasePartTimingRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.acctg_csm_sp_select_base_part_timing" 
                                SelectCommandType="StoredProcedure">

                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="BasePartComboBox"    Name="base_part"    PropertyName="SelectedValue"    Type="String" />
                    <asp:ControlParameter   ControlID="ReleaseIDComboBox"   Name="release_id"   PropertyName="SelectedValue"    Type="String" />
                </SelectParameters>
                
               
            </asp:SqlDataSource>
            
            <br />
            <br />
            
            <!-- PART ATTRIBUTES -->
            <strong>Part Attributes:</strong>
            <telerik:RadGrid    ID="BasePartAttributesRadGrid" 
                                runat="server" 
                                DataSourceID="BasePartAttributesRadGridDataSource"
                                AutoGenerateColumns="False"
                                AllowAutomaticUpdates="False" 
                                CellSpacing="0" 
                                GridLines="None" 
								OnUpdateCommand = "BasePartAttributesRadGrid_UpdateCommand"
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
			<telerik:GridBoundColumn DataField="verified_eop" 
                            FilterControlAltText="Filter verified_eop column" HeaderText="Verified EOP" SortExpression="verified_eop" UniqueName="verified_eop">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </telerik:GridBoundColumn>
			<Telerik:GridDateTimeColumn DataField="verified_eop_date" DataFormatString="{0:d}" FilterControlAltText="Filter verified_eop_date column" HeaderText="Verified EOP Date" UniqueName="verified_eop_date">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                        </Telerik:GridDateTimeColumn>

	
	                <telerik:GridBoundColumn  DataField="empire_eop_note" 
                                    HeaderText="Empire EOP Note" 
                                    FilterControlAltText="Filter empire_eop_note column" 
                                    SortExpression="empire_eop_note" 
                                    UniqueName="empire_eop_note">
                			<ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            	
                        </telerik:GridBoundColumn>

                        <Telerik:GridCheckBoxColumn DataField="include_in_forecast" DataType="System.Boolean" FilterControlAltText="Filter column column" HeaderText="Include in Forecast?" UniqueName="IncludeInForecast">
                        </Telerik:GridCheckBoxColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:SqlDataSource  ID="BasePartAttributesRadGridDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="eeiuser.acctg_csm_sp_select_base_part_attributes" 
                                SelectCommandType="StoredProcedure">

                
                <SelectParameters>
                    <asp:ControlParameter   ControlID="BasePartComboBox"    Name="base_part"    PropertyName="SelectedValue"    Type="String" />
                    <asp:ControlParameter   ControlID="ReleaseIDComboBox"   Name="release_id"   PropertyName="SelectedValue"    Type="String" />
                </SelectParameters>
                
               
            </asp:SqlDataSource>
            
            <br />

            <!-- HISTORICAL AND PLANNING DEMAND GRID -->
            
            <strong>Actual Demand:</strong>
            <telerik:RadGrid    ID="ActualDemandRadGrid" 
                                runat="server" 
                                CellSpacing="0" 
                                GridLines="None"
                                AutoGenerateColumns="False" 
                                DataSourceID="ActualDemandRadGridDataSource" >
                <MasterTableView    DataSourceID="ActualDemandRadGridDataSource" 
                                    AutoGenerateColumns="False"
                                    ShowFooter="true" 
                                    HeaderStyle-HorizontalAlign="Right" 
                                    ItemStyle-HorizontalAlign="Right"
                                    AlternatingItemStyle-HorizontalAlign="Right" 
                                    FooterStyle-HorizontalAlign="Right"
                                    HeaderStyle-Width="54">
                    <CommandItemSettings    ExportToPdfText="Export to PDF" 
                                            ShowAddNewRecordButton="true"
                                            AddNewRecordText="Click here to add a record" />
                    <RowIndicatorColumn     FilterControlAltText="Filter RowIndicator column" 
                                            Visible="True">
                        </RowIndicatorColumn>
                    <ExpandCollapseColumn   FilterControlAltText="Filter ExpandColumn column" 
                                            Visible="True">
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
                                                       
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
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

			            <telerik:GridBoundColumn DataField="total_2023" DataType="System.Decimal" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>

			            <telerik:GridBoundColumn DataField="total_2024" DataType="System.Decimal" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>

			            <telerik:GridBoundColumn DataField="total_2025" DataType="System.Decimal" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_planner_demand2018" SelectCommandType="StoredProcedure">
                
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            
            </asp:SqlDataSource>
            
            <br />

            <!-- CSM DEMAND GRID (RAW DEMAND x QTY PER x FAMILY ALLOCATION x TAKE RATE) -->
 
            <strong>Master Sales Forecast Demand:</strong>
            <telerik:RadGrid ID="CSMDemandRadGrid" runat="server" CellSpacing="0" GridLines="None"
                AutoGenerateColumns="False"  DataSourceID="CSMDemandRadGridDataSource" OnItemUpdated="CsmDemandRadGrid_ItemUpdated" >
                <MasterTableView DataSourceID="CSMDemandRadGridDataSource" DataKeyNames="base_part,mnemonicvehicleplant" AutoGenerateColumns="False"
                    ShowFooter="true" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                    AlternatingItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" HeaderStyle-Width="54" EditMode="InPlace" AllowAutomaticUpdates="true" CommandItemDisplay="Top" >
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
  
   
                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2017" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2018" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

                        <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2019" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
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

					    <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2023" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2023 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>
						
						 <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2024" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2024 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024">
                            <ColumnValidationSettings>
                                <ModelErrorMessage Text="" />
                            </ColumnValidationSettings>
                            <HeaderStyle Width="75px" />
                        </Telerik:GridBoundColumn>

						 <Telerik:GridBoundColumn Aggregate="Sum" DataField="total_2025" DataFormatString="{0:N0}" DataType="System.Decimal" FilterControlAltText="Filter total_2025 column" FooterAggregateFormatString="{0:N0}" HeaderStyle-Width="75" HeaderText="Total 2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025">
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
                SelectCommand="eeiuser.acctg_csm_sp_select_csm_demand2018" SelectCommandType="StoredProcedure" >
                
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="2013-08" Name="release_id"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>

            </asp:SqlDataSource>
            
            <br />
            
            <!-- EMPIRE FACTOR GRID -->

            <telerik:RadGrid    ID="EmpireFactorRadGrid" 
                                runat="server" 
                                CellSpacing="0" 
                                DataSourceID="EmpireFactorRadGridDataSource"
                                OnItemUpdated="EmpireFactorRadGrid_ItemUpdated"
                                GridLines="None" 
                                ShowHeader="False" >
                <MasterTableView    DataSourceID="EmpireFactorRadGridDataSource" 
                                    DataKeyNames="release_id,version,mnemonicvehicleplant" 
                                    AutoGenerateColumns="False" 
                                    AllowAutomaticUpdates="true"
                                    HeaderStyle-HorizontalAlign="Right" 
                                    ItemStyle-HorizontalAlign="Right" 
                                    AlternatingItemStyle-HorizontalAlign="Right"
                                    FooterStyle-HorizontalAlign="Right" 
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
                        
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" SortExpression="total_2017" UniqueName="total_2017" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" SortExpression="total_2018" UniqueName="total_2018" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
			            
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" SortExpression="total_2019" UniqueName="total_2019" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
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

						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Decimal" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" SortExpression="total_2023" UniqueName="total_2023" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

						<telerik:GridBoundColumn DataField="total_2024" DataType="System.Decimal" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" SortExpression="total_2024" UniqueName="total_2024" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Decimal" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" SortExpression="total_2025" UniqueName="total_2025" DataFormatString="{0:N2}"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_factor2018" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
               
            </asp:SqlDataSource>
            
            <!-- ADJUSTED CSM DEMAND (CSM RAW x EMPIRE FACTOR) -->

            <telerik:RadGrid ID="AdjustedCSMDemandRadGrid" runat="server" CellSpacing="0" DataSourceID="AdjustedCSMDemandRadGridDataSource"
                GridLines="None"  AutoGenerateColumns="False" ShowHeader="false">
                <MasterTableView DataSourceID="AdjustedCSMDemandRadGridDataSource" HeaderStyle-HorizontalAlign="Right"
                    ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" HeaderStyle-Width="54">
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

                        <telerik:GridBoundColumn DataField="Total_2017" DataType="System.Decimal" FilterControlAltText="Filter Total_2017 column"
                            HeaderText="Total_2017" ReadOnly="True" SortExpression="Total_2017" UniqueName="Total_2017"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Total_2018" DataType="System.Decimal" FilterControlAltText="Filter Total_2018 column"
                            HeaderText="Total_2018" ReadOnly="True" SortExpression="Total_2018" UniqueName="Total_2018"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
			            
                        <telerik:GridBoundColumn DataField="Total_2019" DataType="System.Decimal" FilterControlAltText="Filter Total_2019 column"
                            HeaderText="Total_2019" ReadOnly="True" SortExpression="Total_2019" UniqueName="Total_2019"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
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

						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Decimal" FilterControlAltText="Filter total_2023 column"
                            HeaderText="total_2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2024" DataType="System.Decimal" FilterControlAltText="Filter total_2024 column"
                            HeaderText="total_2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Decimal" FilterControlAltText="Filter total_2025 column"
                            HeaderText="total_2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_adjusted_csm_demand2018" SelectCommandType="StoredProcedure">
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
                                ShowHeader="False"  >
                <MasterTableView    DataSourceID="EmpireAdjustmentRadGridDataSource" 
                                    DataKeyNames="release_id,version,mnemonicvehicleplant" 
                                    AutoGenerateColumns="False" 
                                    AllowAutomaticUpdates="true"
                                    HeaderStyle-HorizontalAlign="Right" 
                                    ItemStyle-HorizontalAlign="Right" 
                                    AlternatingItemStyle-HorizontalAlign="Right"
                                    FooterStyle-HorizontalAlign="Right" 
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
                        

                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" SortExpression="total_2017" UniqueName="total_2017" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" SortExpression="total_2018" UniqueName="total_2018" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>


			
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" SortExpression="total_2019" UniqueName="total_2019" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
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
						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" SortExpression="total_2023" UniqueName="total_2023" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
						</telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" SortExpression="total_2024" UniqueName="total_2024" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" SortExpression="total_2025" UniqueName="total_2025" DataFormatString="{0:N0}"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_adjustment2018" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_empire_adjustment2018" UpdateCommandType="StoredProcedure">
                
             
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" DefaultValue="NAL0040" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" DefaultValue="2013-08" />
                </SelectParameters>

            </asp:SqlDataSource>
            
            <!-- TOTAL DEMAND (CSM RAW DEMAND x QTY PER x FAMILY ALLOCATION x TAKE RATE x EMPIRE FACTOR) +/- EMPIRE ADJUSTMENT -->

            <telerik:RadGrid ID="TotalDemandRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalDemandRadGridDataSource"
                GridLines="None" ShowHeader="false">
                <MasterTableView DataSourceID="TotalDemandRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" HeaderStyle-Width="54">
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
                        
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
    
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
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
                        <telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_demand2018" SelectCommandType="StoredProcedure"
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
                GridLines="None" ShowHeader="false">
                <MasterTableView DataSourceID="SellingPriceRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" HeaderStyle-Width="54" EditMode="InPlace" AllowAutomaticUpdates="true" >
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
                       
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017"  SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018"  SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019"  SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
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
						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023"  SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024"  SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025"  SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_selling_prices2018" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_selling_prices2018" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>                

            </asp:SqlDataSource>
            
            <!-- TOTAL REVENUE (TOTAL DEMAND x SELLING PRICE) -->

            <telerik:RadGrid ID="TotalRevenueRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalRevenueRadGridDataSource"
                GridLines="None" ShowHeader="false" >
                <MasterTableView DataSourceID="TotalRevenueRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed"  HeaderStyle-Width="54">
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
                        
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
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
					    <telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
					    <telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_revenue2018" SelectCommandType="StoredProcedure"
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
                GridLines="None" ShowHeader="false" AllowAutomaticUpdates="true">
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
                                         
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017"  SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018"  SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019"  SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
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
						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023"  SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024"  SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025"  SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_material_cost2018" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_material_cost2018" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>

            </asp:SqlDataSource>
            
            <!-- TOTAL MATERIAL (TOTAL DEMAND x MATERIAL COST) -->

            <telerik:RadGrid ID="TotalMaterialRadGrid" runat="server" CellSpacing="0" DataSourceID="TotalMaterialRadGridDataSource"
                GridLines="None" ShowHeader="false" >
                <MasterTableView DataSourceID="TotalMaterialRadGridDataSource" AutoGenerateColumns="False"
                    HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" AlternatingItemStyle-HorizontalAlign="Right"
                    FooterStyle-HorizontalAlign="Right" HeaderStyle-Width="54" TableLayout="Fixed">
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
                        
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                  
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
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
						<telerik:GridBoundColumn DataField="total_2023" DataType="System.Int32" FilterControlAltText="Filter total_2023 column"
                            HeaderText="Total 2023" ReadOnly="True" SortExpression="total_2023" UniqueName="total_2023"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2024" DataType="System.Int32" FilterControlAltText="Filter total_2024 column"
                            HeaderText="Total 2024" ReadOnly="True" SortExpression="total_2024" UniqueName="total_2024"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
						<telerik:GridBoundColumn DataField="total_2025" DataType="System.Int32" FilterControlAltText="Filter total_2025 column"
                            HeaderText="Total 2025" ReadOnly="True" SortExpression="total_2025" UniqueName="total_2025"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_material2018" SelectCommandType="StoredProcedure"
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
