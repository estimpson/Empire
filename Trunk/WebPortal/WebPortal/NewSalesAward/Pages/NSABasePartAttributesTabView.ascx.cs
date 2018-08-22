using System;
using System.Web.UI;
using DevExpress.Web;
using Newtonsoft.Json;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSABasePartAttributesTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote => (usp_GetAwardedQuotes_Result) Session["AwardedQuote"];

        private string Mode => (string) Session["Mode"];

        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        public void SetQuote()
        {
            BasePartAttributesFormLayout.DataSource = AwardedQuote;
            BasePartAttributesFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = Mode == "edit";
        }

        public void Save()
        {
            Save("");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void BasePartAttributesCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save(e.Parameter);
        }

        public void Save(string saveParameter)
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetBasePartAttributes(saveParameter) == 0) throw new Exception(ViewModel.Error);

            SaveCheckMark.Enabled = true;
        }

        private int SetBasePartAttributes(string saveParameter)
        {
            var operatorCode = Session["OpCode"].ToString();

            var quote = AwardedQuote.QuoteNumber;

            var basePartFamilyList = BasePartFamilyTextBox.Text.Trim();
            var productLine = ProductLineComboBox.Text.Trim();
            var marketSegment = EmpireMarketSegmentComboBox.Text.Trim();
            var marketSubsegment = EmpireMarketSubsegmentComboBox.Text.Trim();
            var application = EmpireApplicationTextBox.Text.Trim();

            var sop = EmpireSOPDateEdit.Value != null
                ? Convert.ToDateTime(EmpireSOPDateEdit.Value)
                : (DateTime?) null;

            var eop = EmpireEOPDateEdit.Value != null
                ? Convert.ToDateTime(EmpireEOPDateEdit.Value)
                : (DateTime?) null;

            var eopChangeNote = string.Empty;
            if (eop != AwardedQuote.EmpireEOP)
            {
                dynamic x = JsonConvert.DeserializeObject(saveParameter);
                eopChangeNote = x.BasePartAttributes_EmpireEOPNote;
            }

            var comments = BasePart_CommentsTextBox.Text.Trim();

            ViewModel.SetBasePartAttributes(operatorCode, quote, basePartFamilyList, productLine, marketSegment,
                marketSubsegment, application, sop, eop, eopChangeNote, comments);
            return ViewModel.Error != "" ? 0 : 1;
        }

        protected void BasePartAttributesFormLayout_OnInit(object sender, EventArgs e)
        {
            EmpireEOPDateEdit.JSProperties.Add("cpUnlocked", false);
            EmpireEOPDateEdit.JSProperties.Add("cpUnlockNote", null);
        }
    }
}