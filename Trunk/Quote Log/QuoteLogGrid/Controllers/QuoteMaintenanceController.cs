using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using DevExpress.Utils;
using QuoteLogData.Models;
using QuoteLogGrid.Forms;
using QuoteLogGrid.SupportClasses;

namespace QuoteLogGrid.Controllers
{   
    public class QuoteMaintenanceController
    {
        private readonly QuoteLogContext _context;

        private formQuoteMaintenance _theView;
        private DataLayerNewQuoteNumber _nqn;
        private LTAController _ltaController;
        private FileController _fileController;

        private string _quoteNumber;
        private QuoteTypes _quoteType;


        public QuoteMaintenanceController(string quoteNumber, QuoteTypes QuoteType, formQuoteMaintenance frmQuoteMaintenance)
        {
            string errorMessage;
            string errorMethod;

            _theView = frmQuoteMaintenance;
            _quoteNumber = quoteNumber;
            _quoteType = QuoteType;

            _context = new QuoteLogContext();
            _nqn = new DataLayerNewQuoteNumber();

            // Get quote header data, get a new quote number and reset the _quoteNumber variable if necessary
            GetQuoteHeaderData(out errorMessage, out errorMethod);
            if (errorMessage != "")
            {
                ShowError(errorMessage, errorMethod);
                return;
            }

            // Bind all the LookupEdit columns in the grid
            LoadLookupColumns();
            BindDataSources();

            // Quote LTA data
            if (_quoteType == QuoteTypes.ModifyExisting)
            {
                // Existing quote, so update LTA data for it
                _ltaController = new LTAController(_quoteNumber, false);
                _theView.LtaDataSource = _ltaController.GetLtaData(out errorMessage);
                if (errorMessage != "")
                {
                    ShowError(errorMessage, "GetLtaData()");
                    return;
                }
            }
            else
            {
                // New quote, so bypass LTA functions until the quote is saved
                _ltaController = new LTAController(_quoteNumber, true);
            }

            // Quote Print document and Customer Quote document
            _fileController = new FileController(_quoteNumber);
            if (_quoteType == QuoteTypes.ModifyExisting)
            {
                _theView.QuotePrintFile = _fileController.GetQuotePrint();
                _theView.QuotePrintNo = _fileController.GetPrintNo();
                _theView.QuotePrintDate = _fileController.GetPrintDate();
                _theView.CustomerQuoteFile = _fileController.GetCustomerQuote();   
            }
            else
            {
                _theView.ExistsQuotePrint = _theView.ExistsCustomerQuote = false;
            }
        }


        #region Header Grid

        private void GetQuoteHeaderData(out string errorMessage, out string errorMethod)
        {
            errorMessage = errorMethod = "";

            // If necessary, create a new quote number and add it to the Local collection of the DbSet
            if (_quoteType == QuoteTypes.New || _quoteType == QuoteTypes.Copy)
            {
                errorMethod = "GetNewQuoteNumber()";
                _quoteNumber = _nqn.GetNewQuoteNumber(out errorMessage);

                // Add new quote
                if (errorMessage == "") AddNewQuote(out errorMessage);
            }
            else if (_quoteType == QuoteTypes.BomMod)
            {
                errorMethod = "GetNewBomModificationQuoteNumber()";
                _quoteNumber = _nqn.GetNewBomModificationQuoteNumber(_quoteNumber, out errorMessage);

                // Add new quote
                if (errorMessage == "") AddNewQuote(out errorMessage);
            }
            else if (_quoteType == QuoteTypes.PriceChange)
            {
                errorMethod = "GetNewPriceChangeQuoteNumber()";
                _quoteNumber = _nqn.GetNewPriceChangeQuoteNumber(_quoteNumber, out errorMessage);

                // Add new quote
                if (errorMessage == "") AddNewQuote(out errorMessage);
            }

            // Set the quote number back in the form
            if (errorMessage == "") _theView.QuoteNumber = _quoteNumber;

            // Bind grid to the quote number (the new quote if one was created, otherwise, the existing quote)
            if (errorMessage == "")
            {
                errorMethod = "GetHeaderGridData()";
                _theView.HeaderGridDataSource = GetHeaderGridData(out errorMessage);
            } 
        }

        private void AddNewQuote(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                // Create a new entity
                QuoteEntry newQuote = new QuoteEntry   
                {
                    QuoteNumber = _quoteNumber,
                    Status = 0,
                    Type = 0,
                    // ModelYear = DateTime.Today.Year.ToString(),
                    Requote = "N",
                    RowCreateUser = "Andre",
                    RowModifiedUser = "Andre"
                };
                _context.QuoteLog.Add(newQuote);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to add the new quote to the database.";
            }
        }

        public BindingList<QuoteEntry> GetHeaderGridData(out string error)
        {
            error = "";
            try
            {
                _context.QuoteLog.Where(q => q.QuoteNumber == _quoteNumber).Load();
                return _context.QuoteLog.Local.ToBindingList();
            }
            catch (Exception ex)
            {
                error = "Failed to retrieve quote grid data.";
            }
            return null;
        }

        #endregion


        #region Header Grid Lookup Column

        public void LoadLookupColumns()
        {
            try
            {
                _context.Requotes.Load();
                _context.Customers.Load();
                _context.SalesInitials.Load();
                _context.ProgramManagerInitials.Load();
                _context.EngineeringInitials.Load();
                _context.EngineeringMaterialsInitials.Load();
                _context.QuoteReviewInitials.Load();
                _context.QuotePricingInitials.Load();
                _context.CustomerQuoteInitials.Load();
                _context.Functions.Load();
                _context.Applications.Load();
            }
            catch (Exception)
            {
                MessageBox.Show("Error occured while retrieving data for header grid dropdown lists.");
            }
        }

        private void BindDataSources()
        {
            _theView.RequotesBindingList = _context.Requotes.Local.ToBindingList();
            _theView.CustomersBindingList = _context.Customers.Local.ToBindingList();
            _theView.SalesInitialsBindingList = _context.SalesInitials.Local.ToBindingList();
            _theView.ProgramManagerInitialsBindingList = _context.ProgramManagerInitials.Local.ToBindingList();
            _theView.EngineeringInitialsBindingList = _context.EngineeringInitials.Local.ToBindingList();
            _theView.EngineeringMaterialsInitialsBindingList = _context.EngineeringMaterialsInitials.Local.ToBindingList();
            _theView.QuoteReviewInitialsBindingList = _context.QuoteReviewInitials.Local.ToBindingList();
            _theView.QuotePricingInitialsBindingList = _context.QuotePricingInitials.Local.ToBindingList();
            _theView.CustomerQuoteInitialsBindingList = _context.CustomerQuoteInitials.Local.ToBindingList();
            _theView.FunctionsBindingList = _context.Functions.Local.ToBindingList();
            _theView.ApplicationsBindingList = _context.Applications.Local.ToBindingList();
        }

        #endregion


        #region LTAs
  
        public void UpdateLtas()
        {
            string errorMessage;
            _ltaController.UpdateLtas(out errorMessage);
            if (errorMessage != "") ShowError(errorMessage, "UpdateLtas()");
        }

        public void GetLTAs()
        {
            string errorMessage;
            _theView.LtaDataSource = _ltaController.GetLtaData(out errorMessage);
            if (errorMessage != "") ShowError(errorMessage, "GetLtaData()");
        }

        public void SaveLTAs()
        {
            string errorMessage;
            _ltaController.SaveLtaData(out errorMessage);
            if (errorMessage != "") ShowError(errorMessage, "GetLtaData()");
        }

        #endregion


        #region Prints

        public int SavePrint(string printFilePath, string printNo, DateTime printDate)
        {
            string errorMessage;
            _fileController.SavePrint(printFilePath, printNo, printDate, out errorMessage);
            if (errorMessage != "")
            {
                ShowError(errorMessage, "SavePrint()");
                return 0;
            }
            return 1;
        }

        public int DeletePrint()
        {
            string errorMessage;
            _fileController.DeletePrint(out errorMessage);
            if (errorMessage != "")
            {
                ShowError(errorMessage, "DeletePrint()");
                return 0;
            }
            return 1;
        }

        #endregion


        #region Customer Quote Files

        public IEnumerable<string> GetCustomerQuote()
        {
            return _fileController.GetCustomerQuote();
        }

        public int SaveCustomerQuote(string customerQuoteFilePath)
        {
            string errorMessage;
            _fileController.SaveCustomerQuote(customerQuoteFilePath, out errorMessage);
            if (errorMessage != "")
            {
                ShowError(errorMessage, "SaveCustomerQuote()");
                return 0;
            }
            return 1;
        }

        public int DeleteCustomerQuote()
        {
            string errorMessage;
            _fileController.DeleteCustomerQuote(out errorMessage);
            if (errorMessage != "")
            {
                ShowError(errorMessage, "DeleteCustomerQuote()");
                return 0;
            }
            return 1;
        }

        #endregion


        #region Save DbContext

        public string SaveContext()
        {
            try
            {
                _context.SaveChanges();
                return "";
            }
            catch (Exception ex)
            {
                return "Failed to save quote.";
            }
        }

        #endregion


        #region Other Methods

        private void ShowError(string error, string method)
        {    
            MessageBox.Show(error, method);
        }

        #endregion


    }
}
