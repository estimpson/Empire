using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using SupplierEDI.Web.SupplierEDIModule.Models;

namespace SupplierEDI.Web.SupplierEDIModule.Pages
{
    public partial class PurchaseOrderList_GenerateReleasePlans : System.Web.UI.Page
    {
        private List<usp_GetPurchaseOrderList_Result> _selectedPOs = new List<usp_GetPurchaseOrderList_Result>();

        protected void Page_Load(object sender, EventArgs e)
        {
            SelectedPurchaseOrdersGrid.DataSource = _selectedPOs;
            SelectedPurchaseOrdersGrid.DataBind();
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
            Response.Cache.SetNoStore();
            Response.AppendHeader("pragma", "no-cache");
            if (!Page.IsPostBack)
            {
                AuthenticateUser();
            }
        }

        protected string GetCaptionText(GridViewGroupRowTemplateContainer container)
        {
            string captionText = !string.IsNullOrEmpty(container.Column.Caption) ? container.Column.Caption : container.Column.FieldName;
            return string.Format("{0} : {1} {2}", captionText, container.GroupText, container.SummaryText);
        }

        protected bool GetChecked(int visibleIndex)
        {
            for (int i = 0; i < PurchaseOrdersGrid.GetChildRowCount(visibleIndex); i++)
            {
                bool isRowSelected = PurchaseOrdersGrid.Selection.IsRowSelectedByKey(
                    ((usp_GetPurchaseOrderList_Result) PurchaseOrdersGrid.GetChildRow(visibleIndex, i)).PurchaseOrderNumber);
                if (!isRowSelected)
                    return false;
            }
            return true;
        }

        protected void Grid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var parameters = e.Parameters.Split(';');
            var index = int.Parse(parameters[0]);
            var fieldName = parameters[1];
            var isGroupRowSelected = bool.Parse(parameters[2]);

            System.Collections.ObjectModel.ReadOnlyCollection<GridViewDataColumn> groupedCols = PurchaseOrdersGrid.GetGroupedColumns();

            if (groupedCols[groupedCols.Count - 1].FieldName == fieldName)
            {
                //  Check groupcolumn is the lowest level group column.

                PurchaseOrdersGrid.ExpandRow(index, true); // ensures consistent behavior
                for (int i = 0; i < PurchaseOrdersGrid.GetChildRowCount(index); i++)
                {
                    var row = (usp_GetPurchaseOrderList_Result) PurchaseOrdersGrid.GetChildRow(index, i);
                    PurchaseOrdersGrid.Selection.SetSelectionByKey(row.PurchaseOrderNumber, isGroupRowSelected);
                }
            }
            else
            {
                //  Checked row is not the lowest group column.   Recursively iterate (requires row expansion).
                int gidx = -1;
                foreach (var gcol in groupedCols)
                {
                    if (gcol.FieldName == fieldName)
                    {
                        gidx = groupedCols.IndexOf(gcol);
                        break;
                    }
                }

                var checkedDataRow = (usp_GetPurchaseOrderList_Result)PurchaseOrdersGrid.GetRow(index);
                var parentFieldnameValuesDict = new Dictionary<string, object>();
                string parentFieldName;
                object parentKeyValue;
                for (int i = gidx; i >= 0; i--)
                {
                    var pcol = groupedCols[i];
                    parentFieldName = pcol.FieldName;
                    parentKeyValue = GetPropValue(checkedDataRow, parentFieldName);
                    parentFieldnameValuesDict.Add(parentFieldName, parentKeyValue);
                }

                bool isRowChildOfClickedGroup;
                PurchaseOrdersGrid.ExpandRow(index, true);
                for (int i = 0; i <= PurchaseOrdersGrid.VisibleRowCount - 1; i++)
                {
                    var row = (usp_GetPurchaseOrderList_Result) PurchaseOrdersGrid.GetRow(i);

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
                    {
                        //  Row meets all criteria for belonging to the clicked group, change selected state.
                        PurchaseOrdersGrid.Selection.SetSelectionByKey(row.PurchaseOrderNumber, isGroupRowSelected);
                    }
                }
            }
            UpdatePOSelection();
        }

        public static object GetPropValue(object src, string propName)
        {
            return src.GetType().GetProperty(propName).GetValue(src, null);
        }

        //private void SelectChild(int parent, int child)
        //{
        //    var childRowCount = PurchaseOrdersGrid.GetChildRowCount(parent);
        //    PurchaseOrdersGrid.
        //}

        protected void Grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Group) return;
            var checkBox = (ASPxCheckBox)PurchaseOrdersGrid.FindGroupRowTemplateControl(e.VisibleIndex, "groupCheckBox");
            checkBox.Checked = GetChecked(e.VisibleIndex);
        }
        protected void groupCheckBox_OnInit(object sender, EventArgs e)
        {
            var checkBox = (ASPxCheckBox) sender;
            var container = (GridViewGroupRowTemplateContainer) checkBox.NamingContainer;
            checkBox.ClientSideEvents.CheckedChanged = string.Format("function(s, e){{ PurchaseOrdersGrid.PerformCallback('{0};{1};' + s.GetChecked()); }}", container.VisibleIndex, container.Column.FieldName);
        }

        #region Methods
        private void AuthenticateUser()
        {
            //HttpCookie authCookie = Request.Cookies["WebOk"];
            //if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }
        #endregion

        protected void cbxNext_OnClick(object sender, EventArgs e)
        {
            UpdatePOSelection();
            foreach (var item in FormLayout.Items)
            {
                var tlg = item as TabbedLayoutGroup;
                if (tlg?.Name != "TabLayout") continue;
                tlg.PageControl.ActiveTabIndex++;
            }

            
        }

        protected void PurchaseOrdersGrid_OnSelectionChanged(object sender, EventArgs e)
        {
            return;
            var allPOsList = (List<usp_GetPurchaseOrderList_Result>) ObjectDataSourcePOs.Select();
            var selectedPONumbers = PurchaseOrdersGrid.GetSelectedFieldValues(PurchaseOrdersGrid.KeyFieldName);
            _selectedPOs = allPOsList.Where(p => selectedPONumbers.Any(sp => (int)sp == p.PurchaseOrderNumber)).ToList();
            //foreach (var selectedPONumber in PurchaseOrdersGrid.GetSelectedFieldValues(PurchaseOrdersGrid.KeyFieldName))
            //{

            //    //var selectedPO = PurchaseOrdersGrid.GetRow(PurchaseOrdersGrid.Get);

            //}
            //var x = PurchaseOrdersGrid.Selection.Count;
            //SelectedPurcaseOrderCount.Text = x.ToString();

            SelectedPurchaseOrdersGrid.DataSource = _selectedPOs;
        }

        private void UpdatePOSelection()
        {
            var allPOsList = (List<usp_GetPurchaseOrderList_Result>)ObjectDataSourcePOs.Select();
            var selectedPONumbers = PurchaseOrdersGrid.GetSelectedFieldValues(PurchaseOrdersGrid.KeyFieldName);
            _selectedPOs.Clear();
            _selectedPOs.AddRange(allPOsList.Where(p => selectedPONumbers.Any(sp => (int)sp == p.PurchaseOrderNumber)).ToList());
            //SelectedPurchaseOrdersGrid.DataSource = _selectedPOs;
            //SelectedPurchaseOrdersGrid.DataBind();
        }
    }
}