//------------------------------------------------------------------------------
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
    
    public partial class usp_ST_SalesLeadLog_GetActivityHistory_Result
    {
        public string SalesPerson { get; set; }
        public string StatusType { get; set; }
        public string Activity { get; set; }
        public Nullable<System.DateTime> ActivityDate { get; set; }
        public string ContactName { get; set; }
        public string ContactPhoneNumber { get; set; }
        public string ContactEmailAddress { get; set; }
        public Nullable<decimal> Duration { get; set; }
        public string Notes { get; set; }
        public string QuoteNumber { get; set; }
        public Nullable<int> AwardedVolume { get; set; }
        public int RowID { get; set; }
    }
}
