using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using Telerik.Web.Data;
using Telerik.Web;


    public partial class PremiumFreightRequestA : System.Web.UI.Page
    {
        private string type;
        private string value;

        protected void Page_Load(object sender, EventArgs e)
        {
            RadDatePicker1.SelectedDate = DateTime.Today;

            if (Session["SelectedSortOrder"] != null)
            {
                string param = Session["SelectedSortOrder"].ToString();

                SqlDataSourcePFAMenu.SelectCommandType = SqlDataSourceCommandType.Text;
                SqlDataSourcePFAMenu.SelectCommand = "SELECT * FROM [eeiuser].[Freight_PFA] order by " + param;
                SqlDataSourcePFAMenu.Select(DataSourceSelectArguments.Empty);

                RadAutoCompleteBox1.DataSourceID = "SqlDataSourcePFAMenu";
                RadAutoCompleteBox1.DataTextField = param;
                RadAutoCompleteBox1.DataValueField = param;
            }
            else
            {
                SqlDataSourcePFAMenu.SelectCommandType = SqlDataSourceCommandType.Text;
                SqlDataSourcePFAMenu.SelectCommand = "SELECT * FROM [eeiuser].[Freight_PFA] order by TRACKING_NUMBER";
                SqlDataSourcePFAMenu.Select(DataSourceSelectArguments.Empty);

                RadAutoCompleteBox1.DataSourceID = "SqlDataSourcePFAMenu";
                RadAutoCompleteBox1.DataTextField = "TRACKING_NUMBER";
                RadAutoCompleteBox1.DataValueField = "TRACKING_NUMBER";
            }

        }

        protected void RadButton2_Click(object sender, EventArgs e)
        {
            SqlDataSourceNewPFA.Insert();

            SqlDataSourceGetNewPFA.SelectCommand = "select max(PFA_ID) as PFAID from eeiuser.freight_pfa where REQUESTOR = (select name from employee where operator_code = '" +
                                                   RadTextBoxOp.Text + "')";
            DataView a = (DataView)SqlDataSourceGetNewPFA.Select(DataSourceSelectArguments.Empty);

            type = "PFAID";
            value = a[0]["PFAID"].ToString();

            if (value != String.Empty)
                Response.Redirect("PFA.aspx?Type=" + type + "&Value=" + value);
        }

        protected void SearchButton_Clicked(object sender, EventArgs e)
        {
            type = RadComboBox1.Text;
            value = RadAutoCompleteBox1.Text;

            if (value != String.Empty)
                Response.Redirect("PFA.aspx?Type=" + type + "&Value=" + value);
        }

        protected void RadComboBox1_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Session["SelectedSortOrder"] = e.Value.ToString();
        }


}

