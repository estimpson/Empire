using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSATesterToolingTabView : UserControl, I_NSATabView
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
            TesterToolingFormLayout.DataSource = AwardedQuote;
            TesterToolingFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        protected void TesterToolingCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetTesterTooling() == 0) return;

            SaveCheckMark.Enabled = true;
        }

        private int SetTesterTooling()
        {
            var quote = AwardedQuote.QuoteNumber;

            var amount = !string.IsNullOrWhiteSpace(AssemblyTesterToolingAmountTextBox.Text)
                ? Convert.ToInt32(AssemblyTesterToolingAmountTextBox.Text)
                : (int?) null;

            var trigger = AssemblyTesterToolingTriggerTextBox.Text.Trim();
            var description = AssemblyTesterToolingDescriptionTextBox.Text.Trim();
            var capexID = AssemblyTesterToolingCAPEXIDTextBox.Text.Trim();

            ViewModel.SetAssemblyTesterTooling(quote, amount, trigger, description, capexID);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}