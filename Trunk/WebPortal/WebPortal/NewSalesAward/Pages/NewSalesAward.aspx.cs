using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAward : Page
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            set => Session["AwardedQuote"] = value;
        }

        private string Mode
        {
            set => Session["Mode"] = value;
        }


        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        private List<usp_GetAwardedQuotes_Result> QuoteList
        {
            get
            {
                ViewState["QuoteList"] = ViewState["QuoteList"] ?? ViewModel.GetAwardedQuotes();
                return (List<usp_GetAwardedQuotes_Result>) ViewState["QuoteList"];
            }
            set => ViewState["QuoteList"] = value;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            SqlDataSource1.ConnectionString = ConfigurationManager.ConnectionStrings["QuoteTabSql"].ConnectionString;

            gvQuote.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            { 
                PopulateModeList();

                // Coming from another page, if it was the Create Awarded Quote page, check if a quote was awarded
                if (Session["QuoteAwarded"] != null && Session["QuoteNumber"] != null)
                {
                    // Refresh the grid
                    QuoteList = ViewModel.GetAwardedQuotes();
                    gvQuote.DataBind();

                    string quoteNumber = Session["QuoteNumber"].ToString();

                    // If a quote was awarded, show the pop-up edit form for that quote, else exit this block
                    var awardedQuote = QuoteList.FirstOrDefault(q => q.QuoteNumber == quoteNumber);
                    if (awardedQuote == null) return;

                    AwardedQuote = awardedQuote;
                    Mode = "edit";

                    NSAEditPopupContents.SetQuote();
                    pcEdit.ShowOnPageLoad = true;
                }
                else
                {
                    Mode = "Quote";
                }

                Session["QuoteAwarded"] = null;
            }
        }

        private enum LoadingPanelTrigger
        {
            Mode
        }


        #region Events

        protected void pcEdit_OnWindowCallback(object source, PopupWindowCallbackArgs e)
        {
            var quoteNumber = (string) gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");

            //  Get the list entry.
            var awardedQuote = QuoteList.FirstOrDefault(q => q.QuoteNumber == quoteNumber);

            AwardedQuote = awardedQuote;
            Mode = e.Parameter;

            NSAEditPopupContents.SetQuote();
        }

        protected void pcFixQuote_WindowCallback(object source, PopupWindowCallbackArgs e)
        {
            if (e.Parameter == "fixQuoteClicked")
            {
                // Fix Awarded Quote
                var oldQuote = tbxOldQuoteNumber.Text;
                var newQuote = cbxQuoteNumber.Value.ToString();

                ViewModel.AwardedQuoteChangeQuoteNumber(oldQuote, newQuote);
                if (ViewModel.Error == "") tbxOldQuoteNumber.Text = cbxQuoteNumber.Text = "";
                (source as ASPxPopupControl).JSProperties.Add("cpAction", "quoteFixed");
            }
            else
            {
                // Showing the popup window
                var quoteNumber = (string) gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
                tbxOldQuoteNumber.Text = quoteNumber;
                (source as ASPxPopupControl).JSProperties.Add("cpAction", "popupShown");
            }
        }

        protected void cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL(object source,
            ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            try
            {
                var comboBox = (ASPxComboBox) source;

                SqlDataSource1.SelectCommand =
                    @"
select
	st.QuoteNumber
,	st.EEIPartNumber
,	st.Program
from
	(	select
			q.QuoteNumber
		,	q.EEIPartNumber
		,	q.Program
		,	rn = row_number() over (order by q.QuoteNumber)
		from
			NSA.QuoteLog q
		where
			q.QuoteNumber + ' ' + EEIPartNumber + ' ' + Program like @filter
	) st
where
	st.rn between @startIndex and @endIndex";

                SqlDataSource1.SelectParameters.Clear();
                SqlDataSource1.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
                SqlDataSource1.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
                SqlDataSource1.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
                comboBox.DataSource = SqlDataSource1;
                comboBox.DataBind();
            }
            catch (Exception ex)
            {
                var error = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                //lblError.Text = String.Format("Failed to return quote data. {0}", error);
                //pcError.ShowOnPageLoad = true;
            }
        }

        protected void cbxQuoteNumber_OnItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            long value = 0;
            if (e.Value == null || !long.TryParse(e.Value.ToString(), out value)) return;
            var comboBox = (ASPxComboBox) source;
            SqlDataSource1.SelectCommand =
                @"
select
	st.QuoteNumber
,	st.EEIPartNumber
,	st.Program
from
	NSA.QuoteLog st
where
	st.QuoteNumber = @QuoteNumber";
            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("QuoteNumber", TypeCode.String, e.Value.ToString());
            comboBox.DataSource = SqlDataSource1;
            comboBox.DataBind();
        }

        protected void gvQuote_OnDataBinding(object sender, EventArgs e)
        {
            gvQuote.DataSource = QuoteList;
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
                var quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
                Session["QuoteNumber"] = quote;
            }

            Session["RedirectPage"] = "~/NewSalesAward/Pages/NewSalesAward.aspx";
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Session["FocusedRowIndex"] = gvQuote.FocusedRowIndex;
            Response.Redirect("~/QuoteLogIntegration/Pages/QuoteTransfer.aspx");
        }

        protected void btnQuoteTransferGrid_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/QuoteLogIntegration/Pages/QuoteTransferList.aspx");
        }

        #endregion

        #region Methods

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

        #endregion

        protected void cbp1_OnCallback(object sender, CallbackEventArgsBase e)
        {
            QuoteList = ViewModel.GetAwardedQuotes();
            gvQuote.DataBind();
        }


    }
}