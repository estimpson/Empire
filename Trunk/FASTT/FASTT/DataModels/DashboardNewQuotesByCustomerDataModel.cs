
namespace FASTT.DataModels
{
    public class DashboardNewQuotesByCustomerDataModel
    {
        public string QuoteStatus { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string ApplicationName { get; set; }
        public string SalesInitials { get; set; }
        public string Sop { get; set; }
        public string Eop { get; set; }
        public string EeiPartNumber { get; set; }
        public decimal? TotalQuotedSales { get; set; }
        public string Notes { get; set; }
        public decimal? Eau { get; set; }
        public decimal? QuotePrice { get; set; }
        public string QuotePricingDate { get; set; }
        public string Awarded { get; set; }
        public string MaterialPercentage { get; set; }
    }
}
