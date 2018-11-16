using System.Collections.Generic;
using System.Web.Mvc;
using EmpirePortal.Domain.Sql;
using FxWeb.Domain.Core;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public partial class AdministrationController : Controller
    {
        protected readonly CorePortalEntities Db;

        public AdministrationController(CorePortalEntities db)
        {
            Db = db;
        }
    }
}