using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using DevExpress.Web;
using SupplierEDI.Web.SupplierEDIModule.Models;
using SupplierEDI.Web.SupplierEDIModule.ViewModels;

namespace SupplierEDI.Web.SupplierEDIModule.Pages
{
    public partial class GridTest : Page
    {
        private List<usp_GetPurchaseOrderList_Result> SelectedPOs
        {
            get
            {
                if (!(ViewState["SelectedPOs"] is List<usp_GetPurchaseOrderList_Result>))
                    ViewState["SelectedPOs"] = new List<usp_GetPurchaseOrderList_Result>();

                return (List<usp_GetPurchaseOrderList_Result>) ViewState["SelectedPOs"];
            }
        }

        private bool IsGroupSelection
        {
            get
            {
                if (!(ViewState["IsGroupSelection"] is bool))
                    ViewState["IsGroupSelection"] = false;

                return (bool) ViewState["IsGroupSelection"];
            }
            set => ViewState["IsGroupSelection"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Grid2.DataSource = SelectedPOs;
            Grid2.DataBind();

            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
            Response.Cache.SetNoStore();
            Response.AppendHeader("pragma", "no-cache");
            if (!Page.IsPostBack) AuthenticateUser();
        }

        private void AuthenticateUser()
        {
            //HttpCookie authCookie = Request.Cookies["WebOk"];
            //if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        protected void _E1_OnClick(object sender, EventArgs e)
        {
            UpdatePOSelection();
            foreach (var item in MainFormLayout.Items)
            {
                var tlg = item as TabbedLayoutGroup;
                if (tlg?.Name != "TabLayout") continue;
                tlg.PageControl.ActiveTabIndex++;
            }
        }

        private void UpdatePOSelection()
        {
            var allPOs = new PurchaseOrdersViewModel().GetList();
            var selectedPONumbers = Grid1.GetSelectedFieldValues(Grid1.KeyFieldName);
            //var 
            SelectedPOs.Clear();
            SelectedPOs.AddRange(allPOs.Where(p => selectedPONumbers.Any(sp => (int) sp == p.PurchaseOrderNumber)));
            Grid2.DataSource = SelectedPOs;
            Grid2.DataBind();
        }

        protected void Grid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            IsGroupSelection = true;
            var parameters = e.Parameters.Split(';');
            var index = int.Parse(parameters[0]);
            var fieldName = parameters[1];
            var isGroupRowSelected = bool.Parse(parameters[2]);

            var groupedCols = Grid1.GetGroupedColumns();

            if (groupedCols[groupedCols.Count - 1].FieldName == fieldName)
            {
                //  Check groupcolumn is the lowest level group column.

                Grid1.ExpandRow(index, true); // ensures consistent behavior
                for (var i = 0; i < Grid1.GetChildRowCount(index); i++)
                {
                    var row = (usp_GetPurchaseOrderList_Result) Grid1.GetChildRow(index, i);
                    Grid1.Selection.SetSelectionByKey(row.PurchaseOrderNumber, isGroupRowSelected);
                }
            }
            else
            {
                //  Checked row is not the lowest group column.   Recursively iterate (requires row expansion).
                var gidx = -1;
                foreach (var gcol in groupedCols)
                    if (gcol.FieldName == fieldName)
                    {
                        gidx = groupedCols.IndexOf(gcol);
                        break;
                    }

                var checkedDataRow = (usp_GetPurchaseOrderList_Result) Grid1.GetRow(index);
                var parentFieldnameValuesDict = new Dictionary<string, object>();
                string parentFieldName;
                object parentKeyValue;
                for (var i = gidx; i >= 0; i--)
                {
                    var pcol = groupedCols[i];
                    parentFieldName = pcol.FieldName;
                    parentKeyValue = GetPropValue(checkedDataRow, parentFieldName);
                    parentFieldnameValuesDict.Add(parentFieldName, parentKeyValue);
                }

                bool isRowChildOfClickedGroup;
                Grid1.ExpandRow(index, true);
                for (var i = 0; i <= Grid1.VisibleRowCount - 1; i++)
                {
                    var row = (usp_GetPurchaseOrderList_Result) Grid1.GetRow(i);

                    isRowChildOfClickedGroup = true;
                    //  Check if row belongs to checked group.
                    foreach (var kvp in parentFieldnameValuesDict)
                    {
                        parentFieldName = kvp.Key;
                        parentKeyValue = kvp.Value;
                        if (GetPropValue(row, parentFieldName).Equals(parentKeyValue) == false)
                        {
                            isRowChildOfClickedGroup = false;
                            break;
                        }
                    }

                    if (isRowChildOfClickedGroup)
                        Grid1.Selection.SetSelectionByKey(row.PurchaseOrderNumber, isGroupRowSelected);
                }
            }

            IsGroupSelection = false;
            UpdatePOSelection();
        }

        protected bool GetChecked(int visibleIndex)
        {
            for (var i = 0; i < Grid1.GetChildRowCount(visibleIndex); i++)
            {
                var isRowSelected = Grid1.Selection.IsRowSelectedByKey(
                    ((usp_GetPurchaseOrderList_Result) Grid1.GetChildRow(visibleIndex, i)).PurchaseOrderNumber);
                if (!isRowSelected)
                    return false;
            }

            return true;
        }

        protected string GetCaptionText(GridViewGroupRowTemplateContainer container)
        {
            var captionText = !string.IsNullOrEmpty(container.Column.Caption)
                ? container.Column.Caption
                : container.Column.FieldName;
            return $"{captionText} : {container.GroupText} {container.SummaryText}";
        }

        protected void Grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Group) return;
            var checkBox = (ASPxCheckBox) Grid1.FindGroupRowTemplateControl(e.VisibleIndex, "groupCheckBox");
            checkBox.Checked = GetChecked(e.VisibleIndex);
        }

        protected void groupCheckBox_OnInit(object sender, EventArgs e)
        {
            var checkBox = (ASPxCheckBox) sender;
            var container = (GridViewGroupRowTemplateContainer) checkBox.NamingContainer;
            checkBox.ClientSideEvents.CheckedChanged =
                $"function(s, e){{ Grid1.PerformCallback('{container.VisibleIndex};{container.Column.FieldName};' + s.GetChecked()); }}";
        }

        public static object GetPropValue(object src, string propName)
        {
            return src.GetType().GetProperty(propName)?.GetValue(src, null);
        }

        protected void Grid1_OnSelectionChanged(object sender, EventArgs e)
        {
            if (IsGroupSelection) return;
            UpdatePOSelection();
        }
    }
}