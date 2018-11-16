using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class CsmDemand : System.Web.UI.Page
    {
        public String OperatorCode { get; private set; }

        public enum FormStateMnemonic
        {
            Assign,
            UpdateRemove
        }

        private enum LoadingPanelTrigger
        {
            Assign,
            Update,
            Remove
        }


        private PageViewModels.CsmDemandViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (CsmDemandViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new CsmDemandViewModel();
                return ViewModel;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                AuthenticateUser();

                if (Session["BasePart"] == null) Response.Redirect("~/Pages/Login.aspx");

                tbxBasePart.Text = Session["BasePart"].ToString();
                tbxCurrentTakeRate.Text = (Session["TakeRate"] != null) ? Session["TakeRate"].ToString() : "";
                tbxQtyPer.Text = tbxQtyPerCalc.Text = (Session["QtyPer"] != null) ? Session["QtyPer"].ToString() : "";

                if (Session["FamilyAllocation"] == null || Session["FamilyAllocation"].ToString() == "")
                {
                    tbxFamilyAllocation.Text = tbxFamilyAllocationCalc.Text = "1";
                }
                else
                {
                    tbxFamilyAllocation.Text = tbxFamilyAllocationCalc.Text = Session["FamilyAllocation"].ToString();
                }
                
                //tbxQuotedEauCalc.Text = Session["QuotedEau"].ToString();

                GetCalculatedTakeRate();
            }
        }



        #region Control Events

        protected void gvCsmData_DataBound(object sender, EventArgs e)
        {
            //SetGridFocusedRow();

            SetActiveMnemonicHighlighting();
            GetActiveMnemonics();

            int year = DateTime.Now.Year;
            for (int i = 1; i < 4; i++)
            {
                string col = "DemandYear" + i;
                gvCsmData.Columns[col].Caption = "Forecast Demand " + (year + i);
            }

            //ASPxGridView grid = sender as ASPxGridView;
            //SetGridSelectedRows(grid);
        }

        protected void gvCsmData_SelectionChanged(object sender, EventArgs e)
        {
            if (gvCsmData.Selection.Count < 1) return;

            var vMnemonic = gvCsmData.GetSelectedFieldValues("VehiclePlantMnemonic");
            string mnemonic = vMnemonic[0].ToString();

            bool isActive = CheckMnemonicStatus(mnemonic);
            if (isActive) // Remove mnemonic
            {
                if (RemoveCsmMnemonic(mnemonic) == 1)
                {
                    GetCalculatedTakeRate();

                    gvCsmData.Selection.UnselectAll();
                    gvCsmData.DataBind();

                    // If the user has removed the last mnemonic, set a flag to prevent sending a first mnemonic email when they re-add a mnemonic
                    if (memoMnemonic.Text.Trim() == "") Session["RemovedLastMnemonic"] = "true";
                }
            }
            else // Add mnemonic
            {
                if (ValidateForm() == 0) return;

                if (AssignCsmMnemonic(mnemonic) == 1)
                {
                    GetCalculatedTakeRate();

                    gvCsmData.Selection.UnselectAll();
                    gvCsmData.DataBind();

                    // If this is the first mnemonic attached to this base part, send a notification email
                    if (Session["RemovedLastMnemonic"] != null && memoMnemonic.Text.Trim() == "") SendFirstMnemonicEmail();
                }
            }
            HideLoadingPanel(LoadingPanelTrigger.Update);

            gvCsmData.PageIndex = 0;
            gvCsmData.FocusedRowIndex = 0;
        }

        protected void btnUpdateMnemonic_Click(object sender, EventArgs e)
        {
            if (ValidateForm() == 0) return;

            // NOTE: 
            // Qty per and family allocation are editable and will be assigned to all selected mnemonics here.
            // Take rate is calculated and assigned to all selected mnemonics when the Use Take Rate button is clicked.

            string[] collection = memoMnemonic.Text.Split(',').Select(x => x.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToArray();
            foreach (var item in collection)
            {
                string mnemonic = item.ToString();
                if (AssignCsmMnemonic(mnemonic) == 1) // Assign take rate (redundant), qty per and family allocation
                {
                    GetCalculatedTakeRate(); // This will update the calculate take rate section with the assigned qty per and family allocation 

                    //Session["UnselectAll"] = "true";
                    gvCsmData.Selection.UnselectAll();
                    gvCsmData.DataBind();
                }
            }
            HideLoadingPanel(LoadingPanelTrigger.Update);
        }

        protected void btnUseTakeRate_Click(object sender, EventArgs e)
        {
            tbxQtyPer.Text = tbxQtyPerCalc.Text;
            tbxFamilyAllocation.Text = tbxFamilyAllocationCalc.Text;
            tbxCurrentTakeRate.Text = tbxCalculatedTakeRate.Text;
            if (ValidateForm() == 0) return;

            // NOTE:
            // The calculated take rate may change when a mnemonic is selected or de-selected from the grid 
            // depending on its SOP in relation to other selected mnemonics. 

            // Assign the calculated take rate to all selected mnemonics
            string[] collection = memoMnemonic.Text.Split(',').Select(x => x.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToArray();
            foreach (var item in collection)
            {
                string mnemonic = item.ToString();
                AssignCsmMnemonic(mnemonic);
            }
            HideLoadingPanel(LoadingPanelTrigger.Update);
        }

        //protected void btnRemoveMnemonic_Click(object sender, EventArgs e)
        //{
        //    int result = RemoveCsmMnemonic();
        //    if (result == 1) gvCsmData.DataBind();

        //    HideLoadingPanel(LoadingPanelTrigger.Remove);
        //}

        protected void btnClose_Click(object sender, EventArgs e)
        {
            //string jScript = "<script>window.close();</script>";
            //ClientScript.RegisterClientScriptBlock(this.GetType(), "keyClientBlock", jScript);
        }

        #endregion


        #region Authentication Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion



        #region Methods

        private void SetGridFocusedRow()
        {
            // Grid will be sorted descending by mnemonic active flag, 
            //   so if there is a mnemonic tied to this quote/base part, the first row should get focus
            string mnemonic = Session["Mnemonic"].ToString();
            gvCsmData.FocusedRowIndex = (mnemonic == "") ? -1 : 0;
        }

        //private void SetGridSelectedRows(ASPxGridView grid)
        //{
        //    for (int i = 0; i < grid.VisibleRowCount; i++)
        //    {
        //        var activeFlag = gvCsmData.GetRowValues(i, "ActiveFlag");
        //        if ((int)activeFlag == 1) grid.Selection.SelectRow(i);
        //    }
        //}

        private void SetActiveMnemonicHighlighting()
        {
            //GridViewFormatConditionHighlight rulePlantCountry = new GridViewFormatConditionHighlight();
            //rulePlantCountry.FieldName = "SourcePlantCountry";
            //rulePlantCountry.Expression = "[ActiveFlag] = 1";
            //rulePlantCountry.Format = GridConditionHighlightFormat.BoldText;
            //gvCsmData.FormatConditions.Add(rulePlantCountry);

            //GridViewFormatConditionHighlight rulePlant = new GridViewFormatConditionHighlight();
            //rulePlant.FieldName = "SourcePlant";
            //rulePlant.Expression = "[ActiveFlag] = 1";
            //rulePlant.Format = GridConditionHighlightFormat.BoldText;
            //gvCsmData.FormatConditions.Add(rulePlant);

            GridViewFormatConditionHighlight ruleMnemonic = new GridViewFormatConditionHighlight();
            ruleMnemonic.ApplyToRow = true;
            //ruleMnemonic.FieldName = "VehiclePlantMnemonic";
            ruleMnemonic.Expression = "[ActiveFlag] = 1";
            ruleMnemonic.Format = GridConditionHighlightFormat.LightGreenFill;
            gvCsmData.FormatConditions.Add(ruleMnemonic);
        }

        private int GetAwardedQuoteBasePartMnemonic(string quote, string mnemonic)
        {
            var result = ViewModel.GetAwardedQuoteBasePartMnemonic(quote, mnemonic);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetAwardedQuoteBasePartMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            if (!result.Any()) return 0;

            foreach(var item in result)
            {
                tbxQtyPer.Text = (item.QtyPer.HasValue) ? item.QtyPer.ToString() : "";
                tbxCurrentTakeRate.Text = (item.TakeRate.HasValue) ? item.TakeRate.ToString() : "";
                tbxFamilyAllocation.Text = (item.FamilyAllocation.HasValue) ? item.FamilyAllocation.ToString() : "";
            }
            return 1;
        }

        private int AssignCsmMnemonic(string mnemonic)
        {
            string quote = Session["QuoteNumber"].ToString();
            decimal? qtyPer = Decimal.Parse(tbxQtyPer.Text);
            decimal? takeRate = Decimal.Parse(tbxCurrentTakeRate.Text);
            decimal? familyAllocation = Decimal.Parse(tbxFamilyAllocation.Text);

            ViewModel.AssignCsmMnemonic(quote, mnemonic, qtyPer, takeRate, familyAllocation);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at AssignCsmMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int RemoveCsmMnemonic(string mnemonic)
        {
            string quote = Session["QuoteNumber"].ToString();

            ViewModel.RemoveCsmMnemonic(quote, mnemonic);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at RemoveCsmMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void GetCalculatedTakeRate()
        {
            decimal? qtyPer;
            decimal? familyAlloc;
            decimal? quotedEau;
            decimal? csmDemand;
            decimal? takeRate;

            string quote = Session["QuoteNumber"].ToString();

            //if (Session["QuotedEau"] == null)
            //{
            //    tbxCalculatedTakeRate.Text = "N/A";
            //    return;
            //}

            //string sQuotedEau = Session["QuotedEau"].ToString();
            //string sQtyPer = tbxQtyPerCalc.Text.Trim();
            //string sFamilyAllocation = tbxFamilyAllocationCalc.Text.Trim();
            //if (sQuotedEau == "" || sQtyPer == "" || sFamilyAllocation == "")
            //{
            //    tbxCalculatedTakeRate.Text = "N/A";
            //    return;
            //}

            //decimal quotedEau = Convert.ToDecimal(sQuotedEau);
            //decimal qtyPer = Convert.ToDecimal(sQtyPer);
            //decimal familyAllocation = Convert.ToDecimal(sFamilyAllocation);

            ViewModel.GetCalculatedTakeRate(quote, out qtyPer, out familyAlloc, out quotedEau, out csmDemand, out takeRate);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at CalculateTakeRate. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }

            if (qtyPer.HasValue) tbxQtyPerCalc.Text = qtyPer.ToString();
            if (familyAlloc.HasValue) tbxFamilyAllocationCalc.Text = familyAlloc.ToString();
            if (quotedEau.HasValue) tbxQuotedEauCalc.Text = quotedEau.ToString();
            if (csmDemand.HasValue) tbxForecastDemandCalc.Text = csmDemand.ToString();
            if (takeRate.HasValue) tbxCalculatedTakeRate.Text = takeRate.ToString();
        }

        private void GetActiveMnemonics()
        {
            string quote = Session["QuoteNumber"].ToString();
            memoMnemonic.Text = ViewModel.GetActiveMnemonics(quote);
        }

        //private void ToggleFormButtons(FormStateMnemonic state)
        //{
        //    if (state == FormStateMnemonic.Assign)
        //    {
        //        btnAssignMnemonic.Visible = true;
        //        btnRemoveMnemonic.Visible = btnUpdateMnemonic.Visible = false;

        //        tbxFamilyAllocation.Text = tbxQtyPer.Text = "";
        //    }
        //    else if(state == FormStateMnemonic.UpdateRemove)
        //    {
        //        btnAssignMnemonic.Visible = false;
        //        btnRemoveMnemonic.Visible = btnUpdateMnemonic.Visible = true;

        //        btnRemoveMnemonic.BackColor = Color.Red;
        //    }
        //}

        private void HideLoadingPanel(LoadingPanelTrigger trigger)
        {
            // Hide loading panel
            switch (trigger)
            {
                case LoadingPanelTrigger.Assign:
                    //ScriptManager.RegisterClientScriptBlock(btnAssignMnemonic, btnAssignMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                case LoadingPanelTrigger.Update:
                    ScriptManager.RegisterClientScriptBlock(btnUpdateMnemonic, btnUpdateMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                case LoadingPanelTrigger.Remove:
                    //ScriptManager.RegisterClientScriptBlock(btnRemoveMnemonic, btnRemoveMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                default:
                    break;
            }
        }


        private bool CheckMnemonicStatus(string mnemonic)
        {
            bool isActive = false;

            string[] collection = memoMnemonic.Text.Split(',').Select(x => x.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToArray();

            //string[] collection = memoMnemonic.Text.Split(',');
            foreach (var item in collection)
            {
                if (mnemonic == item.ToString()) isActive = true;
            }
            return isActive;
        }

        private int ValidateForm()
        {
            if (tbxQtyPer.Text.Trim() == "" || tbxCurrentTakeRate.Text.Trim() == "" || tbxFamilyAllocation.Text.Trim() == "")
            {
                lblError.Text = "Qty Per, Take Rate and Family Allocation must be entered.";
                pcError.ShowOnPageLoad = true;

                //Session["UnselectAll"] = "true";
                gvCsmData.Selection.UnselectAll();
                return 0;
            }
            return 1;
        }

        private void SendFirstMnemonicEmail()
        {
            string basePart = tbxBasePart.Text.Trim();
            string mnemonic = memoMnemonic.Text.Trim();

            ViewModel.SendFirstMnemonicEmail(basePart, mnemonic);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at CalculateTakeRate. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }
        }

        #endregion



        protected void gvCsmData_AfterPerformCallback(object sender, ASPxGridViewAfterPerformCallbackEventArgs e)
        {
            var sName = e.CallbackName;
            //try
            //{
            //    if (sName == "SELECTION")
            //    {
            //            sHTO = ((ASPxGridView)sender).GetRowValuesByKeyValue(sKey, "HTO").ToString();
            //            if (!string.IsNullOrEmpty(sHTO))
            //            {
            //                Session["IsPerpHTO"] = sHTO;
            //                GetSuspectHistory();
            //            }
            //    }
            //    else
            //    {
            //        if (sName == "FOCUSEDROW")
            //        {
            //            sHTO = ((ASPxGridView)sender).GetRowValuesByKeyValue(sKey, "HTO").ToString();
            //        }
            //    }
            //}
            //catch (NullReferenceException ex)
            //{
            //    sMessage = String.Format("PT_DFAR.gvExclusions_AfterPerformCallback: Error performing callback... Error: {0}... SPECIFICS: {1}", ex.Message, ex.GetBaseException());
            //    SysDate = DateTime.Now;
            //    //modProc.ProcErrLog("POI_Srch", int.Parse(Session["UserIdx"].ToString()), SysDate, sMessage, string.Empty, Session["RevLevel"].ToString());
            //}

        }

        protected void btnHid_Click(object sender, EventArgs e)
        {
            var x = gvCsmData.GetSelectedFieldValues("CSM_SOP");

            if (gvCsmData.FocusedRowIndex < 0) return;

            string y = gvCsmData.GetRowValues(gvCsmData.FocusedRowIndex, "VehiclePlantMnemonic").ToString();


            ScriptManager.RegisterClientScriptBlock(btnHid, btnHid.GetType(), "HideLoadingPanel", "lp.Hide();", true);
            //var x = gvCsmData.GetSelectedFieldValues("CSM_SOP");

            //foreach (var item in x)
            //{

            //}
        }


    }
}