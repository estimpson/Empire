using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebPortal.NewSalesAward.PageViewModels;

namespace WebPortal.NewSalesAward.Pages
{
    public partial class NewSalesAwards : System.Web.UI.Page
    {
        private PageViewModels.DocumentationViewModel DocsViewModel
        {
            get
            {
                if (ViewState["DocsViewModel"] != null)
                {
                    return (DocumentationViewModel)ViewState["DocsViewModel"];
                }
                ViewState["DocsViewModel"] = new DocumentationViewModel();
                return DocsViewModel;
            }
        }

        private PageViewModels.NewSalesAwardsViewModel ViewModel
        {
            get
            {
                if (ViewState["ViewModel"] != null)
                {
                    return (NewSalesAwardsViewModel)ViewState["ViewModel"];
                }
                ViewState["ViewModel"] = new NewSalesAwardsViewModel();
                return ViewModel;
            }
        }

        private enum LoadingPanelTrigger
        {
            Mode
        }


        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["op"] == null) Session["op"] = Request.QueryString["op"];
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AuthenticateUser();

                PopulateModeList();

                btnAltCustomerCommitment.Visible = false;

                gvQuote.FocusedRowIndex = -1;
            }
        }



        #region Control Events

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
            Session["RedirectPage"] = "~/NewSalesAward/Pages/NewSalesAwards.aspx";
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Response.Redirect("~/QuoteLogIntegration/Pages/QuoteTransfer.aspx");
        }

        protected void btnCustomerCommitment_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "CustomerCommitment";

            ShowQuoteFiles("CustomerCommitment");
            btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnAltCustomerCommitment_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "AltCustomerCommitment";

            ShowQuoteFiles("AltCustomerCommitment");
            btnDocGet.Enabled = btnDocDelete.Enabled = (DocsViewModel.QuoteFileName != "");
            pcFileUpload.ShowOnPageLoad = true;
        }

        protected void btnEditMnemonic_Click(object sender, EventArgs e)
        {
            string quote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
            string basePart = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart").ToString();
            string mnemonic = "";
            if (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "VehiclePlantMnemonic") != null)
            {
                mnemonic = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "VehiclePlantMnemonic").ToString());
            }
            Session["QuoteNumber"] = quote;
            Session["BasePart"] = basePart;
            Session["Mnemonic"] = mnemonic;
            Session["ModeIndex"] = cbxMode.SelectedIndex;
            Response.Redirect("CsmDemand.aspx");
        }

        //protected void gvQuote_FocusedRowChanged(object sender, EventArgs e)
        //{
        //    if (gvQuote.FocusedRowIndex < 0) return;

        //    //Session["QuoteNumber"] = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber").ToString();
        //}

        protected void gvQuote_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "ClearSort") gvQuote.ClearSort();
        }

        protected void gvQuote_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (gvQuote.IsNewRowEditing) return;

            string column = e.Column.FieldName;
            ASPxEditBase editor = e.Editor;

            EditModeDisableColumns(column, editor); // Disable editing

            if (column == "CustomerShipTos") EditModePopulateCustomerShipTos(editor); // Populate the CustomerShipTos combobox
        }

        private void EditModePopulateCustomerShipTos(ASPxEditBase e)
        {
            string basePart = (gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "BasePart").ToString());
            var destinations = ViewModel.GetCustomerShipTos(basePart);

            var cmb = e as ASPxComboBox;
            cmb.DataSource = destinations;
            cmb.DataBind();
        }

        protected void gvQuote_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string quote = e.NewValues["QuoteNumber"].ToString();

            string mode = cbxMode.SelectedItem.Value.ToString();
            switch (mode)
            {
                case "Customer PO":
                    if (SetProductionPO(quote, e) == 1) gvQuote.DataBind();
                    break;
                case "Hard Tooling":
                    if (SetHardTooling(quote, e) == 1) gvQuote.DataBind();
                    break;
                case "Tooling Amortization":
                    if (SetToolingAmortization(quote, e) == 1) gvQuote.DataBind();
                    break;
                case "Assembly Tester Tooling":
                    if (SetAssemblyTesterTooling(quote, e) == 1) gvQuote.DataBind();
                    break;
                case "Base Part Mnemonics":
                    //gvQuote.Columns["QuoteNumber"].Visible = true;
                    //gvQuote.Columns["BasePart"].Visible = true;
                    //gvQuote.Columns["VehiclePlantMnemonic"].Visible = true;
                    //gvQuote.Columns["QtyPer"].Visible = true;
                    //gvQuote.Columns["TakeRate"].Visible = true;
                    //gvQuote.Columns["FamilyAllocation"].Visible = true;
                    break;
                case "Base Part Attributes":
                    if (SetBasePartAttributes(quote, e) == 1) gvQuote.DataBind();
                    break;
                default:
                    break;
            }

            gvQuote.CancelEdit();
            e.Cancel = true;
        }

        #endregion



        #region Document Control Events

        protected void btnDocGet_Click(object sender, EventArgs e)
        {
            if (tbxDocName.Text.Trim() == "") return;
            GetFile("QuotePrint");
        }

        protected void btnDocDelete_Click(object sender, EventArgs e)
        {
            Session["AttachmentCategory"] = "QuotePrint";
            if (DeleteFile() == 1)
            {
                tbxDocName.Text = "";
                btnDocGet.Enabled = false;
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!FileUploadControl.HasFile) return;

            string attachmentCategory = Session["AttachmentCategory"].ToString();
            if (SaveFile() == 1) ShowQuoteFiles(attachmentCategory);
        }

        #endregion



        #region Methods

        private void AuthenticateUser()
        {
            HttpCookie authCookie = Request.Cookies["WebOk"];
            if (authCookie == null) { Response.Redirect("~/Pages/UnathenticatedRedirect.aspx"); }
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

        private void ToggleColumnButtonVisibility()
        {
            // Hide all data columns
            for (int i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = false;

            // Toggle edit button columns
            if (cbxMode.Text == "Quote")
            {
                gvQuote.Columns[0].Visible = gvQuote.Columns[1].Visible = false;
            }
            else if (cbxMode.Text == "Base Part Mnemonics")
            {
                gvQuote.Columns[0].Visible = false;
                gvQuote.Columns[1].Visible = true;
            }
            else
            {
                gvQuote.Columns[0].Visible = true;
                gvQuote.Columns[1].Visible = false;
            }

            // Show only the columns required for updating the selected mode
            string mode = cbxMode.SelectedItem.Value.ToString();
            switch (mode)
            {
                case "Quote":
                    for (int i = 2; i < gvQuote.Columns.Count; i++) gvQuote.Columns[i].Visible = true;
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
                    gvQuote.Columns["Comments"].Visible = true;
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
                    gvQuote.Columns["Comments"].Visible = true;
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

        private void EditModeDisableColumns(string column, ASPxEditBase e)
        {
            if (column == "QuoteNumber" || column == "BasePart")
            {
                e.ReadOnly = true;
                e.ClientEnabled = false;
            }
        }

        private void HideLoadingPanel(LoadingPanelTrigger trigger)
        {
            // Hide loading panel
            switch (trigger)
            {
                case LoadingPanelTrigger.Mode:
                    ScriptManager.RegisterClientScriptBlock(cbxMode, cbxMode.GetType(), "HideLoadingPanel", "lp.Hide();", true);
                    break;
                default:
                    break;
            }
        }

        private int SetProductionPO(string quote, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            DateTime? purchaseOrderDt = null;
            if (e.NewValues["PurchaseOrderDate"] != null) purchaseOrderDt = Convert.ToDateTime(e.NewValues["PurchaseOrderDate"]);

            string po = (e.NewValues["CustomerProductionPurchaseOrderNumber"] != null) ? e.NewValues["CustomerProductionPurchaseOrderNumber"].ToString() : "";
            string altCommit = (e.NewValues["AlternativeCustomerCommitment"] != null) ? e.NewValues["AlternativeCustomerCommitment"].ToString() : "";

            decimal? sellingPrice = null;
            if (e.NewValues["PurchaseOrderSellingPrice"] != null) sellingPrice = Convert.ToDecimal(e.NewValues["PurchaseOrderSellingPrice"]);

            DateTime? sop = null;
            if (e.NewValues["PurchaseOrderSOP"] != null) sop = Convert.ToDateTime(e.NewValues["PurchaseOrderSOP"]);

            DateTime? eop = null;
            if (e.NewValues["PurchaseOrderEOP"] != null) eop = Convert.ToDateTime(e.NewValues["PurchaseOrderEOP"]);

            string comments = (e.NewValues["Comments"] != null) ? e.NewValues["Comments"].ToString() : "";

            ViewModel.SetProductionPO(quote, purchaseOrderDt, po, altCommit, sellingPrice, sop, eop, comments);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SetProductionPO. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int SetHardTooling(string quote, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            decimal? amount = null;
            if (e.NewValues["HardToolingAmount"] != null) amount = Convert.ToDecimal(e.NewValues["HardToolingAmount"]);

            string trigger = (e.NewValues["HardToolingTrigger"] != null) ? e.NewValues["HardToolingTrigger"].ToString() : "";
            string description = (e.NewValues["HardToolingDescription"] != null) ? e.NewValues["HardToolingDescription"].ToString() : "";
            string capexid = (e.NewValues["HardToolingCAPEXID"] != null) ? e.NewValues["HardToolingCAPEXID"].ToString() : "";
            
            ViewModel.SetHardTooling(quote, amount, trigger, description, capexid);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SetHardTooling. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int SetToolingAmortization(string quote, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            decimal? amount = null;
            if (e.NewValues["AmortizationAmount"] != null) amount = Convert.ToDecimal(e.NewValues["AmortizationAmount"]);

            decimal? quantity = null;
            if (e.NewValues["AmortizationQuantity"] != null) quantity = Convert.ToDecimal(e.NewValues["AmortizationQuantity"]);

            string description = (e.NewValues["AmortizationToolingDescription"] != null) ? e.NewValues["AmortizationToolingDescription"].ToString() : "";
            string capexid = (e.NewValues["AmortizationCAPEXID"] != null) ? e.NewValues["AmortizationCAPEXID"].ToString() : "";

            ViewModel.SetToolingAmortization(quote, amount, quantity, description, capexid);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SetToolingAmortization. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int SetAssemblyTesterTooling(string quote, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            decimal? amount = null;
            if (e.NewValues["AssemblyTesterToolingAmount"] != null) amount = Convert.ToDecimal(e.NewValues["AssemblyTesterToolingAmount"]);

            string trigger = (e.NewValues["AssemblyTesterToolingTrigger"] != null) ? e.NewValues["AssemblyTesterToolingTrigger"].ToString() : "";
            string description = (e.NewValues["AssemblyTesterToolingDescription"] != null) ? e.NewValues["AssemblyTesterToolingDescription"].ToString() : "";
            string capexid = (e.NewValues["AssemblyTesterToolingCAPEXID"] != null) ? e.NewValues["AssemblyTesterToolingCAPEXID"].ToString() : "";

            ViewModel.SetAssemblyTesterTooling(quote, amount, trigger, description, capexid);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SetAssemblyTesterTooling. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int SetBasePartAttributes(string quote, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string basePartFamily = (e.NewValues["BasePartFamily"] != null) ? e.NewValues["BasePartFamily"].ToString() : "";
            string productLine = (e.NewValues["ProductLine"] != null) ? e.NewValues["ProductLine"].ToString() : "";
            string marketSegment = (e.NewValues["EmpireMarketSegment"] != null) ? e.NewValues["EmpireMarketSegment"].ToString() : "";
            string marketSubsegment = (e.NewValues["EmpireMarketSubsegment"] != null) ? e.NewValues["EmpireMarketSubsegment"].ToString() : "";
            string application = (e.NewValues["EmpireApplication"] != null) ? e.NewValues["EmpireApplication"].ToString() : "";

            DateTime? sop = null;
            if (e.NewValues["EmpireSOP"] != null) sop = Convert.ToDateTime(e.NewValues["PurchaseOrderSOP"]);

            DateTime? eop = null;
            if (e.NewValues["EmpireEOP"] != null) eop = Convert.ToDateTime(e.NewValues["PurchaseOrderEOP"]);



            string comments = "";
            var vComments = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "Comments");
            if (vComments != null) comments = vComments.ToString();

            string eopNote = "";
            var vEopNote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "EmpireEOPNote");
            if (vEopNote != null) eopNote = vEopNote.ToString();

            ViewModel.SetBasePartAttributes(quote, basePartFamily, productLine, marketSegment, marketSubsegment, application, sop, eop, eopNote, comments);
            if (ViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at SetAssemblyTesterTooling. {0}", ViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        #endregion


        #region Document Methods

        private void ShowQuoteFiles(string attachmentCategory)
        {
            string quote = "";
            var vQuote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
            if (vQuote != null) quote = vQuote.ToString();

            DocsViewModel.ShowQuoteFileInfo(quote, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at ShowQuoteFiles. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return;
            }

            tbxDocName.Text = DocsViewModel.QuoteFileName;
            btnDocGet.Enabled = true;
        }

        private void GetFile(string attachmentCategory)
        {
            string quote = "";
            var vQuote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
            if (vQuote != null) quote = vQuote.ToString();

            string fileName;
            byte[] fileContents;
            DocsViewModel.GetQuoteFile(quote, attachmentCategory, out fileName, out fileContents);

            // Separate the file's name and its extension
            int i = fileName.IndexOf('.');
            int totalLength = fileName.Length;
            int extensionLength = totalLength - i;

            string file = fileName.Remove(i, extensionLength);
            string fileType = fileName.Substring(i + 1);

            // Add a random number to the file's name to prevent locking issues
            int random = DateTime.Now.GetHashCode();
            if (random < 0) random = random * -1;
            string tempFileName = file + "_" + random.ToString() + "." + fileType;

            // Set the path where the file's contents will be written
            string path = @"C:\inetpub\wwwroot\WebPortal\temp\";
            string filePathQuotePrint = path + tempFileName;

            // Write the file contents out
            var fs = new System.IO.FileStream(filePathQuotePrint, FileMode.OpenOrCreate);
            fs.Write(fileContents, 0, fileContents.Length);
            fs.Flush();
            fs.Close();

            // Open a page to display the file if it's a PDF; otherwise, download the file.
            Session["FileType"] = fileType;
            Session["FileName"] = fileName;
            Session["FileLength"] = fileContents.Length;
            Session["FilePath"] = filePathQuotePrint;
            string s = "window.open('DocumentGet.aspx', 'popup_window', 'width=600,height=400,left=100,top=100,resizable=yes');";
            ClientScript.RegisterStartupScript(this.GetType(), "script", s, true);

            //btnDocGet2.Focus();
        }

        private int DeleteFile()
        {
            string quote = "";
            var vQuote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
            if (vQuote != null) quote = vQuote.ToString();

            string attachmentCategory = Session["AttachmentCategory"].ToString();

            DocsViewModel.DeleteQuoteFile(quote, attachmentCategory);
            if (DocsViewModel.Error != "")
            {
                lblError.Text = String.Format("Error at DeleteFile. {0}", DocsViewModel.Error);
                pcError.ShowOnPageLoad = true;
                return 0;
            }
            return 1;
        }

        private int SaveFile()
        {
            string quote = "";
            var vQuote = gvQuote.GetRowValues(gvQuote.FocusedRowIndex, "QuoteNumber");
            if (vQuote != null) quote = vQuote.ToString();

            string attachmentCategory = Session["AttachmentCategory"].ToString();

            try
            {
                string fileName = Path.GetFileName(FileUploadControl.FileName);

                byte[] fileContents = FileUploadControl.FileBytes;

                DocumentationViewModel viewModel = new DocumentationViewModel();
                viewModel.SaveQuoteFile(quote, attachmentCategory, fileName, fileContents);

                lblUploadStatus.Text = "File uploaded";
            }
            catch (Exception ex)
            {
                lblUploadStatus.Text = "The file could not be uploaded. The following error occured: " + ex.Message;
                return 0;
            }
            return 1;
        }




        #endregion


    }
}