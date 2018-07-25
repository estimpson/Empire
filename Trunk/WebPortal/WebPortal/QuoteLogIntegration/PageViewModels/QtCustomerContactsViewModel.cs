using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.QuoteLogIntegration.Models;
using WebPortal.QuoteLogIntegration.DataModels;
using System.Linq;


namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class QtCustomerContactsViewModel
    {
        public String OperatorCode { get; set; }
        public String Error { get; private set; }


        #region Constructor

        public QtCustomerContactsViewModel()
        {
        }

        #endregion


        #region Methods

        public List<usp_QL_QuoteTransfer_GetCustomerContacts_Result> GetCustomerContacts(string quote)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            var contactList = new List<usp_QL_QuoteTransfer_GetCustomerContacts_Result>();
            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    contactList = context.usp_QL_QuoteTransfer_GetCustomerContacts(quote, tranDT, result).ToList();
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return contactList;
        }

        public void CustomerContactsInsert()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            Error = "";

            string quote = (System.Web.HttpContext.Current.Session["Quote"] != null)
                ? quote = System.Web.HttpContext.Current.Session["Quote"].ToString()
                : "";

            try
            {
                using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
                {
                    context.usp_QL_QuoteTransfer_CustomerContacts_Insert(OperatorCode, quote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void CustomerContactsUpdate(usp_QL_QuoteTransfer_GetCustomerContacts_Result u)
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                context.usp_QL_QuoteTransfer_CustomerContacts_Update(OperatorCode, u.RowID, u.FirstName, u.LastName, u.PhoneNumber, u.FaxNumber, u.EmailAddress, tranDT, result);
            }
        }

        #endregion


    }
}