
namespace FASTT.DataModels
{
    public class ReportOpenQuotesDataModel
    {
        public string Status { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string ApplicationName { get; set; }
        public string SalesInitials { get; set; }
        public string Sop { get; set; }
        public string Eop { get; set; }
        public string EeiPartNumber { get; set; }
        public decimal? TotalQuotedSales { get; set; }
        public string Notes { get; set; }
        public string QuoteNumber { get; set; }
    }
}
