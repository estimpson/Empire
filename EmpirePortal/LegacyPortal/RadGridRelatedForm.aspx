<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RadGridRelatedForm.aspx.cs"
    Inherits="RadGridRelatedForm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
.RadInput_Default{font:12px "segoe ui",arial,sans-serif}.RadInput{vertical-align:middle}
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
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server" Width =100% Height=100%>
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
                AutoPostBack="true" MaxHeight="400">
            </telerik:RadComboBox>

            <asp:SqlDataSource ID="ReleaseIDComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="SELECT distinct([release_id]) FROM [eeiuser].[acctg_csm_naihs] order by 1 desc">
            </asp:SqlDataSource>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" 
                Text="Include in Forecast?" TextAlign="Left" Font-Bold="true" />
            &nbsp;&nbsp;                
             <telerik:RadWindowManager ID="RadWindowManager1" runat="server" 
                Title="Notes" InitialBehaviors="Minimize" VisibleOnPageLoad="true" 
                Behaviors="Minimize,Move,Resize,Maximize" Left="900"  Top="40">
                <Windows>
                    <telerik:RadWindow ID="NotesWindow" runat="server" Width="355px" Height ="500px" MinHeight="500px" MinWidth="355px" AutoSize="true">
                    <ContentTemplate>
              <telerik:RadGrid    ID="BasePartNotesRadGrid" 
                                runat="server" 
                                DataSourceID="BasePartNotesRadGridDataSource" 
                                AutoGenerateColumns="False" 
                                CellSpacing="0" 
                                GridLines="None"
                                ShowHeader=false 
                                Height="500px"
                                Width="355px" 
                                AllowAutomaticDeletes="True" 
                                AllowAutomaticInserts="True" 
                                AllowAutomaticUpdates="True"
                             
                                 >
                    
                    <MasterTableView    DataSourceID="BasePartNotesRadGridDataSource" 
                                        CommandItemDisplay="Top"
                                        CommandItemStyle-Height=40px
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
                                        BackColor="Transparent" BorderStyle="None" Height="40px" LabelWidth="75px" 
                                        
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
            <strong>Part Detail:</strong><telerik:RadGrid ID="BasePartAttributesRadGrid" 
                runat="server" AllowAutomaticUpdates="True" 
                CellSpacing="0" DataSourceID="BasePartAttributesRadGridDataSource" 
                GridLines="None" AutoGenerateColumns="False">
                <MasterTableView 
                    DataSourceID="BasePartAttributesRadGridDataSource">
                    <CommandItemSettings ExportToPdfText="Export to PDF" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" 
                        Visible="True">
                        <HeaderStyle Width="20px" />
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" 
                        Visible="True">
                        <HeaderStyle Width="20px" />
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridEditCommandColumn FilterControlAltText="Filter EditCommandColumn column">
                        </telerik:GridEditCommandColumn>
                        <telerik:GridBoundColumn DataField="family" 
                            FilterControlAltText="Filter family column" HeaderText="family" 
                            SortExpression="family" UniqueName="family">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="customer" 
                            FilterControlAltText="Filter customer column" HeaderText="customer" 
                            SortExpression="customer" UniqueName="customer">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="parent_customer" 
                            FilterControlAltText="Filter parent_customer column" 
                            HeaderText="parent_customer" SortExpression="parent_customer" 
                            UniqueName="parent_customer">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="product_line" 
                            FilterControlAltText="Filter product_line column" HeaderText="product_line" 
                            SortExpression="product_line" UniqueName="product_line">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_segment" 
                            FilterControlAltText="Filter empire_market_segment column" 
                            HeaderText="empire_market_segment" SortExpression="empire_market_segment" 
                            UniqueName="empire_market_segment">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_market_subsegment" 
                            FilterControlAltText="Filter empire_market_subsegment column" 
                            HeaderText="empire_market_subsegment" SortExpression="empire_market_subsegment" 
                            UniqueName="empire_market_subsegment">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_application" 
                            FilterControlAltText="Filter empire_application column" 
                            HeaderText="empire_application" SortExpression="empire_application" 
                            UniqueName="empire_application">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_sop" DataType="System.DateTime" 
                            FilterControlAltText="Filter empire_sop column" HeaderText="empire_sop" 
                            SortExpression="empire_sop" UniqueName="empire_sop">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="empire_eop" DataType="System.DateTime" 
                            FilterControlAltText="Filter empire_eop column" HeaderText="empire_eop" 
                            SortExpression="empire_eop" UniqueName="empire_eop">
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
            <asp:SqlDataSource ID="BasePartAttributesRadGridDataSource" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                SelectCommand="SELECT [family], [customer], [parent_customer], [product_line], [empire_market_segment], [empire_market_subsegment], [empire_application], [empire_sop], [empire_eop] FROM [eeiuser].[acctg_csm_base_part_attributes] WHERE (([base_part] = @base_part) AND ([release_id] = @release_id))">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="" 
                        Name="base_part" PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" 
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <br />
            <!-- BASE PART TO MNEMONIC ASSOCIATION GRID -->&nbsp;<!-- HISTORICAL AND PLANNING DEMAND GRID --><strong>Actual 
            Demand:</strong>
            <br />
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
                        <telerik:GridBoundColumn DataField="Jan 2012" DataType="System.Decimal" FilterControlAltText="Filter Jan 2012 column"
                            HeaderText="Jan 2012" ReadOnly="True" SortExpression="Jan 2012" 
                            UniqueName="Jan2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2012" DataType="System.Decimal" FilterControlAltText="Filter Feb 2012 column"
                            HeaderText="Feb 2012" ReadOnly="True" SortExpression="Feb 2012" 
                            UniqueName="Feb2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2012" DataType="System.Decimal" FilterControlAltText="Filter Mar 2012 column"
                            HeaderText="Mar 2012" ReadOnly="True" SortExpression="Mar 2012" 
                            UniqueName="Mar2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2012" DataType="System.Decimal" FilterControlAltText="Filter Apr 2012 column"
                            HeaderText="Apr 2012" ReadOnly="True" SortExpression="Apr 2012" 
                            UniqueName="Apr2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2012" DataType="System.Decimal" FilterControlAltText="Filter May 2012 column"
                            HeaderText="May 2012" ReadOnly="True" SortExpression="May 2012" 
                            UniqueName="May2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2012" DataType="System.Decimal" FilterControlAltText="Filter Jun 2012 column"
                            HeaderText="Jun 2012" ReadOnly="True" SortExpression="Jun 2012" 
                            UniqueName="Jun2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2012" DataType="System.Decimal" FilterControlAltText="Filter Jul 2012 column"
                            HeaderText="Jul 2012" ReadOnly="True" SortExpression="Jul 2012" 
                            UniqueName="Jul2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2012" DataType="System.Decimal" FilterControlAltText="Filter Aug 2012 column"
                            HeaderText="Aug 2012" ReadOnly="True" SortExpression="Aug 2012" 
                            UniqueName="Aug2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2012" DataType="System.Decimal" FilterControlAltText="Filter Sep 2012 column"
                            HeaderText="Sep 2012" ReadOnly="True" SortExpression="Sep 2012" 
                            UniqueName="Sep2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2012" DataType="System.Decimal" FilterControlAltText="Filter Oct 2012 column"
                            HeaderText="Oct 2012" ReadOnly="True" SortExpression="Oct 2012" 
                            UniqueName="Oct2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2012" DataType="System.Decimal" FilterControlAltText="Filter Nov 2012 column"
                            HeaderText="Nov 2012" ReadOnly="True" SortExpression="Nov 2012" 
                            UniqueName="Nov2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2012" DataType="System.Decimal" FilterControlAltText="Filter Dec 2012 column"
                            HeaderText="Dec 2012" ReadOnly="True" SortExpression="Dec 2012" 
                            UniqueName="Dec2012" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Decimal" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" ReadOnly="True" SortExpression="total_2012" UniqueName="total_2012"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jan 2013" DataType="System.Decimal" FilterControlAltText="Filter Jan 2013 column"
                            HeaderText="Jan 2013" ReadOnly="True" SortExpression="Jan 2013" 
                            UniqueName="Jan2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2013" DataType="System.Decimal" FilterControlAltText="Filter Feb 2013 column"
                            HeaderText="Feb 2013" ReadOnly="True" SortExpression="Feb 2013" 
                            UniqueName="Feb2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2013" DataType="System.Decimal" FilterControlAltText="Filter Mar 2013 column"
                            HeaderText="Mar 2013" ReadOnly="True" SortExpression="Mar 2013" 
                            UniqueName="Mar2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2013" DataType="System.Decimal" FilterControlAltText="Filter Apr 2013 column"
                            HeaderText="Apr 2013" ReadOnly="True" SortExpression="Apr 2013" 
                            UniqueName="Apr2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2013" DataType="System.Decimal" FilterControlAltText="Filter May 2013 column"
                            HeaderText="May 2013" ReadOnly="True" SortExpression="May 2013" 
                            UniqueName="May2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2013" DataType="System.Decimal" FilterControlAltText="Filter Jun 2013 column"
                            HeaderText="Jun 2013" ReadOnly="True" SortExpression="Jun 2013" 
                            UniqueName="Jun2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2013" DataType="System.Decimal" FilterControlAltText="Filter Jul 2013 column"
                            HeaderText="Jul 2013" ReadOnly="True" SortExpression="Jul 2013" 
                            UniqueName="Jul2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2013" DataType="System.Decimal" FilterControlAltText="Filter Aug 2013 column"
                            HeaderText="Aug 2013" ReadOnly="True" SortExpression="Aug 2013" 
                            UniqueName="Aug2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2013" DataType="System.Decimal" FilterControlAltText="Filter Sep 2013 column"
                            HeaderText="Sep 2013" ReadOnly="True" SortExpression="Sep 2013" 
                            UniqueName="Sep2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2013" DataType="System.Decimal" FilterControlAltText="Filter Oct 2013 column"
                            HeaderText="Oct 2013" ReadOnly="True" SortExpression="Oct 2013" 
                            UniqueName="Oct2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2013" DataType="System.Decimal" FilterControlAltText="Filter Nov 2013 column"
                            HeaderText="Nov 2013" ReadOnly="True" SortExpression="Nov 2013" 
                            UniqueName="Nov2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2013" DataType="System.Decimal" FilterControlAltText="Filter Dec 2013 column"
                            HeaderText="Dec 2013" ReadOnly="True" SortExpression="Dec 2013" 
                            UniqueName="Dec2013" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Decimal" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" ReadOnly="True" SortExpression="total_2013" UniqueName="total_2013"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jan 2014" DataType="System.Decimal" FilterControlAltText="Filter Jan 2014 column"
                            HeaderText="Jan 2014" ReadOnly="True" SortExpression="Jan 2014" 
                            UniqueName="Jan2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2014" DataType="System.Decimal" FilterControlAltText="Filter Feb 2014 column"
                            HeaderText="Feb 2014" ReadOnly="True" SortExpression="Feb 2014" 
                            UniqueName="Feb2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2014" DataType="System.Decimal" FilterControlAltText="Filter Mar 2014 column"
                            HeaderText="Mar 2014" ReadOnly="True" SortExpression="Mar 2014" 
                            UniqueName="Mar2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2014" DataType="System.Decimal" FilterControlAltText="Filter Apr 2014 column"
                            HeaderText="Apr 2014" ReadOnly="True" SortExpression="Apr 2014" 
                            UniqueName="Apr2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2014" DataType="System.Decimal" FilterControlAltText="Filter May 2014 column"
                            HeaderText="May 2014" ReadOnly="True" SortExpression="May 2014" 
                            UniqueName="May2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2014" DataType="System.Decimal" FilterControlAltText="Filter Jun 2014 column"
                            HeaderText="Jun 2014" ReadOnly="True" SortExpression="Jun 2014" 
                            UniqueName="Jun2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2014" DataType="System.Decimal" FilterControlAltText="Filter Jul 2014 column"
                            HeaderText="Jul 2014" ReadOnly="True" SortExpression="Jul 2014" 
                            UniqueName="Jul2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug 2014" DataType="System.Decimal" FilterControlAltText="Filter Aug 2014 column"
                            HeaderText="Aug 2014" ReadOnly="True" SortExpression="Aug 2014" 
                            UniqueName="Aug2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep 2014" DataType="System.Decimal" FilterControlAltText="Filter Sep 2014 column"
                            HeaderText="Sep 2014" ReadOnly="True" SortExpression="Sep 2014" 
                            UniqueName="Sep2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct 2014" DataType="System.Decimal" FilterControlAltText="Filter Oct 2014 column"
                            HeaderText="Oct 2014" ReadOnly="True" SortExpression="Oct 2014" 
                            UniqueName="Oct2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov 2014" DataType="System.Decimal" FilterControlAltText="Filter Nov 2014 column"
                            HeaderText="Nov 2014" ReadOnly="True" SortExpression="Nov 2014" 
                            UniqueName="Nov2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec 2014" DataType="System.Decimal" FilterControlAltText="Filter Dec 2014 column"
                            HeaderText="Dec 2014" ReadOnly="True" SortExpression="Dec 2014" 
                            UniqueName="Dec2014" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Decimal" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" ReadOnly="True" SortExpression="total_2014" UniqueName="total_2014"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Int32" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Int32" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            HeaderStyle-Width="75" Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Int32" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_planner_demand_3yr_dw" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
<!-- CSM DEMAND GRID (RAW DEMAND x QTY PER x FAMILY ALLOCATION x TAKE RATE) -->
            <strong>Master Sales Forecast Demand:</strong>
            <br />
            <telerik:RadGrid ID="CSMDemandRadGrid" runat="server" CellSpacing="0" GridLines="None"
                AutoGenerateColumns="False" DataSourceID="CSMDemandRadGridDataSource" Width="3600">
                <MasterTableView DataSourceID="CSMDemandRadGridDataSource" AutoGenerateColumns="False"
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
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="base_part" FilterControlAltText="Filter base_part column"
                            HeaderText="Base Part" ReadOnly="True" SortExpression="base_part" UniqueName="base_part"
                            HeaderStyle-Width="75" Display="False">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="version" FilterControlAltText="Filter version column"
                            HeaderText="Version" SortExpression="version" UniqueName="version" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="release_id" FilterControlAltText="Filter release_id column"
                            HeaderText="Release ID" SortExpression="release_id" UniqueName="release_id" HeaderStyle-Width="75"
                            Display="False">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mnemonic-Vehicle/Plant" FilterControlAltText="Filter Mnemonic-Vehicle/Plant column"
                            HeaderText="Mnemonic Vehicle/Plant" SortExpression="Mnemonic-Vehicle/Plant" UniqueName="Mnemonic-Vehicle/Plant"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="platform" FilterControlAltText="Filter platform column"
                            HeaderText="Platform" SortExpression="platform" UniqueName="platform" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column"
                            HeaderText="Program" SortExpression="program" UniqueName="program" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="vehicle" FilterControlAltText="Filter vehicle column"
                            HeaderText="Vehicle" ReadOnly="True" SortExpression="vehicle" UniqueName="vehicle"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="plant" FilterControlAltText="Filter plant column"
                            HeaderText="Plant" SortExpression="plant" UniqueName="plant" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sop" DataType="System.DateTime" FilterControlAltText="Filter sop column"
                            HeaderText="SOP" SortExpression="sop" UniqueName="sop" DataFormatString="{0:d}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="eop" DataType="System.DateTime" FilterControlAltText="Filter eop column"
                            HeaderText="EOP" SortExpression="eop" UniqueName="eop" DataFormatString="{0:d}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_per" DataType="System.Decimal" FilterControlAltText="Filter qty_per column"
                            HeaderText="Qty Per" ReadOnly="True" SortExpression="qty_per" UniqueName="qty_per"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="take_rate" DataType="System.Decimal" FilterControlAltText="Filter take_rate column"
                            HeaderText="Take Rate" ReadOnly="True" SortExpression="take_rate" UniqueName="take_rate"
                            DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="family_allocation" DataType="System.Decimal"
                            FilterControlAltText="Filter family_allocation column" HeaderText="Family Allocation"
                            ReadOnly="True" SortExpression="family_allocation" UniqueName="family_allocation"
                            DataFormatString="{0:N2}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jan 2012" DataType="System.Decimal" FilterControlAltText="Filter Jan 2012 column"
                            HeaderText="Jan 2012" ReadOnly="True" SortExpression="Jan 2012" UniqueName="Jan2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb 2012" DataType="System.Decimal" FilterControlAltText="Filter Feb 2012 column"
                            HeaderText="Feb 2012" ReadOnly="True" SortExpression="Feb 2012" UniqueName="Feb2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar 2012" DataType="System.Decimal" FilterControlAltText="Filter Mar 2012 column"
                            HeaderText="Mar 2012" ReadOnly="True" SortExpression="Mar 2012" UniqueName="Mar2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr 2012" DataType="System.Decimal" FilterControlAltText="Filter Apr 2012 column"
                            HeaderText="Apr 2012" ReadOnly="True" SortExpression="Apr 2012" UniqueName="Apr2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May 2012" DataType="System.Decimal" FilterControlAltText="Filter May 2012 column"
                            HeaderText="May 2012" ReadOnly="True" SortExpression="May 2012" UniqueName="May2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun 2012" DataType="System.Decimal" FilterControlAltText="Filter Jun 2012 column"
                            HeaderText="Jun 2012" ReadOnly="True" SortExpression="Jun 2012" UniqueName="Jun2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul 2012" DataType="System.Decimal" FilterControlAltText="Filter Jul 2012 column"
                            HeaderText="Jul   2012" ReadOnly="True" SortExpression="Jul 2012" UniqueName="Jul2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2012" DataType="System.Decimal" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug 2012" ReadOnly="True" SortExpression="aug 2012" UniqueName="aug2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2012" DataType="System.Decimal" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep 2012" ReadOnly="True" SortExpression="sep 2012" UniqueName="sep2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2012" DataType="System.Decimal" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct 2012" ReadOnly="True" SortExpression="oct 2012" UniqueName="oct2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2012" DataType="System.Decimal" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov 2012" ReadOnly="True" SortExpression="nov 2012" UniqueName="nov2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2012" DataType="System.Decimal" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec 2012" ReadOnly="True" SortExpression="dec 2012" UniqueName="dec2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Decimal" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" ReadOnly="True" SortExpression="total_2012" UniqueName="total_2012"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan 2013" DataType="System.Decimal" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan 2013" ReadOnly="True" SortExpression="jan 2013" UniqueName="jan2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2013" DataType="System.Decimal" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb 2013" ReadOnly="True" SortExpression="feb 2013" UniqueName="feb2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2013" DataType="System.Decimal" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar 2013" ReadOnly="True" SortExpression="mar 2013" UniqueName="mar2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2013" DataType="System.Decimal" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr 2013" ReadOnly="True" SortExpression="apr 2013" UniqueName="apr2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2013" DataType="System.Decimal" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May 2013" ReadOnly="True" SortExpression="may 2013" UniqueName="may2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2013" DataType="System.Decimal" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun 2013" ReadOnly="True" SortExpression="jun 2013" UniqueName="jun2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2013" DataType="System.Decimal" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul 2013" ReadOnly="True" SortExpression="jul 2013" UniqueName="jul2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2013" DataType="System.Decimal" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug 2013" ReadOnly="True" SortExpression="aug 2013" UniqueName="aug2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2013" DataType="System.Decimal" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep 2013" ReadOnly="True" SortExpression="sep 2013" UniqueName="sep2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2013" DataType="System.Decimal" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct 2013" ReadOnly="True" SortExpression="oct 2013" UniqueName="oct2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2013" DataType="System.Decimal" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov 2013" ReadOnly="True" SortExpression="nov 2013" UniqueName="nov2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2013" DataType="System.Decimal" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec 2013" ReadOnly="True" SortExpression="dec 2013" UniqueName="dec2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Decimal" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" ReadOnly="True" SortExpression="total_2013" UniqueName="total_2013"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan 2014" DataType="System.Decimal" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014" ReadOnly="True" SortExpression="jan 2014" UniqueName="jan2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2014" DataType="System.Decimal" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="Feb 2014" ReadOnly="True" SortExpression="feb 2014" UniqueName="feb2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2014" DataType="System.Decimal" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014" ReadOnly="True" SortExpression="mar 2014" UniqueName="mar2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2014" DataType="System.Decimal" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014" ReadOnly="True" SortExpression="apr 2014" UniqueName="apr2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2014" DataType="System.Decimal" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014" ReadOnly="True" SortExpression="may 2014" UniqueName="may2014"
                            DataFormatString="{0:N0}" Aggregate="Sum" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2014" DataType="System.Decimal" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun 2014" ReadOnly="True" SortExpression="jun 2014" UniqueName="jun2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2014" DataType="System.Decimal" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul 2014" ReadOnly="True" SortExpression="jul 2014" UniqueName="jul2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2014" DataType="System.Decimal" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug 2014" ReadOnly="True" SortExpression="aug 2014" UniqueName="aug2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2014" DataType="System.Decimal" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep 2014" ReadOnly="True" SortExpression="sep 2014" UniqueName="sep2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2014" DataType="System.Decimal" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014" ReadOnly="True" SortExpression="oct 2014" UniqueName="oct2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2014" DataType="System.Decimal" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014" ReadOnly="True" SortExpression="nov 2014" UniqueName="nov2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2014" DataType="System.Decimal" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014" ReadOnly="True" SortExpression="dec 2014" UniqueName="dec2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Decimal" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" ReadOnly="True" SortExpression="total_2014" UniqueName="total_2014"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="Total 2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="Total 2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="Total 2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
                            Aggregate="Sum" DataFormatString="{0:N0}" FooterAggregateFormatString="{0:N0}"
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
            <asp:SqlDataSource ID="CSMDemandRadGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="eeiuser.acctg_csm_sp_select_demand_9yr_dw" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="2012-08" Name="release_id"
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
                            HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="platform" FilterControlAltText="Filter platform column"
                            HeaderText="platform" SortExpression="platform" UniqueName="platform" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column"
                            HeaderText="program" SortExpression="program" UniqueName="program" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="vehicle" FilterControlAltText="Filter vehicle column"
                            HeaderText="vehicle" ReadOnly="True" SortExpression="vehicle" UniqueName="vehicle"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="plant" FilterControlAltText="Filter plant column"
                            HeaderText="plant" SortExpression="plant" UniqueName="plant" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sop" DataType="System.DateTime" FilterControlAltText="Filter sop column"
                            HeaderText="sop" SortExpression="sop" UniqueName="sop" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="eop" DataType="System.DateTime" FilterControlAltText="Filter eop column"
                            HeaderText="eop" SortExpression="eop" UniqueName="eop" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_per" DataType="System.Decimal" FilterControlAltText="Filter qty_per column"
                            HeaderText="qty_per" ReadOnly="True" SortExpression="qty_per" UniqueName="qty_per"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="take_rate" DataType="System.Decimal" FilterControlAltText="Filter take_rate column"
                            HeaderText="take_rate" ReadOnly="True" SortExpression="take_rate" UniqueName="take_rate"
                            DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="family_allocation" DataType="System.Decimal"
                            FilterControlAltText="Filter family_allocation column" HeaderText="family_allocation"
                            ReadOnly="True" SortExpression="family_allocation" UniqueName="family_allocation"
                            DataFormatString="{0:N2}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2012" DataType="System.Decimal" FilterControlAltText="Filter jan 2012 column"
                            HeaderText="Jan2012" SortExpression="jan2012" UniqueName="jan2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2012" DataType="System.Decimal" FilterControlAltText="Filter feb 2012 column"
                            HeaderText="Feb2012" SortExpression="feb2012" UniqueName="feb2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2012" DataType="System.Decimal" FilterControlAltText="Filter mar 2012 column"
                            HeaderText="Mar2012" SortExpression="mar2012" UniqueName="mar2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2012" DataType="System.Decimal" FilterControlAltText="Filter apr 2012 column"
                            HeaderText="Apr2012" SortExpression="apr2012" UniqueName="apr2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2012" DataType="System.Decimal" FilterControlAltText="Filter may 2012 column"
                            HeaderText="May2012" SortExpression="may2012" UniqueName="may2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2012" DataType="System.Decimal" FilterControlAltText="Filter jun 2012 column"
                            HeaderText="Jun2012" SortExpression="jun2012" UniqueName="jun2012" DataFormatString="{0:N2}" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2012" DataType="System.Decimal" FilterControlAltText="Filter jul 2012 column"
                            HeaderText="Jul2012" SortExpression="jul2012" UniqueName="jul2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2012" DataType="System.Decimal" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug2012" SortExpression="aug2012" UniqueName="aug2012" DataFormatString="{0:N2}" >
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2012" DataType="System.Decimal" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep2012" SortExpression="sep2012" UniqueName="sep2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2012" DataType="System.Decimal" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct2012" SortExpression="oct2012" UniqueName="oct2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2012" DataType="System.Decimal" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov2012" SortExpression="nov2012" UniqueName="nov2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2012" DataType="System.Decimal" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec2012" SortExpression="dec2012" UniqueName="dec2012" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Decimal" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" SortExpression="total_2012" UniqueName="total_2012" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2013" DataType="System.Decimal" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan2013" SortExpression="jan2013" UniqueName="jan2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2013" DataType="System.Decimal" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb2013" SortExpression="feb2013" UniqueName="feb2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2013" DataType="System.Decimal" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar2013" SortExpression="mar2013" UniqueName="mar2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2013" DataType="System.Decimal" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr2013" SortExpression="apr2013" UniqueName="apr2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2013" DataType="System.Decimal" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May2013" SortExpression="may2013" UniqueName="may2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2013" DataType="System.Decimal" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun2013" SortExpression="jun2013" UniqueName="jun2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2013" DataType="System.Decimal" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul2013" SortExpression="jul2013" UniqueName="jul2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2013" DataType="System.Decimal" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug2013" SortExpression="aug2013" UniqueName="aug2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2013" DataType="System.Decimal" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep2013" SortExpression="sep2013" UniqueName="sep2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2013" DataType="System.Decimal" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct2013" SortExpression="oct2013" UniqueName="oct2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2013" DataType="System.Decimal" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov2013" SortExpression="nov2013" UniqueName="nov2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2013" DataType="System.Decimal" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec2013" SortExpression="dec2013" UniqueName="dec2013" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Decimal" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" SortExpression="total_2013" UniqueName="total_2013" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2014" DataType="System.Decimal" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014" SortExpression="jan2014" UniqueName="Jan2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2014" DataType="System.Decimal" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="feb 2014" SortExpression="feb2014" UniqueName="Feb2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2014" DataType="System.Decimal" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014" SortExpression="mar2014" UniqueName="Mar2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2014" DataType="System.Decimal" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014" SortExpression="apr2014" UniqueName="apr2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2014" DataType="System.Decimal" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014" SortExpression="may2014" UniqueName="may2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2014" DataType="System.Decimal" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun 2014" SortExpression="jun2014" UniqueName="jun2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2014" DataType="System.Decimal" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul 2014" SortExpression="jul2014" UniqueName="jul2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2014" DataType="System.Decimal" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug 2014" SortExpression="aug2014" UniqueName="aug2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2014" DataType="System.Decimal" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep 2014" SortExpression="sep2014" UniqueName="sep2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2014" DataType="System.Decimal" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014" SortExpression="oct2014" UniqueName="oct2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2014" DataType="System.Decimal" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014" SortExpression="nov2014" UniqueName="nov2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2014" DataType="System.Decimal" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014" SortExpression="dec2014" UniqueName="dec2014" DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Decimal" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" SortExpression="total_2014" UniqueName="total_2014" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" SortExpression="total_2015" UniqueName="total_2015" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" SortExpression="total_2016" UniqueName="total_2016" DataFormatString="{0:N2}"
                            HeaderStyle-Width="75">
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
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_factor_dw" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_empire_factor_dw" UpdateCommandType="StoredProcedure">
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
                    <asp:Parameter Name="platform" Type="String" />
                    <asp:Parameter Name="program" Type="String" />
                    <asp:Parameter Name="vehicle" Type="String" />
                    <asp:Parameter Name="plant" Type="String" />
                    <asp:Parameter Name="SOP" Type="DateTime" />
                    <asp:Parameter Name="EOP" Type="DateTime" />
                    <asp:Parameter Name="Qty_per" Type="Decimal" />
                    <asp:Parameter Name="Take_rate" Type="Decimal" />
                    <asp:Parameter Name="Family_allocation" Type="Decimal" />
                    <asp:Parameter Name="Jan2012" Type="Decimal" />
                    <asp:Parameter Name="Feb2012" Type="Decimal" />
                    <asp:Parameter Name="Mar2012" Type="Decimal" />
                    <asp:Parameter Name="Apr2012" Type="Decimal" />
                    <asp:Parameter Name="May2012" Type="Decimal" />
                    <asp:Parameter Name="Jun2012" Type="Decimal" />
                    <asp:Parameter Name="Jul2012" Type="Decimal" />
                    <asp:Parameter Name="Aug2012" Type="Decimal" />
                    <asp:Parameter Name="Sep2012" Type="Decimal" />
                    <asp:Parameter Name="Oct2012" Type="Decimal" />
                    <asp:Parameter Name="Nov2012" Type="Decimal" />
                    <asp:Parameter Name="Dec2012" Type="Decimal" />
                    <asp:Parameter Name="Total_2012" Type="Decimal" />
                    <asp:Parameter Name="Jan2013" Type="Decimal" />
                    <asp:Parameter Name="Feb2013" Type="Decimal" />
                    <asp:Parameter Name="Mar2013" Type="Decimal" />
                    <asp:Parameter Name="Apr2013" Type="Decimal" />
                    <asp:Parameter Name="May2013" Type="Decimal" />
                    <asp:Parameter Name="Jun2013" Type="Decimal" />
                    <asp:Parameter Name="Jul2013" Type="Decimal" />
                    <asp:Parameter Name="Aug2013" Type="Decimal" />
                    <asp:Parameter Name="Sep2013" Type="Decimal" />
                    <asp:Parameter Name="Oct2013" Type="Decimal" />
                    <asp:Parameter Name="Nov2013" Type="Decimal" />
                    <asp:Parameter Name="Dec2013" Type="Decimal" />
                    <asp:Parameter Name="Total_2013" Type="Decimal" />
                    <asp:Parameter Name="Jan2014" Type="Decimal" />
                    <asp:Parameter Name="Feb2014" Type="Decimal" />
                    <asp:Parameter Name="Mar2014" Type="Decimal" />
                    <asp:Parameter Name="Apr2014" Type="Decimal" />
                    <asp:Parameter Name="May2014" Type="Decimal" />
                    <asp:Parameter Name="Jun2014" Type="Decimal" />
                    <asp:Parameter Name="Jul2014" Type="Decimal" />
                    <asp:Parameter Name="Aug2014" Type="Decimal" />
                    <asp:Parameter Name="Sep2014" Type="Decimal" />
                    <asp:Parameter Name="Oct2014" Type="Decimal" />
                    <asp:Parameter Name="Nov2014" Type="Decimal" />
                    <asp:Parameter Name="Dec2014" Type="Decimal" />
                    <asp:Parameter Name="Total_2014" Type="Decimal" />
                    <asp:Parameter Name="Total_2015" Type="Decimal" />
                    <asp:Parameter Name="Total_2016" Type="Decimal" />
                    <asp:Parameter Name="Total_2017" Type="Decimal" />
                    <asp:Parameter Name="Total_2018" Type="Decimal" />
                    <asp:Parameter Name="Total_2019" Type="Decimal" />
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
                        <telerik:GridBoundColumn DataField="Jan2012" FilterControlAltText="Filter Jan2012 column"
                            HeaderText="Jan2012" SortExpression="Jan2012" UniqueName="Jan2012" DataType="System.Decimal"
                            DataFormatString="{0:N0}" ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2012" FilterControlAltText="Filter Feb2012 column"
                            HeaderText="Feb2012" SortExpression="Feb2012" UniqueName="Feb2012" DataType="System.Decimal"
                            DataFormatString="{0:N0}" ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2012" FilterControlAltText="Filter Mar2012 column"
                            HeaderText="Mar2012" SortExpression="Mar2012" UniqueName="Mar2012" DataType="System.Decimal"
                            DataFormatString="{0:N0}" ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2012" FilterControlAltText="Filter Apr2012 column"
                            HeaderText="Apr2012" SortExpression="Apr2012" UniqueName="Apr2012" DataType="System.Decimal"
                            DataFormatString="{0:N0}" ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2012" FilterControlAltText="Filter May2012 column"
                            HeaderText="May2012" ReadOnly="True" SortExpression="May2012" UniqueName="May2012"
                            DataType="System.Decimal" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2012" FilterControlAltText="Filter Jun2012 column"
                            HeaderText="Jun2012" SortExpression="Jun2012" UniqueName="Jun2012" DataType="System.Decimal"
                            DataFormatString="{0:N0}" ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2012" DataType="System.Decimal" FilterControlAltText="Filter Jul2012 column"
                            HeaderText="Jul2012" SortExpression="Jul2012" UniqueName="Jul2012" DataFormatString="{0:N0}"
                            ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2012" DataType="System.Decimal" FilterControlAltText="Filter Aug2012 column"
                            HeaderText="Aug2012" SortExpression="Aug2012" UniqueName="Aug2012" DataFormatString="{0:N0}"
                            ReadOnly="True">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2012" DataType="System.Decimal" FilterControlAltText="Filter Sep2012 column"
                            HeaderText="Sep2012" ReadOnly="True" SortExpression="Sep2012" UniqueName="Sep2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2012" DataType="System.Decimal" FilterControlAltText="Filter Oct2012 column"
                            HeaderText="Oct2012" ReadOnly="True" SortExpression="Oct2012" UniqueName="Oct2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2012" DataType="System.Decimal" FilterControlAltText="Filter Nov2012 column"
                            HeaderText="Nov2012" ReadOnly="True" SortExpression="Nov2012" UniqueName="Nov2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2012" DataType="System.Decimal" FilterControlAltText="Filter Dec2012 column"
                            HeaderText="Dec2012" ReadOnly="True" SortExpression="Dec2012" UniqueName="Dec2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2012" DataType="System.Decimal" FilterControlAltText="Filter Total_2012 column"
                            HeaderText="Total_2012" ReadOnly="True" SortExpression="Total_2012" UniqueName="Total_2012"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jan2013" DataType="System.Decimal" FilterControlAltText="Filter Jan2013 column"
                            HeaderText="Jan2013" ReadOnly="True" SortExpression="Jan2013" UniqueName="Jan2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2013" DataType="System.Decimal" FilterControlAltText="Filter Feb2013 column"
                            HeaderText="Feb2013" ReadOnly="True" SortExpression="Feb2013" UniqueName="Feb2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2013" DataType="System.Decimal" FilterControlAltText="Filter Mar2013 column"
                            HeaderText="Mar2013" ReadOnly="True" SortExpression="Mar2013" UniqueName="Mar2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2013" DataType="System.Decimal" FilterControlAltText="Filter Apr2013 column"
                            HeaderText="Apr2013" ReadOnly="True" SortExpression="Apr2013" UniqueName="Apr2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2013" DataType="System.Decimal" FilterControlAltText="Filter May2013 column"
                            HeaderText="May2013" ReadOnly="True" SortExpression="May2013" UniqueName="May2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2013" DataType="System.Decimal" FilterControlAltText="Filter Jun2013 column"
                            HeaderText="Jun2013" ReadOnly="True" SortExpression="Jun2013" UniqueName="Jun2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2013" DataType="System.Decimal" FilterControlAltText="Filter Jul2013 column"
                            HeaderText="Jul2013" ReadOnly="True" SortExpression="Jul2013" UniqueName="Jul2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2013" DataType="System.Decimal" FilterControlAltText="Filter Aug2013 column"
                            HeaderText="Aug2013" ReadOnly="True" SortExpression="Aug2013" UniqueName="Aug2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2013" DataType="System.Decimal" FilterControlAltText="Filter Sep2013 column"
                            HeaderText="Sep2013" ReadOnly="True" SortExpression="Sep2013" UniqueName="Sep2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2013" DataType="System.Decimal" FilterControlAltText="Filter Oct2013 column"
                            HeaderText="Oct2013" ReadOnly="True" SortExpression="Oct2013" UniqueName="Oct2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2013" DataType="System.Decimal" FilterControlAltText="Filter Nov2013 column"
                            HeaderText="Nov2013" ReadOnly="True" SortExpression="Nov2013" UniqueName="Nov2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2013" DataType="System.Decimal" FilterControlAltText="Filter Dec2013 column"
                            HeaderText="Dec2013" ReadOnly="True" SortExpression="Dec2013" UniqueName="Dec2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2013" DataType="System.Decimal" FilterControlAltText="Filter Total_2013 column"
                            HeaderText="Total_2013" ReadOnly="True" SortExpression="Total_2013" UniqueName="Total_2013"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jan2014" DataType="System.Decimal" FilterControlAltText="Filter Jan2014 column"
                            HeaderText="Jan2014" ReadOnly="True" SortExpression="Jan2014" UniqueName="Jan2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Feb2014" DataType="System.Decimal" FilterControlAltText="Filter Feb2014 column"
                            HeaderText="Feb2014" ReadOnly="True" SortExpression="Feb2014" UniqueName="Feb2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Mar2014" DataType="System.Decimal" FilterControlAltText="Filter Mar2014 column"
                            HeaderText="Mar2014" ReadOnly="True" SortExpression="Mar2014" UniqueName="Mar2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Apr2014" DataType="System.Decimal" FilterControlAltText="Filter Apr2014 column"
                            HeaderText="Apr2014" ReadOnly="True" SortExpression="Apr2014" UniqueName="Apr2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="May2014" DataType="System.Decimal" FilterControlAltText="Filter May2014 column"
                            HeaderText="May2014" ReadOnly="True" SortExpression="May2014" UniqueName="May2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jun2014" DataType="System.Decimal" FilterControlAltText="Filter Jun2014 column"
                            HeaderText="Jun2014" ReadOnly="True" SortExpression="Jun2014" UniqueName="Jun2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Jul2014" DataType="System.Decimal" FilterControlAltText="Filter Jul2014 column"
                            HeaderText="Jul2014" ReadOnly="True" SortExpression="Jul2014" UniqueName="Jul2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Aug2014" DataType="System.Decimal" FilterControlAltText="Filter Aug2014 column"
                            HeaderText="Aug2014" ReadOnly="True" SortExpression="Aug2014" UniqueName="Aug2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Sep2014" DataType="System.Decimal" FilterControlAltText="Filter Sep2014 column"
                            HeaderText="Sep2014" ReadOnly="True" SortExpression="Sep2014" UniqueName="Sep2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Oct2014" DataType="System.Decimal" FilterControlAltText="Filter Oct2014 column"
                            HeaderText="Oct2014" ReadOnly="True" SortExpression="Oct2014" UniqueName="Oct2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Nov2014" DataType="System.Decimal" FilterControlAltText="Filter Nov2014 column"
                            HeaderText="Nov2014" ReadOnly="True" SortExpression="Nov2014" UniqueName="Nov2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Dec2014" DataType="System.Decimal" FilterControlAltText="Filter Dec2014 column"
                            HeaderText="Dec2014" ReadOnly="True" SortExpression="Dec2014" UniqueName="Dec2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Total_2014" DataType="System.Decimal" FilterControlAltText="Filter Total_2014 column"
                            HeaderText="Total_2014" ReadOnly="True" SortExpression="Total_2014" UniqueName="Total_2014"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Decimal" FilterControlAltText="Filter total_2015 column"
                            HeaderText="total_2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Decimal" FilterControlAltText="Filter total_2016 column"
                            HeaderText="total_2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2017" DataType="System.Decimal" FilterControlAltText="Filter total_2017 column"
                            HeaderText="total_2017" ReadOnly="True" SortExpression="total_2017" UniqueName="total_2017"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2018" DataType="System.Decimal" FilterControlAltText="Filter total_2018 column"
                            HeaderText="total_2018" ReadOnly="True" SortExpression="total_2018" UniqueName="total_2018"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2019" DataType="System.Decimal" FilterControlAltText="Filter total_2019 column"
                            HeaderText="total_2019" ReadOnly="True" SortExpression="total_2019" UniqueName="total_2019"
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
                SelectCommand="eeiuser.acctg_csm_sp_select_adjusted_csm_demand_dw" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" DefaultValue="NAL0040" Name="base_part"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" DefaultValue="2012-08" Name="release_id"
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
                            HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="platform" FilterControlAltText="Filter platform column"
                            HeaderText="platform" SortExpression="platform" UniqueName="platform" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column"
                            HeaderText="program" SortExpression="program" UniqueName="program" HeaderStyle-Width="75" ForceExtractValue="Always">
                        </telerik:GridBoundColumn >
                        <telerik:GridBoundColumn DataField="vehicle" FilterControlAltText="Filter vehicle column"
                            HeaderText="vehicle" ReadOnly="True" SortExpression="vehicle" UniqueName="vehicle"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="plant" FilterControlAltText="Filter plant column"
                            HeaderText="plant" SortExpression="plant" UniqueName="plant" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sop" DataType="System.DateTime" FilterControlAltText="Filter sop column"
                            HeaderText="sop" SortExpression="sop" UniqueName="sop" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="eop" DataType="System.DateTime" FilterControlAltText="Filter eop column"
                            HeaderText="eop" SortExpression="eop" UniqueName="eop" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="qty_per" DataType="System.Decimal" FilterControlAltText="Filter qty_per column"
                            HeaderText="qty_per" ReadOnly="True" SortExpression="qty_per" UniqueName="qty_per"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="take_rate" DataType="System.Decimal" FilterControlAltText="Filter take_rate column"
                            HeaderText="take_rate" ReadOnly="True" SortExpression="take_rate" UniqueName="take_rate"
                            DataFormatString="{0:N2}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="family_allocation" DataType="System.Decimal"
                            FilterControlAltText="Filter family_allocation column" HeaderText="family_allocation"
                            ReadOnly="True" SortExpression="family_allocation" UniqueName="family_allocation"
                            DataFormatString="{0:N2}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2012" DataType="System.Int32" FilterControlAltText="Filter jan 2012 column"
                            HeaderText="Jan2012" SortExpression="jan2012" UniqueName="jan2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2012" DataType="System.Int32" FilterControlAltText="Filter feb 2012 column"
                            HeaderText="Feb2012" SortExpression="feb2012" UniqueName="feb2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2012" DataType="System.Int32" FilterControlAltText="Filter mar 2012 column"
                            HeaderText="Mar2012" SortExpression="mar2012" UniqueName="mar2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2012" DataType="System.Int32" FilterControlAltText="Filter apr 2012 column"
                            HeaderText="Apr2012" SortExpression="apr2012" UniqueName="apr2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2012" DataType="System.Int32" FilterControlAltText="Filter may 2012 column"
                            HeaderText="May2012" SortExpression="may2012" UniqueName="may2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2012" DataType="System.Int32" FilterControlAltText="Filter jun 2012 column"
                            HeaderText="Jun2012" SortExpression="jun2012" UniqueName="jun2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2012" DataType="System.Int32" FilterControlAltText="Filter jul 2012 column"
                            HeaderText="Jul2012" SortExpression="jul2012" UniqueName="jul2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2012" DataType="System.Int32" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug2012" SortExpression="aug2012" UniqueName="aug2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2012" DataType="System.Int32" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep2012" SortExpression="sep2012" UniqueName="sep2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2012" DataType="System.Int32" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct2012" SortExpression="oct2012" UniqueName="oct2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2012" DataType="System.Int32" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov2012" SortExpression="nov2012" UniqueName="nov2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2012" DataType="System.Int32" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec2012" SortExpression="dec2012" UniqueName="dec2012" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Int32" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" SortExpression="total_2012" UniqueName="total_2012" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2013" DataType="System.Int32" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan2013" SortExpression="jan2013" UniqueName="jan2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2013" DataType="System.Int32" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb2013" SortExpression="feb2013" UniqueName="feb2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2013" DataType="System.Int32" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar2013" SortExpression="mar2013" UniqueName="mar2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2013" DataType="System.Int32" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr2013" SortExpression="apr2013" UniqueName="apr2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2013" DataType="System.Int32" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May2013" SortExpression="may2013" UniqueName="may2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2013" DataType="System.Int32" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun2013" SortExpression="jun2013" UniqueName="jun2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2013" DataType="System.Int32" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul2013" SortExpression="jul2013" UniqueName="jul2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2013" DataType="System.Int32" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug2013" SortExpression="aug2013" UniqueName="aug2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2013" DataType="System.Int32" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep2013" SortExpression="sep2013" UniqueName="sep2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2013" DataType="System.Int32" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct2013" SortExpression="oct2013" UniqueName="oct2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2013" DataType="System.Int32" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov2013" SortExpression="nov2013" UniqueName="nov2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2013" DataType="System.Int32" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec2013" SortExpression="dec2013" UniqueName="dec2013" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Int32" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" SortExpression="total_2013" UniqueName="total_2013" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2014" DataType="System.Int32" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014" SortExpression="jan2014" UniqueName="Jan2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2014" DataType="System.Int32" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="feb 2014" SortExpression="feb2014" UniqueName="Feb2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2014" DataType="System.Int32" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014" SortExpression="mar2014" UniqueName="Mar2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2014" DataType="System.Int32" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014" SortExpression="apr2014" UniqueName="apr2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2014" DataType="System.Int32" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014" SortExpression="may2014" UniqueName="may2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2014" DataType="System.Int32" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun 2014" SortExpression="jun2014" UniqueName="jun2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2014" DataType="System.Int32" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul 2014" SortExpression="jul2014" UniqueName="jul2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2014" DataType="System.Int32" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug 2014" SortExpression="aug2014" UniqueName="aug2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2014" DataType="System.Int32" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep 2014" SortExpression="sep2014" UniqueName="sep2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2014" DataType="System.Int32" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014" SortExpression="oct2014" UniqueName="oct2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2014" DataType="System.Int32" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014" SortExpression="nov2014" UniqueName="nov2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2014" DataType="System.Int32" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014" SortExpression="dec2014" UniqueName="dec2014" DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Int32" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" SortExpression="total_2014" UniqueName="total_2014" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" SortExpression="total_2015" UniqueName="total_2015" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" SortExpression="total_2016" UniqueName="total_2016" DataFormatString="{0:N0}"
                            HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
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
                SelectCommand="eeiuser.acctg_csm_sp_select_empire_adjustment_dw" SelectCommandType="StoredProcedure"
                UpdateCommand="eeiuser.acctg_csm_sp_update_empire_adjustment_dw" UpdateCommandType="StoredProcedure">
                
             
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" DefaultValue="NAL0040" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" DefaultValue="2012-08" />
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
                    <asp:Parameter Name="Jan2012" Type="Decimal" />
                    <asp:Parameter Name="Feb2012" Type="Decimal" />
                    <asp:Parameter Name="Mar2012" Type="Decimal" />
                    <asp:Parameter Name="Apr2012" Type="Decimal" />
                    <asp:Parameter Name="May2012" Type="Decimal" />
                    <asp:Parameter Name="Jun2012" Type="Decimal" />
                    <asp:Parameter Name="Jul2012" Type="Decimal" />
                    <asp:Parameter Name="Aug2012" Type="Decimal" />
                    <asp:Parameter Name="Sep2012" Type="Decimal" />
                    <asp:Parameter Name="Oct2012" Type="Decimal" />
                    <asp:Parameter Name="Nov2012" Type="Decimal" />
                    <asp:Parameter Name="Dec2012" Type="Decimal" />
                    <asp:Parameter Name="Total_2012" Type="Decimal" />
                    <asp:Parameter Name="Jan2013" Type="Decimal" />
                    <asp:Parameter Name="Feb2013" Type="Decimal" />
                    <asp:Parameter Name="Mar2013" Type="Decimal" />
                    <asp:Parameter Name="Apr2013" Type="Decimal" />
                    <asp:Parameter Name="May2013" Type="Decimal" />
                    <asp:Parameter Name="Jun2013" Type="Decimal" />
                    <asp:Parameter Name="Jul2013" Type="Decimal" />
                    <asp:Parameter Name="Aug2013" Type="Decimal" />
                    <asp:Parameter Name="Sep2013" Type="Decimal" />
                    <asp:Parameter Name="Oct2013" Type="Decimal" />
                    <asp:Parameter Name="Nov2013" Type="Decimal" />
                    <asp:Parameter Name="Dec2013" Type="Decimal" />
                    <asp:Parameter Name="Total_2013" Type="Decimal" />
                    <asp:Parameter Name="Jan2014" Type="Decimal" />
                    <asp:Parameter Name="Feb2014" Type="Decimal" />
                    <asp:Parameter Name="Mar2014" Type="Decimal" />
                    <asp:Parameter Name="Apr2014" Type="Decimal" />
                    <asp:Parameter Name="May2014" Type="Decimal" />
                    <asp:Parameter Name="Jun2014" Type="Decimal" />
                    <asp:Parameter Name="Jul2014" Type="Decimal" />
                    <asp:Parameter Name="Aug2014" Type="Decimal" />
                    <asp:Parameter Name="Sep2014" Type="Decimal" />
                    <asp:Parameter Name="Oct2014" Type="Decimal" />
                    <asp:Parameter Name="Nov2014" Type="Decimal" />
                    <asp:Parameter Name="Dec2014" Type="Decimal" />
                    <asp:Parameter Name="Total_2014" Type="Decimal" />
                    <asp:Parameter Name="Total_2015" Type="Decimal" />
                    <asp:Parameter Name="Total_2016" Type="Decimal" />
                    <asp:Parameter Name="Total_2017" Type="Decimal" />
                    <asp:Parameter Name="Total_2018" Type="Decimal" />
                    <asp:Parameter Name="Total_2019" Type="Decimal" />
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
                        <telerik:GridBoundColumn DataField="jan2012" DataType="System.Int32" FilterControlAltText="Filter jan 2012 column"
                            HeaderText="Jan 2012" ReadOnly="True" SortExpression="jan 2012" UniqueName="jan2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2012" DataType="System.Int32" FilterControlAltText="Filter feb 2012 column"
                            HeaderText="Feb 2012" ReadOnly="True" SortExpression="feb 2012" UniqueName="feb2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2012" DataType="System.Int32" FilterControlAltText="Filter mar 2012 column"
                            HeaderText="Mar 2012" ReadOnly="True" SortExpression="mar 2012" UniqueName="mar2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2012" DataType="System.Int32" FilterControlAltText="Filter apr 2012 column"
                            HeaderText="Apr 2012" ReadOnly="True" SortExpression="apr 2012" UniqueName="apr2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2012" DataType="System.Int32" FilterControlAltText="Filter may 2012 column"
                            HeaderText="May 2012" ReadOnly="True" SortExpression="may 2012" UniqueName="may2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2012" DataType="System.Int32" FilterControlAltText="Filter jun 2012 column"
                            HeaderText="Jun 2012" ReadOnly="True" SortExpression="jun 2012" UniqueName="jun2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2012" DataType="System.Int32" FilterControlAltText="Filter jul 2012 column"
                            HeaderText="Jul 2012" ReadOnly="True" SortExpression="jul 2012" UniqueName="jul2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2012" DataType="System.Int32" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug 2012" ReadOnly="True" SortExpression="aug 2012" UniqueName="aug2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2012" DataType="System.Int32" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep 2012" ReadOnly="True" SortExpression="sep 2012" UniqueName="sep2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2012" DataType="System.Int32" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct 2012" ReadOnly="True" SortExpression="oct 2012" UniqueName="oct2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2012" DataType="System.Int32" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov 2012" ReadOnly="True" SortExpression="nov 2012" UniqueName="nov2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2012" DataType="System.Int32" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec 2012" ReadOnly="True" SortExpression="dec 2012" UniqueName="dec2012"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Int32" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" ReadOnly="True" SortExpression="total_2012" UniqueName="total_2012"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2013" DataType="System.Int32" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan 2013" ReadOnly="True" SortExpression="jan 2013" UniqueName="jan2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2013" DataType="System.Int32" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb 2013" ReadOnly="True" SortExpression="feb 2013" UniqueName="feb2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2013" DataType="System.Int32" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar 2013" ReadOnly="True" SortExpression="mar 2013" UniqueName="mar2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2013" DataType="System.Int32" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr 2013" ReadOnly="True" SortExpression="apr 2013" UniqueName="apr2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2013" DataType="System.Int32" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May 2013" ReadOnly="True" SortExpression="may 2013" UniqueName="may2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2013" DataType="System.Int32" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun 2013" ReadOnly="True" SortExpression="jun 2013" UniqueName="jun2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2013" DataType="System.Int32" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul 2013" ReadOnly="True" SortExpression="jul 2013" UniqueName="jul2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2013" DataType="System.Int32" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug 2013" ReadOnly="True" SortExpression="aug 2013" UniqueName="aug2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2013" DataType="System.Int32" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep 2013" ReadOnly="True" SortExpression="sep 2013" UniqueName="sep2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2013" DataType="System.Int32" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct 2013" ReadOnly="True" SortExpression="oct 2013" UniqueName="oct2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2013" DataType="System.Int32" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov 2013" ReadOnly="True" SortExpression="nov 2013" UniqueName="nov2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2013" DataType="System.Int32" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec 2013" ReadOnly="True" SortExpression="dec 2013" UniqueName="dec2013"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Int32" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" ReadOnly="True" SortExpression="total_2013" UniqueName="total_2013"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2014" DataType="System.Int32" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014" ReadOnly="True" SortExpression="jan 2014" UniqueName="Jan2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2014" DataType="System.Int32" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="feb 2014" ReadOnly="True" SortExpression="feb 2014" UniqueName="Feb2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2014" DataType="System.Int32" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014" ReadOnly="True" SortExpression="mar 2014" UniqueName="Mar2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2014" DataType="System.Int32" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014" ReadOnly="True" SortExpression="apr 2014" UniqueName="apr2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2014" DataType="System.Int32" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014" ReadOnly="True" SortExpression="may 2014" UniqueName="may2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2014" DataType="System.Int32" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun2014" ReadOnly="True" SortExpression="jun 2014" UniqueName="jun2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2014" DataType="System.Int32" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul2014" ReadOnly="True" SortExpression="jul 2014" UniqueName="jul2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2014" DataType="System.Int32" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug2014" ReadOnly="True" SortExpression="aug 2014" UniqueName="aug2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2014" DataType="System.Int32" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep2014" ReadOnly="True" SortExpression="sep 2014" UniqueName="sep2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2014" DataType="System.Int32" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014" ReadOnly="True" SortExpression="oct 2014" UniqueName="oct2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2014" DataType="System.Int32" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014" ReadOnly="True" SortExpression="nov 2014" UniqueName="nov2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2014" DataType="System.Int32" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014" ReadOnly="True" SortExpression="dec 2014" UniqueName="dec2014"
                            DataFormatString="{0:N0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Int32" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" ReadOnly="True" SortExpression="total_2014" UniqueName="total_2014"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:N0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_demand_9yr_dw" SelectCommandType="StoredProcedure"
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
                    FooterStyle-HorizontalAlign="Right" TableLayout="Fixed" HeaderStyle-Width="54">
                    <CommandItemSettings AddNewRecordText="Click here to add a record" ExportToPdfText="Export to PDF"
                        ShowAddNewRecordButton="true" />
                    <RowIndicatorColumn FilterControlAltText="Filter RowIndicator column" Visible="True">
                    </RowIndicatorColumn>
                    <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column" Visible="True">
                    </ExpandCollapseColumn>
                    <Columns>
                        <telerik:GridTemplateColumn HeaderStyle-Width="75">
                        </telerik:GridTemplateColumn>
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
                        <telerik:GridBoundColumn DataField="jan2012" DataType="System.Int32" FilterControlAltText="Filter jan 2012 column"
                            HeaderText="Jan 2012"  SortExpression="jan 2012" UniqueName="jan2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2012" DataType="System.Int32" FilterControlAltText="Filter feb 2012 column"
                            HeaderText="Feb 2012"  SortExpression="feb 2012" UniqueName="feb2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2012" DataType="System.Int32" FilterControlAltText="Filter mar 2012 column"
                            HeaderText="Mar 2012"  SortExpression="mar 2012" UniqueName="mar2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2012" DataType="System.Int32" FilterControlAltText="Filter apr 2012 column"
                            HeaderText="Apr 2012"  SortExpression="apr 2012" UniqueName="apr2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2012" DataType="System.Int32" FilterControlAltText="Filter may 2012 column"
                            HeaderText="May 2012"  SortExpression="may 2012" UniqueName="may2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2012" DataType="System.Int32" FilterControlAltText="Filter jun 2012 column"
                            HeaderText="Jun 2012"  SortExpression="jun 2012" UniqueName="jun2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2012" DataType="System.Int32" FilterControlAltText="Filter jul 2012 column"
                            HeaderText="Jul 2012"  SortExpression="jul 2012" UniqueName="jul2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2012" DataType="System.Int32" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug 2012"  SortExpression="aug 2012" UniqueName="aug2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2012" DataType="System.Int32" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep 2012"  SortExpression="sep 2012" UniqueName="sep2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2012" DataType="System.Int32" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct 2012"  SortExpression="oct 2012" UniqueName="oct2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2012" DataType="System.Int32" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov 2012"  SortExpression="nov 2012" UniqueName="nov2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2012" DataType="System.Int32" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec 2012"  SortExpression="dec 2012" UniqueName="dec2012"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Int32" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012"  SortExpression="total_2012" UniqueName="total_2012"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2013" DataType="System.Int32" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan 2013"  SortExpression="jan 2013" UniqueName="jan2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2013" DataType="System.Int32" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb 2013"  SortExpression="feb 2013" UniqueName="feb2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2013" DataType="System.Int32" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar 2013"  SortExpression="mar 2013" UniqueName="mar2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2013" DataType="System.Int32" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr 2013"  SortExpression="apr 2013" UniqueName="apr2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2013" DataType="System.Int32" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May 2013"  SortExpression="may 2013" UniqueName="may2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2013" DataType="System.Int32" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun 2013"  SortExpression="jun 2013" UniqueName="jun2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2013" DataType="System.Int32" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul 2013"  SortExpression="jul 2013" UniqueName="jul2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2013" DataType="System.Int32" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug 2013"  SortExpression="aug 2013" UniqueName="aug2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2013" DataType="System.Int32" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep 2013"  SortExpression="sep 2013" UniqueName="sep2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2013" DataType="System.Int32" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct 2013"  SortExpression="oct 2013" UniqueName="oct2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2013" DataType="System.Int32" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov 2013"  SortExpression="nov 2013" UniqueName="nov2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2013" DataType="System.Int32" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec 2013"  SortExpression="dec 2013" UniqueName="dec2013"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Int32" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013"  SortExpression="total_2013" UniqueName="total_2013"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan2014" DataType="System.Int32" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014"  SortExpression="jan 2014" UniqueName="Jan2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb2014" DataType="System.Int32" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="feb 2014"  SortExpression="feb 2014" UniqueName="Feb2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar2014" DataType="System.Int32" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014"  SortExpression="mar 2014" UniqueName="Mar2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr2014" DataType="System.Int32" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014"  SortExpression="apr 2014" UniqueName="apr2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may2014" DataType="System.Int32" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014"  SortExpression="may 2014" UniqueName="may2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun2014" DataType="System.Int32" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun2014"  SortExpression="jun 2014" UniqueName="jun2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul2014" DataType="System.Int32" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul2014"  SortExpression="jul 2014" UniqueName="jul2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug2014" DataType="System.Int32" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug2014"  SortExpression="aug 2014" UniqueName="aug2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep2014" DataType="System.Int32" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep2014"  SortExpression="sep 2014" UniqueName="sep2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct2014" DataType="System.Int32" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014"  SortExpression="oct 2014" UniqueName="oct2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov2014" DataType="System.Int32" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014"  SortExpression="nov 2014" UniqueName="nov2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec2014" DataType="System.Int32" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014"  SortExpression="dec 2014" UniqueName="dec2014"
                            DataFormatString="{0:C4}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Int32" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014"  SortExpression="total_2014" UniqueName="total_2014"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015"  SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016"  SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C4}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
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
                SelectCommand="eeiuser.acctg_csm_sp_select_selling_prices_9yr_dw" SelectCommandType="StoredProcedure"
                UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="BasePartComboBox" Name="base_part" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="ReleaseIDComboBox" Name="release_id" PropertyName="SelectedValue"
                        Type="String" />
                </SelectParameters>
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
                        <telerik:GridBoundColumn DataField="jan 2012" DataType="System.Int32" FilterControlAltText="Filter jan 2012 column"
                            HeaderText="Jan 2012" ReadOnly="True" SortExpression="jan 2012" UniqueName="jan2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2012" DataType="System.Int32" FilterControlAltText="Filter feb 2012 column"
                            HeaderText="Feb 2012" ReadOnly="True" SortExpression="feb 2012" UniqueName="feb2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2012" DataType="System.Int32" FilterControlAltText="Filter mar 2012 column"
                            HeaderText="Mar 2012" ReadOnly="True" SortExpression="mar 2012" UniqueName="mar2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2012" DataType="System.Int32" FilterControlAltText="Filter apr 2012 column"
                            HeaderText="Apr 2012" ReadOnly="True" SortExpression="apr 2012" UniqueName="apr2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2012" DataType="System.Int32" FilterControlAltText="Filter may 2012 column"
                            HeaderText="May 2012" ReadOnly="True" SortExpression="may 2012" UniqueName="may2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2012" DataType="System.Int32" FilterControlAltText="Filter jun 2012 column"
                            HeaderText="Jun 2012" ReadOnly="True" SortExpression="jun 2012" UniqueName="jun2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2012" DataType="System.Int32" FilterControlAltText="Filter jul 2012 column"
                            HeaderText="Jul 2012" ReadOnly="True" SortExpression="jul 2012" UniqueName="jul2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2012" DataType="System.Int32" FilterControlAltText="Filter aug 2012 column"
                            HeaderText="Aug 2012" ReadOnly="True" SortExpression="aug 2012" UniqueName="aug2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2012" DataType="System.Int32" FilterControlAltText="Filter sep 2012 column"
                            HeaderText="Sep 2012" ReadOnly="True" SortExpression="sep 2012" UniqueName="sep2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2012" DataType="System.Int32" FilterControlAltText="Filter oct 2012 column"
                            HeaderText="Oct 2012" ReadOnly="True" SortExpression="oct 2012" UniqueName="oct2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2012" DataType="System.Int32" FilterControlAltText="Filter nov 2012 column"
                            HeaderText="Nov 2012" ReadOnly="True" SortExpression="nov 2012" UniqueName="nov2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2012" DataType="System.Int32" FilterControlAltText="Filter dec 2012 column"
                            HeaderText="Dec 2012" ReadOnly="True" SortExpression="dec 2012" UniqueName="dec2012"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2012" DataType="System.Int32" FilterControlAltText="Filter total_2012 column"
                            HeaderText="Total 2012" ReadOnly="True" SortExpression="total_2012" UniqueName="total_2012"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan 2013" DataType="System.Int32" FilterControlAltText="Filter jan 2013 column"
                            HeaderText="Jan 2013" ReadOnly="True" SortExpression="jan 2013" UniqueName="jan2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2013" DataType="System.Int32" FilterControlAltText="Filter feb 2013 column"
                            HeaderText="Feb 2013" ReadOnly="True" SortExpression="feb 2013" UniqueName="feb2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2013" DataType="System.Int32" FilterControlAltText="Filter mar 2013 column"
                            HeaderText="Mar 2013" ReadOnly="True" SortExpression="mar 2013" UniqueName="mar2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2013" DataType="System.Int32" FilterControlAltText="Filter apr 2013 column"
                            HeaderText="Apr 2013" ReadOnly="True" SortExpression="apr 2013" UniqueName="apr2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2013" DataType="System.Int32" FilterControlAltText="Filter may 2013 column"
                            HeaderText="May 2013" ReadOnly="True" SortExpression="may 2013" UniqueName="may2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2013" DataType="System.Int32" FilterControlAltText="Filter jun 2013 column"
                            HeaderText="Jun 2013" ReadOnly="True" SortExpression="jun 2013" UniqueName="jun2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2013" DataType="System.Int32" FilterControlAltText="Filter jul 2013 column"
                            HeaderText="Jul 2013" ReadOnly="True" SortExpression="jul 2013" UniqueName="jul2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2013" DataType="System.Int32" FilterControlAltText="Filter aug 2013 column"
                            HeaderText="Aug 2013" ReadOnly="True" SortExpression="aug 2013" UniqueName="aug2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2013" DataType="System.Int32" FilterControlAltText="Filter sep 2013 column"
                            HeaderText="Sep 2013" ReadOnly="True" SortExpression="sep 2013" UniqueName="sep2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2013" DataType="System.Int32" FilterControlAltText="Filter oct 2013 column"
                            HeaderText="Oct 2013" ReadOnly="True" SortExpression="oct 2013" UniqueName="oct2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2013" DataType="System.Int32" FilterControlAltText="Filter nov 2013 column"
                            HeaderText="Nov 2013" ReadOnly="True" SortExpression="nov 2013" UniqueName="nov2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2013" DataType="System.Int32" FilterControlAltText="Filter dec 2013 column"
                            HeaderText="Dec 2013" ReadOnly="True" SortExpression="dec 2013" UniqueName="dec2013"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2013" DataType="System.Int32" FilterControlAltText="Filter total_2013 column"
                            HeaderText="Total 2013" ReadOnly="True" SortExpression="total_2013" UniqueName="total_2013"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jan 2014" DataType="System.Int32" FilterControlAltText="Filter jan 2014 column"
                            HeaderText="jan 2014" ReadOnly="True" SortExpression="jan 2014" UniqueName="Jan2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="feb 2014" DataType="System.Int32" FilterControlAltText="Filter feb 2014 column"
                            HeaderText="feb 2014" ReadOnly="True" SortExpression="feb 2014" UniqueName="Feb2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mar 2014" DataType="System.Int32" FilterControlAltText="Filter mar 2014 column"
                            HeaderText="Mar 2014" ReadOnly="True" SortExpression="mar 2014" UniqueName="Mar2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="apr 2014" DataType="System.Int32" FilterControlAltText="Filter apr 2014 column"
                            HeaderText="Apr 2014" ReadOnly="True" SortExpression="apr 2014" UniqueName="apr2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="may 2014" DataType="System.Int32" FilterControlAltText="Filter may 2014 column"
                            HeaderText="May 2014" ReadOnly="True" SortExpression="may 2014" UniqueName="may2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jun 2014" DataType="System.Int32" FilterControlAltText="Filter jun 2014 column"
                            HeaderText="Jun2014" ReadOnly="True" SortExpression="jun 2014" UniqueName="jun2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="jul 2014" DataType="System.Int32" FilterControlAltText="Filter jul 2014 column"
                            HeaderText="Jul2014" ReadOnly="True" SortExpression="jul 2014" UniqueName="jul2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="aug 2014" DataType="System.Int32" FilterControlAltText="Filter aug 2014 column"
                            HeaderText="Aug2014" ReadOnly="True" SortExpression="aug 2014" UniqueName="aug2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="sep 2014" DataType="System.Int32" FilterControlAltText="Filter sep 2014 column"
                            HeaderText="Sep2014" ReadOnly="True" SortExpression="sep 2014" UniqueName="sep2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="oct 2014" DataType="System.Int32" FilterControlAltText="Filter oct 2014 column"
                            HeaderText="Oct 2014" ReadOnly="True" SortExpression="oct 2014" UniqueName="oct2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="nov 2014" DataType="System.Int32" FilterControlAltText="Filter nov 2014 column"
                            HeaderText="Nov 2014" ReadOnly="True" SortExpression="nov 2014" UniqueName="nov2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="dec 2014" DataType="System.Int32" FilterControlAltText="Filter dec 2014 column"
                            HeaderText="Dec 2014" ReadOnly="True" SortExpression="dec 2014" UniqueName="dec2014"
                            DataFormatString="{0:C0}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2014" DataType="System.Int32" FilterControlAltText="Filter total_2014 column"
                            HeaderText="Total 2014" ReadOnly="True" SortExpression="total_2014" UniqueName="total_2014"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2015" DataType="System.Int32" FilterControlAltText="Filter total_2015 column"
                            HeaderText="Total 2015" ReadOnly="True" SortExpression="total_2015" UniqueName="total_2015"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="total_2016" DataType="System.Int32" FilterControlAltText="Filter total_2016 column"
                            HeaderText="Total 2016" ReadOnly="True" SortExpression="total_2016" UniqueName="total_2016"
                            DataFormatString="{0:C0}" HeaderStyle-Width="75">
                        </telerik:GridBoundColumn>
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
                SelectCommand="eeiuser.acctg_csm_sp_select_total_revenue_dw" SelectCommandType="StoredProcedure"
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
