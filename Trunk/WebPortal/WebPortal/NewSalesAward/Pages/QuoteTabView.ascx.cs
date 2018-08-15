using System;
using System.Web.UI;
using DevExpress.Web;
using WebPortal.NewSalesAward.Models;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class QuoteTabView : UserControl, I_NSATabView
    {
        private usp_GetAwardedQuotes_Result AwardedQuote
        {
            get => (usp_GetAwardedQuotes_Result)Session["AwardedQuote"];
        }

        private string Mode
        {
            get => (string)Session["Mode"];
        }



        private CreateAwardedQuoteViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (CreateAwardedQuoteViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new CreateAwardedQuoteViewModel();
                return ViewModel;
            }
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateDropdownLists();

            //pnlQuoteDetails.Enabled = pnlDocument.Enabled = false;
            cbxReplacingBasePart.Enabled = false;
            cbxQuoteNumber.Focus();
        }



        #region Control Events

        protected void ASPxCallbackPanel1_Callback(object sender, CallbackEventArgsBase e)
        {

        }

        protected void cbxQuoteNumber_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            try
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;

                SqlDataSource1.ConnectionString = "data source=eeisql1.empireelect.local;initial catalog=FxPLM;persist security info=True;user id=cdipaola;password=emp1reFt1";

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

        protected void cbxQuoteNumber_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            //long value = 0;
            //if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
            //    return;
            //ASPxComboBox comboBox = (ASPxComboBox)source;
            //SqlDataSource1.SelectCommand = @"SELECT ID, LastName, [Phone], FirstName FROM Persons WHERE (ID = @ID) ORDER BY FirstName";

            //SqlDataSource1.SelectParameters.Clear();
            //SqlDataSource1.SelectParameters.Add("ID", TypeCode.Int64, e.Value.ToString());
            //comboBox.DataSource = SqlDataSource1;
            //comboBox.DataBind();
        }

        //protected void cbxQuoteNumber_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    // ***** On successful save, should return to the main page, so clearing will not be necessary (selected index should not change more than once) *****
        //    //ClearForm();

        //    Session["QuoteNumber"] = cbxQuoteNumber.Value.ToString();
        //    //if (GetAwardedQuoteDetails() == 1) pnlQuoteDetails.Enabled = true;
        //    GetAwardedQuoteDetails();

        //    //ShowQuoteFiles("CustomerCommitment");
        //}

        protected void cbxQuoteReason_SelectedIndexChanged(object sender, EventArgs e)
        {
            //cbxReplacingBasePart.Enabled = (cbxQuoteReason.Text == "New Part");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //if (Session["QuoteNumber"] == null) return;

            //if (cbxFormOfCommitment.SelectedIndex < 0) cbxFormOfCommitment.BackColor = Color.LightGreen;

            //if (SaveAwardedQuote() == 0) return;

            //Response.Redirect("NewSalesAwards.aspx");
        }

        #endregion


        #region Methods

        public void SetQuote()
        {
            //AwardedQuote = awardedQuote;
            //BasePartAttributesFormLayout.DataSource = AwardedQuote;
            //BasePartAttributesFormLayout.DataBind();

            Session["QuoteNumber"] = AwardedQuote.QuoteNumber;
            GetAwardedQuoteDetails();

            switch (Mode)
            {
                case "new":
                    cbxQuoteNumber.Text = "";
                    pnlQuoteDetails.Visible = false;
                    btnSubmit.Text = "Save";
                    break;
                case "edit":

                    btnSubmit.Text = "Save";
                    break;
                case "fix":

                    cbxQuoteNumber.Text = "";
                    btnSubmit.Text = "Fix Quote";
                    break;
            }
        }

        public void Save()
        {
            // Interface requirement
        }









        private void PopulateDropdownLists()
        {
            if (GetSalespeople() == 0) return;
            if (GetProgramManagers() == 0) return;
            if (GetQuoteReasons() == 0) return;
            if (GetCustomerCommitmentForms() == 0) return;
            GetActiveBaseParts();
        }

        private int GetQuoteLog()
        {
            ViewModel.GetQuoteLog();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Failed to return quote number list. Error at GetQuoteLog. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxQuoteNumber.DataSource = ViewModel.QuoteNumberList;
            cbxQuoteNumber.DataBind();
            return 1;
        }

        private int GetAwardedQuoteDetails()
        {
            ViewModel.QuoteNumber = Session["QuoteNumber"].ToString();
            ViewModel.GetAwardedQuoteDetails();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }

            try
            {
                ListEditItem itemSalesperson = cbxSalesperson.Items.FindByValue(ViewModel.Salesperson);
                if (itemSalesperson != null) cbxSalesperson.Value = ViewModel.Salesperson;

                ListEditItem itemProgramManager = cbxProgramManager.Items.FindByValue(ViewModel.ProgramManager);
                if (itemProgramManager != null) cbxProgramManager.Value = ViewModel.ProgramManager;

                ListEditItem itemQuoteReason = cbxQuoteReason.Items.FindByValue(ViewModel.QuoteReason);
                if (itemQuoteReason != null) cbxQuoteReason.Value = ViewModel.QuoteReason;

                ListEditItem itemFormOfCommitment = cbxFormOfCommitment.Items.FindByValue(ViewModel.FormOfCommitment);
                if (itemFormOfCommitment != null) cbxFormOfCommitment.Value = ViewModel.FormOfCommitment;

                ListEditItem itemBasePart = cbxReplacingBasePart.Items.FindByValue(ViewModel.ReplacingBasePart);
                if (itemBasePart != null)
                {
                    cbxReplacingBasePart.Value = ViewModel.ReplacingBasePart;
                    if (itemBasePart.Text != "") cbxReplacingBasePart.Enabled = true;
                }

                deAwardDate.Value = ViewModel.AwardDate;
                memoComments.Text = ViewModel.Comments;
                tbxQuotedEau.Text = ViewModel.QuotedEau;
                tbxQuotedPrice.Text = ViewModel.QuotedPrice;
                tbxQuotedMaterialCost.Text = ViewModel.QuotedMaterialCost;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                //lblError.Text = String.Format("Error at GetAwardedQuoteDetails. {0}", error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int GetSalespeople()
        {
            var salesPeople = ViewModel.GetSalespeople();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetSalespeople. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxSalesperson.DataSource = salesPeople;
            cbxSalesperson.TextField = "UserName";
            cbxSalesperson.ValueField = "UserCode";
            cbxSalesperson.DataBind();
            return 1;
        }

        private int GetProgramManagers()
        {
            var programManagers = ViewModel.GetProgramManagers();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetProgramManagers. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxProgramManager.DataSource = programManagers;
            cbxProgramManager.TextField = "UserName";
            cbxProgramManager.ValueField = "UserCode";
            cbxProgramManager.DataBind();
            return 1;
        }

        private int GetQuoteReasons()
        {
            var quoteReasons = ViewModel.GetQuoteReasons();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetQuoteReasons. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxQuoteReason.DataSource = quoteReasons;
            cbxQuoteReason.TextField = "QuoteReason";
            cbxQuoteReason.ValueField = "QuoteReasonId";
            cbxQuoteReason.DataBind();
            return 1;
        }

        private int GetCustomerCommitmentForms()
        {
            var forms = ViewModel.GetCustomerCommitmentForms();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetCustomerCommitmentForms. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxFormOfCommitment.DataSource = forms;
            cbxFormOfCommitment.TextField = "FormOfCommitment";
            cbxFormOfCommitment.ValueField = "FormOfCommitment";
            cbxFormOfCommitment.DataBind();
            return 1;
        }

        private int GetActiveBaseParts()
        {
            var baseParts = ViewModel.GetActiveBaseParts();
            if (ViewModel.Error != "")
            {
                //lblError.Text = String.Format("Error at GetActiveBaseParts. {0}", ViewModel.Error);
                //pcError.ShowOnPageLoad = true;
                return 0;
            }
            cbxReplacingBasePart.DataSource = baseParts;
            cbxReplacingBasePart.TextField = "BasePart";
            cbxReplacingBasePart.ValueField = "BasePart";
            cbxReplacingBasePart.DataBind();
            return 1;
        }

        #endregion


        protected void cbxQuoteNumber_Callback(object sender, CallbackEventArgsBase e)
        {
            //Session["QuoteNumber"] = cbxQuoteNumber.Value.ToString();
            Session["QuoteNumber"] = e.ToString();
            GetAwardedQuoteDetails();
        }


    }
}