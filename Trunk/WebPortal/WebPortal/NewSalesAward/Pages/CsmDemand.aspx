<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/Site.Master" CodeBehind="CsmDemand.aspx.cs" Inherits="WebPortal.NewSalesAward.Pages.CsmDemand" %>

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
            gvCsmData.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            gvCsmData.SetHeight(containerHeight - 130);

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

            gvCsmData.PerformCallback("ClearSort");
        }

    </script>

</asp:Content>



<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="CSM Demand"></asp:Label>
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



             
            <div id="divMain" runat="server" style="border: 0px solid black; overflow: hidden; margin-bottom: 10px; width: 2200px;">

                <div>
                    <dx:ASPxButton ID="btnClose" runat="server" Text="" RenderMode="Link" ToolTip="Close" OnClick="btnClose_Click">
                        <Image IconID="actions_close_32x32gray" />
                    </dx:ASPxButton>
                </div>
                

                <div id="divAssignMnemonic" runat="server" style="float:left; width: 330px;">

                    <table class="tbl">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblBasePart" runat="server" Text="Base Part:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxBasePart" runat="server" Width="194" ReadOnly="true" ClientEnabled="false" DisabledStyle-ForeColor="Black" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblMnemonic" runat="server" Text="Mnemonic:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxMnemonic" runat="server" Width="194">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblQtyPer" runat="server" Text="Qty Per:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxQtyPer" runat="server" Width="194">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                        <RegularExpression ValidationExpression="^[0-9]+(\.[0-9]{1,4})?$" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblTakeRate" runat="server" Text="Take Rate:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxTakeRate" runat="server" Width="194">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                        <RegularExpression ValidationExpression="^[0-9]+(\.[0-9]{1,6})?$" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblFamilyAllocation" runat="server" Text="Family Allocation:" />
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="tbxFamilyAllocation" runat="server" Width="194">
                                    <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                        <RequiredField IsRequired="True" ErrorText="" />
                                        <RegularExpression ValidationExpression="^[0-9]+(\.[0-9]{1,6})?$" ErrorText="" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <div style="margin-top: 3px;">
                                    <dx:ASPxButton ID="btnAssignMnemonic" runat="server" Text="Assign Mnemonic" AutoPostBack="false" OnClick="btnAssignMnemonic_Click" ValidationGroup="G" Width="194">   
                                    </dx:ASPxButton>

                                    <div style="margin-bottom: 5px;">
                                        <dx:ASPxButton ID="btnUpdateMnemonic" runat="server" Text="Update Mnemonic" AutoPostBack="false" OnClick="btnUpdateMnemonic_Click" ValidationGroup="G" Width="194">
                                        </dx:ASPxButton>
                                    </div>
                                    <dx:ASPxButton ID="btnRemoveMnemonic" runat="server" Text="Remove Mnemonic" AutoPostBack="false" OnClick="btnRemoveMnemonic_Click" Width="194">
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                    </table>

                    <dx:ASPxGlobalEvents ID="ASPxGlobalEvents1" runat="server">
                        <ClientSideEvents ValidationCompleted="function(s, e) {if (e.isValid) {lp.Show();}}" />
                    </dx:ASPxGlobalEvents>

                </div>

                <div id="divMnemonicGrid" runat="server" style="float: left;">

                    <dx:ASPxGridView ID="gvCsmData" runat="server" ClientInstanceName="gvCsmData" AutoGenerateColumns="False" Width="1790"
                        DataSourceID="odsCsmData" KeyFieldName="VehiclePlantMnemonic" OnFocusedRowChanged="gvCsmData_FocusedRowChanged" 
                        EnableCallBacks="false" EnableRowsCache="true" OnDataBound="gvCsmData_DataBound">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="1px" PaddingBottom="1px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="VehiclePlantMnemonic" Width="200" VisibleIndex="0" />
                            <dx:GridViewDataTextColumn FieldName="Platform" Width="140" VisibleIndex="1" />
                            <dx:GridViewDataTextColumn FieldName="Program" Width="140" VisibleIndex="2" />
                            <dx:GridViewDataTextColumn FieldName="Vehicle" Width="140" VisibleIndex="3" />
                            <dx:GridViewDataTextColumn FieldName="Manufacturer" Width="140" VisibleIndex="4" />
                            <dx:GridViewDataTextColumn FieldName="SourcePlant" Width="140" VisibleIndex="5" />
                            <dx:GridViewDataTextColumn FieldName="SourcePlantCountry" Width="200" VisibleIndex="6" />
                            <dx:GridViewDataTextColumn FieldName="SourcePlantRegion" Width="200" VisibleIndex="7" />
                            <dx:GridViewDataDateColumn FieldName="CSM_SOP" Width="140" VisibleIndex="8">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="CSM_EOP" Width="140" VisibleIndex="9">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="ActiveFlag" Width="90" VisibleIndex="10" SortIndex="1" />
                            <dx:GridViewCommandColumn ShowClearFilterButton="true" ShowApplyFilterButton="true" VisibleIndex="11" />
                        </Columns>

                        <Settings ShowFilterRow="true" />
                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <Settings HorizontalScrollBarMode="Auto" />
                        <SettingsBehavior AllowSelectByRowClick="true" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsBehavior AutoExpandAllGroups="true" />
                        <SettingsSearchPanel Visible="false" ColumnNames="QuoteNumber; BasePart" />
                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="DataAware" />
                        <SettingsPager PageSize="30"></SettingsPager>
                        <SettingsEditing Mode="Inline"></SettingsEditing>
                        <SettingsBehavior ProcessFocusedRowChangedOnServer="true" />
                    </dx:ASPxGridView>
                    <script type="text/javascript">
                        ASPxClientControl.GetControlCollection().BrowserWindowResized.AddHandler(function (s, e) {
                            updateGridHeight();
                        });
                    </script>

                    <asp:EntityDataSource ID="edsCsmData" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False" EntitySetName="CSMDatas" Select="it.[VehiclePlantMnemonic], it.[Platform], it.[Program], it.[Vehicle], it.[Manufacturer], it.[SourcePlant], it.[SourcePlantCountry], it.[SourcePlantRegion], it.[CSM_SOP], it.[CSM_EOP]">
                    </asp:EntityDataSource>

                    <asp:ObjectDataSource ID="odsCsmData" runat="server" SelectMethod="GetAwardedQuoteCSMData" TypeName="WebPortal.NewSalesAward.PageViewModels.CsmDemandViewModel" 
                        UpdateMethod="" DataObjectTypeName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuoteCSMData_Result">   
                        <SelectParameters>
                            <asp:SessionParameter SessionField="QuoteNumber" Type="String" Name="quote" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>

            </div>


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


            </ContentTemplate>
                
            </asp:UpdatePanel>



        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>



</asp:Content>