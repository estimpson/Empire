﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FASTT.Model
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class MONITOREntities : DbContext
    {
        public MONITOREntities()
            : base("name=MONITOREntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Report_OpenQuotes_Result> usp_ST_SalesLeadLog_Report_OpenQuotes(ObjectParameter tranDT, ObjectParameter result)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Report_OpenQuotes_Result>("usp_ST_SalesLeadLog_Report_OpenQuotes", tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Report_NewQuotes_Result> usp_ST_SalesLeadLog_Report_NewQuotes(ObjectParameter tranDT, ObjectParameter result)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Report_NewQuotes_Result>("usp_ST_SalesLeadLog_Report_NewQuotes", tranDT, result);
        }
    }
}