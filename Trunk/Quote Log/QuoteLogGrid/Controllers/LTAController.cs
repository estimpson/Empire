using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using QuoteLogData.Models;
using QuoteLogGrid.SupportClasses;

namespace QuoteLogGrid.Controllers
{
    public class LTAController
    {
        private QuoteLogContext _ltaContext;

        public String YearOne { get; private set; }
        public String YearTwo { get; private set; }
        public String YearThree { get; private set; }
        public String YearFour { get; private set; }

        private string _quoteNumber { get; set; }

        public LTAController(string quoteNumber, bool isNewQuoteNumber)
        {
            _quoteNumber = quoteNumber;

            _ltaContext = new QuoteLogContext();

            //if (!isNewQuoteNumber)
            //{
            //    string errorMessage = "";
            //    UpdateLtas(out errorMessage);
            //    SaveLtaData(out errorMessage);
            //}
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

        public void UpdateLtas(string quoteNumber, decimal? year1, decimal? year2, decimal? year3, decimal? year4, out string errorMessage)
        {
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            errorMessage = "";
            try
            {
                _ltaContext.usp_QT_UpdateQuoteLTA_New2(quoteNumber, year1, year2, year3, year4, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to update LTAs for this quote.";
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

        public void SaveLtaData(string quoteNumber, out string errorMessage)
        {
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            errorMessage = "";
            try
            {
                _ltaContext.usp_QT_InsertQuoteLTA(quoteNumber, tranDt, result);
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to save LTAs for this quote.";
            }
        }

        public BindingList<QuoteLTA> GetLtaData(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                if (_ltaContext != null) _ltaContext.Dispose();

                _ltaContext = new QuoteLogContext();
                var bindingList = DbExtensions.ToBindingList<QuoteLTA>(new ObservableCollection<QuoteLTA>(_ltaContext.QuoteLTAs.Where(q => q.QuoteNumber == _quoteNumber)));

                return bindingList;
            }
            catch (Exception ex)
            {
                errorMessage = "Failed to retrieve LTA grid data.";
            }
            return null;
        }

        //public void GetLtaSummary(out string errorMessage)
        //{
        //    errorMessage = "";
        //    try
        //    {
        //        int counter = 0;
        //        if (_ltaContext != null) _ltaContext.Dispose();

        //        _ltaContext = new QuoteLogContext();
        //        //var x = _ltaContext.QuoteLTAs.Local.Where(q => q.QuoteNumber == _quoteNumber);
        //        var collection = _ltaContext.QuoteLTAs.Where(q => q.QuoteNumber == _quoteNumber);
        //        foreach(var item in collection)
        //        {
        //            counter++;
        //            string percentage = (item.Percentage == 0) ? "Flat Rate" : item.Percentage.ToString() + "%";

        //            switch (counter)
        //            {
        //                case 1:
        //                    YearOne = item.EffectiveDate + ": " + percentage;
        //                    break;
        //                case 2:
        //                    YearTwo = item.EffectiveDate + ": " + percentage;
        //                    break;
        //                case 3:
        //                    YearThree = item.EffectiveDate + ": " + percentage;
        //                    break;
        //                case 4:
        //                    YearFour = item.EffectiveDate + ": " + percentage;
        //                    break;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        errorMessage = "Failed to retrieve LTA summary.";
        //    }
        //}


    }
}
