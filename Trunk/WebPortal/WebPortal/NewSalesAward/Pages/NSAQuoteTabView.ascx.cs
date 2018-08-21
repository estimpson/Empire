using System;
using System.IO;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSAQuoteTabView : UserControl, I_NSATabView
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
            QuoteInfoFormLayout.DataSource = AwardedQuote;
            QuoteInfoFormLayout.DataBind();

            QuoteInfoCallbackPanel.Enabled = Mode == "edit";
        }

        public void Save()
        {
            Save("");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void QuoteInfoCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save(e.Parameter);
        }

        public void Save(string saveParameter)
        {
            SaveCheckMark.Visible = true;
            SaveCheckMark.Enabled = false;
            if (SetQuoteInfo(saveParameter) == 0) throw new Exception(ViewModel.Error);

            SaveCheckMark.Enabled = true;
        }

        private int SetQuoteInfo(string saveParameter)
        {
            //var operatorCode = Session["OpCode"].ToString();

            //var quote = AwardedQuote.QuoteNumber;

            //var basePartFamilyList = BasePartFamilyTextBox.Text.Trim();
            //var productLine = ProductLineComboBox.Text.Trim();
            //var marketSegment = EmpireMarketSegmentComboBox.Text.Trim();
            //var marketSubsegment = EmpireMarketSubsegmentComboBox.Text.Trim();
            //var application = EmpireApplicationTextBox.Text.Trim();

            //var sop = (EmpireSOPDateEdit.Value != null)
            //    ? Convert.ToDateTime(EmpireSOPDateEdit.Value)
            //    : (DateTime?)null;

            //var eop = (EmpireEOPDateEdit.Value != null)
            //    ? Convert.ToDateTime(EmpireEOPDateEdit.Value)
            //    : (DateTime?)null;

            //var eopChangeNote = string.Empty;
            //if (eop != AwardedQuote.EmpireEOP)
            //{
            //    dynamic x = JsonConvert.DeserializeObject(saveParameter);
            //    eopChangeNote = x.BasePartAttributes_EmpireEOPNote;
            //}

            //var comments = BasePart_CommentsTextBox.Text.Trim();

            //ViewModel.SetBasePartAttributes(operatorCode, quote, basePartFamilyList, productLine, marketSegment,
            //    marketSubsegment, application, sop, eop, eopChangeNote, comments);
            return ViewModel.Error != "" ? 0 : 1;
        }

        private DocumentationViewModel DocsViewModel
        {
            get
            {
                if (ViewState["DocsViewModel"] != null)
                {
                    return (DocumentationViewModel)ViewState["DocsViewModel"];
                }
                ViewState["DocsViewModel"] = new DocumentationViewModel();
                return DocsViewModel;
            }
        }

        protected void CustomerCommitmentUploadControl_OnFileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            DocsViewModel.SaveQuoteFile(AwardedQuote.QuoteNumber, "CustomerCommitment", e.UploadedFile.FileName, e.UploadedFile.FileBytes);
            e.CallbackData =
                $"{e.UploadedFile.FileName}|{ResolveClientUrl("~/Temp")}|{e.UploadedFile.ContentLength / 1024} KB";
        }

        protected void HandleFileActionsCallback_OnCallback(object source, CallbackEventArgsBase e)
        {
            switch (e.Parameter)
            {
                case "Delete":
                    DeleteCustomerCommitmentFile();
                    break;
                case "Open":
                    OpenCustomerCommitmentFile();
                    break;
            }
        }

        private void DeleteCustomerCommitmentFile()
        {
            DocsViewModel.DeleteQuoteFile(AwardedQuote.QuoteNumber, "CustomerCommitment");
            if (DocsViewModel.Error != "")
            {
                throw new Exception(DocsViewModel.Error);
            }
        }

        private void OpenCustomerCommitmentFile()
        {
            DocsViewModel.GetQuoteFile(AwardedQuote.QuoteNumber, "CustomerCommitment", out string fileName, out byte[] fileContents);
            var attachmentExtension = Path.GetExtension(fileName);
            var tempFileName =
                Path.ChangeExtension($"{Path.GetFileNameWithoutExtension(fileName)}-{Path.GetRandomFileName()}",
                    attachmentExtension);
            var tempFileServerPath = $"{AppDomain.CurrentDomain.BaseDirectory}/Temp/{tempFileName}";
            var tempFileClientPath = $"../../Temp/{tempFileName}";

            var fs = new FileStream(tempFileServerPath, FileMode.Create);
            fs.Write(fileContents, 0, fileContents.Length);
            fs.Flush();
            fs.Close();

            OpenCustomerCommitmentFileButton.JSProperties.Add("cpFilePath", tempFileClientPath);
        }
    }
}