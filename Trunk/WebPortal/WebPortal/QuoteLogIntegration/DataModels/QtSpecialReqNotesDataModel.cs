using System;

namespace WebPortal.QuoteLogIntegration.DataModels
{
    [Serializable]
    public class QtSpecialReqNotesDataModel
    {
        public int RowID { get; set; }
        public String Description { get; set; }
        public String Answer { get; set; }
        public String Notes { get; set; }
    }
}