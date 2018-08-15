using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSALogisticsTabView : UserControl, I_NSATabView
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
            LogisticsFormLayout.DataSource = AwardedQuote;
            LogisticsFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        protected void LogisticsCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetSaveLogistics() == 0) return;

            SaveCheckMark.Enabled = true;
        }

        private int SetSaveLogistics()
        {
            var quote = AwardedQuote.QuoteNumber;

            var empireFacility = EmpireFacilityComboBox.Text.Trim();
            var freightTerms = FreightTermsComboBox.Text.Trim();
            var customerShipTo = CustomerShipTosComboBox.Text.Trim();

            ViewModel.SetLogistics(quote, empireFacility, freightTerms, customerShipTo);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}