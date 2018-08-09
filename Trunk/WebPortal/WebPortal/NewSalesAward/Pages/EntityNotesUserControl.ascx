<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EntityNotesUserControl.ascx.cs" Inherits="WebPortal.Scheduling.Pages.EntityNotesUserControl" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<script>
    function FilterEntityNotesUserControl(uri) {
        uriHiddenField.Set("uriFilter", uri);

        $('tr[id*="EntityNotesGridView_DXDataRow"]').hide();
        var vrows = $("span").filter(function () { return ($(this).text() === uri) }).closest('tr');

        vrows.show();
        $('span[id*="EntityNotesGridView_Title"]').text(vrows.length + " Comment" + ((vrows.length === 1) ? "" : "s"));

        uriFilt.SetText(uri);
    }
</script>

<dx:ASPxHiddenField runat="server" ClientInstanceName="uriHiddenField" ID="hfUri"></dx:ASPxHiddenField>
<dx:ASPxHiddenField runat="server" ClientInstanceName="rowIDsHiddenField" ID="hfRowIDs"></dx:ASPxHiddenField>
<dx:ASPxLabel runat="server" ClientInstanceName="uriFilt" Text="xxx"/>
<dx:ASPxGridView ID="EntityNotesGridView" runat="server" AutoGenerateColumns="False" ClientInstanceName="entityNotes"
                 KeyFieldName="RowID" Border-BorderStyle="None"
                 EnableRowsCache="True"
                 OnRowInserting="EntityNotesGridView_OnRowInserting"
                 OnRowUpdating="EntityNotesGridView_OnRowUpdating"
                 OnHtmlRowPrepared="EntityNotesGridView_OnHtmlRowPrepared"
                 OnHtmlRowCreated="EntityNotesGridView_OnHtmlRowCreated"
                 Width="98%"
                 >
<%--    <ClientSideEvents EndCallback="function () { FilterEntityNotesUserControl( uriHiddenField.Get ('uriFilter')); }" />--%>
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
    <SettingsPopup EditForm-Modal="True" EditForm-HorizontalAlign="Center" EditForm-VerticalAlign="WindowCenter">
        <EditForm HorizontalAlign="Center" VerticalAlign="WindowCenter" Modal="True" />
    </SettingsPopup>
    <SettingsBehavior SortMode="Value" AllowSort="False" />
    <Settings VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Standard" VerticalScrollableHeight="800" />
    <SettingsDataSecurity AllowDelete="False" />
    <Templates>
        <TitlePanel>
            <dx:ASPxLabel runat="server" Text='<%# Eval("VisibleRowCount") + " Comments" %>'/>
            <br />
            <div style="text-align: left; padding: 2px 2px 2px 2px">
                <dx:ASPxButton ID="NewRow" runat="server" AutoPostBack="False" Text="New Note"
                               RenderMode="Link">
                    <ClientSideEvents Click="function () { entityNotes.AddNewRow(); }" />
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
            <div style="padding:5px">
                <dx:ASPxLabel runat="server" Text='<%# Eval("Author") %>'>
                    <Font Size="17px" Bold="True" />
                </dx:ASPxLabel>
                <dx:ASPxLabel runat="server" Text='<%# Eval("RowCreateDT") %>' ForeColor="#AFB0B3" Font-Underline="True" >
                </dx:ASPxLabel>
                <dx:ASPxLabel runat="server" Text='<%# Eval("EntityURI") %>' ForeColor="#AFB0B3" Font-Underline="True" Font-Size="8px">
                </dx:ASPxLabel>
                <br />
                <div style="padding: 10px 0 0 0">
                    <dx:ASPxLabel runat="server" Text='<%# Eval("Body") %>' EncodeHtml="False"/>
                </div>
                <br />
                <div id="x" style="text-align: left; padding: 2px 2px 0 0">
                    <dx:ASPxButton ID="EditRow" runat="server" AutoPostBack="False" Text="Edit"
                                   RenderMode="Link">
                        <ClientSideEvents Click="function (s, e) {
                                var a = $(event.target).closest('div');
                                console.log ('a:' + a);
                                console.log ('a.len:' + a.length);
                                console.log (a.attr('id'));
                                var b = a.find('span[id*=RowID]');  
                                console.log ('b:' + b);
                                console.log ('b.len:' + b.length);
                                console.log (b.text());
                                var row = rowIDsHiddenField.Get (b.text ());
                                console.log (row);
                                entityNotes.StartEditRow (row); 
                            }" />
                    </dx:ASPxButton>
                    <div style="display: inline">
                        <dx:ASPxLabel runat="server" ID="RowID" ClientInstanceName="rowID" Text='<%# Eval("RowID") %>' />
                    </div>
                </div>
                <hr style="color: #AFB0B3"/>
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
