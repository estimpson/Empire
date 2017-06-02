namespace RmaMaintenance.DataModels
{
    public class RmaRtvHistoryByShipperDataModel
    {
        public string Type { get; set; }
        public string RmaRtvNumber { get; set; }
        public int Serial { get; set; }
        public string Part { get; set; }
        public string GlSegment { get; set; }
        public string Quantity { get; set; }
        public string AuditTrailDate { get; set; }
    }
}
