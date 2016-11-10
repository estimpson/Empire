using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImportSpreadsheetData.DataModels
{
    public class SalesOrderDataModel
    {
        public int OrderNo { get; set; }
        public string CustomerPart { get; set; }
        public string BlanketPart { get; set; }
        public string ModelYear { get; set; }
    }
}
