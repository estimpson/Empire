using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Drawing;
using WebPortal.QuoteLogIntegration.PageViewModels;


namespace WebPortal.QuoteLogIntegration.Pages
{
    [Serializable]
    public class ControlArrays
    {
        public ASPxComboBox[] CbxAnswers;
        public ASPxMemo[] MemoNotes;
        public ASPxLabel[] LblNotesDescs;
    }

    public partial class QuoteTransfer : System.Web.UI.Page
    {
        #region Instance variables for control arrays.

        private ControlArrays _controlArrays;

        void BuildControlArrays()
        {
            _controlArrays = new ControlArrays();
            _controlArrays.CbxAnswers = new ASPxComboBox[]
            {
                cbxAnswer0, cbxAnswer1, cbxAnswer2, cbxAnswer3, cbxAnswer4, cbxAnswer5, cbxAnswer6, cbxAnswer7, cbxAnswer8
            };
            
            _controlArrays.MemoNotes = new ASPxMemo[]
            {
                memoNotes0, memoNotes1, memoNotes2, memoNotes3, memoNotes4, memoNotes5, memoNotes6, memoNotes7, memoNotes8
            };

            _controlArrays.LblNotesDescs = new ASPxLabel[]
            {
                lblNotesDesc0, lblNotesDesc1, lblNotesDesc2, lblNotesDesc3, lblNotesDesc4, lblNotesDesc5, lblNotesDesc6, lblNotesDesc7, lblNotesDesc8
            };
        }
       #endregion


        #region MyViewModels

        private QtQuoteTransferViewModel QuoteTransferViewModel
        {
            get
            {
                ViewState["QuoteTransferViewModel"] =
                    ViewState["QuoteTransferViewModel"] ?? new QtQuoteTransferViewModel();
                return (QtQuoteTransferViewModel) ViewState["QuoteTransferViewModel"];
            }
        }

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

        #endregion


        protected void Page_Init(object sender, EventArgs e)
        {
            QuoteViewModel.OperatorCode = CustViewModel.OperatorCode = NotesViewModel.OperatorCode = SignOffViewModel.OperatorCode =
                DocsViewModel.OperatorCode = Session["OpCode"].ToString();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            BuildControlArrays();
            if (!Page.IsPostBack)
            { 
                if (Session["QuoteNumber"] != null)
                {
                    cbxQuoteNumbers.Text = Session["QuoteNumber"].ToString();
                    PopulateForm();
                }
                cbxQuoteNumbers.Focus();
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
            for (int note = 0; note <= 8; note++)
            {
                if (UpdateSpecialReqNotes(note) == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(btnSaveNotes, btnSaveNotes.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    return;
                }
            }
            ScriptManager.RegisterClientScriptBlock(btnSaveNotes, btnSaveNotes.GetType(), "HideLoadingPanel", "lp.Hide();", true);
        }

        protected void btnSaveSignOff_Click(object sender, EventArgs e)
        {
            if (UpdateSignOffs() == 0) return;
            if (PopulateSignOffLists() == 1) GetSignedOffEmployees();

            ScriptManager.RegisterClientScriptBlock(btnSaveSignOff, btnSaveSignOff.GetType(), "HideLoadingPanel", "lp.Hide();", true);
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
                btnDocGet2.Enabled = btnDocDelete2.Enabled = false;
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
                btnDocGet3.Enabled = btnDocDelete3.Enabled = false;
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
                btnDocGet4.Enabled = btnDocDelete4.Enabled = false;
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
                btnDocGet5.Enabled = btnDocDelete5.Enabled = false;
            }
        }

        protected void btnDocGet5_Click(object sender, EventArgs e)
        {
            GetFile("VendorQuote");
        }

        protected void cpTransferComplete_Callback(object sender, CallbackEventArgsBase e)
        {
            string quote = cbxQuoteNumbers.Text.Trim();
            if (quote == "")
            {
                lblError.Text = "A quote must be selected.";
                pcError.ShowOnPageLoad = true;
            }

            lblTransferCompleteResult.Text = "";
            System.Threading.Thread.Sleep(1000);

            if (e.Parameter == "Y")
            {
                QuoteViewModel.QuoteTransferCompleteUpdateSendEmail(quote, "Y", DateTime.Now);
            }
            else
            {
                QuoteViewModel.QuoteTransferCompleteUpdateSendEmail(quote, "N", null);
            }

            if (QuoteViewModel.Error != "")
            {
                lblTransferCompleteResult.Text = "Error: " + QuoteViewModel.Error;
                lblTransferCompleteResult.ForeColor = Color.Red;
            }
        }

        //protected void cbxSoQuoteEngInitials_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GetInitials(1);
        //    PopulateSignOffLists();
        //    ScriptManager.RegisterClientScriptBlock(cbxSoQuoteEngInitials, cbxSoQuoteEngInitials.GetType(), "HideLoadingPanel", "lp.Hide();", true);
        //}

        //protected void cbxSoMaterialRepInitials_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GetInitials(2);
        //    PopulateSignOffLists();
        //    ScriptManager.RegisterClientScriptBlock(cbxSoMaterialRepInitials, cbxSoMaterialRepInitials.GetType(), "HideLoadingPanel", "lp.Hide();", true);
        //}

        //protected void cbxSoPemInitials_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GetInitials(3);
        //    PopulateSignOffLists();
        //    ScriptManager.RegisterClientScriptBlock(cbxSoPemInitials, cbxSoPemInitials.GetType(), "HideLoadingPanel", "lp.Hide();", true);
        //}

        //protected void cbxSoProductEngInitials_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GetInitials(4);
        //    PopulateSignOffLists();
        //    ScriptManager.RegisterClientScriptBlock(cbxSoProductEngInitials, cbxSoProductEngInitials.GetType(), "HideLoadingPanel", "lp.Hide();", true);
        //}

        #endregion


        #region Quote Methods

        private void PopulateForm()
        {
            string quote = cbxQuoteNumbers.Text.Trim();
            if (quote == "") return;

            DeleteTempFiles();

            if (GetQuote(quote) == 0) return;
            Session["Quote"] = cbxQuoteNumbers.Text;

            if (NewQuoteTransfer(quote) != 1) return;

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
            ToggleDocumentButtons();

            if (PopulateSignOffLists() == 1) GetSignedOffEmployees();
            //for (int i = 1; i < 4; i++)
            //{
            //    GetInitials(i);
            //}
        }

        private int NewQuoteTransfer(string quote)
        {
            QuoteTransferViewModel.NewQuoteTransfer(quote);
            if (QuoteTransferViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at NewQuoteTransfer. {0}", QuoteTransferViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
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
            tbxProgramManager.Text = QuoteViewModel.ProgramManager;
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

            if (QuoteViewModel.QuoteTransferComplete == "Y")
            {
                rlTransferComplete.Items[0].Selected = true;
            }
            else
            {
                rlTransferComplete.Items[1].Selected = true;
            }
        }

        #endregion


        #region Customer Contact Methods

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

        private void ToggleDocumentButtons()
        {
            btnDocDelete2.Enabled = btnDocGet2.Enabled = (tbxDocName2.Text.Trim() != "");
            btnDocDelete3.Enabled = btnDocGet3.Enabled = (tbxDocName3.Text.Trim() != "");
            btnDocDelete4.Enabled = btnDocGet4.Enabled = (tbxDocName4.Text.Trim() != "");
            btnDocDelete5.Enabled = btnDocGet5.Enabled = (tbxDocName5.Text.Trim() != "");
        }

        private void ToggleDocumentButtonsAfterClick(int button, int deletedSaved)
        {
            switch (button)
            {
                case 2:
                    btnDocDelete2.Enabled = btnDocGet2.Enabled = (deletedSaved == 1);
                    break;
                case 3:
                    btnDocDelete3.Enabled = btnDocGet3.Enabled = (deletedSaved == 1);
                    break;
                case 4:
                    btnDocDelete4.Enabled = btnDocGet4.Enabled = (deletedSaved == 1);
                    break;
                case 5:
                    btnDocDelete5.Enabled = btnDocGet5.Enabled = (deletedSaved == 1);
                    break;
            }
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
            DocsViewModel.GetDocumentationAnswers(cbxQuoteNumbers.Text);
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
            DocsViewModel.SaveDocumentationAnswers(cbxQuoteNumbers.Text, lblDocDesc1.Text, cbxPoConfirmed.Text);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SaveDocumentationAnswers. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }
        }

        private void ShowQuoteFiles(string attachmentCategory)
        {
            DocsViewModel.ShowQuoteFileInfo(cbxQuoteNumbers.Text, attachmentCategory);
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
                    btnDocGet2.Enabled = btnDocDelete2.Enabled = true;
                    break;
                case "BomLabor":
                    tbxDocName3.Text = DocsViewModel.QuoteFileName;
                    btnDocGet3.Enabled = btnDocDelete3.Enabled = true;
                    break;
                case "CustomerQuote":
                    tbxDocName4.Text = DocsViewModel.QuoteFileName;
                    btnDocGet4.Enabled = btnDocDelete3.Enabled = true;
                    break;
                case "VendorQuote":
                    tbxDocName5.Text = DocsViewModel.QuoteFileName;
                    btnDocGet5.Enabled = btnDocDelete4.Enabled = true;
                    break;           
            }
        }

        private int SaveFile()
        {
            string attachmentCategory = Session["AttachmentCategory"].ToString();

            string fileName = Path.GetFileName(FileUploadControl.FileName);
            byte[] fileContents = FileUploadControl.FileBytes;

            DocsViewModel.SaveQuoteFile(cbxQuoteNumbers.Text, attachmentCategory, fileName, fileContents);
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
            DocsViewModel.GetQuoteFile(cbxQuoteNumbers.Text, attachmentCategory, out fileName, out fileContents);

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

            DocsViewModel.DeleteQuoteFile(cbxQuoteNumbers.Text, attachmentCategory);
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
            if (!Directory.Exists(directoryPath)) return;

            string[] files = Directory.GetFiles(directoryPath);
            foreach (string file in files)
            {
                FileInfo fi = new FileInfo(file);
                if (fi.LastAccessTime < DateTime.Now.AddDays(-1)) fi.Delete();
                
            }
        }

        #endregion


        #region Special Requests / Notes Methods

        private void PopulateNotesAnswers()
        {
            List<String> l = new List<String>
            {
                "",
                "Yes",
                "Yes/No",
                "No"
            };

            for (int i = 0; i < 9; i++)
            {
                _controlArrays.CbxAnswers[i].DataSource = l;
                _controlArrays.CbxAnswers[i].DataBind();
            }
        }

        private void GetSpecialReqNotes()
        {
            NotesViewModel.GetSpecialReqNotes();
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetSpecialReqNotes. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
            }

            int i = -1;
            foreach (var item in NotesViewModel.NotesList)
            {
                i++;
                hfNotesRowId[$"Note{i}"] = item.RowID;
                _controlArrays.CbxAnswers[i].Text = item.Answer;
                _controlArrays.MemoNotes[i].Text = item.Notes;
                _controlArrays.LblNotesDescs[i].Text = item.Description;
            }
        }

        private int UpdateSpecialReqNotes(int note)
        {
            var rowId = (int)hfNotesRowId[$"Note{note}"];
            var answer = _controlArrays.CbxAnswers[note].Text;
            var notes = _controlArrays.MemoNotes[note].Text;
            NotesViewModel.SpecialReqNotesUpdate(rowId, answer, notes);
            if (NotesViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSpecialReqNotes1. {0}", NotesViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }
        #endregion



        #region Sign Off Methods

        private int PopulateSignOffLists()
        {
            // Populate the lists with all employees
            SignOffViewModel.GetEmployees();
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at PopulateSignOffLists. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }

            cbxSoQuoteEngInitials.DataSource = cbxSoMaterialRepInitials.DataSource = cbxSoPemInitials.DataSource = 
                cbxSoProductEngInitials.DataSource = SignOffViewModel.SignOffEmployeesList;

            cbxSoQuoteEngInitials.DataBind();
            cbxSoMaterialRepInitials.DataBind();
            cbxSoPemInitials.DataBind();
            cbxSoProductEngInitials.DataBind();
            return 1;
        }

        private void GetSignedOffEmployees()
        {
            // If an employee has signed off selected them in the list
            SignOffViewModel.GetSignedOffEmployees();
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
                        cbxSoQuoteEngInitials.Value = item.EmployeeCode;
                        deSoQuoteEngDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 2:
                        hfSignOffRowId["SignOff2"] = item.RowID;
                        lblSoMaterialRepTitle.Text = item.Title;
                        cbxSoMaterialRepInitials.Value = item.EmployeeCode;
                        deSoMaterialRepDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 3:
                        hfSignOffRowId["SignOff3"] = item.RowID;
                        lblSoPemTitle.Text = item.Title;
                        cbxSoPemInitials.Value = item.EmployeeCode;
                        deSoPemDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                    case 4:
                        hfSignOffRowId["SignOff4"] = item.RowID;
                        lblSoProductEngTitle.Text = item.Title;
                        cbxSoProductEngInitials.Value = item.EmployeeCode;
                        deSoProductEngDate.Value = (item.SignOffDate.HasValue) ? item.SignOffDate : DateTime.Now;
                        break;
                }
            }
        }

        //private void GetInitials(int type)
        //{
        //    // Show the initials of selected employees
        //    string employeeCode, initials;
        //    switch (type)
        //    {
        //        case 1:
        //            employeeCode = (string)cbxSoQuoteEngInitials.Value;
        //            initials = SignOffViewModel.GetEmployeeInitials(employeeCode);
        //            tbxQuoteEngInitials.Text = initials;
        //            break;
        //        case 2:
        //            employeeCode = (string)cbxSoMaterialRepInitials.Value;
        //            initials = SignOffViewModel.GetEmployeeInitials(employeeCode);
        //            tbxMatRepInitials.Text = initials;
        //            break;
        //        case 3:
        //            employeeCode = (string)cbxSoPemInitials.Value;
        //            initials = SignOffViewModel.GetEmployeeInitials(employeeCode);
        //            tbxPemInitials.Text = initials;
        //            break;
        //        case 4:
        //            employeeCode = (string)cbxSoProductEngInitials.Value;
        //            initials = SignOffViewModel.GetEmployeeInitials(employeeCode);
        //            tbxProdEngInitials.Text = initials;
        //            break;
        //    }
        //}

        private int UpdateSignOffs()
        {
            string quoteEng = (cbxSoQuoteEngInitials.Value != null) ? (string)cbxSoQuoteEngInitials.Value : "";
            string matRep = (cbxSoMaterialRepInitials.Value != null) ? (string)cbxSoMaterialRepInitials.Value : "";
            string pem = (cbxSoPemInitials.Value != null) ? (string)cbxSoPemInitials.Value : "";
            string prodEng = (cbxSoProductEngInitials.Value != null) ? (string)cbxSoProductEngInitials.Value : "";

            SignOffViewModel.SignOffUpdate((int)hfSignOffRowId["SignOff1"], quoteEng, null, (DateTime)deSoQuoteEngDate.Value);
            SignOffViewModel.SignOffUpdate((int)hfSignOffRowId["SignOff2"], matRep, null, (DateTime)deSoMaterialRepDate.Value);
            SignOffViewModel.SignOffUpdate((int)hfSignOffRowId["SignOff3"], pem, null, (DateTime)deSoPemDate.Value);
            SignOffViewModel.SignOffUpdate((int)hfSignOffRowId["SignOff4"], prodEng, null, (DateTime)deSoProductEngDate.Value);
            if (SignOffViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at UpdateSignOffs. {0}", SignOffViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }




        #endregion


    }
}