using System;

namespace WebPortal.QuoteLogIntegration.DataModels
{
    [Serializable]
    public class QtSignOffDataModel
    {
        public int RowID { get; set; }
        public String Title { get; set; }
        public DateTime? SignOffDate { get; set; }
        public String EmployeeCode { get; set; }
        public String EmployeeName { get; set; }
        public String Initials { get; set; }
    }
}