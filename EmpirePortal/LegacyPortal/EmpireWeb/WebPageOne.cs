using System;
using System.Web;
using System.Data;
using System.Design;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik;
using Telerik.Web.UI;
using Telerik.Web.Data;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.Diagnostics;


public partial class WebPageOne : System.Web.UI.Page 
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack)
	    	{
		}
		else
		{
			
			if(Request.Cookies["LoggedIn"] != null)
			{
				Label1.Text = "Cookie Exists";
			}
		}
	}	

}