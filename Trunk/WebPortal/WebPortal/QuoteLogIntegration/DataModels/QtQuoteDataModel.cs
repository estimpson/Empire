using System;

namespace WebPortal.QuoteLogIntegration.DataModels
{
    [Serializable]
    public class QtQuoteDataModel
    {
        public String QuoteNumber { get; set; }
        public DateTime Date { get; set; }
        public String Customer { get; set; }
        public String EmpirePartNumber { get; set; }
        public String CustomerPartNumber { get; set; }
        public String Program { get; set; }
        public String Application { get; set; }
        public Decimal? FinancialEau { get; set; }
        public Decimal? CapactiyEau { get; set; }
        public String Salesman { get; set; }
        public String QuoteEngineer { get; set; }
        public Decimal? QuotePrice { get; set; }
        public Decimal? LtaYear1 { get; set; }
        public Decimal? LtaYear2 { get; set; }
        public Decimal? LtaYear3 { get; set; }
        public Decimal? LtaYear4 { get; set; }
        public Decimal? PrototypePrice { get; set; }
        public int MinimumOrderQuantity { get; set; }
        public Decimal? Material { get; set; }
        public Decimal? Labor { get; set; }
        public Decimal? Tooling { get; set; }
    }
}