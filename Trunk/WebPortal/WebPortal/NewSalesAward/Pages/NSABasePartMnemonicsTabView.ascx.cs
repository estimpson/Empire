using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSABasePartMnemonicsTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];
        }

        private string Mode
        {
            get => (string)Session["Mode"];
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote()
        {
            PartMnemonicsFormLayout.DataSource = AwardedQuote;
            PartMnemonicsFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        public void Save()
        {
            // Nothing to do here.
        }

        protected void PartMnemonicsCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            //  Refactor to open a new tab and pass only the quote.
            var quote = AwardedQuote.QuoteNumber;
            var basePart = AwardedQuote.BasePart;
            var mnemonic = AwardedQuote.VehiclePlantMnemonic;
            var qtyPer = (AwardedQuote.QtyPer.HasValue) ? AwardedQuote.QtyPer.ToString() : "0";
            var takeRate = (AwardedQuote.TakeRate.HasValue) ? AwardedQuote.TakeRate.ToString() : "0";
            var familyAllocation = (AwardedQuote.FamilyAllocation.HasValue) ? AwardedQuote.FamilyAllocation.ToString() : "0";
            var quotedEau = (AwardedQuote.QuotedEAU.HasValue) ? AwardedQuote.QuotedEAU.ToString() : "0";
            var awardedEau = (AwardedQuote.AwardedEAU.HasValue) ? AwardedQuote.AwardedEAU.ToString() : "0";

            Session["QuoteNumber"] = quote;
            Session["BasePart"] = basePart;
            Session["Mnemonic"] = mnemonic;
            Session["QtyPer"] = qtyPer;
            Session["TakeRate"] = takeRate;
            Session["FamilyAllocation"] = familyAllocation;
            Session["QuotedEau"] = quotedEau;
            Session["AwardedEau"] = awardedEau;
        }


    }
}