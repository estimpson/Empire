namespace RmaMaintenance.DataModels
{
    public class RmaRtvHistoryByShipperDataModel
    {
        public string Type { get; set; }
        public string Shipper { get; set; }
        public string Serial { get; set; }
        public string Part { get; set; }
        public string GlSegment { get; set; }
        public string Quantity { get; set; }
        public string AuditTrailDate { get; set; }
        public string FromLocation { get; set; }
        public string ToLocation { get; set; }
    }
}
