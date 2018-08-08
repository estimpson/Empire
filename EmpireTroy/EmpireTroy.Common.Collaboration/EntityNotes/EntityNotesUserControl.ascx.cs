using System;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Web.UI;
using DevExpress.Web;
using DevExpress.Web.ASPxHtmlEditor;
using DevExpress.Web.Data;

namespace EmpireTroy.Common.Collaboration.EntityNotes
{
    public partial class EntityNotesUserControl : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
            Debug.Assert(htmlEditor != null, nameof(htmlEditor) + " != null");
            newValues["Body"] = htmlEditor.Html;
        }

        protected void EditRow_OnClick(object sender, EventArgs e)
        {
            var editButton = sender as ASPxButton;
            Debug.Assert(editButton != null, nameof(editButton) + " != null");
            EntityNotesGridView.StartEdit(int.Parse(editButton.CommandArgument));
        }

        protected void EntityNotesGridView_OnHtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            var editButton = grid?.FindRowTemplateControl(e.VisibleIndex, "EditRow") as ASPxButton;
            Debug.Assert(editButton != null, nameof(editButton) + " != null");
            editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void EntityNotesGridView_OnHtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            var grid = sender as ASPxGridView;
            var editButton = grid?.FindRowTemplateControl(e.VisibleIndex, "EditRow") as ASPxButton;
            Debug.Assert(editButton != null, nameof(editButton) + " != null");
            editButton.CommandArgument = $"{e.VisibleIndex}";
        }

        protected void NewRow_OnClick(object sender, EventArgs e)
        {
            EntityNotesGridView.AddNewRow();
        }
    }
}