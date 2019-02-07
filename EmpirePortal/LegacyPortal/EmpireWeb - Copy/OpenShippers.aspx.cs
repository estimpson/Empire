using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress;
using DevExpress.Data;
using DevExpress.Web;
using DevExpress.Web.ASPxGridView;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void ASPxGridView1_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewEditorEventArgs e)
    {
        if (e.Column.FieldName == "customer_part" && (sender as ASPxGridView).IsNewRowEditing)
        {
            e.Editor.ReadOnly = false;
        }
    }
}