namespace RmaMaintenance.DataModels
{
    public class ReviewRmaRtvDataModel
    {
        public string ShipperType { get; set; }
        public string Shipper { get; set; }
        public string Part { get; set; }
        public string GlSegment { get; set; }
        public int? TotalSerials { get; set; }
        public decimal? TotalQuantity { get; set; }
    }
}
