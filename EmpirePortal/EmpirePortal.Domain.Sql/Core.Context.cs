﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace EmpirePortal.Domain.Sql
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class CorePortalEntities : DbContext
    {
        public CorePortalEntities()
            : base("name=CorePortalEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<MenuItemNode> MenuItemTree { get; set; }
        public virtual DbSet<MenuItem> MenuItems { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<User> Users { get; set; }
    
        public virtual ObjectResult<MonitorOperators> GetMonitorOperators(string monitorLoginLocation, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var monitorLoginLocationParameter = monitorLoginLocation != null ?
                new ObjectParameter("MonitorLoginLocation", monitorLoginLocation) :
                new ObjectParameter("MonitorLoginLocation", typeof(string));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<MonitorOperators>("GetMonitorOperators", monitorLoginLocationParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<MonitorOperators> GetEehMonitorOperatorsByRange(string filter, Nullable<int> start, Nullable<int> end, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var filterParameter = filter != null ?
                new ObjectParameter("Filter", filter) :
                new ObjectParameter("Filter", typeof(string));
    
            var startParameter = start.HasValue ?
                new ObjectParameter("Start", start) :
                new ObjectParameter("Start", typeof(int));
    
            var endParameter = end.HasValue ?
                new ObjectParameter("End", end) :
                new ObjectParameter("End", typeof(int));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<MonitorOperators>("GetEehMonitorOperatorsByRange", filterParameter, startParameter, endParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<MonitorOperators> GetEehMonitorOperator(string value, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var valueParameter = value != null ?
                new ObjectParameter("Value", value) :
                new ObjectParameter("Value", typeof(string));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<MonitorOperators>("GetEehMonitorOperator", valueParameter, tranDT, result, debugParameter, debugMsg);
        }
    }
}
