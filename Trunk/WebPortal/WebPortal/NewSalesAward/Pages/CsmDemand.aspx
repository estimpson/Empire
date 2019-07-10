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

        function grid_BeginCallback(s, e) {

        }
        function grid_EndCallback(s, e) {
            
        }

        function OnGetSelectedFieldValues(selectedValues) {
            alert(selectedValues.length);
            if (selectedValues.length == 0) {
                lp.Hide();
                return;
            }

            var s = "";
            s = selectedValues[0];
            alert(s);
            lp.Hide();

            //for (i = 0; i < selectedValues.length; i++) {

            //    for (j = 0; j < selectedValues[i].length; j++) {
            //        s = s + selectedValues[i][j] + "&nbsp;";
            //    }
            //}
            //alert(s);
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
                    <dx:ASPxButton ID="btnClose" runat="server" Text="" RenderMode="Link" ToolTip="Close" OnClick="btnClose_Click" Visible="false">
                        <Image IconID="actions_close_32x32gray" />
                    </dx:ASPxButton>
                </div>
                


                <div style="float: left; width: 380px;">

                    <div id="divAssignMnemonic" runat="server">

                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblBasePart" runat="server" Text="Base Part:" Width="125" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxBasePart" runat="server" Width="194" ReadOnly="true" ClientEnabled="false" DisabledStyle-ForeColor="Black" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblMnemonic" runat="server" Text="Mnemonics:" />
                                </td>
                                <td>
                                    <dx:ASPxMemo ID="memoMnemonic" runat="server" Width="194" ReadOnly="true" ClientEnabled="false" Height="100" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblQtyPer" runat="server" Text="Qty Per:" Font-Bold="true" />
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
                                    <dx:ASPxLabel ID="lblFamilyAllocation" runat="server" Text="Family Allocation:" Font-Bold="true" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxFamilyAllocation" runat="server" Width="194">
                                        <ValidationSettings Display="Dynamic" ErrorText="" ErrorTextPosition="Right" SetFocusOnError="True" ValidationGroup="G">
                                            <RequiredField ErrorText="" IsRequired="True" />
                                            <RegularExpression ErrorText="" ValidationExpression="^[0-9]+(\.[0-9]{1,6})?$" />
                                        </ValidationSettings>
                                        <InvalidStyle BackColor="LightPink" />
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblCurrentTakeRate" runat="server" Text="Take Rate:" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxCurrentTakeRate" runat="server" Width="194">
                                         <ValidationSettings SetFocusOnError="True" ErrorText="" Display="Dynamic" ErrorTextPosition="Right" ValidationGroup="G">
                                            <RequiredField IsRequired="True" ErrorText="" />
                                            <RegularExpression ValidationExpression="^[0-9]+(\.[0-9]{1,6})?$" ErrorText="" />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <div style="margin-top: 3px;">
                                        <dx:ASPxButton ID="btnUpdateMnemonic" runat="server" AutoPostBack="false" OnClick="btnUpdateMnemonic_Click" Text="Update Mnemonics" ValidationGroup="G" Width="194">
                                        </dx:ASPxButton>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <div style="margin-top: 7px;">
                                        <dx:ASPxLabel ID="lblUpdateMnemonicsInstruct" runat="server" Text="** If Qty Per or Family Allocation are changed, then update all selected mnemonics." Font-Size="10" ForeColor="DarkGray"></dx:ASPxLabel>
                                    </div>        
                                </td>
                            </tr>
                        </table>

                        <dx:ASPxGlobalEvents ID="ASPxGlobalEvents1" runat="server">
                            <ClientSideEvents ValidationCompleted="function(s, e) {if (e.isValid) {lp.Show();}}" />
                        </dx:ASPxGlobalEvents>

                    </div>



                    <div style="margin-top: 45px;">
                        <table class="tbl">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblSpace" runat="server" Text="" Width="125" />
                                </td>
                                <td>
                                    <dx:ASPxLabel ID="lblCalcTakeRateTitle1" runat="server" Text="Calculated Take Rate" Font-Size="14" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblQuotedEauCalc" runat="server" Text="Quoted EAU:" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxQuotedEauCalc" runat="server" ReadOnly="true" DisplayFormatString="{0:N}" Width="194">
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblAwardedEauCalc" runat="server" Text="or Awarded EAU:" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxAwardedEauCalc" runat="server" ReadOnly="true" DisplayFormatString="{0:N}" Width="194">
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblQtyPerCalc" runat="server" Text="/ (Qty Per:" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxQtyPerCalc" runat="server" ReadOnly="true" Width="194">
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblFamilyAllocationCalc" runat="server" Text="* Family Allocation:" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxFamilyAllocationCalc" runat="server" ReadOnly="true" Width="194">
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblForecastDemanCalc" runat="server" Text="* Forecast Demand):" ToolTip="Summarized value derived from the selected mnemonic with the maximum CSM_SOP." ForeColor="Green" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxForecastDemandCalc" runat="server" ReadOnly="true" DisplayFormatString="{0:N}" Width="194">
                                    </dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblTakeRateCalc" runat="server" Text="= Take Rate:" Font-Bold="true" />
                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="tbxCalculatedTakeRate" runat="server" ReadOnly="true" Width="194" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <dx:ASPxButton ID="btnUseTakeRate" runat="server" Text ="Use Take Rate" OnClick="btnUseTakeRate_Click" Width="194" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <div style="margin-top: 7px;">
                                        <dx:ASPxLabel ID="lblUseTakeRateInstruct" runat="server" Text="** Take rate will be applied to all selected mnemonics. (Update Mnemonics does not need to be clicked after clicking Use Take Rate.)" Font-Size="10" ForeColor="DarkGray"></dx:ASPxLabel>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>

                </div>







                <div id="divMnemonicGrid" runat="server" style="float: left;">

                    <dx:ASPxGridView ID="gvCsmData" runat="server" ClientInstanceName="gvCsmData" AutoGenerateColumns="False" Width="1640"
                        DataSourceID="odsCsmData" KeyFieldName="RowID" OnSelectionChanged="gvCsmData_SelectionChanged"
                        EnableCallBacks="false" EnableRowsCache="true" OnDataBound="gvCsmData_DataBound">
                        <Styles>
                            <Cell>
                                <Paddings PaddingTop="1px" PaddingBottom="1px" />
                            </Cell>
                        </Styles>
                        <Columns>
                            <dx:GridViewCommandColumn Caption="Add / Remove" ShowSelectCheckbox="true" VisibleIndex="0" HeaderStyle-Wrap="True" Width="65" />
                            <dx:GridViewDataTextColumn FieldName="SourcePlantCountry" Caption="Source Plant Country" Width="110" VisibleIndex="1" HeaderStyle-Wrap="True" />
                            <dx:GridViewDataTextColumn FieldName="SourcePlant" Width="140" VisibleIndex="2" />
                            <dx:GridViewDataTextColumn FieldName="VehiclePlantMnemonic" Caption="Vehicle Plant Mnemonic" Width="100" VisibleIndex="3" HeaderStyle-Wrap="True"/>
                            <dx:GridViewDataTextColumn FieldName="Manufacturer" Width="115" VisibleIndex="4" />
                            <dx:GridViewDataTextColumn FieldName="Platform" Width="125" VisibleIndex="5" />
                            <dx:GridViewDataTextColumn FieldName="Program" Width="125" VisibleIndex="6" />
                            <dx:GridViewDataTextColumn FieldName="Vehicle" Width="120" VisibleIndex="7" />
                            <dx:GridViewDataDateColumn FieldName="CSM_SOP" Width="105" VisibleIndex="8">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="CSM_EOP" Width="105" VisibleIndex="9">
                                <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd" />
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="DemandYear1" Width="110" VisibleIndex="10" HeaderStyle-Wrap="True" />
                            <dx:GridViewDataTextColumn FieldName="DemandYear2" Width="110" VisibleIndex="11" HeaderStyle-Wrap="True" />
                            <dx:GridViewDataTextColumn FieldName="DemandYear3" Width="110" VisibleIndex="12" HeaderStyle-Wrap="True" />
                            <dx:GridViewCommandColumn Caption=" " ShowClearFilterButton="true" ShowApplyFilterButton="true" VisibleIndex="13" />
                            <dx:GridViewDataTextColumn FieldName="ActiveFlag" Width="10" VisibleIndex="14" Visible="true" />
                            <dx:GridViewDataTextColumn FieldName="RowID" Width="10" VisibleIndex="15" Visible="false" />
                        </Columns>

                        <Settings ShowFilterRow="true" />
                        <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="VirtualSmooth" />
                        <Settings VerticalScrollableHeight="400" />
                        <Settings HorizontalScrollBarMode="Auto" />
                        <SettingsBehavior AllowSelectByRowClick="false" />
                        <SettingsBehavior AllowSelectSingleRowOnly="true" />
                        <SettingsBehavior AllowFocusedRow="false" />
                        <SettingsBehavior AutoExpandAllGroups="true" />
                        <SettingsSearchPanel Visible="false" ColumnNames="QuoteNumber; BasePart" />
                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="DataAware" />
                        <SettingsPager PageSize="20" />
                        <SettingsBehavior ProcessFocusedRowChangedOnServer="true" />
                        <SettingsBehavior ProcessSelectionChangedOnServer="true" />

                        <ClientSideEvents BeginCallback="grid_BeginCallback" EndCallback="grid_EndCallback" />
                     
                        
                       
                    </dx:ASPxGridView>
                    <script type="text/javascript">
                        ASPxClientControl.GetControlCollection().BrowserWindowResized.AddHandler(function (s, e) {
                            updateGridHeight();
                        });
                    </script>

                    <asp:EntityDataSource ID="edsCsmData" runat="server" ConnectionString="name=FxPLMEntities" DefaultContainerName="FxPLMEntities" EnableFlattening="False"
                        EntitySetName="CSMDatas" Select="it.[VehiclePlantMnemonic], it.[Platform], it.[Program], it.[Vehicle], it.[Manufacturer], it.[SourcePlant], it.[SourcePlantCountry], it.[SourcePlantRegion], it.[CSM_SOP], it.[CSM_EOP], it.[RowID], it.[ActiveFlag]">
                    </asp:EntityDataSource>

                    <asp:EntityDataSource ID="edsCsmData2" runat="server" ContextTypeName="WebPortal.NewSalesAward.PageViewModels.CsmDemandViewModel" 
                        EntitySetName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuoteCSMData_Result" EnableFlattening="false">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="QuoteNumber" Type="String" Name="quote" />
                        </SelectParameters>
                    </asp:EntityDataSource>

                    <dx:EntityServerModeDataSource ID="EntityServerModeDataSource" runat="server"
                        ContextTypeName="DevExpress.Web.Demos.LargeDatabaseContext" TableName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuoteCSMData_Result" />




                    <asp:ObjectDataSource ID="odsCsmData" runat="server" SelectMethod="GetAwardedQuoteCSMData" TypeName="WebPortal.NewSalesAward.PageViewModels.CsmDemandViewModel" 
                        UpdateMethod="" DataObjectTypeName="WebPortal.NewSalesAward.Models.usp_GetAwardedQuoteCSMData_Result">   
                        <SelectParameters>
                            <asp:SessionParameter SessionField="QuoteNumber" Type="String" Name="quote" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>

          

                  </div>

                <div style="display: none;">
                    <dx:ASPxButton ID="btnHid" ClientInstanceName="btnHid" runat="server" AutoPostBack="False" Text="" UseSubmitBehavior="False" OnClick="btnHid_Click">
                    
                    </dx:ASPxButton>
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