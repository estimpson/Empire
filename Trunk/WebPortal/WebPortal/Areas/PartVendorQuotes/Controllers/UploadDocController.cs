using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebPortal.Areas.PartVendorQuotes.Controllers
{
    public class UploadDocController : Controller
    {
        // GET: PartVendorQuotes/UploadDoc
        public ActionResult Index()
        {
            return View();
        }

    //    public ActionResult UploadControlUpload()
    //    {
    //        UploadControlExtension.GetUploadedFiles("UploadControl", UploadDocsControllerUploadControlSettings.UploadValidationSettings, UploadDocsControllerUploadControlSettings.FileUploadComplete);
    //        return null;
    //    }
    //}
    //public class UploadDocsControllerUploadControlSettings
    //{
    //    public static DevExpress.Web.UploadControlValidationSettings UploadValidationSettings = new DevExpress.Web.UploadControlValidationSettings()
    //    {
    //        AllowedFileExtensions = new string[] { ".jpg", ".jpeg" },
    //        MaxFileSize = 4000000
    //    };
    //    public static void FileUploadComplete(object sender, DevExpress.Web.FileUploadCompleteEventArgs e)
    //    {
    //        if (e.UploadedFile.IsValid)
    //        {
    //            // Save uploaded file to some location
    //        }
    //    }


    }
}