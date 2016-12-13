﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FASTT.DataModels
{
    public class ReportTopLeadsDataModel
    {
        public int? PeakVolume { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string Application { get; set; }
        public string BulbType { get; set; }
        public string Region { get; set; }
        public string SOP { get; set; }
        public string EOP { get; set; }
        public string SalesLeadStatus { get; set; }
        public string SalesPerson { get; set; }
        public string AwardedVolume { get; set; }
        public int? RowId { get; set; }
        public int? CombinedLightingStudyId { get; set; }
    }
}