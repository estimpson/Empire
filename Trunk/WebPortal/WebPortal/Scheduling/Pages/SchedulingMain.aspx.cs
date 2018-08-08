using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.Scheduling.PageViewModels;

namespace WebPortal.Scheduling
{
    public partial class Main : System.Web.UI.Page
    {
        private PageViewModels.SchedulersViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] !=null)
                {
                    return (SchedulersViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new SchedulersViewModel();
                return ViewModel;
            }
        }

        private Boolean Refreshing { get; set; }

        private List<DataModels.SchedulersDataModel> Schedulers
        {
            get
            {
                if (ViewState["Schedulers"] != null)
                {
                    return (List<DataModels.SchedulersDataModel>)ViewState["Schedulers"];
                }
                ViewState["Schedulers"] = new List<DataModels.SchedulersDataModel>();
                return Schedulers;
            }
        }

        private string Operator
        {
            get { return ViewState["Operator"] != null ? (string)ViewState["Operator"] : ""; }
            set { ViewState["Operator"] = value; }
        }

        private string Name
        {
            get { return ViewState["Name"] != null ? (string)ViewState["Name"] : ""; }
            set { ViewState["Name"] = value; }
        }

        private string FinishedPart
        {
            get { return ViewState["FinishedPart"] != null ? (string)ViewState["FinishedPart"] : ""; }
            set { ViewState["FinishedPart"] = value; }
        }

        private string Revision
        {
            get { return ViewState["Revision"] != null ? (string)ViewState["Revision"] : ""; }
            set { ViewState["Revision"] = value; }
        }

        private string CustomerPart
        {
            get { return ViewState["CustomerPart"] != null ? (string)ViewState["CustomerPart"] : ""; }
            set { ViewState["CustomerPart"] = value; }
        }





        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
            }
            else
            {
                AuthenticateUser();

                Operator = Request.QueryString["op"];
                Name = Request.QueryString["name"];

                GetSchedulers();

                try
                {
                    GridViewFormatConditionHighlight Rule2 = new GridViewFormatConditionHighlight();
                    Rule2.FieldName = "WeeksOnHand";
                    Rule2.Expression = "[WeeksOnHandWarnFlag] > 2";
                    Rule2.Format = GridConditionHighlightFormat.GreenFillWithDarkGreenText;
                    gvwSnapshotCalendar.FormatConditions.Add(Rule2);
                }
                catch (Exception ex)
                {

                    throw;
                }


                //gvwFinishedParts.FocusedRowIndex = -1;
            }
        }


        #region Control Events

        protected void tbxOverrideCustRequirement_Init(object sender, EventArgs e)
        {
            ASPxTextBox txt = sender as ASPxTextBox;
            GridViewDataItemTemplateContainer container = txt.NamingContainer as GridViewDataItemTemplateContainer;
            txt.ClientInstanceName = String.Format("tbx{0}", container.VisibleIndex);
            txt.ClientSideEvents.KeyPress = String.Format("function (s, e) {{ tbx_KeyPress(s, e, {0}); }}", container.VisibleIndex);
        }
 

        protected void cbxSchedulers_SelectedIndexChanged(object sender, EventArgs e)
        {
            string schedulerId = (cbxSchedulers.SelectedItem.Value == null)
                ? schedulerId = cbxSchedulers.Value.ToString()
                : schedulerId = cbxSchedulers.SelectedItem.Value.ToString();

            GetFinishedParts(schedulerId);

            //gvwFinishedParts.Selection.UnselectAll();

            gvwFinishedParts.ScrollToVisibleIndexOnClient = gvwFinishedParts.VisibleStartIndex;
        }

        protected void gvwFinishedParts_FocusedRowChanged(object sender, EventArgs e)
        {
            if (gvwFinishedParts.FocusedRowIndex < 0) return;

            string part = gvwFinishedParts.GetRowValues(gvwFinishedParts.FocusedRowIndex, "FinishedPart").ToString();
            string revision = gvwFinishedParts.GetRowValues(gvwFinishedParts.FocusedRowIndex, "Revision").ToString();

            FinishedPart = part;
            Revision = revision;
        }

        protected void btnHidGetHeaderDetail_Click(object sender, EventArgs e)
        {
            GetHeaderInfo(FinishedPart, Revision);

            GetSnapshotCalendar(FinishedPart, Revision);
        }

        protected void btnHidOverrideCustRequirementDn_Click(object sender, EventArgs e)
        {
            if (Refreshing) return;
            int i = gvwSnapshotCalendar.FocusedRowIndex;



            var column = gvwSnapshotCalendar.Columns["OverrideCustomerRequirement"] as GridViewDataColumn;
            var textBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i, column, "tbxOverrideCustRequirement") as ASPxTextBox;
            string sNewRequirement = textBox.Text;

            string sCalendarDt = gvwSnapshotCalendar.GetRowValues(i, "CalendarDT").ToString();
            DateTime calendarDt = DateTime.Parse(sCalendarDt);

            decimal? newRequirement = (sNewRequirement == "") ? newRequirement = null : Convert.ToDecimal(sNewRequirement);
            
            UpdateSnapshotCalendarOverrideCustReq(calendarDt, newRequirement);


            var nextTextBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i + 1, column, "tbxOverrideCustRequirement") as ASPxTextBox;
            nextTextBox.Focus();
        }

        protected void btnHidNewOnOrderEehDn_Click(object sender, EventArgs e)
        {
            if (Refreshing) return;
            int i = gvwSnapshotCalendar.FocusedRowIndex;

            var column = gvwSnapshotCalendar.Columns["NewOnOrderEEH"] as GridViewDataColumn;
            var textBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i, column, "tbxNewOnOrderEeh") as ASPxTextBox;
            string sNewOnOrder = textBox.Text;

            string sCalendarDt = gvwSnapshotCalendar.GetRowValues(i, "CalendarDT").ToString();
            DateTime calendarDt = DateTime.Parse(sCalendarDt);

            decimal? newOnOrder = (sNewOnOrder == "") ? newOnOrder = null : Convert.ToDecimal(sNewOnOrder);

            UpdateSnapshotCalendarNewOnOrderEeh(calendarDt, newOnOrder);


            var nextTextBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i + 1, column, "tbxNewOnOrderEeh") as ASPxTextBox;
            nextTextBox.Focus();
        }


        protected void btnHidOverrideCustRequirementUp_Click(object sender, EventArgs e)
        {
            if (Refreshing) return;
            int i = gvwSnapshotCalendar.FocusedRowIndex;

            var column = gvwSnapshotCalendar.Columns["OverrideCustomerRequirement"] as GridViewDataColumn;
            var textBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i, column, "tbxOverrideCustRequirement") as ASPxTextBox;
            string sNewRequirement = textBox.Text;

            string sCalendarDt = gvwSnapshotCalendar.GetRowValues(i, "CalendarDT").ToString();
            DateTime calendarDt = DateTime.Parse(sCalendarDt);

            decimal? newRequirement = (sNewRequirement == "") ? newRequirement = null : Convert.ToDecimal(sNewRequirement);

            UpdateSnapshotCalendarOverrideCustReq(calendarDt, newRequirement);


            var nextTextBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i - 1, column, "tbxOverrideCustRequirement") as ASPxTextBox;
            nextTextBox.Focus();
        }

        protected void btnHidNewOnOrderEehUp_Click(object sender, EventArgs e)
        {
            if (Refreshing) return;
            int i = gvwSnapshotCalendar.FocusedRowIndex;

            var column = gvwSnapshotCalendar.Columns["NewOnOrderEEH"] as GridViewDataColumn;
            var textBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i, column, "tbxNewOnOrderEeh") as ASPxTextBox;
            string sNewOnOrder = textBox.Text;

            string sCalendarDt = gvwSnapshotCalendar.GetRowValues(i, "CalendarDT").ToString();
            DateTime calendarDt = DateTime.Parse(sCalendarDt);

            decimal? newOnOrder = (sNewOnOrder == "") ? newOnOrder = null : Convert.ToDecimal(sNewOnOrder);

            UpdateSnapshotCalendarNewOnOrderEeh(calendarDt, newOnOrder);


            var nextTextBox = gvwSnapshotCalendar.FindRowCellTemplateControl(i - 1, column, "tbxNewOnOrderEeh") as ASPxTextBox;
            nextTextBox.Focus();
        }


        protected void gvwSnapshotCalendar_HtmlDataCellPrepared(object sender, DevExpress.Web.ASPxGridViewTableDataCellEventArgs e)
        {
            //ASPxGridView gridView = (ASPxGridView)sender;
            string column = e.DataColumn.FieldName;
            if (column == "WeeksOnHand")
            {
                int flag = Convert.ToInt16(e.GetValue("WeeksOnHandWarnFlag"));
                switch (flag)
                {
                    case 0:
                        e.Cell.BackColor = ColorTranslator.FromHtml("#f72100"); // red
                        break;
                    case 1:
                        e.Cell.BackColor = ColorTranslator.FromHtml("#f7da00"); // yellow
                        break;
                    case 2:
                        e.Cell.BackColor = ColorTranslator.FromHtml("#00f77c"); // green
                        break;
                    case 3:
                        //e.Cell.BackColor = ColorTranslator.FromHtml("#744dff"); // blue
                        break;
                    default:
                        break;
                }
            }

            if (column == "TotalInventory" || column == "CustomerRequirement" || column == "OverrideCustomerRequirement" ||
                column == "InTransQty" || column == "OnOrderEEH" || column == "Balance" || column == "WeeksOnHand")
            {
                string amt = e.GetValue("TotalInventory").ToString();
                if (amt.Contains("(")) { e.Cell.ForeColor = ColorTranslator.FromHtml("#000000"); }
            }
        }

        protected void vgSnapshotCalendar_SelectionChanged(object sender, EventArgs e)
        {
         
        }

        protected void btnComplete_Click(object sender, EventArgs e)
        {

        }

        #endregion


        #region Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        private void GetSchedulers()
        {
            string result = ViewModel.GetSchedulers();
            if (result != "")
            {
                lblError.Text = "Failed to return schedulers list. " + result + " GetSchedulers().";
                pcError.ShowOnPageLoad = true;
                return;
            }

            cbxSchedulers.DataSource = null;
            cbxSchedulers.DataSource = ViewModel.SchedulersList;
            cbxSchedulers.TextField = "Scheduler";
            cbxSchedulers.ValueField = "SchedulerId";
            cbxSchedulers.DataBind();

            foreach (var item in ViewModel.SchedulersList)
            {
                if (item.Scheduler == Name)
                {
                    // Set selected scheduler as logged in scheduler
                    cbxSchedulers.Text = Name;

                    // Get parts associated with this scheduler
                    GetFinishedParts(item.SchedulerId);
                }
            }
        }

        private void GetFinishedParts(string schedulerId)
        {
            string result = ViewModel.GetFinishedParts(schedulerId);
            if (result != "")
            {
                lblError.Text = "Failed to return finished parts list. " + result + " GetFinishedParts().";
                pcError.ShowOnPageLoad = true;
                return;
            }

            gvwFinishedParts.DataSource = null;
            gvwFinishedParts.DataSource = ViewModel.FinishedPartsList;
            gvwFinishedParts.DataBind();

            gvwFinishedParts.FocusedRowIndex = -1;

     
            tbxCustomerPart.Text = tbxDescription.Text = tbxStandardPack.Text = tbxDefaultPo.Text = tbxSalesPrice.Text = "";
            ViewModel.SnapshotCalendarList.Clear();
            gvwSnapshotCalendar.DataBind();
        }

        private void GetHeaderInfo(string part, string revision)
        {
            string result = ViewModel.GetHeaderInfo(part, revision);
            if (result != "")
            {
                lblError.Text = "Failed to return header information. " + result + " GetHeaderInfo.";
                pcError.ShowOnPageLoad = true;
                return;
            }

            foreach (var item in ViewModel.HeaderInfoList)
            {
                tbxCustomerPart.Text = item.CustomerPart;
                tbxDescription.Text = item.Description;
                tbxStandardPack.Text = item.StandardPack.ToString();
                tbxDefaultPo.Text = item.DefaultPo.ToString();
                tbxSalesPrice.Text = item.SalesPrice.ToString();
                tbxAbcClass1.Text = item.AbcClass1;
                tbxAbcClass2.Text = item.AbcClass2;
                tbxEauEei.Text = item.EauEei;
                tbxEehCapacity.Text = item.EehCapacity;
                tbxSop.Text = item.Sop;
                tbxEop.Text = item.Eop;
            }
        }

        private void GetSnapshotCalendar(string part, string revision)
        {
            Refreshing = true;
            string result = ViewModel.GetSnapShotCalendar(part, revision);
            if (result != "")
            {
                lblError.Text = "Failed to return snapshot calendar data. " + result + " GetSnapshotCalendar().";
                pcError.ShowOnPageLoad = true;
                return;
            }

            gvwSnapshotCalendar.DataSource = null;
            gvwSnapshotCalendar.DataSource = ViewModel.SnapshotCalendarList;
            gvwSnapshotCalendar.DataBind();

            vgSnapshotCalendar.DataSource = null;
            vgSnapshotCalendar.DataSource = ViewModel.SnapshotCalendarList;
            vgSnapshotCalendar.DataBind();
            Refreshing = false;
        }

        private void UpdateSnapshotCalendarOverrideCustReq(DateTime calendarDt, Decimal? newRequirement)
        {
            string result = ViewModel.UpdateSnapshotCalendarOverrideCustReq(Operator, FinishedPart, Revision, calendarDt, newRequirement);
            if (result != "")
            {
                lblError.Text = "Failed to update the snapshot calendar. " + result + " UpdateSnapshotCalendarOverrideCustReq().";
                pcError.ShowOnPageLoad = true;
                return;
            }
            
            // Success, so refresh the grid
            GetSnapshotCalendar(FinishedPart, Revision);
        }

        private void UpdateSnapshotCalendarNewOnOrderEeh(DateTime calendarDt, Decimal? newOnOrderEeh)
        {
            string result = ViewModel.UpdateSnapshotCalendarNewOnOrderEeh(Operator, FinishedPart, Revision, calendarDt, newOnOrderEeh);
            if (result != "")
            {
                lblError.Text = "Failed to update the snapshot calendar. " + result + " UpdateSnapshotCalendarNewOnOrderEeh().";
                pcError.ShowOnPageLoad = true;
                return;
            }

            // Success, so refresh the grid
            GetSnapshotCalendar(FinishedPart, Revision);
        }









        //protected void gvwSnapshotCalendar_DataBinding(object sender, EventArgs e)
        //{
        //    string part = ViewState["part"].ToString();
        //    string revision = ViewState["revision"].ToString();

        //    var viewModel = new SchedulersVewModel();
        //    string result = viewModel.GetSnapShotCalendar(part, revision);
        //    if (result != "")
        //    {
        //        lblErrorMessage.Text = result;
        //        lblErrorMessage.Visible = true;
        //        return;
        //    }

        //    gvwSnapshotCalendar.DataSource = viewModel.SnapshotCalendarList;
        //}

        #endregion


    }
}