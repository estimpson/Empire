using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuoteLogData.Models;

namespace QuoteLogGrid.SupportClasses
{
    public class DataLayerNewQuoteNumber
    {
        private readonly QuoteLogContext _context;

        public DataLayerNewQuoteNumber()
        {
            _context = new QuoteLogContext();
        }

        public string GetNewQuoteNumber(out string errorMessage)
        {
            errorMessage = "";
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));
            try
            {
                _context.usp_QT_GetNewQuote(NewQuoteNumber);
                return NewQuoteNumber.Value.ToString();
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to create a new Quote Number.";
            }
            return "";
        }

        public string GetNewBomModificationQuoteNumber(string quoteNumber, out string errorMessage)
        {
            errorMessage = "";
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));
            try
            {
                _context.usp_QT_GetBOMModificationQuoteNumber(quoteNumber, NewQuoteNumber);
                return NewQuoteNumber.Value.ToString();
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to create a new Quote Number for BOM modification.";
            }
            return "";
        }

        public string GetNewPriceChangeQuoteNumber(string quoteNumber, out string errorMessage)
        {
            errorMessage = "";
            ObjectParameter NewQuoteNumber = new ObjectParameter("NewQuoteNumber", typeof(string));
            try
            {
                _context.usp_QT_GetPriceChangeModificationQuoteNumber(quoteNumber, NewQuoteNumber);
                if (NewQuoteNumber.Value.ToString().Length > 44) // Instead of a quote number, an error was returned
                {
                    errorMessage = "There's a more current price for that rev.";
                    return "";
                }
                return NewQuoteNumber.Value.ToString();
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to create a new Quote Number for price change.";
            }
            return "";
        }



    }
}
