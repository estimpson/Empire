using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSAToolingAmortizationTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];
        }

        private string Mode
        {
            get => (string)Session["Mode"];
        }

        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel)ViewState["ViewModel"];
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote()
        {
            ToolingAmortizationFormLayout.DataSource = AwardedQuote;
            ToolingAmortizationFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        protected void ToolingAmortizationCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetToolingAmortization() == 0)
            {
                throw new Exception(ViewModel.Error);
            }

            SaveCheckMark.Enabled = true;
        }

        private int SetToolingAmortization()
        {
            var quote = AwardedQuote.QuoteNumber;

            var amount = !string.IsNullOrWhiteSpace(AmortizationAmountTextBox.Text)
                ? Convert.ToDecimal(AmortizationAmountTextBox.Text)
                : (decimal?) null;

            var quantity = !string.IsNullOrWhiteSpace(AmortizationQuantityTextBox.Text)
                ? Convert.ToInt32(AmortizationQuantityTextBox.Text)
                : (int?) null;

            var description = AmortizationToolingDescriptionTextBox.Text.Trim();
            var capexID = AmortizationCAPEXIDTextBox.Text.Trim();

            ViewModel.SetToolingAmortization(quote, amount, quantity, description, capexID);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}