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
    
    public partial class MONITOREntitiesQuteLog : DbContext
    {
        public MONITOREntitiesQuteLog()
            : base("name=MONITOREntitiesQuteLog")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual ObjectResult<usp_Web_EmpireMarketSegment_Result> usp_Web_EmpireMarketSegment()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_Web_EmpireMarketSegment_Result>("usp_Web_EmpireMarketSegment");
        }
    
        public virtual int usp_Web_EmpireMarketSegment_ApproveDeny_SendEmail(string empireMarketSegment, ObjectParameter tranDT, ObjectParameter result)
        {
            var empireMarketSegmentParameter = empireMarketSegment != null ?
                new ObjectParameter("EmpireMarketSegment", empireMarketSegment) :
                new ObjectParameter("EmpireMarketSegment", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSegment_ApproveDeny_SendEmail", empireMarketSegmentParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_Web_EmpireMarketSubsegment_Result> usp_Web_EmpireMarketSubsegment()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_Web_EmpireMarketSubsegment_Result>("usp_Web_EmpireMarketSubsegment");
        }
    
        public virtual int usp_Web_EmpireMarketSubsegment_ApproveDeny_SendEmail(string empireMarketSubsegment, ObjectParameter tranDT, ObjectParameter result)
        {
            var empireMarketSubsegmentParameter = empireMarketSubsegment != null ?
                new ObjectParameter("EmpireMarketSubsegment", empireMarketSubsegment) :
                new ObjectParameter("EmpireMarketSubsegment", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSubsegment_ApproveDeny_SendEmail", empireMarketSubsegmentParameter, tranDT, result);
        }
    
        public virtual int usp_Web_EmpireMarketSegment_Approve(string operatorCode, string empireMarketSegment, string note, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var empireMarketSegmentParameter = empireMarketSegment != null ?
                new ObjectParameter("EmpireMarketSegment", empireMarketSegment) :
                new ObjectParameter("EmpireMarketSegment", typeof(string));
    
            var noteParameter = note != null ?
                new ObjectParameter("Note", note) :
                new ObjectParameter("Note", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSegment_Approve", operatorCodeParameter, empireMarketSegmentParameter, noteParameter, tranDT, result);
        }
    
        public virtual int usp_Web_EmpireMarketSegment_Deny(string operatorCode, string empireMarketSegment, string note, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var empireMarketSegmentParameter = empireMarketSegment != null ?
                new ObjectParameter("EmpireMarketSegment", empireMarketSegment) :
                new ObjectParameter("EmpireMarketSegment", typeof(string));
    
            var noteParameter = note != null ?
                new ObjectParameter("Note", note) :
                new ObjectParameter("Note", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSegment_Deny", operatorCodeParameter, empireMarketSegmentParameter, noteParameter, tranDT, result);
        }
    
        public virtual int usp_Web_EmpireMarketSubsegment_Approve(string operatorCode, string empireMarketSubsegment, string note, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var empireMarketSubsegmentParameter = empireMarketSubsegment != null ?
                new ObjectParameter("EmpireMarketSubsegment", empireMarketSubsegment) :
                new ObjectParameter("EmpireMarketSubsegment", typeof(string));
    
            var noteParameter = note != null ?
                new ObjectParameter("Note", note) :
                new ObjectParameter("Note", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSubsegment_Approve", operatorCodeParameter, empireMarketSubsegmentParameter, noteParameter, tranDT, result);
        }
    
        public virtual int usp_Web_EmpireMarketSubsegment_Deny(string operatorCode, string empireMarketSubsegment, string note, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var empireMarketSubsegmentParameter = empireMarketSubsegment != null ?
                new ObjectParameter("EmpireMarketSubsegment", empireMarketSubsegment) :
                new ObjectParameter("EmpireMarketSubsegment", typeof(string));
    
            var noteParameter = note != null ?
                new ObjectParameter("Note", note) :
                new ObjectParameter("Note", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Web_EmpireMarketSubsegment_Deny", operatorCodeParameter, empireMarketSubsegmentParameter, noteParameter, tranDT, result);
        }
    }
}
