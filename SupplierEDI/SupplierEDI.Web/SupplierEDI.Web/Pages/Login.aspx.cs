using System;
using System.Drawing;
using System.Linq;
using System.Web;
using SupplierEDI.Web.PageViewModels;

namespace SupplierEDI.Web.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CheckUserSettings();
            }
        }


        #region Control Events

        protected void cbxRememberUser_CheckedChanged(object sender, EventArgs e)
        {
            if (cbxRememberUser.Text == "Remember Me") return;

            if (cbxRememberUser.Checked) ChangeUser();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string operatorCode;
            string password;
            string operatorName;

            if (ValidateForm(out operatorCode, out password) == 0) return;

            if (ValidateLogin(operatorCode, password, out operatorName) == 0) return;

            GetUserWebPages(operatorCode, operatorName);
        }

        #endregion


        #region Methods

        private void CheckUserSettings()
        {
            // Check whether the users had previously chose the Remember Me option
            HttpCookie authCookie = Request.Cookies["WebSettings"];
            if (authCookie != null)
            {
                if (!string.IsNullOrEmpty(authCookie.Values["Op"]) && !string.IsNullOrEmpty(authCookie.Values["Pw"]))
                {
                    tbxUser.Text = authCookie.Values["Op"].ToString();
                    tbxPWord.Text = authCookie.Values["Pw"].ToString();
                    tbxPWord.Attributes["value"] = authCookie.Values["Pw"].ToString();

                    tbxUser.Enabled = tbxPWord.Enabled = false;
                    tbxUser.BackColor = tbxPWord.BackColor = ColorTranslator.FromHtml("#ebebeb");

                    cbxRememberUser.Text = "Change User";
                    cbxRememberUser.Checked = false;
                    cbxRememberUser.AutoPostBack = true;
                }
            }
        }

        private void ChangeUser()
        {
            cbxRememberUser.Text = "Remember Me";
            cbxRememberUser.Checked = false;
            cbxRememberUser.AutoPostBack = false;

            tbxUser.Enabled = tbxPWord.Enabled = true;
            tbxUser.BackColor = tbxPWord.BackColor = ColorTranslator.FromHtml("#ffffff");

            tbxUser.Text = tbxPWord.Text = "";
            tbxPWord.Attributes["value"] = "";

            if (Request.Cookies["WebSettings"] != null) Response.Cookies["WebSettings"].Expires = DateTime.Now.AddDays(-1);
        }

        private int ValidateForm(out string opCode, out string pw)
        {
            opCode = pw = "";

            opCode = tbxUser.Text.Trim();
            if (opCode == "")
            {
                lblError.Text = "Please enter your operator code.";
                return 0;
            }
            pw = tbxPWord.Text.Trim();
            if (pw == "")
            {
                lblError.Text = "Please enter your password.";
                return 0;
            }
            return 1;
        }

        private int ValidateLogin(string opCode, string pw, out string opName)
        {
            opName = "";

            string error;
            var _loginViewModel = new LoginViewModel();
            opName = _loginViewModel.ValidateOperatorLogin(opCode, pw, out error);
            if (error != "")
            {
                lblError.Text = error;
                return 0;
            }

            if (cbxRememberUser.Checked)
            {
                // Store user authentication
                var userCookie = new HttpCookie("WebSettings");
                userCookie["Op"] = opCode;
                userCookie["Pw"] = pw;
                userCookie["Name"] = opName;
                userCookie.Expires = DateTime.Now.AddDays(30);
                Response.Cookies.Add(userCookie);
            }
                    
            // Set temporary 'logged in' cookie
            var webCookie = new HttpCookie("WebOk");
            webCookie["Op"] = opCode;
            webCookie["Name"] = opName;
            Response.Cookies.Add(webCookie);

            return 1;
        }

        private void GetUserWebPages(string opCode, string opName)
        {
            string error;
            var _loginViewModel = new LoginViewModel();
            error =_loginViewModel.GetUserWebPages(opCode);
            if (error != "")
            {
                lblError.Text = error;
                return;
            }

            if (!_loginViewModel.UserWebPagesList.Any())
            {
                lblError.Text = "No pages have been assigned to this user.";
                return;
            }

            foreach (var item in _loginViewModel.UserWebPagesList)
            {
                if (item.DefaultPage == 1)
                {
                    string defaultPage = item.FilePath + item.WebPage;
                    Response.Redirect("~/" + defaultPage + ".aspx?op=" + opCode + "&name=" + opName);
                }
            }
            //Response.Redirect("~/Scheduling/Pages/SchedulingMain.aspx?op=" + operatorCode + "&name=" + name);
        }

        #endregion


    }
}