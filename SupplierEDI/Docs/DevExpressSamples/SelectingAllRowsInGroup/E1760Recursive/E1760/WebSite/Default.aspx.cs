// Developer Express Code Central Example:
// How to implement select/unselect for all rows in a group row
// 
// This example demonstrates how to implement select/unselect for all rows in a
// group row.
// 
// It's possible to implement this behavior only by using
// ASPXGridView 9.1. For more information, please refer to
// http://www.devexpress.com/scid=S18760.
// 
// First, place ASPxCheckBox and
// ASPxLabel into the Grid.Templates.GroupRowContent template.
// 
// 
// Second, set the
// ASPxCheckBox.Checked property and the client-side
// ASPxCheckBox.ClientSideEvents.CheckedChanged event in the
// ASPxGridView.HtmlRowPrepared event handler.
// 
// In this example the
// ASPxLabel.Text is bound in the markup using Two-Way DataBinding.
// 
// You can find sample updates and versions for different programming languages here:
// http://www.devexpress.com/example=E1760

using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxEditors;
using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page
{

    protected bool GetChecked(int visibleIndex)
    {
        int childRowCount = Grid.GetChildRowCount(visibleIndex);
        for (int i = 0; i < childRowCount; i++)
        {
            bool isRowSelected = Grid.Selection.IsRowSelectedByKey(Grid.GetChildDataRow(visibleIndex, i)["ProductID"]);
            if (!isRowSelected)
                return false;
        }
        return true;
    }

    protected string GetCaptionText(GridViewGroupRowTemplateContainer container)
    {
        string captionText = !string.IsNullOrEmpty(container.Column.Caption) ? container.Column.Caption : container.Column.FieldName;
        return string.Format("{0} : {1} {2}", captionText, container.GroupText, container.SummaryText);
    }
    protected void Grid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e) {
      string[] parameters = e.Parameters.Split(';');

      int index = int.Parse(parameters[0]);
      string fieldname = parameters[1];
      bool isGroupRowSelected = bool.Parse(parameters[2]);

      System.Collections.ObjectModel.ReadOnlyCollection<GridViewDataColumn> groupedCols = Grid.GetGroupedColumns();

      if (groupedCols[groupedCols.Count - 1].FieldName == fieldname) {
         // Checked groupcolumn is the lowest level groupcolumn;
         // we can apply original recursive checking here

         Grid.ExpandRow(index, true); // expand grouped column for consistent behaviour
         for (int i = 0; i < Grid.GetChildRowCount(index); i++) {
            DataRow row = Grid.GetChildDataRow(index, i);
            object test = row["ProductID"];
            Grid.Selection.SetSelectionByKey(row["ProductID"], isGroupRowSelected);
         }
      }
      else {
         // checked row is not the lowest level groupcolumn:
         // we will find the Datarows that are to be checked recursively by iterating all rows
         // and compare the fieldvalues of the fields described by the checked groupcolumn
         // and all its parent groupcolumns. Rows that match these criteria are to the checked.
         // CAVEAT: only expanded rows can be iterated, so we will have to expand clicked row recursivly before iterating the grid

         int gidx = -1;
         foreach (GridViewDataColumn gcol in groupedCols) {
            if (gcol.FieldName == fieldname) {
               gidx = groupedCols.IndexOf(gcol);
               break;
            }
         }

         DataRow CheckedDataRow = Grid.GetDataRow(index);
         //Build dictionary with checked groucolumn and its parent groupcolumn fieldname and values
         Dictionary<string, object> DictParentFieldnamesValues = new Dictionary<string, object>();
         string parentfieldname;
         object parentkeyvalue;
         for (int i = gidx; i >= 0; i--) {
            // find parent groupcols and parentkeyvalue
            GridViewDataColumn pcol = groupedCols[i];
            parentfieldname = pcol.FieldName;
            parentkeyvalue = CheckedDataRow[parentfieldname];
            DictParentFieldnamesValues.Add(parentfieldname, parentkeyvalue);
         }


         bool isChildDatarowOfClickedGroup;
         Grid.ExpandRow(index, true);
         for (int i = 0; i <= Grid.VisibleRowCount - 1; i++) {
            DataRow row = Grid.GetDataRow(i);

            isChildDatarowOfClickedGroup = true;
            // check whether row does belong to checked group all the parent groups of the clicked group
            foreach (KeyValuePair<string, object> kvp in DictParentFieldnamesValues) {
               parentfieldname = kvp.Key;
               parentkeyvalue = kvp.Value;
               if (row[parentfieldname].Equals(parentkeyvalue) == false) {
                  isChildDatarowOfClickedGroup = false;
                  break;
                  //Iterated row does not belong to at least one parentgroup of the clicked groupbox; do not change selection state for this row
               }
            }

            if (isChildDatarowOfClickedGroup == true) {
               //row meets all the criteria for belonging to the clicked group and all parents of the clicked group:
               // change selection state
               Grid.Selection.SetSelectionByKey(row["ProductID"], isGroupRowSelected);
            }
         }
      }
   }

    protected void Grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
    {
        if (e.RowType == GridViewRowType.Group)
        {
            ASPxCheckBox checkBox = (ASPxCheckBox)Grid.FindGroupRowTemplateControl(e.VisibleIndex, "checkBox");
            checkBox.Checked = GetChecked(e.VisibleIndex);
        }
    }

    protected void checkBox_Init(object sender, EventArgs e)
    {
        ASPxCheckBox checkBox = sender as ASPxCheckBox;
        GridViewGroupRowTemplateContainer container = checkBox.NamingContainer as GridViewGroupRowTemplateContainer;
        checkBox.ClientSideEvents.CheckedChanged = string.Format("function(s, e){{ Grid.PerformCallback('{0};{1};' + s.GetChecked()); }}", container.VisibleIndex, container.Column.FieldName);
    }
}
