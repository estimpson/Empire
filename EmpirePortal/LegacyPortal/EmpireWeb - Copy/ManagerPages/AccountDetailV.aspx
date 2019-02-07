<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AccountDetailV.aspx.cs" Inherits="TestMaster" Title="Account Detail" %>

<%@ Register Assembly="DundasWebChart" Namespace="Dundas.Charting.WebControl" TagPrefix="DCWC" %>
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


    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxE">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxA" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadioButtonList2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxA">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid4" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid6" />
                    <telerik:AjaxUpdatedControl ControlID="Chart1" />
                    <telerik:AjaxUpdatedControl ControlID="Chart2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxD">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid4" /> 
                    <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
                    <telerik:AjaxUpdatedControl ControlID="Chart1" />
                    <telerik:AjaxUpdatedControl ControlID="Chart2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxB">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid4" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxA" /> 
                    <telerik:AjaxUpdatedControl ControlID="Chart1" />
                    <telerik:AjaxUpdatedControl ControlID="Chart2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxC">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid4" /> 
                    <telerik:AjaxUpdatedControl ControlID="RadGrid5" />
                    <telerik:AjaxUpdatedControl ControlID="Chart1" />
                    <telerik:AjaxUpdatedControl ControlID="Chart2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGrid4">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadioButtonList1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid6" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <br />
 
    <table style="width: 1400px">
        <tr>
            <td style="width: 700px; text-align:left">
   
                <telerik:RadComboBox ID="RadComboBoxE" runat="server" Skin="Vista" AutoPostBack="True" AppendDataBoundItems="true"  DataTextField = "organization_description" DataValueField = "organization"  Width="100px" MarkFirstMatch="True" DataSourceID="SqlDataSourceE" style="float:left; display:inline; padding-right:5px">
                    <Items>
                        <telerik:RadComboBoxItem runat="server" Text="All" Value="All" Selected="True" Enabled="true" />
                    </Items>
                    <CollapseAnimation Duration="200" Type="OutQuint" />
                </telerik:RadComboBox>
                
                <telerik:RadComboBox ID="RadComboBoxA" runat="server" Skin="Vista" AutoPostBack="True" DataTextField = "account_description" DataValueField = "ledger_account" Width="300px" MarkFirstMatch="True" DataSourceID="SqlDataSourceA" Height="400px" style="float:left; display:inline; padding-right:5px">
                </telerik:RadComboBox>
           
            </td>
            <td style="width: 700px; text-align:right">
   
                <telerik:RadComboBox ID="RadComboBoxD" runat="server" Skin="Vista" AutoPostBack="True" DataTextField = "month_name" DataValueField = "month_no" Width="125px" MarkFirstMatch="True" DataSourceID="SqlDataSourceD" style="float:right; display: inline; padding-right:5px"/>
                &nbsp;     
                <telerik:RadComboBox ID="RadComboBoxB" runat="server" Skin="Vista" AutoPostBack="True" DataTextField = "fiscal_year" DataValueField = "fiscal_year" Width="100px" MarkFirstMatch="True" DataSourceID="SqlDataSourceB" style="float:right; display: inline; padding-right:5px"/>
                &nbsp;    
                <telerik:RadComboBox ID="RadComboBoxC" runat="server" Skin="Vista" AutoPostBack="True" DataTextField = "budget_id" DataValueField = "budget_id" Width="275px" MarkFirstMatch="True" DataSourceID="SqlDataSourceC" style="float:right; display:inline; padding-right:5px"/>
                &nbsp;
   
            </td>
        </tr>
    </table>    

    <br />
    <telerik:RadDockZone ID="RadDockZone5" runat="server" MinHeight="40px" Width="1400px" BackColor="Transparent" Orientation="Horizontal" BorderStyle="None" ForeColor="Transparent" Skin="Office2007">
        <telerik:RadDock ID="RadDock6" Title="Budget v Actual Chart" runat="server" Width="700px" height="415px" Skin="Office2007"  Collapsed="true">
            <ContentTemplate>
            
                <DCWC:Chart ID="Chart1" runat="server" BackColor="LightSteelBlue" BackGradientEndColor="210, 235, 250"
                    BackGradientType="DiagonalLeft" BorderLineColor="LightSlateGray" BorderLineStyle="Solid"
                    DataSourceID="SqlDataSource6" Palette="WaterLilies" Width="690px" DataMember="DefaultView" Height="374px">
                    <Legends>
                        <DCWC:Legend Alignment="Center" BackColor="200, 235, 245, 255" BorderColor="LightSlateGray" Docking="Bottom" Name="Default"/>
                    </Legends>
                    <UI>
                        <Toolbar BackColor="Transparent" BorderStyle="NotSet">
                            <BorderSkin FrameBackColor="SteelBlue" FrameBackGradientEndColor="LightBlue" PageColor="Transparent" />
                        </Toolbar>
                    </UI>
                    <Titles>
                        <DCWC:Title Name="Account Performance"/>
                    </Titles>
                    <Series>
                        <DCWC:Series BackGradientEndColor="200, 195, 205, 220" CustomAttributes="LabelStyle=Top"
                            Font="Microsoft Sans Serif, 8.25pt" FontAngle="45" LabelToolTip="Budget for #VALX: #VAL{C2}"
                            Name="Budget" ToolTip="Budget for #VALX: #VAL{C2}" ValueMembersY="budget_amount"
                            ValueMemberX="date" XValueType="String">
                        </DCWC:Series>
                        <DCWC:Series BackGradientEndColor="200, 195, 205, 220" Color="DarkSeaGreen" Font="Microsoft Sans Serif, 8.25pt"
                            LabelToolTip="Actual for #VALX: #VAL{C2}" Name="Actual" ShadowColor="White" ToolTip="Actual for #VALX: #VAL{C2}"
                            ValueMembersY="actual_amount" ValueMemberX="date" XValueType="String">
                        </DCWC:Series>
                        
                    </Series>
                    <ChartAreas>
                        <DCWC:ChartArea BackColor="100, 235, 245, 255" BackGradientEndColor="235, 245, 255"
                            BorderColor="200, 0, 0, 0" BorderStyle="Solid" Name="Default">
                            <AxisY>
                                <MajorGrid LineColor="65, 0, 0, 0" LineStyle="Dash" />
                                <MinorGrid LineColor="30, 0, 0, 0" LineStyle="Dash" />
                                <MinorTickMark Size="2" />
                                <LabelStyle Format="C0" />
                            </AxisY>
                            <AxisX>
                                <MajorGrid LineColor="65, 0, 0, 0" LineStyle="Dash" />
                                <MinorGrid LineColor="30, 0, 0, 0" LineStyle="Dash" />
                                <MinorTickMark Size="2" />
                            </AxisX>
                            <Area3DStyle WallWidth="0" />
                        </DCWC:ChartArea>
                    </ChartAreas>
                    <BorderSkin FrameBackColor="SteelBlue" FrameBackGradientEndColor="LightBlue" FrameBorderColor="100, 0, 0, 0"
                        FrameBorderWidth="2" PageColor="AliceBlue" />
                </DCWC:Chart>
            
                <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                    SelectCommand="select isnull(a.ledger_account,b.ledger_account) as ledger_account, convert(char(2),isnull(a.period,b.period))+'/'+isnull(a.fiscal_year, b.fiscal_year) as date, isnull(a.fiscal_year, b.fiscal_year) as fiscal_year, isnull(a.period,b.period) as period, isnull(a.period_amount,0) as actual_amount, isnull(b.period_amount,0) as budget_amount from&#13;&#10;(select ledger_account, fiscal_year, period, period_amount as period_amount from ledger_balances where balance_name = 'Actual' and fiscal_year = @fiscal_year and ledger_account = @ledger_account ) a&#13;&#10;full outer join&#13;&#10;(select ledger_account, fiscal_year, period, sum(period_amount) as period_amount from eeiuser.acctg_budget where budget_id = @budget_id and fiscal_year = @fiscal_year and ledger_account = @ledger_account group by ledger_account, fiscal_year, period) b&#13;&#10;on a.ledger_account = b.ledger_account and a.period = b.period and a.fiscal_year = b.fiscal_year&#13;&#10;&#13;&#10;&#13;&#10;">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            
            </ContentTemplate>
        </telerik:RadDock>    
        
        <telerik:RadDock ID="RadDock7" Title="Paretto Chart" runat="server" Width="700px" height="415px" Skin="Office2007"  Collapsed="true">
            <ContentTemplate>
            
                <DCWC:Chart ID="Chart2" runat="server" BackColor="LightSteelBlue" BackGradientEndColor="210, 235, 250"
                    BackGradientType="DiagonalLeft" BorderLineColor="LightSlateGray" BorderLineStyle="Solid"
                    DataSourceID="SqlDataSource9" Palette="WaterLilies" Width="690px" DataMember="DefaultView" Height="374px">
                    <Legends>
                        <DCWC:Legend Alignment="Center" BackColor="200, 235, 245, 255" BorderColor="LightSlateGray" Docking="Bottom" Name="Default"/>
                    </Legends>
                    <UI>
                        <Toolbar BackColor="Transparent" BorderStyle="NotSet">
                            <BorderSkin FrameBackColor="SteelBlue" FrameBackGradientEndColor="LightBlue" PageColor="Transparent" />
                        </Toolbar>
                    </UI>
                    <Titles>
                        <DCWC:Title Name="Account Performance"/>
                    </Titles>
                    <Series>
                        <DCWC:Series BackGradientEndColor="200, 195, 205, 220" CustomAttributes="LabelStyle=Top"
                            Font="Microsoft Sans Serif, 8.25pt" FontAngle="45" LabelToolTip="Budget for #VALX: #VAL{C2}"
                            Name="Budget" ToolTip="Budget for #VALX: #VAL{C2}" ValueMembersY="budget_amount"
                            ValueMemberX="date" XValueType="String">
                        </DCWC:Series>
                        <DCWC:Series BackGradientEndColor="200, 195, 205, 220" Color="DarkSeaGreen" Font="Microsoft Sans Serif, 8.25pt"
                            LabelToolTip="Actual for #VALX: #VAL{C2}" Name="Actual" ShadowColor="White" ToolTip="Actual for #VALX: #VAL{C2}"
                            ValueMembersY="actual_amount" ValueMemberX="date" XValueType="String">
                        </DCWC:Series>
                        
                    </Series>
                    <ChartAreas>
                        <DCWC:ChartArea BackColor="100, 235, 245, 255" BackGradientEndColor="235, 245, 255"
                            BorderColor="200, 0, 0, 0" BorderStyle="Solid" Name="Default">
                            <AxisY>
                                <MajorGrid LineColor="65, 0, 0, 0" LineStyle="Dash" />
                                <MinorGrid LineColor="30, 0, 0, 0" LineStyle="Dash" />
                                <MinorTickMark Size="2" />
                                <LabelStyle Format="C0" />
                            </AxisY>
                            <AxisX>
                                <MajorGrid LineColor="65, 0, 0, 0" LineStyle="Dash" />
                                <MinorGrid LineColor="30, 0, 0, 0" LineStyle="Dash" />
                                <MinorTickMark Size="2" />
                            </AxisX>
                            <Area3DStyle WallWidth="0" />
                        </DCWC:ChartArea>
                    </ChartAreas>
                    <BorderSkin FrameBackColor="SteelBlue" FrameBackGradientEndColor="LightBlue" FrameBorderColor="100, 0, 0, 0"
                        FrameBorderWidth="2" PageColor="AliceBlue" />
                </DCWC:Chart>
            
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                    SelectCommand="select isnull(a.ledger_account,b.ledger_account) as ledger_account, convert(char(2),isnull(a.period,b.period))+'/'+isnull(a.fiscal_year, b.fiscal_year) as date, isnull(a.fiscal_year, b.fiscal_year) as fiscal_year, isnull(a.period,b.period) as period, isnull(a.period_amount,0) as actual_amount, isnull(b.period_amount,0) as budget_amount from&#13;&#10;(select ledger_account, fiscal_year, period, period_amount as period_amount from ledger_balances where balance_name = 'Actual' and fiscal_year = @fiscal_year and ledger_account = @ledger_account ) a&#13;&#10;full outer join&#13;&#10;(select ledger_account, fiscal_year, period, sum(period_amount) as period_amount from eeiuser.acctg_budget where budget_id = @budget_id and fiscal_year = @fiscal_year and ledger_account = @ledger_account group by ledger_account, fiscal_year, period) b&#13;&#10;on a.ledger_account = b.ledger_account and a.period = b.period and a.fiscal_year = b.fiscal_year&#13;&#10;&#13;&#10;&#13;&#10;">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            
            </ContentTemplate>
        </telerik:RadDock> 
    </telerik:RadDockZone>
    
    <telerik:RadDockZone ID="RadDockZone4" runat="server" MinHeight="40px" Width="1400px" BackColor="Transparent" Orientation="Horizontal" BorderStyle="None" ForeColor="Transparent" Skin="Office2007">
        <telerik:RadDock ID="RadDock4" Title="Month End Review Notes" runat="server" Width="700px" Skin="Office2007"  Collapsed="true">
            <ContentTemplate>
                
                <asp:RadioButtonList ID="RadioButtonList2" runat="server" AutoPostBack="True"  RepeatDirection="Horizontal"  >
                    <asp:ListItem Text="All" Value="All"/>
                    <asp:ListItem Text="Open" Value="Open" Selected="true"/>
                    <asp:ListItem Text="Closed" Value="Closed"/>
                </asp:RadioButtonList>
                            
                <telerik:RadGrid ID="RadGrid5" runat="server" AllowAutomaticInserts="True" AllowAutomaticUpdates="True"
                    AllowSorting="True" AutoGenerateEditColumn="True" DataSourceID="SqlDataSource5"
                    GridLines="None" Skin="Vista">
                    <MasterTableView AutoGenerateColumns="False" CommandItemDisplay="Top" DataSourceID="SqlDataSource5">
<Columns>
<telerik:GridBoundColumn DataField="review_note_id" UniqueName="review_note_id" Visible="False" ReadOnly="True" ForceExtractValue="Always"></telerik:GridBoundColumn>
<telerik:GridDropDownColumn DataField="status" UniqueName="status" HeaderText="status" Visible="False" DataSourceID="SqlDataSource5a" ListTextField="status" ListValueField="status" DropDownControlType="DropDownList"  ></telerik:GridDropDownColumn>
<telerik:GridBoundColumn DataField="budget_line" HeaderText="budget line" SortExpression="budget_line" UniqueName="budget_line">
    <ItemStyle Width="100px" />
</telerik:GridBoundColumn>
<telerik:GridBoundColumn DataField="review_note" HeaderText="review_note" SortExpression="review_note" UniqueName="review_note">
    <ItemStyle Width="230px" />
</telerik:GridBoundColumn>
<telerik:GridBoundColumn DataField="response" HeaderText="response" SortExpression="response" UniqueName="response"></telerik:GridBoundColumn>
</Columns>

<CommandItemSettings AddNewRecordText=" Add New Review Note"/>

<RowIndicatorColumn Visible="False">
<HeaderStyle Width="20px"/>
</RowIndicatorColumn>

<ExpandCollapseColumn Visible="False" Resizable="False">
<HeaderStyle Width="20px"/>
</ExpandCollapseColumn>
<EditItemStyle Width="250px" Wrap="true" />
<EditFormSettings>
<PopUpSettings ScrollBars="None"/>
<FormTableItemStyle Wrap="True" Width="250px"/>

</EditFormSettings>

</MasterTableView>
                    <ClientSettings EnablePostBackOnRowClick="True" EnableRowHoverStyle="True">
<Selecting AllowRowSelect="True"/>
</ClientSettings>
                </telerik:RadGrid>
                
                <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                    SelectCommand="select review_note_id, fiscal_year, period, ledger_account, budget_line, review_note, response, status from eeiuser.acctg_budget_review_note_header where ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = @period"
                    UpdateCommand="update eeiuser.acctg_budget_review_note_header set status = @status, budget_line = @budget_line, review_note = @review_note, response = @response where review_note_id = @review_note_id"
                    InsertCommand="insert into eeiuser.acctg_budget_review_note_header select (select max(review_note_id)+1 from eeiuser.acctg_budget_review_note_header) as review_note_id, @fiscal_year, @period, @ledger_account, @budget_line, 'Open', @review_note, @response">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxD" Name="period" PropertyName="SelectedValue" />
                
                    </SelectParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxD" Name="period" PropertyName="SelectedValue" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="review_note" Name="review_note" />
                        <asp:FormParameter FormField="response" Name="response" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:FormParameter FormField="status" Name="status" />
                        <asp:FormParameter FormField="review_note_id" Name="review_note_id" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="review_note" Name="review_note" />
                        <asp:FormParameter FormField="response" Name="response" />
                    </UpdateParameters>
                </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource5a" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                    SelectCommand="select 'Open' as status union select 'Closed' as status">
                </asp:SqlDataSource>
                </ContentTemplate>
        </telerik:RadDock>    
        
        <telerik:RadDock ID="RadDock5" Title="Action Items" runat="server" Width="700px"  Skin="Office2007"  Collapsed="true">
            <ContentTemplate>
                
                <asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="True"  RepeatDirection="Horizontal">
                    <asp:ListItem Text="All" Value="All"/>
                    <asp:ListItem Text="Open" Value="0pen" Selected="true"/>
                    <asp:ListItem Text="Closed" Value="Closed"/>
                </asp:RadioButtonList>
                
                <telerik:RadGrid ID="RadGrid6" runat="server" AllowAutomaticInserts="True" AllowAutomaticUpdates="True"
                    AllowSorting="True" AutoGenerateEditColumn="True" DataSourceID="SqlDataSource10"
                    GridLines="None" Skin="Vista">
                    <MasterTableView AutoGenerateColumns="False" CommandItemDisplay="Top" DataSourceID="SqlDataSource10"> 
                        <Columns>
                            <telerik:GridBoundColumn DataField="action_item_id" UniqueName="action_item_id" Visible="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="budget_line" HeaderText="budget_line" SortExpression="budget_line" UniqueName="budget_line"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="action_item" HeaderText="action_item" SortExpression="action_item" UniqueName="action_item"></telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="due_date" HeaderText="due_date" SortExpression="due_date" UniqueName="due_date" DataType="System.DateTime"></telerik:GridDateTimeColumn>
                             </Columns>
                        <CommandItemSettings AddNewRecordText=" Add New Action Item"/>
                        <RowIndicatorColumn Visible="False">
                            <HeaderStyle Width="20px"/>
                        </RowIndicatorColumn>
                        <ExpandCollapseColumn Visible="False" Resizable="False">
                            <HeaderStyle Width="20px"/>
                        </ExpandCollapseColumn>
                        <EditFormSettings>
                            <PopUpSettings ScrollBars="None"/>
                        </EditFormSettings>
                    </MasterTableView>
                    <ClientSettings EnablePostBackOnRowClick="True" EnableRowHoverStyle="True">
                        <Selecting AllowRowSelect="True"/>
                    </ClientSettings>
                </telerik:RadGrid>
        
                <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
                    SelectCommand="select action_item_id, budget_line, action_item, due_date from eeiuser.acctg_budget_action_item_header where ledger_account = @ledger_account"
                    UpdateCommand="update eeiuser.acctg_budget_action_item_header set budget_line = @budget_line, action_item = @action_item, due_date = @due_date where action_item_id = @action_item_id"
                    InsertCommand="insert into eeiuser.acctg_budget_action_item_header select (select max(action_item_id)+1 from eeiuser.acctg_budget_action_item_header) as action_item_id, @ledger_account, @budget_line, @action_item, 'Open', @due_date">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="action_item" Name="action_item" />
                        <asp:FormParameter FormField="due_date" Name="due_date" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:FormParameter FormField="action_item_id" Name="action_item_id" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="action_item" Name="action_item" />
                        <asp:FormParameter FormField="due_date" Name="due_date" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            
            </ContentTemplate>
        </telerik:RadDock>
    </telerik:RadDockZone>     
  
    <telerik:RadDockZone ID="RadDockZone2" runat="server" MinHeight="40px" Width="1400px" BackColor="Transparent" BorderStyle="None" ForeColor="Transparent" Skin="Office2007">
        <telerik:RadDock ID="RadDock2" Title="Budget versus Actual" runat="server" Width="1395px" Skin="Office2007" Collapsed="true">
            <ContentTemplate>
            
            <br />
            <br />
            Budget
            
            <telerik:RadGrid ID="RadGrid1" runat="server" Skin="Web20" AllowSorting="True" DataSourceID="SqlDataSource1" GridLines="None" BorderStyle="None" AutoGenerateColumns="False" >
                <MasterTableView DataSourceID="SqlDataSource1"  TableLayout = "Fixed" Width = "1375px" ShowFooter="True" ShowGroupFooter="True"  EditMode="InPlace" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" CommandItemDisplay="Top">
                        <Columns>
                            <telerik:GridEditCommandColumn HeaderStyle-Width="60px" ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Left"/>
                            <telerik:GridBoundColumn DataField="budget_line" UniqueName="budget_line" HeaderText="budget_line" >
                                <HeaderStyle HorizontalAlign="Left" Width="100px" />
                                <ItemStyle HorizontalAlign="Left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="budget_description" DataFormatString="{0:C2}" UniqueName="budget_description" HeaderText = "description">
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle HorizontalAlign="Left" Width="200px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="budget1" DataFormatString="{0:C0}" UniqueName="budget1" HeaderText = "1-2013" Aggregate="Sum"  GroupByExpression="Sum(budget1)"/>
                            <telerik:GridBoundColumn DataField="budget2" DataFormatString="{0:C0}" UniqueName="budget2" HeaderText = "2-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget3" DataFormatString="{0:C0}" UniqueName="budget3" HeaderText = "3-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget4" DataFormatString="{0:C0}" UniqueName="budget4" HeaderText = "4-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget5" DataFormatString="{0:C0}" UniqueName="budget5" HeaderText = "5-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget6" DataFormatString="{0:C0}" UniqueName="budget6" HeaderText = "6-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget7" DataFormatString="{0:C0}" UniqueName="budget7" HeaderText = "7-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget8" DataFormatString="{0:C0}" UniqueName="budget8" HeaderText = "8-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget9" DataFormatString="{0:C0}" UniqueName="budget9" HeaderText = "9-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget10" DataFormatString="{0:C0}" UniqueName="budget10" HeaderText = "10-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget11" DataFormatString="{0:C0}" UniqueName="budget11" HeaderText = "11-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="budget12" DataFormatString="{0:C0}" UniqueName="budget12" HeaderText = "12-2013" Aggregate="Sum" />
                            <telerik:GridBoundColumn DataField="total_budget" DataFormatString="{0:C0}" UniqueName="total_budget" HeaderText = "total_budget" Aggregate="Sum" />
                        </Columns>
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" Width="80px" />
                        <FooterStyle HorizontalAlign="Right" />
                        <AlternatingItemStyle HorizontalAlign="Right" />
                        <EditFormSettings>
                            <PopUpSettings ScrollBars="None" />
                            <EditColumn UniqueName="EditCommandColumn1"/>
                        </EditFormSettings>
                        <ExpandCollapseColumn Resizable="False" Visible="False">
                            <HeaderStyle Width="20px" />
                        </ExpandCollapseColumn>
                        <RowIndicatorColumn Visible="False">
                            <HeaderStyle Width="20px" />
                        </RowIndicatorColumn>    
                    </MasterTableView>
                </telerik:RadGrid>
            
                <br />
                Actual
            
                <telerik:RadGrid ID="RadGrid2" runat="server" Skin="Web20" AllowSorting="True" DataSourceID="SqlDataSource1" GridLines="None" BorderStyle="None" AutoGenerateColumns="False" Width="1400px" OnItemCommand="RadGrid2_ItemCommand">
                    <MasterTableView DataSourceID="SqlDataSource1" TableLayout = "Fixed" Width = "1375px" ShowFooter="True" ShowGroupFooter="True" DataKeyNames="ledger_account,budget_line" HierarchyLoadMode="ServerBind" AllowAutomaticUpdates="False">
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="spacer1" HeaderStyle-Width="55px" ItemStyle-Width="55px"/>
                            <telerik:GridBoundColumn DataField="budget_line" UniqueName="budget_line2" HeaderText="budget_line" >
                                <HeaderStyle HorizontalAlign="Left" Width="100px" />
                                <ItemStyle HorizontalAlign="Left" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="budget_description" DataFormatString="{0:C2}" UniqueName="budget_description2" HeaderText = "description">
                                <ItemStyle HorizontalAlign="Left" />
                                <HeaderStyle HorizontalAlign="Left" Width="200px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="actual1" DataFormatString="{0:C0}" UniqueName="actual1" HeaderText = "1-2013" Aggregate="Sum" GroupByExpression="Sum(actual1)"/>
                            <telerik:GridBoundColumn DataField="actual2" DataFormatString="{0:C0}" UniqueName="actual2" HeaderText = "2-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual3" DataFormatString="{0:C0}" UniqueName="actual3" HeaderText = "3-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual4" DataFormatString="{0:C0}" UniqueName="actual4" HeaderText = "4-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual5" DataFormatString="{0:C0}" UniqueName="actual5" HeaderText = "5-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual6" DataFormatString="{0:C0}" UniqueName="actual6" HeaderText = "6-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual7" DataFormatString="{0:C0}" UniqueName="actual7" HeaderText = "7-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual8" DataFormatString="{0:C0}" UniqueName="actual8" HeaderText = "8-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual9" DataFormatString="{0:C0}" UniqueName="actual9" HeaderText = "9-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual10" DataFormatString="{0:C0}" UniqueName="actual10" HeaderText = "10-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual11" DataFormatString="{0:C0}" UniqueName="actual11" HeaderText = "11-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="actual12" DataFormatString="{0:C0}" UniqueName="actual12" HeaderText = "12-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="total_actual" DataFormatString="{0:C0}" UniqueName="total_actual" HeaderText = "total_actual" Aggregate="Sum"/>
                        </Columns>
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" Width="80px" />
                        <FooterStyle HorizontalAlign="Right" />
                        <AlternatingItemStyle HorizontalAlign="Right" />
                        <EditFormSettings>
                            <PopUpSettings ScrollBars="None" />
                        </EditFormSettings>
                        <ExpandCollapseColumn Resizable="False">
                            <HeaderStyle Width="20px" />
                        </ExpandCollapseColumn>
                        <RowIndicatorColumn Visible="False">
                            <HeaderStyle Width="20px" />
                        </RowIndicatorColumn>             
                    </MasterTableView>
                </telerik:RadGrid>
                
                <br />
                Variance
                
                <telerik:RadGrid ID="RadGrid3" runat="server" Skin="Web20"  AllowSorting="True" DataSourceID="SqlDataSource1" GridLines="None" BorderStyle="None" AutoGenerateColumns="False" Width="1400px">
                    <MasterTableView DataSourceID="SqlDataSource1" TableLayout = "Fixed" Width = "1375px" ShowFooter="True" ShowGroupFooter="True">
                        <Columns>
                            <telerik:GridTemplateColumn UniqueName="spacer1" HeaderStyle-Width="55px" ItemStyle-Width="55px"/>
                            <telerik:GridBoundColumn DataField="budget_line" UniqueName="budget_line3" HeaderText="budget_line" HeaderStyle-HorizontalAlign="left" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left" />
                            <telerik:GridBoundColumn DataField="budget_description" DataFormatString="{0:C2}" UniqueName="budget_description3" HeaderText = "description">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" Width="200px" />
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="variance1" DataFormatString="{0:C0}" UniqueName="variance1" HeaderText = "1-2013" Aggregate="Sum" GroupByExpression="Sum(variance1)"/>
                            <telerik:GridBoundColumn DataField="variance2" DataFormatString="{0:C0}" UniqueName="variance2" HeaderText = "2-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance3" DataFormatString="{0:C0}" UniqueName="variance3" HeaderText = "3-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance4" DataFormatString="{0:C0}" UniqueName="variance4" HeaderText = "4-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance5" DataFormatString="{0:C0}" UniqueName="variance5" HeaderText = "5-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance6" DataFormatString="{0:C0}" UniqueName="variance6" HeaderText = "6-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance7" DataFormatString="{0:C0}" UniqueName="variance7" HeaderText = "7-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance8" DataFormatString="{0:C0}" UniqueName="variance8" HeaderText = "8-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance9" DataFormatString="{0:C0}" UniqueName="variance9" HeaderText = "9-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance10" DataFormatString="{0:C0}" UniqueName="variance10" HeaderText = "10-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance11" DataFormatString="{0:C0}" UniqueName="variance11" HeaderText = "11-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="variance12" DataFormatString="{0:C0}" UniqueName="variance12" HeaderText = "12-2013" Aggregate="Sum"/>
                            <telerik:GridBoundColumn DataField="total_variance" DataFormatString="{0:C0}" UniqueName="total_variance" HeaderText = "total_variance" Aggregate="Sum"/>
                        </Columns>
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" Width="80px" />
                        <FooterStyle HorizontalAlign="Right" />
                        <AlternatingItemStyle HorizontalAlign="Right" />
                        <EditFormSettings>
                            <PopUpSettings ScrollBars="None" />
                        </EditFormSettings>
                        <ExpandCollapseColumn Resizable="False" Visible="False">
                            <HeaderStyle Width="20px" />
                        </ExpandCollapseColumn>
                        <RowIndicatorColumn Visible="False">
                            <HeaderStyle Width="20px" />
                        </RowIndicatorColumn>    
                    </MasterTableView>
                </telerik:RadGrid>
                
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" SelectCommand="exec eeiuser.acctg_budget_annual_query @budget_id, @fiscal_year, @user_id, @ledger_account" UpdateCommand="exec eeiuser.acctg_budget_annual_update @budget_id, @ledger_account, @fiscal_year, @budget_line, @budget1, @budget2, @budget3, @budget4, @budget5, @budget6, @budget7, @budget8, @budget9, @budget10, @budget11, @budget12, @total_budget, @budget_description" InsertCommand="exec eeiuser.acctg_budget_annual_insert @budget_id, @ledger_account, @fiscal_year, @budget_line, @budget1, @budget2, @budget3, @budget4, @budget5, @budget6, @budget7, @budget8, @budget9, @budget10, @budget11, @budget12, @total_budget, @budget_description" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:ProfileParameter Name="user_id" PropertyName="FirstName" Type="String"/>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" Type="String"/>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String"/>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="budget1" Name="budget1" />
                        <asp:FormParameter FormField="budget2" Name="budget2" />
                        <asp:FormParameter FormField="budget3" Name="budget3" />
                        <asp:FormParameter FormField="budget4" Name="budget4" />
                        <asp:FormParameter FormField="budget5" Name="budget5" />
                        <asp:FormParameter FormField="budget6" Name="budget6" />
                        <asp:FormParameter FormField="budget7" Name="budget7" />
                        <asp:FormParameter FormField="budget8" Name="budget8" />
                        <asp:FormParameter FormField="budget9" Name="budget9" />
                        <asp:FormParameter FormField="budget10" Name="budget10" />
                        <asp:FormParameter FormField="budget11" Name="budget11" />
                        <asp:FormParameter FormField="budget12" Name="budget12" />
                        <asp:FormParameter FormField="total_budget" Name="total_budget" />
                        <asp:FormParameter FormField="budget_description" Name="budget_description" />
                    </UpdateParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" Type="String"/>
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String"/>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:FormParameter FormField="budget_line" Name="budget_line" />
                        <asp:FormParameter FormField="budget1" Name="budget1" />
                        <asp:FormParameter FormField="budget2" Name="budget2" />
                        <asp:FormParameter FormField="budget3" Name="budget3" />
                        <asp:FormParameter FormField="budget4" Name="budget4" />
                        <asp:FormParameter FormField="budget5" Name="budget5" />
                        <asp:FormParameter FormField="budget6" Name="budget6" />
                        <asp:FormParameter FormField="budget7" Name="budget7" />
                        <asp:FormParameter FormField="budget8" Name="budget8" />
                        <asp:FormParameter FormField="budget9" Name="budget9" />
                        <asp:FormParameter FormField="budget10" Name="budget10" />
                        <asp:FormParameter FormField="budget11" Name="budget11" />
                        <asp:FormParameter FormField="budget12" Name="budget12" />
                        <asp:FormParameter FormField="total_budget" Name="total_budget" />
                        <asp:FormParameter FormField="budget_description" Name="budget_description" />
                    </InsertParameters>
                </asp:SqlDataSource>        
                
            </ContentTemplate>
        </telerik:RadDock>
    </telerik:RadDockZone>
   
   
    <asp:SqlDataSource ID="SqlDataSourceE" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" 
            SelectCommand="select '11' as organization,'11 (EEI)' as organization_description union select '08' as organization, '08 (PCB' as organization_description union select '12' as organization,'12 (EEH)' as organization_description union select '21' as organization, '21 (ESE)' as organization_description union select '60' as organization,'60 (EEC)' as organization_description order by 1 asc">
    </asp:SqlDataSource>   
    <asp:SqlDataSource ID="SqlDataSourceA" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" 
            SelectCommand="exec eeiuser.acctg_budget_authorized_ledger_accounts @user_id, @budget_id, @organization, @fiscal_year">
        <SelectParameters>
            <asp:ProfileParameter Name="user_id" PropertyName="FirstName" Type="String" />
            <asp:ControlParameter ControlID="RadComboBoxC" Name="budget_id" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="RadComboBoxE" Name="organization" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year"  PropertyName="SelectedValue" Type="string" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceB" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
            SelectCommand="select '2008' as fiscal_year union select '2009' as fiscal_year union select '2010' as fiscal_year union select '2011' as fiscal_year union select '2012' as fiscal_year union select '2013' as fiscal_year union select '2014' as fiscal_year">
    </asp:SqlDataSource>
     <asp:SqlDataSource ID="SqlDataSourceC" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
            SelectCommand="select distinct(budget_id) as budget_id from eeiuser.acctg_budget order by 1 desc">
    </asp:SqlDataSource>   
    <asp:SqlDataSource ID="SqlDataSourceD" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>"
            SelectCommand="select 1 as month_no, 'January' as month_name union select 2 as month_no, 'February' as month_name union select 3 as month_no, 'March' as month_name union select 4 as month_no, 'April' as month_name union select 5 as month_no, 'May' as month_name union select 6 as month_no, 'June' as month_name union select 7 as month_no, 'July' as month_name union select 8 as month_no, 'August' as month_name union select 9 as month_no, 'September' as month_name union select 10 as month_no, 'October' as month_name union select 11 as month_no, 'November' as month_name union select 12 as month_no, 'December' as month_name">
    </asp:SqlDataSource>
    
   
    <telerik:RadDockZone ID="RadDockZone3" runat="server" MinHeight="40px" Width="1400px" BackColor="Transparent" BorderStyle="None" ForeColor="Transparent" Skin="Office2007">
        <telerik:RadDock ID="RadDock3" Title="Actual Detail for the Month" runat="server" Width="1400px"  Skin="Office2007"  Collapsed="true">
            <ContentTemplate>
                
                <telerik:RadGrid ID="RadGrid4" runat="server" Skin="Web20" AllowAutomaticUpdates="True" AllowSorting="True" DataSourceID="SqlDataSource2" GridLines="None" BorderStyle="None" AutoGenerateColumns="False" Width="1215px">
                    <MasterTableView DataSourceID="SqlDataSource2" TableLayout = "Fixed" Width = "1400px" ShowFooter="True" ShowGroupFooter="True" EditMode="InPlace">
                        <Columns>
                            <telerik:GridEditCommandColumn HeaderStyle-Width="60px" ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Left"/>
                            <telerik:GridBoundColumn DataField="contract_account_id" UniqueName="contract_account_id" HeaderText="budget_line" HeaderStyle-HorizontalAlign="left" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left" />
                            <telerik:GridBoundColumn DataField="document_id2" UniqueName="document_id2" HeaderText = "document_id2" HeaderStyle-Width="100px"/>
                            <telerik:GridBoundColumn DataField="document_id1" UniqueName="document_id1" HeaderText = "document_id1" HeaderStyle-Width="100px"/>               
                            <telerik:GridBoundColumn DataField="transaction_date" DataFormatString="{0:d}" UniqueName="transaction_date" HeaderText = "transaction_date" HeaderStyle-Width="100px" ReadOnly="True"/>
                            <telerik:GridBoundColumn DataField="amount" DataFormatString="{0:C2}" UniqueName="amount" HeaderText = "amount" HeaderStyle-Width="75px" Aggregate="Sum" ReadOnly="True"/>
                            <telerik:GridBoundColumn DataField="document_remarks" UniqueName="document_remarks" HeaderText = "document_remarks" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ReadOnly="True"/>
                            <telerik:GridBoundColumn DataField="document_line" UniqueName="document_line" Visible="False"/>
                            <telerik:GridBoundColumn DataField="document_type" UniqueName="document_type" Visible="False"/>
                        </Columns>
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" Width="100px" />
                        <AlternatingItemStyle HorizontalAlign="Right" />
                        <EditFormSettings>
                            <PopUpSettings ScrollBars="None" />
                        </EditFormSettings>
                        <ExpandCollapseColumn Resizable="False" Visible="False">
                            <HeaderStyle Width="20px" />
                        </ExpandCollapseColumn>
                        <RowIndicatorColumn Visible="False">
                            <HeaderStyle Width="20px" />
                        </RowIndicatorColumn>    
                    </MasterTableView>
                </telerik:RadGrid>    
    
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MONITOR %>" SelectCommand="exec eeiuser.acctg_budget_annual_select_actual @fiscal_year, @period, @ledger_account" UpdateCommand="exec eeiuser.acctg_budget_annual_update_actual @fiscal_year, @period, @ledger_account, @contract_account_id, @document_id2,  @document_id1, @transaction_date, @amount, @document_remarks, @document_line, @document_type">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxD" Name="period" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>        
                    <UpdateParameters>
                        <asp:ControlParameter ControlID="RadComboBoxB" Name="fiscal_year" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxD" Name="period" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="RadComboBoxA" Name="ledger_account" PropertyName="SelectedValue" Type="String" />            
                        <asp:FormParameter FormField="contract_account_id" Name="contract_account_id" Type="String" />
                        <asp:FormParameter FormField="document_id2" Name="document_id2" />
                        <asp:FormParameter FormField="document_id1" Name="document_id1" />
                        <asp:FormParameter FormField="transaction_date" Name="transaction_date" Type="DateTime" />
                        <asp:FormParameter FormField="amount" Name="amount" />
                        <asp:FormParameter FormField="document_remarks" Name="document_remarks" />
                        <asp:FormParameter FormField="document_line" Name="document_line" Type="String" />
                        <asp:FormParameter FormField="document_type" Name="document_type" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>     
    
            </ContentTemplate>
        </telerik:RadDock>
    </telerik:RadDockZone>    
    
    <telerik:RadDockZone ID="RadDockZone1" runat="server" MinHeight="40px" Width="1238px" BackColor="Transparent" BorderStyle="None" ForeColor="Transparent" Skin="Office2007">
    </telerik:RadDockZone>     
    
        
</asp:Content>

