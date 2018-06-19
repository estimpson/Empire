﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebPortal.Scheduling.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class MONITOREntities3 : DbContext
    {
        public MONITOREntities3()
            : base("name=MONITOREntities3")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual int usp_PlanningSnapshot_CRUD_NewOnOrderEEH(string user, string finishedPart, string revision, Nullable<System.DateTime> calendarDT, Nullable<decimal> newOnOrderEEH, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var finishedPartParameter = finishedPart != null ?
                new ObjectParameter("FinishedPart", finishedPart) :
                new ObjectParameter("FinishedPart", typeof(string));
    
            var revisionParameter = revision != null ?
                new ObjectParameter("Revision", revision) :
                new ObjectParameter("Revision", typeof(string));
    
            var calendarDTParameter = calendarDT.HasValue ?
                new ObjectParameter("CalendarDT", calendarDT) :
                new ObjectParameter("CalendarDT", typeof(System.DateTime));
    
            var newOnOrderEEHParameter = newOnOrderEEH.HasValue ?
                new ObjectParameter("NewOnOrderEEH", newOnOrderEEH) :
                new ObjectParameter("NewOnOrderEEH", typeof(decimal));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_PlanningSnapshot_CRUD_NewOnOrderEEH", userParameter, finishedPartParameter, revisionParameter, calendarDTParameter, newOnOrderEEHParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual int usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement(string user, string finishedPart, string revision, Nullable<System.DateTime> calendarDT, Nullable<decimal> newRequirement, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var userParameter = user != null ?
                new ObjectParameter("User", user) :
                new ObjectParameter("User", typeof(string));
    
            var finishedPartParameter = finishedPart != null ?
                new ObjectParameter("FinishedPart", finishedPart) :
                new ObjectParameter("FinishedPart", typeof(string));
    
            var revisionParameter = revision != null ?
                new ObjectParameter("Revision", revision) :
                new ObjectParameter("Revision", typeof(string));
    
            var calendarDTParameter = calendarDT.HasValue ?
                new ObjectParameter("CalendarDT", calendarDT) :
                new ObjectParameter("CalendarDT", typeof(System.DateTime));
    
            var newRequirementParameter = newRequirement.HasValue ?
                new ObjectParameter("NewRequirement", newRequirement) :
                new ObjectParameter("NewRequirement", typeof(decimal));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement", userParameter, finishedPartParameter, revisionParameter, calendarDTParameter, newRequirementParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<usp_PlanningSnapshot_Q_CurrentPartList_Result> usp_PlanningSnapshot_Q_CurrentPartList(string schedulerID, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var schedulerIDParameter = schedulerID != null ?
                new ObjectParameter("SchedulerID", schedulerID) :
                new ObjectParameter("SchedulerID", typeof(string));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_PlanningSnapshot_Q_CurrentPartList_Result>("usp_PlanningSnapshot_Q_CurrentPartList", schedulerIDParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<usp_PlanningSnapshot_Q_GetHeaderInfo_Result> usp_PlanningSnapshot_Q_GetHeaderInfo(string finishedPart, string revision, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var finishedPartParameter = finishedPart != null ?
                new ObjectParameter("FinishedPart", finishedPart) :
                new ObjectParameter("FinishedPart", typeof(string));
    
            var revisionParameter = revision != null ?
                new ObjectParameter("Revision", revision) :
                new ObjectParameter("Revision", typeof(string));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_PlanningSnapshot_Q_GetHeaderInfo_Result>("usp_PlanningSnapshot_Q_GetHeaderInfo", finishedPartParameter, revisionParameter, tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<usp_PlanningSnapshot_Q_GetSchedulers_Result> usp_PlanningSnapshot_Q_GetSchedulers(ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_PlanningSnapshot_Q_GetSchedulers_Result>("usp_PlanningSnapshot_Q_GetSchedulers", tranDT, result, debugParameter, debugMsg);
        }
    
        public virtual ObjectResult<usp_PlanningSnapshot_Q_GetSnapshotCalendar_Result> usp_PlanningSnapshot_Q_GetSnapshotCalendar(string finishedPart, string revision, ObjectParameter tranDT, ObjectParameter result, Nullable<int> debug, ObjectParameter debugMsg)
        {
            var finishedPartParameter = finishedPart != null ?
                new ObjectParameter("FinishedPart", finishedPart) :
                new ObjectParameter("FinishedPart", typeof(string));
    
            var revisionParameter = revision != null ?
                new ObjectParameter("Revision", revision) :
                new ObjectParameter("Revision", typeof(string));
    
            var debugParameter = debug.HasValue ?
                new ObjectParameter("Debug", debug) :
                new ObjectParameter("Debug", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_PlanningSnapshot_Q_GetSnapshotCalendar_Result>("usp_PlanningSnapshot_Q_GetSnapshotCalendar", finishedPartParameter, revisionParameter, tranDT, result, debugParameter, debugMsg);
        }
    }
}
