using System;
using System.IO;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NSACustomerPOTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result) Session["AwardedQuote"];
        }
        private string Mode
        {
            get => (string)Session["Mode"];
        }

        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel) ViewState["ViewModel"];
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void SetQuote()
        {
            CustomerPOFormLayout.DataSource = AwardedQuote;
            CustomerPOFormLayout.DataBind();

            ASPxCallbackPanel1.Enabled = (Mode == "edit");
        }

        protected void POCallback_OnCallback(object sender, CallbackEventArgsBase e)
        {
            Save();
        }

        public void Save()
        {
            if (SetProductionPO() == 0) return;
        }

        private int SetProductionPO()
        {
            var quote = AwardedQuote.QuoteNumber;

            var purchaseOrderDt = (PODateDateEdit.Value != null)
                ? Convert.ToDateTime(PODateDateEdit.Value)
                : (DateTime?) null;

            var po = PONumberTextBox.Text.Trim();
            var altCommit = AltCustomerCommitmentTextBox.Text.Trim();

            var sellingPrice = !string.IsNullOrWhiteSpace(POSellingPriceTextBox.Text)
                ? Convert.ToDecimal(POSellingPriceTextBox.Text)
                : (decimal?) null;

            var sop = (POSOPDateEdit.Value != null)
                ? Convert.ToDateTime(POSOPDateEdit.Value)
                : (DateTime?)null;

            var eop = (POEOPDateEdit.Value != null)
                ? Convert.ToDateTime(POEOPDateEdit.Value)
                : (DateTime?)null;

            var comments = POCommentsTextBox.Text.Trim();

            ViewModel.SetProductionPO(quote, purchaseOrderDt, po, altCommit, sellingPrice, sop, eop, comments);
            return ViewModel.Error != "" ? 0 : 1;
        }


        #region PO File

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

        protected void CustomerPOUploadControl_OnFileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            DocsViewModel.SaveQuoteFile(AwardedQuote.QuoteNumber, "CustomerPO", e.UploadedFile.FileName, e.UploadedFile.FileBytes);
            e.CallbackData =
                $"{e.UploadedFile.FileName}|{ResolveClientUrl("~/Temp")}|{e.UploadedFile.ContentLength / 1024} KB";
        }

        protected void HandleFileActionsCallback_OnCallback(object source, CallbackEventArgsBase e)
        {
            switch (e.Parameter)
            {
                case "Delete":
                    DeleteCustomerPOFile();
                    break;
                case "Open":
                    OpenCustomerPOFile();
                    break;
            }
        }

        private void DeleteCustomerPOFile()
        {
            DocsViewModel.DeleteQuoteFile(AwardedQuote.QuoteNumber, "CustomerPO");
            if (DocsViewModel.Error != "")
            {
                throw new Exception(DocsViewModel.Error);
            }
        }

        private void OpenCustomerPOFile()
        {
            DocsViewModel.GetQuoteFile(AwardedQuote.QuoteNumber, "CustomerPO", out string fileName, out byte[] fileContents);
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

            OpenCustomerPOFileButton.JSProperties.Add("cpFilePath", tempFileClientPath);
        }

        #endregion
    }
}