using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
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
            get => hfUri["uriFilter"]?.ToString();
            set => hfUri["uriFilter"] = value;
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
            var grid = (ASPxGridView) sender;
            var htmlEditor = grid.FindEditFormTemplateControl("ASPxHtmlEditor1") as ASPxHtmlEditor;

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
    }
}