﻿using System;
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
            if(Page.IsPostBack)
            {
                string x = "x";
            }
        }

        protected void NSAEditCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            //  Refactor.  Remove callback from got focus!
            //  Save all.
            foreach (var nsaTabView in NSATabViews)
            {
                nsaTabView.Save();
            }
        }

        public void SetQuote(usp_GetAwardedQuotes_Result awardedQuote)
        {
            //  Binding.
            AwardedQuote = awardedQuote;
            NSAEditFormLayout.DataSource = AwardedQuote;
            NSAEditFormLayout.DataBind();

            //  Used for EntityURI building.
            QuoteNumberHiddenField.Set("QuoteNumber", AwardedQuote.QuoteNumber);

            //  Retrieve the entity notes for this quote.
            Session["userCode"] = Session["OpCode"];
            Session["entityURI"] = "EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=" + AwardedQuote.QuoteNumber + "%";
            EntityNotesUserControl.RefreshGrid();
            
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