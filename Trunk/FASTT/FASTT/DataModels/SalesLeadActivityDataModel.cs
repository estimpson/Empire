using System;

namespace FASTT.DataModels
{
    public class SalesLeadActivityDataModel
    {
        public string Customer { get; set; }
        public string Program { get; set; }
        public string Application { get; set; }
        public string Sop { get; set; }
        public string Eop { get; set; }
        public string PeakVolume { get; set; }
        public string LastSalesActivity { get; set; }
        public string Status { get; set; }
        public int? ID { get; set; }
        public int? SalesLeadID { get; set; }
    }
}
