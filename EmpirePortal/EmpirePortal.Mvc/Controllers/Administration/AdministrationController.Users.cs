using System;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Web.Mvc;
using EmpirePortal.Domain.Sql;
using FxWeb.Domain.Core.Types;
using FxWeb.Mvc.Infrastructure.ActionFilters;
using FxWeb.Mvc.Infrastructure.DataServices;
using FxWeb.Mvc.Infrastructure.Security.Authentication;
using FxWeb.Mvc.Infrastructure.ViewModels;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public partial class AdministrationController
    {
        public ActionResult Users()
        {
            var viewModel = new OneGridViewModel
            {
                ViewTitle = "Users List",
                PartialGridViewActionName = "UsersGridViewPartial",
            };
            return View("_oneGridLayout", viewModel);
        }

        [ValidateInput(false)]
        public ActionResult UsersGridViewPartial()
        {
            var viewModel = Db.Users.ToList().Select(u => new UserViewModel
            {
                UserName = u.UserName,
                FirstName = u.FirstName,
                MiddleName = u.MiddleName,
                LastName = u.LastName,
                EmailAddress = u.EmailAddress,
                IsAccountActive = u.IsAccountActive,
                CurrentPasswordHash = u.PasswordHash,
                MonitorOperator_EEH = u.MonitorOperator_EEH,
                MonitorOperator_EEI = u.MonitorOperator_EEI,
            }).ToList();
            return PartialView("_usersGridView", viewModel);
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult UsersGridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))]
            UserViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    Db.AddEntity(new User
                    {
                        UserName = item.UserName,
                        Person = new Person
                        {
                            FirstName = item.FirstName,
                            MiddleName = item.MiddleName,
                            LastName = item.LastName
                        },
                        PasswordHash = PasswordHelper.HashPassword(item.ConfirmNewAccountPassword),
                        EmailAddress = item.EmailAddress,
                        IsActive = item.IsAccountActive,
                        MonitorOperator_EEH = item.MonitorOperator_EEH,
                        MonitorOperator_EEI = item.MonitorOperator_EEI,
                    });
                    Db.SaveChanges();
                }
                catch (DbEntityValidationException e)
                {
                    ViewData["EditError"] = "DbEntityValidationException: "
                                            + string.Join("; ",
                                                e.EntityValidationErrors.Select(eve =>
                                                        string.Join(", ",
                                                            eve.ValidationErrors.Select(ve =>
                                                                $"{ve.PropertyName}: {ve.ErrorMessage}").ToList()))
                                                    .ToList());
                }
                catch (SqlException e)
                {
                    ViewData["EditError"] = $"SqlException: {e.Message} {e.InnerException?.Message}";
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = $"Exception: {e.Message} {e.InnerException?.Message}";
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return UsersGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult UsersGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))]
            UserViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var modelItem = Db.Users.FirstOrDefault(u => u.UserName == item.UserName);
                    if (modelItem != null)
                    {
                        Db.UpdateEntity(modelItem, new User
                        {
                            Id = modelItem.Id,
                            UserName = item.UserName,
                            Person = new Person
                            {
                                FirstName = item.FirstName,
                                MiddleName = item.MiddleName,
                                LastName = item.LastName
                            },
                            PasswordHash = !string.IsNullOrEmpty(item.ConfirmChangePassword)
                                ? PasswordHelper.HashPassword(item.ConfirmChangePassword)
                                : modelItem.PasswordHash,
                            SecurityGuid = modelItem.SecurityGuid,
                            EmailAddress = item.EmailAddress,
                            IsAccountActive = true,
                            IsPasswordActive = true,
                            MonitorOperator_EEH = item.MonitorOperator_EEH,
                            MonitorOperator_EEI = item.MonitorOperator_EEI,
                        });
                        Db.SaveChanges();
                    }
                }
                catch (DbEntityValidationException e)
                {
                    ViewData["EditError"] = "DbEntityValidationException: "
                                            + string.Join("; ",
                                                e.EntityValidationErrors.Select(eve =>
                                                        string.Join(", ",
                                                            eve.ValidationErrors.Select(ve =>
                                                                $"{ve.PropertyName}: {ve.ErrorMessage}").ToList()))
                                                    .ToList());
                }
                catch (SqlException e)
                {
                    ViewData["EditError"] = $"SqlException: {e.Message} {e.InnerException?.Message}";
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = $"Exception: {e.Message} {e.InnerException?.Message}";
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return UsersGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult UsersGridViewPartialDelete(string userName)
        {
            if (string.IsNullOrEmpty(userName)) return UsersGridViewPartial();
            try
            {
                Db.DeleteUser(userName);
            }
            catch (Exception e)
            {
                ViewData["EditError"] = e.Message;
            }

            return UsersGridViewPartial();
        }


        //[Log("EehMonitorOperatorsComboBoxPartialInGrid")]
        public ActionResult EehMonitorOperatorsComboBoxPartialInGrid()
        {
            MVCxColumnComboBoxProperties p = new MVCxColumnComboBoxProperties();
            p.CallbackPageSize = 30;
            p.CallbackRouteValues = new { Controller = "Administration", Action = "EehMonitorOperatorsComboBoxPartialInGrid" };
            p.FilterMinLength = 0;

            p.Width = Unit.Percentage(100);
            p.DropDownStyle = DropDownStyle.DropDownList;
            p.Columns.Add("FullName");
            p.Columns.Add("MonitorOperatorCode");
            p.TextField = "MonitorOperatorCode";
            p.ValueField = "MonitorOperatorCode";
            p.ValueType = typeof(string);
            //p.BindList(CoreDbContextService.Db.GetMonitorOperators("EEH").OrderBy(mo=>mo.FullName));
            p.BindList(CoreDbContextService.Db.GetEehMonitorOperatorsRange
                , CoreDbContextService.Db.GetEehMonitorOperatorsByOperator);

            return GridViewExtension.GetComboBoxCallbackResult(p);
        }
    }
}