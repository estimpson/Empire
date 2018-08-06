using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSABasePartAttributesTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];

            set => Session["AwardedQuote"] = value;
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

        public void SetQuote(usp_GetAwardedQuotes_Result awardedQuote)
        {
            AwardedQuote = awardedQuote;
            BasePartAttributesFormLayout.DataSource = AwardedQuote;
            BasePartAttributesFormLayout.DataBind();
        }

        protected void BasePartAttributesCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetBasePartAttributes() == 0) return;

            SaveCheckMark.Enabled = true;
        }

        private int SetBasePartAttributes()
        {
            var operatorCode = Session["OpCode"].ToString();

            var quote = AwardedQuote.QuoteNumber;

            var basePartFamilyList = BasePartFamilyTextBox.Text.Trim();
            var productLine = ProductLineComboBox.Text.Trim();
            var marketSegment = EmpireMarketSegmentComboBox.Text.Trim();
            var marketSubsegment = EmpireMarketSubsegmentComboBox.Text.Trim();
            var application = EmpireApplicationTextBox.Text.Trim();

            var sop = (EmpireSOPDateEdit.Value != null)
                ? Convert.ToDateTime(EmpireSOPDateEdit.Value)
                : (DateTime?) null;

            var eop = (EmpireEOPDateEdit.Value != null)
                ? Convert.ToDateTime(EmpireEOPDateEdit.Value)
                : (DateTime?) null;

            var eopNote = "x";
            var comments = BasePart_CommentsTextBox.Text.Trim();

            ViewModel.SetBasePartAttributes(operatorCode, quote, basePartFamilyList, productLine, marketSegment,
                marketSubsegment, application, sop, eop, eopNote, comments);
            return ViewModel.Error != "" ? 0 : 1;
        }
    }
}