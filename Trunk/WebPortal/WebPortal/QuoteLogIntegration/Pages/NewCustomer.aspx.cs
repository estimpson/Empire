using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.QuoteLogIntegration.PageViewModels;


namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class NewCustomer : System.Web.UI.Page
    {
        private PageViewModels.NewCustomerViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (NewCustomerViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new NewCustomerViewModel();
                return ViewModel;
            }
        }


        protected void Page_Init(object sender, EventArgs e)
        {
            ViewModel.OperatorCode = Request.QueryString["op"];
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AuthenticateUser();

                rPnl.Collapsed = true;
                gvCustomers.FocusedRowIndex = -1;
            }
        }


        #region Events

        protected void btnHidFocusedRow_Click(object sender, EventArgs e)
        {
        }

        protected void gvCustomers_FocusedRowChanged(object sender, EventArgs e)
        {
            if (gvCustomers.FocusedRowIndex < 0) return;

            // Populate edit form
            string customer = gvCustomers.GetRowValues(gvCustomers.FocusedRowIndex, "CustomerCode").ToString();
            tbxCustomer.Text = customer;

            rPnl.Collapsed = false;
        }

        protected void btnApproveCustomer_Click(object sender, EventArgs e)
        {
            if (ApproveCustomer() == 0) return;

            //SendCustomerApprovedEmail();

            RefreshCustomers();
        }

        protected void btnDenyCustomer_Click(object sender, EventArgs e)
        {
            if (DenyCustomer() == 0) return;

            RefreshCustomers();
        }

        #endregion


        #region Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        private int ApproveCustomer()
        {
            ViewModel.CustomerCode = tbxCustomer.Text;

            ViewModel.ApproveCustomer();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int DenyCustomer()
        {
            ViewModel.CustomerCode = tbxCustomer.Text;
            ViewModel.ResponseNote = tbxCustomerNote.Text.Trim();

            ViewModel.DenyCustomer();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void SendCustomerApprovedEmail()
        {
            ViewModel.SendApprovedEmail();
        }

        private void RefreshCustomers()
        {
            tbxCustomer.Text = tbxCustomerNote.Text = "";

            gvCustomers.DataBind();
        }


        #endregion


    }
}