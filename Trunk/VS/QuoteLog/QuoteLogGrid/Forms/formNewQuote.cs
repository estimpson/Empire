using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Objects;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing.Printing;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using QuoteLogGrid.Interfaces;
using System.Data.Objects;
using System.Data.Entity;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid.Views.Base;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraEditors;
using System.IO;

namespace QuoteLogGrid
{
    public partial class formNewQuote : Form
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        public string QuoteNumber { get; set; }

        private string CustomerRFQNumber, Customer, CustomerPartNumber, EEIPartNumber, Requote, Notes,
            ApplicationName, Program, Nameplate, ModelYear, SalesInitials, ProgramManagerInitials, ProductEngineerInitials, 
            CustomerQuoteInitials;
        private int? ParentQuoteID;
        private Decimal? EAU, QuotePrice, StraightMaterialCost;
        private DateTime? ReceiptDate, RequestedDueDate, EEIPromisedDueDate;

        public formNewQuote()
        {
            InitializeComponent();

            lblSaved.Visible = false;
            gridControl1.Focus();
        }

        public void ShowLayoutGridDataForCopy(string quoteNumber) // Header grid
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.SalesInitials.Load();
                Context.Requotes.Load();
                Context.QuoteLog.Where(o => o.QuoteNumber == quoteNumber).Load();

                // Bind lookup columns
                salesInitialsItemGridLookUpEdit.DataSource = null;
                salesInitialsItemGridLookUpEdit.DataSource = Context.SalesInitials.Local.ToBindingList();

                requoteItemGridLookUpEdit.DataSource = null;
                requoteItemGridLookUpEdit.DataSource = Context.Requotes.Local.ToBindingList();

                // Bind grid
                gridControl1.DataSource = null;
                gridControl1.DataSource = Context.QuoteLog.Local.ToBindingList();

                // Modify grid fields
                layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;

                layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
                layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
                layoutView1.SetRowCellValue(0, "Requote", "Y");
                layoutView1.SetRowCellValue(0, "Price", "");

                // Get a new quote number and update the grid
                //GetNewQuoteNumber();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        public void ShowLayoutGridDataForNew(string quoteNumber) // Header grid
        {
            // Query the database and copy records to local dbset
            Context.SalesInitials.Load();
            Context.Requotes.Load();
            Context.QuoteLog.Where(o => o.QuoteNumber == quoteNumber).Load();
            //Context.QuoteLog.Select(q=>new {QuoteNumber}).Where(o => o.QuoteNumber == quoteNumber).Load();

            // Bind lookup columns
            salesInitialsItemGridLookUpEdit.DataSource = null;
            salesInitialsItemGridLookUpEdit.DataSource = Context.SalesInitials.Local.ToBindingList();

            requoteItemGridLookUpEdit.DataSource = null;
            requoteItemGridLookUpEdit.DataSource = Context.Requotes.Local.ToBindingList();

            // Bind grid
            gridControl1.DataSource = null;
            gridControl1.DataSource = Context.QuoteLog.Local.ToBindingList();

            // Modify grid fields
            layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;

            layoutView1.SetRowCellValue(0, "ReceiptDate", DateTime.Now.ToShortDateString());
            layoutView1.SetRowCellValue(0, "EEIPromisedDueDate", DateTime.Now.AddDays(14).ToShortDateString());
            layoutView1.SetRowCellValue(0, "Requote", "Y");
            layoutView1.SetRowCellValue(0, "Price", "");
            layoutView1.SetRowCellValue(0, "EEIPartNumber", "");
            layoutView1.SetRowCellValue(0, "Customer", "");
            layoutView1.SetRowCellValue(0, "CustomerPartNumber", "");
            layoutView1.SetRowCellValue(0, "CustomerRFQNumber", "");
            layoutView1.SetRowCellValue(0, "EAU", "");
            layoutView1.SetRowCellValue(0, "ApplicationCode", "");
            layoutView1.SetRowCellValue(0, "ProgramManagerInitials", "");
            layoutView1.SetRowCellValue(0, "CustomerQuoteInitials", ""); // End User
            layoutView1.SetRowCellValue(0, "EngineeringInitials", "");
            layoutView1.SetRowCellValue(0, "SalesInitials", "");
            layoutView1.SetRowCellValue(0, "ModelYear", "");
            layoutView1.SetRowCellValue(0, "Program", "");
            layoutView1.SetRowCellValue(0, "Nameplate", "");
            layoutView1.SetRowCellValue(0, "StraightMaterialCost", "");
            layoutView1.SetRowCellValue(0, "Notes", "");
            layoutView1.SetRowCellValue(0, "Target", "");

            GetNewQuoteNumber();
        }

        private void GetNewQuoteNumber()
        {
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));

            try
            {
                Context.usp_QT_GetNewQuote(NewQuoteNumber);    
                layoutView1.SetRowCellValue(0, "QuoteNumber", NewQuoteNumber.Value.ToString());
                //layoutView1.SetRowCellValue(0, layoutView1.Columns["QuoteNumber"], NewQuoteNumber.Value.ToString());
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                    //MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
                    MessageBox.Show("Error occured.  Failed to return a new quote number.");
            }
        }

        public void ShowLayoutGridDataForBomModification(string quoteNumber, int rowID) // Header grid
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.SalesInitials.Load();
                Context.Requotes.Load();
                Context.QuoteLog.Where(o => o.QuoteNumber == quoteNumber).Load();

                // Bind lookup columns
                salesInitialsItemGridLookUpEdit.DataSource = null;
                salesInitialsItemGridLookUpEdit.DataSource = Context.SalesInitials.Local.ToBindingList();

                requoteItemGridLookUpEdit.DataSource = null;
                requoteItemGridLookUpEdit.DataSource = Context.Requotes.Local.ToBindingList();

                // Bind grid
                gridControl1.DataSource = null;
                gridControl1.DataSource = Context.QuoteLog.Local.ToBindingList();

                // Modify fields
                layoutView1.Columns["QuoteNumber"].OptionsColumn.ReadOnly = true;

                layoutView1.SetRowCellValue(0, "ParentQuoteID", rowID);
                layoutView1.SetRowCellValue(0, "Notes", "");

                // Get a new quote number and update the grid
                GetNewBomModificationQuoteNumber(quoteNumber);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        private void GetNewBomModificationQuoteNumber(string quoteNumber)
        {
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));

            try
            {
                Context.usp_QT_GetBOMModificationQuoteNumber(quoteNumber, NewQuoteNumber);
                layoutView1.SetRowCellValue(0, "QuoteNumber", NewQuoteNumber.Value.ToString());
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                    //MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
                    MessageBox.Show("Error occured.  Failed to return a new quote number.");
            }
        }

        public void ShowLayoutGridDataForPriceChange(string quoteNumber, int rowID) // Header grid
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.SalesInitials.Load();
                Context.Requotes.Load();
                Context.QuoteLog.Where(o => o.QuoteNumber == quoteNumber).Load();

                // Bind lookup columns
                salesInitialsItemGridLookUpEdit.DataSource = null;
                salesInitialsItemGridLookUpEdit.DataSource = Context.SalesInitials.Local.ToBindingList();

                requoteItemGridLookUpEdit.DataSource = null;
                requoteItemGridLookUpEdit.DataSource = Context.Requotes.Local.ToBindingList();

                // Bind grid
                gridControl1.DataSource = null;
                gridControl1.DataSource = Context.QuoteLog.Local.ToBindingList();

                // Modify fields
                layoutView1.SetRowCellValue(0, "ParentQuoteID", rowID);
                layoutView1.SetRowCellValue(0, "Notes", "");

                // Get a new quote number and update the grid
                GetNewPriceChangeQuoteNumber(quoteNumber);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        private void GetNewPriceChangeQuoteNumber(string quoteNumber)
        {
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));

            try
            {
                Context.usp_QT_GetPriceChangeModificationQuoteNumber(quoteNumber, NewQuoteNumber);
                layoutView1.SetRowCellValue(0, "QuoteNumber", NewQuoteNumber.Value.ToString());
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                    //MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
                    MessageBox.Show("Error occured.  Failed to return a new quote number.");
            }
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnPrint_Click(object sender, EventArgs e)
        {
            ShowPrintPreviewDialog();
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            if (SaveQuote() == 1) lblSaved.Visible = true; 
        }

        private void ShowPrintPreviewDialog()
        {
            PrintPreviewDialog PrintPreviewDialog1 = new PrintPreviewDialog();
            PrintDocument doc = new PrintDocument();

            //Set the size, location, and name. 
            PrintPreviewDialog1.ClientSize = new System.Drawing.Size(400, 300);
            PrintPreviewDialog1.Location = new System.Drawing.Point(29, 29);
            PrintPreviewDialog1.Name = "PrintPreviewDialog1";

            // Associate the event-handling method with the document's PrintPage event. 
            doc.PrintPage += new PrintPageEventHandler(document_PrintPage);

            // Set the minimum size the dialog can be resized to. 
            PrintPreviewDialog1.MinimumSize = new System.Drawing.Size(375, 250);

            // Set the UseAntiAlias property to true, which will allow the  
            // operating system to smooth fonts. 
            PrintPreviewDialog1.UseAntiAlias = true;

            doc.DocumentName = this.Tag.ToString();

            // Set the PrintPreviewDialog.Document property to the PrintDocument object selected by the user.
            PrintPreviewDialog1.Document = doc;

            // Call the ShowDialog method. This will trigger the document's PrintPage event.
            PrintPreviewDialog1.ShowDialog();


            // Print
            ShowPrintDialog(doc);
        }

        private void ShowPrintDialog(PrintDocument doc)
        {
            PrintDialog pd = new PrintDialog();
            DialogResult result = pd.ShowDialog();
            if (result == DialogResult.OK)
            {
                doc.Print();
            }
        }

        private void document_PrintPage(object sender, PrintPageEventArgs e)
        {
            // Code to render the page here. 
            // This code will be called when the PrintPreviewDialog.ShowDialog  
            // method is called. 

            int x = SystemInformation.WorkingArea.X;
            int y = SystemInformation.WorkingArea.Y;
            int width = this.Width;
            int height = this.Height;

            Rectangle bounds = new Rectangle(x, y, width, height);

            Bitmap img = new Bitmap(width, height);

            this.DrawToBitmap(img, bounds);
            Point p = new Point(0, 0);
            e.Graphics.DrawImage(img, p);
        }

        private int SaveQuote()
        {
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32));
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            // Create new quote in the system
            GetGridValues();
            try
            {
                //Context.usp_QT_InsertQuoteLog(QuoteNumber, ParentQuoteID, CustomerRFQNumber, ReceiptDate, Customer, RequestedDueDate,
                //    EEIPromisedDueDate, CustomerPartNumber, EEIPartNumber, Requote, Notes, EAU, ApplicationName, Program,
                //    Nameplate, ModelYear, SalesInitials, ProgramManagerInitials, ProductEngineerInitials, CustomerQuoteInitials, 
                //    StraightMaterialCost, QuotePrice, tranDt, result);
                
                return 1;
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
                return 0;
            }
        }

        private void GetGridValues()
        {
            QuoteNumber = layoutView1.GetRowCellValue(0, "QuoteNumber").ToString();

            CustomerRFQNumber = layoutView1.GetRowCellValue(0, "CustomerRFQNumber") != null
                ? layoutView1.GetRowCellValue(0, "CustomerRFQNumber").ToString()
                : null;

            Customer = layoutView1.GetRowCellValue(0, "Customer") != null
                ? layoutView1.GetRowCellValue(0, "Customer").ToString()
                : null;

            CustomerPartNumber = layoutView1.GetRowCellValue(0, "CustomerPartNumber") != null
                ? layoutView1.GetRowCellValue(0, "CustomerPartNumber").ToString()
                : null;

            EEIPartNumber = layoutView1.GetRowCellValue(0, "EEIPartNumber") != null
                ? layoutView1.GetRowCellValue(0, "EEIPartNumber").ToString()
                : null;

            Requote = layoutView1.GetRowCellValue(0, "Requote") != null
                ? layoutView1.GetRowCellValue(0, "Requote").ToString()
                : null;

            Notes = layoutView1.GetRowCellValue(0, "Notes") != null
                ? layoutView1.GetRowCellValue(0, "Notes").ToString()
                : null;

            ApplicationName = layoutView1.GetRowCellValue(0, "ApplicationName") != null
                ? layoutView1.GetRowCellValue(0, "ApplicationName").ToString()
                : null;

            Program = layoutView1.GetRowCellValue(0, "Program") != null
                ? layoutView1.GetRowCellValue(0, "Program").ToString()
                : null;

            Nameplate = layoutView1.GetRowCellValue(0, "Nameplate") != null
                ? layoutView1.GetRowCellValue(0, "Nameplate").ToString()
                : null;

            ModelYear = layoutView1.GetRowCellValue(0, "ModelYear") != null
                ? layoutView1.GetRowCellValue(0, "ModelYear").ToString()
                : null;

            SalesInitials = layoutView1.GetRowCellValue(0, "SalesInitials") != null
                ? layoutView1.GetRowCellValue(0, "SalesInitials").ToString()
                : null;

            ProgramManagerInitials = layoutView1.GetRowCellValue(0, "ProgramManagerInitials") != null
                ? layoutView1.GetRowCellValue(0, "ProgramManagerInitials").ToString()
                : null;

            ProductEngineerInitials = layoutView1.GetRowCellValue(0, "ProductEngineerInitials") != null
                ? layoutView1.GetRowCellValue(0, "ProductEngineerInitials").ToString()
                : null;

            CustomerQuoteInitials = layoutView1.GetRowCellValue(0, "CustomerQuoteInitials") != null
                ? layoutView1.GetRowCellValue(0, "CustomerQuoteInitials").ToString()
                : null;

            ParentQuoteID = (int?)layoutView1.GetRowCellValue(0, "ParentQuoteID");

            EAU = (Decimal?)layoutView1.GetRowCellValue(0, "EAU");
            QuotePrice = (Decimal?)layoutView1.GetRowCellValue(0, "QuotePrice");
            StraightMaterialCost = (Decimal?)layoutView1.GetRowCellValue(0, "StraightMaterialCost");

            ReceiptDate = (DateTime?)layoutView1.GetRowCellValue(0, "ReceiptDate");
            RequestedDueDate = (DateTime?)layoutView1.GetRowCellValue(0, "RequestedDueDate");
            EEIPromisedDueDate = (DateTime?)layoutView1.GetRowCellValue(0, "EEIPromisedDueDate");
        }

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


    }
}
