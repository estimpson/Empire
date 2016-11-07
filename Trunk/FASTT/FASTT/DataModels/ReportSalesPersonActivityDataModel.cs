
namespace FASTT.DataModels
{
    public class ReportSalesPersonActivityDataModel
    {
        public string SalesPerson { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string Application { get; set; }
        public string SOP { get; set; }
        public string EOP { get; set; }
        public string PeakVolume { get; set; }
        public string Status { get; set; }
        public string ActivityDate { get; set; }
        public string Activity { get; set; }
        public string MeetingLocation { get; set; }
        public string ContactName { get; set; }
        public string ContactPhoneNumber { get; set; }
        public string ContactEmailAddress { get; set; }
        public string Duration { get; set; }
        public string Notes { get; set; }
        public string SalesPersonCode { get; set; }
        public int RowId { get; set; }
        public int? CombinedLightingStudyId { get; set; }
    }
}
