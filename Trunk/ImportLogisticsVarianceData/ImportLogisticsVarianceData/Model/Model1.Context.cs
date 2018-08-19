﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ImportLogisticsVarianceData.Model
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
    
    
        public virtual int usp_Variance_InsertFromRaw(string operatorCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Variance_InsertFromRaw", operatorCodeParameter, tranDT, result);
        }
    
        public virtual int usp_Variance_InsertChrFromRaw(string operatorCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Variance_InsertChrFromRaw", operatorCodeParameter, tranDT, result);
        }
    
        public virtual int usp_Variance_InsertPfsFromRaw(string operatorCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Variance_InsertPfsFromRaw", operatorCodeParameter, tranDT, result);
        }
    
        public virtual int usp_Variance_ValidateOperator(string operatorCode, string password, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var passwordParameter = password != null ?
                new ObjectParameter("Password", password) :
                new ObjectParameter("Password", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Variance_ValidateOperator", operatorCodeParameter, passwordParameter, tranDT, result);
        }
    
        public virtual int usp_Variance_InsertUpsFromRaw(string operatorCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Variance_InsertUpsFromRaw", operatorCodeParameter, tranDT, result);
        }
    }
}