using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using SupplierEDI.Web.PageViewModels;

namespace SupplierEDI.Web
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

                if (authCookie != null)
                {
                    Session["OpCode"] = authCookie.Values["Op"].ToString();
                    Session["Name"] = authCookie.Values["Name"].ToString();
                    GetUserPages();

                    lblOperator.Text = authCookie.Values["Name"].ToString();
                    return;
                }
            }
        }


        #region Control Events

        protected void lbxWebPages_SelectedIndexChanged(object sender, EventArgs e)
        {
            string operatorCode = HttpContext.Current.Session["OpCode"].ToString();
            string operatorName = HttpContext.Current.Session["Name"].ToString();

            string page = lbxWebPages.SelectedItem.Text;
            string path = "";

            var query = ViewModel.UserWebPagesList.Where(p => p.WebPage == page);
            foreach (var item in query) path = item.FilePath;

            Response.Redirect("~/" + path + page + ".aspx?op=" + operatorCode + "&name=" + operatorName);
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