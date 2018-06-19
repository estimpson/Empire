using System;
using System.Collections.Generic;
using System.Linq;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.DataModels;
using System.Data.Entity.Core.Objects;

namespace WebPortal.NewSalesAward.PageViewModels
{
    [Serializable]
    public class NewSalesAwardsViewModel
    {
        public String OperatorCode { get; private set; }
        public String Error { get; private set; }


        #region Constructor

        public NewSalesAwardsViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["op"].ToString();
        }

        #endregion



        #region Quote Methods

        public List<usp_GetAwardedQuotes_Result> GetAwardedQuotes()
        {
            List<usp_GetAwardedQuotes_Result> list;
            using (var context = new FxPLMEntities())
            {
                list = context.usp_GetAwardedQuotes().ToList();
            }
            return list;
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

        #endregion


        #region Customer PO Methods

        //public List<usp_GetAwardedQuoteProductionPOs_Result> GetAwardedQuoteProductionPOs()
        //{
        //    List<usp_GetAwardedQuoteProductionPOs_Result> list;
        //    using (var context = new FxPLMEntities())
        //    {
        //        list = context.usp_GetAwardedQuoteProductionPOs().ToList();
        //    }
        //    return list;
        //}

        //public void UpdateAwardedQuoteProductionPOs(usp_GetAwardedQuoteProductionPOs_Result u)
        //{
        //    using (var context = new FxPLMEntities())
        //    {
        //        ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //        ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

        //        context.usp_SetProductionPO(u.QuoteNumber, u.PurchaseOrderDT, u.PONumber, u.AlternativeCustomerCommitment,
        //            u.SellingPrice, u.PurchaseOrderSOP, u.PurchaseOrderEOP, u.Comments, tranDT, result, 0, null);
        //    }
        //}

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
                    context.usp_SetProductionPO(quote, purchaseOrderDt, po, altCustCommitment, sellingPrice, poSop, poEop, comments, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Hard Tooling Methods

        public void SetHardTooling(string quote, decimal? amount, string trigger, string description, string capexid)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

            Error = "";
            try
            {
                using (var context = new FxPLMEntities())
                {
                    context.usp_SetHardTooling(quote, amount, trigger, description, capexid, tranDT, result, 0, debugMsg);
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
                    context.usp_SetToolingAmortization(quote, amount, quantity, description, capexid, tranDT, result, 0, debugMsg);
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
                    context.usp_SetAssemblyTesterTooling(quote, amount, trigger, description, capexid, tranDT, result, 0, debugMsg);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Base Part Attributes Methods

        public void SetBasePartAttributes(string quote, string basePartFamilyList, string productLine, string marketSegment,
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
                    context.usp_SetBasePartAttributes(OperatorCode, quote, basePartFamilyList, productLine, marketSegment,
                        marketSubsegment, application, sop, eop, eopNote, comments, tranDT, result, 0, debugMsg);
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