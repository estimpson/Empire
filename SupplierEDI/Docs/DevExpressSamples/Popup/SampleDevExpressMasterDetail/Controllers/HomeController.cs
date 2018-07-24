using SampleDevExpressMasterDetail.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SampleDevExpressMasterDetail.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        [ValidateInput(false)]
        public ActionResult MasterPartial()
        {
            var model = SampleDevExpressMasterDetail.Models.DB_Source_MasterModel.ItemsList;

            return PartialView("_MasterPartial", model);
        }

        [ValidateInput(false)]
        public ActionResult MasterCustomActionPartial(int detailId) {
            SampleDevExpressMasterDetail.Models.DB_Source_DetailModel.ItemsList.Where(c => c.ID == detailId).FirstOrDefault().DetailName =
                SampleDevExpressMasterDetail.Models.DB_Source_DetailModel.ItemsList.Where(c => c.ID == detailId).FirstOrDefault().DetailName.ToUpper();
  
            return PartialView("_MasterPartial", SampleDevExpressMasterDetail.Models.DB_Source_MasterModel.ItemsList);
        }

        [ValidateInput(false)]
        public ActionResult DetailPartial(int masterID)
        {
            ViewBag.MasterID = masterID;
            var model = SampleDevExpressMasterDetail.Models.DB_Source_DetailModel.ItemsList.Where(c => c.MasterID == masterID);

            return PartialView("_DetailPartial", model);
        }

        [HttpPost]
        public ActionResult PopUpPostAction()
        {
            var value = Request.Params["hiddenID"];
            int intID = int.Parse(value);
            SampleDevExpressMasterDetail.Models.DB_Source_DetailModel.ItemsList.Where(c => c.ID == intID).FirstOrDefault().DetailName =
                SampleDevExpressMasterDetail.Models.DB_Source_DetailModel.ItemsList.Where(c => c.ID == intID).FirstOrDefault().DetailName.ToUpper();
            return View("Index");
        }
    }
}