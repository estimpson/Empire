using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using FASTT.Controls;
using FASTT.Model;
using FASTT.DataModels;

namespace FASTT.Controllers
{
    public class ReportsController
    {
        #region Class Objects

        private MONITOREntities _context;
        private readonly CustomMessageBox _messageBox;

        private ReportOpenQuotesDataModel _openQuotesDataModel;
        public readonly List<ReportOpenQuotesDataModel> ListOpenQuotes = new List<ReportOpenQuotesDataModel>();

        private ReportNewQuotesDataModel _newQuotesDataModel;
        public readonly List<ReportNewQuotesDataModel> ListNewQuotes = new List<ReportNewQuotesDataModel>();

        #endregion


        #region Constructor

        public ReportsController()
        {
            _context = new MONITOREntities();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Methods

        public void GetOpenQuotes()
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            ListOpenQuotes.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_OpenQuotes(td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _openQuotesDataModel = new ReportOpenQuotesDataModel
                        {
                            QuoteNumber = item.QuoteNumber,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            Customer = item.Customer,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            EeiPartNumber = item.EEIPartNumber,
                            TotalQuotedSales = item.TotalQuotedSales
                        };
                        ListOpenQuotes.Add(_openQuotesDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return open quote data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetNewQuotes()
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            ListNewQuotes.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_NewQuotes(td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _newQuotesDataModel = new ReportNewQuotesDataModel
                        {
                            QuoteNumber = item.QuoteNumber,
                            QuoteStatus = item.QuoteStatus,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            Customer = item.Customer,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            EeiPartNumber = item.EEIPartNumber,
                            TotalQuotedSales = item.TotalQuotedSales
                        };
                        ListNewQuotes.Add(_newQuotesDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return new quote data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


    }
}
