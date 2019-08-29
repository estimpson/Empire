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
            var quote = AwardedQuote.QuoteNumber;

            var awardDate = (AwardDateEdit.Value != null)
                ? Convert.ToDateTime(AwardDateEdit.Value)
                : (DateTime?)null;

            var awardedEau = (AwardedEAUTextBox.Value != null)
                ? Convert.ToDecimal(AwardedEAUTextBox.Value)
                : (Decimal?)null;

            var awardedPrice = (AwardedPriceTextBox.Value != null)
                ? Convert.ToDecimal(AwardedPriceTextBox.Value)
                : (Decimal?)null;

            var formOfCommitment = FormOfCommitmentComboBox.Text.Trim();
            var quoteReason = QuoteReasonComboBox.Text.Trim();
            var replacingBasePart = ReplacingBasePartComboBox.Text.Trim();
            var salespersonRowId = (SalespersonComboBox.SelectedIndex > -1) ? SalespersonComboBox.SelectedItem.Value.ToString() : "";

            //var salesperson = (SalespersonComboBox.Value == null)
            //    ? null
            //    : SalespersonComboBox.Value.ToString();
            //var programManager = ProgramManagerComboBox.Value.ToString();

            var programManagerRowId = (ProgramManagerComboBox.SelectedIndex > -1) ? ProgramManagerComboBox.SelectedItem.Value.ToString() : "";
            var comments = CommentsTextBox.Text.Trim();

            ViewModel.SetQuoteDetails(quote, awardDate, formOfCommitment, quoteReason,
                replacingBasePart, salespersonRowId, programManagerRowId, awardedEau, awardedPrice, comments);
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