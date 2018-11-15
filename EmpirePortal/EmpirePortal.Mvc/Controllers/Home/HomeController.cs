using System.Linq;
using System.Web.Mvc;
using EmpirePortal.Domain.Sql;

namespace EmpirePortal.Mvc.Controllers.Home
{
    public class HomeController : Controller
    {
        private CorePortalEntities Db = new CorePortalEntities();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ModuleMenu()
        {
            var viewModel = new ModuleMenuViewModel
            {
                Data = Db.MenuItems.Where(mi => mi.IsModule).OrderBy(mi => mi.MenuOrder).ToList().Select(mi =>
                    new ModuleMenuItemViewModel(mi))
            };

            return PartialView("_topMenu", viewModel);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}