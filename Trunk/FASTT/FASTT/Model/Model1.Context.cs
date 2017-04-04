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
    
    public partial class MONITOREntities1 : DbContext
    {
        public MONITOREntities1()
            : base("name=MONITOREntities1")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<employee> employees { get; set; }
        public DbSet<ST_SalesLeadLog_StatusDefinition> ST_SalesLeadLog_StatusDefinition { get; set; }
        public DbSet<vw_ST_LightingStudy_Hitlist_2016> vw_ST_LightingStudy_Hitlist_2016 { get; set; }
    
        public virtual ObjectResult<usp_ST_Csm_SalesForecast_Result1> usp_ST_Csm_SalesForecast(string parentCustomer, ObjectParameter tranDT, ObjectParameter result)
        {
            var parentCustomerParameter = parentCustomer != null ?
                new ObjectParameter("ParentCustomer", parentCustomer) :
                new ObjectParameter("ParentCustomer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Csm_SalesForecast_Result1>("usp_ST_Csm_SalesForecast", parentCustomerParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_GetContactInfo_Result> usp_ST_SalesLeadLog_GetContactInfo(Nullable<int> id, ObjectParameter tranDT, ObjectParameter result)
        {
            var idParameter = id.HasValue ?
                new ObjectParameter("Id", id) :
                new ObjectParameter("Id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_GetContactInfo_Result>("usp_ST_SalesLeadLog_GetContactInfo", idParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_GetActivityHistory_Result> usp_ST_SalesLeadLog_GetActivityHistory(Nullable<int> salesLeadId, ObjectParameter tranDT, ObjectParameter result)
        {
            var salesLeadIdParameter = salesLeadId.HasValue ?
                new ObjectParameter("SalesLeadId", salesLeadId) :
                new ObjectParameter("SalesLeadId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_GetActivityHistory_Result>("usp_ST_SalesLeadLog_GetActivityHistory", salesLeadIdParameter, tranDT, result);
        }
    
        public virtual int usp_ST_SalesLeadLog_Hitlist_SearchForSalesLeads(Nullable<int> hitlistId, ObjectParameter tranDT, ObjectParameter result)
        {
            var hitlistIdParameter = hitlistId.HasValue ?
                new ObjectParameter("HitlistId", hitlistId) :
                new ObjectParameter("HitlistId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_ST_SalesLeadLog_Hitlist_SearchForSalesLeads", hitlistIdParameter, tranDT, result);
        }
    
        public virtual int usp_ST_SalesLeadLog_Hitlist_Update(string operatorCode, Nullable<int> combinedLightingId, Nullable<int> salesLeadId, Nullable<int> salesLeadStatus, Nullable<int> activityRowId, string activity, Nullable<System.DateTime> activityDate, string meetingLocation, string contactName, string contactPhoneNumber, string contactEmailAddress, Nullable<decimal> duration, string notes, string quoteNumber, Nullable<int> awardedVolume, ObjectParameter tranDT, ObjectParameter result)
        {
            var operatorCodeParameter = operatorCode != null ?
                new ObjectParameter("OperatorCode", operatorCode) :
                new ObjectParameter("OperatorCode", typeof(string));
    
            var combinedLightingIdParameter = combinedLightingId.HasValue ?
                new ObjectParameter("CombinedLightingId", combinedLightingId) :
                new ObjectParameter("CombinedLightingId", typeof(int));
    
            var salesLeadIdParameter = salesLeadId.HasValue ?
                new ObjectParameter("SalesLeadId", salesLeadId) :
                new ObjectParameter("SalesLeadId", typeof(int));
    
            var salesLeadStatusParameter = salesLeadStatus.HasValue ?
                new ObjectParameter("SalesLeadStatus", salesLeadStatus) :
                new ObjectParameter("SalesLeadStatus", typeof(int));
    
            var activityRowIdParameter = activityRowId.HasValue ?
                new ObjectParameter("ActivityRowId", activityRowId) :
                new ObjectParameter("ActivityRowId", typeof(int));
    
            var activityParameter = activity != null ?
                new ObjectParameter("Activity", activity) :
                new ObjectParameter("Activity", typeof(string));
    
            var activityDateParameter = activityDate.HasValue ?
                new ObjectParameter("ActivityDate", activityDate) :
                new ObjectParameter("ActivityDate", typeof(System.DateTime));
    
            var meetingLocationParameter = meetingLocation != null ?
                new ObjectParameter("MeetingLocation", meetingLocation) :
                new ObjectParameter("MeetingLocation", typeof(string));
    
            var contactNameParameter = contactName != null ?
                new ObjectParameter("ContactName", contactName) :
                new ObjectParameter("ContactName", typeof(string));
    
            var contactPhoneNumberParameter = contactPhoneNumber != null ?
                new ObjectParameter("ContactPhoneNumber", contactPhoneNumber) :
                new ObjectParameter("ContactPhoneNumber", typeof(string));
    
            var contactEmailAddressParameter = contactEmailAddress != null ?
                new ObjectParameter("ContactEmailAddress", contactEmailAddress) :
                new ObjectParameter("ContactEmailAddress", typeof(string));
    
            var durationParameter = duration.HasValue ?
                new ObjectParameter("Duration", duration) :
                new ObjectParameter("Duration", typeof(decimal));
    
            var notesParameter = notes != null ?
                new ObjectParameter("Notes", notes) :
                new ObjectParameter("Notes", typeof(string));
    
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var awardedVolumeParameter = awardedVolume.HasValue ?
                new ObjectParameter("AwardedVolume", awardedVolume) :
                new ObjectParameter("AwardedVolume", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_ST_SalesLeadLog_Hitlist_Update", operatorCodeParameter, combinedLightingIdParameter, salesLeadIdParameter, salesLeadStatusParameter, activityRowIdParameter, activityParameter, activityDateParameter, meetingLocationParameter, contactNameParameter, contactPhoneNumberParameter, contactEmailAddressParameter, durationParameter, notesParameter, quoteNumberParameter, awardedVolumeParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Hitlist_GetActivity_Result> usp_ST_SalesLeadLog_Hitlist_GetActivity(string salesPersonCode, ObjectParameter tranDT, ObjectParameter result)
        {
            var salesPersonCodeParameter = salesPersonCode != null ?
                new ObjectParameter("SalesPersonCode", salesPersonCode) :
                new ObjectParameter("SalesPersonCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Hitlist_GetActivity_Result>("usp_ST_SalesLeadLog_Hitlist_GetActivity", salesPersonCodeParameter, tranDT, result);
        }
    }
}
