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
    
    
    <telerik:AjaxSetting AjaxControlID="RadGrid2">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
        </UpdatedControls>
    </telerik:AjaxSetting>
    
    
    </AjaxSettings>
    </telerik:RadAjaxManager>
        <div>
            <span class="style1">Display Shipments from:</span>
            <telerik:RadDatePicker ID="RadDatePicker1" Runat="server" AutoPostBack="True" 
                Culture="en-US" 
                HiddenInputTitleAttibute="Visually hidden input created for functionality purposes." 
                SelectedDate="2013-01-01" 
                WrapperTableSummary="Table holding date picker control for selection of dates.">
                <Calendar runat="server" UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" ViewSelectorText="x">
                </Calendar>

                <DateInput runat= "server" DisplayDateFormat="M/dd/yyyy" DateFormat="M/dd/yyyy" LabelWidth="40%" 
                    AutoPostBack="True" DisplayText="1/1/2013" SelectedDate="2013-01-01" 
                    value="1/1/2013">
                </DateInput>

                <DatePopupButton ImageUrl="" HoverImageUrl="">
                </DatePopupButton>
            </telerik:RadDatePicker>

            &nbsp;<span class="style1">to: </span>
            
            <telerik:RadDatePicker ID="RadDatePicker2" Runat="server" AutoPostBack="True" 
                Culture="en-US" 
                HiddenInputTitleAttibute="Visually hidden input created for functionality purposes." 
                SelectedDate="2013-01-01" 
                WrapperTableSummary="Table holding date picker control for selection of dates.">
                <Calendar UseRowHeadersAsSelectors="False" UseColumnHeadersAsSelectors="False" ViewSelectorText="x" runat="server">
                </Calendar>

                <DateInput runat="server" DisplayDateFormat="M/dd/yyyy" DateFormat="M/dd/yyyy" LabelWidth="40%" 
                    AutoPostBack="True" DisplayText="1/31/2013" SelectedDate="2013-01-31" 
                    value="1/31/2013">
                </DateInput>

                <DatePopupButton ImageUrl="" HoverImageUrl="">
                </DatePopupButton>
            </telerik:RadDatePicker>
            <br />
            <br />
            <span class="style1">
            <strong>Releases:</strong></span>
            <telerik:RadGrid    ID="RadGrid2"  
                                DataSourceID="SqlDataSource2"
                                runat="server"
                                ShowStatusBar="True"                              
                                Width="95%" 
                                CellSpacing="0" 
                                ShowGroupPanel="True" 
                                AllowSorting="True" >
                
                <MasterTableView    Width="100%" 
                                    AutoGenerateColumns="False" 
                                    RetrieveAllDataFields="true"
                                    GridLines="Vertical"
                                    ShowHeader="true"   >
                    
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
                                                    UniqueName="ShipToCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn    DataField="CustomerPart" 
                                                    FilterControlAltText="Filter CustomerPart column" 
                                                    HeaderText="CustomerPart" 
                                                    ReadOnly="True" 
                                                    SortExpression="CustomerPart" 
                                                    UniqueName="CustomerPart">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn DataField="MonReleaseDT" 
                                                    FilterControlAltText="Filter MonReleaseNo column"  
                                                    SortExpression="MonReleaseDT" 
                                                    UniqueName="MonReleaseDT">
                            <HeaderTemplate>
                                <table id="Table1" style="width:auto;" >
                                <tr>
                                    <td colspan="1" style="text-align:center">
                                
                                <asp:LinkButton ID="Label1" runat="server" 
                                    Text="Mon 2/18/2013">
                                </asp:LinkButton>
                                    </td>
                                    </tr>
                                    </table>
                            </HeaderTemplate>
                                   
                            <ItemTemplate>
                                <asp:Label ID="MonReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("MonReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="MonReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("MonReleaseQty", "{0:N0}") %>'></asp:Label> 
                                 
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn FilterControlAltText="Filter TueReleaseDT column" 
                                                    SortExpression="TueReleaseDT" 
                                                    UniqueName="TueReleaseDT">
                            <HeaderTemplate>
                                <asp:LinkButton  ID="Label2" runat="server" 
                                            Text="Tue 2/19/2013">
                                </asp:LinkButton>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TueReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("TueReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="TueReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("TueReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn     FilterControlAltText="Filter WedReleaseNo column" 
                                                        SortExpression="WedReleaseNo" 
                                                        UniqueName="WedReleaseNo">
                            <HeaderTemplate>
                                <asp:Label ID="Label3" runat="server" 
                                    Text="Wed 2/20/2013"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="WedReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("WedReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="WedReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("WedReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn     FilterControlAltText="Filter ThuReleaseNo column" 
                                                        HeaderText="ThuReleaseNo" 
                                                        SortExpression="ThuReleaseNo" 
                                                        UniqueName="ThuReleaseNo">
                        
                            <HeaderTemplate>
                                <asp:Label ID="Label4" runat="server" 
                                    Text="Thu 2/21/2013"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="ThuReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("ThuReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="ThuReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("ThuReleaseQty", "{0:N0}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn 
                                                         FilterControlAltText="Filter FriReleaseNo column" 
                                                         HeaderText="FriReleaseNo" 
                                                         SortExpression="FriReleaseNo" 
                                                         UniqueName="FriReleaseNo">
                            <HeaderTemplate>
                                <asp:Label ID="Label5" runat="server" 
                                    Text="Fri 2/22/2013"></asp:Label>
                            </HeaderTemplate><ItemTemplate>
                                <asp:Label ID="FriReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("FriReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="FriReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("FriReleaseQty", "{0:N}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn 
                            FilterControlAltText="Filter SatReleaseNo column"  
                            SortExpression="SatReleaseNo" UniqueName="SatReleaseNo">
                             <HeaderTemplate>
                                <asp:Label ID="Label6" runat="server" 
                                    Text="Sat 2/23/2013"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="SatReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("SatReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="SatReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("SatReleaseQty", "{0:N}") %>'></asp:Label>
                            </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn  
                            FilterControlAltText="Filter SunReleaseNo column"  
                            SortExpression="SunReleaseNo" UniqueName="SunReleaseNo">
                            <HeaderTemplate>
                                <asp:Label ID="Label7" runat="server" 
                                    Text="Sat 2/24/2013"></asp:Label>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="SunReleaseNoLabel" runat="server" 
                                    Text='<%# Eval("SunReleaseNo") %>'></asp:Label>
                                <br />
                                <asp:Label ID="SunReleaseNoLabel0" runat="server" 
                                    Text='<%# Eval("SunReleaseQty", "{0:N}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                    </Columns>
                    <EditFormSettings>
                        <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                        </EditColumn>
                    </EditFormSettings>
                </MasterTableView>
                <GroupingSettings ShowUnGroupButton="True" />
                <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true" 
                    AllowDragToGroup="True">
                    <Selecting AllowRowSelect="true" />
                    <Scrolling AllowScroll="True" ScrollHeight="500px" UseStaticHeaders="True" />
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
                <FilterMenu EnableImageSprites="False">
                </FilterMenu>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="SqlDataSource2" 
                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_nal_rans_by_week"
                runat="server" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
