using DevExpress.Web;
using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
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
            PartVendorQuotesViewModel model = new PartVendorQuotesViewModel();

            using (var context = new MONITOREntities4())
            {
                model.PartVendorQuotes = context.usp_GetPartVendorQuotes().ToList();
                model.Parts = context.usp_GetParts().ToList();
                model.Vendors = context.usp_GetVendors().ToList();
                model.Oems = context.usp_GetOems().ToList();
            }

            return View(model);
        }

        public ActionResult PartVendorQuotesGridViewPartial()
        {
            PartVendorQuotesViewModel model = new PartVendorQuotesViewModel();

            using (var context = new MONITOREntities4())
            {
                model.PartVendorQuotes = context.usp_GetPartVendorQuotes().ToList();
                model.Parts = context.usp_GetParts().ToList();
                model.Vendors = context.usp_GetVendors().ToList();
                model.Oems = context.usp_GetOems().ToList();
            }

            return PartialView("_PartVendorQuotesGridViewPartial", model);
        }

        public PartialViewResult UploadDocViewPartial()
        {
            return PartialView("_UploadDocViewPartial");
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
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            var partVendorQuotesViewModel = new PartVendorQuotesViewModel
            {
                Parts = _context.usp_GetParts().ToList(),
                Vendors = _context.usp_GetVendors().ToList(),
                PartVendorQuotes = _context.usp_GetPartVendorQuotes().ToList(),
                Oems = _context.usp_GetOems().ToList()
            };

            return PartialView("_PartVendorQuotesGridViewPartial", partVendorQuotesViewModel);
        }
        [HttpPost, ValidateInput(false)]
        public ActionResult PartVendorQuotesGridViewPartialUpdate([ModelBinder(typeof(DevExpressEditorsBinder))] usp_GetPartVendorQuotes_Result item)
        {
            ViewData["EditError"] = "Hello";
            if (ModelState.IsValid)
            {
                try
                {
                    ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                    ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
                    ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));
                    _context.usp_EditPartVendorQuote("", item.RowID, item.VendorCode, item.PartCode, item.Oem, item.EffectiveDate, item.EndDate, item.Price, tranDT, result, 0, debugMsg);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";
 
                
            var partVendorQuotesViewModel = new PartVendorQuotesViewModel
            {
                Parts = _context.usp_GetParts().ToList(),
                Vendors = _context.usp_GetVendors().ToList(),
                PartVendorQuotes = _context.usp_GetPartVendorQuotes().ToList(),
                Oems = _context.usp_GetOems().ToList()
            };

            return PartialView("_PartVendorQuotesGridViewPartial", partVendorQuotesViewModel);
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
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }

            //if (ViewData["EditError"] != null)
            //{
            //     settings.Settings.ShowFooter = true;
            //    settings.SetFooterRowTemplateContent(c =>
            //    {
            //        Html.ViewContext.Writer.Write(ViewData["EditError"]);
            //    });
            //}
            
            var partVendorQuotesViewModel = new PartVendorQuotesViewModel
            {
                Parts = _context.usp_GetParts().ToList(),
                Vendors = _context.usp_GetVendors().ToList(),
                PartVendorQuotes = _context.usp_GetPartVendorQuotes().ToList(),
                Oems = _context.usp_GetOems().ToList()
            };
            
            return PartialView("_PartVendorQuotesGridViewPartial", partVendorQuotesViewModel);
        }

        public ActionResult UploadControlUpload([ModelBinder(typeof(MultiFileSelectionDemoBinder))]IEnumerable<UploadedFile> ucMultiSelection)
        {
            return null;
        }


        public ActionResult SelectedRowChanged(int rowID, string quoteFileName)
        {
            RowID = rowID;
            QuoteFileName = quoteFileName;
            return null;
        }

        public ActionResult OpenFileButtonClicked()
        {

            return null;
        }

        public ActionResult DeleteFileButtonClicked()
        {

            return null;
        }


        public static readonly UploadControlValidationSettings UploadValidationSettings = new UploadControlValidationSettings
        {
            MaxFileSize = 41943040
        };

        public static void MultiSelection_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            var rowID = RowID;

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            //throw new Exception(rowID.ToString());
            //DocsViewModel.SaveQuoteFile(AwardedQuote.QuoteNumber, "CustomerCommitment", e.UploadedFile.FileName, e.UploadedFile.FileBytes);

            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";

            try
            {
                var context = new MONITOREntities4();
                context.usp_PVQ_FileManagement_Save(partVendorQuoteNumber, attachmentCategory, e.UploadedFile.FileName, e.UploadedFile.FileBytes, tranDT, result);
            }
            catch (Exception ex)
            {
                string error = ex.InnerException.Message;
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

            //OpenCustomerCommitmentFileButton.JSProperties.Add("cpFilePath", tempFileClientPath);
            return null;
        }

        public ActionResult DeletePartVendorQuoteFile(int rowID)
        {
            string partVendorQuoteNumber = "PVQ_" + rowID.ToString();
            string attachmentCategory = "VendorQuote";

            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));
            //ObjectParameter debugMsg = new ObjectParameter("DebugMsg", typeof(String));
            //int debug = 0;

            try
            {
                _context.usp_PVQ_FileManagement_Delete(partVendorQuoteNumber, attachmentCategory, tranDT, result);
            }
            catch (Exception e)
            {

                throw e.InnerException;
            }
            return null;
        }


        public ActionResult ExportTo(string customExportCommand) {
            switch(customExportCommand) {
                case "CustomExportToXLS":
                case "CustomExportToXLSX":
                    return GridViewExportHelper.ExportFormatsInfo[customExportCommand](
                        GridViewHelper.ExportGridSettings, (new MONITOREntities4()).usp_GetPartVendorQuotes().ToList());
                default:
                    return RedirectToAction("Index");
            }
        }
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
