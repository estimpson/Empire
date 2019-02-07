using System;
using System.Web.UI;
using Telerik.Web.UI;

public partial class NALReview : System.Web.UI.Page 
{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

        protected void RadTextBox1_TextChanged(object sender, EventArgs e)
        {
            RadGrid3.Rebind();
        }
        protected void RadGrid3_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            RadGrid3.Rebind();
        }
}
