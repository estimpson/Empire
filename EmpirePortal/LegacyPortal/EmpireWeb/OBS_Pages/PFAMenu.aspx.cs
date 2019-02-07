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
        protected void Page_Load(object sender, EventArgs e)
        {
            RadTextBox1.Text = User.Identity.Name;
            RadDatePicker1.SelectedDate = DateTime.Today;
        }

        protected void RadButton2_Click(object sender, EventArgs e)
        {
            SqlDataSourceNewPFA.Insert();
        }
}

