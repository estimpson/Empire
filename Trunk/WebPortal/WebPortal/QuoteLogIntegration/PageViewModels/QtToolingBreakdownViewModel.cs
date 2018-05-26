using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity.Core.Objects;
using WebPortal.QuoteLogIntegration.Models;


namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtToolingBreakdownViewModel
    {
        public String OperatorCode { get; set; }

        public String Error { get; private set; }


        #region Constructor

        public QtToolingBreakdownViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["op"].ToString();
        }

        #endregion


        #region Methods

        public List<usp_QL_QuoteTransfer_GetToolingBreakdown_Result> GetToolingBreakdown(string quote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            var toolingList = new List<usp_QL_QuoteTransfer_GetToolingBreakdown_Result>();
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    toolingList = context.usp_QL_QuoteTransfer_GetToolingBreakdown(quote, tranDT, result).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return toolingList;
        }

        public void ToolingBreakdownInsert(usp_QL_QuoteTransfer_GetToolingBreakdown_Result u)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            string quote = (System.Web.HttpContext.Current.Session["Quote"] != null)
                ? quote = System.Web.HttpContext.Current.Session["Quote"].ToString()
                : "";
      
            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                context.usp_QL_QuoteTransfer_ToolingBreakdown_Insert(OperatorCode, quote, u.Description, u.Quantity, u.Value, tranDT, result);
            }
        }

        public void ToolingBreakdownUpdate(usp_QL_QuoteTransfer_GetToolingBreakdown_Result u)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                context.usp_QL_QuoteTransfer_ToolingBreakdown_Update(OperatorCode, u.RowID, u.Description, u.Quantity, u.Value, tranDT, result);
            }
        }

        public void ToolingBreakdownDelete(usp_QL_QuoteTransfer_GetToolingBreakdown_Result u)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                context.usp_QL_QuoteTransfer_ToolingBreakdown_Delete(OperatorCode, u.RowID, tranDT, result);
            }
        }

        #endregion


    }
}