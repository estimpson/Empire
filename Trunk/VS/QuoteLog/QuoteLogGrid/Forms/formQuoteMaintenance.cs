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
        public bool IsSaved;

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

        public BindingList<Requote> Requotes {set { requoteItemGridLookUpEdit.DataSource = value; }}
        public BindingList<Customer> Customers {set { customersItemGridLookUpEdit.DataSource = value; }}
        public BindingList<SalesInitials> SalesInitials {set { salesInitialsItemGridLookUpEdit.DataSource = value; }}
        public BindingList<ProgramManagerInitials> ProgramManagerInitials {set { programManagerInitialsItemGridLookUpEdit.DataSource = value; }} 
        public BindingList<EngineeringInitials> EngineeringInitials {set { engineeringInitialsItemGridLookUpEdit.DataSource = value; }}
        public BindingList<EngineeringMaterialsInitials> EngineeringMaterialsInitials {set { engineeringMaterialsInitialsItemGridLookUpEdit.DataSource = value; }} 
        public BindingList<QuoteReviewInitials> QuoteReviewInitials {set { quoteReviewInitialsItemGridLookUpEdit.DataSource = value; }} 
        public BindingList<QuotePricingInitials> QuotePricingInitials {set { quotePricingInitialsItemGridLookUpEdit.DataSource = value; }}
        public BindingList<CustomerQuoteInitials> CustomerQuoteInitials {set { customerQuoteInitialsItemGridLookUpEdit.DataSource = value; }}
        public BindingList<Functions> Functions {set { functionsItemGridLookUpEdit.DataSource = value; }}
        public BindingList<QuoteLogData.Models.Application> Applications {set { applicationCodeItemGridLookUpEdit.DataSource = value; }} 

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
                    linkRemoveCustomerQuote.Visible = true;
                }
                else
                {
                    linkAddViewCustomerQuote.Text = "Add Quote";
                    linkAddViewCustomerQuote.Visible = true;
                    linkRemoveCustomerQuote.Visible = false;
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

        private bool _existsQuotePrint;
        public bool ExistsQuotePrint
        {
            get { return _existsQuotePrint; }
            set
            {
                if (value)
                {
                    linkAddViewPrint.Text = "View Print";
                    linkRemovePrint.Visible = true;
                }
                else
                {
                    linkAddViewPrint.Text = "Add Print";
                    linkAddViewPrint.Visible = true;
                    linkRemovePrint.Visible = false;
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


        public formQuoteMaintenance(string quoteNumber, DateTime? sop, DateTime? eop, int? rowId, QuoteTypes quoteType)
        {
            InitializeComponent();

            _context = new QuoteLogContext();

            _quoteType = quoteType;
            _sop = sop;
            _eop = eop;
            _rowID = rowId;

            _quoteMaintenanceController = new QuoteMaintenanceController(quoteNumber, quoteType, this);

            if (_quoteType != QuoteTypes.ModifyExisting)
            {
                gbxLTA.Visible = btnCSM.Visible = false;
                lblMessage.Text = "CSM and LTA sections will become available after saving.";
            }
            else
            {
                lblMessage.Text = "";
            }

            printDocStatus = PrintDocStatus.NoActionTaken;
            cbxRepeat.Visible = false;
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
                    SetFormStateCopyQuote();
                    break;
                case QuoteTypes.BomMod:
                    this.Text = "BOM Modification";
                    SetFormStateBomModQuote();
                    break;
                case QuoteTypes.PriceChange:
                    this.Text = "Price Change";
                    SetFormStatePriceChangeQuote();
                    break;
            }
        }

        private void SetFormStateModifyQuote()
        {
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.Columns["SOP"].DisplayFormat.FormatType = FormatType.DateTime;
            layoutView1.Columns["SOP"].DisplayFormat.FormatString = "MMM yyyy";
            layoutView1.Columns["EOP"].DisplayFormat.FormatType = FormatType.DateTime;
            layoutView1.Columns["EOP"].DisplayFormat.FormatString = "MMM yyyy";
        }

        private void SetFormStateNewQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.SetRowCellValue(0, "Requote", "N");
        }

        private void SetFormStateCopyQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.SetRowCellValue(0, "RequestedDueDate", "");
            layoutView1.SetRowCellValue(0, "Requote", "Y");
            if (_sop != null) layoutView1.SetRowCellValue(0, "SOP", _sop);
            if (_eop != null) layoutView1.SetRowCellValue(0, "EOP", _eop);
        }

        private void SetFormStateBomModQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ParentQuoteID", _rowID);
            layoutView1.SetRowCellValue(0, "Notes", "");
        }

        private void SetFormStatePriceChangeQuote()
        {
            layoutView1.SetRowCellValue(0, "QuoteNumber", _quoteNumber);
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
            layoutView1.SetRowCellValue(0, "ParentQuoteID", _rowID);
            layoutView1.SetRowCellValue(0, "Requote", "Y");
            layoutView1.SetRowCellValue(0, "Notes", "");
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
 
            _quoteMaintenanceController.SaveLTAs();  // Save LTA context (save LTA percentages)
            _quoteMaintenanceController.UpdateLtas();  // Exec procedure to update LTA effective dates based on the saved model year
            _quoteMaintenanceController.GetLTAs();  // Refresh LTA grid

            // Exec procedures to update quote documents
            UpdatePrintDocument();
            UpdateCustomerQuoteDocument();
        }

        private void SaveNewQuote()
        {
            string result;

            // Save changes made to the QuoteLog entity
            result = _quoteMaintenanceController.SaveContext();
            if (result != "")
            {
                MessageBox.Show(result, "SaveNewQuote()");
                return;
            }

            // LTAs
            _quoteMaintenanceController.UpdateLtas();  // Exec procedure to update LTA effective dates based on the saved model year
            _quoteMaintenanceController.SaveLTAs();  // Save LTA context (save LTA percentages)
            _quoteMaintenanceController.GetLTAs();  // Refresh LTA grid

            // Tie Print to Quote
            if (printDocStatus == PrintDocStatus.PrintAdded) SavePrint();

            // Tie Customer Quote Document (PDF) to Quote
            if (customerQuoteDocStatus == CustomerQuoteDocStatus.QuoteAdded) SaveCustomerQuoteDocument();

            // Allow changes to this newly saved quote
            gbxLTA.Visible = btnCSM.Visible = true;
            _quoteType = QuoteTypes.ModifyExisting;
            lblMessage.Text = "";
        }

        #endregion



        #region Quote Print File

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
                printDocStatus = PrintDocStatus.PrintAdded;
            }
        }

        private void RemovePrint()
        {
            tbxPrintFilePath.Text = "";
            linkAddViewPrint.Visible = false;
            printDocStatus = PrintDocStatus.PrintRemoved;
        }

        private void UpdatePrintDocument()
        {
            if (printDocStatus == PrintDocStatus.PrintAdded)
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
            if (_quoteMaintenanceController.SavePrint(tbxPrintFilePath.Text.Trim()) == 1)
                ExistsQuotePrint = true;
        }
        private void DeletePrint()
        {
            if (_quoteMaintenanceController.DeletePrint() == 1) ExistsQuotePrint = false;
        }

        #endregion


        #region Customer Quote File

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
            csm.ShowDialog();
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
