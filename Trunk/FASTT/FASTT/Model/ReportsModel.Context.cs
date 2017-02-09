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
    
        public DbSet<vw_ST_LightingStudy_2016> vw_ST_LightingStudy_2016 { get; set; }
        public DbSet<vw_ST_SalesPersonActivity_OneWeek> vw_ST_SalesPersonActivity_OneWeek { get; set; }
        public DbSet<ST_CustomersWithProgramsLaunchingClosing2017> ST_CustomersWithProgramsLaunchingClosing2017 { get; set; }
        public DbSet<ST_CustomersWithProgramsLaunchingClosing2018> ST_CustomersWithProgramsLaunchingClosing2018 { get; set; }
        public DbSet<ST_CustomersWithProgramsLaunchingClosing2019> ST_CustomersWithProgramsLaunchingClosing2019 { get; set; }
        public DbSet<ST_CustomersAll> ST_CustomersAll { get; set; }
    
        public virtual ObjectResult<ProgramsLaunchingByCustomer> usp_ST_Metrics_ProgramsLaunchingByCustomer()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<ProgramsLaunchingByCustomer>("usp_ST_Metrics_ProgramsLaunchingByCustomer");
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsLaunching> usp_ST_Metrics_PeakVolumeOfProgramsLaunching()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsLaunching>("usp_ST_Metrics_PeakVolumeOfProgramsLaunching");
        }
    
        public virtual ObjectResult<usp_ST_Metrics_TotalSalesActivityOneMonth_Result> usp_ST_Metrics_TotalSalesActivityOneMonth()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Metrics_TotalSalesActivityOneMonth_Result>("usp_ST_Metrics_TotalSalesActivityOneMonth");
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsClosing2017_Result> usp_ST_Metrics_PeakVolumeOfProgramsClosing2017(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsClosing2017_Result>("usp_ST_Metrics_PeakVolumeOfProgramsClosing2017", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsClosing2018_Result> usp_ST_Metrics_PeakVolumeOfProgramsClosing2018(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsClosing2018_Result>("usp_ST_Metrics_PeakVolumeOfProgramsClosing2018", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsClosing2019_Result> usp_ST_Metrics_PeakVolumeOfProgramsClosing2019(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsClosing2019_Result>("usp_ST_Metrics_PeakVolumeOfProgramsClosing2019", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsLaunching2018_Result> usp_ST_Metrics_PeakVolumeOfProgramsLaunching2018(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsLaunching2018_Result>("usp_ST_Metrics_PeakVolumeOfProgramsLaunching2018", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsLaunching2019_Result> usp_ST_Metrics_PeakVolumeOfProgramsLaunching2019(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsLaunching2019_Result>("usp_ST_Metrics_PeakVolumeOfProgramsLaunching2019", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<PeakVolumeOfProgramsLaunching2017_Result> usp_ST_Metrics_PeakVolumeOfProgramsLaunching2017(string customer, string region)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var regionParameter = region != null ?
                new ObjectParameter("Region", region) :
                new ObjectParameter("Region", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<PeakVolumeOfProgramsLaunching2017_Result>("usp_ST_Metrics_PeakVolumeOfProgramsLaunching2017", customerParameter, regionParameter);
        }
    
        public virtual ObjectResult<usp_ST_Report_SalesActivityOneWeek_Result> usp_ST_Report_SalesActivityOneWeek()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Report_SalesActivityOneWeek_Result>("usp_ST_Report_SalesActivityOneWeek");
        }
    
        public virtual ObjectResult<usp_ST_Reports_GetSalesForecastData_Result> usp_ST_Reports_GetSalesForecastData(string lightingStudyCustomer, ObjectParameter tranDT, ObjectParameter result)
        {
            var lightingStudyCustomerParameter = lightingStudyCustomer != null ?
                new ObjectParameter("LightingStudyCustomer", lightingStudyCustomer) :
                new ObjectParameter("LightingStudyCustomer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Reports_GetSalesForecastData_Result>("usp_ST_Reports_GetSalesForecastData", lightingStudyCustomerParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_Report_SalesActivityByCustomer_Result> usp_ST_Report_SalesActivityByCustomer(string customer)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Report_SalesActivityByCustomer_Result>("usp_ST_Report_SalesActivityByCustomer", customerParameter);
        }
    
        public virtual ObjectResult<usp_ST_Report_TopLeads_Result> usp_ST_Report_TopLeads()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Report_TopLeads_Result>("usp_ST_Report_TopLeads");
        }
    
        public virtual ObjectResult<usp_ST_Report_TopLeadsByCustomer_Result> usp_ST_Report_TopLeadsByCustomer(string customer)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_Report_TopLeadsByCustomer_Result>("usp_ST_Report_TopLeadsByCustomer", customerParameter);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Report_NewQuotes_Result> usp_ST_SalesLeadLog_Report_NewQuotes(Nullable<int> numberOfDays, ObjectParameter tranDT, ObjectParameter result)
        {
            var numberOfDaysParameter = numberOfDays.HasValue ?
                new ObjectParameter("NumberOfDays", numberOfDays) :
                new ObjectParameter("NumberOfDays", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Report_NewQuotes_Result>("usp_ST_SalesLeadLog_Report_NewQuotes", numberOfDaysParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Report_NewQuotesByCustomer_Result> usp_ST_SalesLeadLog_Report_NewQuotesByCustomer(string customer, ObjectParameter tranDT, ObjectParameter result)
        {
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Report_NewQuotesByCustomer_Result>("usp_ST_SalesLeadLog_Report_NewQuotesByCustomer", customerParameter, tranDT, result);
        }
    
        public virtual ObjectResult<usp_ST_SalesLeadLog_Report_OpenQuotes_Result> usp_ST_SalesLeadLog_Report_OpenQuotes(ObjectParameter tranDT, ObjectParameter result)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_ST_SalesLeadLog_Report_OpenQuotes_Result>("usp_ST_SalesLeadLog_Report_OpenQuotes", tranDT, result);
        }
    }
}
