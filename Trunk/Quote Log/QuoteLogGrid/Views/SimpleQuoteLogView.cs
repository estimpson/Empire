using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.Utils;
using DevExpress.XtraGrid.Views.Base;
using QuoteLogGrid.Controllers;
using QuoteLogGrid.Interfaces;
using QuoteLogData.Models;
using QuoteLogGrid.Forms;
using DevExpress.Data.Linq;
using System.Data.Objects;
using System.Data.Entity;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraEditors.Controls;
using System.IO;
using QuoteLogGrid.SupportClasses;

namespace QuoteLogGrid.Views
{
    public partial class SimpleQuoteLogView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext _context;

        private string _quoteNumber, _customer, _customerRfqNumber, _customerPartNumber, _eeiPartNumber,
            _notes, _oem, _applicationCode, _applicationName, _functionName, _eau, _program, _nameplate,
            _programManagerInitials, _engineeringInitials, _salesInitials, _engineeringMaterialsInitials,
            _quoteReviewInitials, _quotePricingInitials, _customerQuoteInitials, _modelYear, _packageNumber,
            _quoteReason, _productLine, _printFilePath, _customerQuoteFilePath, _marketSegment, _marketSubsegment,
            _minimumOrderQuantity, _awarded, _awardedDate, _tooling, _straightMaterialCost, _stdHours, _quotePrice,
            _prototypePrice;


        public SimpleQuoteLogView()
        {
            InitializeComponent();
            InitGrid();

            _context = new QuoteLogContext();

            btnRefresh.Visible = false;
        }

        void InitGrid()
        {
        }


        #region EmbeddedNavigator Events

        private void gridControl_EmbeddedNavigator_Click(object sender, EventArgs e)
        {
        }

        #endregion


        #region Button Click Events

        private void btnSave_Click(object sender, EventArgs e)
        {
            // Check to see if a new part has been entered and if so, set the quote reason before saving
            //LookUpBasePart();

            // If the quote reason field is set to New Part, make sure there is no other quote for this part with the same designation
            int r = gridView1.GetSelectedRows()[0];
            string quoteReason = (gridView1.GetRowCellValue(r, "QuoteReason") != null) ? gridView1.GetRowCellValue(r, "QuoteReason").ToString() : "";
            if (quoteReason == "New Part")
            {
                string eeiPartNumber = (gridView1.GetRowCellValue(r, "EEIPartNumber") != null) ? gridView1.GetRowCellValue(r, "EEIPartNumber").ToString() : "";
                if (eeiPartNumber == "")
                {
                    MessageBox.Show("Failed to save. EEIPartNumber cannot be empty for a new part.", "Error");
                    return;
                }
                if (GetQuoteCountForNewPart(eeiPartNumber) == 0) return;
            }

            SaveData();
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            //RefreshGrid();
        }

        private void btnExportToExcel_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        #endregion


        #region Grid Data Methods

        public void ShowData()
        {
            Cursor.Current = Cursors.WaitCursor;
            try
            {
                gridView1.ClearColumnsFilter();
                gridView1.ClearGrouping();
                gridView1.ClearSorting();

                // Query the database and copy records to local dbsets
                ////_context.QuoteLog.Load();
                //var x = (from u in _context.QuoteLog
                //         //where u.QuoteNumber.StartsWith("52")
                //         select u).ToList();


                // Load some quotes from the database into the DbContext
                _context.QuoteLog.Where(q => q.QuoteNumber.StartsWith("52")).Load();
                //_context.QuoteLog.Load();
      
                // Bind grid
                //gridControl.DataSource = null;
                gridControl.DataSource = _context.QuoteLog.Local.ToBindingList();

                

                // Modify grid fields
                gridView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["CustomerRFQNumber"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["LTA"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["NameplateComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["OEMComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["ProgramComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["TotalQuotedSales"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["FileServerQuotePrint"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["FileServerCustomerQuote"].OptionsColumn.ReadOnly = true;

                //gridView1.Columns["QuoteReason"].OptionsColumn.ReadOnly = true;

                gridView1.Columns["SOP"].DisplayFormat.FormatType = FormatType.DateTime;
                gridView1.Columns["SOP"].DisplayFormat.FormatString = "MMM yyyy";

                gridView1.Columns["EOP"].DisplayFormat.FormatType = FormatType.DateTime;
                gridView1.Columns["EOP"].DisplayFormat.FormatString = "MMM yyyy";

                gridView1.Columns["AwardedDate"].DisplayFormat.FormatType = FormatType.DateTime;
                gridView1.Columns["AwardedDate"].DisplayFormat.FormatString = "MMM yyyy";


                BindLookupColumns();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
            }
            Cursor.Current = Cursors.Default;
        }

        private void BindLookupColumns()
        {
            try
            {
                // Query the database and copy records to local dbset
                _context.Requotes.Load();
                _context.Customers.Load();
                _context.SalesInitials.Load();
                _context.ProgramManagerInitials.Load();
                _context.EngineeringInitials.Load();
                _context.EngineeringMaterialsInitials.Load();
                _context.QuoteReviewInitials.Load();
                _context.QuotePricingInitials.Load();
                _context.CustomerQuoteInitials.Load();
                _context.Applications.Load();
                _context.vw_QT_Functions.Load();
                _context.vw_QT_QuoteReasons.Load();
                _context.vw_QT_ProductLines.Load();
                _context.vw_QT_EmpireMarketSegment.Load();
                _context.vw_QT_EmpireMarketSubsegment.Load();

                // Clear grids
                //requoteItemGridLookUpEdit.DataSource = customerItemGridLookUpEdit.DataSource =
                //    salesInitialsItemGridLookUpEdit.DataSource = programManagerInitialsItemGridLookUpEdit.DataSource =
                //    engineeringInitialsItemGridLookUpEdit.DataSource = engineeringMaterialsInitialsItemGridLookUpEdit.DataSource =
                //    quoteReviewInitialsItemGridLookUpEdit.DataSource = quotePricingInitialsItemGridLookUpEdit.DataSource =
                //    customerQuoteInitialsItemGridLookUpEdit.DataSource = applicationCodeItemGridLookUpEdit.DataSource =
                //    functionsItemGridLookUpEdit.DataSource = null;

                // Bind lookup columns
                requoteItemGridLookUpEdit.DataSource = _context.Requotes.Local.ToBindingList();
                customerItemGridLookUpEdit.DataSource = _context.Customers.Local.ToBindingList();
                salesInitialsItemGridLookUpEdit.DataSource = _context.SalesInitials.Local.ToBindingList();
                programManagerInitialsItemGridLookUpEdit.DataSource = _context.ProgramManagerInitials.Local.ToBindingList();
                engineeringInitialsItemGridLookUpEdit.DataSource = _context.EngineeringInitials.Local.ToBindingList();
                engineeringMaterialsInitialsItemGridLookUpEdit.DataSource = _context.EngineeringMaterialsInitials.Local.ToBindingList();
                quoteReviewInitialsItemGridLookUpEdit.DataSource = _context.QuoteReviewInitials.Local.ToBindingList();
                quotePricingInitialsItemGridLookUpEdit.DataSource = _context.QuotePricingInitials.Local.ToBindingList();
                customerQuoteInitialsItemGridLookUpEdit.DataSource = _context.CustomerQuoteInitials.Local.ToBindingList();
                applicationCodeItemGridLookUpEdit.DataSource = _context.Applications.Local.ToBindingList();
                functionsItemGridLookUpEdit.DataSource = _context.vw_QT_Functions.Local.ToBindingList();
                quoteReasonItemGridLookUpEdit.DataSource = _context.vw_QT_QuoteReasons.Local.ToBindingList();
                productLineItemGridLookUpEdit.DataSource = _context.vw_QT_ProductLines.Local.ToBindingList();
                marketSegmentItemGridLookUpEdit.DataSource = _context.vw_QT_EmpireMarketSegment.Local.ToBindingList();
                marketSubsegmentItemGridLookUpEdit.DataSource = _context.vw_QT_EmpireMarketSubsegment.Local.ToBindingList();
            }
            catch (Exception)
            {
                MessageBox.Show("Error occured while retrieving data for header grid dropdown lists.");
            }
        }

        //private void LookUpBasePart()
        //{
        //var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //var result = new ObjectParameter("Result", typeof(Int32?));
        //    string basePart = "";

        //    int r = gridView1.GetSelectedRows()[0];
        //    string eeiPartNumber = (gridView1.GetRowCellValue(r, "EEIPartNumber") != null) ? gridView1.GetRowCellValue(r, "EEIPartNumber").ToString() : "";
        //    if (eeiPartNumber == "") return;

        //    try
        //    {
        //        var collection = _context.usp_QT_NewPartCheck(eeiPartNumber, tranDT, result);
        //        foreach (var item in collection) basePart = item.BasePart;

        //        // If the entered part is not found, assume this is a new base part and set the quote reason field accordingly
        //        if (basePart == "") gridView1.SetRowCellValue(r, "QuoteReason", basePart);
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //        MessageBox.Show(error, "Error at LookUpBasePart");
        //    }
        //}

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

        public void SaveData()
        {
            Cursor.Current = Cursors.WaitCursor;

            gridView1.PostEditor();
            gridView1.UpdateCurrentRow();

            _context.SaveChanges();

            Cursor.Current = Cursors.Default;
        }

        public void ExportToExcel()
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.Title = "Select the Excel file (.xlsx) to import the data into ...";
                ofd.Filter = "*.xlsx|*.xlsx";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    string filePath = ofd.FileName;
                    gridControl.ExportToXlsx(filePath);
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(error, "Error at Export to Excel");
            }
        }

        #endregion


        #region SaveRestore Grid Layout

        public void SaveLayout()
        {
            try
            {
                Directory.CreateDirectory(@"C:\QuoteLogGridSettings");
                MessageBox.Show("Layout saved.", "Message");
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Failed to create the directory where grid settings will be saved.  {0}", ex.Message), "Error");
                return;
            }

            string fileName = @"C:\QuoteLogGridSettings\SimpleQuoteLogView.xml";
            try
            {
                gridView1.SaveLayoutToXml(fileName);
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Failed to save grid settings.  {0}", ex.Message), "Error");
            }
        }

        public void RestoreLayout()
        {
            try
            {
                // Restore saved grid settings if they exist
                string filePath = @"C:\QuoteLogGridSettings\SimpleQuoteLogView.xml";
                if (File.Exists(filePath)) gridView1.RestoreLayoutFromXml(filePath);
            }
            catch (Exception ex)
            {
                MessageBox.Show(string.Format("Grid layout could not be restored. Exception:  {0}", ex.Message), "Error");
            }
        }

        #endregion


        #region Show Quote Form

        private void gridControl_DoubleClick(object sender, EventArgs e)
        {
            DateTime? sop;
            DateTime? eop;
            int r = gridView1.GetSelectedRows()[0];

            _quoteNumber = gridView1.GetRowCellValue(r, "QuoteNumber").ToString(); 

            if (gridView1.GetRowCellValue(r, "SOP") != null)
            {
                sop = Convert.ToDateTime(gridView1.GetRowCellValue(r, "SOP"));
            }
            else
            {
                sop = null;
            }

            if (gridView1.GetRowCellValue(r, "EOP") != null)
            {
                eop = Convert.ToDateTime(gridView1.GetRowCellValue(r, "EOP"));
            }
            else
            {
                eop = null;
            }

            if (gridView1.GetRowCellValue(r, "Customer") != null) _customer = gridView1.GetRowCellValue(r, "Customer").ToString();
            if (gridView1.GetRowCellValue(r, "CustomerRFQNumber") != null) _customerRfqNumber = gridView1.GetRowCellValue(r, "CustomerRFQNumber").ToString();
            if (gridView1.GetRowCellValue(r, "CustomerPartNumber") != null) _customerPartNumber = gridView1.GetRowCellValue(r, "CustomerPartNumber").ToString();
            if (gridView1.GetRowCellValue(r, "EEIPartNumber") != null) _eeiPartNumber = gridView1.GetRowCellValue(r, "EEIPartNumber").ToString();
            if (gridView1.GetRowCellValue(r, "Notes") != null) _notes = gridView1.GetRowCellValue(r, "Notes").ToString();
            if (gridView1.GetRowCellValue(r, "OEM") != null) _oem = gridView1.GetRowCellValue(r, "OEM").ToString();
            if (gridView1.GetRowCellValue(r, "ApplicationCode") != null) _applicationCode = gridView1.GetRowCellValue(r, "ApplicationCode").ToString();
            if (gridView1.GetRowCellValue(r, "ApplicationName") != null) _applicationName = gridView1.GetRowCellValue(r, "ApplicationName").ToString();
            if (gridView1.GetRowCellValue(r, "FunctionName") != null) _functionName = gridView1.GetRowCellValue(r, "FunctionName").ToString();
            if (gridView1.GetRowCellValue(r, "EAU") != null) _eau = gridView1.GetRowCellValue(r, "EAU").ToString();
            if (gridView1.GetRowCellValue(r, "Program") != null) _program = gridView1.GetRowCellValue(r, "Program").ToString();
            if (gridView1.GetRowCellValue(r, "Nameplate") != null) _nameplate = gridView1.GetRowCellValue(r, "Nameplate").ToString();
            if (gridView1.GetRowCellValue(r, "ProgramManagerInitials") != null) _programManagerInitials = gridView1.GetRowCellValue(r, "ProgramManagerInitials").ToString();
            if (gridView1.GetRowCellValue(r, "EngineeringInitials") != null) _engineeringInitials = gridView1.GetRowCellValue(r, "EngineeringInitials").ToString();
            if (gridView1.GetRowCellValue(r, "SalesInitials") != null) _salesInitials = gridView1.GetRowCellValue(r, "SalesInitials").ToString();
            if (gridView1.GetRowCellValue(r, "EngineeringMaterialsInitials") != null) _engineeringMaterialsInitials = gridView1.GetRowCellValue(r, "EngineeringMaterialsInitials").ToString();
            if (gridView1.GetRowCellValue(r, "QuoteReviewInitials") != null) _quoteReviewInitials = gridView1.GetRowCellValue(r, "QuoteReviewInitials").ToString();
            if (gridView1.GetRowCellValue(r, "QuotePricingInitials") != null) _quotePricingInitials = gridView1.GetRowCellValue(r, "QuotePricingInitials").ToString();
            if (gridView1.GetRowCellValue(r, "CustomerQuoteInitials") != null) _customerQuoteInitials = gridView1.GetRowCellValue(r, "CustomerQuoteInitials").ToString();
            if (gridView1.GetRowCellValue(r, "ModelYear") != null) _modelYear = gridView1.GetRowCellValue(r, "ModelYear").ToString();
            if (gridView1.GetRowCellValue(r, "PackageNumber") != null) _packageNumber = gridView1.GetRowCellValue(r, "PackageNumber").ToString();
            if (gridView1.GetRowCellValue(r, "QuoteReason") != null) _quoteReason = gridView1.GetRowCellValue(r, "QuoteReason").ToString();
            if (gridView1.GetRowCellValue(r, "ProductLine") != null) _productLine= gridView1.GetRowCellValue(r, "ProductLine").ToString();
            if (gridView1.GetRowCellValue(r, "PrintFilePath") != null) _printFilePath = gridView1.GetRowCellValue(r, "PrintFilePath").ToString();
            if (gridView1.GetRowCellValue(r, "CustomerQuoteFilePath") != null) _customerQuoteFilePath = gridView1.GetRowCellValue(r, "CustomerQuoteFilePath").ToString();
            if (gridView1.GetRowCellValue(r, "EmpireMarketSegment") != null) _marketSegment = gridView1.GetRowCellValue(r, "EmpireMarketSegment").ToString();
            if (gridView1.GetRowCellValue(r, "EmpireMarketSubsegment") != null) _marketSubsegment = gridView1.GetRowCellValue(r, "EmpireMarketSubsegment").ToString();
            if (gridView1.GetRowCellValue(r, "MinimumOrderQuantity") != null) _minimumOrderQuantity = gridView1.GetRowCellValue(r, "MinimumOrderQuantity").ToString();
            if (gridView1.GetRowCellValue(r, "Awarded") != null) _awarded = gridView1.GetRowCellValue(r, "Awarded").ToString();
            if (gridView1.GetRowCellValue(r, "AwardedDate") != null) _awardedDate = gridView1.GetRowCellValue(r, "AwardedDate").ToString();
            if (gridView1.GetRowCellValue(r, "StraightMaterialCost") != null) _straightMaterialCost = gridView1.GetRowCellValue(r, "StraightMaterialCost").ToString();
            if (gridView1.GetRowCellValue(r, "StdHours") != null) _stdHours = gridView1.GetRowCellValue(r, "StdHours").ToString();
            if (gridView1.GetRowCellValue(r, "Tooling") != null) _tooling = gridView1.GetRowCellValue(r, "Tooling").ToString();
            if (gridView1.GetRowCellValue(r, "QuotePrice") != null) _quotePrice = gridView1.GetRowCellValue(r, "QuotePrice").ToString();
            if (gridView1.GetRowCellValue(r, "PrototypePrice") != null) _prototypePrice = gridView1.GetRowCellValue(r, "PrototypePrice").ToString();

            int? rowID = (int)gridView1.GetRowCellValue(r, "RowID");

            showQuoteForm(sop, eop, rowID);
        }

        private void showQuoteForm(DateTime? sop, DateTime? eop, int? rowID)
        {
            QuoteLogGrid.Forms.formChooseQuoteType chooseQuote = new QuoteLogGrid.Forms.formChooseQuoteType();
            if (chooseQuote.ShowDialog() == DialogResult.OK)
            {
                //qmc = new QuoteMaintenanceController(_quoteNumber, sop, eop, rowID, chooseQuote.QuoteType);

                formQuoteMaintenance quoteMaintenance = new formQuoteMaintenance(_quoteNumber, sop, eop, rowID, chooseQuote.QuoteType, _customer,
                    _customerRfqNumber, _customerPartNumber, _eeiPartNumber, _notes, _oem, _applicationCode, _applicationName, _functionName,
                    _eau, _program, _nameplate, _programManagerInitials, _engineeringInitials, _salesInitials, _engineeringMaterialsInitials,
                    _quoteReviewInitials, _quotePricingInitials, _customerQuoteInitials, _modelYear, _packageNumber, _quoteReason,
                    _productLine, _printFilePath, _customerQuoteFilePath, _marketSegment, _marketSubsegment, _minimumOrderQuantity,
                    _awarded, _awardedDate, _straightMaterialCost, _stdHours, _tooling, _quotePrice, _prototypePrice);

                if (quoteMaintenance.ShowDialog() == DialogResult.OK)
                {
                    if (quoteMaintenance.IsSaved)
                    {
                        // Show Lighting Study form
                        var lighting = new formLightingData();
                        lighting.QuoteNumber = _quoteNumber;
                        lighting.ShowDialog();
                    }
                    if (quoteMaintenance.IsSaved || quoteMaintenance.PrintSaved)
                    {
                        // Refresh grid
                        if (chooseQuote.QuoteType == QuoteTypes.ModifyExisting)
                        {
                            ReloadSingleQuoteLogEntity();
                        }
                        else
                        {
                            ReloadAllQuoteLogEntities();
                        }
                    }
                }


                //QuoteLogGrid.Forms.formQuoteMaintenance form = new QuoteLogGrid.Forms.formQuoteMaintenance(quoteNumber, sop, eop, rowID, chooseQuote.QuoteType);
                //if (form.IsDisposed) return;
                //if (form.ShowDialog() == DialogResult.OK)
                //{
                //    //if(form._IsSavedOnce) RefreshGrid();
                //}
            }
        }

        #endregion


        #region View Quote Docucuments

        private void quotePrintItemButtonEdit_Click(object sender, EventArgs e)
        {
            //int r = gridView1.GetSelectedRows()[0];

            //if (gridView1.GetRowCellValue(r, "PrintFilePath") != null)
            //{
            //    ViewPrint(gridView1.GetRowCellValue(r, "PrintFilePath").ToString());
            //}

            int r = gridView1.GetSelectedRows()[0];
            if (gridView1.GetRowCellValue(r, "PrintFilePath") != null) GetQuotePrint();
        }

        private void customerQuoteItemButtonEdit_Click(object sender, EventArgs e)
        {
            //int r = gridView1.GetSelectedRows()[0];

            //if (gridView1.GetRowCellValue(r, "CustomerQuoteFilePath") != null)
            //{
            //    ViewPrint(gridView1.GetRowCellValue(r, "CustomerQuoteFilePath").ToString());
            //}

            int r = gridView1.GetSelectedRows()[0];
            if (gridView1.GetRowCellValue(r, "CustomerQuoteFilePath") != null) GetCustomerQuote();
        }

        private void ViewPrint(string filePath)
        {
            try
            {
                System.Diagnostics.Process.Start(filePath);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message + ".");
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
                int r = gridView1.GetSelectedRows()[0];
                string quoteNumber = gridView1.GetRowCellValue(r, "QuoteNumber").ToString();

                var collection = _context.usp_QT_FileManagement_Get(quoteNumber, attachmentCategory, tranDT, result);
                var item = collection.First();
                fileName = item.FileName;
                fileContents = item.FileContents;

                //fileName = fileName.Remove(fileName.Length - 4);
                //filePathQuotePrint = path + fileName + "_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf";

                string filePathQuotePrint = path + fileName;

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
                int r = gridView1.GetSelectedRows()[0];
                string quoteNumber = gridView1.GetRowCellValue(r, "QuoteNumber").ToString();

                var collection = _context.usp_QT_FileManagement_Get(quoteNumber, attachmentCategory, tranDT, result);
                var item = collection.First();
                fileName = item.FileName;
                fileContents = item.FileContents;

                //fileName = fileName.Remove(fileName.Length - 4);
                //filePathQuotePrint = path + fileName + "_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf";

                string filePathCustomerQuote = path + fileName;

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

        #endregion


        #region Other Methods

        private void ReloadAllQuoteLogEntities()
        {
            Cursor.Current = Cursors.WaitCursor;

            gridControl.FocusedView.CloseEditor();
            _context.QuoteLog.Load();

            Cursor.Current = Cursors.Default;
        }

        private void ReloadSingleQuoteLogEntity()
        {
            Cursor.Current = Cursors.WaitCursor;

            gridControl.FocusedView.CloseEditor();

            //  Get the specific entity that was modified
            foreach (var quote in _context.QuoteLog.Where(q => q.QuoteNumber == _quoteNumber))
            {
                // Reload the entity from the database
                _context.Entry(quote).Reload();
            }

            Cursor.Current = Cursors.Default;

            //gridControl.FocusedView.CloseEditor();
            //System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;

          
            ////_context.QuoteLog.Load();
            ////_context.QuoteLog.Local.ToBindingList();

            //var x = (from u in _context.QuoteLog
            //         //where u.QuoteNumber.StartsWith("52")
            //         select u).ToList();

            //gridControl.DataSource = null;
            //gridControl.DataSource = _context.QuoteLog.Local.ToBindingList();

            //BindLookupColumns();


            //// Modified quote
            ////  Create a list of the Entities (rows) in the Entity Set (table)
            //foreach (var quote in _context.QuoteLog.Where(q => q.QuoteNumber == "526-07"))
            //{
            //    // Reload the entity from the database
            //    _context.Entry(quote).Reload();
            //}

            // New quote
            //_context.QuoteLog.Load();


            //System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        #endregion



    }
}
