using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuoteLogData.Models;
using QuoteLogGrid.SupportClasses;

namespace QuoteLogGrid.Controllers
{
    public class FileController
    {
        private readonly QuoteLogContext _context;

        private string _quoteNumber { get; set; }

        ObjectParameter result = new ObjectParameter("Result", typeof(Int32));
        ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));


        public FileController(string quoteNumber)
        {
            _quoteNumber = quoteNumber;
            _context = new QuoteLogContext();

            _context.QuoteLog.Where(q => q.QuoteNumber == _quoteNumber).Load();
        }


        #region Prints

        public IEnumerable<string> GetQuotePrint()
        {
            return _context.QuoteLog.Where(o => o.QuoteNumber == _quoteNumber).Select(o => o.PrintFilePath);
        }
        public IEnumerable<string> GetPrintNo()
        {
            return _context.QuoteLog.Where(o => o.QuoteNumber == _quoteNumber).Select(o => o.PrintNo);
        }
        public IEnumerable<DateTime?> GetPrintDate()
        {
            return _context.QuoteLog.Where(o => o.QuoteNumber == _quoteNumber).Select(o => o.PrintDate);
        }

        public void SavePrint(string printFilePath, string printNo, DateTime printDate, out string error)
        {
            error = "";
            try
            {
                _context.usp_QT_InsertQuotePrints(_quoteNumber, printFilePath, printNo, printDate, tranDt, result);
            }
            catch (Exception ex)
            {
                error = ("Error occured when attempting to save Print to database.  Print was not saved.");
            }    
        }

        public void DeletePrint(out string error)
        {
            error = "";
            try
            {
                _context.usp_QT_DeleteQuotePrints(_quoteNumber, tranDt, result);
            }
            catch (Exception ex)
            {
                error = "Error occured when attempting to delete Print from database.  Print was not deleted.";
            }
        }

        #endregion


        #region Customer Quote Files

        public IEnumerable<string> GetCustomerQuote()
        {
            return _context.QuoteLog.Where(o => o.QuoteNumber == _quoteNumber).Select(o => o.CustomerQuoteFilePath);
        }

        public void SaveCustomerQuote(string customerQuoteFilePath, out string error)
        {
            error = "";
            try
            {
                _context.usp_QT_InsertCustomerQuoteDoc(_quoteNumber, customerQuoteFilePath, tranDt, result);
            }
            catch (Exception ex)
            {
                error = "Error occured when attempting to save Customer Quote to database.  Customer Quote was not saved.";
            }
        }

        public void DeleteCustomerQuote(out string error)
        {
            error = "";
            try
            {
                _context.usp_QT_DeleteCustomerQuoteDoc(_quoteNumber, tranDt, result);
            }
            catch (Exception ex)
            {
                error = "Error occured when attempting to delete Customer Quote from database.  Customer Quote was not deleted.";
            }
        }

        #endregion




    }
}
