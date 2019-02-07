using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Web.Mvc;
using FxWeb.Mvc.Infrastructure.DataServices;
using FxWeb.Mvc.Infrastructure.DevExpress.GridView;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public class IndentedMenuDefinitionGridViewHelper : GridViewHelperBase
    {
        public override void SetCrudActionRoutes(GridViewSettings settings)
        {
            settings.CallbackRouteValues = new
            {
                Controller = "Administration",
                Action = "IndentedMenuDefinitionGridViewPartial"
            };

            settings.SettingsEditing.AddNewRowRouteValues = new { Controller = "Administration", Action = "IndentedMenuDefinitionGridViewPartialAddNew" };
            settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "Administration", Action = "IndentedMenuDefinitionGridViewPartialUpdate" };
            settings.SettingsEditing.DeleteRowRouteValues = new { Controller = "Administration", Action = "IndentedMenuDefinitionGridViewPartialDelete" };
        }

        public override void BuildColumns(GridViewSettings settings)
        {
            settings.KeyFieldName = "Id";

            settings.Columns.Add("Id").WithNonVisible();

            settings.Columns.Add("PartialName")
                .WithTextBox()
                .WithInlineHelpText("Menu name must not contain a dot separator.")
                .WithErrorDisplay(ErrorDisplayMode.ImageWithText, ErrorTextPosition.Bottom);

            var x = CoreDbContextService.Db.MenuItemTree.OrderBy(m => m.Sequence).ToList();

            settings.Columns.Add("ParentMenuName")
                .WithComboBox(p =>
                {
                    p.Width = Unit.Percentage(100);
                    p.DropDownStyle = DropDownStyle.DropDownList;
                    p.Columns.Add("ShortName");
                    p.TextField = "ShortName";
                    p.ValueField = "ShortName";
                    p.ValueType = typeof(string);
                    p.BindList(CoreDbContextService.Db.MenuItemTree.OrderBy(m => m.Sequence).ToList());
                })
                .WithInlineHelpText("Select parent from list or leave blank for module menu...");

            settings.Columns.Add("Caption")
                .WithTextBox()
                .WithInlineHelpText("Text displayed in the menu.")
                .WithErrorDisplay(ErrorDisplayMode.ImageWithText, ErrorTextPosition.Bottom);

            settings.Columns.Add("Url")
                .WithTextBox()
                .WithInlineHelpText("Url must begin with ~/..., or leave blank for non-navigable items.")
                .WithErrorDisplay(ErrorDisplayMode.ImageWithText, ErrorTextPosition.Bottom);

            settings.Columns.Add("MenuOrder")
                .WithInlineHelpText("Use to control the order of siblings.");
        }

        public override void BuildEditForm(GridViewSettings settings)
        {
            settings.SettingsText.PopupEditFormCaption = "Menu Item";
            settings.SettingsPopup.EditForm.Width = 600;
            settings.EditFormLayoutProperties.ColCount = 1;
            settings.EditFormLayoutProperties.Items.Add("PartialName");
            settings.EditFormLayoutProperties.Items.Add("ParentMenuName");
            settings.EditFormLayoutProperties.Items.Add("Caption");
            settings.EditFormLayoutProperties.Items.Add("Url");
            settings.EditFormLayoutProperties.Items.Add("MenuOrder");
            settings.EditFormLayoutProperties.Items.AddCommandItem(itemSettings =>
            {
                itemSettings.Width = Unit.Percentage(100);
                itemSettings.HorizontalAlign = FormLayoutHorizontalAlign.Right;
            });

            base.BuildEditForm(settings);
        }

        public override void BuildServerSideEventHandlers(GridViewSettings settings, TempDataDictionary tempData)
        {
            settings.HtmlDataCellPrepared += (s, e) =>
            {
                if (e.DataColumn.FieldName != "PartialName") return;
                var level = e.GetValue("Level").ToString();
                e.Cell.Style.Add("padding-left", 10 + int.Parse(level) * 20 + "px");
            };

            base.BuildServerSideEventHandlers(settings, tempData);
        }
    }
}