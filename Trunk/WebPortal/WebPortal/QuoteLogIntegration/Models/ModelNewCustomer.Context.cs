﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebPortal.QuoteLogIntegration.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class MONITOREntitiesQuoteLogIntegrationCustomer : DbContext
    {
        public MONITOREntitiesQuoteLogIntegrationCustomer()
            : base("name=MONITOREntitiesQuoteLogIntegrationCustomer")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual int usp_Web_QuoteLog_NewCustomer_Approve_SendEmail(string customerCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var customerCodeParameter = customerCode != null ?
                new ObjectParameter("CustomerCode", customerCode) :
                new ObjectParameter("CustomerCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_QuoteLog_NewCustomer_Approve_SendEmail", customerCodeParameter, tranDT, result);
        }
    
        public virtual int usp_Web_QuoteLog_NewCustomer_ApproveRequest(string operatorCode, string customerCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var customerCodeParameter = customerCode != null ?
                new ObjectParameter("CustomerCode", customerCode) :
                new ObjectParameter("CustomerCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_QuoteLog_NewCustomer_ApproveRequest", operatorCodeParameter, customerCodeParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_Web_QuoteLog_NewCustomer_GetRequests_Result> usp_Web_QuoteLog_NewCustomer_GetRequests()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_Web_QuoteLog_NewCustomer_GetRequests_Result>("usp_Web_QuoteLog_NewCustomer_GetRequests");
        }
    
        public virtual int usp_Web_QuoteLog_NewCustomer_Deny_SendEmail(string operatorCode, string customerCode, string responseNote, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var customerCodeParameter = customerCode != null ?
                new ObjectParameter("CustomerCode", customerCode) :
                new ObjectParameter("CustomerCode", typeof(string));
    
            var responseNoteParameter = responseNote != null ?
                new ObjectParameter("ResponseNote", responseNote) :
                new ObjectParameter("ResponseNote", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_QuoteLog_NewCustomer_Deny_SendEmail", operatorCodeParameter, customerCodeParameter, responseNoteParameter, tranDT, result);
        }
    }
}
