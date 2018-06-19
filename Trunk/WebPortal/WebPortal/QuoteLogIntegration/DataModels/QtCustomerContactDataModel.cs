using System;

namespace WebPortal.QuoteLogIntegration.DataModels
{
    [Serializable]
    public class QtCustomerContactDataModel
    {
        public String Title { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Phone { get; set; }
        public String Fax { get; set; }
        public String Email { get; set; }
    }
}