using System;

namespace WebPortal.Scheduling.DataModels
{
    [Serializable]
    public class HeaderInfoDataModel
    {
        public string CustomerPart { get; set; }
        public string Description { get; set; }
        public string StandardPack { get; set; }
        public string DefaultPo { get; set; }
        public string SalesPrice { get; set; }
        public string AbcClass1 { get; set; }
        public string AbcClass2 { get; set; }
        public string EauEei { get; set; }
        public string EehCapacity { get; set; }
        public string Sop { get; set; }
        public string Eop { get; set; }
    }
}