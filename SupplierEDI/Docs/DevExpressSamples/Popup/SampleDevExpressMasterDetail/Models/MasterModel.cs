using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SampleDevExpressMasterDetail.Models
{
    public class MasterModel
    {
        public int ID { get; set; }
        public string MasterName { get; set; }
    }

    public static class DB_Source_MasterModel
    {
        public static List<MasterModel> ItemsList = new List<MasterModel>
        {
            new MasterModel() {ID = 1, MasterName="DetailItem11"},
            new MasterModel() {ID = 2, MasterName="DetailItem12"},
            new MasterModel() {ID = 3, MasterName="DetailItem13"}
        };
    }
}