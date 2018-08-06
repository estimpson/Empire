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

            set => Session["AwardedQuote"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote(usp_GetAwardedQuotes_Result awardedQuote)
        {
            AwardedQuote = awardedQuote;
            PartMnemonicsFormLayout.DataSource = AwardedQuote;
            PartMnemonicsFormLayout.DataBind();
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
            var qtyPer = AwardedQuote.QtyPer.ToString();
            var takeRate = AwardedQuote.TakeRate.ToString();
            var familyAllocation = AwardedQuote.FamilyAllocation.ToString();
            var quotedEau = AwardedQuote.QuotedEAU.ToString();

            Session["QuoteNumber"] = quote;
            Session["BasePart"] = basePart;
            Session["Mnemonic"] = mnemonic;
            Session["QtyPer"] = qtyPer;
            Session["TakeRate"] = takeRate;
            Session["FamilyAllocation"] = familyAllocation;
            Session["QuotedEau"] = quotedEau;
        }
    }
}