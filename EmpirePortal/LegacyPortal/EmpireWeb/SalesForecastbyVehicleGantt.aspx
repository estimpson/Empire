<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastbyVehicleGantt.aspx.cs" Inherits="SalesForecast" %>

<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"   %>


<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI.Gantt" tagprefix="cc1" %>

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
        .gantt-container 
        {
            padding: 0 0px 0px 0;
            height: 100%;
            width: 100%;
            box-sizing: border-box;
            min-width="800px"
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
<%--    <telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="VehicleComboBox">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <asp:Panel ID="Panel1" runat="server">--%>
        <div>
            <!-- BASE PART DROP DOWN -->

            <strong>Choose Vehicle:&nbsp;&nbsp;</strong>
            
            <telerik:RadComboBox ID="VehicleComboBox" runat="server" DataSourceID="VehicleComboBoxDataSource"
                DataTextField="Vehicle" DataValueField="Vehicle" MarkFirstMatch="True" Width="250px" AutoPostBack="True" Filter="Contains">
            </telerik:RadComboBox>
            
            <asp:SqlDataSource ID="VehicleComboBoxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>"
                SelectCommand="select distinct(vehicle) as vehicle from eeiuser.acctg_csm_vw_select_sales_forecast where vehicle is not null order by vehicle">
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
         </div>
        <div class="gantt-container">
            <telerik:RadGantt RenderMode="Lightweight" ID="RadGantt1"  
                runat="server" 
                DataSourceID="GanttTasksDataSource"
                DependenciesDataSourceId="GanttDependenciesDataSource"
                AutoGenerateColumns="False"
                ReadOnly="True"
                SelectedView="YearView"
                CurrentTimeMarkerInterval="5000"
                YearView-RangeStart="1/1/2012"
                YearView-RangeEnd="12/31/2021"
                AllowColumnResize="True"
                Font-Size="Small"  
                Skin="Windows7" 
                OnLoad="Page_Load"
                 Height="875px"
                ListWidth="650px" 
                Width="100%">
                <DataBindings>
                    <TasksDataBindings IdField="ID" ParentIdField="ParentID" StartField="Start" EndField="End" OrderIdField="OrderID" TitleField="Title" SummaryField="Summary" />
                    <DependenciesDataBindings IdField="ID" SuccessorIdField="SuccessorID" PredecessorIdField="PredecessorID" TypeField="Type"/>
                </DataBindings>
               
                <Columns>
                    <Telerik:GanttBoundColumn DataField="Title" DataType="String" Width="490px"/>
                    <Telerik:GanttBoundColumn DataField="Start" DataType="DateTime" HeaderText="SOP" DataFormatString="MM/dd/yyyy" Width="80px"/>
                    <telerik:GanttBoundColumn DataField="End" DataType="DateTime" HeaderText="EOP" DataFormatString="MM/dd/yyyy" Width="80px"/>
                </Columns> 

                <YearView UserSelectable="true" SlotWidth="10px"  MonthHeaderDateFormat="m" />
                <MonthView UserSelectable="false" />
                <WeekView UserSelectable="false" />
                <DayView UserSelectable="false" />
                
            </telerik:RadGantt>      
            
            <asp:SqlDataSource  ID="GanttTasksDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="select * from eeiuser.acctg_csm_GanttTasks where id != -1 and vehicle = @vehicle and title is not null " SelectCommandType="Text" >
           
                <SelectParameters>
                    <asp:ControlParameter ControlID="VehicleComboBox" Name="vehicle" PropertyName="SelectedValue" Type="String" DefaultValue="Cadillac CTS" />
                </SelectParameters>
            </asp:SqlDataSource>
          
            <asp:SqlDataSource  ID="GanttDependenciesDataSource" 
                                runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MONITORConnectionString %>" 
                                SelectCommand="select * from eeiuser.acctg_csm_GanttDependencies where id in (select id from eeiuser.acctg_csm_ganttTasks where id != -1 and vehicle = @vehicle2) " SelectCommandType="Text" >
           
                <SelectParameters>
                    <asp:ControlParameter ControlID="VehicleComboBox" Name="vehicle2" PropertyName="SelectedValue" Type="String" DefaultValue="Cadillac CTS" />
                </SelectParameters>
            </asp:SqlDataSource>
       
        </div>
<%--    </asp:Panel>--%>
    </form>
</body>
</html>
, 