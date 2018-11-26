using System.Web.Mvc;

namespace EmpirePortal.Mvc.Controllers.Evision
{
    public class EvisionController : Controller
    {
        public ActionResult Legacy(string legacyUrl)
        {
            var viewModel = new LegacyViewModel
            {
                LegacyUrl = legacyUrl ?? "http://evision/WebPortal/NewSalesAward/Pages/NewSalesAward",
            };
            return View(viewModel);
        }
    }
}