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
    
    public partial class MONITOREntities_LiteTek : DbContext
    {
        public MONITOREntities_LiteTek()
            : base("name=MONITOREntities_LiteTek")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual int usp_DeleteRecords_ManualImport(string release, ObjectParameter tranDT, ObjectParameter result)
        {
            var releaseParameter = release != null ?
                new ObjectParameter("Release", release) :
                new ObjectParameter("Release", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_DeleteRecords_ManualImport", releaseParameter, tranDT, result);
        }
    
        public virtual int usp_Process_ManualImport(string destination, ObjectParameter tranDT, ObjectParameter result, Nullable<int> testing, Nullable<int> debug)
        {
            var destinationParameter = destination != null ?
                new ObjectParameter("Destination", destination) :
                new ObjectParameter("Destination", typeof(string));
    
            var testingParameter = testing.HasValue ?
                new ObjectParameter("Testing", testing) :
                new ObjectParameter("Testing", typeof(int));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Process_ManualImport", destinationParameter, tranDT, result, testingParameter, debugParameter);
        }
    
        public virtual int usp_Stage_2_ManualImport(string release, string customerPart, string part, string destination, Nullable<decimal> releaseQty, Nullable<System.DateTime> releaseDT, ObjectParameter tranDT, ObjectParameter result)
        {
            var releaseParameter = release != null ?
                new ObjectParameter("Release", release) :
                new ObjectParameter("Release", typeof(string));
    
            var customerPartParameter = customerPart != null ?
                new ObjectParameter("CustomerPart", customerPart) :
                new ObjectParameter("CustomerPart", typeof(string));
    
            var partParameter = part != null ?
                new ObjectParameter("Part", part) :
                new ObjectParameter("Part", typeof(string));
    
            var destinationParameter = destination != null ?
                new ObjectParameter("Destination", destination) :
                new ObjectParameter("Destination", typeof(string));
    
            var releaseQtyParameter = releaseQty.HasValue ?
                new ObjectParameter("ReleaseQty", releaseQty) :
                new ObjectParameter("ReleaseQty", typeof(decimal));
    
            var releaseDTParameter = releaseDT.HasValue ?
                new ObjectParameter("ReleaseDT", releaseDT) :
                new ObjectParameter("ReleaseDT", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_Stage_2_ManualImport", releaseParameter, customerPartParameter, partParameter, destinationParameter, releaseQtyParameter, releaseDTParameter, tranDT, result);
        }
    }
}
