using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAwardTest2 : System.Web.UI.Page
    {
        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel)ViewState["ViewModel"];
            }
        }

        private List<usp_GetAwardedQuotes_Result> _quoteList;
        private List<usp_GetAwardedQuotes_Result> QuoteList
        {
            get
            {
                if (_quoteList != null) return _quoteList;
                _quoteList = _quoteList ?? ((List<usp_GetAwardedQuotes_Result>)ViewState["QuoteList"] ??
                                            ViewModel.GetAwardedQuotes());
                //if (ViewState["QuoteList"] == null)
                //    ViewState["QuoteList"] = ViewModel.GetAwardedQuotes();
                //return (List<usp_GetAwardedQuotes_Result>) ViewState["QuoteList"];
                return _quoteList;
            }
        }

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

        protected void btnNewSalesAward_Click(object sender, EventArgs e)
        {
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Response.Redirect("CreateAwardedQuote.aspx");
        }

        protected void btnQuoteTransfer_Click(object sender, EventArgs e)
        {
            if (gvQuote.FocusedRowIndex > -1)
            {
                string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
                Session["QuoteNumber"] = quote;
            }
            Session["RedirectPage"] = "~/NewSalesAward/Pages/NewSalesAwards.aspx";
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Session["FocusedRowIndex"] = gvQuote.FocusedRowIndex;
            Response.Redirect("~/QuoteLogIntegration/Pages/QuoteTransfer.aspx");
        }

        protected void btnCustomerCommitment_Click(object sender, EventArgs e)
        {
            //// ***** Need quote number ???
            //Session["AttachmentCategory"] = "CustomerCommitment";

            //ShowQuoteFiles("CustomerCommitment");
            //btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            //pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnAltCustomerCommitment_Click(object sender, EventArgs e)
        {
            //Session["AttachmentCategory"] = "AltCustomerCommitment";

            //ShowQuoteFiles("AltCustomerCommitment");
            //btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            //pcFileUpload.ShowOnPageLoad = true;
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
                cbxMode.SelectedIndex = (int)Session["ModeIndex"];
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







        protected void pcEdit_OnWindowCallback(object source, PopupWindowCallbackArgs e)
        {
            var quoteNumber = (string)gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");

            //  Get the list entry.
            var awardedQuote = QuoteList.FirstOrDefault(q => q.QuoteNumber == quoteNumber);

            NSAEditPopupContents.SetQuote(awardedQuote);
        }


    }
}