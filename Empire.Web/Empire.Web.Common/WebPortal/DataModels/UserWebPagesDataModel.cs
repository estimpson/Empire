using System;

namespace WebPortal.DataModels
{
    [Serializable]
    public class UserWebPagesDataModel
    {
        public string WebPage { get; set; }
        public string FilePath { get; set; }
        public int? DefaultPage { get; set; }
    }
}