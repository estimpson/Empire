using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.QuoteLogIntegration.Models;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtQuoteViewModel
    {
        #region Properties

        public String OperatorCode { get; set; }

        public String QuoteNumber { get; private set; }
        public String QtDate { get; private set; }
        public String Customer { get; private set; }
        public String EmpirePartNumber { get; private set; }
        public String CustomerPartNumber { get; private set; }
        public String Program { get; private set; }
        public String Application { get; private set; }
        public String FinancialEau { get; private set; }
        public String CapactiyEau { get; private set; }
        public String Salesman { get; private set; }
        public String QuoteEngineer { get; private set; }
        public String ProgramManager { get; private set; }
        public String SalePrice { get; private set; }
        public String LtaYear1 { get; private set; }
        public String LtaYear2 { get; private set; }
        public String LtaYear3 { get; private set; }
        public String LtaYear4 { get; private set; }
        public String PrototypePrice { get; private set; }
        public String MinimumOrderQuantity { get; private set; }
        public String Material { get; private set; }
        public String Labor { get; private set; }
        public String Tooling { get; private set; }
        public String Sop { get; private set;}
        public String Eop { get; private set; }
        public String QuoteTransferComplete { get; private set; }

        public String Error { get; private set; }

        #endregion


        #region Constructor

        public QtQuoteViewModel()
        {
        }

        #endregion


        #region Methods

        public void GetQuote(string quote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    var collection = context.usp_QL_QuoteTransfer_GetQuote(quote, tranDT, result);
                    foreach (var item in collection)
                    {
                        QuoteNumber = item.QuoteNumber;
                        QtDate = item.Date.ToString("yyyy-MM-dd");
                        Customer = item.Customer;
                        EmpirePartNumber = item.EmpirePartNumber;
                        CustomerPartNumber = item.CustomerPartNumber;
                        Program = item.Program;
                        Application = item.Application;
                        FinancialEau = (item.FinancialEau.HasValue) ? item.FinancialEau.Value.ToString("N0") : "";
                        CapactiyEau = (item.CapacityEau.HasValue) ? item.CapacityEau.Value.ToString("N0") : "";
                        Salesman = item.Salesman;
                        QuoteEngineer = item.QuoteEngineer;
                        ProgramManager = item.ProgramManager;
                        SalePrice = (item.SalesPrice.HasValue) ? item.SalesPrice.Value.ToString("C2") : "";
                        LtaYear1 = (item.LtaYear1 != 0) ? item.LtaYear1.Value.ToString("C2") : "";
                        LtaYear2 = (item.LtaYear2 != 0) ? item.LtaYear2.Value.ToString("C2") : "";
                        LtaYear3 = (item.LtaYear3 != 0) ? item.LtaYear3.Value.ToString("C2") : "";
                        LtaYear4 = (item.LtaYear4 != 0) ? item.LtaYear4.Value.ToString("C2") : "";
                        PrototypePrice = (item.PrototypePrice.HasValue) ? item.PrototypePrice.Value.ToString("N2") : "";
                        MinimumOrderQuantity = (item.MinimumOrderQuantity.HasValue) ? item.MinimumOrderQuantity.ToString() : "";
                        Material = (item.Material.HasValue) ? item.Material.Value.ToString("C2") : "";
                        Labor = (item.Labor.HasValue) ? item.Labor.Value.ToString("C2") : "";
                        Tooling = (item.Tooling.HasValue) ? item.Tooling.Value.ToString("C2") : "";
                        Sop = (item.SOP.HasValue) ? item.SOP.Value.ToString("yyyy-MM-dd") : "";
                        Eop = (item.EOP.HasValue) ? item.EOP.Value.ToString("yyyy-MM-dd") : "";
                        QuoteTransferComplete = item.QuoteTransferComplete;
                    }
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }       
        }

        public List<usp_QL_QuoteTransfer_GetCustomerContacts_Result> GetCustomerContacts(string quote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            var customerList = new List<usp_QL_QuoteTransfer_GetCustomerContacts_Result>();
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    customerList = context.usp_QL_QuoteTransfer_GetCustomerContacts(quote, tranDT, result).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return customerList;
        }

        public void QuoteTransferCompleteUpdateSendEmail(string quote, string complete, DateTime? completedDate)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QL_QuoteTransfer_Complete_UpdateSendEmail(OperatorCode, quote, complete, completedDate, tranDT, result);
                }
            }
            catch(Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        //public void ApproveCustomer()
        //{
        //    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
        //    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

        //    Error = "";
        //    try
        //    {
        //        using (var context = new MONITOREntitiesQuoteLogIntegrationCustomer())
        //        {
        //            context.usp_Web_QuoteLog_NewCustomer_ApproveRequest(OperatorCode, CustomerCode, tranDT, result);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //    }
        //}

        #endregion


    }
}