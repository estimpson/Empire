//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RmaMaintenance.Model
{
    using System;
    
    public partial class QualityRMA_Details
    {
        public Nullable<int> RMAShipperID { get; set; }
        public Nullable<System.DateTime> RMADateStamp { get; set; }
        public string RMASerialList { get; set; }
        public string RMAStatus { get; set; }
        public Nullable<int> RTVShipperID { get; set; }
        public Nullable<System.DateTime> RTVDateStamp { get; set; }
        public string RTVSerialList { get; set; }
        public string RTVStatus { get; set; }
    }
}
