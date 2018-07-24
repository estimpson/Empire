using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using SupplierEDI.Web.SupplierEDIModule.ViewModels;

namespace SupplierEDI.Web.SupplierEDIModule.Pages
{
    public partial class Show830 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Page.Title = "Preview 830";
            if (!Page.IsPostBack)
            {
                GetXML();
            }
        }

        void GetXML()
        {
            var purchaseOrderNumber = int.Parse(Request.QueryString["PurchaseOrder"]);
            var purchaseOrder830VM = new PurchaseOrder830ViewModel();
            var XML830 = purchaseOrder830VM.GetPreview(purchaseOrderNumber);
            var x = XML830.Length;

            //Xml1.ApplyStyleSheetSkin();
            //Xml1.DocumentContent = XML830;

            ReportXML.Text = XML830;  // String.Format("{0}", HttpUtility.HtmlEncode(XML830));

            //xmlLabel.Text = Server.HtmlEncode(XML830);

            //var sb = new StringBuilder();
            //var sw = new StringWriter(sb);
            //var xt = new XmlTextWriter(sw);
            //xt.Formatting = Formatting.Indented;
            //var xd = new XmlDocument();
            //xd.LoadXml(XML830);
            //xd.WriteTo(xt);

            //xmlLabel.Text = sb.ToString();
        }
    }
}