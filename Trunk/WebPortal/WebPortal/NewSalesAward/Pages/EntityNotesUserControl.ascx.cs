using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using DevExpress.Web;
using DevExpress.Web.ASPxHtmlEditor;
using DevExpress.Web.Data;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.Scheduling.Pages
{
    public partial class EntityNotesUserControl : UserControl
    {
        private List<usp_GetEntityNotes_Result> NoteList
        {
            get => (List<usp_GetEntityNotes_Result>) Session["NoteList"];
            set
            {
                Session["NoteList"] = value;
                var i = 0;
                foreach (var note in value.OrderByDescending(n=>n.RowCreateDT))
                {
                    hfRowIDs[note.RowID.ToString()] = i;
                    i++;
                }
            }
        }

        private string User
        {
            get => (string) Session["UserCode"];
            set => Session["UserCode"] = value;
        }

        private string SelectedURI
        {
            get => (string) Session["SelectedURI"];
            set => Session["SelectedURI"] = value;
        }

        private string FilteredURI
        {
            get => hfUri.Contains("uriFilter") ? hfUri ["uriFilter"].ToString() : null;
            set => hfUri["uriFilter"] = value;
        }

        private bool UnlockFieldMode
        {
            get => hfMode.Contains("UnlockMode") ? Convert.ToBoolean(hfMode["UnlockMode"]) : false;
        }

        private string UnlockData
        {
            get => hfMode.Contains("UnlockData") ? (string)hfMode["UnlockData"] : null;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            EntityNotesGridView.DataSource = NoteList;
            EntityNotesGridView.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void Retrieve(string user, string uri)
        {
            User = user;
            SelectedURI = uri;
            hfUri["uriFilter"] = uri;
            RefreshGrid();
        }

        public void RefreshGrid()
        {
            NoteList = new EntityNotesViewModel().GetEntityNotes(User, SelectedURI);
            EntityNotesGridView.DataSource = NoteList;
            EntityNotesGridView.DataBind();
        }

        protected void EntityNotesGridView_OnRowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            var grid = (ASPxGridView)sender;
            var htmlEditor = grid.FindEditFormTemplateControl("ASPxHtmlEditor1") as ASPxHtmlEditor;

            if (UnlockFieldMode)
            {
                CreateUnlockData(grid, htmlEditor, e);
            }
            else
            {
                SaveNewNote(htmlEditor, e);
            }
        }

        private void CreateUnlockData(ASPxGridView grid, ASPxHtmlEditor htmlEditor, ASPxDataInsertingEventArgs e)
        {
            grid.JSProperties["cpUnlock"] = true;
            grid.JSProperties["cpUnlockData"] = htmlEditor.Html;
            grid.JSProperties["cpEndEditing"] = true;

            EntityNotesGridView.CancelEdit();
            e.Cancel = true;
        }

        private void SaveNewNote(ASPxHtmlEditor htmlEditor, ASPxDataInsertingEventArgs e)
        {
            var vm = new EntityNotesViewModel();
            Debug.Assert(htmlEditor != null, nameof(htmlEditor) + " != null");
            vm.AddEntityNote(User, FilteredURI, htmlEditor.Html);

            EntityNotesGridView.CancelEdit();
            e.Cancel = true;

            RefreshGrid();
        }

        protected void EntityNotesGridView_OnRowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            var grid = (ASPxGridView) sender;
            var htmlEditor = grid.FindEditFormTemplateControl("ASPxHtmlEditor1") as ASPxHtmlEditor;

            //grid.JSProperties["cpUpdating"] = true;

            var vm = new EntityNotesViewModel();
            Debug.Assert(htmlEditor != null, nameof(htmlEditor) + " != null");
            var rowID = (int) e.Keys[0];
            var uri = NoteList.First(n => n.RowID == rowID).EntityURI;
            var body = htmlEditor.Html;
            vm.ModifyEntityNote(User, uri, rowID, body);

            EntityNotesGridView.CancelEdit();
            e.Cancel = true;

            RefreshGrid();
        }

        protected void EntityNotesGridView_OnCancelRowEditing(object sender, ASPxStartRowEditingEventArgs e)
        {
            var grid = (ASPxGridView)sender;
            if (UnlockFieldMode)
            {
                grid.JSProperties["cpEndEditing"] = true;
            }
        }

        protected void EntityNotesGridView_OnHtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            Debug.Assert(grid != null, nameof(grid) + " != null");
            if (grid.FindRowTemplateControl(e.VisibleIndex, "EditRow") is ASPxButton editButton)
                editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void EntityNotesGridView_OnHtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            Debug.Assert(grid != null, nameof(grid) + " != null");
            if (grid.FindRowTemplateControl(e.VisibleIndex, "EditRow") is ASPxButton editButton)
                editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void EntityNotesGridView_OnInitNewRow(object sender, ASPxDataInitNewRowEventArgs e)
        {
            var grid = sender as ASPxGridView;
            var x = FilteredURI;
            var y = x.Split('/').Last().Split('.').Last();
            var r = new Regex(@"
                (?<=[A-Z])(?=[A-Z][a-z]) |
                 (?<=[^A-Z])(?=[A-Z]) |
                 (?<=[A-Za-z])(?=[^A-Za-z])", RegexOptions.IgnorePatternWhitespace);
            var z = r.Replace(y, " ");
            grid.SettingsText.PopupEditFormCaption = (UnlockFieldMode?"Unlock":"New") + $" {z} Note";

            if (UnlockFieldMode)
            {
                var a = e.NewValues;
                a["Body"] = UnlockData;
                grid.JSProperties.Add("cpUnlock", null);
                grid.JSProperties.Add("cpUnlockData", null);
                grid.JSProperties.Add("cpEndEditing", null);
            }
        }

        protected void EntityNotesGridView_OnStartRowEditing(object sender, ASPxStartRowEditingEventArgs e)
        {
            var grid = sender as ASPxGridView;
            grid.SettingsText.PopupEditFormCaption = "Edit Note";
        }
    }
}