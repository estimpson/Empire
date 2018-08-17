using System;
using System.Drawing;
using System.IO;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;


namespace WebPortal.NewSalesAward.Pages
{
    public partial class QuoteTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];
        }

        private string Mode
        {
            get => (string)Session["Mode"];
        }



        private CreateAwardedQuoteViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (CreateAwardedQuoteViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new CreateAwardedQuoteViewModel();
                return ViewModel;
            }
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



        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateDropdownLists();
            ShowQuoteFiles("CustomerCommitment");
        }



        #region Control Events

        protected void ASPxCallbackPanel1_Callback(object sender, CallbackEventArgsBase e)
        {
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //if (Session["QuoteNumber"] == null) return;

            //if (cbxFormOfCommitment.SelectedIndex < 0) cbxFormOfCommitment.BackColor = Color.LightGreen;

            //if (SaveAwardedQuote() == 0) return;

            //Response.Redirect("NewSalesAwards.aspx");
        }

        protected void cbxQuoteNumber_Callback(object sender, CallbackEventArgsBase e)
        {
            Session["QuoteNumber"] = e.ToString();
            GetAwardedQuoteDetails();
        }

        #endregion


        #region Document Control Events

        protected void btnDocDelete_Click(object sender, EventArgs e)
        {
            if (Session["QuoteNumber"] == null || tbxDocName.Text.Trim() == "") return;

            Session["AttachmentCategory"] = "CustomerCommitment";
            if (DeleteFile() == 1)
            {
                tbxDocName.Text = "";
                btnDocGet.Enabled = false;
            }
        }

        protected void btnDocGet_Click(object sender, EventArgs e)
        {
            if (Session["QuoteNumber"] == null || tbxDocName.Text.Trim() == "") return;

            if (tbxDocName.Text.Trim() == "") return;
            GetFile("CustomerCommitment");
        }

        protected void btnDocSave_Click(object sender, EventArgs e)
        {
            if (Session["QuoteNumber"] == null) return;

            // Show file upload pop-up window (file upload control cannot be placed within an update panel)
            Session["AttachmentCategory"] = "CustomerCommitment";
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (cbxFormOfCommitment.SelectedIndex < 0) cbxFormOfCommitment.BackColor = Color.LightGreen;

            // (This is a button on the pop-up form)
            if (!FileUploadControl.HasFile) return;

            //string attachmentCategory = Session["AttachmentCategory"].ToString();
            if (SaveFile() == 1) ShowQuoteFiles("CustomerCommitment");
        }

        #endregion


        #region Methods

        public void SetQuote()
        {
            //AwardedQuote = awardedQuote;
            //BasePartAttributesFormLayout.DataSource = AwardedQuote;
            //BasePartAttributesFormLayout.DataBind();

            Session["QuoteNumber"] = tbxQuoteNumber.Text = AwardedQuote.QuoteNumber;
            GetAwardedQuoteDetails();
        }

        public void Save()
        {
            // Interface requirement
        }






        private void PopulateDropdownLists()
        {
            if (GetSalespeople() == 0) return;
            if (GetProgramManagers() == 0) return;
            if (GetQuoteReasons() == 0) return;
            if (GetCustomerCommitmentForms() == 0) return;
            GetActiveBaseParts();
        }

        //private int GetQuoteLog()
        //{
        //    ViewModel.GetQuoteLog();
        //    if (ViewModel.Error != "")
        //    {
        //        //lblError.Text = String.Format("Failed to return quote number list. Error at GetQuoteLog. {0}", ViewModel.Error);
        //        //pcError.ShowOnPageLoad = true;
        //        return 0;
        //    }
        //    cbxQuoteNumber.DataSource = ViewModel.QuoteNumberList;
        //    cbxQuoteNumber.DataBind();
        //    return 1;
        //}

        private int GetAwardedQuoteDetails()
        {
            ViewModel.QuoteNumber = Session["QuoteNumber"].ToString();
            ViewModel.GetAwardedQuoteDetails();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }

            try
            {
                ListEditItem itemSalesperson = cbxSalesperson.Items.FindByValue(ViewModel.Salesperson);
                if (itemSalesperson != null) cbxSalesperson.Value = ViewModel.Salesperson;

                ListEditItem itemProgramManager = cbxProgramManager.Items.FindByValue(ViewModel.ProgramManager);
                if (itemProgramManager != null) cbxProgramManager.Value = ViewModel.ProgramManager;

                ListEditItem itemQuoteReason = cbxQuoteReason.Items.FindByValue(ViewModel.QuoteReason);
                if (itemQuoteReason != null) cbxQuoteReason.Value = ViewModel.QuoteReason;

                ListEditItem itemFormOfCommitment = cbxFormOfCommitment.Items.FindByValue(ViewModel.FormOfCommitment);
                if (itemFormOfCommitment != null) cbxFormOfCommitment.Value = ViewModel.FormOfCommitment;

                ListEditItem itemBasePart = cbxReplacingBasePart.Items.FindByValue(ViewModel.ReplacingBasePart);
                if (itemBasePart != null)
                {
                    cbxReplacingBasePart.Value = ViewModel.ReplacingBasePart;
                    if (itemBasePart.Text != "") cbxReplacingBasePart.Enabled = true;
                }

                deAwardDate.Value = ViewModel.AwardDate;
                memoComments.Text = ViewModel.Comments;
                tbxQuotedEau.Text = ViewModel.QuotedEau;
                tbxQuotedPrice.Text = ViewModel.QuotedPrice;
                tbxQuotedMaterialCost.Text = ViewModel.QuotedMaterialCost;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                //lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int GetSalespeople()
        {
            var salesPeople = ViewModel.GetSalespeople();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetSalespeople. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSalesperson.DataSource = salesPeople;
            cbxSalesperson.TextField = "UserName";
            cbxSalesperson.ValueField = "UserCode";
            cbxSalesperson.DataBind();
            return 1;
        }

        private int GetProgramManagers()
        {
            var programManagers = ViewModel.GetProgramManagers();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetProgramManagers. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxProgramManager.DataSource = programManagers;
            cbxProgramManager.TextField = "UserName";
            cbxProgramManager.ValueField = "UserCode";
            cbxProgramManager.DataBind();
            return 1;
        }

        private int GetQuoteReasons()
        {
            var quoteReasons = ViewModel.GetQuoteReasons();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetQuoteReasons. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxQuoteReason.DataSource = quoteReasons;
            cbxQuoteReason.TextField = "QuoteReason";
            cbxQuoteReason.ValueField = "QuoteReasonId";
            cbxQuoteReason.DataBind();
            return 1;
        }

        private int GetCustomerCommitmentForms()
        {
            var forms = ViewModel.GetCustomerCommitmentForms();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetCustomerCommitmentForms. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxFormOfCommitment.DataSource = forms;
            cbxFormOfCommitment.TextField = "FormOfCommitment";
            cbxFormOfCommitment.ValueField = "FormOfCommitment";
            cbxFormOfCommitment.DataBind();
            return 1;
        }

        private int GetActiveBaseParts()
        {
            var baseParts = ViewModel.GetActiveBaseParts();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetActiveBaseParts. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxReplacingBasePart.DataSource = baseParts;
            cbxReplacingBasePart.TextField = "BasePart";
            cbxReplacingBasePart.ValueField = "BasePart";
            cbxReplacingBasePart.DataBind();
            return 1;
        }

        #endregion



        #region Document Methods

        private void ShowQuoteFiles(string attachmentCategory)
        {
            DocsViewModel.ShowQuoteFileInfo(tbxQuoteNumber.Text, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at ShowquoteFiles. {0}", DocsViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return;
            }

            switch (attachmentCategory)
            {
                case "CustomerCommitment":
                    tbxDocName.Text = DocsViewModel.QuoteFileName;
                    //btnDocGet.Enabled = true;
                    break;
                case "BomLabor":
                    //tbxDocName3.Text = DocsViewModel.QuoteFileName;
                    //btnDocGet3.Enabled = true;
                    break;
                case "CustomerQuote":
                    //tbxDocName4.Text = DocsViewModel.QuoteFileName;
                    //btnDocGet4.Enabled = true;
                    break;
                case "VendorQuote":
                    //tbxDocName5.Text = DocsViewModel.QuoteFileName;
                    //btnDocGet5.Enabled = true;
                    break;
            }
        }

        private int SaveFile()
        {
            string attachmentCategory = Session["AttachmentCategory"].ToString();

            string fileName = Path.GetFileName(FileUploadControl.FileName);
            byte[] fileContents = FileUploadControl.FileBytes;

            DocsViewModel.SaveQuoteFile(tbxQuoteNumber.Text, attachmentCategory, fileName, fileContents);
            if (DocsViewModel.Error != "")
            {
                lblUploadStatus.Text = string.Format("The file could not be uploaded. The following error occured: {0}", DocsViewModel.Error);
                return 0;
            }
            lblUploadStatus.Text = "Successfully uploaded the file.";

            btnDocSave.Focus();
            return 1;
        }

        private void GetFile(string attachmentCategory)
        {
            string fileName;
            byte[] fileContents;
            DocsViewModel.GetQuoteFile(tbxQuoteNumber.Text, attachmentCategory, out fileName, out fileContents);

            // Separate the file's name and its extension
            int i = fileName.IndexOf('.');
            int totalLength = fileName.Length;
            int extensionLength = totalLength - i;

            string file = fileName.Remove(i, extensionLength);
            string fileType = fileName.Substring(i + 1);

            // Add a random number to the file's name to prevent locking issues
            int random = DateTime.Now.GetHashCode();
            if (random < 0) random = random * -1;
            string tempFileName = file + "_" + random.ToString() + "." + fileType;

            // Set the path where the file's contents will be written
            string path = @"C:\inetpub\wwwroot\WebPortal\temp\";
            string filePathQuotePrint = path + tempFileName;

            // Write the file contents out
            var fs = new System.IO.FileStream(filePathQuotePrint, FileMode.OpenOrCreate);
            fs.Write(fileContents, 0, fileContents.Length);
            fs.Flush();
            fs.Close();

            // Open a page to display the file if it's a PDF; otherwise, download the file.
            Session["FileType"] = fileType;
            Session["FileName"] = fileName;
            Session["FileLength"] = fileContents.Length;
            Session["FilePath"] = filePathQuotePrint;
            string s = "window.open('Documents.aspx', 'popup_window', 'width=600,height=400,left=100,top=100,resizable=yes');";

            Page.RegisterStartupScript("script", s);

            btnDocGet.Focus();
        }

        private int DeleteFile()
        {
            string attachmentCategory = Session["AttachmentCategory"].ToString();

            DocsViewModel.DeleteQuoteFile(tbxQuoteNumber.Text, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at DeleteFile. {0}", DocsViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        #endregion


    }
}