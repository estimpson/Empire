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

        private string _quoteNumber;

       
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


        #region Grid Data Methods

        public void ShowData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbsets
                ////_context.QuoteLog.Load();
                //var x = (from u in _context.QuoteLog
                //         //where u.QuoteNumber.StartsWith("52")
                //         select u).ToList();


                // Load some quotes from the database into the DbContext
                //_context.QuoteLog.Where(q => q.QuoteNumber.StartsWith("52")).Load();
                _context.QuoteLog.Load();
      
                // Bind grid
                //gridControl.DataSource = null;
                gridControl.DataSource = _context.QuoteLog.Local.ToBindingList();

                

                // Modify grid fields
                gridView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["LTA"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["NameplateComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["OEMComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["ProgramComputed"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["TotalQuotedSales"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["PrintFilePath"].OptionsColumn.ReadOnly = true;
                gridView1.Columns["CustomerQuoteFilePath"].OptionsColumn.ReadOnly = true;

                gridView1.Columns["SOP"].DisplayFormat.FormatType = FormatType.DateTime;
                gridView1.Columns["SOP"].DisplayFormat.FormatString = "MMM yyyy";

                gridView1.Columns["EOP"].DisplayFormat.FormatType = FormatType.DateTime;
                gridView1.Columns["EOP"].DisplayFormat.FormatString = "MMM yyyy";


                BindLookupColumns();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
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
                _context.Functions.Load();

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
                functionsItemGridLookUpEdit.DataSource = _context.Functions.Local.ToBindingList();
            }
            catch (Exception)
            {
                MessageBox.Show("Error occured while retrieving data for header grid dropdown lists.");
            }
        }

        public void SaveData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;

            gridView1.PostEditor();
            gridView1.UpdateCurrentRow();

            _context.SaveChanges();

            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        #endregion


        #region SaveRestore Grid Layout

        public void SaveLayout()
        {
            SaveFileDialog sfd = new SaveFileDialog();
            sfd.DefaultExt = "xml";
            if (sfd.ShowDialog() == DialogResult.OK)
            {
                gridView1.SaveLayoutToXml(sfd.FileName);
            }
        }

        public void RestoreLayout()
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.DefaultExt = "xml";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    if (File.Exists(ofd.FileName))
                    {
                        gridView1.RestoreLayoutFromXml(ofd.FileName);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Layout could not be restored. Exception: " + ex.Message, "Error");
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
            
            int? rowID = (int)gridView1.GetRowCellValue(r, "RowID");

            showQuoteForm(sop, eop, rowID);
        }

        private void showQuoteForm(DateTime? sop, DateTime? eop, int? rowID)
        {
            QuoteLogGrid.Forms.formChooseQuoteType chooseQuote = new QuoteLogGrid.Forms.formChooseQuoteType();
            if (chooseQuote.ShowDialog() == DialogResult.OK)
            {
                //qmc = new QuoteMaintenanceController(_quoteNumber, sop, eop, rowID, chooseQuote.QuoteType);

                formQuoteMaintenance quoteMaintenance = new formQuoteMaintenance(_quoteNumber, sop, eop, rowID, chooseQuote.QuoteType);
                if (quoteMaintenance.ShowDialog() == DialogResult.OK)
                {
                    if (quoteMaintenance.IsSaved)
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
            int r = gridView1.GetSelectedRows()[0];

            if (gridView1.GetRowCellValue(r, "PrintFilePath") != null)
            {
                ViewPrint(gridView1.GetRowCellValue(r, "PrintFilePath").ToString());
            }
        }

        private void customerQuoteItemButtonEdit_Click(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];

            if (gridView1.GetRowCellValue(r, "CustomerQuoteFilePath") != null)
            {
                ViewPrint(gridView1.GetRowCellValue(r, "CustomerQuoteFilePath").ToString());
            }
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

        #endregion

        #region Other Methods

        private void btnSave_Click(object sender, EventArgs e)
        {
            SaveData();
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            //RefreshGrid();
        }

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
