using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuoteLogData.Models;

namespace QuoteLogGrid.SupportClasses
{
    public class DataLayerEmpireMarket
    {
        private readonly QuoteLogContext _context;


        #region Properties

        public string OperatorCode { get; set; }
        public string OperatorName { get; private set; }
        public string ErrorMessage { get; private set; }
        public string Segment { get; set; }
        public string Subsegment { get; set; }
        public string Note { get; set; }

        #endregion


        #region Constructor

        public DataLayerEmpireMarket()
        {
            _context = new QuoteLogContext();
        }

        #endregion


        #region Segment Methods

        public void EmpireMarketSegmentRequest()
        {
            ErrorMessage = "";

            //string output = "";
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter res = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_QT_EmpireMarketSegment_Request(OperatorCode, Segment, Note, tranDt, res);
                //var collection = _context.usp_QT_EmpireMarketSegment_Request(OperatorCode, Segment, Note, tranDt, res);
                //foreach (var item in collection) output = item.ToString(); // output can be a returned value or an error message

                //if ((int)res.Value == 0) // Object parameters are not populated until after the result set is read
                //{
                //    OperatorName = output;
                //    return;
                //}
                //ErrorMessage = output;
            }
            catch (Exception ex)
            {
                ErrorMessage = (ex.InnerException != null) ? "Request failed. " + ex.InnerException.Message : "Request failed. " + ex.Message;
            }
        }

        public void EmpireMarketSegmentRequestSendEmail()
        {
            //string output = "";
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter res = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_QT_EmpireMarketSegment_Request_SendEmail(Segment, tranDt, res);
                //var collection = _context.usp_QT_EmpireMarketSegment_Request_SendEmail(Segment, tranDt, res);
                //foreach (var item in collection) output = item.ToString();

                //ErrorMessage = output;
            }
            catch (Exception ex)
            {
                ErrorMessage = (ex.InnerException != null) ? "Request failed. " + ex.InnerException.Message : "Request failed. " + ex.Message;
            }
        }

        #endregion


        #region Subsegment Methods

        public void EmpireMarketSubsegmentRequest()
        {
            ErrorMessage = "";

            //string output = "";
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter res = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_QT_EmpireMarketSubsegment_Request(OperatorCode, Subsegment, Note, tranDt, res);
                //var collection = _context.usp_QT_EmpireMarketSubsegment_Request(OperatorCode, Subsegment, Note, tranDt, res);
                //foreach (var item in collection) output = item.ToString(); // output can be a returned value or an error message

                //if ((int)res.Value == 0) // Object parameters are not populated until after the result set is read
                //{
                //    OperatorName = output;
                //    return;
                //}
                //ErrorMessage = output;
            }
            catch (Exception ex)
            {
                ErrorMessage = (ex.InnerException != null) ? "Request failed. " + ex.InnerException.Message : "Request failed. " + ex.Message;
            }
        }

        public void EmpireMarketSubsegmentRequestSendEmail()
        {
            //string output = "";
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            ObjectParameter res = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_QT_EmpireMarketSubsegment_Request_SendEmail(Subsegment, tranDt, res);
                //var collection = _context.usp_QT_EmpireMarketSubsegment_Request_SendEmail(Subsegment, tranDt, res);
                //foreach (var item in collection) output = item.ToString();

                //ErrorMessage = output;
            }
            catch (Exception ex)
            {
                ErrorMessage = (ex.InnerException != null) ? "Request failed. " + ex.InnerException.Message : "Request failed. " + ex.Message;
            }
        }

        #endregion


    }
}
