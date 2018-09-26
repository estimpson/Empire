using DevExpress.Web;
using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Areas.PartVendorQuotes.Models;
using WebPortal.Areas.PartVendorQuotes.ViewModels;
using WebPortal.Areas.PartVendorQuotes.Views._Helpers;

namespace WebPortal.Areas.PartVendorQuotes.Controllers
{
    public class HomeController : Controller
    {
        private static int RowID;
        private static string QuoteFileName;

        private MONITOREntities4 _context = new MONITOREntities4();

        // GET: PartVendorQuotes/Home
        public ActionResult Index()
        {
            return View();
        }

        #region Grid
        public ActionResult PartVendorQuotesGridViewPartial()
        {
            PartVendorQuotesViewModel model = new PartVendorQuotesViewModel();

            model.PartVendorQuotes = _context.usp_GetPartVendorQuotes().ToList();
            model.Parts = _context.usp_GetParts().ToList();
            model.Vendors = _context.usp_GetVendors().ToList();
            model.Oems = _context.usp_GetOems().ToList();

            return PartialView("_PartVendorQuotesGridViewPartial", model);
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))] usp_GetPartVendorQuotes_Result item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
                    ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                    _context.usp_AddPartVendorQuote("", item.VendorCode, item.PartCode, item.Oem, item.EffectiveDate, item.EndDate, item.Price, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error:  " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = "NON-SQL Error:" + e.Message + e.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return PartVendorQuotesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))] usp_GetPartVendorQuotes_Result item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
                    ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                    _context.usp_EditPartVendorQuote("", item.RowID, item.VendorCode, item.PartCode, item.Oem, item.EffectiveDate, item.EndDate, item.Price, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error (On Update):  " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.GetType().Name + " - NON-SQL Error:  " + e.Message + e.InnerException?.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";
 
            return PartVendorQuotesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialDelete([ModelBinder(typeof(DevExpressEditorsBinder))]System.Int32 RowId)
        {
            if (RowId >= 0)
            {
                ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
                ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));

                string attachmentCategory = "VendorQuote";
                try
                {
                    _context.usp_DeletePartVendorQuote("", RowId, attachmentCategory, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error:  " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
          
            return PartVendorQuotesGridViewPartial();
        }

        #endregion

        #region Upload Control
        public static UploadControlValidationSettings UploadValidationSettings
            => new UploadControlValidationSettings { MaxFileSize = 419430400 };

        public PartialViewResult UploadDocViewPartial()
        {
            return PartialView("_UploadDocViewPartial");
        }

        // Necessary evil.
        public ActionResult UploadControlUpload([ModelBinder(typeof(MultiFileSelectionDemoBinder))]IEnumerable<UploadedFile> ucMultiSelection)
        {
            return null;
        }

        // This action occurs when an upload is started and notifies controller of the currently
        // selected RowID.
        public ActionResult FileUploadStart(int rowID, string quoteFileName)
        {
            RowID = rowID;
            QuoteFileName = quoteFileName;
            return null;
        }

        public static void MultiSelection_FileUploadComplete(object sender, FileUploadCompleteEventArgs args)
        {
            try
            {
                var rowID = RowID;

                ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

                string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
                string attachmentCategory = "VendorQuote";

                using (var context = new MONITOREntities4())
                {
                    context.usp_PVQ_FileManagement_Save(partVendorQuoteNumber, attachmentCategory, args.UploadedFile.FileName, args.UploadedFile.FileBytes, tranDT, result);
                }
            }
            catch (EntityCommandExecutionException e)
            {
                throw new Exception("SQL Error:  " + e.Message + " " + e.InnerException?.Message);
            }
            catch (Exception e)
            {
                throw new Exception("NON-SQL Error:" + e.Message + e.InnerException?.Message);
            }

        }

        public ActionResult OpenPartVendorQuoteFile()
        {
            var rowID = RowID;
            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";
            string fileName = "";
            byte[] fileContents = null;

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            var context = new MONITOREntities4();
            var collection = context.usp_PVQ_FileManagement_Get(partVendorQuoteNumber, attachmentCategory, tranDT, result);
            var item = collection.ToList().First();
            fileName = item.FileName;
            fileContents = item.FileContents;

            var attachmentExtension = Path.GetExtension(fileName);
            var tempFileName =
                Path.ChangeExtension($"{Path.GetFileNameWithoutExtension(fileName)}-{Path.GetRandomFileName()}",
                    attachmentExtension);
            var tempFileServerPath = $"{AppDomain.CurrentDomain.BaseDirectory}/Temp/{tempFileName}";
            var tempFileClientPath = $"../../Temp/{tempFileName}";

            var fs = new FileStream(tempFileServerPath, FileMode.Create);
            fs.Write(fileContents, 0, fileContents.Length);
            fs.Flush();
            fs.Close();
            return null;
        }

        public void DeletePartVendorQuoteFile(int rowID)
        {
            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            _context.usp_PVQ_FileManagement_Delete(partVendorQuoteNumber, attachmentCategory, tranDT, result);
        }
        #endregion

        #region Export
        public ActionResult ExportTo(string customExportCommand)
        {
            switch (customExportCommand)
            {
                case "CustomExportToXLS":
                case "CustomExportToXLSX":
                    return GridViewExportHelper.ExportFormatsInfo[customExportCommand](
                        GridViewHelper.ExportGridSettings, (new MONITOREntities4()).usp_GetPartVendorQuotes().ToList());
                default:
                    return RedirectToAction("Index");
            }
        }
        #endregion
    }

    public class MultiFileSelectionDemoBinder : DevExpressEditorsBinder
    {
        public MultiFileSelectionDemoBinder()
        {
            UploadControlBinderSettings.ValidationSettings.Assign(HomeController.UploadValidationSettings);
            UploadControlBinderSettings.FileUploadCompleteHandler = HomeController.MultiSelection_FileUploadComplete;
        }
    }
}
