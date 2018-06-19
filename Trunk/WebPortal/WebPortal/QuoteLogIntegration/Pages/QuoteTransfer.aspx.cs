using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.QuoteLogIntegration.PageViewModels;


namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class QuoteTransfer : System.Web.UI.Page
    {
        private PageViewModels.QtQuoteViewModel QuoteViewModel
        {
            get
            {
                if (ViewState["QuoteViewModel"] != null)
                {
                    return (QtQuoteViewModel)ViewState["QuoteViewModel"];
                }
                ViewState["QuoteViewModel"] = new QtQuoteViewModel();
                return QuoteViewModel;
            }
        }

        private PageViewModels.QtCustomerContactsViewModel CustViewModel
        {
            get
            {
                if (ViewState["CustViewModel"] != null)
                {
                    return (QtCustomerContactsViewModel)ViewState["CustViewModel"];
                }
                ViewState["CustViewModel"] = new QtCustomerContactsViewModel();
                return CustViewModel;
            }
        }

        private PageViewModels.QtSpecialReqNotesViewModel NotesViewModel
        {
            get
            {
                if (ViewState["NotesViewModel"] != null)
                {
                    return (QtSpecialReqNotesViewModel)ViewState["NotesViewModel"];
                }
                ViewState["NotesViewModel"] = new QtSpecialReqNotesViewModel();
                return NotesViewModel;
            }
        }

        private PageViewModels.QtSignOffViewModel SignOffViewModel
        {
            get
            {
                if (ViewState["SignOffViewModel"] != null)
                {
                    return (QtSignOffViewModel)ViewState["SignOffViewModel"];
                }
                ViewState["SignOffViewModel"] = new QtSignOffViewModel();
                return SignOffViewModel;
            }
        }

        private PageViewModels.QtDocumentationViewModel DocsViewModel
        {
            get
            {
                if (ViewState["DocsViewModel"] != null)
                {
                    return (QtDocumentationViewModel)ViewState["DocsViewModel"];
                }
                ViewState["DocsViewModel"] = new QtDocumentationViewModel();
                return DocsViewModel;
            }
        }


        #region Variables

        private int _rowId;
        private string _answer;
        private string _notes;
        private string _signOffinitials;
        private DateTime _signOffDate;

        #endregion


        protected void Page_Init(object sender, EventArgs e)
        {
            // If arriving from another page, make sure session variables have not timed out
            if (Session["RedirectPage"] != null && Session["op"] == null) Response.Redirect("~/Pages/Login.aspx");

            // Get the operator code 
            if (Session["op"] == null)
            {
                // Arrived here from the menu
                QuoteViewModel.OperatorCode = CustViewModel.OperatorCode = Request.QueryString["op"];
                Session["op"] = Request.QueryString["op"];
                btnClose.Visible = false;
            }
            else
            {
                // Arrived here from another page
                QuoteViewModel.OperatorCode = CustViewModel.OperatorCode = Session["op"].ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AuthenticateUser();

                if (Session["QuoteNumber"] != null)
                {
                    tbxQuoteNumber.Text = Session["QuoteNumber"].ToString();
                    //PopulateForm();
                }
                else
                {
                    rPnl.Visible = false;
                    tbxQuoteNumber.Focus();
                }

                btnClose.Visible = (Session["RedirectPage"] != null);
            }
        }



        #region Control Events

        protected void btnGetQuote_Click(object sender, EventArgs e)
        {
            PopulateForm();
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            Response.Redirect(Session["RedirectPage"].ToString());
        }

        protected void btnSaveNotes_Click(object sender, EventArgs e)
        {
            if (UpdateSpecialReqNotes1() == 0) return;
            if (UpdateSpecialReqNotes2() == 0) return;
            if (UpdateSpecialReqNotes3() == 0) return;
            if (UpdateSpecialReqNotes4() == 0) return;
            if (UpdateSpecialReqNotes5() == 0) return;
            if (UpdateSpecialReqNotes6() == 0) return;
            if (UpdateSpecialReqNotes7() == 0) return;
            if (UpdateSpecialReqNotes8() == 0) return;
            UpdateSpecialReqNotes9();
        }
        protected void btnSaveSignOff_Click(object sender, EventArgs e)
        {
            if (UpdateSignOffQuoteEngineer() == 0) return;
            if (UpdateSignOffMaterialRep() == 0) return;
            if (UpdateSignOffPem() == 0) return;
            UpdateSignOffProductEngineer();
        }

        protected void btnSaveDocDesc1Answer_Click(object sender, EventArgs e)
        {
            SaveDocumentationAnswers();
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            // (This is a button on the pop-up form)
            if (!FileUploadControl.HasFile) return;

            string attachmentCategory = Session["AttachmentCategory"].ToString();
            if (SaveFile() == 1) ShowQuoteFiles(attachmentCategory);
        }

        protected void btnDocSave2_Click(object sender, EventArgs e)
        {
            // Show file upload pop-up window (file upload control cannot be placed within an update panel)
            Session["AttachmentCategory"] = "QuotePrint";
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnDocDelete2_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "QuotePrint";
            if (DeleteFile() == 1)
            {
                tbxDocName2.Text = "";
                btnDocGet2.Enabled = false;
            }
        }

        protected void btnDocGet2_Click(object sender, EventArgs e)
        {
            if (tbxDocName2.Text.Trim() == "") return;
            GetFile("QuotePrint");
        }

        protected void btnDocSave3_Click(object sender, EventArgs e)
        {
            // Show file upload pop-up window (file upload control cannot be placed within an update panel)
            Session["AttachmentCategory"] = "BomLabor";
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnDocDelete3_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "BomLabor";
            if (DeleteFile() == 1)
            {
                tbxDocName3.Text = "";
                btnDocGet3.Enabled = false;
            }
        }

        protected void btnDocGet3_Click(object sender, EventArgs e)
        {
            if (tbxDocName3.Text.Trim() == "") return;
            GetFile("BomLabor");
        }

        protected void btnDocSave4_Click(object sender, EventArgs e)
        {
            // Show file upload pop-up window (file upload control cannot be placed within an update panel)
            Session["AttachmentCategory"] = "CustomerQuote";
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnDocDelete4_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "CustomerQuote";
            if (DeleteFile() == 1)
            {
                tbxDocName4.Text = "";
                btnDocGet4.Enabled = false;
            }
        }

        protected void btnDocGet4_Click(object sender, EventArgs e)
        {
            if (tbxDocName4.Text.Trim() == "") return;
            GetFile("CustomerQuote");
        }

        protected void btnDocSave5_Click(object sender, EventArgs e)
        {
            // Show file upload pop-up window (file upload control cannot be placed within an update panel)
            Session["AttachmentCategory"] = "VendorQuote";
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnDocDelete5_Click(object sender, EventArgs e)
        {
            if (DeleteFile() == 1)
            {
                tbxDocName5.Text = "";
                btnDocGet5.Enabled = false;
            }
        }

        protected void btnDocGet5_Click(object sender, EventArgs e)
        {
            GetFile("VendorQuote");
        }

        #endregion



        #region Authentication Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion



        #region Quote Methods

        private void PopulateForm()
        {
            string quote = tbxQuoteNumber.Text.Trim();
            if (quote == "") return;

            //DeleteTempFiles();

            if (GetQuote(quote) == 0) return;
            Session["Quote"] = tbxQuoteNumber.Text;

            if (InsertCustomerContacts() == 0) return;
            if (InsertSpecialReqNotes() == 0) return;
            if (InsertSignOff() == 0) return;

            PopulateQuoteFields();
            Session["Quote"] = quote;
            rPnl.Visible = true;

            PopulateDocumentationAnswers();
            PopulateNotesAnswers();

            GetCustomerContacts(quote);
            GetToolingBreakdown(quote);
            GetSpecialReqNotes();
            GetDocumentationAnswers();

            ShowQuoteFiles("QuotePrint");
            ShowQuoteFiles("BomLabor");
            ShowQuoteFiles("CustomerQuote");
            ShowQuoteFiles("VendorQuote");
            ToggleGetDocumentButtons();

            if (GetSignOffInitialsQuoteEngineer() == 0) return;
            if (GetSignOffInitialsMaterialRep() == 0) return;
            if (GetSignOffInitialsProductEngineer() == 0) return;
            if (GetSignOffInitialsProgramManager() == 0) return;

            GetSignOff();
        }

        private int GetQuote(string quote)
        {
            QuoteViewModel.GetQuote(quote);
            if (QuoteViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetQuote. {0}", QuoteViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            if (QuoteViewModel.QuoteNumber == null)
            {
                lblError.Text = String.Format("Quote number {0} was not found.", quote);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void PopulateQuoteFields()
        {
            tbxCustomer.Text = QuoteViewModel.Customer;
            tbxEmpirePartNumber.Text = QuoteViewModel.EmpirePartNumber;
            tbxCustomerPartNumber.Text = QuoteViewModel.CustomerPartNumber;
            tbxProgram.Text = QuoteViewModel.Program;
            tbxApplication.Text = QuoteViewModel.Application;
            tbxFinancialEau.Text = QuoteViewModel.FinancialEau;
            tbxCapacityEau.Text = QuoteViewModel.CapactiyEau;
            tbxDate.Text = QuoteViewModel.QtDate;
            tbxSop.Text = QuoteViewModel.Sop;
            tbxEop.Text = QuoteViewModel.Eop;
            tbxSalesman.Text = QuoteViewModel.Salesman;
            tbxEngineerAssignedToQuote.Text = QuoteViewModel.QuoteEngineer;
            tbxSalesPrice.Text = QuoteViewModel.SalePrice;
            tbxYear1.Text = QuoteViewModel.LtaYear1;
            tbxYear2.Text = QuoteViewModel.LtaYear2;
            tbxYear3.Text = QuoteViewModel.LtaYear3;
            tbxYear4.Text = QuoteViewModel.LtaYear4;
            tbxPrototypePrice.Text = QuoteViewModel.PrototypePrice;
            tbxMoq.Text = QuoteViewModel.MinimumOrderQuantity;
            tbxMaterial.Text = QuoteViewModel.Material;
            tbxLabor.Text = QuoteViewModel.Labor;
            tbxTooling.Text = QuoteViewModel.Tooling;
        }

        #endregion



        #region Customer Contact Methods

        private int InsertCustomerContacts()
        {
            CustViewModel.CustomerContactsInsert();
            if (CustViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at InsertCustomerContacts. {0}", CustViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void GetCustomerContacts(string quote)
        {
            odsCustomerContacts.SelectParameters["quote"].DefaultValue = quote;
            odsCustomerContacts.DataBind();
        }

        #endregion



        #region Tooling Breakdown Methods

        private void GetToolingBreakdown(string quote)
        {
            odsToolingBreakdown.SelectParameters["quote"].DefaultValue = quote;
            odsToolingBreakdown.DataBind();
        }

        #endregion



        #region Quote Documents Methods

        private void ToggleGetDocumentButtons()
        {
            btnDocDelete2.Enabled = btnDocGet2.Enabled = (tbxDocName2.Text.Trim() != "");
            btnDocDelete3.Enabled = btnDocGet3.Enabled = (tbxDocName3.Text.Trim() != "");
            btnDocDelete4.Enabled = btnDocGet4.Enabled = (tbxDocName4.Text.Trim() != "");
            btnDocDelete5.Enabled = btnDocGet5.Enabled = (tbxDocName5.Text.Trim() != "");
        }

        private void PopulateDocumentationAnswers()
        {
            List<String> l = new List<String>
            {
                "",
                "Yes",
                "No"
            };

            cbxPoConfirmed.DataSource = l;
            cbxPoConfirmed.DataBind();
        }
        private void GetDocumentationAnswers()
        {
            DocsViewModel.GetDocumentationAnswers(tbxQuoteNumber.Text);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetDocumentationAnswers. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }
            cbxPoConfirmed.Text = DocsViewModel.DocAnswer;
        }

        private void SaveDocumentationAnswers()
        {
            DocsViewModel.SaveDocumentationAnswers(tbxQuoteNumber.Text, lblDocDesc1.Text, cbxPoConfirmed.Text);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SaveDocumentationAnswers. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }
        }

        private void ShowQuoteFiles(string attachmentCategory)
        {
            DocsViewModel.ShowQuoteFileInfo(tbxQuoteNumber.Text, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at ShowquoteFiles. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }

            switch (attachmentCategory)
            {
                case "QuotePrint":
                    tbxDocName2.Text = DocsViewModel.QuoteFileName;
                    btnDocGet2.Enabled = true;
                    break;
                case "BomLabor":
                    tbxDocName3.Text = DocsViewModel.QuoteFileName;
                    btnDocGet3.Enabled = true;
                    break;
                case "CustomerQuote":
                    tbxDocName4.Text = DocsViewModel.QuoteFileName;
                    btnDocGet4.Enabled = true;
                    break;
                case "VendorQuote":
                    tbxDocName5.Text = DocsViewModel.QuoteFileName;
                    btnDocGet5.Enabled = true;
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

            btnDocSave2.Focus();
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
            string s = "window.open('QuoteDocument.aspx', 'popup_window', 'width=600,height=400,left=100,top=100,resizable=yes');";
            ClientScript.RegisterStartupScript(this.GetType(), "script", s, true);

            //cbxPoConfirmed.Focus();
            btnDocGet2.Focus();
        }

        private int DeleteFile()
        {
            string attachmentCategory = Session["AttachmentCategory"].ToString();

            DocsViewModel.DeleteQuoteFile(tbxQuoteNumber.Text, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at DeleteFile. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void DeleteTempFiles()
        {
            string directoryPath = @"C:\inetpub\wwwroot\WebPortal\temp\";
            string[] files = Directory.GetFiles(directoryPath);

            foreach (string file in files)
            {
                FileInfo fi = new FileInfo(file);
                if (fi.LastAccessTime < DateTime.Now.AddDays(-1)) ;
                fi.Delete();
            }
        }

        #endregion



        #region Special Requests / Notes Methods

        private int InsertSpecialReqNotes()
        {
            NotesViewModel.SpecialReqNotesInsert();
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at InsertSpecialReqNotes. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void PopulateNotesAnswers()
        {
            List<String> l = new List<String>
            {
                "",
                "Yes",
                "Yes/No",
                "No"
            };

            cbxAnswer1.DataSource = cbxAnswer2.DataSource = cbxAnswer3.DataSource = cbxAnswer4.DataSource = cbxAnswer5.DataSource =
                cbxAnswer6.DataSource = cbxAnswer7.DataSource = cbxAnswer8.DataSource = cbxAnswer9.DataSource = l;

            cbxAnswer1.DataBind();
            cbxAnswer2.DataBind();
            cbxAnswer3.DataBind();
            cbxAnswer4.DataBind();
            cbxAnswer5.DataBind();
            cbxAnswer6.DataBind();
            cbxAnswer7.DataBind();
            cbxAnswer8.DataBind();
            cbxAnswer9.DataBind();
        }

        private void GetSpecialReqNotes()
        {
            NotesViewModel.GetSpecialReqNotes();
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSpecialReqNotes. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
            }

            int i = 0;
            foreach (var item in NotesViewModel.NotesList)
            {
                i++;
                switch (i)
                {
                    case 1:
                        hfNotesRowId["Notes1"] = item.RowID;
                        lblNotesDesc1.Text = item.Description;
                        cbxAnswer1.Text = item.Answer;
                        memoNotes1.Text = item.Notes;
                        break;
                    case 2:
                        hfNotesRowId["Notes2"] = item.RowID;
                        lblNotesDesc2.Text = item.Description;
                        cbxAnswer2.Text = item.Answer;
                        memoNotes2.Text = item.Notes;
                        break;
                    case 3:
                        hfNotesRowId["Notes3"] = item.RowID;
                        lblNotesDesc3.Text = item.Description;
                        cbxAnswer3.Text = item.Answer;
                        memoNotes3.Text = item.Notes;
                        break;
                    case 4:
                        hfNotesRowId["Notes4"] = item.RowID;
                        lblNotesDesc4.Text = item.Description;
                        cbxAnswer4.Text = item.Answer;
                        memoNotes4.Text = item.Notes;
                        break;
                    case 5:
                        hfNotesRowId["Notes5"] = item.RowID;
                        lblNotesDesc5.Text = item.Description;
                        cbxAnswer5.Text = item.Answer;
                        memoNotes5.Text = item.Notes;
                        break;
                    case 6:
                        hfNotesRowId["Notes6"] = item.RowID;
                        lblNotesDesc6.Text = item.Description;
                        cbxAnswer6.Text = item.Answer;
                        memoNotes6.Text = item.Notes;
                        break;
                    case 7:
                        hfNotesRowId["Notes7"] = item.RowID;
                        lblNotesDesc7.Text = item.Description;
                        cbxAnswer7.Text = item.Answer;
                        memoNotes7.Text = item.Notes;
                        break;
                    case 8:
                        hfNotesRowId["Notes8"] = item.RowID;
                        lblNotesDesc8.Text = item.Description;
                        cbxAnswer8.Text = item.Answer;
                        memoNotes8.Text = item.Notes;
                        break;
                    case 9:
                        hfNotesRowId["Notes9"] = item.RowID;
                        lblNotesDesc9.Text = item.Description;
                        cbxAnswer9.Text = item.Answer;
                        memoNotes9.Text = item.Notes;
                        break;
                }
            }
        }

        private int UpdateSpecialReqNotes1()
        {
            _rowId = (int)hfNotesRowId["Notes1"];
            _answer = cbxAnswer1.Text;
            _notes = memoNotes1.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes1. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes2()
        {
            _rowId = (int)hfNotesRowId["Notes2"];
            _answer = cbxAnswer2.Text;
            _notes = memoNotes2.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes2. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes3()
        {
            _rowId = (int)hfNotesRowId["Notes3"];
            _answer = cbxAnswer3.Text;
            _notes = memoNotes3.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes3. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes4()
        {
            _rowId = (int)hfNotesRowId["Notes4"];
            _answer = cbxAnswer4.Text;
            _notes = memoNotes4.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes4. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes5()
        {
            _rowId = (int)hfNotesRowId["Notes5"];
            _answer = cbxAnswer5.Text;
            _notes = memoNotes5.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes5. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes6()
        {
            _rowId = (int)hfNotesRowId["Notes6"];
            _answer = cbxAnswer6.Text;
            _notes = memoNotes6.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes6. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes7()
        {
            _rowId = (int)hfNotesRowId["Notes7"];
            _answer = cbxAnswer7.Text;
            _notes = memoNotes7.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes7. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes8()
        {
            _rowId = (int)hfNotesRowId["Notes8"];
            _answer = cbxAnswer8.Text;
            _notes = memoNotes8.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes8. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSpecialReqNotes9()
        {
            _rowId = (int)hfNotesRowId["Notes9"];
            _answer = cbxAnswer9.Text;
            _notes = memoNotes9.Text;

            NotesViewModel.SpecialReqNotesUpdate(_rowId, _answer, _notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes9. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        #endregion



        #region Sign Off Methods

        private int InsertSignOff()
        {
            SignOffViewModel.SignOffInsert();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at InsertSignOff. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int GetSignOffInitialsQuoteEngineer()
        {
            SignOffViewModel.GetSignOffInitialsQuoteEngineer();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSignOffInitialsQuoteEngineer. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSoQuoteEngInitials.DataSource = SignOffViewModel.QuoteEngineerList;
            cbxSoQuoteEngInitials.DataBind();
            return 1;
        }

        private int GetSignOffInitialsMaterialRep()
        {
            SignOffViewModel.GetSignOffInitialsMaterialRep();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSignOffInitialsMaterialRep. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSoMaterialRepInitials.DataSource = SignOffViewModel.MaterialRepList;
            cbxSoMaterialRepInitials.DataBind();
            return 1;
        }

        private int GetSignOffInitialsProductEngineer()
        {
            SignOffViewModel.GetSignOffInitialsProductEngineer();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSignOffInitialsProductEngineer. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSoProductEngInitials.DataSource = SignOffViewModel.ProductEngineerList;
            cbxSoProductEngInitials.DataBind();
            return 1;
        }

        private int GetSignOffInitialsProgramManager()
        {
            SignOffViewModel.GetSignOffInitialsProgramManager();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSignOffInitialsProgramManager. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSoPemInitials.DataSource = SignOffViewModel.ProgramManagerList;
            cbxSoPemInitials.DataBind();
            return 1;
        }

        private void GetSignOff()
        {
            SignOffViewModel.GetSignOff();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSignOff. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
            }

            int i = 0;
            foreach (var item in SignOffViewModel.SignOffList)
            {
                i++;
                switch (i)
                {
                    case 1:
                        hfSignOffRowId["SignOff1"] = item.RowID;
                        lblSoQuoteEngTitle.Text = item.Title;
                        cbxSoQuoteEngInitials.Text = item.Initials;
                        deSoQuoteEngDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 2:
                        hfSignOffRowId["SignOff2"] = item.RowID;
                        lblSoMaterialRepTitle.Text = item.Title;
                        cbxSoMaterialRepInitials.Text = item.Initials;
                        //if (item.SignOffDate.HasValue) deSoMaterialRepDate.Value = item.SignOffDate;
                        deSoMaterialRepDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 3:
                        hfSignOffRowId["SignOff3"] = item.RowID;
                        lblSoPemTitle.Text = item.Title;
                        cbxSoPemInitials.Text = item.Initials;
                        //if (item.SignOffDate.HasValue) deSoPemDate.Value = item.SignOffDate;
                        deSoPemDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 4:
                        hfSignOffRowId["SignOff4"] = item.RowID;
                        lblSoProductEngTitle.Text = item.Title;
                        cbxSoProductEngInitials.Text = item.Initials;
                        //if (item.SignOffDate.HasValue) deSoProductEngDate.Value = item.SignOffDate;
                        deSoProductEngDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                }
            }
        }

        private int UpdateSignOffQuoteEngineer()
        {
            _rowId = (int)hfSignOffRowId["SignOff1"];
            _signOffinitials = cbxSoQuoteEngInitials.Text;
            if (deSoQuoteEngDate.Value != null) _signOffDate = Convert.ToDateTime(deSoQuoteEngDate.Value);

            SignOffViewModel.SignOffUpdate(_rowId, _signOffinitials, _signOffDate);
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSignOffQuoteEngineer. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSignOffMaterialRep()
        {
            _rowId = (int)hfSignOffRowId["SignOff2"];
            _signOffinitials = cbxSoMaterialRepInitials.Text;
            if (deSoMaterialRepDate.Value != null) _signOffDate = Convert.ToDateTime(deSoMaterialRepDate.Value);

            SignOffViewModel.SignOffUpdate(_rowId, _signOffinitials, _signOffDate);
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSignOffMaterialRep. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int UpdateSignOffPem()
        {
            _rowId = (int)hfSignOffRowId["SignOff3"];
            _signOffinitials = cbxSoPemInitials.Text;
            if (deSoPemDate.Value != null) _signOffDate = Convert.ToDateTime(deSoPemDate.Value);

            SignOffViewModel.SignOffUpdate(_rowId, _signOffinitials, _signOffDate);
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSignOffPem. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void UpdateSignOffProductEngineer()
        {
            _rowId = (int)hfSignOffRowId["SignOff4"];
            _signOffinitials = cbxSoProductEngInitials.Text;
            if (deSoProductEngDate.Value != null) _signOffDate = Convert.ToDateTime(deSoProductEngDate.Value);

            SignOffViewModel.SignOffUpdate(_rowId, _signOffinitials, _signOffDate);
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSignOffProductEngineer. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
            }
        }


        #endregion


    }
}