using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebPortal.Pages
{
    public partial class Menu : System.Web.UI.Page
    {
        private string Operator
        {
            get { return ViewState["Operator"] != null ? (string)ViewState["Operator"] : ""; }
            set { ViewState["Operator"] = value; }
        }

        private string Name
        {
            get { return ViewState["Name"] != null ? (string)ViewState["Name"] : ""; }
            set { ViewState["Name"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
            }
            else
            {
                AuthenticateUser();
            }
        }


        #region Methods
        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion


    }
}