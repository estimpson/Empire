using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class CsmDemand : System.Web.UI.Page
    {
        public String OperatorCode { get; private set; }

        public enum FormStateMnemonic
        {
            Assign,
            UpdateRemove
        }

        private enum LoadingPanelTrigger
        {
            Assign,
            Update,
            Remove
        }


        private PageViewModels.CsmDemandViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (CsmDemandViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new CsmDemandViewModel();
                return ViewModel;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                AuthenticateUser();

                OperatorCode = System.Web.HttpContext.Current.Session["op"].ToString();

                if (Session["BasePart"] == null) Response.Redirect("~/Pages/Login.aspx");
                tbxBasePart.Text = Session["BasePart"].ToString();

                btnAssignMnemonic.Visible = btnRemoveMnemonic.Visible = false;
            }
        }



        #region Control Events

        protected void gvCsmData_DataBound(object sender, EventArgs e)
        {
            SetGridFocusedRow();

            SetActiveMnemonicHighlighting();

            //ASPxGridView grid = sender as ASPxGridView;
            //SetGridSelectedRows(grid);
        }

        protected void gvCsmData_FocusedRowChanged(object sender, EventArgs e)
        {
            if (gvCsmData.FocusedRowIndex < 0) return;

            tbxMnemonic.Text = gvCsmData.GetRowValues(gvCsmData.FocusedRowIndex, "VehiclePlantMnemonic").ToString();
            int result = GetAwardedQuoteBasePartMnemonic(Session["QuoteNumber"].ToString(), tbxMnemonic.Text);
            if (result == 1)
            {
                // Assigned mnemonic selected
                ToggleFormButtons(FormStateMnemonic.UpdateRemove);
            }
            else
            {
                // Un-assigned mnemonic selected
                ToggleFormButtons(FormStateMnemonic.Assign);
            }
        }

        protected void btnAssignMnemonic_Click(object sender, EventArgs e)
        {
            int result = AssignCsmMnemonic();
            if (result == 1)
            {
                gvCsmData.DataBind();
                ToggleFormButtons(FormStateMnemonic.UpdateRemove);
            }
            else
            {
                // Assignment failed, so keep the assign button visible
                ToggleFormButtons(FormStateMnemonic.Assign);
            }
            HideLoadingPanel(LoadingPanelTrigger.Assign);
        }

        protected void btnUpdateMnemonic_Click(object sender, EventArgs e)
        {
            int result = AssignCsmMnemonic();
            if (result == 1)
            {
                gvCsmData.DataBind();
                ToggleFormButtons(FormStateMnemonic.UpdateRemove);
            }
            else
            {
                // Assignment failed, so keep the assign button visible
                ToggleFormButtons(FormStateMnemonic.Assign);
            }
            HideLoadingPanel(LoadingPanelTrigger.Update);
        }

        protected void btnRemoveMnemonic_Click(object sender, EventArgs e)
        {
            int result = RemoveCsmMnemonic();
            if (result == 1)
            {
                gvCsmData.DataBind();
                ToggleFormButtons(FormStateMnemonic.Assign);
            }
            else
            {
                // Assignment failed, so keep the assign button visible
                ToggleFormButtons(FormStateMnemonic.UpdateRemove);
            }
            HideLoadingPanel(LoadingPanelTrigger.Remove);
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            Response.Redirect("NewSalesAwards.aspx");
        }

        #endregion


        #region Authentication Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
        }

        #endregion



        #region Methods

        private void SetGridFocusedRow()
        {
            // Grid will be sorted descending by mnemonic active flag, 
            //   so id there is a mnemonic tied to this quote/base part, the first row should get focus
            string mnemonic = Session["Mnemonic"].ToString();
            gvCsmData.FocusedRowIndex = (mnemonic == "") ? -1 : 0;
        }

        //private void SetGridSelectedRows(ASPxGridView grid)
        //{
        //    for (int i = 0; i < grid.VisibleRowCount; i++)
        //    {
        //        var activeFlag = gvCsmData.GetRowValues(i, "ActiveFlag");
        //        if ((int)activeFlag == 1) grid.Selection.SelectRow(i);
        //    }
        //}

        private void SetActiveMnemonicHighlighting()
        {
            GridViewFormatConditionHighlight rule = new GridViewFormatConditionHighlight();
            rule.FieldName = "VehiclePlantMnemonic";
            rule.Expression = "[ActiveFlag] = 1";
            rule.Format = GridConditionHighlightFormat.BoldText;
            gvCsmData.FormatConditions.Add(rule);
        }

        private int GetAwardedQuoteBasePartMnemonic(string quote, string mnemonic)
        {
            var result = ViewModel.GetAwardedQuoteBasePartMnemonic(quote, mnemonic);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at GetAwardedQuoteBasePartMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            if (!result.Any()) return 0;

            foreach(var item in result)
            {
                tbxQtyPer.Text = (item.QtyPer.HasValue) ? item.QtyPer.ToString() : "";
                tbxTakeRate.Text = (item.TakeRate.HasValue) ? item.TakeRate.ToString() : "";
                tbxFamilyAllocation.Text = (item.FamilyAllocation.HasValue) ? item.FamilyAllocation.ToString() : "";
            }
            return 1;
        }

        private int AssignCsmMnemonic()
        {
            string quote = Session["QuoteNumber"].ToString();
            string mnemonic = tbxMnemonic.Text;
            decimal? qtyPer = Decimal.Parse(tbxQtyPer.Text);
            decimal? takeRate = Decimal.Parse(tbxTakeRate.Text);
            decimal? familyAllocation = Decimal.Parse(tbxFamilyAllocation.Text);

            ViewModel.AssignCsmMnemonic(quote, mnemonic, qtyPer, takeRate, familyAllocation);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at AssignCsmMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int RemoveCsmMnemonic()
        {
            string quote = Session["QuoteNumber"].ToString();
            string mnemonic = tbxMnemonic.Text;

            ViewModel.RemoveCsmMnemonic(quote, mnemonic);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at RemoveCsmMnemonic. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private void ToggleFormButtons(FormStateMnemonic state)
        {
            if (state == FormStateMnemonic.Assign)
            {
                btnAssignMnemonic.Visible = true;
                btnRemoveMnemonic.Visible = btnUpdateMnemonic.Visible = false;

                tbxFamilyAllocation.Text = tbxQtyPer.Text = tbxTakeRate.Text = "";
            }
            else if(state == FormStateMnemonic.UpdateRemove)
            {
                btnAssignMnemonic.Visible = false;
                btnRemoveMnemonic.Visible = btnUpdateMnemonic.Visible = true;

                btnRemoveMnemonic.BackColor = Color.Red;
            }
        }

        private void HideLoadingPanel(LoadingPanelTrigger trigger)
        {
            // Hide loading panel
            switch (trigger)
            {
                case LoadingPanelTrigger.Assign:
                    ScriptManager.RegisterClientScriptBlock(btnAssignMnemonic, btnAssignMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                case LoadingPanelTrigger.Update:
                    ScriptManager.RegisterClientScriptBlock(btnUpdateMnemonic, btnUpdateMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                case LoadingPanelTrigger.Remove:
                    ScriptManager.RegisterClientScriptBlock(btnRemoveMnemonic, btnRemoveMnemonic.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                default:
                    break;
            }
        }


        #endregion


    }
}