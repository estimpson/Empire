//------------------------------------------------------------------------------
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
    
    public partial class usp_PlanningSnapshot_Q_GetSnapshotCalendar_Result
    {
        public Nullable<System.DateTime> CalendarDT { get; set; }
        public string DailyWeekly { get; set; }
        public Nullable<int> WeekNo { get; set; }
        public string Holiday { get; set; }
        public Nullable<System.DateTime> EEIContainerDT { get; set; }
        public Nullable<System.DateTime> SchedulingDT { get; set; }
        public Nullable<int> PlanningDays { get; set; }
        public Nullable<decimal> CustomerRequirement { get; set; }
        public Nullable<decimal> OverrideCustomerRequirement { get; set; }
        public Nullable<decimal> InTransQty { get; set; }
        public Nullable<decimal> OnOrderEEH { get; set; }
        public Nullable<decimal> NewOnOrderEEH { get; set; }
        public Nullable<decimal> TotalInventory { get; set; }
        public Nullable<decimal> Balance { get; set; }
        public Nullable<decimal> WeeksOnHand { get; set; }
        public Nullable<byte> WeeksOnHandWarnFlag { get; set; }
        public Nullable<int> RowID { get; set; }
    }
}
