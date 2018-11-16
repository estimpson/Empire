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
    
    [Serializable]
    public partial class usp_GetAwardedQuoteCSMData_Result
    {
        public string ReleaseID { get; set; }
        public string VehiclePlantMnemonic { get; set; }
        public string Platform { get; set; }
        public string Program { get; set; }
        public string Vehicle { get; set; }
        public string Manufacturer { get; set; }
        public string SourcePlant { get; set; }
        public string SourcePlantCountry { get; set; }
        public string SourcePlantRegion { get; set; }
        public Nullable<System.DateTime> CSM_SOP { get; set; }
        public Nullable<System.DateTime> CSM_EOP { get; set; }
        public int ActiveFlag { get; set; }
        public Nullable<decimal> DemandYear1 { get; set; }
        public Nullable<decimal> DemandYear2 { get; set; }
        public Nullable<decimal> DemandYear3 { get; set; }
        public long RowID { get; set; }
    }
}
