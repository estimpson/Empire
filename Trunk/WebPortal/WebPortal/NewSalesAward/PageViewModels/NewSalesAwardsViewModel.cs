using System;
using System.Collections.Generic;
using System.Linq;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.DataModels;
using System.Data.Entity.Core.Objects;
using System.Web;

namespace WebPortal.NewSalesAward.PageViewModels
{
    [Serializable]
    public class NewSalesAwardsViewModel
    {
        public string OperatorCode => HttpContext.Current.Session["OpCode"].ToString();
        public String Error { get; private set; }

        public List<String> QuoteNumberList = new List<String>();
        #region Constructor

        public NewSalesAwardsViewModel()
        {
        }

        #endregion



        #region Quote Methods


        public void GetQuoteLog()
        {
            Error = "";
            QuoteNumberList.Clear();
            QuoteNumberList.Add("");

            try
            {
                using (var context = new FxPLMEntities())
                {
                    var query = from ql in context.QuoteLogs
                                select ql;

                    foreach (var result in query) QuoteNumberList.Add(result.QuoteNumber);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public List<usp_GetAwardedQuotes_Result> GetAwardedQuotes()
        {
            List<usp_GetAwardedQuotes_Result> list;
            using (var context = new FxPLMEntities())
            {
                list = context.usp_GetAwardedQuotes().ToList();
            }
            return list;
        }

        public usp_GetAwardedQuotes_Result GetAwardedQuote(string quote)
        {
            using (var context = new FxPLMEntities())
            {
                return context.usp_GetAwardedQuote(quote).First();
            }
        }

        public List<usp_GetCustomerShipTos_Result> GetCustomerShipTos(string basePart)
        {
            var list = new List<usp_GetCustomerShipTos_Result>();
            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    list = context.usp_GetCustomerShipTos(basePart).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return list;
        }

        public void AwardedQuoteChangeQuoteNumber(string oldQuote, string newQuote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_AwardedQuote_ChangeQuoteNumber(OperatorCode, oldQuote, newQuote, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SetQuoteDetails(string quoteNumber, DateTime? awardDate, string formOfCommitment, string quoteReason,
            string replacingBasePart, string salesperson, string programManager, decimal? awardedEau, decimal? awardedPrice, string comments)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetQuoteDetails(OperatorCode, quoteNumber, awardDate, formOfCommitment, quoteReason,
                        replacingBasePart, salesperson, programManager, awardedEau, awardedPrice, comments, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Customer PO Methods

        public void SetProductionPO(string quote, DateTime? purchaseOrderDt, string po, string altCustCommitment, decimal? sellingPrice, DateTime? poSop,
            DateTime? poEop, string comments)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetProductionPO(OperatorCode, quote, purchaseOrderDt, po, altCustCommitment, sellingPrice, poSop, poEop, comments, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Hard Tooling Methods

        public void SetHardTooling(string quote, decimal? amount, string trigger, string description, string capexid, string customerPO)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetHardTooling(OperatorCode, quote, amount, trigger, description, capexid, customerPO, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Amortization Methods

        public void SetToolingAmortization(string quote, decimal? amount, decimal? quantity, string description, string capexid)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetToolingAmortization(OperatorCode, quote, amount, quantity, description, capexid, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Assembly Tester Tooling Methods

        public void SetAssemblyTesterTooling(string quote, decimal? amount, string trigger, string description, string capexid)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetAssemblyTesterTooling(OperatorCode, quote, amount, trigger, description, capexid, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Base Part Attributes Methods

        public void SetBasePartAttributes(string operatorCode, string quote, string basePartFamilyList, string productLine, string marketSegment,
            string marketSubsegment, string application, DateTime? sop, DateTime? eop, string eopNote, string comments)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetBasePartAttributes(operatorCode, quote, basePartFamilyList, productLine, marketSegment,
                        marketSubsegment, application, sop, eop, eopNote, comments, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Logistics Methods

        public void SetLogistics(string quote, string empireFacility, string freightTerms, string customerShipTo)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetLogistics(quote, empireFacility, freightTerms, customerShipTo, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}