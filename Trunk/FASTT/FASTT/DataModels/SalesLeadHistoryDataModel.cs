﻿using System;

namespace FASTT.DataModels
{
    public class SalesLeadHistoryDataModel
    {
        public string SalesPerson { get; set; }
        public string Status { get; set; }
        public string Activity { get; set; }
        public DateTime? ActivityDate { get; set; }
        public decimal? Duration { get; set; }
        public string ContactName { get; set; }
        public string ContactPhoneNumber { get; set; }
        public string ContactEmailAddress { get; set; }
        public string Notes { get; set; }
        public string QuoteNumber { get; set; }
        public string AwardedVolume { get; set; }
        public int RowId { get; set; }
    }
}
