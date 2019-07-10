using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class QuoteTransferList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/NewSalesAward/Pages/NewSalesAward.aspx");
        }

        protected void QuoteTransfersGrid_OnCustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            switch (e.Parameters)
            {
                case "RowDoubleClick":
                    if (QuoteTransfersGrid.FocusedRowIndex < 0)
                    {
                        return;
                    }
                    Session["QuoteNumber"] = QuoteTransfersGrid.GetRowValues(QuoteTransfersGrid.FocusedRowIndex, "QuoteNumber");
                    Session["RedirectPage"] = "~/QuoteLogIntegration/Pages/QuoteTransferList.aspx";
                    Session["FocusedRowIndex"] = QuoteTransfersGrid.FocusedRowIndex;
                    var TARGET_URL = "~/QuoteLogIntegration/Pages/QuoteTransfer.aspx";
                    if (Page.IsCallback)
                        ASPxWebControl.RedirectOnCallback(TARGET_URL);
                    else
                        Response.Redirect(TARGET_URL);
                    break;
                default:
                    throw new Exception(e.Parameters);
            }
        }

        protected void QuoteTransferCallbackPanel_OnCallback(object sender, CallbackEventArgsBase e)
        {
            switch (e.Parameter)
            {
                case "New":
                    if (QuoteTransfersGrid.FocusedRowIndex < 0)
                    {
                        return;
                    }
                    Session["QuoteNumber"] = null;
                    Session["RedirectPage"] = "~/QuoteLogIntegration/Pages/QuoteTransferList.aspx";
                    Session["FocusedRowIndex"] = QuoteTransfersGrid.FocusedRowIndex;
                    var TARGET_URL = "~/QuoteLogIntegration/Pages/QuoteTransfer.aspx";
                    if (Page.IsCallback)
                        ASPxWebControl.RedirectOnCallback(TARGET_URL);
                    else
                        Response.Redirect(TARGET_URL);
                    break;
                default:
                    throw new Exception(e.Parameter);
            }
        }
    }
}