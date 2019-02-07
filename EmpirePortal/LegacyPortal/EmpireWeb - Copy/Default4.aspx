<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default4.aspx.cs" Inherits="Default4" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>

<%@ Register assembly="DevExpress.Web.v13.2, Version=13.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        </telerik:RadStyleSheetManager>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>   
        

            <telerik:RadAjaxManager ID="RadAjaxManager2" runat="server">
                <AjaxSettings>            
                <telerik:AjaxSetting AjaxControlID="DropDownList1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ASPxGridView1" />
                    <telerik:AjaxUpdatedControl ControlID="SqlDataSource2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
            </telerik:RadAjaxManager>
          <div>
    Select Data as of:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           
              <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource1" DataTextField="asofdate" DataValueField="asofdate" DataTextFormatString="{0:yyyy-MM-dd H:mm:ss.fff}" Height="20px" Width="143px">
              </asp:DropDownList>
           
       &nbsp;<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:EEHConnectionString %>" SelectCommand="select distinct(asofdate) as asofdate from eeiuser.acctg_inv_age_review order by asofdate desc"></asp:SqlDataSource>
           
              <telerik:RadGrid ID="RadGrid1" runat="server" AllowFilteringByColumn="True" AllowSorting="True" DataSourceID="SqlDataSource2">
                  <ClientSettings AllowColumnsReorder="True">
                  </ClientSettings>
                  <MasterTableView AutoGenerateColumns="False" DataKeyNames="asofdate,receivedfiscalyear,receivedperiod,part" DataSourceID="SqlDataSource2">
                      <Columns>
                          <telerik:GridBoundColumn DataField="asofdate" DataType="System.DateTime" FilterControlAltText="Filter asofdate column" HeaderText="asofdate" ReadOnly="True" SortExpression="asofdate" UniqueName="asofdate">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="receivedfiscalyear" DataType="System.Int32" FilterControlAltText="Filter receivedfiscalyear column" HeaderText="receivedfiscalyear" ReadOnly="True" SortExpression="receivedfiscalyear" UniqueName="receivedfiscalyear">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="receivedperiod" DataType="System.Int32" FilterControlAltText="Filter receivedperiod column" HeaderText="receivedperiod" ReadOnly="True" SortExpression="receivedperiod" UniqueName="receivedperiod">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="default_vendor" FilterControlAltText="Filter default_vendor column" HeaderText="default_vendor" SortExpression="default_vendor" UniqueName="default_vendor">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="part" FilterControlAltText="Filter part column" HeaderText="part" ReadOnly="True" SortExpression="part" UniqueName="part">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="part_name" FilterControlAltText="Filter part_name column" HeaderText="part_name" SortExpression="part_name" UniqueName="part_name">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="commodity" FilterControlAltText="Filter commodity column" HeaderText="commodity" SortExpression="commodity" UniqueName="commodity">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="quantity" DataType="System.Decimal" FilterControlAltText="Filter quantity column" HeaderText="quantity" SortExpression="quantity" UniqueName="quantity">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="ext_material_cum" DataType="System.Decimal" FilterControlAltText="Filter ext_material_cum column" HeaderText="ext_material_cum" SortExpression="ext_material_cum" UniqueName="ext_material_cum">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="std_pack" DataType="System.Decimal" FilterControlAltText="Filter std_pack column" HeaderText="std_pack" SortExpression="std_pack" UniqueName="std_pack">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="min_order_qty" DataType="System.Decimal" FilterControlAltText="Filter min_order_qty column" HeaderText="min_order_qty" SortExpression="min_order_qty" UniqueName="min_order_qty">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="min_empire_sop" DataType="System.DateTime" FilterControlAltText="Filter min_empire_sop column" HeaderText="min_empire_sop" SortExpression="min_empire_sop" UniqueName="min_empire_sop">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="max_empire_eop" DataType="System.DateTime" FilterControlAltText="Filter max_empire_eop column" HeaderText="max_empire_eop" SortExpression="max_empire_eop" UniqueName="max_empire_eop">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="fg_on_hand" DataType="System.Decimal" FilterControlAltText="Filter fg_on_hand column" HeaderText="fg_on_hand" SortExpression="fg_on_hand" UniqueName="fg_on_hand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="FG_Net_20_Wk_Demand" DataType="System.Decimal" FilterControlAltText="Filter FG_Net_20_Wk_Demand column" HeaderText="FG_Net_20_Wk_Demand" SortExpression="FG_Net_20_Wk_Demand" UniqueName="FG_Net_20_Wk_Demand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="FG_Net_Avg_Wk_Demand" DataType="System.Decimal" FilterControlAltText="Filter FG_Net_Avg_Wk_Demand column" HeaderText="FG_Net_Avg_Wk_Demand" SortExpression="FG_Net_Avg_Wk_Demand" UniqueName="FG_Net_Avg_Wk_Demand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="RM_Net_20_Wk_Demand" DataType="System.Decimal" FilterControlAltText="Filter RM_Net_20_Wk_Demand column" HeaderText="RM_Net_20_Wk_Demand" SortExpression="RM_Net_20_Wk_Demand" UniqueName="RM_Net_20_Wk_Demand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="RM_Net_Avg_Wk_Demand" DataType="System.Decimal" FilterControlAltText="Filter RM_Net_Avg_Wk_Demand column" HeaderText="RM_Net_Avg_Wk_Demand" SortExpression="RM_Net_Avg_Wk_Demand" UniqueName="RM_Net_Avg_Wk_Demand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="weeks_to_exhaust" DataType="System.Decimal" FilterControlAltText="Filter weeks_to_exhaust column" HeaderText="weeks_to_exhaust" SortExpression="weeks_to_exhaust" UniqueName="weeks_to_exhaust">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="exhaust_date" DataType="System.DateTime" FilterControlAltText="Filter exhaust_date column" HeaderText="exhaust_date" SortExpression="exhaust_date" UniqueName="exhaust_date">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="classification" FilterControlAltText="Filter classification column" HeaderText="classification" SortExpression="classification" UniqueName="classification">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="on_hold" FilterControlAltText="Filter on_hold column" HeaderText="on_hold" SortExpression="on_hold" UniqueName="on_hold">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="active_demand" FilterControlAltText="Filter active_demand column" HeaderText="active_demand" SortExpression="active_demand" UniqueName="active_demand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="max_date_material_issued" DataType="System.DateTime" FilterControlAltText="Filter max_date_material_issued column" HeaderText="max_date_material_issued" SortExpression="max_date_material_issued" UniqueName="max_date_material_issued">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="category" FilterControlAltText="Filter category column" HeaderText="category" SortExpression="category" UniqueName="category">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="active_where_used" FilterControlAltText="Filter active_where_used column" HeaderText="active_where_used" SortExpression="active_where_used" UniqueName="active_where_used">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="service_where_used" FilterControlAltText="Filter service_where_used column" HeaderText="service_where_used" SortExpression="service_where_used" UniqueName="service_where_used">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="inactive_where_used" FilterControlAltText="Filter inactive_where_used column" HeaderText="inactive_where_used" SortExpression="inactive_where_used" UniqueName="inactive_where_used">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="note" FilterControlAltText="Filter note column" HeaderText="note" SortExpression="note" UniqueName="note">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="review_note" FilterControlAltText="Filter review_note column" HeaderText="review_note" SortExpression="review_note" UniqueName="review_note">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="assigned_party" FilterControlAltText="Filter assigned_party column" HeaderText="assigned_party" SortExpression="assigned_party" UniqueName="assigned_party">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="corrective_action" FilterControlAltText="Filter corrective_action column" HeaderText="corrective_action" SortExpression="corrective_action" UniqueName="corrective_action">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridCheckBoxColumn DataField="at_risk" DataType="System.Boolean" FilterControlAltText="Filter at_risk column" HeaderText="at_risk" SortExpression="at_risk" UniqueName="at_risk">
                          </telerik:GridCheckBoxColumn>
                          <telerik:GridBoundColumn DataField="percent_total" DataType="System.Decimal" FilterControlAltText="Filter percent_total column" HeaderText="percent_total" SortExpression="percent_total" UniqueName="percent_total">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="RM_Net_104_WkDemand" DataType="System.Decimal" FilterControlAltText="Filter RM_Net_104_WkDemand column" HeaderText="RM_Net_104_WkDemand" SortExpression="RM_Net_104_WkDemand" UniqueName="RM_Net_104_WkDemand">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="Net_RM_104_Wk" DataType="System.Decimal" FilterControlAltText="Filter Net_RM_104_Wk column" HeaderText="Net_RM_104_Wk" SortExpression="Net_RM_104_Wk" UniqueName="Net_RM_104_Wk">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                          <telerik:GridBoundColumn DataField="Net_RM_104_Wk_Material" DataType="System.Decimal" FilterControlAltText="Filter Net_RM_104_Wk_Material column" HeaderText="Net_RM_104_Wk_Material" SortExpression="Net_RM_104_Wk_Material" UniqueName="Net_RM_104_Wk_Material">
                              <ColumnValidationSettings>
                                  <ModelErrorMessage Text="" />
                              </ColumnValidationSettings>
                          </telerik:GridBoundColumn>
                      </Columns>
                  </MasterTableView>
              </telerik:RadGrid>
           
       <br />
        <dx:ASPxGridView ID="ASPxGridView1" runat="server" DataSourceID="SqlDataSource2" AutoGenerateColumns="False" KeyFieldName="asofdate">
            <Columns>
                <dx:GridViewDataDateColumn FieldName="asofdate" ReadOnly="True" VisibleIndex="0">
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn FieldName="receivedfiscalyear" ReadOnly="True" VisibleIndex="1">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="receivedperiod" ReadOnly="True" VisibleIndex="2">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="default_vendor" VisibleIndex="3">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="part" ReadOnly="True" VisibleIndex="4">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="part_name" VisibleIndex="5">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="commodity" VisibleIndex="6">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="quantity" VisibleIndex="7">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ext_material_cum" VisibleIndex="8">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="std_pack" VisibleIndex="9">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="min_order_qty" VisibleIndex="10">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="min_empire_sop" VisibleIndex="11">
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataDateColumn FieldName="max_empire_eop" VisibleIndex="12">
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn FieldName="fg_on_hand" VisibleIndex="13">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="FG_Net_20_Wk_Demand" VisibleIndex="14">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="FG_Net_Avg_Wk_Demand" VisibleIndex="15">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="RM_Net_20_Wk_Demand" VisibleIndex="16">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="RM_Net_Avg_Wk_Demand" VisibleIndex="17">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="weeks_to_exhaust" VisibleIndex="18">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="exhaust_date" VisibleIndex="19">
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn FieldName="classification" VisibleIndex="20">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="on_hold" VisibleIndex="21">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="active_demand" VisibleIndex="22">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="max_date_material_issued" VisibleIndex="23">
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn FieldName="category" VisibleIndex="24">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="active_where_used" VisibleIndex="25">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="service_where_used" VisibleIndex="26">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="inactive_where_used" VisibleIndex="27">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="note" VisibleIndex="28">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="review_note" VisibleIndex="29">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="assigned_party" VisibleIndex="30">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="corrective_action" VisibleIndex="31">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataCheckColumn FieldName="at_risk" VisibleIndex="32">
                </dx:GridViewDataCheckColumn>
                <dx:GridViewDataTextColumn FieldName="percent_total" VisibleIndex="33">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="RM_Net_104_WkDemand" VisibleIndex="34">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Net_RM_104_Wk" VisibleIndex="35">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Net_RM_104_Wk_Material" VisibleIndex="36">
                </dx:GridViewDataTextColumn>
            </Columns>
            <SettingsBehavior AllowSelectByRowClick="True" ColumnResizeMode="Control" ConfirmDelete="True" />
            <SettingsPager Mode="ShowAllRecords"/>
            <SettingsEditing Mode="Batch">
                <BatchEditSettings EditMode="Row" StartEditAction="DblClick" />
            </SettingsEditing>
            <Settings ShowFilterBar="Visible" UseFixedTableLayout="True" VerticalScrollableHeight="600" VerticalScrollBarMode="Visible" ShowHeaderFilterButton="True" />
            <SettingsDataSecurity AllowInsert="False" AllowDelete="False"/>
        </dx:ASPxGridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:EEHConnectionString %>" SelectCommand="SELECT * FROM eeiuser.[acctg_inv_age_review] WHERE ([asofdate] = @asofdate)" ProviderName="<%$ ConnectionStrings:EEHConnectionString.ProviderName %>">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList1" Name="asofdate" PropertyName="SelectedValue" Type="DateTime" DefaultValue="2014-05-31 23:52:00.860"/>
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
        
    </form>
</body>
</html>
