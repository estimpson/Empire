using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using EmpirePortal.Mvc.App_Start;
using FxWeb.Mvc.Infrastructure.Security.Authorization;
using Newtonsoft.Json;

namespace EmpirePortal.Mvc
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            DependencyInjectionConfig.RegisterTypes();
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            ModelBinders.Binders.DefaultBinder = new DevExpress.Web.Mvc.DevExpressEditorsBinder();
        }

        protected void Application_PostAuthenticateRequest(object sender, EventArgs e)
        {
            var authCookie = Request.Cookies["User"];
            if (authCookie == null) return;
            var authTicket = FormsAuthentication.Decrypt(authCookie.Value);
            if (authTicket == null) return;
            var serializeModel = JsonConvert.DeserializeObject<FxSerializeUserModel>(authTicket.UserData);

            var principal = new FxPrincipal(authTicket.Name)
            {
                UserId = serializeModel.UserId,
                FirstName = serializeModel.FirstName,
                LastName = serializeModel.LastName,
                SecurityGuid = serializeModel.SecurityGuid,
                Roles = serializeModel.RoleName?.ToArray()
            };

            HttpContext.Current.User = principal;
        }
    }
}
