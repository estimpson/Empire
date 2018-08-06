using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSACustomerPOTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result) Session["AwardedQuote"];

            set => Session["AwardedQuote"] = value;
        }

        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote(usp_GetAwardedQuotes_Result awardedQuote)
        {
            AwardedQuote = awardedQuote;
            QuoteNumberHiddenField.Set("QuoteNumber", AwardedQuote.QuoteNumber);
            CustomerPOFormLayout.DataSource = AwardedQuote;
            CustomerPOFormLayout.DataBind();
        }

        protected void POCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            if (SetProductionPO() == 0) return;
        }

        private int SetProductionPO()
        {
            var quote = AwardedQuote.QuoteNumber;

            var purchaseOrderDt = (PODateDateEdit.Value != null)
                ? Convert.ToDateTime(PODateDateEdit.Value)
                : (DateTime?) null;

            var po = PONumberTextBox.Text.Trim();
            var altCommit = AltCustomerCommitmentTextBox.Text.Trim();

            var sellingPrice = !string.IsNullOrWhiteSpace(POSellingPriceTextBox.Text)
                ? Convert.ToDecimal(POSellingPriceTextBox.Text)
                : (decimal?) null;

            var sop = (POSOPDateEdit.Value != null)
                ? Convert.ToDateTime(POSOPDateEdit.Value)
                : (DateTime?)null;

            var eop = (POEOPDateEdit.Value != null)
                ? Convert.ToDateTime(POEOPDateEdit.Value)
                : (DateTime?)null;

            var comments = POCommentsTextBox.Text.Trim();

            ViewModel.SetProductionPO(quote, purchaseOrderDt, po, altCommit, sellingPrice, sop, eop, comments);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}