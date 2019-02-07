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
using System.Data.Objects;
using System.Collections.Generic;
using System.Linq;
using System.Web.SessionState;
using System.Collections;


public partial class PremiumFreightRequest : System.Web.UI.Page
{
    private string _argumentType;
    private string _argumentValue;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            RetrieveQueryString();
            SqlDataSourcePFA.SelectCommand = CreateSelectStatement();

            DataView a = (DataView)SqlDataSourcePFA.Select(DataSourceSelectArguments.Empty);

            ASPxLabel lbl1 = ASPxRoundPanel3.FindControl("Label1") as ASPxLabel;
            lbl1.Text = a[0]["REQUESTOR"].ToString();

            ASPxLabel lbl2 = ASPxRoundPanel3.FindControl("Label2") as ASPxLabel;
            String.Format("{0:d}", lbl2.Text);
            lbl2.Text = a[0]["PFA_DATE"].ToString();

            ASPxLabel lbl3 = ASPxRoundPanel3.FindControl("Label3") as ASPxLabel;
            lbl3.Text = a[0]["PFA_ID"].ToString();
            Session["PFAID"] = a[0]["PFA_ID"].ToString();
        }
    }

    protected void ASPxButton1_Clicked(object sender, EventArgs e)
    {
        Response.Redirect("PFAMenu.aspx");
    }

    protected void ASPxButton2_Clicked(object sender, EventArgs e)
    {
        // Submit
        SqlDataSourcePFA.UpdateParameters["PFA_ID"].DefaultValue = Session["PFAID"].ToString();
        SqlDataSourcePFA.Update();
        Response.Redirect("PFAMenu.aspx");
    }

    private void RetrieveQueryString()
    {
        if (Request.QueryString["Type"] != null) _argumentType = Request.QueryString["Type"];
        if (Request.QueryString["Value"] != null)
        {
            _argumentValue = Request.QueryString["Value"];

            int len = _argumentValue.Length;
            if (_argumentValue.Substring(len - 1, 1) == ";") _argumentValue = _argumentValue.Remove(len - 1, 1);
        }   
    }

    private string CreateSelectStatement()
    {
        string selectStatement = "";
        if (_argumentType == "Tracking Number")
        {
            selectStatement = "SELECT * FROM [eeiuser].[Freight_PFA] WHERE [TRACKING_NUMBER] = '" + _argumentValue + "'";
        }
        else if (_argumentType == "PFAID")
        {
            selectStatement = "SELECT * FROM [eeiuser].[Freight_PFA] WHERE [PFA_ID] = '" + _argumentValue + "'";
        }
        return selectStatement;
    }

    protected void Label1_OnInit(object sender, EventArgs e)
    {
        //throw new NotImplementedException();
    }

    protected void Label2_OnInit(object sender, EventArgs e)
    {
        //throw new NotImplementedException();
    }

    protected void ASPxLabel1_OnInit(object sender, EventArgs e)
    {
        //throw new NotImplementedException();
    }

    protected void Label3_OnInit(object sender, EventArgs e)
    {
        //throw new NotImplementedException();
    }


}
