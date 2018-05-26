<%@ Page Title="SalesForecastUpdated" EnableViewState="true" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SalesForecastUpdated.aspx.cs" Inherits="WebPortal.SalesForecast.Pages.SalesForecastUpdated" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">

    <script type="text/javascript">

        function pageLoad() {
            $(function () {
                updateGridHeight();
            });
        }

        function updateCheckBoxState(s, e) {
            //var checkState = s.GetCheckState();
            //var checked = s.GetChecked();
            //var checkBoxIDParts = s.name.split("_");
            //var checkBoxID = checkBoxIDParts[checkBoxIDParts.length - 1];
            //var checkedStateSpan = document.getElementById(checkBoxID + "CheckState");
            //var checkedSpan = document.getElementById(checkBoxID + "Checked");
            //checkedStateSpan.innerHTML = "CheckState = " + checkState;
            //checkedSpan.innerHTML = "Checked = " + checked;
        }

        function updateGridHeight() {
            gvSalesForecastUpdated.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            gvSalesForecastUpdated.SetHeight(containerHeight - 50);
        }

        var postponedCallbackRequired = false;
        function OnComboBoxIndexChanged(s, e) {
            if (CallbackPanel.InCallback())
                postponedCallbackRequired = true;
            else
                CallbackPanel.PerformCallback();
        }
        function OnEndCallback(s, e) {
            if (postponedCallbackRequired) {
                CallbackPanel.PerformCallback();
                postponedCallbackRequired = false;
            }
        }

        function RefreshGrid(s, e) {

            gvSalesForecastUpdated.PerformCallback("ClearSort");
        }

    </script>

</asp:Content>



<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Sales Forecast Updated"></asp:Label>
</asp:Content>



<asp:Content ID="contentBody" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" ClientInstanceName="lp" Modal="true">
        </dx:ASPxLoadingPanel>

    <dx:ASPxCallbackPanel ID="cbp1" runat="server" EnableCallbackAnimation="false" ClientInstanceName="CallbackPanel" SettingsLoadingPanel-Enabled="true">
    <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
    <PanelCollection>
        <dx:PanelContent ID="pc1" runat="server">


            <asp:UpdatePanel ID="updatePnl" runat="server">
            <ContentTemplate>

              

            <div style="margin-bottom: 0px; border: 0px solid red; height: 40px;">

                <div style="float: left; padding-top: 8px;">
                    <dx:ASPxLabel ID="lblEopYears" runat="server" Text="EOP:"></dx:ASPxLabel>
                </div>

                <div style="float: left; margin-left: 7px;">
                    <dx:ASPxComboBox ID="cbxEopYears" runat="server" ValueType="System.String" Width="90"
                        OnSelectedIndexChanged="cbxYear_SelectedIndexChanged" AutoPostBack="true">
                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
                        lp.Show();
                                 }" />
                    </dx:ASPxComboBox>
                </div>

                <div style="float: left; margin-left: 20px;">  
                    <div style="float: left;">
                        <dx:ASPxButton ID="btnShowAll" runat="server" AutoPostBack="true" 
                            GroupName="G" Text="Show All" Width="100%" OnCheckedChanged="btnShowAll_CheckedChanged">
                            <ClientSideEvents Click="function(s, e) {
                                lp.Show();  }" />
                        </dx:ASPxButton>
                    </div>
                    <div style="float: left;">
                        <dx:ASPxButton ID="btnVerifiedOnly" runat="server" AutoPostBack="true" GroupName="G"
                            Text="Verified Only" Width="100%" OnCheckedChanged="btnVerifiedOnly_CheckedChanged">
                            <ClientSideEvents Click="function(s, e) {
                                lp.Show();  }" />
                        </dx:ASPxButton>
                    </div>
                    <div style="float: left;">
                        <dx:ASPxButton ID="btnNonVerifiedOnly" runat="server" AutoPostBack="true" GroupName="G"
                            Text="Non-verified Only" Width="100%" OnCheckedChanged="btnNonVerifiedOnly_CheckedChanged">
                            <ClientSideEvents Click="function(s, e) {
                                lp.Show();  }" />
                        </dx:ASPxButton>
                    </div>
                </div>
        
                <div style="float: left; margin-left: 25px;">
                    <dx:ASPxButton ID="btnRefresh" runat="server" RenderMode="Link" AutoPostBack="false" ClientSideEvents-Click="function(s,e){RefreshGrid()}">
                        <Image IconID="actions_refresh_32x32gray" ToolTip="Clear sorting and grouping"></Image>
                    </dx:ASPxButton>
                </div>

                <div style="float: left; margin-left: 25px;">
                    <dx:ASPxButton ID="btnEx" runat="server" OnClick="btnEx_Click" RenderMode="Link">
                        <Image IconID="export_exporttoxlsx_32x32gray" ToolTip="Export to Excel"></Image>
                    </dx:ASPxButton>
                    <dx:ASPxGridViewExporter ID="gridExporter" runat="server" GridViewID="gvSalesForecastUpdated"></dx:ASPxGridViewExporter>
                </div>

            </div>



            <div>

                <dx:ASPxGridView ID="gvSalesForecastUpdated" runat="server" ClientInstanceName="gvSalesForecastUpdated" AutoGenerateColumns="False" SettingsBehavior-AllowGroup="true"
                    KeyFieldName="RowId" SettingsBehavior-AllowSort="true" Settings-ShowGroupPanel="true"
                    SettingsEditing-Mode="Inline" EnableRowsCache="False" OnCellEditorInitialize="gvSalesForecastUpdated_CellEditorInitialize"
                    OnCustomCallback="gvSalesForecastUpdated_CustomCallback" Width="98%" DataSourceID="ObjectDataSource1" > 
                    <Styles>
                        <Cell>
                            <Paddings PaddingTop="1px" PaddingBottom="1px" />
                        </Cell>
                    </Styles>
                    <Columns>
                        <dx:GridViewCommandColumn Caption=" " ShowNewButtonInHeader="false" ShowEditButton="true" VisibleIndex="0" Width="130" FixedStyle="Left">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn Caption="Status" FieldName="Status" Name="Status" VisibleIndex="1" Width="110" FixedStyle="Left">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="BasePart" FieldName="BasePart" Name="BasePart" VisibleIndex="2" Width="110" FixedStyle="Left">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="RowId" FieldName="RowId" Name="RowId" VisibleIndex="3" Width="120" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="ParentCustomer" FieldName="ParentCustomer" Name="ParentCustomer" VisibleIndex="4" Width="180" />
                        <dx:GridViewDataTextColumn Caption="Program" FieldName="Program" Name="Program" VisibleIndex="5" Width="100" />
                        <dx:GridViewDataTextColumn Caption="Vehicle" FieldName="Vehicle" Name="Vehicle" VisibleIndex="6" Width="170" />
                        <dx:GridViewDataDateColumn Caption="EmpireSop" FieldName="EmpireSop" Name="EmpireSop" VisibleIndex="7" Width="110">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn Caption="MidModelYear" FieldName="MidModelYear" Name="MidModelYear" VisibleIndex="8" Width="110">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn Caption="EmpireEop" FieldName="EmpireEop" Name="EmpireEop" VisibleIndex="9" Width="110">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataComboBoxColumn Caption="VerifiedEop" FieldName="VerifiedEop" Name="VerifiedEop" VisibleIndex="10" Width="180">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataDateColumn Caption="VerifiedEopDate" FieldName="VerifiedEopDate" Name="VerifiedEopDate" VisibleIndex="11" Width="130">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn Caption="EmpireEopNote" FieldName="EmpireEopNote" Name="EmpireEopNote" VisibleIndex="12" Width="350" />
                        <dx:GridViewDataDateColumn Caption="CsmSop" FieldName="CsmSop" Name="CsmSop" VisibleIndex="13" Width="110">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn Caption="CsmEop" FieldName="CsmEop" Name="CsmEop" VisibleIndex="14" Width="110">
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>

                        <dx:GridViewDataTextColumn Caption="Sales2016" FieldName="Sales2016" Name="Sales2016" VisibleIndex="15" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2017" FieldName="Sales2017" Name="Sales2017" VisibleIndex="16" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2018" FieldName="Sales2018" Name="Sales2018" VisibleIndex="17" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2019" FieldName="Sales2019" Name="Sales2019" VisibleIndex="18" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2020" FieldName="Sales2020" Name="Sales2020" VisibleIndex="19" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2021" FieldName="Sales2021" Name="Sales2021" VisibleIndex="20" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2022" FieldName="Sales2022" Name="Sales2022" VisibleIndex="21" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2023" FieldName="Sales2023" Name="Sales2023" VisibleIndex="22" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2024" FieldName="Sales2024" Name="Sales2024" VisibleIndex="23" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />
                        <dx:GridViewDataTextColumn Caption="Sales2025" FieldName="Sales2025" Name="Sales2025" VisibleIndex="24" Width="110" PropertiesTextEdit-DisplayFormatString ="{0:C}" />

                        <dx:GridViewDataComboBoxColumn Caption="SchedulerResponsible" FieldName="SchedulerResponsible" Name="SchedulerResponsible" VisibleIndex="25" Width="210">
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataTextColumn Caption="RfMpsLink" FieldName="RfMpsLink" Name="RfMpsLink" VisibleIndex="26" Width="110">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="SchedulingTeamComments" FieldName="SchedulingTeamComments" Name="SchedulingTeamComments" VisibleIndex="27" Width="200">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="MaterialsComments" FieldName="MaterialsComments" Name="MaterialsComments" VisibleIndex="28" Width="200">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="ShipToLocation" FieldName="ShipToLocation" Name="ShipToLocation" VisibleIndex="29" Width="150">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="FgInventoryAfterBuildout" FieldName="FgInventoryAfterBuildout" Name="FgInventoryAfterBuildout" VisibleIndex="30" Width="180">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="CostEach" FieldName="CostEach" Name="CostEach" VisibleIndex="31" Width="120">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="ExcessFgAfterBuildout" FieldName="ExcessFgAfterBuildout" Name="ExcessFgAfterBuildout" VisibleIndex="32" Width="180">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="ExcessRmAfterBuildout" FieldName="ExcessRmAfterBuildout" Name="ExcessRmAfterBuildout" VisibleIndex="33" Width="180">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="ProgramExposure" FieldName="ProgramExposure" Name="ProgramExposure" VisibleIndex="34" Width="140">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn Caption="DateToSendCoLetter" FieldName="DateToSendCoLetter" Name="DateToSendCoLetter" VisibleIndex="35" Width="260">
                            <HeaderStyle BackColor="#efefef" />
                            <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn Caption="ObsolescenceCost" FieldName="ObsolescenceCost" Name="ObsolescenceCost" VisibleIndex="36" Width="180" PropertiesTextEdit-DisplayFormatString ="{0:C}">
                            <HeaderStyle BackColor="#efefef" />
                        </dx:GridViewDataTextColumn>
                    </Columns>
                   
                    <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                    <Settings HorizontalScrollBarMode="Visible" />
                    <SettingsBehavior AllowSelectByRowClick="false" />
                    <SettingsBehavior AllowFocusedRow="true" />
                    <SettingsBehavior AutoExpandAllGroups="true" />
                    <SettingsSearchPanel Visible="true" ColumnNames="BasePart; ParentCustomer; Vehicle" />
                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="DataAware" />
                    <SettingsPager PageSize="30"></SettingsPager>
                    <SettingsEditing Mode="Inline"></SettingsEditing>

                </dx:ASPxGridView>
                   
                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetSf" TypeName="WebPortal.SalesForecast.PageViewModels.SalesForecastUpdatedViewModel" 
                    UpdateMethod="UpdateSf" DataObjectTypeName="WebPortal.SalesForecast.Models.GetSalesForecastUpdated_Result">   
                    <SelectParameters>
                        <asp:Parameter Name="eop" Type="Int32" />
                        <asp:Parameter Name="filter" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>


                
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnEx" />
                </Triggers>
            </asp:UpdatePanel>


        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>



        <div>
            <dx:ASPxPopupControl ID="pcError" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcError"
                HeaderText="Error Message" AllowDragging="True" PopupAnimationType="Fade" ForeColor="Red" EnableViewState="False" AutoUpdatePosition="true">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <div style="padding: 10px 20px 20px 20px;">
                            <dx:ASPxLabel ID="lblError" runat="server" Text=""></dx:ASPxLabel>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </div>


</asp:Content>