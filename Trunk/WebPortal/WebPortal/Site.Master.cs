using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.PageViewModels;

namespace WebPortal
{
    public partial class SiteMaster : MasterPage
    {
        private PageViewModels.LoginViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (LoginViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new LoginViewModel();
                return ViewModel;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpCookie authCookie = Request.Cookies["WebSettings"];
                if (authCookie == null) authCookie = Request.Cookies["WebOk"];
                if (authCookie == null) Response.Redirect("~/Pages/Login.aspx");

                Session["OpCode"] = authCookie.Values["Op"].ToString();
                Session["Name"] = authCookie.Values["Name"].ToString();
                GetUserPages();

                lblOperator.Text = authCookie.Values["Name"].ToString();
            }
        }


        #region Control Events

        protected void lbxWebPages_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["OpCode"] == null) Response.Redirect("~/Pages/Login.aspx");

            string operatorCode = HttpContext.Current.Session["OpCode"].ToString();
            string operatorName = HttpContext.Current.Session["Name"].ToString();
            string page = lbxWebPages.SelectedItem.Text;
            string path = "";

            var query = ViewModel.UserWebPagesList.Where(p => p.WebPage == page);
            foreach (var item in query) path = item.FilePath;

            if (page == "PartVendorQuotes") // MVC Area
            {
                Response.Redirect("~/" + path + "Home");
            }
            else
            {
                //Response.Redirect("~/" + path + page + ".aspx?op=" + operatorCode + "&name=" + operatorName);
                Response.Redirect("~/" + path + page + ".aspx");
            }
        }

        #endregion


        #region Methods

        private void GetUserPages()
        {
            string error;
            string operatorCode = HttpContext.Current.Session["OpCode"].ToString();

            error = ViewModel.GetUserWebPages(operatorCode);
            if (error != "") return;
            if (!ViewModel.UserWebPagesList.Any()) return;
            
            lbxWebPages.DataSource = ViewModel.UserWebPagesList;
            lbxWebPages.TextField = "WebPage";
            lbxWebPages.ValueField = "WebPage";
            lbxWebPages.DataBind();
        }

        #endregion


    }
}