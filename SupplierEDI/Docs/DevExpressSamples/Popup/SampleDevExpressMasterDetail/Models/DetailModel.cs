using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SampleDevExpressMasterDetail.Models
{
    public class DetailModel
    {
        public int ID { get; set; }
        public string DetailName { get; set; }
        public int MasterID { get; set; }
    }

    public static class DB_Source_DetailModel
    {
        public static List<DetailModel> ItemsList = new List<DetailModel>
        {
            new DetailModel() {ID = 11, DetailName="DetailItem11", MasterID = 1},
            new DetailModel() {ID = 12, DetailName="DetailItem12", MasterID = 1},
            new DetailModel() {ID = 13, DetailName="DetailItem13", MasterID = 1},
            new DetailModel() {ID = 21, DetailName="DetailItem21", MasterID = 2},
            new DetailModel() {ID = 22, DetailName="DetailItem22", MasterID = 2},
            new DetailModel() {ID = 23, DetailName="DetailItem23", MasterID = 2},
            new DetailModel() {ID = 31, DetailName="DetailItem31", MasterID = 3},
            new DetailModel() {ID = 32, DetailName="DetailItem32", MasterID = 3}
        };
    }
}