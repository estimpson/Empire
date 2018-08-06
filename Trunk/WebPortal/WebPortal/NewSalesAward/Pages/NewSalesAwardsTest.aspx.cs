using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAwardsTest : Page
    {
        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        private List<usp_GetAwardedQuotes_Result> _quoteList;
        private List<usp_GetAwardedQuotes_Result> QuoteList
        {
            get
            {
                if (_quoteList != null) return _quoteList;
                _quoteList = _quoteList ?? ((List<usp_GetAwardedQuotes_Result>) ViewState["QuoteList"] ??
                                            ViewModel.GetAwardedQuotes());
                //if (ViewState["QuoteList"] == null)
                //    ViewState["QuoteList"] = ViewModel.GetAwardedQuotes();
                //return (List<usp_GetAwardedQuotes_Result>) ViewState["QuoteList"];
                return _quoteList;
            }
        }

        private List<I_NSATabView> NSATabViews => new List<I_NSATabView> { NSACustomerPOTabView, NSAHardToolingTabView, NSAToolingAmortizationTabView, NSATesterToolingTabView, NSABasePartAttributesTabView, NSABasePartMnemonicsTabView, NSALogisticsTabView };

        protected void Page_Init(object sender, EventArgs e)
        {
            gvQuote.DataSource = QuoteList;
            gvQuote.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) PopulateModeList();
        }

        protected void gvQuote_DataBound(object sender, EventArgs e)
        {
            SetFocusedRow();
        }

        protected void cbxMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvQuote.IsEditing) gvQuote.CancelEdit();

            ToggleColumnButtonVisibility();
            HideLoadingPanel(LoadingPanelTrigger.Mode);
        }

        private void AuthenticateUser()
        {
            var authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) Response.Redirect("~/Pages/UnathenticatedRedirect.aspx");
        }

        private void PopulateModeList()
        {
            var list = new List<string>
            {
                "Quote",
                "Customer PO",
                "Hard Tooling",
                "Assembly Tester Tooling",
                "Tooling Amortization",
                "Base Part Attributes",
                "Base Part Mnemonics",
                "Logistics"
            };

            cbxMode.DataSource = list;
            cbxMode.DataBind();

            // If returning from another page, pick up where the user left off
            if (Session["ModeIndex"] != null)
            {
                cbxMode.SelectedIndex = (int) Session["ModeIndex"];
                ToggleColumnButtonVisibility();
            }
            else
            {
                cbxMode.SelectedIndex = 0;
            }
        }

        private void SetFocusedRow()
        {
            if (Session["FocusedRowIndex"] == null) return;
            int i = Convert.ToInt16(Session["FocusedRowIndex"]);
            gvQuote.FocusedRowIndex = i;
            gvQuote.ScrollToVisibleIndexOnClient = i;
        }

        private void ToggleColumnButtonVisibility()
        {
            // Hide all data columns
            for (var i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = false;

            // Show only the columns required for updating the selected mode
            var mode = cbxMode.SelectedItem.Value.ToString();
            switch (mode)
            {
                case "Quote":
                    for (var i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = true;
                    break;
                case "Customer PO":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["PurchaseOrderDate"].Visible = true;
                    gvQuote.Columns["CustomerProductionPurchaseOrderNumber"].Visible = true;
                    gvQuote.Columns["AlternativeCustomerCommitment"].Visible = true;
                    gvQuote.Columns["PurchaseOrderSellingPrice"].Visible = true;
                    gvQuote.Columns["PurchaseOrderSOP"].Visible = true;
                    gvQuote.Columns["PurchaseOrderEOP"].Visible = true;
                    gvQuote.Columns["CustomerProductionPurchaseOrderComments"].Visible = true;
                    break;
                case "Hard Tooling":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["HardToolingAmount"].Visible = true;
                    gvQuote.Columns["HardToolingTrigger"].Visible = true;
                    gvQuote.Columns["HardToolingDescription"].Visible = true;
                    gvQuote.Columns["HardToolingCAPEXID"].Visible = true;
                    break;
                case "Tooling Amortization":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["AmortizationAmount"].Visible = true;
                    gvQuote.Columns["AmortizationQuantity"].Visible = true;
                    gvQuote.Columns["AmortizationToolingDescription"].Visible = true;
                    gvQuote.Columns["AmortizationCAPEXID"].Visible = true;
                    break;
                case "Assembly Tester Tooling":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingAmount"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingTrigger"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingDescription"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingCAPEXID"].Visible = true;
                    break;
                case "Base Part Mnemonics":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["VehiclePlantMnemonic"].Visible = true;
                    gvQuote.Columns["QtyPer"].Visible = true;
                    gvQuote.Columns["TakeRate"].Visible = true;
                    gvQuote.Columns["FamilyAllocation"].Visible = true;
                    break;
                case "Base Part Attributes":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["BasePartFamily"].Visible = true;
                    gvQuote.Columns["ProductLine"].Visible = true;
                    gvQuote.Columns["EmpireMarketSegment"].Visible = true;
                    gvQuote.Columns["EmpireMarketSubsegment"].Visible = true;
                    gvQuote.Columns["EmpireApplication"].Visible = true;
                    gvQuote.Columns["EmpireSOP"].Visible = true;
                    gvQuote.Columns["EmpireEOP"].Visible = true;
                    gvQuote.Columns["EmpireEOPNote"].Visible = true;
                    gvQuote.Columns["BasePart_Comments"].Visible = true;
                    break;
                case "Logistics":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["EmpireFacility"].Visible = true;
                    gvQuote.Columns["FreightTerms"].Visible = true;
                    gvQuote.Columns["CustomerShipTos"].Visible = true;
                    break;
                default:
                    break;
            }
        }

        private void EditModeDisableColumns(string column, ASPxEditBase e)
        {
            if (column == "QuoteNumber" || column == "BasePart")
            {
                e.ReadOnly = true;
                e.ClientEnabled = false;
            }
        }

        private void HideLoadingPanel(LoadingPanelTrigger trigger)
        {
            // Hide loading panel
            switch (trigger)
            {
                case LoadingPanelTrigger.Mode:
                    ScriptManager.RegisterClientScriptBlock(cbxMode, cbxMode.GetType(), "HideLoadingPanel",
                        "lp.Hide();", true);
                    break;
                default:
                    break;
            }
        }

        private enum LoadingPanelTrigger
        {
            Mode
        }

        protected void gvQuote_OnCustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            lblBasePart.Text = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart").ToString();

            // Purchase Order
            DateTime? purchaseOrderDt = null;
            if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderDate") != null) purchaseOrderDt = Convert.ToDateTime(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderDate"));
            //dePurchaseOrderDate.Value = purchaseOrderDt;

            //tbxPoNumber.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerProductionPurchaseOrderNumber") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerProductionPurchaseOrderNumber").ToString() : "";
            //tbxAltCustCommit.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AlternativeCustomerCommitment") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AlternativeCustomerCommitment").ToString() : "";

            //decimal? sellingPrice = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderSellingPrice") != null) sellingPrice = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderSellingPrice"));
            //tbxPoSellingPrice.Value = sellingPrice;

            //DateTime? poSop = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderSOP") != null) poSop = Convert.ToDateTime(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderSOP"));
            //dePoSop.Value = poSop;

            //DateTime? poEop = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderEOP") != null) poEop = Convert.ToDateTime(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "PurchaseOrderEOP"));
            //dePoEop.Value = poEop;

            //tbxPoComments.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerProductionPurchaseOrderComments") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerProductionPurchaseOrderComments").ToString() : "";



            //// Hard Tooling
            //decimal? toolingAmount = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingAmount") != null) toolingAmount = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingAmount"));
            //tbxHardToolingAmount.Value = toolingAmount;

            //tbxHardToolingTrigger.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingTrigger") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingTrigger").ToString() : "";
            //tbxHardToolingDescription.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingDescription") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingDescription").ToString() : "";
            //tbxHardToolingCAPEXID.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingCAPEXID") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "HardToolingCAPEXID").ToString() : "";



            //// Tooling Amortization
            //decimal? amAmount = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationAmount") != null) amAmount = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationAmount"));
            //tbxAmortizationAmount.Value = amAmount;

            //decimal? amQuantity = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationQuantity") != null) amQuantity = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationQuantity"));
            //tbxAmortizationQuantity.Value = amQuantity;

            //tbxAmortizationToolingDescription.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationToolingDescription") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationToolingDescription").ToString() : "";
            //tbxAmortizationCAPEXID.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationCAPEXID") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AmortizationCAPEXID").ToString() : "";



            //// Assembly Tester Tooling
            //decimal? assemblyTesterToolingAmount = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingAmount") != null) assemblyTesterToolingAmount = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingAmount"));
            //tbxAssemblyTesterToolingAmount.Value = assemblyTesterToolingAmount;

            //tbxAssemblyTesterToolingTrigger.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingTrigger") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingTrigger").ToString() : "";
            //tbxAssemblyTesterToolingDescription.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingDescription") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingDescription").ToString() : "";
            //tbxAssemblyTesterToolingCAPEXID.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingCAPEXID") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "AssemblyTesterToolingCAPEXID").ToString() : "";



            //// Logistics
            //cbxEmpireFacility.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireFacility") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireFacility").ToString() : "";
            //cbxFreightTerms.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "FreightTerms") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "FreightTerms").ToString() : "";
            //cbxCustomerShipTos.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerShipTos") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "CustomerShipTos").ToString() : "";



            //// Base Part Attributes
            //tbxBasePartFamily.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePartFamily") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePartFamily").ToString() : "";
            //cbxProductLine.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "ProductLine") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "ProductLine").ToString() : "";
            //cbxEmpireMarketSegment.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireMarketSegment") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireMarketSegment").ToString() : "";
            //cbxEmpireMarketSubsegment.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireMarketSubsegment") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireMarketSubsegment").ToString() : "";
            //tbxEmpireApplication.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireApplication") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireApplication").ToString() : "";
            ////tbxEmpireEopNote.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireEOPNote") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireEOPNote").ToString() : "";

            //DateTime? empireSop = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireSOP") != null) empireSop = Convert.ToDateTime(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireSOP"));
            //deEmpireSop.Value = empireSop;

            //DateTime? empireEop = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireEOP") != null) empireEop = Convert.ToDateTime(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireEOP"));
            //deEmpireEop.Value = empireEop;

            //tbxBasePartAttributesComments.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart_Comments") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart_Comments").ToString() : "";



            //// Base Part Mnemonics
            //tbxVehiclePlantMnemonic.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "VehiclePlantMnemonic") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "VehiclePlantMnemonic").ToString() : "";

            //decimal? qtyPer = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QtyPer") != null) qtyPer = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QtyPer"));
            //tbxQtyPer.Value = qtyPer;

            //decimal? takeRate = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "TakeRate") != null) takeRate = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "TakeRate"));
            //tbxTakeRate.Value = takeRate;

            //tbxFamilyAllocation.Text = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "FamilyAllocation") != null) ? gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "FamilyAllocation").ToString() : "";

            //decimal? quotedEau = null;
            //if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuotedEAU") != null) quotedEau = Convert.ToDecimal(gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuotedEAU"));
            //tbxQuotedEau.Value = quotedEau;


            pcEdit.ShowOnPageLoad = true;
        }

        protected void pcEdit_OnWindowCallback(object source, PopupWindowCallbackArgs e)
        {
            var quoteNumber = (string) gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
            lblBasePart.Text = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart").ToString();

            //  Get the list entry.
            var awardedQuote = QuoteList.FirstOrDefault(q => q.QuoteNumber == quoteNumber);

            //  Set quote for each tab view.
            foreach (var nsaTabView in NSATabViews)
            {
                nsaTabView.SetQuote(awardedQuote);
            }

            //  Make the first tab visible.
            NSAEditPageControl.ActiveTabPage = NSAEditPageControl.TabPages[0];
        }
    }
}