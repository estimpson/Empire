using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using EmpirePortal.Domain.Sql;
using FxWeb.Mvc.Infrastructure.ViewModels;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public partial class AdministrationController
    {
        public ActionResult Roles()
        {
            var viewModel = new OneGridViewModel
            {
                ViewTitle = "Roles List",
                PartialGridViewActionName = "RolesGridViewPartial",
            };
            return View("_oneGridLayout", viewModel);
        }


        [ValidateInput(false)]
        public ActionResult RolesGridViewPartial()
        {
            var viewModel = Db.Roles.ToList().Select(r => new RoleViewModel
            {
                Name = r.Name,
                Description = r.Description,
            }).ToList();
            return PartialView("_rolesGridView", viewModel);
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult RolesGridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))] RoleViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    Db.AddEntity(new Role
                    {
                        Name = item.Name,
                        Description = item.Description,
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
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";
            return RolesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult RolesGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))] RoleViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var modelItem = Db.Roles.FirstOrDefault(r => r.Name == item.Name);
                    if (modelItem != null)
                    {
                        Db.UpdateEntity(modelItem, new Role
                        {
                            Id = modelItem.Id,
                            Name = item.Name,
                            Description = item.Description,
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
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";
            return RolesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult RolesGridViewPartialDelete(string roleName)
        {
            if (string.IsNullOrEmpty(roleName)) return RolesGridViewPartial();
            {
                try
                {
                    Db.DeleteRole(roleName);
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
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " + e.InnerException?.InnerException?.Message;
                }
            }
            return RolesGridViewPartial();
        }

        public ActionResult RoleMembershipGridViewPartial([ModelBinder(typeof(DevExpressEditorsBinder))] RoleViewModel item)
        {
            var roleUsers = Db.Roles.Single(r => r.Name == item.Name).Users;
            var viewModel = Db.Users.ToList().Select(u => new RoleUserViewModel
            {
                RoleName = item.Name,
                UserName = u.UserName,
                FullName = $"{u.LastName}, {u.FirstName} {u.MiddleName}",
                IsMember = roleUsers.Any(ru=> ru.UserName == u.UserName),
            }).ToList();
            ViewData["RoleViewModel"] = item;
            return PartialView("_roleMembersGridView", viewModel);
        }

        public ActionResult RoleUserBatchEditingUpdateModel(
            MVCxGridViewBatchUpdateValues<RoleUserViewModel, string> updateValues, string roleName)
        {
            var role = Db.Roles.Single(r => r.Name == roleName);
            foreach (var roleUserViewModel in updateValues.Update)
            {
                if (!updateValues.IsValid(roleUserViewModel)) continue;
                var user = Db.Users.Single(u => u.UserName == roleUserViewModel.UserName);
                if (roleUserViewModel.IsMember)
                {
                    if (!role.Users.Contains(user))
                    {
                        role.Users.Add((User)user);
                    }
                }
                else
                {
                    if (role.Users.Contains(user))
                    {
                        role.Users.Remove((User)user);
                    }
                }
            }

            Db.SaveChanges();

            return RoleMembershipGridViewPartial(new RoleViewModel { Name = role.Name, Description = role.Description });
        }
    }

    public class RoleUserViewModel
    {
        public string RoleName { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public bool IsMember { get; set; }
    }
}