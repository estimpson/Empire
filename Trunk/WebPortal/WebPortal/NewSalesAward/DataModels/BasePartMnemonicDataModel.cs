using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebPortal.NewSalesAward.DataModels
{
    [Serializable]
    public class BasePartMnemonicDataModel
    {
        public Decimal? QtyPer { get; set; }
        public Decimal? TakeRate { get; set; }
        public Decimal? FamilyAllocation { get; set; }
    }
}