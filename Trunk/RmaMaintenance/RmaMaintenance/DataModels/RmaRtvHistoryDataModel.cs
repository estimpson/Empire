namespace RmaMaintenance.DataModels
{
    public class RmaRtvHistoryDataModel
    {
        public string Type { get; set; }
        public string Shipper { get; set; }
        public int Serial { get; set; }
        public string Part { get; set; }
        public string GlSegment { get; set; }
        public string Quantity { get; set; }
        public string AuditTrailDate { get; set; }
    }
}
