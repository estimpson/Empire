using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;


namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAwardEdit : System.Web.UI.Page
    {
        private PageViewModels.NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (NewSalesAwardsViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return ViewModel;
            }
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            //if (HttpContext.Current.Session["Quote"] == null) Response.Redirect("~/Pages/Login.aspx");


            string q = Request.QueryString["Quote"];


            var x = ViewModel.GetAwardedQuote(q);
            string bp = x.BasePart;
        }



        #region Control Events

        protected void btnSaveLogistics_Click(object sender, EventArgs e)
        {
            SaveLogistics();
        }

        protected void btnSaveBasePartAttr_Click(object sender, EventArgs e)
        {
            SaveBasePartAttributes();
        }

        protected void btnSaveAssemblyTester_Click(object sender, EventArgs e)
        {
            SaveAssemblyTester();
        }

        protected void btnSaveAmortization_Click(object sender, EventArgs e)
        {
            SaveAmortization();
        }

        protected void btnSaveHardTooling_Click(object sender, EventArgs e)
        {
            SaveHardTooling();
        }

        protected void btnSavePO_Click(object sender, EventArgs e)
        {
            SavePo();
        }

        protected void btnSaveAll_Click(object sender, EventArgs e)
        {
            if (SavePo() == 0) return;
            if (SaveHardTooling() == 0) return;
            if (SaveAssemblyTester() == 0) return;
            if (SaveAmortization() == 0) return;
            if (SaveBasePartAttributes() == 0) return;
            SaveLogistics();
        }

        #endregion



        #region Methods

        private int SaveLogistics()
        {
            //btnCheckmarkLogistics.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetLogistics(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkLogistics.Visible = true;
            return 1;
        }
        private int SaveBasePartAttributes()
        {
            //btnCheckmarkBasePartAttr.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetBasePartAttributes(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkBasePartAttr.Visible = true;
            return 1;
        }

        private int SaveAssemblyTester()
        {
            //btnCheckmarkAssemblyTester.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetAssemblyTesterTooling(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkAssemblyTester.Visible = true;
            return 1;
        }

        private int SaveAmortization()
        {
            //btnCheckmarkAmortization.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetToolingAmortization(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkAmortization.Visible = true;
            return 1;
        }

        private int SaveHardTooling()
        {
            //btnCheckmarkHardTooling.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetHardTooling(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkHardTooling.Visible = true;
            return 1;
        }

        private int SavePo()
        {
            //btnCheckmarkPO.Visible = false;
            //string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            //if (SetProductionPO(quote) == 0) return 0;

            //gvQuote.DataBind();
            //btnCheckmarkPO.Visible = true;
            return 1;
        }


        #endregion

        protected void btnEditBasePartMnemonics_Click(object sender, EventArgs e)
        {

        }
    }
}