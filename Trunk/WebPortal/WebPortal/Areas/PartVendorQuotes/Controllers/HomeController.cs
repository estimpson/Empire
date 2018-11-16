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
        private static int _rowID;
        private static string _quoteFileName;
        private static string _uploadError;

        private MONITOREntities4 _context = new MONITOREntities4();

        // GET: PartVendorQuotes/Home
        public ActionResult Index()
        {
            if (Session["DeletedTempFiles"] == null)
            {
                Session["DeletedTempFiles"] = "true";
                DeleteTempFiles();
            }

            return View();
        }


        #region Messages

        public PartialViewResult MessagesViewPartial()
        {
            return PartialView("_MessagesViewPartial");
        }
        
        #endregion


        #region Grid

        public ActionResult PartVendorQuotesGridViewPartial()
        {
            var model = _context.usp_GetPartVendorQuotes().ToList().Select(pv => new PartVendorQuoteViewModel
            {
                RowID = pv.RowID,
                VendorCode = pv.VendorCode,
                PartCode = pv.PartCode,
                Oem = pv.Oem,
                EffectiveDate = pv.EffectiveDate,
                EndDate = pv.EndDate,
                Price = pv.Price,
                QuoteFileName = pv.QuoteFileName,
            }).ToList();

            return PartialView("_PartVendorQuotesGridViewPartial", model);
        }

        public string GetFocusedRowFile(int rowID)
        {
            return _context.usp_GetPartVendorQuotes().SingleOrDefault(pvq => pvq.RowID == rowID)?.QuoteFileName;
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialAddNew([ModelBinder(typeof(DevExpressEditorsBinder))] PartVendorQuoteViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                    var result = new ObjectParameter("Result", typeof(Int32?));
                    var debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                    _context.usp_AddPartVendorQuote("", item.VendorCode, item.PartCode, item.Oem, item.EffectiveDate, item.EndDate, item.Price, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error: " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = "NON-SQL Error: " + e.Message + " " + e.InnerException?.Message;
                }
            }
            else
            {
                ViewData["EditError"] = "Please, correct all errors.";
            }
            return PartVendorQuotesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))] PartVendorQuoteViewModel item)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                    var result = new ObjectParameter("Result", typeof(Int32?));
                    var debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                    _context.usp_EditPartVendorQuote("", item.RowID, item.VendorCode, item.PartCode, item.Oem, item.EffectiveDate, item.EndDate, item.Price, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error (On Update): " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = "NON-SQL Error: " + e.Message + " " + e.InnerException?.Message;
                }
            }
            else
            {
                ViewData["EditError"] = "Please, correct all errors.";
            }
            return PartVendorQuotesGridViewPartial();
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialDelete([ModelBinder(typeof(DevExpressEditorsBinder))]System.Int32 RowId)
        {
            if (RowId >= 0)
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                var debugMsg = new ObjectParameter("DebugMsg", typeof(String));

                string attachmentCategory = "VendorQuote";
                try
                {
                    _context.usp_DeletePartVendorQuote("", RowId, attachmentCategory, tranDT, result, 0, debugMsg);
                }
                catch (EntityCommandExecutionException e)
                {
                    ViewData["EditError"] = "SQL Error: " + e.Message + " " + e.InnerException?.Message;
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = "NON-SQL Error: " + e.Message + " " + e.InnerException?.Message;
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
            _rowID = rowID;
            _quoteFileName = quoteFileName;
            return null;
        }

        public static void MultiSelection_FileUploadComplete(object sender, FileUploadCompleteEventArgs args)
        {
            try
            {
                _uploadError = "";
                var rowID = _rowID;

                ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

                string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
                string attachmentCategory = "VendorQuote";

                // Save uploaded file to the file server
                using (var context = new MONITOREntities4())
                {
                    context.usp_PVQ_FileManagement_Save(partVendorQuoteNumber, attachmentCategory, args.UploadedFile.FileName, args.UploadedFile.FileBytes, tranDT, result);
                }
            }
            catch (EntityCommandExecutionException e)
            {
                _uploadError = "SQL Error:  " + e.Message + " " + e.InnerException?.Message;
                //throw new Exception("SQL Error:  " + e.Message + " " + e.InnerException?.Message);
            }
            catch (Exception e)
            {
                _uploadError = "SQL Error:  " + e.Message + " " + e.InnerException?.Message;
                //throw new Exception("NON-SQL Error:" + e.Message + e.InnerException?.Message);
            }
        }

        public ActionResult CheckUploadSuccess()
        {
            if (_uploadError != "")
            {
                return new HttpStatusCodeResult(410, _uploadError);
            }
            return new HttpStatusCodeResult(200);
        }

        public ActionResult OpenPartVendorQuoteFile(int rowID)
        {
            // Return the file contents from the file server
            string fileName;
            byte[] fileContents;
            string result = GetFile(rowID, out fileName, out fileContents);
            if (result != "")
                return new HttpStatusCodeResult(410, result);
        
            // Create the file to display in a javascript window
            string tempFileServerPath;
            string tempFileClientPath;
            try
            {
                var attachmentExtension = Path.GetExtension(fileName);
                var tempFileName =
                    Path.ChangeExtension($"{Path.GetFileNameWithoutExtension(fileName)}-{Path.GetRandomFileName()}",
                        attachmentExtension);
                tempFileServerPath = $"{AppDomain.CurrentDomain.BaseDirectory}/Temp/{tempFileName}";
                tempFileClientPath = $"../Temp/{tempFileName}";

                var fs = new FileStream(tempFileServerPath, FileMode.Create);
                fs.Write(fileContents, 0, fileContents.Length);
                fs.Flush();
                fs.Close();
            }
            catch (Exception e)
            {
                string error = (e.InnerException != null) ? e.InnerException.Message : e.Message;
                return new HttpStatusCodeResult(410, error);
            }
            return Content(tempFileClientPath);
        }

        public string GetFile(int rowID, out string fileName, out byte[] fileContents)
        {
            string error = "";
            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";
            fileName = "";
            fileContents = null;

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            try
            {
                using (var context = new MONITOREntities4())
                {
                    var collection = context.usp_PVQ_FileManagement_Get(partVendorQuoteNumber, attachmentCategory, tranDT, result);
                    var item = collection.ToList().First();
                    fileName = item.FileName;
                    fileContents = item.FileContents;
                }
            }
            catch (EntityCommandExecutionException e)
            {
                error = (e.InnerException != null) ? e.InnerException.Message : e.Message;
            }
            catch (Exception e)
            {
                error = (e.InnerException != null) ? e.InnerException.Message : e.Message;
            }
            return error;
        }

        public ActionResult DeletePartVendorQuoteFile(int rowID)
        {
            string error;
            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            try
            {
                _context.usp_PVQ_FileManagement_Delete(partVendorQuoteNumber, attachmentCategory, tranDT, result);
            }
            catch (EntityCommandExecutionException e)
            {
                error = (e.InnerException == null) ? e.Message : e.InnerException.Message;
                return new HttpStatusCodeResult(410, error);
            }
            catch (Exception e)
            {
                error = (e.InnerException == null) ? e.Message : e.InnerException.Message;
                return new HttpStatusCodeResult(410, error);
            }
            return new HttpStatusCodeResult(200);

            //if (ViewData["Attempt"] == null)
            //{
            //    ViewData["Attempt"] = 1;
            //    return new HttpStatusCodeResult(200);
            //}
            //else
            //{
            //    ViewData["Attempt"] = null;
            //    return new HttpStatusCodeResult(410, "TESTING: error capture and display.");
            //}
        }

        private void DeleteTempFiles()
        {
            string directoryPath = @"C:\inetpub\wwwroot\WebPortal\temp\";
            if (!Directory.Exists(directoryPath)) return;

            string[] files = Directory.GetFiles(directoryPath);
            foreach (string file in files)
            {
                FileInfo fi = new FileInfo(file);
                if (fi.LastAccessTime < DateTime.Now.AddDays(-1)) ;
                fi.Delete();
            }
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
