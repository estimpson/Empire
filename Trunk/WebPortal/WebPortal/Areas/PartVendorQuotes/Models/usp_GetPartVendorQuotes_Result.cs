//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebPortal.Areas.PartVendorQuotes.Models
{
    using System;
    
    public partial class usp_GetPartVendorQuotes_Result
    {
        public int RowID { get; set; }
        public string VendorCode { get; set; }
        public string PartCode { get; set; }
        public string Oem { get; set; }
        public Nullable<System.DateTime> EffectiveDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public Nullable<decimal> Price { get; set; }
        public string QuoteFileName { get; set; }
    }
}
