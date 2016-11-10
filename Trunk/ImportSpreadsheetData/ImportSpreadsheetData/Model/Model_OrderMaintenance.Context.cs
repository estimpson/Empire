﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ImportSpreadsheetData.Model
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class MONITOREntities_OrderMaintenance : DbContext
    {
        public MONITOREntities_OrderMaintenance()
            : base("name=MONITOREntities_OrderMaintenance")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual ObjectResult<usp_PlanningReleaseManualImport_GetOrders_Result> usp_PlanningReleaseManualImport_GetOrders(string destination, ObjectParameter tranDT, ObjectParameter result)
        {
            var destinationParameter = destination != null ?
                new ObjectParameter("Destination", destination) :
                new ObjectParameter("Destination", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_PlanningReleaseManualImport_GetOrders_Result>("usp_PlanningReleaseManualImport_GetOrders", destinationParameter, tranDT, result);
        }
    
        public virtual int usp_PlanningReleaseManualImport_UpdateModelYear(Nullable<int> orderNo, string modelYear, ObjectParameter tranDT, ObjectParameter result)
        {
            var orderNoParameter = orderNo.HasValue ?
                new ObjectParameter("OrderNo", orderNo) :
                new ObjectParameter("OrderNo", typeof(int));
    
            var modelYearParameter = modelYear != null ?
                new ObjectParameter("ModelYear", modelYear) :
                new ObjectParameter("ModelYear", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_PlanningReleaseManualImport_UpdateModelYear", orderNoParameter, modelYearParameter, tranDT, result);
        }
    }
}
