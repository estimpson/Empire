using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSAHardToolingTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result) Session["AwardedQuote"];
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
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote()
        {
            HardToolingFormLayout.DataSource = AwardedQuote;
            HardToolingFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        protected void HardToolingCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetHardTooling() == 0) return;

            SaveCheckMark.Enabled = true;
        }

        private int SetHardTooling()
        {
            var quote = AwardedQuote.QuoteNumber;

            var amount = !string.IsNullOrEmpty(HardToolingAmountTextBox.Text)
                ? Convert.ToDecimal(HardToolingAmountTextBox.Text)
                : (decimal?) null;

            var trigger = HardToolingTriggerTextBox.Text.Trim();
            var description = HardToolingDescriptionTextBox.Text.Trim();
            var capexID = HardToolingCAPEXIDTextBox.Text.Trim();

            ViewModel.SetHardTooling(quote, amount, trigger, description, capexID);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}