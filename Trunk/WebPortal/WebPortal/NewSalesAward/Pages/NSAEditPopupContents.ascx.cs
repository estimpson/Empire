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

        private string Mode
        {
            get => (string)Session["Mode"];

            set => Session["Mode"] = value;
        }

        private List<I_NSATabView> NSATabViews => new List<I_NSATabView> { QuoteTabView, NSACustomerPOTabView, NSAHardToolingTabView, NSAToolingAmortizationTabView, NSATesterToolingTabView, NSABasePartAttributesTabView, NSABasePartMnemonicsTabView, NSALogisticsTabView };

        protected void Page_Load(object sender, EventArgs e)
        {
            if(Page.IsPostBack)
            {
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

        public void SetQuote()
        {
            //  Binding.
            NSAEditFormLayout.DataSource = AwardedQuote;
            NSAEditFormLayout.DataBind();

            //  Used for EntityURI building.
            QuoteNumberHiddenField.Set("QuoteNumber", AwardedQuote.QuoteNumber);

            //  Retrieve the entity notes for this quote.
            EntityNotesUserControl.Retrieve(Session["OpCode"].ToString(),
                "EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=" + AwardedQuote.QuoteNumber + "%");
            EntityNotesUserControl.RefreshGrid();

            //  Set quote for each tab view.
            foreach (var nsaTabView in NSATabViews)
            {
                nsaTabView.SetQuote();
            }

            //  Make the first tab visible.
            NSAEditPageControl.ActiveTabPage = NSAEditPageControl.TabPages[0];
        }


        protected void OnDataBinding(object sender, EventArgs e)
        {
        }

        protected void OnDataBound(object sender, EventArgs e)
        {
            var k = (ASPxLabel) sender;

            if (Mode == "new")
            {
                k.Text = "";
            }
            else
            {
                k.Text = "Quote Number: " + AwardedQuote.QuoteNumber + (AwardedQuote.BasePart == null ? " [Invalid Quote Number]" : " | " + AwardedQuote.BasePart);
            }
        }

        
    }
}