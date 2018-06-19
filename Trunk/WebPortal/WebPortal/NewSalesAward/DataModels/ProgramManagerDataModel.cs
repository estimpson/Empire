using System;

namespace WebPortal.NewSalesAward.DataModels
{
    [Serializable]
    public class ProgramManagerDataModel
    {
        public String UserCode { get; set; }
        public String UserName { get; set; }
        public String UserInitials { get; set; }
        public String EmailAddress { get; set; }
    }
}