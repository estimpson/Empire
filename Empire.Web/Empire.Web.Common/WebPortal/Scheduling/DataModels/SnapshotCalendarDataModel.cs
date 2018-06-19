using System;

namespace WebPortal.Scheduling.DataModels
{
    [Serializable]
    public class SnapshotCalendarDataModel
    {
        public string CalendarDT { get; set; }
        public string DailyWeekly { get; set; }
        public int? WeekNo { get; set; }
        public string Holiday { get; set; }
        public string EEIContainerDT { get; set; }
        public string SchedulingDT { get; set; }
        public int? PlanningDays { get; set; }
        public string CustomerRequirement { get; set; }
        public string OverrideCustomerRequirement { get; set; }
        public string InTransQty { get; set; }
        public string OnOrderEEH { get; set; }
        public string NewOnOrderEEH { get; set; }
        public string TotalInventory { get; set; }
        public string Balance { get; set; }
        public string WeeksOnHand { get; set; }
        public int? WeeksOnHandWarnFlag { get; set; }
        public int? RowID { get; set; }
    }
}