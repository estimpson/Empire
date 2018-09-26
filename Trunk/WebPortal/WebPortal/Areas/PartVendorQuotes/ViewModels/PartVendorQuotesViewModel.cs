using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebPortal.Areas.PartVendorQuotes.Models;

namespace WebPortal.Areas.PartVendorQuotes.ViewModels
{
    public class PartVendorQuotesViewModel
    {
        public List<usp_GetPartVendorQuotes_Result> PartVendorQuotes { get; set; }
        public List<usp_GetParts_Result> Parts { get; set; }
        public List<usp_GetVendors_Result> Vendors { get; set; }
        public List<usp_GetOems_Result> Oems { get; set; }
    }
}