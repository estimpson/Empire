using System;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using AutoMapper.QueryableExtensions;
using DevExpress.Web.Mvc;
using EmpirePortal.Domain.Sql;
using FxWeb.Mvc.Infrastructure.ActionFilters;
using FxWeb.Mvc.Infrastructure.Alerts;
using FxWeb.Mvc.Infrastructure.DevExpress.GridView;
using FxWeb.Mvc.Infrastructure.ViewModels;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public partial class AdministrationController
    {
        public ActionResult MenuDefinitions()
        {
            var viewModel = new OneGridViewModel
            {
                ViewTitle = "Menu Definition",
                PartialGridViewActionName = "IndentedMenuDefinitionGridViewPartial",
            };
            return View("_oneGridLayout", viewModel);
        }

        [ValidateInput(false)]
        public ActionResult IndentedMenuDefinitionGridViewPartial()
        {
            var model = Db.MenuItemTree.OrderBy(m => m.Sequence).ToList();
            var viewModel = Db.MenuItemTree.OrderBy(m => m.Sequence).ProjectTo<MenuItemNodeViewModel>().ToList();
            TempData.SetGridViewHelper(new IndentedMenuDefinitionGridViewHelper());

            return PartialView("_standardGridView", viewModel);
        }

        [HttpPost, ValidateInput(false)]
        //[Log("New menu {item.ParentMenuName}.{item.PartialName}")]
        public ActionResult IndentedMenuDefinitionGridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))]
            MenuItemNodeViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var parentMenu = Db.MenuItems.FirstOrDefault(m => m.ShortName == item.ParentMenuName);
                    Db.AddEntity(new MenuItem
                    {
                        ShortName = string.IsNullOrEmpty(item.ParentMenuName) ? $"{item.PartialName}" : $"{item.ParentMenuName}.{item.PartialName}",
                        Caption = item.Caption,
                        Url = item.Url,
                        IsModule = string.IsNullOrEmpty(item.ParentMenuName),
                        ParentMenuItem = (MenuItem)parentMenu,
                        MenuOrder = item.MenuOrder ??
                                    parentMenu?.ChildMenuItems?.Max(cm => cm.MenuOrder as decimal?) + 1 ?? 0,
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
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                            e.InnerException?.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                            e.InnerException?.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return string.IsNullOrEmpty(ViewData["EditError"]?.ToString())
                ? IndentedMenuDefinitionGridViewPartial()
                    .WithSuccess("Menu created!")
                : IndentedMenuDefinitionGridViewPartial()
                    .WithWarning("Save failed!");
        }

        [HttpPost, ValidateInput(false)]
        [Log("Update menu {item.ParentMenuName}.{item.PartialName}")]
        public ActionResult IndentedMenuDefinitionGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))]
            MenuItemNodeViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var modelItem = Db.MenuItems.SingleOrDefault(mi =>
                        mi.ShortName == item.ParentMenuName + "." + item.PartialName);

                    var parentMenu = Db.MenuItems.FirstOrDefault(m => m.ShortName == item.ParentMenuName);

                    if (modelItem != null)
                    {
                        Db.UpdateEntity(modelItem, new MenuItem
                        {
                            Id = modelItem.Id,
                            ShortName = string.IsNullOrEmpty(item.ParentMenuName) ? $"{item.PartialName}" : $"{item.ParentMenuName}.{item.PartialName}",
                            Caption = item.Caption,
                            Url = item.Url,
                            IsModule = string.IsNullOrEmpty(item.ParentMenuName),
                            ParentMenuItem = (MenuItem)parentMenu,
                            MenuOrder = item.MenuOrder ??
                                        parentMenu?.ChildMenuItems?.Max(cm => cm.MenuOrder as decimal?) + 1 ?? 0,
                            AssetGuid = modelItem.AssetGuid,
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
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                            e.InnerException?.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                            e.InnerException?.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return string.IsNullOrEmpty(ViewData["EditError"]?.ToString())
                ? IndentedMenuDefinitionGridViewPartial()
                    .WithSuccess("Menu updated!")
                : IndentedMenuDefinitionGridViewPartial()
                    .WithWarning("Save failed!");
        }

        [HttpPost, ValidateInput(false)]
        //[Log("Delete menu {id}")]
        public ActionResult IndentedMenuDefinitionGridViewPartialDelete(int id)
        {
            if (id < 0) return IndentedMenuDefinitionGridViewPartial();
            try
            {
                Db.DeleteMenuItem(id);
            }
            catch (SqlException e)
            {
                ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                        e.InnerException?.InnerException?.Message;
            }
            catch (Exception e)
            {
                ViewData["EditError"] = e.Message + ". " + e.InnerException?.Message + ". " +
                                        e.InnerException?.InnerException?.Message;
            }

            return string.IsNullOrEmpty(ViewData["EditError"]?.ToString())
                ? IndentedMenuDefinitionGridViewPartial()
                    .WithSuccess("Menu deleted!")
                : IndentedMenuDefinitionGridViewPartial()
                    .WithWarning("Delete failed!");
        }
    }
}