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
    public partial class usp_GetAwardedQuoteProductionPOs_Result
    {
        public string QuoteNumber { get; set; }
        public string BasePart { get; set; }
        public string PONumber { get; set; }
        public string PurchaseOrderFileName { get; set; }
        public Nullable<System.DateTime> PurchaseOrderDT { get; set; }
        public string AlternativeCustomerCommitment { get; set; }
        public Nullable<decimal> SellingPrice { get; set; }
        public Nullable<System.DateTime> PurchaseOrderSOP { get; set; }
        public Nullable<System.DateTime> PurchaseOrderEOP { get; set; }
        public string Comments { get; set; }
    }
}