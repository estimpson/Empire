using System;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Areas.PartVendorQuotes.ViewModels
{
    public class PartVendorQuoteViewModel
    {
        [Key]
        public int RowID { get; set; }
        [Required]
        public string VendorCode { get; set; }
        [Required]
        public string PartCode { get; set; }
        public string Oem { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal? Price { get; set; }
        public string QuoteFileName { get; set; }
    }
}