using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.Utils;
using QuoteLogGrid.Controllers;
using QuoteLogGrid.Interfaces;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using System.Data.Objects;
using System.Data.Entity;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid.Views.Base;
using QuoteLogGrid.SupportClasses;
using DevExpress.XtraReports.UI;
using System.IO;

namespace QuoteLogGrid.Forms
{
    public partial class formQuoteMaintenance : Form
    {
        private readonly QuoteLogContext _context;
        private readonly QuoteMaintenanceController _quoteMaintenanceController;
        private LTAController ltaController;

        private QuoteTypes _quoteType = new QuoteTypes();

        #region Variables

        private int? _rowID;
        private DateTime? _sop, _eop;
        private string _customer, _customerRfqNumber, _customerPartNumber, _eeiPartNumber,
            _notes, _oem, _applicationCode, _applicationName, _functionName, _eau, _program, _nameplate,
            _programManagerInitials, _engineeringInitials, _salesInitials, _engineeringMaterialsInitials,
            _quoteReviewInitials, _quotePricingInitials, _customerQuoteInitials, _modelYear, _packageNumber,
            _quoteReason, _productLine, _printFilePath, _customerQuoteFilePath, _marketSegment, _marketSubsegment,
            _awarded, _awardedDate, _straightMaterialCost, _stdHours, _tooling, _quotePrice, _prototypePrice,
            _minimumOrderQuantity;

        public bool IsSaved;
        public bool PrintSaved;

        private String filePathQuotePrint;
        private String filePathCustomerQuote;

        #endregion

        #region Properties

        //private bool _isCopyQuote { get; set; }


        private string _quoteNumber;
        public string QuoteNumber
        { 
            get { return _quoteNumber; }
            set { _quoteNumber = value; }
        }

        public BindingList<QuoteEntry> HeaderGridDataSource
        {
            set
            {
                gridControl2.DataSource = value;
                if (value != null) SetFormStateQuoteGrid();
            }
        }

        public BindingList<Requote> RequotesBindingList {set { requoteItemGridLookUpEdit.DataSource = value; }}
        public BindingList<Customer> CustomersBindingList { set { customersItemGridLookUpEdit.DataSource = value; } }
        public BindingList<SalesInitials> SalesInitialsBindingList { set { salesInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<ProgramManagerInitials> ProgramManagerInitialsBindingList { set { programManagerInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<EngineeringInitials> EngineeringInitialsBindingList { set { engineeringInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<EngineeringMaterialsInitials> EngineeringMaterialsInitialsBindingList { set { engineeringMaterialsInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<QuoteReviewInitials> QuoteReviewInitialsBindingList { set { quoteReviewInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<QuotePricingInitials> QuotePricingInitialsBindingList { set { quotePricingInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<CustomerQuoteInitials> CustomerQuoteInitialsBindingList { set { customerQuoteInitialsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<vw_QT_Functions> FunctionsBindingList { set { functionsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<QuoteLogData.Models.Application> ApplicationsBindingList { set { applicationCodeItemGridLookUpEdit.DataSource = value; } }
        public BindingList<vw_QT_QuoteReasons> QuoteReasonsBindingList { set { quoteReasonsItemGridLookUpEdit.DataSource = value; } }
        public BindingList<vw_QT_ProductLines> ProductLinesBindingList { set { productLinesItemGridLookUpEdit.DataSource = value; } }
        public BindingList<vw_QT_EmpireMarketSegment> EmpireMarketSegmentBindingList { set { marketSegmentItemGridLookUpEdit.DataSource = value; } }
        public BindingList<vw_QT_EmpireMarketSubsegment> EmpireMarketSubsegmentBindingList { set { marketSubsegmentItemGridLookUpEdit.DataSource = value; } }

        public BindingList<QuoteLTA> LtaDataSource
        {
            set
            {
                gridControl3.DataSource = null;
                gridControl3.DataSource = value;
                if (value != null)
                {
                    SetFormStateLta();
                }
            }
        }

        private IEnumerable<string> _customerQuoteFile; 
        public IEnumerable<string> CustomerQuoteFile
        {
            set
            {
                _customerQuoteFile = value;
                foreach (var item in _customerQuoteFile)
                {
                    if (item != null) tbxCustQuoteFilePath.Text = item;
                }
                ExistsCustomerQuote = (tbxCustQuoteFilePath.Text != "");
            }
        }

        private bool _existsCustomerQuote;
        public bool ExistsCustomerQuote
        {
            get { return _existsCustomerQuote; }
            set
            {
                if (value)
                {
                    linkAddViewCustomerQuote.Text = "View Quote";
                    //linkRemoveCustomerQuote.Visible = true;
                }
                else
                {
                    linkAddViewCustomerQuote.Text = "Add Quote";
                    //linkAddViewCustomerQuote.Visible = true;
                    //linkRemoveCustomerQuote.Visible = false;
                    tbxCustQuoteFilePath.Text = "";
                }
                _existsCustomerQuote = value;
            }
        }

        private IEnumerable<string> _quotePrintFile;
        public IEnumerable<string> QuotePrintFile
        {
            set
            {
                _quotePrintFile = value;
                foreach (var item in _quotePrintFile)   
                {
                    if (item != null) tbxPrintFilePath.Text = item;   
                }
                ExistsQuotePrint = (tbxPrintFilePath.Text != "");
            }
        }

        private IEnumerable<string> _quotePrintNo;
        public IEnumerable<string> QuotePrintNo
        {
            set
            {
                _quotePrintNo = value;
                foreach (var item in _quotePrintNo)
                {
                    if (item != null) tbxPrintNo.Text = item;
                }
            }
        }

        private IEnumerable<DateTime?> _quotePrintDate;
        public IEnumerable<DateTime?> QuotePrintDate
        {
            set
            {
                _quotePrintDate = value;
                foreach (var item in _quotePrintDate)
                {
                    if (item != null) dateEditPrint.DateTime = item.Value;
                }
            }
        }

        private bool _existsQuotePrint;
        public bool ExistsQuotePrint
        {
            get { return _existsQuotePrint; }
            set
            {
                if (value)
                {
                    linkAddViewPrint.Text = "View Print";
                    //linkRemovePrint.Visible = panelPrint.Visible = true;
                }
                else
                {
                    linkAddViewPrint.Text = "Add Print";
                    //linkAddViewPrint.Visible = true;
                    //linkRemovePrint.Visible = panelPrint.Visible = false;
                    tbxPrintFilePath.Text = "";
                }
                _existsQuotePrint = value;
            }
        }

        #endregion


        #region Enumerators

        public enum PrintDocStatus
        {
            NoActionTaken,
            PrintAdded,
            PrintRemoved
        }
        private PrintDocStatus printDocStatus;

        public enum CustomerQuoteDocStatus
        {
            NoActionTaken,
            QuoteAdded,
            QuoteRemoved
        }
        private CustomerQuoteDocStatus customerQuoteDocStatus;

        #endregion


        public formQuoteMaintenance(string quoteNumber, DateTime? sop, DateTime? eop, int? rowId, QuoteTypes quoteType, string customer,        
            string customerRfqNumber, string customerPartNumber, string eeiPartNumber, string notes, string oem, string applicationCode, 
            string applicationName, string functionName, string eau, string program, string nameplate, string programManagerInitials, 
            string engineeringInitials, string salesInitials, string engineeringMaterialsInitials, string quoteReviewInitials, 
            string quotePricingInitials, string customerQuoteInitials, string modelYear, string packageNumber, string quoteReason,
            string productLine, string printFilePath, string customerQuoteFilePath, string marketSegment, string marketSubsegment,
            string minimumOrderQuantity, string awarded, string awardedDate, string straightMaterialCost, string stdHours, 
            string tooling, string quotePrice, string prototypePrice)
        {
            InitializeComponent();

            _context = new QuoteLogContext();

            _quoteType = quoteType;
            _sop = sop;
            _eop = eop;
            _customer = customer;
            _customerRfqNumber = customerRfqNumber;
            _customerPartNumber = customerPartNumber;
            _eeiPartNumber = eeiPartNumber;
            _notes = notes;
            _oem = oem;
            _applicationCode = applicationCode;
            _applicationName = applicationName;
            _functionName = functionName;
            _eau = eau;
            _program = program;
            _nameplate = nameplate;
            _programManagerInitials = programManagerInitials;
            _engineeringInitials = engineeringInitials;
            _salesInitials = salesInitials;
            _engineeringMaterialsInitials = engineeringMaterialsInitials;
            _quoteReviewInitials = quoteReviewInitials;
            _quotePricingInitials = quotePricingInitials;
            _customerQuoteInitials = customerQuoteInitials;
            _modelYear = modelYear;
            _packageNumber = packageNumber;
            _quoteReason = quoteReason;
            _productLine = productLine;
            _printFilePath = printFilePath;
            _customerQuoteFilePath = customerQuoteFilePath;
            _marketSegment = marketSegment;
            _marketSubsegment = marketSubsegment;
            _awarded = awarded;
            _awardedDate = awardedDate;
            _straightMaterialCost = straightMaterialCost;
            _stdHours = stdHours;
            _tooling = tooling;
            _quotePrice = quotePrice;
            _prototypePrice = prototypePrice;
            _minimumOrderQuantity = minimumOrderQuantity;
            _rowID = rowId;

            _quoteMaintenanceController = new QuoteMaintenanceController(quoteNumber, quoteType, this);

            if (_quoteType != QuoteTypes.ModifyExisting)
            {
                gridControl3.Enabled = btnCSM.Visible = false;
                lblMessage.Text = "CSM and LTA sections will become available after saving.";
            }
            else
            {
                lblMessage.Text = "";
            }

            printDocStatus = PrintDocStatus.NoActionTaken;
            cbxRepeat.Visible = false;

            // File Management
            ShowQuotePrintFileInfo();
            ShowCustomerQuoteFileInfo();
        }


        #region Quote Grid Layout

        private void SetFormStateQuoteGrid()
        {
            layoutView1.Appearance.FieldCaption.Font = new Font("Tahoma", 10);
            layoutView1.Appearance.FieldValue.Font = new Font("Tahoma", 10);
            layoutView1.Appearance.FieldCaption.ForeColor = Color.DimGray;

            switch (_quoteType)
            {
                case QuoteTypes.ModifyExisting:
                    this.Text = "Quote Maintenance";
                    SetFormStateModifyQuote();
                    break;
                case QuoteTypes.New:
                    this.Text = "New Quote";
                    SetFormStateNewQuote();
                    break;
                case QuoteTypes.Copy:
                    this.Text = "Copy Quote";
                    SetCopiedValues();
                    SetFormStateCopyQuote();
                    break;
                case QuoteTypes.BomMod:
                    this.Text = "BOM Modification";
                    SetCopiedValues();
                    SetFormStateBomModQuote();
                    break;
                case QuoteTypes.PriceChange:
                    this.Text = "Price Change";
                    SetCopiedValues();
                    SetFormStatePriceChangeQuote();
                    break;
            }
        }

        private void SetCopiedValues()
        {
            layoutView1.SetRowCellValue(0, "ModelYear", _modelYear);
            layoutView1.SetRowCellValue(0, "Customer", _customer);
            layoutView1.SetRowCellValue(0, "CustomerRFQNumber", _customerRfqNumber);
            layoutView1.SetRowCellValue(0, "CustomerPartNumber", _customerPartNumber);
            layoutView1.SetRowCellValue(0, "EEIPartNumber", _eeiPartNumber);
            layoutView1.SetRowCellValue(0, "Notes", _notes);
            layoutView1.SetRowCellValue(0, "OEM", _oem);
            layoutView1.SetRowCellValue(0, "ApplicationCode", _applicationCode);
            layoutView1.SetRowCellValue(0, "ApplicationName", _applicationName);
            layoutView1.SetRowCellValue(0, "FunctionName", _functionName);
            layoutView1.SetRowCellValue(0, "EAU", _eau);
            layoutView1.SetRowCellValue(0, "Program", _program);
            layoutView1.SetRowCellValue(0, "Nameplate", _nameplate);
            layoutView1.SetRowCellValue(0, "ProgramManagerInitials", _programManagerInitials);
            layoutView1.SetRowCellValue(0, "EngineeringInitials", _engineeringInitials);
            layoutView1.SetRowCellValue(0, "SalesInitials", _salesInitials);
            layoutView1.SetRowCellValue(0, "EngineeringMaterialsInitials", _engineeringMaterialsInitials);
            layoutView1.SetRowCellValue(0, "QuoteReviewInitials", _quoteReviewInitials);
            layoutView1.SetRowCellValue(0, "QuotePricingInitials", _quotePricingInitials);
            layoutView1.SetRowCellValue(0, "CustomerQuoteInitials", _customerQuoteInitials);
            layoutView1.SetRowCellValue(0, "PackageNumber", _packageNumber);
            layoutView1.SetRowCellValue(0, "QuoteReason", _quoteReason);
            layoutView1.SetRowCellValue(0, "ProductLine", _productLine);
            layoutView1.SetRowCellValue(0, "PrintFilePath", _printFilePath);
            layoutView1.SetRowCellValue(0, "CustomerQuoteFilePath", _customerQuoteFilePath);
            layoutView1.SetRowCellValue(0, "EmpireMarketSegment", _marketSegment);
            layoutView1.SetRowCellValue(0, "EmpireMarketSubsegment", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "Awarded", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "AwardedDate", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "StraightMaterialCost", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "StdHours", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "Tooling", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "QuotePrice", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "PrototypePrice", _marketSubsegment);
            layoutView1.SetRowCellValue(0, "MinimumOrderQuantity", _minimumOrderQuantity);
        }

        private void SetFormStateModifyQuote()
        {
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["SOP"].DisplayFormat.FormatType = FormatType.DateTime;
            layoutView1.Columns["SOP"].DisplayFormat.FormatString = "MMM yyyy";
            layoutView1.Columns["EOP"].DisplayFormat.FormatType = FormatType.DateTime;
            layoutView1.Columns["EOP"].DisplayFormat.FormatString = "MMM yyyy";
        }

        private void SetFormStateNewQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.SetRowCellValue(0, "Requote", "N");
            layoutView1.SetRowCellValue(0, "QuoteReason", "New Part");
        }

        private void SetFormStateCopyQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.SetRowCellValue(0, "RequestedDueDate", "");
            layoutView1.SetRowCellValue(0, "Requote", "Y");
            if (_sop != null) layoutView1.SetRowCellValue(0, "SOP", _sop);
            if (_eop != null) layoutView1.SetRowCellValue(0, "EOP", _eop);

            //layoutView1.SetRowCellValue(0, "QuotePrice", "");
            //layoutView1.SetRowCellValue(0, "StraightMaterialCost", "");
            //layoutView1.SetRowCellValue(0, "PrototypePrice", "");
            //layoutView1.SetRowCellValue(0, "EngineeringMaterialsDate", "");
            //layoutView1.SetRowCellValue(0, "QuoteReviewDate", "");
            //layoutView1.SetRowCellValue(0, "QuotePricingDate", "");
            //layoutView1.SetRowCellValue(0, "CustomerQuoteDate", "");
        }

        private void SetFormStateBomModQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ParentQuoteID", _rowID);
            layoutView1.SetRowCellValue(0, "Notes", "");
        }

        private void SetFormStatePriceChangeQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ParentQuoteID", _rowID);
            layoutView1.SetRowCellValue(0, "Requote", "Y");
            layoutView1.SetRowCellValue(0, "Notes", "");
            layoutView1.SetRowCellValue(0, "QuoteReason", "Price Change");
        }

        #endregion

        #region LTA Grid Layout

        private void SetFormStateLta()
        {
            // Set column defaults
            gridView4.Columns["QuoteNumber"].Visible = false;
            gridView4.Columns["LTAYear"].Visible = false;
            gridView4.Columns["EffectiveDate"].OptionsColumn.ReadOnly = true;
        }

        #endregion


        #region Save Event / Methods

        private void btnSave_Click(object sender, EventArgs e)
        {
            //// Show the Lighting Study form to allow the user to link this quote number to a lighting program
            //var form = new formLightingData();
            //form.ShowDialog();

            // If new quote, make sure a customer RFQ number and a quote reason have been entered 
            if (_quoteType != QuoteTypes.ModifyExisting)
            {
                string rfq = (layoutView1.GetRowCellValue(0, "CustomerRFQNumber") != null)
                  ? layoutView1.GetRowCellValue(0, "CustomerRFQNumber").ToString() : "";
                if (rfq == "")
                {
                    MessageBox.Show("Customer RFQ Number is required.", "Message");
                    return;
                }

                string reason = (layoutView1.GetRowCellValue(0, "QuoteReason") != null)
                  ? layoutView1.GetRowCellValue(0, "QuoteReason").ToString() : "";
                if (reason == "")
                {
                    MessageBox.Show("Quote Reason is required.", "Message");
                    return;
                }
            }

            // If the quote reason field is set to New Part, make sure there is no other quote for this part with the same designation
            string quoteReason = (layoutView1.GetRowCellValue(0, "QuoteReason") != null) ? layoutView1.GetRowCellValue(0, "QuoteReason").ToString() : "";
            if (quoteReason == "New Part")
            {
                string eeiPartNumber = layoutView1.GetRowCellValue(0, "EEIPartNumber").ToString();
                if (eeiPartNumber == "")
                {
                    MessageBox.Show("Failed to save. EEIPartNumber cannot be empty for a new part.", "Error");
                    return;
                }
                if (GetQuoteCountForNewPart(eeiPartNumber) == 0) return;
            }

            // End any editing in grids
            gridControl2.FocusedView.CloseEditor();  // Quote grid
            gridControl3.FocusedView.CloseEditor();  // LTA grid

            Cursor.Current = Cursors.WaitCursor;
            btnClose.Enabled = btnPrint.Enabled = false;

            if (_quoteType == QuoteTypes.ModifyExisting)
            {
                SaveExistingQuote();
            }
            else
            {
                SaveNewQuote();
            }

            btnClose.Enabled = btnPrint.Enabled = true;
            Cursor.Current = Cursors.Default;

            IsSaved = true;
        }

        private void SaveExistingQuote()
        {
            string result;

            //// End any editing in grids
            //layoutView1.PostEditor();  // Quote layout grid
            //layoutView1.UpdateCurrentRow();
            //gridView4.PostEditor();  // LTA grid
            //gridView4.UpdateCurrentRow();

            // Save changes made to the QuoteLog entity
            result = _quoteMaintenanceController.SaveContext();
            if (result != "")
            {
                MessageBox.Show(result, "SaveExistingQuote()");
                return;
            }

            //_quoteMaintenanceController.SaveLTAs();  // Save LTA context (save LTA percentages)

            string sYear1 = (gridView4.GetRowCellValue(0, "Percentage") != null) ? gridView4.GetRowCellValue(0, "Percentage").ToString() : "0";
            string sYear2 = (gridView4.GetRowCellValue(1, "Percentage") != null) ? gridView4.GetRowCellValue(1, "Percentage").ToString() : "0"; 
            string sYear3 = (gridView4.GetRowCellValue(2, "Percentage") != null) ? gridView4.GetRowCellValue(2, "Percentage").ToString() : "0"; 
            string sYear4 = (gridView4.GetRowCellValue(3, "Percentage") != null) ? gridView4.GetRowCellValue(3, "Percentage").ToString() : "0";

            decimal? year1 = ValidateLtaPercentage(sYear1);
            decimal? year2 = ValidateLtaPercentage(sYear2);
            decimal? year3 = ValidateLtaPercentage(sYear3);
            decimal? year4 = ValidateLtaPercentage(sYear4);

            _quoteMaintenanceController.UpdateLtas(QuoteNumber, year1, year2, year3, year4);  // Exec procedure to update LTA effective dates based on the saved model year

            _quoteMaintenanceController.GetLTAs();  // Refresh LTA grid

            // Exec procedures to update quote documents
            UpdatePrintDocument();
            UpdateCustomerQuoteDocument();
        }

        private decimal? ValidateLtaPercentage(string value)
        {
            decimal? decVal;
            try
            {
                decVal = Convert.ToDecimal(value);
            }
            catch (Exception)
            {
                decVal = null;
            }
            return decVal;
        }

        private void SaveNewQuote()
        {
            string result;

            if (layoutView1.GetRowCellValue(0, "ModelYear") == null)
            {
                MessageBox.Show("You must enter a Model Year.");
                return;
            }

            // Save changes made to the QuoteLog entity
            result = _quoteMaintenanceController.SaveContext();
            if (result != "")
            {
                MessageBox.Show(result, "SaveNewQuote()");
                return;
            }

            // LTAs
            //_quoteMaintenanceController.UpdateLtas();  // Exec procedure to update LTA effective dates based on the saved model year
            _quoteMaintenanceController.SaveLTAs(QuoteNumber);  // Create LTA records based off the quote's model year with default percentages of zero
            _quoteMaintenanceController.GetLTAs();  // Refresh LTA grid

            // Tie Print to Quote
            if (printDocStatus == PrintDocStatus.PrintAdded) SavePrint();

            // Tie Customer Quote Document (PDF) to Quote
            if (customerQuoteDocStatus == CustomerQuoteDocStatus.QuoteAdded) SaveCustomerQuoteDocument();

            // Allow changes to this newly saved quote
            gridControl3.Enabled = btnCSM.Visible = true;
            _quoteType = QuoteTypes.ModifyExisting;
            lblMessage.Text = "";
        }

        private int GetQuoteCountForNewPart(string part)
        {
            var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            var result = new ObjectParameter("Result", typeof(Int32?));

            try
            {
                _context.usp_QT_NewPartCountPerQuoteCheck(part, tranDT, result);
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null)
                    ? "Failed to save: " + ex.InnerException.Message
                    : "Failed to save: " + ex.Message;
                MessageBox.Show(error, "Error at GetQuoteCountForNewPart()");
                return 0;
            }
            return 1;
        }

        #endregion


        #region Quote Print File

        private void lnkGetQuotePrint_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            GetQuotePrint();
        }

        private void lnkSaveQuotePrint_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            SaveQuotePrint();
        }

        private void lnkDeleteQuotePrint_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            DeleteQuotePrint();
        }

        private void ShowQuotePrintFileInfo()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string attachmentCategory = "QuotePrint";
            string fileName = "";
            try
            {
                var collection = _context.usp_QT_FileManagement_Get(QuoteNumber, attachmentCategory, tranDT, result);
                foreach (var item in collection) fileName = item.FileName;

                if (fileName == "")
                {
                    lnkGetQuotePrint.Enabled = lnkDeleteQuotePrint.Enabled = false;
                    lblQuotePrint.Text = "";
                }
                else
                {
                    lnkGetQuotePrint.Enabled = lnkDeleteQuotePrint.Enabled = true;
                    lblQuotePrint.Text = fileName;
                }
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show("Failed to return Quote Print information from the database.  " + err, "Error at ShowQuotePrintFileInfo()");

                lnkGetQuotePrint.Enabled = lnkSaveQuotePrint.Enabled = lnkDeleteQuotePrint.Enabled = false;
                lblQuotePrint.Text = "";
            }
        }

        private void GetQuotePrint()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string path = Path.GetTempPath();
            path = path + @"QuotePrints\";

            if (Directory.Exists(path)) System.IO.Directory.Delete(path, true);
            System.IO.Directory.CreateDirectory(path);

            string attachmentCategory = "QuotePrint";
            string fileName = "";
            byte[] fileContents;
            try
            {
                var collection = _context.usp_QT_FileManagement_Get(QuoteNumber, attachmentCategory, tranDT, result);
                var item = collection.First();
                fileName = item.FileName;
                fileContents = item.FileContents;

                //fileName = fileName.Remove(fileName.Length - 4);
                //filePathQuotePrint = path + fileName + "_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf";

                filePathQuotePrint = path + fileName;

                var fs = new System.IO.FileStream(filePathQuotePrint, FileMode.OpenOrCreate);
                fs.Write(fileContents, 0, fileContents.Length);
                fs.Flush();
                fs.Close();

                System.Diagnostics.Process.Start(filePathQuotePrint);
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(err, "Error at GetQuotePrint()");
            }
        }

        private void SaveQuotePrint()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            var openFileDialog = new OpenFileDialog();

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                if (openFileDialog.FileName.Length > 0)
                {
                    string filePath = openFileDialog.FileName;
                    string fileName = openFileDialog.SafeFileName;

                    // Read the file (as one string) and convert it to Byte Array
                    byte[] fileContents = System.IO.File.ReadAllBytes(filePath);

                    string attachmentCategory = "QuotePrint";
                    try
                    {
                        _context.usp_QT_FileManagement_Save(QuoteNumber, attachmentCategory, fileName, fileContents, tranDT, result);

                        lnkGetQuotePrint.Enabled = lnkDeleteQuotePrint.Enabled = true;
                        lblQuotePrint.Text = fileName;
                        PrintSaved = true;
                    }
                    catch (Exception ex)
                    {
                        string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                        MessageBox.Show(err, "Error at SaveQuotePrint()");
                    }
                }
            }
        }

        private void DeleteQuotePrint()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string attachmentCategory = "QuotePrint";
            try
            {
                _context.usp_QT_FileManagement_Delete(QuoteNumber, attachmentCategory, tranDT, result);

                lnkGetQuotePrint.Enabled = lnkDeleteQuotePrint.Enabled = false;
                lblQuotePrint.Text = "";
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(err, "Error at DeleteQuotePrint()");
            }
        }

        #endregion


        #region Customer Quote File

        private void lnkGetCustomerQuote_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            GetCustomerQuote();
        }

        private void lnkSaveCustomerQuote_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            SaveCustomerQuote();
        }

        private void lnkDeleteCustomerQuote_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            DeleteCustomerQuote();
        }

        private void ShowCustomerQuoteFileInfo()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string attachmentCategory = "CustomerQuote";
            string fileName = "";
            try
            {
                var collection = _context.usp_QT_FileManagement_Get(QuoteNumber, attachmentCategory, tranDT, result);
                foreach (var item in collection) fileName = item.FileName;

                if (fileName == "")
                {
                    lnkGetCustomerQuote.Enabled = lnkDeleteCustomerQuote.Enabled = false;
                    lblCustomerQuote.Text = "";
                }
                else
                {
                    lnkGetCustomerQuote.Enabled = lnkDeleteCustomerQuote.Enabled = true;
                    lblCustomerQuote.Text = fileName;
                }
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show("Failed to return Customer Quote information from the database.  " + err, "Error at ShowCustomerQuoteFileInfo()");

                lnkGetCustomerQuote.Enabled = lnkSaveCustomerQuote.Enabled = lnkDeleteCustomerQuote.Enabled = false;
                lblCustomerQuote.Text = "";
            }
        }

        private void GetCustomerQuote()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string path = Path.GetTempPath();
            path = path + @"CustomerQuotes\";

            if (Directory.Exists(path)) System.IO.Directory.Delete(path, true);
            System.IO.Directory.CreateDirectory(path);

            string attachmentCategory = "CustomerQuote";
            string fileName = "";
            byte[] fileContents;
            try
            {
                var collection = _context.usp_QT_FileManagement_Get(QuoteNumber, attachmentCategory, tranDT, result);
                var item = collection.First();
                fileName = item.FileName;
                fileContents = item.FileContents;

                //fileName = fileName.Remove(fileName.Length - 4);
                //filePathQuotePrint = path + fileName + "_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf";

                filePathCustomerQuote = path + fileName;

                var fs = new System.IO.FileStream(filePathCustomerQuote, FileMode.OpenOrCreate);
                fs.Write(fileContents, 0, fileContents.Length);
                fs.Flush();
                fs.Close();

                System.Diagnostics.Process.Start(filePathCustomerQuote);
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(err, "Error at GetCustomerQuote()");
            }
        }

        private void SaveCustomerQuote()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            var openFileDialog = new OpenFileDialog();

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                if (openFileDialog.FileName.Length > 0)
                {
                    string filePath = openFileDialog.FileName;
                    string fileName = openFileDialog.SafeFileName;

                    // Read the file (as one string) and convert it to Byte Array
                    byte[] fileContents = System.IO.File.ReadAllBytes(filePath);

                    string attachmentCategory = "CustomerQuote";
                    try
                    {
                        _context.usp_QT_FileManagement_Save(QuoteNumber, attachmentCategory, fileName, fileContents, tranDT, result);

                        lnkGetCustomerQuote.Enabled = lnkDeleteCustomerQuote.Enabled = true;
                        lblCustomerQuote.Text = fileName;
                        PrintSaved = true;
                    }
                    catch (Exception ex)
                    {
                        string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                        MessageBox.Show(err, "Error at SaveCustomerQuote()");
                    }
                }
            }
        }

        private void gridView4_CustomColumnDisplayText(object sender, CustomColumnDisplayTextEventArgs e)
        {
            //var view = sender as ColumnView;
            int row = e.ListSourceRowIndex;
            if (e.Column.FieldName == "Percentage" && e.ListSourceRowIndex != DevExpress.XtraGrid.GridControl.InvalidRowHandle)
            {
                string percentage = (gridView4.GetRowCellValue(row, "Percentage") != null) ? gridView4.GetRowCellValue(row, "Percentage").ToString() : "";
                if (percentage == "0")
                {
                    e.DisplayText = "Flat Rate";
                }
            }
        }

        private void DeleteCustomerQuote()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string attachmentCategory = "CustomerQuote";
            try
            {
                _context.usp_QT_FileManagement_Delete(QuoteNumber, attachmentCategory, tranDT, result);

                lnkGetCustomerQuote.Enabled = lnkDeleteCustomerQuote.Enabled = false;
                lblCustomerQuote.Text = "";
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(err, "Error at DeleteCustomerQuote()");
            }
        }

        #endregion




        #region Quote Print File - OLD

        private void linkAddViewPrint_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (_existsQuotePrint)
            {
                ViewPrint();
            }
            else
            {
                AddPrint();
            }
        }

        private void linkRemovePrint_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            RemovePrint();
        }

        private void ViewPrint()
        {
            try
            {
                System.Diagnostics.Process.Start(tbxPrintFilePath.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message + ".");
            }
        }

        private void AddPrint()
        {
            //Stream myStream = null;
            OpenFileDialog openFileDialog1 = new OpenFileDialog();

            //openFileDialog1.InitialDirectory = "c:\\";
            //openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            //openFileDialog1.FilterIndex = 2;
            //openFileDialog1.RestoreDirectory = true;

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                tbxPrintFilePath.Text = openFileDialog1.FileName;

                panelPrint.Visible = true;
                printDocStatus = PrintDocStatus.PrintAdded;
            }
        }

        private void RemovePrint()
        {
            tbxPrintFilePath.Text = tbxPrintNo.Text = dateEditPrint.Text = "";
            linkAddViewPrint.Visible = panelPrint.Visible = false;
            printDocStatus = PrintDocStatus.PrintRemoved;
        }

        private void UpdatePrintDocument()
        {
            if (printDocStatus == PrintDocStatus.PrintAdded || panelPrint.Visible)
            {
                // Tie Print to Quote 
                SavePrint();
            }
            else if (printDocStatus == PrintDocStatus.PrintRemoved)
            {
                DeletePrint();   
            }
        }
        private void SavePrint()
        {
            if (_quoteMaintenanceController.SavePrint(tbxPrintFilePath.Text.Trim(), tbxPrintNo.Text.Trim(), dateEditPrint.DateTime) == 1)
                ExistsQuotePrint = true;
        }
        private void DeletePrint()
        {
            if (_quoteMaintenanceController.DeletePrint() == 1) ExistsQuotePrint = false;
        }

        #endregion


        #region Customer Quote File - OLD

        //private void GetCustomerQuote()
        //{
        //    var custQuotePath = _quoteMaintenanceController.GetCustomerQuote(); 
        //    foreach (var item in custQuotePath)
        //    {
        //        if (item != null) tbxCustQuoteFilePath.Text = item;
        //    }
        //    _existsCustomerQuote = (tbxCustQuoteFilePath.Text != "");
        //}

        private void linkAddViewCustomerQuote_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (_existsCustomerQuote)
            {
                ViewCustomerQuote();
            }
            else
            {
                AddCustomerQuote();
            }
        }

        private void linkRemoveCustomerQuote_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            RemoveCustomerQuote();
        }

        private void ViewCustomerQuote()
        {
            try
            {
                System.Diagnostics.Process.Start(tbxCustQuoteFilePath.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message + ".");
            }
        }

        private void AddCustomerQuote()
        {
            //Stream myStream = null;
            OpenFileDialog openFileDialog1 = new OpenFileDialog();

            //openFileDialog1.InitialDirectory = "c:\\";
            //openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            //openFileDialog1.FilterIndex = 2;
            //openFileDialog1.RestoreDirectory = true;

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                tbxCustQuoteFilePath.Text = openFileDialog1.FileName;
                customerQuoteDocStatus = CustomerQuoteDocStatus.QuoteAdded;
            }
        }

        private void RemoveCustomerQuote()
        {
            tbxCustQuoteFilePath.Text = "";
            linkAddViewCustomerQuote.Visible = false;
            customerQuoteDocStatus = CustomerQuoteDocStatus.QuoteRemoved;
        }

        private void UpdateCustomerQuoteDocument()
        {
            if (customerQuoteDocStatus == CustomerQuoteDocStatus.QuoteAdded)
            {
                // Tie Customer Quote Document (PDF) to Quote
                SaveCustomerQuoteDocument();
            }
            else if (customerQuoteDocStatus == CustomerQuoteDocStatus.QuoteRemoved)
            {
                DeleteCustomerQuoteDocument();
            }
        }
        private void SaveCustomerQuoteDocument()
        {
            if (_quoteMaintenanceController.SaveCustomerQuote(tbxCustQuoteFilePath.Text.Trim()) == 1)
                ExistsCustomerQuote = true;
        }
        private void DeleteCustomerQuoteDocument()
        {
            if (_quoteMaintenanceController.DeleteCustomerQuote() == 1) ExistsCustomerQuote = false;
        }

        #endregion



        #region Other Events

        private void layoutView1_CellValueChanged(object sender, CellValueChangedEventArgs e)
        {
            if (e.Column.FieldName != "QuotePrice") return;
            if (e.Value == null) return;

            decimal? quotePrice = ValidateDecimal(e.Value.ToString(), "QuotePrice");
            if (quotePrice != null)
            {
                if (quotePrice > 0)
                {
                    string prototypePrice = (quotePrice * 3).ToString();
                    layoutView1.SetRowCellValue(e.RowHandle, layoutView1.Columns["PrototypePrice"], prototypePrice);
                }
                else
                {
                    layoutView1.SetRowCellValue(e.RowHandle, layoutView1.Columns["StraightMaterialCost"], "0");
                    layoutView1.SetRowCellValue(e.RowHandle, layoutView1.Columns["Tooling"], "0");
                    layoutView1.SetRowCellValue(e.RowHandle, layoutView1.Columns["PrototypePrice"], "0");
                }
            }
        }

        private void btnCSM_Click(object sender, EventArgs e)
        {
            formCSM csm = new formCSM(_quoteNumber, _quoteType);
            if (!csm.IsDisposed) csm.ShowDialog();
        }

        private void btnPrint_Click(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;

            reportNewQuote report = new reportNewQuote();
            report.QuoteNumber.Value = _quoteNumber;
            report.ShowPreview();

            Cursor.Current = Cursors.Default;
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        #endregion


        #region Other Methods

        private DateTime? ValidateDateTime(string dt, string dateName)
        {
            try
            {
                return Convert.ToDateTime(dt);
            }
            catch (Exception)
            {
                MessageBox.Show(dateName + " is not in a proper date format. Please fix before proceeding.", "Form Validation Exception");
                return null;
            }
        }

        private Decimal? ValidateDecimal(string dec, string decName)
        {
            try
            {
                return Convert.ToDecimal(dec);
            }
            catch (Exception)
            {
                MessageBox.Show(decName + " is not in a proper decimal format. Please fix before proceeding.", "Form Validation Exception");
                return null;
            }
        }

        #endregion



    }
}
