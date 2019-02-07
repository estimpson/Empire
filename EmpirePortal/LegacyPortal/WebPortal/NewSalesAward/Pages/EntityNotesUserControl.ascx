<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EntityNotesUserControl.ascx.cs" Inherits="WebPortal.Scheduling.Pages.EntityNotesUserControl" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxSpellChecker" Assembly="DevExpress.Web.ASPxSpellChecker.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<script>
    var FilterByContext = true;

    function ReFilter() {
        FilterEntityNotesUserControl(uriHiddenField.Get("uriFilter"));
    }

    function FilterEntityNotesUserControl(uri) {
        uriHiddenField.Set("uriFilter", uri);
        uriFilt.SetText(uri);

        if (FilterByContext) {

            $('tr[id*="EntityNotesGridView_DXDataRow"]').hide();
            var vrows = $("span").filter(function() { return ($(this).text() === uri) }).closest('tr');

            vrows.show("slow");
            $('span[id*="EntityNotesGridView_Title"]').text(vrows.length + " Note" + ((vrows.length === 1) ? "" : "s"));
        } else {

            $('tr[id*="EntityNotesGridView_DXDataRow"]').show("slow");
        }
           
    }

    function OnClickEditNote(s, e) {
        //  Get the div containing the button clicked.
        var a = $(event.target).closest('div');

        //  Find the span containing the RowID.
        var b = a.find('span[id*=RowID]');

        //  Lookup the grid row associated with that RowID.
        var row = rowIDsHiddenField.Get (b.text ());
        entityNotes.StartEditRow (row); 
    }

    function OnNewRow(s, e) {
        modeHiddenField.Set("UnlockMode", "false");
        entityNotes.AddNewRow();
    }

    var MandatoryNoteSender;
    var EndMandatoryNoteCallback;

    function PromptMandatoryNote(s, endMandatoryNoteCallback) {
        MandatoryNoteSender = s;
        if (MandatoryNoteSender.cpUnlocked) {
            modeHiddenField.Set("UnlockData", MandatoryNoteSender.cpUnlockNote);
        } else {
            modeHiddenField.Set("UnlockData", undefined);
        }
        
        EndMandatoryNoteCallback = endMandatoryNoteCallback;
        modeHiddenField.Set("UnlockData", MandatoryNoteSender.cpUnlockNote);
        modeHiddenField.Set("UnlockMode", "true");
        entityNotes.AddNewRow();
    }

    function onEntityNotesEndCallback(s, e) {
        FilterEntityNotesUserControl( uriHiddenField.Get ("uriFilter"));
        $('.dxgvCSD').css("border", "none").css("box-shadow", "none");

        if (!s.cpEndEditing) return;

        console.log("UnlockMode: " + modeHiddenField.Get("UnlockMode"));
        if (modeHiddenField.Get("UnlockMode")) {
            if (!s.cpUnlock) {
                console.log("cancelled unlock");
                EndMandatoryNoteCallback(MandatoryNoteSender, false, undefined);
            } else {
                console.log("unlock data: " + s.cpUnlockData);
                EndMandatoryNoteCallback(MandatoryNoteSender, true, s.cpUnlockData);
            }
        }
    }
</script>

<dx:ASPxHiddenField runat="server" ClientInstanceName="modeHiddenField" ID="hfMode"></dx:ASPxHiddenField>
<dx:ASPxHiddenField runat="server" ClientInstanceName="uriHiddenField" ID="hfUri"></dx:ASPxHiddenField>
<dx:ASPxHiddenField runat="server" ClientInstanceName="rowIDsHiddenField" ID="hfRowIDs"></dx:ASPxHiddenField>
<div style="display: none">
    <dx:ASPxLabel runat="server" ClientInstanceName="uriFilt" Text="xxx"/>
</div>

<div style="border-top: 2px solid darkorange; margin-left: 40px; width: 1500px; clear: left; margin-top: 10px;">
    <table style="margin-top: 10px; ">
        <tr>
            <td>
                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Notes / Comments / Change Tracking" Font-Size="13" ForeColor="DarkOrange" />
            </td>
            <script>
                function OnFilterButtonClick(s, e) {
                    console.log("FilterByContext");
                    FilterByContext = true;
                    ReFilter();
                }

                function OnShowAllButtonClick(s, e) {
                    console.log("ShowAll");
                    FilterByContext = false;
                    ReFilter();
                }
            </script>
            <td>
                <dx:ASPxButton ID="FilterButton" runat="server" AutoPostBack="False"
                               Text="Filter by Context" Checked="True" GroupName="F">
                    <ClientSideEvents
                        Click="OnFilterButtonClick" />
                </dx:ASPxButton>
            </td>
            <td>
                <dx:ASPxButton ID="ShowAllButton" runat="server" AutoPostBack="False"
                               Text="Show All Notes" GroupName="F">
                    <ClientSideEvents
                        Click="OnShowAllButtonClick" />
                </dx:ASPxButton>
            </td>
        </tr>
        <tr>
            <dx:ASPxGridView ID="EntityNotesGridView" CssClass="borderlessGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="entityNotes"
                             KeyFieldName="RowID" Border-BorderStyle="None"
                             EnableRowsCache="True"
                             EnableCallBacks="True"
                             OnInitNewRow="EntityNotesGridView_OnInitNewRow"
                             OnStartRowEditing="EntityNotesGridView_OnStartRowEditing"
                             OnRowInserting="EntityNotesGridView_OnRowInserting"
                             OnRowUpdating="EntityNotesGridView_OnRowUpdating"
                             OnCancelRowEditing="EntityNotesGridView_OnCancelRowEditing"
                             OnHtmlRowPrepared="EntityNotesGridView_OnHtmlRowPrepared"
                             OnHtmlRowCreated="EntityNotesGridView_OnHtmlRowCreated"
                             Width="98%"
                             >
                <ClientSideEvents
                    EndCallback="onEntityNotesEndCallback"
                    Init="function () {
                FilterEntityNotesUserControl( uriHiddenField.Get ('uriFilter'));
                $('.dxgvCSD' ).css('border', 'none').css('box-shadow', 'none');
            }"
                    />
                <Border BorderStyle="None"></Border>
                <SettingsAdaptivity AdaptivityMode="HideDataCellsWindowLimit">
                    <AdaptiveDetailLayoutProperties>
                        <Items>
                            <dx:GridViewColumnLayoutItem>
                            </dx:GridViewColumnLayoutItem>
                            <dx:GridViewColumnLayoutItem ColumnName="Author">
                            </dx:GridViewColumnLayoutItem>
                            <dx:GridViewColumnLayoutItem ColumnName="Body">
                            </dx:GridViewColumnLayoutItem>
                            <dx:GridViewColumnLayoutItem ColumnName="RowCreateDT">
                            </dx:GridViewColumnLayoutItem>
                            <dx:GridViewColumnLayoutItem ColumnName="RowCreateUser">
                            </dx:GridViewColumnLayoutItem>
                        </Items>
                    </AdaptiveDetailLayoutProperties>
                </SettingsAdaptivity>
                <Settings ShowTitlePanel="True" ShowColumnHeaders="False" />
                <SettingsPager Visible="False" />
                <SettingsEditing Mode="PopupEditForm" />
                <SettingsPopup>
                    <EditForm HorizontalAlign="Center" VerticalAlign="WindowCenter" Modal="True" />
                </SettingsPopup>
                <SettingsBehavior SortMode="Value" AllowSort="False" />
                <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Standard" />
                <SettingsDataSecurity AllowDelete="False" />
                <Templates>
                    <TitlePanel>
                        <dx:ASPxLabel runat="server" Text='<%# Eval("VisibleRowCount") + " Comments" %>'/>
                        <br />
                        <div style="text-align: left; padding: 2px 2px 2px 2px">
                            <dx:ASPxButton ID="NewRow" runat="server" AutoPostBack="False" Text="New Note"
                                           RenderMode="Link">
                                <ClientSideEvents Click="OnNewRow" />
                            </dx:ASPxButton>
                        </div>
                    </TitlePanel>
                    <EditForm>
                        <dx:ASPxHtmlEditor ID="ASPxHtmlEditor1" runat="server" Html='<%# Eval("Body") %>'>
                            <SettingsImageUpload>
                                <ValidationSettings AllowedContentTypes="image/jpeg,image/pjpeg,image/gif,image/png,image/x-png"></ValidationSettings>
                            </SettingsImageUpload>

                        </dx:ASPxHtmlEditor>
                        <br />
                        <div style="text-align: right; padding: 2px 2px 2px 2px">
                            <dx:ASPxGridViewTemplateReplacement runat="server" ID="UpdateButton" ReplacementType="EditFormUpdateButton"/>
                            <dx:ASPxGridViewTemplateReplacement runat="server" ID="CancelButton" ReplacementType="EditFormCancelButton"/>
                        </div>
                    </EditForm>
                    <DataRow>
                        <div style="padding: 5px; border-bottom: 1px solid darkorange;">
                            <dx:ASPxLabel runat="server" Text='<%# Eval("Author") %>'>
                                <Font Size="17px" Bold="True" />
                            </dx:ASPxLabel>
                            <dx:ASPxLabel runat="server" Text='<%# Eval("RowCreateDT") %>' ForeColor="#AFB0B3" Font-Underline="True">
                            </dx:ASPxLabel>
                            <dx:ASPxLabel runat="server" Text='<%# Eval("EntityURI") %>' ForeColor="darkorange" Font-Underline="True">
                            </dx:ASPxLabel>
                            <br />
                            <dx:ASPxLabel runat="server" Text='<%# Eval("ValueChange") %>' ForeColor="#AFB0B3" Font-Underline="True">
                            </dx:ASPxLabel>
                            <dx:ASPxLabel runat="server" Text='<%# Eval("OldValue") %>' ForeColor="darkorange" Font-Underline="True">
                            </dx:ASPxLabel>
                            <dx:ASPxLabel runat="server" Text='<%# Eval("NewValue") %>' ForeColor="darkorange" Font-Underline="True">
                            </dx:ASPxLabel>
                            <br />
                            <div style="padding: 10px 0 0 0">
                                <dx:ASPxLabel runat="server" Text='<%# Eval("Body") %>' EncodeHtml="False"/>
                            </div>
                            <br />
                            <div id="x" style="text-align: left; padding: 2px 2px 0 0">
                                <dx:ASPxButton ID="EditRow" runat="server" AutoPostBack="False" Text="Edit"
                                               RenderMode="Link">
                                    <ClientSideEvents Click="OnClickEditNote" />
                                </dx:ASPxButton>
                                <div style="display: none">
                                    <dx:ASPxLabel runat="server" ID="RowID" ClientInstanceName="rowID" Text='<%# Eval("RowID") %>' />
                                </div>
                            </div>
                        </div>
                    </DataRow>
                </Templates>
                <Columns>
                    <dx:GridViewCommandColumn ShowEditButton="True" ShowNewButtonInHeader="True" VisibleIndex="0" ShowClearFilterButton="True">
                    </dx:GridViewCommandColumn>
                    <dx:GridViewDataTextColumn FieldName="Author" VisibleIndex="1">
                        <EditFormSettings Visible="False"/>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Body" VisibleIndex="2">
                        <PropertiesTextEdit EncodeHtml="False" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="RowID" VisibleIndex="8" Visible="False">
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="EntityURI" VisibleIndex="9" Visible="True">
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="RowCreateDT" SortIndex="0" SortOrder="Descending" VisibleIndex="9" AdaptivePriority="1">
                        <EditFormSettings Visible="False"/>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataTextColumn FieldName="RowCreateUser" VisibleIndex="10" AdaptivePriority="1">
                        <EditFormSettings Visible="False"/>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="RowModifiedDT" VisibleIndex="11" AdaptivePriority="1">
                        <EditFormSettings Visible="False"/>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataTextColumn FieldName="RowModifiedUser" VisibleIndex="12" AdaptivePriority="1">
                        <EditFormSettings Visible="False"/>
                    </dx:GridViewDataTextColumn>
                </Columns>

                <Border BorderStyle="None"></Border>
            </dx:ASPxGridView>
        </tr>
    </table>
</div>