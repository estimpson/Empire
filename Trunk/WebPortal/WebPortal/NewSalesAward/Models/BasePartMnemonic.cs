//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebPortal.NewSalesAward.Models
{
    using System;
    using System.Collections.Generic;
    
    [Serializable]
    public partial class BasePartMnemonic
    {
        public string QuoteNumber { get; set; }
        public string ReleaseID { get; set; }
        public string VehiclePlantMnemonic { get; set; }
        public string BasePart { get; set; }
        public Nullable<decimal> QtyPer { get; set; }
        public Nullable<decimal> TakeRate { get; set; }
        public Nullable<decimal> FamilyAllocation { get; set; }
        public string Platform { get; set; }
        public string Program { get; set; }
        public string Vehicle { get; set; }
        public string Manufacturer { get; set; }
        public string Family { get; set; }
        public string SourcePlant { get; set; }
        public string SourcePlantCountry { get; set; }
        public string SourcePlantRegion { get; set; }
        public Nullable<System.DateTime> CSM_SOP { get; set; }
        public Nullable<System.DateTime> CSM_EOP { get; set; }
        public Nullable<decimal> EAU { get; set; }
        public Nullable<decimal> QuotedEAU { get; set; }
    }
}
