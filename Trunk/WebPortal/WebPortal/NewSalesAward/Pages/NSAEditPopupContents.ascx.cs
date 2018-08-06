using System;
using System.Collections.Generic;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSAEditPopupContents : UserControl
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];

            set => Session["AwardedQuote"] = value;
        }

        private List<I_NSATabView> NSATabViews => new List<I_NSATabView> { NSACustomerPOTabView, NSAHardToolingTabView, NSAToolingAmortizationTabView, NSATesterToolingTabView, NSABasePartAttributesTabView, NSABasePartMnemonicsTabView, NSALogisticsTabView };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void NSAEditCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            //  Save all.
            foreach (var nsaTabView in NSATabViews)
            {
                nsaTabView.Save();
            }
        }

        public void SetQuote(usp_GetAwardedQuotes_Result awardedQuote)
        {
            AwardedQuote = awardedQuote;
            NSAEditFormLayout.DataSource = AwardedQuote;
            NSAEditFormLayout.DataBind();

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