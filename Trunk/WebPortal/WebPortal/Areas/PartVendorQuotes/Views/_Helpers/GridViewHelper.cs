using System.Web.Mvc;
using DevExpress.Web;
using DevExpress.Web.Mvc;
using DevExpress.Web.Mvc.UI;

namespace WebPortal.Areas.PartVendorQuotes.Views._Helpers
{
    public static class GridViewHelper
    {
        public static void UseStandardToolbar(GridViewSettings settings, HtmlHelper helper)
        {
            settings.Toolbars.Add(toolbar =>
            {
                toolbar.Enabled = true;
                toolbar.Position = GridToolbarPosition.Top;
                toolbar.ItemAlign = GridToolbarItemAlign.Right;
                toolbar.Items.Add(GridViewToolbarCommand.New);
                toolbar.Items.Add(GridViewToolbarCommand.Edit);
                toolbar.Items.Add(GridViewToolbarCommand.Delete);
                toolbar.Items.Add(GridViewToolbarCommand.Refresh, true);
                toolbar.Items.Add(i =>
                {
                    i.Text = "Export to";
                    i.Image.IconID = DevExpress.Web.ASPxThemes.IconID.ActionsDownload16x16office2013;
                    i.BeginGroup = true;
                    i.Items.Add(GridViewToolbarCommand.ExportToPdf);
                    i.Items.Add(GridViewToolbarCommand.ExportToDocx);
                    i.Items.Add(GridViewToolbarCommand.ExportToRtf);
                    i.Items.Add(GridViewToolbarCommand.ExportToXls).Text = "Export to XLS(DataAware)";
                    i.Items.Add(exportitem =>
                    {
                        exportitem.Name = "CustomExportToXLS";
                        exportitem.Text = "Export to XLS(WYSIWYG)";
                        exportitem.Image.IconID = DevExpress.Web.ASPxThemes.IconID.ExportExporttoxls16x16office2013;
                    });
                    i.Items.Add(GridViewToolbarCommand.ExportToXlsx).Text = "Export to XLSX(DataAware)";
                    i.Items.Add(exportitem =>
                    {
                        exportitem.Name = "CustomExportToXLSX";
                        exportitem.Text = "Export to XLSX(WYSIWYG)";
                        exportitem.Image.IconID = DevExpress.Web.ASPxThemes.IconID.ExportExporttoxlsx16x16office2013;
                    });
                });
                toolbar.Items.Add(i =>
                {
                    i.BeginGroup = true;
                    i.SetTemplateContent(c =>
                    {

                        helper.DevExpress().ButtonEdit(s =>
                        {
                            s.Name = "search";
                            s.Properties.NullText = "Search...";
                            s.Properties.Buttons
                                .Add()
                                .Image.IconID = DevExpress.Web.ASPxThemes.IconID.FindFind16x16gray;
                        }).Render();
                    });
                });
            });
            settings.SettingsSearchPanel.CustomEditorName = "search";

            settings.ClientSideEvents.ToolbarItemClick = "OnToolbarItemClick";
            settings.SettingsExport.EnableClientSideExportAPI = true;
            settings.SettingsExport.ExcelExportMode = DevExpress.Export.ExportType.DataAware;

        }

        public static void SetStandardAdaptivitySettings(GridViewSettings settings)
        {
            settings.SettingsAdaptivity.AdaptivityMode = GridViewAdaptivityMode.HideDataCellsWindowLimit;
            settings.SettingsAdaptivity.AdaptiveColumnPosition = GridViewAdaptiveColumnPosition.Right;
            settings.SettingsAdaptivity.AdaptiveDetailColumnCount = 1;
            settings.SettingsAdaptivity.AllowOnlyOneAdaptiveDetailExpanded = true;
            settings.SettingsAdaptivity.HideDataCellsAtWindowInnerWidth = 0;

        }

        /// <summary>
        /// Place after creation of columns.
        /// </summary>
        /// <param name="settings"></param>
        public static void SetStandardBehavior(GridViewSettings settings)
        {
            settings.SettingsPager.Visible = true;
            settings.Settings.ShowGroupPanel = true;
            settings.SettingsBehavior.AllowFocusedRow = true;
            settings.SettingsBehavior.AllowSelectByRowClick = true;
            settings.SettingsBehavior.ConfirmDelete = true;
            settings.Settings.ShowHeaderFilterButton = true;
            settings.SettingsPopup.HeaderFilter.Height = 200;
            settings.SettingsPopup.HeaderFilter.SettingsAdaptivity.MinHeight = 300;
            settings.SettingsPager.EnableAdaptivity = true;

            foreach (GridViewDataColumn column in settings.Columns)
            {
                column.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
            }
        }

        static GridViewSettings exportGridSettings;
        public static GridViewSettings ExportGridSettings
        {
            get
            {
                if (exportGridSettings == null)
                    exportGridSettings = CreateExportGridSettings();
                return exportGridSettings;
            }
        }

        static GridViewSettings CreateExportGridSettings()
        {
            var settings = new GridViewSettings();
            settings.Name = "grid";
            settings.KeyFieldName = "RowID";
            return settings;
        }
    }
}