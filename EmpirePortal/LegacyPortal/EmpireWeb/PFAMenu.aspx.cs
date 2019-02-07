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
        }

        protected void RadButton2_Click(object sender, EventArgs e)
        {
            SqlDataSourceNewPFA.Insert();

            SqlDataSourceGetNewPFA.SelectCommand = "select max(PFA_ID) as PFAID from eeiuser.freight_pfa where REQUESTOR = 'Dan West'";
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


}

