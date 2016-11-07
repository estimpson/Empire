using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FASTT.DataModels
{
    public class ReportNewQuotesDataModel
    {
        public string QuoteNumber { get; set; }
        public string QuoteStatus { get; set; }
        public string Program { get; set; }
        public string ApplicationName { get; set; }
        public string Customer { get; set; }
        public string SalesInitials { get; set; }
        public string Sop { get; set; }
        public string EeiPartNumber { get; set; }
        public string TotalQuotedSales { get; set; }
    }
}
