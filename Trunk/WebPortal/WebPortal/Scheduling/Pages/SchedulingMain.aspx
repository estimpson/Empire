<%@ Page Title="Scheduling" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SchedulingMain.aspx.cs" Inherits="WebPortal.Scheduling.Main" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content runat="server" ContentPlaceHolderID="CustomHeaderHolder">
    <script type="text/javascript">


        function pageLoad() {
            $(function () {
                updateGridHeight();
            });
        }
        

        function updateGridHeight() {
            sGrid.SetHeight(0);
            dGrid.SetHeight(0);

            var containerHeight = ASPxClientUtils.GetDocumentClientHeight();

            //alert(containerHeight);
            //alert(document.body.scrollHeight);


            //if (document.body.scrollHeight > containerHeight)
            //    containerHeight = document.body.scrollHeight;


            sGrid.SetHeight(containerHeight - 140);
            dGrid.SetHeight(containerHeight - 230);
        }



        function DoProcessKeyPress(htmlEvent, editName) {
            //if (htmlEvent.keyCode == 9) {
            //    ASPxClientUtils.PreventEventAndBubble(htmlEvent);

            //    //dGrid.PerformCallback();

            //    if (editName == 'OverrideCustRequirement')
            //    {
            //        btnHidOverrideCustRequirement.DoClick();
            //    }
            //    else if (editName == 'NewOnOrderEEH')
            //    {
            //        btnHidNewOnOrderEeh.DoClick();
            //    }
            //}

            
            if (htmlEvent.keyCode == 40)
            {
                if (editName == 'OverrideCustRequirement') {
                    btnHidOverrideCustRequirementDn.DoClick();
                }
                else if (editName == 'NewOnOrderEEH') {
                    btnHidNewOnOrderEehDn.DoClick();
                }
            }

            else if (htmlEvent.keyCode == 38)
            {
                if (editName == 'OverrideCustRequirement') {
                    btnHidOverrideCustRequirementUp.DoClick();
                }
                else if (editName == 'NewOnOrderEEH') {
                    btnHidNewOnOrderEehUp.DoClick();
                }
            }
                //tbxOverrideCustRequirement.Focus();

                //var x = dGrid.GetFocusedRowIndex();
                //dGrid.SetFocusedRowIndex(x + 1);



                //tbxOverrideCustRequirement.Focus();

                //var nextBox = eval("OverrideCustRequirement" + (row + 1));
                //if (e.htmlEvent.keyCode == 40) {
                //    nextBox.Focus();
                //}

           
        }


        function LostFocus(htmlEvent, editName) {   
            //if (editName == 'OverrideCustRequirement') {
            //    btnHidOverrideCustRequirement.DoClick();
            //}
            //else if (editName == 'NewOnOrderEEH') {
            //    btnHidNewOnOrderEeh.DoClick();
            //}
        }

    </script>
</asp:Content>


<asp:Content ID="contentTitle" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="MPS Troy"></asp:Label>
</asp:Content>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
               <dx:ASPxLoadingPanel ID="ldnPanel1" ClientInstanceName="ldnPanel1" runat="server" Modal="true"></dx:ASPxLoadingPanel>


            
 
        <div style="width: 1585px; height: 630px; margin-bottom: 0px; border: 0px solid red;">



            <div style="float: left;">

                <div style="margin-bottom: 15px;">
                    <dx:ASPxComboBox ID="cbxSchedulers" runat="server" ValueType="System.String" AutoPostBack="false" 
                        OnSelectedIndexChanged="cbxSchedulers_SelectedIndexChanged" Width="163">
                         <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                        e.processOnServer = true; 
                                        // do some processing at the server side
                                  }" />
                    </dx:ASPxComboBox>
                </div>


                <div>
                    <dx:ASPxGridView ID="gvwFinishedParts" ClientInstanceName="sGrid" AutoGenerateColumns="false" runat="server"
                        KeyFieldName="FinishedPart" OnFocusedRowChanged="gvwFinishedParts_FocusedRowChanged" EnableCallBacks="false">
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        <SettingsBehavior AllowSort="false" AllowGroup="false" />
                        <Settings VerticalScrollBarMode="Visible" />
                        <Settings VerticalScrollableHeight="0" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="FinishedPart" VisibleIndex="0" Width="145px" />
                            <dx:GridViewDataTextColumn FieldName="Revision" VisibleIndex="1" Visible="false" Width="100px" />
                        </Columns>
                        <ClientSideEvents FocusedRowChanged="function(s, e) {
                            btnHidGetHeaderDetail.DoClick();
                        }" />
                    </dx:ASPxGridView>
                </div>

            </div>




            <div id="divHeader" class="headerBox" runat="server">

                <table class="tbl">
                    <tr>
                        <td>
                            <dx:ASPxLabel ID="lblCustomerPart" runat="server" Text="Cust Part:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxCustomerPart" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblDescription" runat="server" Text="Desc:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td colspan="3">
                            <dx:ASPxTextBox ID="tbxDescription" runat="server" ReadOnly="true" Width="305" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblAbcClass1" runat="server" Text="Abc Class 1:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxAbcClass1" runat="server" ReadOnly="true" Width="75" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblSop" runat="server" Text="SOP:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxSop" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblEauEei" runat="server" Text="EAU EEI:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxEauEei" runat="server" ReadOnly="true" Width="75" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dx:ASPxLabel ID="lblStandardPack" runat="server" Text="Std Pack:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxStandardPack" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblDefaultPo" runat="server" Text="Def PO:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxDefaultPo" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblSalesPrice" runat="server" Text="Sales Price:" ForeColor="#808080" Width="75" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxSalesPrice" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblAbcClass2" runat="server" Text="Abc Class 2:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxAbcClass2" runat="server" ReadOnly="true" Width="75" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblEop" runat="server" Text="EOP:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxEop" runat="server" ReadOnly="true" Width="110" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblEehCapacity" runat="server" Text="EEH Cap:" ForeColor="#808080" Font-Size="9"></dx:ASPxLabel>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="tbxEehCapacity" runat="server" ReadOnly="true" Width="75" Font-Size="9" Height="32"></dx:ASPxTextBox>
                        </td>
                    </tr>
                </table>
            </div>




            <div style="float: left; margin: 0px 0px 0px 25px;">
                 <dx:ASPxGridView ID="gvwSnapshotCalendar" ClientInstanceName="dGrid" AutoGenerateColumns="false" runat="server"
                    KeyFieldName="RowID" OnHtmlDataCellPrepared="gvwSnapshotCalendar_HtmlDataCellPrepared" Visible="true">
                         <Styles>
        <Cell>
            <Paddings PaddingTop="0px" PaddingBottom="0px" />
        </Cell>
    </Styles>
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="RowID" VisibleIndex="0" Width="50" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="EEI ContainerDT" FieldName="CalendarDT" Name="CalendarDT" VisibleIndex="1" Width="120" />
                        <dx:GridViewDataTextColumn Caption="Daily Weekly" FieldName="DailyWeekly" Name="DailyWeekly" VisibleIndex="2" Width="80" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="Week" FieldName="WeekNo" Name="WeekNo" VisibleIndex="3" Width="55" />
                        <dx:GridViewDataTextColumn Caption="Holiday" FieldName="Holiday" Name="Holiday" VisibleIndex="4" Width="95" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="EEI ContainerDT" FieldName="EEIContainerDT" Name="EEIContainerDT" VisibleIndex="5" Width="120" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="SchedulingDT" FieldName="SchedulingDT" Name="SchedulingDT" VisibleIndex="6" Width="105" Visible="false" />
                        <dx:GridViewDataTextColumn Caption="Plan Days" FieldName="PlanningDays" Name="PlanningDays" VisibleIndex="7" Width="85" />
                        <dx:GridViewDataTextColumn Caption="Cust Req" FieldName="CustomerRequirement" Name="CustomerRequirement" VisibleIndex="8" Width="100" />
                        <dx:GridViewDataTextColumn Caption="Override Cust Req" FieldName="OverrideCustomerRequirement" Name="OverrideCustomerRequirement" VisibleIndex="9" Width="135">
                            <DataItemTemplate>                
                                <dx:ASPxTextBox ID="tbxOverrideCustRequirement" Width="100%" Height="27" runat="server" Value='<%# Eval("OverrideCustomerRequirement")%>' ClientInstanceName="tbxOverrideCustRequirement"
                                    ClientSideEvents-GotFocus='<%# string.Format("function(s, e){{ dGrid.SetFocusedRowIndex({0}); }}",Container.VisibleIndex) %>'>
                                    <ClientSideEvents KeyDown="function(s, e) { DoProcessKeyPress(e.htmlEvent, 'OverrideCustRequirement');  }" />
                                   
                                </dx:ASPxTextBox>           
                            </DataItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="InTrans Qty" FieldName="InTransQty" Name="InTransQty" VisibleIndex="10" Width="95" />
                        <dx:GridViewDataTextColumn Caption="OnOrder EEH" FieldName="OnOrderEEH" Name="OnOrderEEH" VisibleIndex="11" Width="105" />
                        <dx:GridViewDataTextColumn Caption="New OnOrder EEH" FieldName="NewOnOrderEEH" Name="NewOnOrderEEH" VisibleIndex="12" Width="135">
                            <DataItemTemplate>                
                                <dx:ASPxTextBox ID="tbxNewOnOrderEeh" Width="100%" Height="27" runat="server" Value='<%# Eval("NewOnOrderEEH")%>' ClientInstanceName="tbxNewOnOrderEeh"
                                    ClientSideEvents-GotFocus='<%# string.Format("function(s, e){{ dGrid.SetFocusedRowIndex({0}); }}",Container.VisibleIndex) %>'>
                                    <ClientSideEvents KeyDown="function(s, e) { DoProcessKeyPress(e.htmlEvent, 'NewOnOrderEEH');  }" />
                                    
                                </dx:ASPxTextBox>
                            </DataItemTemplate>     
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="Total Inv" FieldName="TotalInventory" Name="TotalInventory" VisibleIndex="13" Width="100" />
                        <dx:GridViewDataTextColumn Caption="Balance" FieldName="Balance" Name="Balance" VisibleIndex="14" Width="100" />
                        <dx:GridViewDataTextColumn Caption="Wks OnHand" FieldName="WeeksOnHand" Name="WeeksOnHand" VisibleIndex="15" Width="105" />
                        <dx:GridViewDataTextColumn FieldName="WeeksOnHandWarnFlag" Name="WeeksOnHandWarnFlag" VisibleIndex="16" Width="150" Visible="false" />
                    </Columns>
                    <SettingsBehavior AllowSelectByRowClick="true" />
                    <SettingsBehavior AllowSelectSingleRowOnly="false" />
                    <SettingsBehavior AllowFocusedRow="true" />
                    <SettingsBehavior AllowSort="false" />
                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                    <Settings VerticalScrollBarMode="Visible" />
                    <Settings VerticalScrollableHeight="0" />
                </dx:ASPxGridView>
                <script type="text/javascript">
                    // <![CDATA[
                    ASPxClientControl.GetControlCollection().ControlsInitialized.AddHandler(function (s, e) {
                        //updateHeaderMenuOrientation();
                        //updateGridHeight();
                    });
                    ASPxClientControl.GetControlCollection().BrowserWindowResized.AddHandler(function (s, e) {
                        //updateHeaderMenuOrientation();
                        updateGridHeight();
                    });
        // ]]> 
        </script>
            </div>





            
            <div style="float: left; margin: 0px 0px 0px 190px;">
                <dx:ASPxVerticalGrid ID="vgSnapshotCalendar" runat="server" ClientInstanceName="vgSnapshotCalendar" Width="100%"
                    AutoGenerateRows="False" OnSelectionChanged="vgSnapshotCalendar_SelectionChanged">
                <Styles>
                    <Record>
                        <Paddings PaddingTop="0px" PaddingBottom="0px" />
                    </Record>
                </Styles>
                    <Rows>

                        <dx:VerticalGridCommandRow SelectAllCheckboxMode="Page" ShowSelectCheckbox="True" VisibleIndex="0">
                        </dx:VerticalGridCommandRow>

                        <dx:VerticalGridTextRow FieldName="RowID" VisibleIndex="1" Visible="false" />
                        <dx:VerticalGridTextRow Caption="EEI ContainerDT" FieldName="CalendarDT" Name="CalendarDT" VisibleIndex="2"  />
                        <dx:VerticalGridTextRow Caption="Daily Weekly" FieldName="DailyWeekly" Name="DailyWeekly" VisibleIndex="3" Visible="false" />
                        <dx:VerticalGridTextRow Caption="Week" FieldName="WeekNo" Name="WeekNo" VisibleIndex="4" />
                        <dx:VerticalGridTextRow Caption="Holiday" FieldName="Holiday" Name="Holiday" VisibleIndex="5" Visible="false" />
                        <dx:VerticalGridTextRow Caption="EEI ContainerDT" FieldName="EEIContainerDT" Name="EEIContainerDT" VisibleIndex="6" Visible="false" />
                        <dx:VerticalGridTextRow Caption="SchedulingDT" FieldName="SchedulingDT" Name="SchedulingDT" VisibleIndex="7" Visible="false" />
                        <dx:VerticalGridTextRow Caption="Plan Days" FieldName="PlanningDays" Name="PlanningDays" VisibleIndex="8" />
                        <dx:VerticalGridTextRow Caption="Cust Req" FieldName="CustomerRequirement" Name="CustomerRequirement" VisibleIndex="9" />

                        <dx:VerticalGridTextRow Caption="Override Cust Req" FieldName="OverrideCustomerRequirement" Name="OverrideCustomerRequirement" VisibleIndex="10">
                            <DataItemTemplate>    
                                <div style="float: left;">
                                <dx:ASPxTextBox ID="tbxOverrideCustRequirement" Width="60" Height="27" runat="server" Value='<%# Eval("OverrideCustomerRequirement")%>' ClientInstanceName="tbxOverrideCustRequirement"
                                    >
                                        <ClientSideEvents KeyDown="function(s, e) { DoProcessKeyPress(e.htmlEvent, 'OverrideCustRequirement');  }" />
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left; margin: 0px 0px 0px 3px;">
                                    <dx:ASPxButton ID="btnCopy" runat="server" ClientInstanceName="btnCopy" AutoPostBack="false" RenderMode="Link">
                                        <Image IconID="actions_stretch_16x16gray" />
                                    </dx:ASPxButton>
                                </div>
                            </DataItemTemplate>
                        </dx:VerticalGridTextRow>
                        
                        <dx:VerticalGridTextRow Caption="InTrans Qty" FieldName="InTransQty" Name="InTransQty" VisibleIndex="11" />
                        <dx:VerticalGridTextRow Caption="OnOrder EEH" FieldName="OnOrderEEH" Name="OnOrderEEH" VisibleIndex="12" />
                        <dx:VerticalGridTextRow Caption="New OnOrder EEH" FieldName="NewOnOrderEEH" Name="NewOnOrderEEH" VisibleIndex="13">
                            <DataItemTemplate>   
                                <div style="float: left;">
                                <dx:ASPxTextBox ID="tbxNewOnOrderEeh" Width="60" Height="27" runat="server" Value='<%# Eval("NewOnOrderEEH")%>' ClientInstanceName="tbxNewOnOrderEeh"
                                    ClientSideEvents-GotFocus='<%# string.Format("function(s, e){{ dGrid.SetFocusedRowIndex({0}); }}",Container.VisibleIndex) %>'>
                                    <ClientSideEvents KeyDown="function(s, e) { DoProcessKeyPress(e.htmlEvent, 'NewOnOrderEEH');  }" />
                                    
                                </dx:ASPxTextBox>
                                </div>
                                <div style="float: left; margin: 0px 0px 0px 3px;">
                                    <dx:ASPxButton ID="btnCopy" runat="server" ClientInstanceName="btnCopy" AutoPostBack="false" RenderMode="Link">
                                        <Image IconID="actions_stretch_16x16gray" />
                                    </dx:ASPxButton>
                                </div>
                            </DataItemTemplate>     
                        </dx:VerticalGridTextRow>

                        <dx:VerticalGridTextRow Caption="Total Inv" FieldName="TotalInventory" Name="TotalInventory" VisibleIndex="14" />
                        <dx:VerticalGridTextRow Caption="Balance" FieldName="Balance" Name="Balance" VisibleIndex="15" />
                        <dx:VerticalGridTextRow Caption="Wks OnHand" FieldName="WeeksOnHand" Name="WeeksOnHand" VisibleIndex="16" />
                        <dx:VerticalGridTextRow FieldName="WeeksOnHandWarnFlag" Name="WeeksOnHandWarnFlag" VisibleIndex="17" Visible="true" />
                    </Rows>
                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                    <Settings HorizontalScrollBarMode="Visible" />
                   
                    <FormatConditions>
                        <dx:VerticalGridFormatConditionHighlight ApplyToRecord="False" Expression="[WeeksOnHandWarnFlag] &gt; 0" FieldName="WeeksOnHand" Format="GreenFillWithDarkGreenText">
                        </dx:VerticalGridFormatConditionHighlight>
                    </FormatConditions>
                   
                </dx:ASPxVerticalGrid>

            </div>








            <div style="float: left; margin-left: 20px;">
                <dx:ASPxButton ID="btnComplete" ClientInstanceName="btnComplete" runat="server" AutoPostBack="false" Text="Complete" OnClick="btnComplete_Click"></dx:ASPxButton>
            </div>


        </div>


            <div style="display: none;">
                <dx:ASPxButton ID="btnHidGetHeaderDetail" ClientInstanceName="btnHidGetHeaderDetail" runat="server" AutoPostBack="false" OnClick="btnHidGetHeaderDetail_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
                <dx:ASPxButton ID="btnHidOverrideCustRequirementDn" ClientInstanceName="btnHidOverrideCustRequirementDn" runat="server" AutoPostBack="false" OnClick="btnHidOverrideCustRequirementDn_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
                <dx:ASPxButton ID="btnHidNewOnOrderEehDn" ClientInstanceName="btnHidNewOnOrderEehDn" runat="server" AutoPostBack="false" OnClick="btnHidNewOnOrderEehDn_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
                <dx:ASPxButton ID="btnHidOverrideCustRequirementUp" ClientInstanceName="btnHidOverrideCustRequirementUp" runat="server" AutoPostBack="false" OnClick="btnHidOverrideCustRequirementUp_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
                <dx:ASPxButton ID="btnHidNewOnOrderEehUp" ClientInstanceName="btnHidNewOnOrderEehUp" runat="server" AutoPostBack="false" OnClick="btnHidNewOnOrderEehUp_Click" Height="5" UseSubmitBehavior="false"></dx:ASPxButton>
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


    


</asp:Content>
