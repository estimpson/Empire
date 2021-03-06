﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QuoteLogData.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class QuoteLogContext : DbContext
    {
        public QuoteLogContext()
            : base("name=QuoteLogContext")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<QuoteEntry> QuoteLog { get; set; }
        public DbSet<Application> Applications { get; set; }
        public DbSet<CSM_Mnemonic> CSM_Mnemonic { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Requote> Requotes { get; set; }
        public DbSet<EngineeringInitials> EngineeringInitials { get; set; }
        public DbSet<EngineeringMaterialsInitials> EngineeringMaterialsInitials { get; set; }
        public DbSet<ProgramManagerInitials> ProgramManagerInitials { get; set; }
        public DbSet<SalesInitials> SalesInitials { get; set; }
        public DbSet<QuoteCSM> QuoteCSMs { get; set; }
        public DbSet<QuoteManualProgramData> QuoteManualProgramDatas { get; set; }
        public DbSet<QuoteLTA> QuoteLTAs { get; set; }
        public DbSet<CustomerQuoteInitials> CustomerQuoteInitials { get; set; }
        public DbSet<QuotePricingInitials> QuotePricingInitials { get; set; }
        public DbSet<QuoteReviewInitials> QuoteReviewInitials { get; set; }
        public DbSet<ApplicationNames> ApplicationNames { get; set; }
        public DbSet<Functions> Functions { get; set; }
        public DbSet<QuotePrints> QuotePrints { get; set; }
        public DbSet<QuoteTreeList> QuoteTreeLists { get; set; }
        public DbSet<QT_Test> QT_Test { get; set; }
    
        public virtual ObjectResult<Application> GetApplicationCodes()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Application>("GetApplicationCodes");
        }
    
        public virtual ObjectResult<Application> GetApplicationCodes(MergeOption mergeOption)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Application>("GetApplicationCodes", mergeOption);
        }
    
        public virtual int usp_QT_InsertQuoteLog(string quoteNumber, Nullable<int> parentQuoteID, string customerRFQNumber, Nullable<System.DateTime> receiptDate, string customer, Nullable<System.DateTime> requestedDueDate, Nullable<System.DateTime> eEIPromisedDueDate, string customerPartNumber, string eEIPartNumber, string requote, string notes, Nullable<decimal> eAU, string applicationName, string applicationCode, string functionName, string program, string oEM, string nameplate, string modelYear, Nullable<System.DateTime> sOP, Nullable<System.DateTime> eOP, string salesInitials, string programManagerInitials, string engineeringInitials, string engineeringMaterialsInitials, Nullable<System.DateTime> engineeringMaterialsDate, string quoteReviewInitials, Nullable<System.DateTime> quoteReviewDate, string quotePricingInitials, Nullable<System.DateTime> quotePricingDate, string customerQuoteInitials, Nullable<System.DateTime> customerQuoteDate, Nullable<decimal> straightMaterialCost, Nullable<decimal> quotePrice, Nullable<decimal> prototypePrice, string awarded, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var parentQuoteIDParameter = parentQuoteID.HasValue ?
                new ObjectParameter("ParentQuoteID", parentQuoteID) :
                new ObjectParameter("ParentQuoteID", typeof(int));
    
            var customerRFQNumberParameter = customerRFQNumber != null ?
                new ObjectParameter("CustomerRFQNumber", customerRFQNumber) :
                new ObjectParameter("CustomerRFQNumber", typeof(string));
    
            var receiptDateParameter = receiptDate.HasValue ?
                new ObjectParameter("ReceiptDate", receiptDate) :
                new ObjectParameter("ReceiptDate", typeof(System.DateTime));
    
            var customerParameter = customer != null ?
                new ObjectParameter("Customer", customer) :
                new ObjectParameter("Customer", typeof(string));
    
            var requestedDueDateParameter = requestedDueDate.HasValue ?
                new ObjectParameter("RequestedDueDate", requestedDueDate) :
                new ObjectParameter("RequestedDueDate", typeof(System.DateTime));
    
            var eEIPromisedDueDateParameter = eEIPromisedDueDate.HasValue ?
                new ObjectParameter("EEIPromisedDueDate", eEIPromisedDueDate) :
                new ObjectParameter("EEIPromisedDueDate", typeof(System.DateTime));
    
            var customerPartNumberParameter = customerPartNumber != null ?
                new ObjectParameter("CustomerPartNumber", customerPartNumber) :
                new ObjectParameter("CustomerPartNumber", typeof(string));
    
            var eEIPartNumberParameter = eEIPartNumber != null ?
                new ObjectParameter("EEIPartNumber", eEIPartNumber) :
                new ObjectParameter("EEIPartNumber", typeof(string));
    
            var requoteParameter = requote != null ?
                new ObjectParameter("Requote", requote) :
                new ObjectParameter("Requote", typeof(string));
    
            var notesParameter = notes != null ?
                new ObjectParameter("Notes", notes) :
                new ObjectParameter("Notes", typeof(string));
    
            var eAUParameter = eAU.HasValue ?
                new ObjectParameter("EAU", eAU) :
                new ObjectParameter("EAU", typeof(decimal));
    
            var applicationNameParameter = applicationName != null ?
                new ObjectParameter("ApplicationName", applicationName) :
                new ObjectParameter("ApplicationName", typeof(string));
    
            var applicationCodeParameter = applicationCode != null ?
                new ObjectParameter("ApplicationCode", applicationCode) :
                new ObjectParameter("ApplicationCode", typeof(string));
    
            var functionNameParameter = functionName != null ?
                new ObjectParameter("FunctionName", functionName) :
                new ObjectParameter("FunctionName", typeof(string));
    
            var programParameter = program != null ?
                new ObjectParameter("Program", program) :
                new ObjectParameter("Program", typeof(string));
    
            var oEMParameter = oEM != null ?
                new ObjectParameter("OEM", oEM) :
                new ObjectParameter("OEM", typeof(string));
    
            var nameplateParameter = nameplate != null ?
                new ObjectParameter("Nameplate", nameplate) :
                new ObjectParameter("Nameplate", typeof(string));
    
            var modelYearParameter = modelYear != null ?
                new ObjectParameter("ModelYear", modelYear) :
                new ObjectParameter("ModelYear", typeof(string));
    
            var sOPParameter = sOP.HasValue ?
                new ObjectParameter("SOP", sOP) :
                new ObjectParameter("SOP", typeof(System.DateTime));
    
            var eOPParameter = eOP.HasValue ?
                new ObjectParameter("EOP", eOP) :
                new ObjectParameter("EOP", typeof(System.DateTime));
    
            var salesInitialsParameter = salesInitials != null ?
                new ObjectParameter("SalesInitials", salesInitials) :
                new ObjectParameter("SalesInitials", typeof(string));
    
            var programManagerInitialsParameter = programManagerInitials != null ?
                new ObjectParameter("ProgramManagerInitials", programManagerInitials) :
                new ObjectParameter("ProgramManagerInitials", typeof(string));
    
            var engineeringInitialsParameter = engineeringInitials != null ?
                new ObjectParameter("EngineeringInitials", engineeringInitials) :
                new ObjectParameter("EngineeringInitials", typeof(string));
    
            var engineeringMaterialsInitialsParameter = engineeringMaterialsInitials != null ?
                new ObjectParameter("EngineeringMaterialsInitials", engineeringMaterialsInitials) :
                new ObjectParameter("EngineeringMaterialsInitials", typeof(string));
    
            var engineeringMaterialsDateParameter = engineeringMaterialsDate.HasValue ?
                new ObjectParameter("EngineeringMaterialsDate", engineeringMaterialsDate) :
                new ObjectParameter("EngineeringMaterialsDate", typeof(System.DateTime));
    
            var quoteReviewInitialsParameter = quoteReviewInitials != null ?
                new ObjectParameter("QuoteReviewInitials", quoteReviewInitials) :
                new ObjectParameter("QuoteReviewInitials", typeof(string));
    
            var quoteReviewDateParameter = quoteReviewDate.HasValue ?
                new ObjectParameter("QuoteReviewDate", quoteReviewDate) :
                new ObjectParameter("QuoteReviewDate", typeof(System.DateTime));
    
            var quotePricingInitialsParameter = quotePricingInitials != null ?
                new ObjectParameter("QuotePricingInitials", quotePricingInitials) :
                new ObjectParameter("QuotePricingInitials", typeof(string));
    
            var quotePricingDateParameter = quotePricingDate.HasValue ?
                new ObjectParameter("QuotePricingDate", quotePricingDate) :
                new ObjectParameter("QuotePricingDate", typeof(System.DateTime));
    
            var customerQuoteInitialsParameter = customerQuoteInitials != null ?
                new ObjectParameter("CustomerQuoteInitials", customerQuoteInitials) :
                new ObjectParameter("CustomerQuoteInitials", typeof(string));
    
            var customerQuoteDateParameter = customerQuoteDate.HasValue ?
                new ObjectParameter("CustomerQuoteDate", customerQuoteDate) :
                new ObjectParameter("CustomerQuoteDate", typeof(System.DateTime));
    
            var straightMaterialCostParameter = straightMaterialCost.HasValue ?
                new ObjectParameter("StraightMaterialCost", straightMaterialCost) :
                new ObjectParameter("StraightMaterialCost", typeof(decimal));
    
            var quotePriceParameter = quotePrice.HasValue ?
                new ObjectParameter("QuotePrice", quotePrice) :
                new ObjectParameter("QuotePrice", typeof(decimal));
    
            var prototypePriceParameter = prototypePrice.HasValue ?
                new ObjectParameter("PrototypePrice", prototypePrice) :
                new ObjectParameter("PrototypePrice", typeof(decimal));
    
            var awardedParameter = awarded != null ?
                new ObjectParameter("Awarded", awarded) :
                new ObjectParameter("Awarded", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_InsertQuoteLog", quoteNumberParameter, parentQuoteIDParameter, customerRFQNumberParameter, receiptDateParameter, customerParameter, requestedDueDateParameter, eEIPromisedDueDateParameter, customerPartNumberParameter, eEIPartNumberParameter, requoteParameter, notesParameter, eAUParameter, applicationNameParameter, applicationCodeParameter, functionNameParameter, programParameter, oEMParameter, nameplateParameter, modelYearParameter, sOPParameter, eOPParameter, salesInitialsParameter, programManagerInitialsParameter, engineeringInitialsParameter, engineeringMaterialsInitialsParameter, engineeringMaterialsDateParameter, quoteReviewInitialsParameter, quoteReviewDateParameter, quotePricingInitialsParameter, quotePricingDateParameter, customerQuoteInitialsParameter, customerQuoteDateParameter, straightMaterialCostParameter, quotePriceParameter, prototypePriceParameter, awardedParameter, tranDT, result);
        }
    
        public virtual int usp_QT_ReplaceQuoteLogValues(string deleteFrom, string deletingValue, string replacementValue, ObjectParameter tranDT, ObjectParameter result)
        {
            var deleteFromParameter = deleteFrom != null ?
                new ObjectParameter("DeleteFrom", deleteFrom) :
                new ObjectParameter("DeleteFrom", typeof(string));
    
            var deletingValueParameter = deletingValue != null ?
                new ObjectParameter("DeletingValue", deletingValue) :
                new ObjectParameter("DeletingValue", typeof(string));
    
            var replacementValueParameter = replacementValue != null ?
                new ObjectParameter("ReplacementValue", replacementValue) :
                new ObjectParameter("ReplacementValue", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_ReplaceQuoteLogValues", deleteFromParameter, deletingValueParameter, replacementValueParameter, tranDT, result);
        }
    
        public virtual int usp_QT_InsertQuoteCSM(string quoteNumber, string cSM_Mnemonic, string version, string release_ID, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var cSM_MnemonicParameter = cSM_Mnemonic != null ?
                new ObjectParameter("CSM_Mnemonic", cSM_Mnemonic) :
                new ObjectParameter("CSM_Mnemonic", typeof(string));
    
            var versionParameter = version != null ?
                new ObjectParameter("Version", version) :
                new ObjectParameter("Version", typeof(string));
    
            var release_IDParameter = release_ID != null ?
                new ObjectParameter("Release_ID", release_ID) :
                new ObjectParameter("Release_ID", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_InsertQuoteCSM", quoteNumberParameter, cSM_MnemonicParameter, versionParameter, release_IDParameter, tranDT, result);
        }
    
        public virtual int usp_QT_DeleteQuoteCSM(string quoteNumber, string cSM_Mnemonic, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var cSM_MnemonicParameter = cSM_Mnemonic != null ?
                new ObjectParameter("CSM_Mnemonic", cSM_Mnemonic) :
                new ObjectParameter("CSM_Mnemonic", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_DeleteQuoteCSM", quoteNumberParameter, cSM_MnemonicParameter, tranDT, result);
        }
    
        public virtual int usp_QT_GetBOMModificationQuoteNumber(string quoteNumber, ObjectParameter newQuoteNumber)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_GetBOMModificationQuoteNumber", quoteNumberParameter, newQuoteNumber);
        }
    
        public virtual int usp_QT_GetNewQuote(ObjectParameter newQuoteNumber)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_GetNewQuote", newQuoteNumber);
        }
    
        public virtual int usp_QT_GetPriceChangeModificationQuoteNumber(string quoteNumber, ObjectParameter newQuoteNumber)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_GetPriceChangeModificationQuoteNumber", quoteNumberParameter, newQuoteNumber);
        }
    
        public virtual int usp_QT_InsertQuoteManualProgramData(string quoteNumber, string manufacturer, string platform, string program, string nameplate, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var manufacturerParameter = manufacturer != null ?
                new ObjectParameter("Manufacturer", manufacturer) :
                new ObjectParameter("Manufacturer", typeof(string));
    
            var platformParameter = platform != null ?
                new ObjectParameter("Platform", platform) :
                new ObjectParameter("Platform", typeof(string));
    
            var programParameter = program != null ?
                new ObjectParameter("Program", program) :
                new ObjectParameter("Program", typeof(string));
    
            var nameplateParameter = nameplate != null ?
                new ObjectParameter("Nameplate", nameplate) :
                new ObjectParameter("Nameplate", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_InsertQuoteManualProgramData", quoteNumberParameter, manufacturerParameter, platformParameter, programParameter, nameplateParameter, tranDT, result);
        }
    
        public virtual int usp_QT_UpdateQuoteLTA(string quoteNumber, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_UpdateQuoteLTA", quoteNumberParameter, tranDT, result);
        }
    
        public virtual int usp_QT_DeleteQuoteManualProgramData(string quoteNumber, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_DeleteQuoteManualProgramData", quoteNumberParameter, tranDT, result);
        }
    
        public virtual int usp_QT_CopyQuoteLTA(string quoteNumber, Nullable<int> lTAYear, Nullable<decimal> percentage, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var lTAYearParameter = lTAYear.HasValue ?
                new ObjectParameter("LTAYear", lTAYear) :
                new ObjectParameter("LTAYear", typeof(int));
    
            var percentageParameter = percentage.HasValue ?
                new ObjectParameter("Percentage", percentage) :
                new ObjectParameter("Percentage", typeof(decimal));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_CopyQuoteLTA", quoteNumberParameter, lTAYearParameter, percentageParameter, tranDT, result);
        }
    
        public virtual int usp_QT_DeleteQuotePrints(string quoteNumber, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_DeleteQuotePrints", quoteNumberParameter, tranDT, result);
        }
    
        public virtual ObjectResult<TotalQuotesReceivedPerYear> usp_QT_Metrics_TotalQuotesReceivedPerYear()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TotalQuotesReceivedPerYear>("usp_QT_Metrics_TotalQuotesReceivedPerYear");
        }
    
        public virtual ObjectResult<QuotesPerMonth> usp_QT_Metrics_QuotesPerMonth()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<QuotesPerMonth>("usp_QT_Metrics_QuotesPerMonth");
        }
    
        public virtual ObjectResult<CompletedQuotes> usp_QT_Metrics_CompletedQuotes()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CompletedQuotes>("usp_QT_Metrics_CompletedQuotes");
        }
    
        public virtual ObjectResult<QuotesCompletedByEstimator> usp_QT_Metrics_QuotesCompletedByEstimator()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<QuotesCompletedByEstimator>("usp_QT_Metrics_QuotesCompletedByEstimator");
        }
    
        public virtual ObjectResult<OnTimeDelivery> usp_QT_Metrics_OnTimeDelivery()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<OnTimeDelivery>("usp_QT_Metrics_OnTimeDelivery");
        }
    
        public virtual ObjectResult<OnTimeByQuoteEngineer> usp_QT_Metrics_OnTimeByQuoteEngineer()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<OnTimeByQuoteEngineer>("usp_QT_Metrics_OnTimeByQuoteEngineer");
        }
    
        public virtual ObjectResult<QuoteRequestsPerMonth> usp_QT_Metrics_QuoteRequestsPerMonth()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<QuoteRequestsPerMonth>("usp_QT_Metrics_QuoteRequestsPerMonth");
        }
    
        public virtual ObjectResult<QuoteRequestsPerMonthSalesperson> usp_QT_Metrics_QuoteRequestsPerMonthSalesperson()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<QuoteRequestsPerMonthSalesperson>("usp_QT_Metrics_QuoteRequestsPerMonthSalesperson");
        }
    
        public virtual ObjectResult<CategoryByQuantity> usp_QT_Metrics_CategoryByQuantity()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CategoryByQuantity>("usp_QT_Metrics_CategoryByQuantity");
        }
    
        public virtual ObjectResult<TopCustomersByQuotes> usp_QT_Metrics_TopCustomersByQuotes()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TopCustomersByQuotes>("usp_QT_Metrics_TopCustomersByQuotes");
        }
    
        public virtual ObjectResult<TopCustomersBySales> usp_QT_Metrics_TopCustomersBySales()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TopCustomersBySales>("usp_QT_Metrics_TopCustomersBySales");
        }
    
        public virtual ObjectResult<TypeOfRequests> usp_QT_Metrics_TypeOfRequests()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TypeOfRequests>("usp_QT_Metrics_TypeOfRequests");
        }
    
        public virtual ObjectResult<TypeOfRequestsPerCustomer> usp_QT_Metrics_TypeOfRequestsPerCustomer()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<TypeOfRequestsPerCustomer>("usp_QT_Metrics_TypeOfRequestsPerCustomer");
        }
    
        public virtual int usp_QT_DeleteCustomerQuoteDoc(string quoteNumber, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_DeleteCustomerQuoteDoc", quoteNumberParameter, tranDT, result);
        }
    
        public virtual int usp_QT_InsertCustomerQuoteDoc(string quoteNumber, string customerQuoteFilePath, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var customerQuoteFilePathParameter = customerQuoteFilePath != null ?
                new ObjectParameter("CustomerQuoteFilePath", customerQuoteFilePath) :
                new ObjectParameter("CustomerQuoteFilePath", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_InsertCustomerQuoteDoc", quoteNumberParameter, customerQuoteFilePathParameter, tranDT, result);
        }
    
        public virtual int usp_QT_Test(Nullable<int> action, string firstName, string lastName, ObjectParameter tranDT, ObjectParameter result)
        {
            var actionParameter = action.HasValue ?
                new ObjectParameter("Action", action) :
                new ObjectParameter("Action", typeof(int));
    
            var firstNameParameter = firstName != null ?
                new ObjectParameter("FirstName", firstName) :
                new ObjectParameter("FirstName", typeof(string));
    
            var lastNameParameter = lastName != null ?
                new ObjectParameter("LastName", lastName) :
                new ObjectParameter("LastName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_Test", actionParameter, firstNameParameter, lastNameParameter, tranDT, result);
        }
    
        public virtual int usp_QT_UpdateQuoteLTA_New(string quoteNumber, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_UpdateQuoteLTA_New", quoteNumberParameter, tranDT, result);
        }
    
        public virtual int usp_QT_InsertQuotePrints(string quoteNumber, string printFilePath, ObjectParameter tranDT, ObjectParameter result)
        {
            var quoteNumberParameter = quoteNumber != null ?
                new ObjectParameter("QuoteNumber", quoteNumber) :
                new ObjectParameter("QuoteNumber", typeof(string));
    
            var printFilePathParameter = printFilePath != null ?
                new ObjectParameter("PrintFilePath", printFilePath) :
                new ObjectParameter("PrintFilePath", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_QT_InsertQuotePrints", quoteNumberParameter, printFilePathParameter, tranDT, result);
        }
    }
}
