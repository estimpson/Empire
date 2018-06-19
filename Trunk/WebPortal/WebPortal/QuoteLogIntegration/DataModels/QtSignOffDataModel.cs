using System;

namespace WebPortal.QuoteLogIntegration.DataModels
{
    [Serializable]
    public class QtSignOffDataModel
    {
        public int RowID { get; set; }
        public String Title { get; set; }
        public String Initials { get; set; }
        public DateTime? SignOffDate { get; set; }
    }
}