using System;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Web.UI;
using DevExpress.Web;
using DevExpress.Web.ASPxHtmlEditor;
using DevExpress.Web.Data;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;


namespace WebPortal.Scheduling.Pages
{
    public partial class EntityNotesUserControl : System.Web.UI.UserControl
    {
        private List<usp_GetEntityNotes_Result> NoteList
        {
            get
            {
                //if (Session["NoteList"] == null)
                //{
                //    Session["NoteList"] = (new EntityNotesViewModel()).GetEntityNotes(user, entityUri);
                //}
                return (List<usp_GetEntityNotes_Result>)Session["NoteList"];
            }
            set
            {
                Session["NoteList"] = value;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            //EntityNotesGridView.DataSource = NoteList;
            //EntityNotesGridView.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void RefreshGrid()
        {
            //EntityNotesDataSource.Select();
            //EntityNotesGridView.DataBind();
            string user = Session["userCode"].ToString();
            string entityUri = Session["entityURI"].ToString();
            NoteList = (new EntityNotesViewModel()).GetEntityNotes(user, entityUri);
            EntityNotesGridView.DataSource = NoteList;
            EntityNotesGridView.DataBind();
        }

        protected void EntityNotesGridView_OnRowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            ProcessBodyRichContent(sender as ASPxGridView, e.NewValues);
        }

        protected void EntityNotesGridView_OnRowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            ProcessBodyRichContent(sender as ASPxGridView, e.NewValues);
        }

        private void ProcessBodyRichContent(ASPxGridView grid, OrderedDictionary newValues)
        {
            var htmlEditor = grid.FindEditFormTemplateControl("ASPxHtmlEditor1") as ASPxHtmlEditor;
            newValues["Body"] = htmlEditor.Html;
        }

        protected void EditRow_OnClick(object sender, EventArgs e)
        {
            var editButton = sender as ASPxButton;
            EntityNotesGridView.StartEdit(int.Parse(editButton.CommandArgument));
        }

        protected void EntityNotesGridView_OnHtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            var editButton = grid.FindRowTemplateControl(e.VisibleIndex, "EditRow") as ASPxButton;
            editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void EntityNotesGridView_OnHtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            var editButton = grid.FindRowTemplateControl(e.VisibleIndex, "EditRow") as ASPxButton;
            editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void NewRow_OnClick(object sender, EventArgs e)
        {
            EntityNotesGridView.AddNewRow();
        }
    }

}
