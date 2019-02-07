<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContainerProgress.aspx.cs" Inherits="ContainerProgress" %>
<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Order Progress</title>
    <link rel="Stylesheet" type="text/css" href="CSS/StyleSheet.css" />
</head>
<body>
    <form id="form1" runat="server">

        <Telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        </Telerik:RadStyleSheetManager>

        <telerik:radscriptmanager runat="server">
        </telerik:radscriptmanager>
       
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
            <ajaxsettings>
                <telerik:AjaxSetting AjaxControlID="RadPushButton1">
                    <updatedcontrols>
                        <Telerik:AjaxUpdatedControl ControlID="SDS_KomaxProduction2" />
                        <Telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    </updatedcontrols>
                </telerik:AjaxSetting>
            </ajaxsettings>
        </telerik:RadAjaxManager>

<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
</telerik:RadAjaxLoadingPanel>
 
<div>       

<Telerik:RadComboBox 
        ID="RadComboBox1" 
        runat="server" 
        height="190px"
        width="200px" 
        Skin="Bootstrap"  
        DataSourceID="SqlDataSource1" 
        OnItemDataBound="RadComboBox1_ItemDataBound" 
        DropDownAutoWidth="Enabled"
        Label="Select Container Number:"
        DataTextField="ContenedorID"
        DataValueField="ContenedorID"
        HighlightTemplatedItems="true"
         EnableOverlay="true"
        AutoPostBack="true"
       Enabled="true"
    >
 
   
    <HeaderTemplate>
    <%--<ul>    
            <li class="col1">Container Number</li>
            <li class="col2">Date Departing EEH</li>
            <li class="col3">Date Arriving EEI</li>

        </ul>--%>       
        
        <table style="width: 500px; text-align:left">
            <tr>
                <td style="width: 70px;">Container ID</td>
                <td style="width: 150px;">Date Departing EEH</td>
                <td style="width: 150px;">Date Arriving EEI</td>
            </tr>
        </table>
    </HeaderTemplate>    
        
    <ItemTemplate>
     
        <%--<ul>
            <li class="col1">
                   <asp:Label ID="One" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ContenedorID") %>' /></li>
            <li class="col2">
                   <asp:Label ID="Two" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "FechaEEH") %>' /></li>
            <li class="col3">
                   <asp:Label ID="Three" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "FechaEEI") %>' /></li>     
        </ul>--%>
        <table style="width: 500px; text-align:left">
            <tr style="height:25px">
                <td style="width: 70px;">
                    <%# DataBinder.Eval(Container.DataItem, "ContenedorID") %>
                </td>
                <td style="width: 150px;">
                    <%# DataBinder.Eval(Container.DataItem, "FechaEEH") %>
                </td>
                <td style="width: 150px;">
                    <%# DataBinder.Eval(Container.DataItem, "FechaEEI") %>
                </td>
            </tr>
        </table>
    </ItemTemplate>
</Telerik:RadComboBox>


    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>" SelectCommand="select * from sistema.dbo.CP_Contenedores Contenedor where fechaEEH between dateadd(d,-28,getdate()) and dateadd(d,+28,getdate()) order by 1
"></asp:SqlDataSource>


<%--<telerik:RadDropDownList ID="RadDropDownList1" runat="server" RenderMode="Lightweight" Skin="Material" AutoPostBack="true" Height="35px" >
    <Items>
        <telerik:DropDownListItem runat="server" Selected="False" Text="Day" Value="dd" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Week" Value="wk" /> 
        <telerik:DropDownListItem runat="server" Selected="False" Text="Month" Value="mm" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Quarter" Value="qq" />
        <telerik:DropDownListItem runat="server" Selected="False" Text="Year" Value="yy" />
       
    </Items>
</telerik:RadDropDownList> --%>      


<telerik:RadPushButton ID="RadPushButton1" runat="server" Text="Refresh Data" AutoPostBack="True" OnClick="RadPushButton1_Click" Height="33px" Skin="Material" >
    <Icon CssClass="rbRefresh" ></Icon>
</telerik:RadPushButton>

<br/>
<br />


    <Telerik:RadGrid ID="RadGrid1" runat="server" Skin="Bootstrap"  Height="800px" Width="50%" AllowSorting ="True" 
                        DataSourceID="SDS_ContainerProgress" MasterTableView-ShowGroupFooter="true" AutoGenerateColumns="False" ShowHeader="true" ShowFooter="True" FilterType="HeaderContext" OnCustomAggregate="RadGrid1_CustomAggregate" >
    
    <GroupingSettings CollapseAllTooltip="Collapse all groups">
    </GroupingSettings>
            <ClientSettings>
                <Selecting AllowRowSelect="True" CellSelectionMode="SingleCell" />
                <Scrolling AllowScroll="true" UseStaticHeaders="true" />              
            </ClientSettings>
            <MasterTableView DataSourceID="SDS_ContainerProgress" DataKeyNames="part" IsFilterItemExpanded="false" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" AllowFilteringByColumn="true" CommandItemDisplay="Top" GroupLoadMode="Client">
              <GroupByExpressions>
                  <Telerik:GridGroupByExpression>
                      <SelectFields>
                          <Telerik:GridGroupByField FieldName="category" HeaderText="Category" />
                          <Telerik:GridGroupByField FieldName="revision3" HeaderText="Qty Required (Revision 3)" FormatString="{0:N0}" Aggregate="Sum" />
                          <Telerik:GridGroupByField FieldName="qty_built" HeaderText="Qty Built" FormatString="{0:N0}" Aggregate="Sum" />
                          <Telerik:GridGroupByField FieldName="percent_complete" HeaderText="Percent Complete" FormatString="{0:P0}" Aggregate="Avg" />
                      </SelectFields>
                      <GroupByFields>
                          <Telerik:GridGroupByField FieldName="category" />
                      </GroupByFields>
                  </Telerik:GridGroupByExpression>
              </GroupByExpressions>
                <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="True" />
                <Columns>
                    <telerik:GridBoundColumn DataField="category"                                                     HeaderText="Category"                         HeaderStyle-Width="10%"  FilterControlAltText="Filter category column"                  SortExpression="category"       UniqueName="category" GroupByExpression="category" DataType="System.String">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="part"                                                                                                       HeaderStyle-Width="10%" FilterControlAltText="Filter part column"           HeaderText="Part"               SortExpression="part"           UniqueName="part">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="comentario1"                                                                                                HeaderStyle-Width="20%" FilterControlAltText="Filter comentario1 column"    HeaderText="Commentary"         SortExpression="comentario1"    UniqueName="comentario1">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="materialcritico"                                                                                            HeaderStyle-Width="18%" FilterControlAltText="Filter materialcritico column" HeaderText="Critical Material"  SortExpression="materialcritico" UniqueName="materialcritico" ReadOnly="True">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="revision1"              UniqueName="revision1"                 HeaderText="Qty Required (Revision 1)"       HeaderStyle-Width="10%"    ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Int32"         FilterControlAltText="Filter revision1 column"              SortExpression="revision1"                  DataFormatString="{0:N0}"   Aggregate="Sum"     FooterAggregateFormatString="{0:N0}" >
                    </telerik:GridBoundColumn>                    
                    <telerik:GridBoundColumn DataField="revision3"              UniqueName="revision3"                 HeaderText="Qty Required (Revision 3)"       HeaderStyle-Width="8%"     ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Int32"         FilterControlAltText="Filter revision3 column"              SortExpression="revision3"                  DataFormatString="{0:N0}"   Aggregate="Sum"     FooterAggregateFormatString="{0:N0}" >
                    </telerik:GridBoundColumn> 
                    <telerik:GridBoundColumn DataField="qty_built"              UniqueName="qty_built"                 HeaderText="Qty Built"                       HeaderStyle-Width="8%"     ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Decimal"       FilterControlAltText="Filter qty_built column"              SortExpression="qty_built"                  DataFormatString="{0:N0}"   Aggregate="Sum"     FooterAggregateFormatString="{0:N0}" >
                    </telerik:GridBoundColumn>
                    <Telerik:GridBoundColumn DataField="percent_complete"       UniqueName="percent_complete"          HeaderText="Percent Complete"                HeaderStyle-Width="8%"     ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Decimal"       FilterControlAltText="Filter percent_complete"              SortExpression="percent_complete"           DataFormatString="{0:P0}"   Aggregate="Avg"     FooterAggregateFormatString="{0:P0}">
                    </Telerik:GridBoundColumn>
                    
<%--                <telerik:GridBoundColumn DataField="qty_remaining_to_approve" UniqueName="qty_remaining_to_approve"     HeaderText="Remaining to Approve"       HeaderStyle-Width="8%"     ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Decimal"       FilterControlAltText="Filter qty_remaining_to_approve column"    SortExpression="qty_remaining_to_approve"    DataFormatString="{0:N0}"   Aggregate="Sum"     FooterAggregateFormatString="{0:N0}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="qty_remaining_to_build" UniqueName="qty_remaining_to_build"     HeaderText="Remaining to Build"             HeaderStyle-Width="8%"     ItemStyle-HorizontalAlign="Right"    FooterStyle-HorizontalAlign="Right"     DataType="System.Decimal"       FilterControlAltText="Filter qty_remaining_to_build column" SortExpression="qty_remaining_to_build"     DataFormatString="{0:N0}"   Aggregate="Sum"     FooterAggregateFormatString="{0:N0}">
                    </telerik:GridBoundColumn>--%>
                   

                    
<%--                <Telerik:GridTemplateColumn UniqueName ="graph" DataField="qty_remaining_to_build" >
                        <ItemTemplate>
                            <Telerik:RadHtmlChart ID="RadHtmlChart1" runat="server" DataSourceID="SDS_ContainerProgress">
                                <PlotArea>
                                    <XAxis DataLabelsField="part">

                                    </XAxis>
                                    <YAxis Name="Part" Step="1" Visible="True" >
                                    </YAxis>
                                    <Series>
                                        <telerik:BulletSeries AxisName="Quantity" DataCurrentField="QTY_REMAINING_TO_BUILD" DataTargetField="REVISION3" Name="BulletSeries1">                  
                                            <Target>
                                                <Border DashType="Solid" />
                                            </Target>
                                        </telerik:BulletSeries>
                                    </Series>
                                </PlotArea>
                            </Telerik:RadHtmlChart>
                        </ItemTemplate>
                    </Telerik:GridTemplateColumn>--%>
                    
                </Columns>
            </MasterTableView>
    </Telerik:RadGrid>
    <asp:SqlDataSource ID="SDS_ContainerProgress" runat="server" ConnectionString="<%$ ConnectionStrings:EEHMONITORConnectionString %>" SelectCommand="eeiuser.acctg_scheduling_container_progress" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="RadComboBox1" Name="ContainerWeek" PropertyName="SelectedValue" Type="Int32" />
                    
                </SelectParameters>
    </asp:SqlDataSource>
 

<%--
    <br />
    <br />

    <asp:Chart ID="Chart1" runat="server" DataSourceID="SDS_ContainerProgress" ImageStorageMode="UseImageLocation" ImageLocation="~/Images"  Height="12000px" Width="800px">
        <series>
            <asp:Series ChartType="StackedBar100" Name="Series1" XValueMember="part" YValueMembers="qty_built">
          </asp:Series>
            <asp:Series ChartType="StackedBar100" Name="Series2" XValueMember="part" YValueMembers="qty_remaining_to_build">

            </asp:Series>
        </series>
     
        <chartareas>
            <asp:ChartArea Name="ChartArea1"  >
                <AxisX IntervalType="NotSet" Interval="1"></AxisX>
                <AxisY Minimum="0" Maximum="100" Title="percentage complete"></AxisY>
            </asp:ChartArea>
        </chartareas>
    </asp:Chart>--%>
        </div>
    </form>
</body>
</html>
