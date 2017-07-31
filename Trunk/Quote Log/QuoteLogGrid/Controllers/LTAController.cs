using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using QuoteLogData.Models;

namespace QuoteLogGrid.Controllers
{
    public class LTAController
    {
        private QuoteLogContext _ltaContext;

        private string _quoteNumber { get; set; }

        public LTAController(string quoteNumber, bool isNewQuoteNumber)
        {
            _quoteNumber = quoteNumber;

            _ltaContext = new QuoteLogContext();

            if (!isNewQuoteNumber)
            {
                string errorMessage = "";
                UpdateLtas(out errorMessage);
                SaveLtaData(out errorMessage);
            }
        }


        public void UpdateLtas(out string errorMessage)
        {
            errorMessage = "";
            var result = new ObjectParameter("Result", typeof(Int32));
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                _ltaContext.usp_QT_UpdateQuoteLTA_New(_quoteNumber, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to update LTAs";
                //if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Warning");
            }
        }

        public void SaveLtaData(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                if (_ltaContext != null)
                {
                    _ltaContext.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to retrieve LTA grid data.";
            }
        }

        public BindingList<QuoteLTA> GetLtaData(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                if (_ltaContext != null)
                {
                    _ltaContext.Dispose();
                }

                _ltaContext = new QuoteLogContext();
                var bindingList = DbExtensions.ToBindingList<QuoteLTA>(new ObservableCollection<QuoteLTA>(_ltaContext .QuoteLTAs.Where(q => q.QuoteNumber == _quoteNumber)));
                
                return bindingList;
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to retrieve LTA grid data.";
            }
            return null;
        }


    }
}
