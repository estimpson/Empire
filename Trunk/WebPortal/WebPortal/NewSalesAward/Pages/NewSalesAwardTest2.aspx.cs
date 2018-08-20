using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAwardTest2 : System.Web.UI.Page
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            set => Session["AwardedQuote"] = value;
        }

        private string Mode
        {
            set => Session["Mode"] = value;
        }


        private NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] == null) ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return (NewSalesAwardsViewModel)ViewState["ViewModel"];
            }
        }


        private enum LoadingPanelTrigger
        {
            Mode
        }


        private List<usp_GetAwardedQuotes_Result> _quoteList;
        private List<usp_GetAwardedQuotes_Result> QuoteList
        {
            get
            {
                if (_quoteList != null) return _quoteList;
                _quoteList = _quoteList ?? ((List<usp_GetAwardedQuotes_Result>)ViewState["QuoteList"] ??
                                            ViewModel.GetAwardedQuotes());
                //if (ViewState["QuoteList"] == null)
                //    ViewState["QuoteList"] = ViewModel.GetAwardedQuotes();
                //return (List<usp_GetAwardedQuotes_Result>) ViewState["QuoteList"];
                return _quoteList;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            gvQuote.DataSource = QuoteList;
            gvQuote.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) PopulateModeList();
        }



        #region Events

        protected void pcEdit_OnWindowCallback(object source, PopupWindowCallbackArgs e)
        {
            var quoteNumber = (string)gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");

            //  Get the list entry.
            var awardedQuote = QuoteList.FirstOrDefault(q => q.QuoteNumber == quoteNumber);

            AwardedQuote = awardedQuote;
            Mode = e.Parameter;

            NSAEditPopupContents.SetQuote();
        }

        protected void pcFixQuote_WindowCallback(object source, PopupWindowCallbackArgs e)
        {
            if (e.Parameter == "fixQuoteClicked")
            {
                // Fix Awarded Quote
                string oldQuote = tbxOldQuoteNumber.Text;
                string newQuote = cbxQuoteNumber.Value.ToString();
                if (newQuote == null) return;

                ViewModel.AwardedQuoteChangeQuoteNumber(oldQuote, newQuote);
                if (ViewModel.Error == "") tbxOldQuoteNumber.Text = cbxQuoteNumber.Text = "";
            }
            else
            {
                // Showing the popup window
                var quoteNumber = (string)gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
                tbxOldQuoteNumber.Text = quoteNumber;
            }
        }

        protected void cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            try
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;

                //SqlDataSource1.ConnectionString = "data source=eeisql1.empireelect.local;initial catalog=FxPLM;persist security info=True;user id=cdipaola;password=emp1reFt1";
                SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["QuoteTabSql"].ConnectionString;

                SqlDataSource1.SelectCommand =
                       @"SELECT [QuoteNumber], [EEIPartNumber], [Program] FROM (select [QuoteNumber], [EEIPartNumber], [Program], row_number()over(order by q.[QuoteNumber]) as [rn] from [NSA].[QuoteLog] as q where (([QuoteNumber] + ' ' + [EEIPartNumber] + ' ' + [Program]) LIKE @filter)) as st where st.[rn] between @startIndex and @endIndex";

                SqlDataSource1.SelectParameters.Clear();
                SqlDataSource1.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
                SqlDataSource1.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
                SqlDataSource1.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
                comboBox.DataSource = SqlDataSource1;
                comboBox.DataBind();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                //lblError.Text = String.Format("Failed to return quote data. {0}", error);
                //pcError.ShowOnPageLoad = true;
            }
        }

        protected void gvQuote_DataBound(object sender, EventArgs e)
        {
            SetFocusedRow();
        }

        protected void cbxMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvQuote.IsEditing) gvQuote.CancelEdit();

            ToggleColumnButtonVisibility();
            HideLoadingPanel(LoadingPanelTrigger.Mode);
        }

        protected void btnNewSalesAward_Click(object sender, EventArgs e)
        {
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Response.Redirect("CreateAwardedQuote.aspx");
        }

        protected void btnQuoteTransfer_Click(object sender, EventArgs e)
        {
            if (gvQuote.FocusedRowIndex > -1)
            {
                string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
                Session["QuoteNumber"] = quote;
            }
            Session["RedirectPage"] = "~/NewSalesAward/Pages/NewSalesAwardTest2.aspx";
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Session["FocusedRowIndex"] = gvQuote.FocusedRowIndex;
            Response.Redirect("~/QuoteLogIntegration/Pages/QuoteTransfer.aspx");
        }

        protected void btnCustomerCommitment_Click(object sender, EventArgs e)
        {
            //// ***** Need quote number ???
            //Session["AttachmentCategory"] = "CustomerCommitment";

            //ShowQuoteFiles("CustomerCommitment");
            //btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            //pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnAltCustomerCommitment_Click(object sender, EventArgs e)
        {
            //Session["AttachmentCategory"] = "AltCustomerCommitment";

            //ShowQuoteFiles("AltCustomerCommitment");
            //btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            //pcFileUpload.ShowOnPageLoad = true;
        }

        #endregion




        #region Methods

        private void AuthenticateUser()
        {
            var authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) Response.Redirect("~/Pages/UnathenticatedRedirect.aspx");
        }

        private void PopulateModeList()
        {
            var list = new List<string>
            {
                "Quote",
                "Customer PO",
                "Hard Tooling",
                "Assembly Tester Tooling",
                "Tooling Amortization",
                "Base Part Attributes",
                "Base Part Mnemonics",
                "Logistics"
            };

            cbxMode.DataSource = list;
            cbxMode.DataBind();

            // If returning from another page, pick up where the user left off
            if (Session["ModeIndex"] != null)
            {
                cbxMode.SelectedIndex = (int)Session["ModeIndex"];
                ToggleColumnButtonVisibility();
            }
            else
            {
                cbxMode.SelectedIndex = 0;
            }
        }

        //private int GetQuoteLog()
        //{
        //    ViewModel.GetQuoteLog();
        //    if (ViewModel.Error != "")
        //    {
        //        //lblError.Text = String.Format("Failed to return quote number list. Error at GetQuoteLog. {0}", ViewModel.Error);
        //        //pcError.ShowOnPageLoad = true;
        //        return 0;
        //    }
        //    cbxQuoteNumber.DataSource = ViewModel.QuoteNumberList;
        //    cbxQuoteNumber.DataBind();
        //    return 1;
        //}

        private void SetFocusedRow()
        {
            if (Session["FocusedRowIndex"] == null) return;
            int i = Convert.ToInt16(Session["FocusedRowIndex"]);
            gvQuote.FocusedRowIndex = i;
            gvQuote.ScrollToVisibleIndexOnClient = i;
        }

        private void ToggleColumnButtonVisibility()
        {
            // Hide all data columns
            for (var i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = false;

            // Show only the columns required for updating the selected mode
            var mode = cbxMode.SelectedItem.Value.ToString();
            switch (mode)
            {
                case "Quote":
                    for (var i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = true;
                    break;
                case "Customer PO":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["PurchaseOrderDate"].Visible = true;
                    gvQuote.Columns["CustomerProductionPurchaseOrderNumber"].Visible = true;
                    gvQuote.Columns["AlternativeCustomerCommitment"].Visible = true;
                    gvQuote.Columns["PurchaseOrderSellingPrice"].Visible = true;
                    gvQuote.Columns["PurchaseOrderSOP"].Visible = true;
                    gvQuote.Columns["PurchaseOrderEOP"].Visible = true;
                    gvQuote.Columns["CustomerProductionPurchaseOrderComments"].Visible = true;
                    break;
                case "Hard Tooling":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["HardToolingAmount"].Visible = true;
                    gvQuote.Columns["HardToolingTrigger"].Visible = true;
                    gvQuote.Columns["HardToolingDescription"].Visible = true;
                    gvQuote.Columns["HardToolingCAPEXID"].Visible = true;
                    break;
                case "Tooling Amortization":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["AmortizationAmount"].Visible = true;
                    gvQuote.Columns["AmortizationQuantity"].Visible = true;
                    gvQuote.Columns["AmortizationToolingDescription"].Visible = true;
                    gvQuote.Columns["AmortizationCAPEXID"].Visible = true;
                    break;
                case "Assembly Tester Tooling":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingAmount"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingTrigger"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingDescription"].Visible = true;
                    gvQuote.Columns["AssemblyTesterToolingCAPEXID"].Visible = true;
                    break;
                case "Base Part Mnemonics":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["VehiclePlantMnemonic"].Visible = true;
                    gvQuote.Columns["QtyPer"].Visible = true;
                    gvQuote.Columns["TakeRate"].Visible = true;
                    gvQuote.Columns["FamilyAllocation"].Visible = true;
                    break;
                case "Base Part Attributes":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["BasePartFamily"].Visible = true;
                    gvQuote.Columns["ProductLine"].Visible = true;
                    gvQuote.Columns["EmpireMarketSegment"].Visible = true;
                    gvQuote.Columns["EmpireMarketSubsegment"].Visible = true;
                    gvQuote.Columns["EmpireApplication"].Visible = true;
                    gvQuote.Columns["EmpireSOP"].Visible = true;
                    gvQuote.Columns["EmpireEOP"].Visible = true;
                    gvQuote.Columns["EmpireEOPNote"].Visible = true;
                    gvQuote.Columns["BasePart_Comments"].Visible = true;
                    break;
                case "Logistics":
                    gvQuote.Columns["QuoteNumber"].Visible = true;
                    gvQuote.Columns["BasePart"].Visible = true;
                    gvQuote.Columns["EmpireFacility"].Visible = true;
                    gvQuote.Columns["FreightTerms"].Visible = true;
                    gvQuote.Columns["CustomerShipTos"].Visible = true;
                    break;
                default:
                    break;
            }
        }

        private void HideLoadingPanel(LoadingPanelTrigger trigger)
        {
            // Hide loading panel
            switch (trigger)
            {
                case LoadingPanelTrigger.Mode:
                    ScriptManager.RegisterClientScriptBlock(cbxMode, cbxMode.GetType(), "HideLoadingPanel",
                        "lp.Hide();", true);
                    break;
                default:
                    break;
            }
        }

        #endregion


    }
}