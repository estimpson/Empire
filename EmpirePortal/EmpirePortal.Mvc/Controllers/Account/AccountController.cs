using System.Web.Mvc;
using EmpirePortal.Domain.Sql;

namespace EmpirePortal.Mvc.Controllers.Account
{
    public partial class AccountController : Controller
    {
        protected readonly CorePortalEntities Db;

        public AccountController(CorePortalEntities db)
        {
            Db = db;
        }
    }
}