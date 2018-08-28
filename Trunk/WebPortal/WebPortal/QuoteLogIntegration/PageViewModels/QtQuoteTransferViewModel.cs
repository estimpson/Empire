using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.QuoteLogIntegration.Models;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtQuoteTransferViewModel
    {
        public string Error;
        public string OperatorCode => HttpContext.Current.Session["OpCode"].ToString();

        public List<usp_QL_GetQuoteTransfers_Result> GetQuoteTransfers()
        {
            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                return context.usp_QL_GetQuoteTransfers().ToList();
            }
        }

        public void NewQuoteTransfer(string quote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            Error = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QL_NewQuoteTransfer(OperatorCode, quote, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }
    }
}