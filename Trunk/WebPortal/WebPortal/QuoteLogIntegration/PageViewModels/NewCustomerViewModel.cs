using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using WebPortal.QuoteLogIntegration.Models;


namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    public class NewCustomerViewModel
    {
        #region Properties

        public String OperatorCode { get; set; }
        public String CustomerCode { get; set; }
        public String ResponseNote { get; set; }
        public String Error { get; private set; }

        #endregion


        #region Constructor

        public NewCustomerViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["OpCode"].ToString();
        }

        #endregion


        #region Methods

        public List<usp_Web_QuoteLog_NewCustomer_GetRequests_Result> GetCustomerRequests()
        {
            var customerList = new List<usp_Web_QuoteLog_NewCustomer_GetRequests_Result>();
            using (var context = new MONITOREntitiesQuoteLogIntegrationCustomer())
            {
                customerList = context.usp_Web_QuoteLog_NewCustomer_GetRequests().ToList();
            }
            return customerList;
        }

        public void ApproveCustomer()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationCustomer())
                {
                    context.usp_Web_QuoteLog_NewCustomer_ApproveRequest(OperatorCode, CustomerCode, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void DenyCustomer()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationCustomer())
                {
                    context.usp_Web_QuoteLog_NewCustomer_Deny_SendEmail(OperatorCode, CustomerCode, ResponseNote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SendApprovedEmail()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationCustomer())
                {
                    context.usp_Web_QuoteLog_NewCustomer_Approve_SendEmail(CustomerCode, tranDT, result);
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