using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DevExpress.Web;
using DevExpress.Data;
using Telerik.Web.UI;

public partial class PremiumFreightRequest : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        DataView a = (DataView)SqlDataSourcePFA.Select(DataSourceSelectArguments.Empty);
        
        ASPxLabel lbl1 = ASPxRoundPanel3.FindControl("Label1") as ASPxLabel;
        lbl1.Text = a[0]["REQUESTOR"].ToString();

        ASPxLabel lbl2 = ASPxRoundPanel3.FindControl("Label2") as ASPxLabel;
        String.Format("{0:d}", lbl2.Text);
        lbl2.Text = a[0]["PFA_DATE"].ToString();
        


        ASPxLabel lbl3 = ASPxRoundPanel3.FindControl("Label3") as ASPxLabel;
        lbl3.Text = a[0]["PFA_ID"].ToString();
        
    }
}
