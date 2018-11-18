using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using FxWeb.Mvc.Infrastructure.Security.Authorization;
using Newtonsoft.Json;

namespace EmpirePortal.Mvc.Controllers.Account
{
    public partial class AccountController
    {
        public ActionResult LoginModal()
        {
            return View("_loginPopup");
        }

        public ActionResult AttemptLogin(LoginViewModel form)
        {
            if (ModelState.IsValid)
            {
                if (Membership.ValidateUser(form.UserName, form.Password))
                {
                    var user = (FxMembershipUser) Membership.GetUser(form.UserName, false);
                    if (user != null)
                    {
                        var userModel = new FxSerializeUserModel
                        {
                            UserId = user.UserId,
                            FirstName = user.FirstName,
                            LastName = user.LastName,
                            SecurityGuid = user.SecurityGuid,
                            RoleName = user.Roles?.Select(r => r.Name).ToList(),
                        };

                        var userData = JsonConvert.SerializeObject(userModel);
                        var authTicket = new FormsAuthenticationTicket(version: 1, name: form.UserName,
                            issueDate: DateTime.Now, expiration: DateTime.Now.AddMinutes(15), isPersistent: false,
                            userData: userData);

                        var enTicket = FormsAuthentication.Encrypt(authTicket);
                        var faCookie = new HttpCookie(name: "User", value: enTicket);
                        Response.Cookies.Add(faCookie);
                    }

                    return RedirectToAction(actionName: "index", controllerName: "Home");
                }
           }

            ModelState.AddModelError(key: "UserName", errorMessage: "User Name or Password invalid.");
            return View("_loginPopup");
        }
    }
}