using System.Collections.Generic;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using DevExpress.XtraPrinting;

namespace WebPortal.Areas.PartVendorQuotes.Controllers
{
    public delegate ActionResult GridViewExportMethod(GridViewSettings settings, object dataObject);
    public class GridViewExportHelper
    {
        static Dictionary<string, GridViewExportMethod> exportFormatsInfo;
        public static Dictionary<string, GridViewExportMethod> ExportFormatsInfo
        {
            get
            {
                if (exportFormatsInfo == null)
                    exportFormatsInfo = CreateExportFormatsInfo();
                return exportFormatsInfo;
            }
        }
        static Dictionary<string, GridViewExportMethod> CreateExportFormatsInfo()
        {
            return new Dictionary<string, GridViewExportMethod> {
                {
                    "CustomExportToXLS",
                    (settings, data) => GridViewExtension.ExportToXls(settings, data, new XlsExportOptionsEx { ExportType = DevExpress.Export.ExportType.WYSIWYG })
                },
                {
                    "CustomExportToXLSX",
                    (settings, data) => GridViewExtension.ExportToXlsx(settings, data, new XlsxExportOptionsEx { ExportType = DevExpress.Export.ExportType.WYSIWYG })
                }
            };
        }
    }
}