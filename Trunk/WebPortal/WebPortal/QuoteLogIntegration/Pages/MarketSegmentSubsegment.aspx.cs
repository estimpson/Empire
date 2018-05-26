using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.QuoteLogIntegration.PageViewModels;

namespace WebPortal.QuoteLogIntegration.Pages
{
    public partial class MarketSegmentSubsegment : System.Web.UI.Page
    {
        private PageViewModels.MarketSegmentSubsegmentViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (MarketSegmentSubsegmentViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new MarketSegmentSubsegmentViewModel();
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

                rPnl.Collapsed = rPnl2.Collapsed = true;
                gvSegments.FocusedRowIndex = gvSubsegments.FocusedRowIndex = -1;
            }
        }


        #region Control Events

        protected void btnHidFocusedRow_Click(object sender, EventArgs e)
        {
        }

        #endregion


        #region Segment Control Events

        protected void gvSegments_FocusedRowChanged(object sender, EventArgs e)
        {
            if (gvSegments.FocusedRowIndex < 0) return;

            gvSubsegments.FocusedRowIndex = -1;

            string status = gvSegments.GetRowValues(gvSegments.FocusedRowIndex, "ApprovalStatus").ToString();
            if (status != "Waiting Approval") return;

            // Populate edit form
            string empireMarketSegment = gvSegments.GetRowValues(gvSegments.FocusedRowIndex, "EmpireMarketSegment").ToString();
            tbxSegment.Text = empireMarketSegment;

            rPnl.Collapsed = false;
        }

        protected void btnApproveSegment_Click(object sender, EventArgs e)
        {
            if (ApproveSegment() == 0) return;

            //SendSegmentEmail();

            RefreshSegment();
        }

        protected void btnDenySegment_Click(object sender, EventArgs e)
        {
            if (DenySegment() == 0) return;

            //SendSegmentEmail();

            RefreshSegment();
        }

        #endregion


        #region Subsegment Control Events

        protected void gvSubsegments_FocusedRowChanged(object sender, EventArgs e)
        {
            if (gvSubsegments.FocusedRowIndex < 0) return;

            gvSegments.FocusedRowIndex = -1;

            string status = gvSubsegments.GetRowValues(gvSubsegments.FocusedRowIndex, "ApprovalStatus").ToString();
            if (status != "Waiting Approval") return;

            // Populate edit form
            string empireMarketSubsegment = gvSubsegments.GetRowValues(gvSubsegments.FocusedRowIndex, "EmpireMarketSubsegment").ToString();
            tbxSubsegment.Text = empireMarketSubsegment;

            rPnl2.Collapsed = false;
        }

        protected void btnApproveSubsegment_Click(object sender, EventArgs e)
        {
            if (ApproveSubsegment() == 0) return;

            //SendSubsegmentEmail();

            RefreshSubsegment();
        }

        protected void btnDenySubsegment_Click(object sender, EventArgs e)
        {
            if (DenySubsegment() == 0) return;

            //SendSubsegmentEmail();

            RefreshSubsegment();
        }

        #endregion


        #region Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion


        #region Segment Methods

        private int ApproveSegment()
        {
            ViewModel.Segment = tbxSegment.Text;
            ViewModel.SegmentNote = tbxSegmentNote.Text.Trim();

            ViewModel.ApproveSegment();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int DenySegment()
        {
            ViewModel.Segment = tbxSegment.Text;
            ViewModel.SegmentNote = tbxSegmentNote.Text.Trim();

            ViewModel.DenySegment();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void SendSegmentEmail()
        {
            ViewModel.SendSegmentEmail();
        }

        private void RefreshSegment()
        {
            tbxSegment.Text = tbxSegmentNote.Text = "";

            gvSegments.DataBind();
        }

        #endregion


        #region Subsegment Methods

        private int ApproveSubsegment()
        {
            ViewModel.Subsegment = tbxSubsegment.Text;
            ViewModel.SubsegmentNote = tbxSubsegmentNote.Text.Trim();

            ViewModel.ApproveSubsegment();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int DenySubsegment()
        {
            ViewModel.Subsegment = tbxSubsegment.Text;
            ViewModel.SubsegmentNote = tbxSubsegmentNote.Text.Trim();

            ViewModel.DenySubsegment();
            if (ViewModel.Error != "")
            {
                lblError.Text = ViewModel.Error;
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void SendSubsegmentEmail()
        {
            ViewModel.SendSubsegmentEmail();
        }

        private void RefreshSubsegment()
        {
            tbxSubsegment.Text = tbxSubsegmentNote.Text = "";

            gvSubsegments.DataBind();
        }

        #endregion


    }
}