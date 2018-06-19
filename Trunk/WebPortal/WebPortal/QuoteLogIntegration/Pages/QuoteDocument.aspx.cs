using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class QuoteDocument : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack) return;

            string fileType = Session["FileType"].ToString();
            string fileName = Session["FileName"].ToString();
            string filePath = Session["FilePath"].ToString();
            string fileLength = Session["FileLength"].ToString();

            if (fileType == "pdf")
            {
                Response.ContentType = "application/pdf";
                Response.WriteFile(Session["FilePath"].ToString());
                return;
            }

            // Set the appropriate content type
            if (fileType == "tif" || fileType == "tiff")
            {
                Response.ContentType = "image/tiff";
            }
            else if (fileType == "jpg" || fileType == "jpeg")
            {
                Response.ContentType = "image/jpeg";
            }
            else if (fileType == "htm" || fileType == "html")
            {
                Response.ContentType = "text/HTML";
            }
            else if (fileType == "txt")
            {
                Response.ContentType = "text/plain";
            }
            else if (fileType == "doc" || fileType == "rtf" || fileType == "docx")
            {
                Response.ContentType = "Application/msword";
            }
            else if (fileType == "xlsx" || fileType == "xlsm")
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            }

            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.AddHeader("Content-Length", fileLength);
            Response.Flush();
            Response.TransmitFile(filePath);
            Response.End();
        }


    }
}