<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="BudgetSummary.aspx.cs" Inherits="TestMaster" Title="Budget Summary" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <%--Framework scripts--%>
            <asp:ScriptReference Name="MsAjaxBundle" />
            <asp:ScriptReference Name="jquery" />
            <asp:ScriptReference Name="jquery.ui.combined" />
            <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
            <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
            <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
            <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
            <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
            <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
            <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
            <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
            <asp:ScriptReference Name="WebFormsBundle" />
            <%--Site scripts--%>
        </Scripts>
    </asp:ScriptManager>

    <telerik:RadAjaxManager
        ID="RadAjaxManager1" runat="server" EnableViewState="True" DefaultLoadingPanelID="RadAjaxLoadingPanel1" Visible="true" UpdatePanelsRenderMode="Inline">
        
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBox1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBox2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBox3">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>           
            <telerik:AjaxSetting AjaxControlID="RadComboBox4">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>        
    <telerik:RadAjaxLoadingPanel id="RadAjaxLoadingPanel1" Runat="server" height="75px" width="75px">
            <img alt="Loading..." src="../images/loading3.gif" style="border: 0px;" width="67" height="17" />
        </telerik:RadAjaxLoadingPanel>
    &nbsp; &nbsp;
    <telerik:RadComboBox ID="RadComboBox4" runat="server" AutoPostBack="True" Width="85px" MarkFirstMatch="True" style="left: 750px; position: absolute; top: 144px; z-index: 101;" ExpandDelay="50">
        <CollapseAnimation Duration="200" Type="OutQuint" />
    <Items>
    <telerik:RadComboBoxItem Value="All" Text="All" />
    <telerik:RadComboBoxItem Value="11" Text="EEI" />
    <telerik:RadComboBoxItem Value="12" Text="EEH" />
    <telerik:RadComboBoxItem Value="21" Text="ESE" />
    <telerik:RadComboBoxItem Value="60" Text="EEC" />
    </Items>
    </telerik:RadComboBox> 
    <telerik:RadComboBox ID="RadComboBox1" runat="server" AutoPostBack="True" DataTextField = "month_part" DataValueField = "month_part" Width="111px" MarkFirstMatch="True" DataSourceID="SqlDataSource1" style="left: 889px; position: absolute; top: 144px; z-index: 102;" ExpandDelay="50">
        <CollapseAnimation Duration="200" Type="OutQuint" />
    </telerik:RadComboBox>
    &nbsp;
    <telerik:RadComboBox ID="RadComboBox2" runat="server" AutoPostBack="True" DataTextField = "month_name" DataValueField = "month_no" Width="131px" MarkFirstMatch="True" DataSourceID="SqlDataSource2" style="left: 1003px; position: absolute; top: 144px; z-index: 103;">
        <CollapseAnimation Duration="200" Type="OutQuint" />
    </telerik:RadComboBox>
    &nbsp;
    <telerik:RadComboBox ID="RadComboBox3" runat="server" AutoPostBack="True" DataTextField = "fiscal_year" DataValueField = "fiscal_year" Width="85px" MarkFirstMatch="True" DataSourceID="SqlDataSource3" style="left: 1138px; position: absolute; top: 144px; z-index: 104;" ExpandDelay="50">
        <CollapseAnimation Duration="200" Type="OutQuint" />
    </telerik:RadComboBox> 
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" 
            SelectCommand="select 'MTD' as month_part union select '1H' as month_part union select '2H' as month_part">
    </asp:SqlDataSource>
        
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
            SelectCommand="select 1 as month_no, 'January' as month_name union select 2 as month_no, 'February' as month_name union select 3 as month_no, 'March' as month_name union select 4 as month_no, 'April' as month_name union select 5 as month_no, 'May' as month_name union select 6 as month_no, 'June' as month_name union select 7 as month_no, 'July' as month_name union select 8 as month_no, 'August' as month_name union select 9 as month_no, 'September' as month_name union select 10 as month_no, 'October' as month_name union select 11 as month_no, 'November' as month_name union select 12 as month_no, 'December' as month_name">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
            SelectCommand="select '2008' as fiscal_year union select '2009' as fiscal_year union select '2010' as fiscal_year union select '2011' as fiscal_year union select '2012' as fiscal_year union select '2013' as fiscal_year union select '2014' as fiscal_year">
    </asp:SqlDataSource>
    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Width="1213px" SelectedIndex ="0" ClickSelectedTab="True">
        <Tabs>
            <telerik:RadTab runat="server"  Text="Summary by Category" Selected="True" />
            <telerik:RadTab runat="server"  Text="Summary by Ledger Account"  />
            <telerik:RadTab runat="server"  Text="Summary by Budget Line Item"/>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0" Width="1400px" >
        
        <telerik:RadPageView ID="RadPageView1" runat="server" Selected="True" Width="1400px">
            <telerik:RadGrid ID="RadGrid2" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                BorderStyle="None" DataSourceID="SqlDataSource5" GridLines="None">
                <MasterTableView DataSourceID="SqlDataSource5" ShowFooter="true" TableLayout="Fixed" Width="1400px">
                    <EditFormSettings>
                        <PopUpSettings ScrollBars="None" />
                    </EditFormSettings>
                    <ExpandCollapseColumn Resizable="False" Visible="False">
                        <HeaderStyle Width="20px" />
                    </ExpandCollapseColumn>
                    <RowIndicatorColumn Visible="False">
                        <HeaderStyle Width="20px" />
                    </RowIndicatorColumn>
                    <HeaderStyle HorizontalAlign="Right" />
                    <ItemStyle HorizontalAlign="Right" Width="100px" />
                    <AlternatingItemStyle HorizontalAlign="Right" />
                    <Columns>
                        <telerik:GridHyperLinkColumn DataNavigateUrlFields="category" DataNavigateUrlFormatString="AccountSummary.aspx"
                            DataTextField="category" HeaderText="category" NavigateUrl="~/AccountSummary.aspx"
                            UniqueName="category">
                            <HeaderStyle HorizontalAlign="Left" Width="150px" />
                            <ItemStyle HorizontalAlign="Left" />
                        </telerik:GridHyperLinkColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="mtd_budget" DataFormatString="{0:C2}"
                            HeaderText="budget" UniqueName="mtd_budget">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="mtd_actual" DataFormatString="{0:C2}"
                            HeaderText="actual" UniqueName="mtd_actual">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="mtd_variance" DataFormatString="{0:C2}"
                            HeaderText="variance $" UniqueName="mtd_variance">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mtd_vpercentage" DataFormatString="{0:P1}" HeaderText="variance %"
                            UniqueName="mtd_vpercentage">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="ytd_budget" DataFormatString="{0:C2}"
                            HeaderText="ytd budget" UniqueName="ytd_budget">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="ytd_actual" DataFormatString="{0:C2}"
                            HeaderText="ytd actual" UniqueName="ytd_actual">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="sum" DataField="ytd_variance" DataFormatString="{0:C2}"
                            HeaderText="ytd variance $" UniqueName="ytd_variance">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ytd_vpercentage" DataFormatString="{0:P1}" HeaderText=" ytd variance %"
                            UniqueName="ytd_vpercentage">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                SelectCommand="exec eeiuser.acctg_budget_category_summary @month, @fiscal_year, @month_part, @user_id">
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox2" DefaultValue="January" Name="month"
                        PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="RadComboBox3" DefaultValue="2014" Name="fiscal_year"
                        PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="RadComboBox1" DefaultValue="MTD" Name="month_part"
                        PropertyName="SelectedValue" />
                    <asp:ProfileParameter Name="user_id" PropertyName="FirstName" />
                </SelectParameters>
            </asp:SqlDataSource>
           
        </telerik:RadPageView>


        <telerik:RadPageView ID="RadPageView2" runat="server" Selected="True" Width="1220px">
            <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="True" DataSourceID="SqlDataSource4" GridLines="None" BorderStyle="None" AutoGenerateColumns="False">
        <MasterTableView DataSourceID="SqlDataSource4" TableLayout = "Fixed" Width = "1220px" ShowFooter="True" ShowGroupFooter="true">
            <EditFormSettings>
                <PopUpSettings ScrollBars="None" />
            </EditFormSettings>
            <ExpandCollapseColumn Resizable="False" Visible="False">
                <HeaderStyle Width="20px" />
            </ExpandCollapseColumn>
            <RowIndicatorColumn Visible="False">
                <HeaderStyle Width="20px" />
            </RowIndicatorColumn>
            <HeaderStyle HorizontalAlign="Right" />
            <ItemStyle HorizontalAlign="Right" Width="100px" />
            <AlternatingItemStyle HorizontalAlign="Right" />
            
            <Columns>
                <telerik:GridHyperLinkColumn DataNavigateUrlFields="ledger_account" DataTextField="ledger_account"
                    HeaderText="account" UniqueName="ledger_account">
                    <HeaderStyle HorizontalAlign="Left" Width="150px" />
                    <ItemStyle HorizontalAlign="Left" />
                </telerik:GridHyperLinkColumn>
                <telerik:GridBoundColumn DataField="mtd_budget" DataFormatString="{0:C2}" UniqueName="mtd_budget" HeaderText = "budget" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="mtd_actual" DataFormatString="{0:C2}" UniqueName="mtd_actual" HeaderText = "actual" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="mtd_variance" DataFormatString="{0:C2}" UniqueName="mtd_variance" HeaderText = "variance $" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="mtd_vpercentage" DataFormatString="{0:P1}" UniqueName="mtd_vpercentage" HeaderText = "variance %">
                </telerik:GridBoundColumn>                
                <telerik:GridBoundColumn DataField="ytd_budget" DataFormatString="{0:C2}" UniqueName="ytd_budget" HeaderText = "ytd budget" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ytd_actual" DataFormatString="{0:C2}" UniqueName="ytd_actual" HeaderText = "ytd actual" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ytd_variance" DataFormatString="{0:C2}" UniqueName="ytd_variance" HeaderText = "ytd variance $" Aggregate="Sum">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ytd_vpercentage" DataFormatString="{0:P1}" UniqueName="ytd_vpercentage" HeaderText = " ytd variance %">
                </telerik:GridBoundColumn>
            </Columns>
        </MasterTableView>
                <ClientSettings>
                    <Resizing AllowColumnResize="True" ResizeGridOnColumnResize="True" />
                </ClientSettings>
    </telerik:RadGrid><asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" SelectCommand="exec eeiuser.acctg_budget_account_summary @month, @fiscal_year, @month_part, @user_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="RadComboBox2" DefaultValue="January" Name="month"
                PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="RadComboBox3" DefaultValue="2008" Name="fiscal_year"
                PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="RadComboBox1" DefaultValue="MTD" Name="month_part"
                PropertyName="SelectedValue" />
            <asp:ProfileParameter Name="user_id" PropertyName="FirstName" DefaultValue="Dan" />
        </SelectParameters>
    </asp:SqlDataSource>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView3" runat="server" Selected="True" Width="1400px">
            <telerik:RadGrid ID="RadGrid3" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                BorderStyle="None" DataSourceID="SqlDataSource6" GridLines="None" ShowGroupPanel="True">
                <MasterTableView DataSourceID="SqlDataSource6" GroupsDefaultExpanded="True" ShowFooter="True"
                    ShowGroupFooter="True" TableLayout="Fixed" Width="1400px">
                    <EditFormSettings>
                        <PopUpSettings ScrollBars="None" />
                    </EditFormSettings>
                    <ExpandCollapseColumn Resizable="False" Visible="False">
                        <HeaderStyle Width="20px" />
                    </ExpandCollapseColumn>
                    <RowIndicatorColumn Visible="False">
                        <HeaderStyle Width="20px" />
                    </RowIndicatorColumn>
                    <HeaderStyle HorizontalAlign="Right" />
                    <ItemStyle HorizontalAlign="Right" Width="100px" />
                    <AlternatingItemStyle HorizontalAlign="Right" />
                    <Columns>
                        <telerik:GridHyperLinkColumn DataNavigateUrlFields="ledger_account" DataTextField="ledger_account"
                            HeaderText="account" UniqueName="ledger_account">
                            <HeaderStyle HorizontalAlign="Left" Width="75px" />
                            <ItemStyle HorizontalAlign="Left" />
                        </telerik:GridHyperLinkColumn>                        
                        <telerik:GridBoundColumn DataField="budget_line" DataFormatString="{0:C2}"
                            HeaderText="budget line" UniqueName="budgetline">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" Width="100px" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="budget_description" DataFormatString="{0:C2}"
                            HeaderText="description" UniqueName="budget_description">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" Width="200px" />
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="mtd_budget" DataFormatString="{0:C2}"
                            GroupByExpression="Sum(budget)" HeaderText="budget" UniqueName="mtd_budget">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="mtd_actual" DataFormatString="{0:C2}"
                            HeaderText="actual" UniqueName="mtd_actual">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="mtd_variance" DataFormatString="{0:C2}"
                            HeaderText="variance $" UniqueName="mtd_variance">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="mtd_vpercentage" DataFormatString="{0:P1}" HeaderText="variance %"
                            UniqueName="mtd_vpercentage">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="ytd_budget" DataFormatString="{0:C2}"
                            HeaderText="ytd budget" UniqueName="ytd_budget">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="ytd_actual" DataFormatString="{0:C2}"
                            HeaderText="ytd actual" UniqueName="ytd_actual">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn Aggregate="Sum" DataField="ytd_variance" DataFormatString="{0:C2}"
                            HeaderText="ytd variance $" UniqueName="ytd_variance">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ytd_vpercentage" DataFormatString="{0:P1}" HeaderText=" ytd variance %"
                            UniqueName="ytd_vpercentage">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
                <ClientSettings AllowDragToGroup="True">
                </ClientSettings>
            </telerik:RadGrid><asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                SelectCommand="exec eeiuser.acctg_budget_account_detail_cr @budget_id, @organization, @fiscal_year, @month, @month_part, @user_id">
                <SelectParameters>
                    <asp:Parameter Name="budget_id" DefaultValue="2008 Official Budget - Q2 Update" />
                    <asp:ControlParameter ControlID="RadComboBox4" DefaultValue="11" Name="organization" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="RadComboBox3" DefaultValue="2008" Name="fiscal_year" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="RadComboBox2" DefaultValue="1" Name="month" Type="int32" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="RadComboBox1" DefaultValue="MTD" Name="month_part" PropertyName="SelectedValue" />
                    <asp:ProfileParameter Name="user_id" PropertyName="FirstName" />
                </SelectParameters>
            </asp:SqlDataSource>
        </telerik:RadPageView>
    </telerik:RadMultiPage><br />
    <br />
    
    <br />
    
</asp:Content>

