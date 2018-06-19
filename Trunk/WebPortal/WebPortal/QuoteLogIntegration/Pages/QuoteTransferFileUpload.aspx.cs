using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using WebPortal.QuoteLogIntegration.PageViewModels;

namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class QuoteTransferFileUpload : System.Web.UI.Page
    {
        private String _quote;

        protected void Page_Load(object sender, EventArgs e)
        {
            _quote = Session["Quote"].ToString();
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (FileUploadControl.HasFile) SaveFile();
        }


        private void SaveFile()
        {
            try
            {
                string fileName = Path.GetFileName(FileUploadControl.FileName);

                byte[] fileContents = FileUploadControl.FileBytes;

                // Save Quote Print
                QtDocumentationViewModel viewModel = new QtDocumentationViewModel();
                viewModel.SaveQuoteFile(_quote, "QuotePrint", fileName, fileContents);

                StatusLabel.Text = "File uploaded!";
            }
            catch (Exception ex)
            {
                StatusLabel.Text = "The file could not be uploaded. The following error occured: " + ex.Message;
            }
        }


    }
}