using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class CreateAwardedQuote : System.Web.UI.Page
    {
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


        #region Variables

        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AuthenticateUser();

                // Get quote numbers
                //if (GetQuoteLog() == 0) return;

                PopulateDropdownLists();


                // ***** Will probably be moved to its own page *****
                pnlDocument.Visible = false;


                pnlQuoteDetails.Enabled = pnlDocument.Enabled = false;
                cbxReplacingBasePart.Enabled = false;
                cbxQuoteNumber.Focus(); 
            }
        }



        #region Authentication Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion



        #region Control Events

        protected void cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            try
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;

                SqlDataSource1.ConnectionString = "data source=eeisql1.empireelect.local;initial catalog=FxPLM;persist security info=True;user id=cdipaola;password=emp1reFt1";

                SqlDataSource1.SelectCommand =
                       @"SELECT [QuoteNumber], [EEIPartNumber], [Program] FROM (select [QuoteNumber], [EEIPartNumber], [Program], row_number()over(order by q.[QuoteNumber]) as [rn] from [NSA].[QuoteLog] as q where (([QuoteNumber] + ' ' + [EEIPartNumber] + ' ' + [Program]) LIKE @filter)) as st where st.[rn] between @startIndex and @endIndex";

                SqlDataSource1.SelectParameters.Clear();
                SqlDataSource1.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
                SqlDataSource1.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
                SqlDataSource1.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
                comboBox.DataSource = SqlDataSource1;
                comboBox.DataBind();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                lblError.Text = String.Format("Failed to return quote data. {0}", error);
                pcError.ShowOnPageLoad = true;
            }
        }

        protected void cbxQuoteNumber_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            //long value = 0;
            //if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
            //    return;
            //ASPxComboBox comboBox = (ASPxComboBox)source;
            //SqlDataSource1.SelectCommand = @"SELECT ID, LastName, [Phone], FirstName FROM Persons WHERE (ID = @ID) ORDER BY FirstName";

            //SqlDataSource1.SelectParameters.Clear();
            //SqlDataSource1.SelectParameters.Add("ID", TypeCode.Int64, e.Value.ToString());
            //comboBox.DataSource = SqlDataSource1;
            //comboBox.DataBind();
        }

        protected void cbxQuoteNumber_SelectedIndexChanged(object sender, EventArgs e)
        {
            // ***** On successful save, should return to the main page, so clearing will not be necessary (selected index should not change more than once) *****
            //ClearForm();

            Session["QuoteNumber"] = cbxQuoteNumber.Value.ToString();
            //if (GetAwardedQuoteDetails() == 1) pnlQuoteDetails.Enabled = true;
            GetAwardedQuoteDetails();

            pnlQuoteDetails.Enabled = pnlDocument.Enabled = true;

            ShowQuoteFiles("CustomerCommitment");
            btnDocDelete.Enabled = btnDocGet.Enabled = (tbxDocName.Text.Trim() != "");
        }

        protected void cbxQuoteReason_SelectedIndexChanged(object sender, EventArgs e)
        {
            cbxReplacingBasePart.Enabled = (cbxQuoteReason.Text == "New Part");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (cbxFormOfCommitment.SelectedIndex < 0) cbxFormOfCommitment.BackColor = Color.LightGreen;

            if (SaveAwardedQuote() == 0) return;

            Response.Redirect("NewSalesAwards.aspx");
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewSalesAwards.aspx");
        }

        #endregion


        #region Document Control Events

        protected void btnDocDelete_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "CustomerCommitment";
            if (DeleteFile() == 1)
            {
                tbxDocName.Text = "";
                btnDocGet.Enabled = false;
            }
        }

        protected void btnDocGet_Click(object sender, EventArgs e)
        {
            if (tbxDocName.Text.Trim() == "") return;
            GetFile("CustomerCommitment");
        }

        protected void btnDocSave_Click(object sender, EventArgs e)
        {
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

        private void PopulateDropdownLists()
        {
            if (GetSalespeople() == 0) return;
            if (GetProgramManagers() == 0) return;
            if (GetQuoteReasons() == 0) return;
            if (GetCustomerCommitmentForms() == 0) return;
            GetActiveBaseParts();
        }

        private int GetQuoteLog()
        {
            ViewModel.GetQuoteLog();
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Failed to return quote number list. Error at GetQuoteLog. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxQuoteNumber.DataSource = ViewModel.QuoteNumberList;
            cbxQuoteNumber.DataBind();
            return 1;
        }

        private int GetAwardedQuoteDetails()
        {
            ViewModel.QuoteNumber = Session["QuoteNumber"].ToString();
            ViewModel.GetAwardedQuoteDetails();
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
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
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int GetSalespeople()
        {
            var salesPeople = ViewModel.GetSalespeople();
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSalespeople. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
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
                lblError.Text = String.Format("Error at GetProgramManagers. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
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
                lblError.Text = String.Format("Error at GetQuoteReasons. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
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
                lblError.Text = String.Format("Error at GetCustomerCommitmentForms. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
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
                lblError.Text = String.Format("Error at GetActiveBaseParts. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxReplacingBasePart.DataSource = baseParts;
            cbxReplacingBasePart.TextField = "BasePart";
            cbxReplacingBasePart.ValueField = "BasePart";
            cbxReplacingBasePart.DataBind();
            return 1;
        }

        private int SaveAwardedQuote()
        {
            DateTime? awardDt = null;
            if (deAwardDate.Value != null) awardDt = Convert.ToDateTime(deAwardDate.Value);
            ViewModel.AwardDate = awardDt;

            ViewModel.QuoteReason = Convert.ToByte(cbxQuoteReason.Value);
            ViewModel.Comments = memoComments.Text.Trim();
            ViewModel.FormOfCommitment = cbxFormOfCommitment.Text;
            ViewModel.ProgramManager = cbxProgramManager.Value.ToString();
            ViewModel.QuoteNumber = cbxQuoteNumber.Value.ToString();
            ViewModel.ReplacingBasePart = cbxReplacingBasePart.Text;
            ViewModel.Salesperson = cbxSalesperson.Value.ToString();

            ViewModel.CreateAwardedQuote();
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SaveAwardedQuote. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void ClearForm()
        {
            memoComments.Text = "";
            //cbxQuoteReason.Text = cbxFormOfCommitment.Text = cbxReplacingBasePart.Text = cbxProgramManager.Text = cbxSalesperson.Text = "";
 
            //cbxQuoteNumber.SelectedIndex = cbxQuoteReason.SelectedIndex = cbxFormOfCommitment.SelectedIndex =
            //    cbxReplacingBasePart.SelectedIndex = cbxProgramManager.SelectedIndex = cbxSalesperson.SelectedIndex = -1;

            deAwardDate.Value = null;

            cbxReplacingBasePart.Enabled = false;
            //pnlQuoteDetails.Enabled = false;
            //cbxQuoteNumber.Focus();
        }

        #endregion


        #region Document Methods

        private void ShowQuoteFiles(string attachmentCategory)
        {
            DocsViewModel.ShowQuoteFileInfo(cbxQuoteNumber.Value.ToString(), attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at ShowquoteFiles. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }

            switch (attachmentCategory)
            {
                case "CustomerCommitment":
                    tbxDocName.Text = DocsViewModel.QuoteFileName;
                    btnDocGet.Enabled = true;
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

            DocsViewModel.SaveQuoteFile(cbxQuoteNumber.Value.ToString(), attachmentCategory, fileName, fileContents);
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
            DocsViewModel.GetQuoteFile(cbxQuoteNumber.Value.ToString(), attachmentCategory, out fileName, out fileContents);

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
            ClientScript.RegisterStartupScript(this.GetType(), "script", s, true);

            btnDocGet.Focus();
        }

        private int DeleteFile()
        {
            string attachmentCategory = Session["AttachmentCategory"].ToString();

            DocsViewModel.DeleteQuoteFile(cbxQuoteNumber.Value.ToString(), attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at DeleteFile. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }


        #endregion


    }
}