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


public partial class SiteTestMaster : MasterPage 
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Page.IsPostBack)
	    	{
		}
		else
		{
		
		}
	}	
	
	protected void RadButtonLogin_Click(object sender, EventArgs e)  
	{  
     
	}

	protected void RadButtonCookie_Click(object sender, EventArgs e)  
	{  
     		HttpCookie aCookie = new HttpCookie("LoggedIn");
		//aCookie.Value = DateTime.Now.ToString();
		//aCookie.Expires = DateTime.Now.AddDays(1);
		Response.Cookies.Add(aCookie);
	}

	protected void RadButtonWebPage_Click(object sender, EventArgs e)  
	{  
     
	} 
	
