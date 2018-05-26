namespace QuoteLogGrid.Forms
{
    partial class formQuoteMaintenance
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnPrint = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.cbxRepeat = new System.Windows.Forms.CheckBox();
            this.lblMessage = new System.Windows.Forms.Label();
            this.gridControl2 = new DevExpress.XtraGrid.GridControl();
            this.layoutView1 = new DevExpress.XtraGrid.Views.Layout.LayoutView();
            this.colQuoteNumber = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colCustomer = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.customersItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView3 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colCustomerRFQNumber = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colRequestedDueDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEEIPromisedDueDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colCustomerPartNumber = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEEIPartNumber = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colNotes = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEAU = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colApplicationName = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colFunctionName = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.functionsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView10 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colOEM = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colQuotePrice = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colAwarded = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colCustomerQuoteDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colApplicationCode = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.applicationCodeItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView12 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colCustomerQuoteInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.customerQuoteInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView9 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colModelYear = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colReceiptDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colProgramManagerInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.programManagerInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.repositoryItemGridLookUpEdit1View = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colEngineeringInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.engineeringInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView5 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colSalesInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.salesInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.salesInitialsItemGridLookUpEditView = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colStraightMaterialCost = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colQuoteReviewInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.quoteReviewInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView7 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colQuoteReviewDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colQuotePricingInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.quotePricingInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView8 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colQuotePricingDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEngineeringMaterialsInitials = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.engineeringMaterialsInitialsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView6 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colEngineeringMaterialsDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colTooling = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colProgram = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colPrototypePrice = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colParentQuoteID = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colNamePlate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colSOP = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEOP = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colRequote = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.requoteItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView2 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colStdHours = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colPackageNuber = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colProductLine = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.productLinesItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView13 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colQuoteReason = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.quoteReasonsItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView1 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colPrintFilePath = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colCustomerQuoteFilePath = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colEmpireMarketSegment = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.marketSegmentItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView14 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colEmpireMarketSubsegment = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.marketSubsegmentItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView15 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.applicationNamesItemGridLookUpEdit = new DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit();
            this.gridView11 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.lblCustomerQuote = new System.Windows.Forms.Label();
            this.lnkSaveQuotePrint = new System.Windows.Forms.LinkLabel();
            this.lblQuotePrint = new System.Windows.Forms.Label();
            this.lnkSaveCustomerQuote = new System.Windows.Forms.LinkLabel();
            this.label4 = new System.Windows.Forms.Label();
            this.lnkGetQuotePrint = new System.Windows.Forms.LinkLabel();
            this.label3 = new System.Windows.Forms.Label();
            this.lnkGetCustomerQuote = new System.Windows.Forms.LinkLabel();
            this.labelControl3 = new DevExpress.XtraEditors.LabelControl();
            this.lnkDeleteQuotePrint = new System.Windows.Forms.LinkLabel();
            this.label2 = new System.Windows.Forms.Label();
            this.lnkDeleteCustomerQuote = new System.Windows.Forms.LinkLabel();
            this.panelPrint = new System.Windows.Forms.Panel();
            this.tbxPrintNo = new System.Windows.Forms.TextBox();
            this.labelControl2 = new DevExpress.XtraEditors.LabelControl();
            this.dateEditPrint = new DevExpress.XtraEditors.DateEdit();
            this.linkRemoveCustomerQuote = new System.Windows.Forms.LinkLabel();
            this.linkAddViewCustomerQuote = new System.Windows.Forms.LinkLabel();
            this.tbxCustQuoteFilePath = new System.Windows.Forms.TextBox();
            this.labelControl1 = new DevExpress.XtraEditors.LabelControl();
            this.label1 = new System.Windows.Forms.Label();
            this.linkRemovePrint = new System.Windows.Forms.LinkLabel();
            this.linkAddViewPrint = new System.Windows.Forms.LinkLabel();
            this.tbxPrintFilePath = new System.Windows.Forms.TextBox();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.gridControl3 = new DevExpress.XtraGrid.GridControl();
            this.gridView4 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.label5 = new System.Windows.Forms.Label();
            this.btnCSM = new System.Windows.Forms.Button();
            this.colMinimumOrderQuantity = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.colAwardedDate = new DevExpress.XtraGrid.Columns.LayoutViewColumn();
            this.layoutViewCard1 = new DevExpress.XtraGrid.Views.Layout.LayoutViewCard();
            this.layoutViewField_layoutViewColumn1 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_8 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.item1 = new DevExpress.XtraLayout.SimpleSeparator();
            this.layoutViewField_layoutViewColumn1_21 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_3 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_1 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_22 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_23 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_24 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_25 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_2 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_4 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_5 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_13 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_6 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_18 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_20 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_10 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_11 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_9 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_26 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.item2 = new DevExpress.XtraLayout.SimpleSeparator();
            this.item3 = new DevExpress.XtraLayout.SimpleSeparator();
            this.item4 = new DevExpress.XtraLayout.SimpleSeparator();
            this.layoutViewField_layoutViewColumn1_30 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_31 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_32 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_34 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_12 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_14 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_27 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_28 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_19 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_17 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_29 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_35 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_36 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_7 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_37 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_15 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_38 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_41 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_42 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_43 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_44 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_16 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_40 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_39 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_45 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_46 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.layoutViewField_layoutViewColumn1_33 = new DevExpress.XtraGrid.Views.Layout.LayoutViewField();
            this.tableLayoutPanel1.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridControl2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.customersItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.functionsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView10)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.applicationCodeItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView12)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.customerQuoteInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView9)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.programManagerInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemGridLookUpEdit1View)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.engineeringInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.salesInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.salesInitialsItemGridLookUpEditView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.quoteReviewInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView7)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.quotePricingInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView8)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.engineeringMaterialsInitialsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView6)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.requoteItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.productLinesItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView13)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.quoteReasonsItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.marketSegmentItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView14)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.marketSubsegmentItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView15)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.applicationNamesItemGridLookUpEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView11)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panelPrint.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dateEditPrint.Properties.CalendarTimeProperties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dateEditPrint.Properties)).BeginInit();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridControl3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewCard1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_8)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.item1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_21)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_22)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_23)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_24)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_25)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_13)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_6)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_18)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_20)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_10)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_11)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_9)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_26)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.item2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.item3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.item4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_30)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_31)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_32)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_34)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_12)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_14)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_27)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_28)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_19)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_17)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_29)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_35)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_36)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_7)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_37)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_15)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_38)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_41)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_42)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_43)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_44)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_16)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_40)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_39)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_45)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_46)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_33)).BeginInit();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.flowLayoutPanel1, 0, 3);
            this.tableLayoutPanel1.Controls.Add(this.gridControl2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.panel1, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 2);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(4);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 4;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 526F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 94F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 170F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 55F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(1924, 1017);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.btnClose);
            this.flowLayoutPanel1.Controls.Add(this.btnPrint);
            this.flowLayoutPanel1.Controls.Add(this.btnSave);
            this.flowLayoutPanel1.Controls.Add(this.cbxRepeat);
            this.flowLayoutPanel1.Controls.Add(this.lblMessage);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.RightToLeft;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(4, 794);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(4);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(1916, 219);
            this.flowLayoutPanel1.TabIndex = 1;
            // 
            // btnClose
            // 
            this.btnClose.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnClose.Location = new System.Drawing.Point(1759, 4);
            this.btnClose.Margin = new System.Windows.Forms.Padding(4);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(153, 35);
            this.btnClose.TabIndex = 2;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnPrint
            // 
            this.btnPrint.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPrint.Location = new System.Drawing.Point(1598, 4);
            this.btnPrint.Margin = new System.Windows.Forms.Padding(4);
            this.btnPrint.Name = "btnPrint";
            this.btnPrint.Size = new System.Drawing.Size(153, 35);
            this.btnPrint.TabIndex = 1;
            this.btnPrint.Text = "Print";
            this.btnPrint.UseVisualStyleBackColor = true;
            this.btnPrint.Click += new System.EventHandler(this.btnPrint_Click);
            // 
            // btnSave
            // 
            this.btnSave.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSave.Location = new System.Drawing.Point(1437, 4);
            this.btnSave.Margin = new System.Windows.Forms.Padding(4);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(153, 35);
            this.btnSave.TabIndex = 0;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // cbxRepeat
            // 
            this.cbxRepeat.AutoSize = true;
            this.cbxRepeat.Location = new System.Drawing.Point(1353, 4);
            this.cbxRepeat.Margin = new System.Windows.Forms.Padding(4);
            this.cbxRepeat.Name = "cbxRepeat";
            this.cbxRepeat.Size = new System.Drawing.Size(76, 21);
            this.cbxRepeat.TabIndex = 3;
            this.cbxRepeat.Text = "Repeat";
            this.cbxRepeat.UseVisualStyleBackColor = true;
            // 
            // lblMessage
            // 
            this.lblMessage.AutoSize = true;
            this.lblMessage.Location = new System.Drawing.Point(1299, 0);
            this.lblMessage.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblMessage.Name = "lblMessage";
            this.lblMessage.Size = new System.Drawing.Size(46, 17);
            this.lblMessage.TabIndex = 0;
            this.lblMessage.Text = "label1";
            this.lblMessage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // gridControl2
            // 
            this.gridControl2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.gridControl2.EmbeddedNavigator.Margin = new System.Windows.Forms.Padding(4);
            this.gridControl2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.gridControl2.Location = new System.Drawing.Point(4, 4);
            this.gridControl2.MainView = this.layoutView1;
            this.gridControl2.Margin = new System.Windows.Forms.Padding(4);
            this.gridControl2.Name = "gridControl2";
            this.gridControl2.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.requoteItemGridLookUpEdit,
            this.customersItemGridLookUpEdit,
            this.salesInitialsItemGridLookUpEdit,
            this.programManagerInitialsItemGridLookUpEdit,
            this.engineeringInitialsItemGridLookUpEdit,
            this.engineeringMaterialsInitialsItemGridLookUpEdit,
            this.quoteReviewInitialsItemGridLookUpEdit,
            this.quotePricingInitialsItemGridLookUpEdit,
            this.customerQuoteInitialsItemGridLookUpEdit,
            this.functionsItemGridLookUpEdit,
            this.applicationNamesItemGridLookUpEdit,
            this.applicationCodeItemGridLookUpEdit,
            this.quoteReasonsItemGridLookUpEdit,
            this.productLinesItemGridLookUpEdit,
            this.marketSegmentItemGridLookUpEdit,
            this.marketSubsegmentItemGridLookUpEdit});
            this.gridControl2.Size = new System.Drawing.Size(1916, 518);
            this.gridControl2.TabIndex = 2;
            this.gridControl2.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.layoutView1});
            // 
            // layoutView1
            // 
            this.layoutView1.Appearance.Card.Font = new System.Drawing.Font("Tahoma", 10F);
            this.layoutView1.Appearance.Card.Options.UseFont = true;
            this.layoutView1.Appearance.FieldEditingValue.BorderColor = System.Drawing.Color.White;
            this.layoutView1.Appearance.FieldEditingValue.Options.UseBorderColor = true;
            this.layoutView1.Appearance.FieldEditingValue.Options.UseTextOptions = true;
            this.layoutView1.Appearance.FieldEditingValue.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap;
            this.layoutView1.Appearance.FieldValue.BorderColor = System.Drawing.Color.White;
            this.layoutView1.Appearance.FieldValue.Options.UseBorderColor = true;
            this.layoutView1.Appearance.FieldValue.Options.UseTextOptions = true;
            this.layoutView1.Appearance.FieldValue.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap;
            this.layoutView1.CardMinSize = new System.Drawing.Size(877, 547);
            this.layoutView1.Columns.AddRange(new DevExpress.XtraGrid.Columns.LayoutViewColumn[] {
            this.colQuoteNumber,
            this.colCustomer,
            this.colCustomerRFQNumber,
            this.colRequestedDueDate,
            this.colEEIPromisedDueDate,
            this.colCustomerPartNumber,
            this.colEEIPartNumber,
            this.colNotes,
            this.colEAU,
            this.colApplicationName,
            this.colFunctionName,
            this.colOEM,
            this.colQuotePrice,
            this.colAwarded,
            this.colCustomerQuoteDate,
            this.colApplicationCode,
            this.colCustomerQuoteInitials,
            this.colModelYear,
            this.colReceiptDate,
            this.colProgramManagerInitials,
            this.colEngineeringInitials,
            this.colSalesInitials,
            this.colStraightMaterialCost,
            this.colQuoteReviewInitials,
            this.colQuoteReviewDate,
            this.colQuotePricingInitials,
            this.colQuotePricingDate,
            this.colEngineeringMaterialsInitials,
            this.colEngineeringMaterialsDate,
            this.colTooling,
            this.colProgram,
            this.colPrototypePrice,
            this.colParentQuoteID,
            this.colNamePlate,
            this.colSOP,
            this.colEOP,
            this.colRequote,
            this.colStdHours,
            this.colPackageNuber,
            this.colProductLine,
            this.colQuoteReason,
            this.colPrintFilePath,
            this.colCustomerQuoteFilePath,
            this.colEmpireMarketSegment,
            this.colEmpireMarketSubsegment,
            this.colMinimumOrderQuantity,
            this.colAwardedDate});
            this.layoutView1.GridControl = this.gridControl2;
            this.layoutView1.HiddenItems.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[] {
            this.layoutViewField_layoutViewColumn1_33});
            this.layoutView1.Name = "layoutView1";
            this.layoutView1.OptionsCustomization.AllowFilter = false;
            this.layoutView1.OptionsCustomization.AllowSort = false;
            this.layoutView1.TemplateCard = this.layoutViewCard1;
            this.layoutView1.CellValueChanged += new DevExpress.XtraGrid.Views.Base.CellValueChangedEventHandler(this.layoutView1_CellValueChanged);
            // 
            // colQuoteNumber
            // 
            this.colQuoteNumber.AppearanceCell.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Bold);
            this.colQuoteNumber.AppearanceCell.Options.UseFont = true;
            this.colQuoteNumber.FieldName = "QuoteNumber";
            this.colQuoteNumber.LayoutViewField = this.layoutViewField_layoutViewColumn1;
            this.colQuoteNumber.Name = "colQuoteNumber";
            // 
            // colCustomer
            // 
            this.colCustomer.ColumnEdit = this.customersItemGridLookUpEdit;
            this.colCustomer.FieldName = "Customer";
            this.colCustomer.LayoutViewField = this.layoutViewField_layoutViewColumn1_1;
            this.colCustomer.Name = "colCustomer";
            // 
            // customersItemGridLookUpEdit
            // 
            this.customersItemGridLookUpEdit.AutoHeight = false;
            this.customersItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.customersItemGridLookUpEdit.DisplayMember = "CustomerCode";
            this.customersItemGridLookUpEdit.Name = "customersItemGridLookUpEdit";
            this.customersItemGridLookUpEdit.NullText = "";
            this.customersItemGridLookUpEdit.PopupView = this.gridView3;
            this.customersItemGridLookUpEdit.ValueMember = "CustomerCode";
            // 
            // gridView3
            // 
            this.gridView3.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView3.Name = "gridView3";
            this.gridView3.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView3.OptionsView.ShowGroupPanel = false;
            // 
            // colCustomerRFQNumber
            // 
            this.colCustomerRFQNumber.FieldName = "CustomerRFQNumber";
            this.colCustomerRFQNumber.LayoutViewField = this.layoutViewField_layoutViewColumn1_2;
            this.colCustomerRFQNumber.Name = "colCustomerRFQNumber";
            // 
            // colRequestedDueDate
            // 
            this.colRequestedDueDate.FieldName = "RequestedDueDate";
            this.colRequestedDueDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_3;
            this.colRequestedDueDate.Name = "colRequestedDueDate";
            // 
            // colEEIPromisedDueDate
            // 
            this.colEEIPromisedDueDate.FieldName = "EEIPromisedDueDate";
            this.colEEIPromisedDueDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_4;
            this.colEEIPromisedDueDate.Name = "colEEIPromisedDueDate";
            // 
            // colCustomerPartNumber
            // 
            this.colCustomerPartNumber.FieldName = "CustomerPartNumber";
            this.colCustomerPartNumber.LayoutViewField = this.layoutViewField_layoutViewColumn1_5;
            this.colCustomerPartNumber.Name = "colCustomerPartNumber";
            // 
            // colEEIPartNumber
            // 
            this.colEEIPartNumber.FieldName = "EEIPartNumber";
            this.colEEIPartNumber.LayoutViewField = this.layoutViewField_layoutViewColumn1_6;
            this.colEEIPartNumber.Name = "colEEIPartNumber";
            // 
            // colNotes
            // 
            this.colNotes.AppearanceCell.Options.UseTextOptions = true;
            this.colNotes.AppearanceCell.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap;
            this.colNotes.FieldName = "Notes";
            this.colNotes.LayoutViewField = this.layoutViewField_layoutViewColumn1_8;
            this.colNotes.Name = "colNotes";
            // 
            // colEAU
            // 
            this.colEAU.FieldName = "EAU";
            this.colEAU.LayoutViewField = this.layoutViewField_layoutViewColumn1_9;
            this.colEAU.Name = "colEAU";
            // 
            // colApplicationName
            // 
            this.colApplicationName.FieldName = "ApplicationName";
            this.colApplicationName.LayoutViewField = this.layoutViewField_layoutViewColumn1_10;
            this.colApplicationName.Name = "colApplicationName";
            // 
            // colFunctionName
            // 
            this.colFunctionName.ColumnEdit = this.functionsItemGridLookUpEdit;
            this.colFunctionName.FieldName = "FunctionName";
            this.colFunctionName.LayoutViewField = this.layoutViewField_layoutViewColumn1_11;
            this.colFunctionName.Name = "colFunctionName";
            // 
            // functionsItemGridLookUpEdit
            // 
            this.functionsItemGridLookUpEdit.AutoHeight = false;
            this.functionsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.functionsItemGridLookUpEdit.DisplayMember = "FunctionCode";
            this.functionsItemGridLookUpEdit.Name = "functionsItemGridLookUpEdit";
            this.functionsItemGridLookUpEdit.NullText = "";
            this.functionsItemGridLookUpEdit.PopupView = this.gridView10;
            this.functionsItemGridLookUpEdit.ValueMember = "FunctionCode";
            // 
            // gridView10
            // 
            this.gridView10.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView10.Name = "gridView10";
            this.gridView10.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView10.OptionsView.ShowGroupPanel = false;
            // 
            // colOEM
            // 
            this.colOEM.FieldName = "OEM";
            this.colOEM.LayoutViewField = this.layoutViewField_layoutViewColumn1_13;
            this.colOEM.Name = "colOEM";
            // 
            // colQuotePrice
            // 
            this.colQuotePrice.FieldName = "QuotePrice";
            this.colQuotePrice.LayoutViewField = this.layoutViewField_layoutViewColumn1_15;
            this.colQuotePrice.Name = "colQuotePrice";
            // 
            // colAwarded
            // 
            this.colAwarded.FieldName = "Awarded";
            this.colAwarded.LayoutViewField = this.layoutViewField_layoutViewColumn1_16;
            this.colAwarded.Name = "colAwarded";
            // 
            // colCustomerQuoteDate
            // 
            this.colCustomerQuoteDate.FieldName = "CustomerQuoteDate";
            this.colCustomerQuoteDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_17;
            this.colCustomerQuoteDate.Name = "colCustomerQuoteDate";
            // 
            // colApplicationCode
            // 
            this.colApplicationCode.ColumnEdit = this.applicationCodeItemGridLookUpEdit;
            this.colApplicationCode.FieldName = "ApplicationCode";
            this.colApplicationCode.LayoutViewField = this.layoutViewField_layoutViewColumn1_18;
            this.colApplicationCode.Name = "colApplicationCode";
            // 
            // applicationCodeItemGridLookUpEdit
            // 
            this.applicationCodeItemGridLookUpEdit.AutoHeight = false;
            this.applicationCodeItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.applicationCodeItemGridLookUpEdit.DisplayMember = "ApplicationCode";
            this.applicationCodeItemGridLookUpEdit.Name = "applicationCodeItemGridLookUpEdit";
            this.applicationCodeItemGridLookUpEdit.NullText = "";
            this.applicationCodeItemGridLookUpEdit.PopupView = this.gridView12;
            this.applicationCodeItemGridLookUpEdit.ValueMember = "ApplicationCode";
            // 
            // gridView12
            // 
            this.gridView12.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView12.Name = "gridView12";
            this.gridView12.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView12.OptionsView.ShowGroupPanel = false;
            // 
            // colCustomerQuoteInitials
            // 
            this.colCustomerQuoteInitials.ColumnEdit = this.customerQuoteInitialsItemGridLookUpEdit;
            this.colCustomerQuoteInitials.FieldName = "CustomerQuoteInitials";
            this.colCustomerQuoteInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_19;
            this.colCustomerQuoteInitials.Name = "colCustomerQuoteInitials";
            // 
            // customerQuoteInitialsItemGridLookUpEdit
            // 
            this.customerQuoteInitialsItemGridLookUpEdit.AutoHeight = false;
            this.customerQuoteInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.customerQuoteInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.customerQuoteInitialsItemGridLookUpEdit.Name = "customerQuoteInitialsItemGridLookUpEdit";
            this.customerQuoteInitialsItemGridLookUpEdit.NullText = "";
            this.customerQuoteInitialsItemGridLookUpEdit.PopupView = this.gridView9;
            this.customerQuoteInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // gridView9
            // 
            this.gridView9.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView9.Name = "gridView9";
            this.gridView9.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView9.OptionsView.ShowGroupPanel = false;
            // 
            // colModelYear
            // 
            this.colModelYear.FieldName = "ModelYear";
            this.colModelYear.LayoutViewField = this.layoutViewField_layoutViewColumn1_20;
            this.colModelYear.Name = "colModelYear";
            // 
            // colReceiptDate
            // 
            this.colReceiptDate.FieldName = "ReceiptDate";
            this.colReceiptDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_21;
            this.colReceiptDate.Name = "colReceiptDate";
            // 
            // colProgramManagerInitials
            // 
            this.colProgramManagerInitials.ColumnEdit = this.programManagerInitialsItemGridLookUpEdit;
            this.colProgramManagerInitials.FieldName = "ProgramManagerInitials";
            this.colProgramManagerInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_22;
            this.colProgramManagerInitials.Name = "colProgramManagerInitials";
            // 
            // programManagerInitialsItemGridLookUpEdit
            // 
            this.programManagerInitialsItemGridLookUpEdit.AutoHeight = false;
            this.programManagerInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.programManagerInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.programManagerInitialsItemGridLookUpEdit.Name = "programManagerInitialsItemGridLookUpEdit";
            this.programManagerInitialsItemGridLookUpEdit.NullText = "";
            this.programManagerInitialsItemGridLookUpEdit.PopupView = this.repositoryItemGridLookUpEdit1View;
            this.programManagerInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // repositoryItemGridLookUpEdit1View
            // 
            this.repositoryItemGridLookUpEdit1View.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.repositoryItemGridLookUpEdit1View.Name = "repositoryItemGridLookUpEdit1View";
            this.repositoryItemGridLookUpEdit1View.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.repositoryItemGridLookUpEdit1View.OptionsView.ShowGroupPanel = false;
            // 
            // colEngineeringInitials
            // 
            this.colEngineeringInitials.ColumnEdit = this.engineeringInitialsItemGridLookUpEdit;
            this.colEngineeringInitials.FieldName = "EngineeringInitials";
            this.colEngineeringInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_23;
            this.colEngineeringInitials.Name = "colEngineeringInitials";
            // 
            // engineeringInitialsItemGridLookUpEdit
            // 
            this.engineeringInitialsItemGridLookUpEdit.AutoHeight = false;
            this.engineeringInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.engineeringInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.engineeringInitialsItemGridLookUpEdit.Name = "engineeringInitialsItemGridLookUpEdit";
            this.engineeringInitialsItemGridLookUpEdit.NullText = "";
            this.engineeringInitialsItemGridLookUpEdit.PopupView = this.gridView5;
            this.engineeringInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // gridView5
            // 
            this.gridView5.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView5.Name = "gridView5";
            this.gridView5.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView5.OptionsView.ShowGroupPanel = false;
            // 
            // colSalesInitials
            // 
            this.colSalesInitials.ColumnEdit = this.salesInitialsItemGridLookUpEdit;
            this.colSalesInitials.FieldName = "SalesInitials";
            this.colSalesInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_24;
            this.colSalesInitials.Name = "colSalesInitials";
            // 
            // salesInitialsItemGridLookUpEdit
            // 
            this.salesInitialsItemGridLookUpEdit.AutoHeight = false;
            this.salesInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.salesInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.salesInitialsItemGridLookUpEdit.Name = "salesInitialsItemGridLookUpEdit";
            this.salesInitialsItemGridLookUpEdit.NullText = "";
            this.salesInitialsItemGridLookUpEdit.PopupView = this.salesInitialsItemGridLookUpEditView;
            this.salesInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // salesInitialsItemGridLookUpEditView
            // 
            this.salesInitialsItemGridLookUpEditView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.salesInitialsItemGridLookUpEditView.Name = "salesInitialsItemGridLookUpEditView";
            this.salesInitialsItemGridLookUpEditView.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.salesInitialsItemGridLookUpEditView.OptionsView.ShowGroupPanel = false;
            // 
            // colStraightMaterialCost
            // 
            this.colStraightMaterialCost.FieldName = "StraightMaterialCost";
            this.colStraightMaterialCost.LayoutViewField = this.layoutViewField_layoutViewColumn1_26;
            this.colStraightMaterialCost.Name = "colStraightMaterialCost";
            // 
            // colQuoteReviewInitials
            // 
            this.colQuoteReviewInitials.ColumnEdit = this.quoteReviewInitialsItemGridLookUpEdit;
            this.colQuoteReviewInitials.FieldName = "QuoteReviewInitials";
            this.colQuoteReviewInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_12;
            this.colQuoteReviewInitials.Name = "colQuoteReviewInitials";
            // 
            // quoteReviewInitialsItemGridLookUpEdit
            // 
            this.quoteReviewInitialsItemGridLookUpEdit.AutoHeight = false;
            this.quoteReviewInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.quoteReviewInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.quoteReviewInitialsItemGridLookUpEdit.Name = "quoteReviewInitialsItemGridLookUpEdit";
            this.quoteReviewInitialsItemGridLookUpEdit.NullText = "";
            this.quoteReviewInitialsItemGridLookUpEdit.PopupView = this.gridView7;
            this.quoteReviewInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // gridView7
            // 
            this.gridView7.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView7.Name = "gridView7";
            this.gridView7.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView7.OptionsView.ShowGroupPanel = false;
            // 
            // colQuoteReviewDate
            // 
            this.colQuoteReviewDate.FieldName = "QuoteReviewDate";
            this.colQuoteReviewDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_14;
            this.colQuoteReviewDate.Name = "colQuoteReviewDate";
            // 
            // colQuotePricingInitials
            // 
            this.colQuotePricingInitials.ColumnEdit = this.quotePricingInitialsItemGridLookUpEdit;
            this.colQuotePricingInitials.FieldName = "QuotePricingInitials";
            this.colQuotePricingInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_27;
            this.colQuotePricingInitials.Name = "colQuotePricingInitials";
            // 
            // quotePricingInitialsItemGridLookUpEdit
            // 
            this.quotePricingInitialsItemGridLookUpEdit.AutoHeight = false;
            this.quotePricingInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.quotePricingInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.quotePricingInitialsItemGridLookUpEdit.Name = "quotePricingInitialsItemGridLookUpEdit";
            this.quotePricingInitialsItemGridLookUpEdit.NullText = "";
            this.quotePricingInitialsItemGridLookUpEdit.PopupView = this.gridView8;
            this.quotePricingInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // gridView8
            // 
            this.gridView8.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView8.Name = "gridView8";
            this.gridView8.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView8.OptionsView.ShowGroupPanel = false;
            // 
            // colQuotePricingDate
            // 
            this.colQuotePricingDate.FieldName = "QuotePricingDate";
            this.colQuotePricingDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_28;
            this.colQuotePricingDate.Name = "colQuotePricingDate";
            // 
            // colEngineeringMaterialsInitials
            // 
            this.colEngineeringMaterialsInitials.ColumnEdit = this.engineeringMaterialsInitialsItemGridLookUpEdit;
            this.colEngineeringMaterialsInitials.FieldName = "EngineeringMaterialsInitials";
            this.colEngineeringMaterialsInitials.LayoutViewField = this.layoutViewField_layoutViewColumn1_25;
            this.colEngineeringMaterialsInitials.Name = "colEngineeringMaterialsInitials";
            // 
            // engineeringMaterialsInitialsItemGridLookUpEdit
            // 
            this.engineeringMaterialsInitialsItemGridLookUpEdit.AutoHeight = false;
            this.engineeringMaterialsInitialsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.engineeringMaterialsInitialsItemGridLookUpEdit.DisplayMember = "Initials";
            this.engineeringMaterialsInitialsItemGridLookUpEdit.Name = "engineeringMaterialsInitialsItemGridLookUpEdit";
            this.engineeringMaterialsInitialsItemGridLookUpEdit.NullText = "";
            this.engineeringMaterialsInitialsItemGridLookUpEdit.PopupView = this.gridView6;
            this.engineeringMaterialsInitialsItemGridLookUpEdit.ValueMember = "Initials";
            // 
            // gridView6
            // 
            this.gridView6.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView6.Name = "gridView6";
            this.gridView6.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView6.OptionsView.ShowGroupPanel = false;
            // 
            // colEngineeringMaterialsDate
            // 
            this.colEngineeringMaterialsDate.FieldName = "EngineeringMaterialsDate";
            this.colEngineeringMaterialsDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_29;
            this.colEngineeringMaterialsDate.Name = "colEngineeringMaterialsDate";
            // 
            // colTooling
            // 
            this.colTooling.Caption = "Tooling Cost";
            this.colTooling.FieldName = "Tooling";
            this.colTooling.LayoutViewField = this.layoutViewField_layoutViewColumn1_30;
            this.colTooling.Name = "colTooling";
            // 
            // colProgram
            // 
            this.colProgram.FieldName = "Program";
            this.colProgram.LayoutViewField = this.layoutViewField_layoutViewColumn1_31;
            this.colProgram.Name = "colProgram";
            // 
            // colPrototypePrice
            // 
            this.colPrototypePrice.FieldName = "PrototypePrice";
            this.colPrototypePrice.LayoutViewField = this.layoutViewField_layoutViewColumn1_32;
            this.colPrototypePrice.Name = "colPrototypePrice";
            // 
            // colParentQuoteID
            // 
            this.colParentQuoteID.FieldName = "ParentQuoteID";
            this.colParentQuoteID.LayoutViewField = this.layoutViewField_layoutViewColumn1_33;
            this.colParentQuoteID.Name = "colParentQuoteID";
            // 
            // colNamePlate
            // 
            this.colNamePlate.FieldName = "Nameplate";
            this.colNamePlate.LayoutViewField = this.layoutViewField_layoutViewColumn1_34;
            this.colNamePlate.Name = "colNamePlate";
            // 
            // colSOP
            // 
            this.colSOP.FieldName = "SOP";
            this.colSOP.LayoutViewField = this.layoutViewField_layoutViewColumn1_35;
            this.colSOP.Name = "colSOP";
            // 
            // colEOP
            // 
            this.colEOP.FieldName = "EOP";
            this.colEOP.LayoutViewField = this.layoutViewField_layoutViewColumn1_36;
            this.colEOP.Name = "colEOP";
            // 
            // colRequote
            // 
            this.colRequote.ColumnEdit = this.requoteItemGridLookUpEdit;
            this.colRequote.FieldName = "Requote";
            this.colRequote.LayoutViewField = this.layoutViewField_layoutViewColumn1_7;
            this.colRequote.Name = "colRequote";
            // 
            // requoteItemGridLookUpEdit
            // 
            this.requoteItemGridLookUpEdit.AutoHeight = false;
            this.requoteItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.requoteItemGridLookUpEdit.DisplayMember = "Type";
            this.requoteItemGridLookUpEdit.Name = "requoteItemGridLookUpEdit";
            this.requoteItemGridLookUpEdit.NullText = "";
            this.requoteItemGridLookUpEdit.PopupView = this.gridView2;
            this.requoteItemGridLookUpEdit.ValueMember = "Type";
            // 
            // gridView2
            // 
            this.gridView2.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView2.Name = "gridView2";
            this.gridView2.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView2.OptionsView.ShowGroupPanel = false;
            // 
            // colStdHours
            // 
            this.colStdHours.Caption = "Std Hours";
            this.colStdHours.FieldName = "StdHours";
            this.colStdHours.LayoutViewField = this.layoutViewField_layoutViewColumn1_37;
            this.colStdHours.Name = "colStdHours";
            // 
            // colPackageNuber
            // 
            this.colPackageNuber.Caption = "PackageNumber";
            this.colPackageNuber.FieldName = "PackageNumber";
            this.colPackageNuber.LayoutViewField = this.layoutViewField_layoutViewColumn1_38;
            this.colPackageNuber.Name = "colPackageNuber";
            // 
            // colProductLine
            // 
            this.colProductLine.Caption = "ProductLine";
            this.colProductLine.ColumnEdit = this.productLinesItemGridLookUpEdit;
            this.colProductLine.FieldName = "ProductLine";
            this.colProductLine.LayoutViewField = this.layoutViewField_layoutViewColumn1_40;
            this.colProductLine.Name = "colProductLine";
            // 
            // productLinesItemGridLookUpEdit
            // 
            this.productLinesItemGridLookUpEdit.AutoHeight = false;
            this.productLinesItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.productLinesItemGridLookUpEdit.DisplayMember = "ProductLine";
            this.productLinesItemGridLookUpEdit.Name = "productLinesItemGridLookUpEdit";
            this.productLinesItemGridLookUpEdit.NullText = "";
            this.productLinesItemGridLookUpEdit.PopupView = this.gridView13;
            this.productLinesItemGridLookUpEdit.ValueMember = "ProductLine";
            // 
            // gridView13
            // 
            this.gridView13.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView13.Name = "gridView13";
            this.gridView13.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView13.OptionsView.ShowGroupPanel = false;
            // 
            // colQuoteReason
            // 
            this.colQuoteReason.Caption = "QuoteReason";
            this.colQuoteReason.ColumnEdit = this.quoteReasonsItemGridLookUpEdit;
            this.colQuoteReason.CustomizationCaption = "QuoteReason";
            this.colQuoteReason.FieldName = "QuoteReason";
            this.colQuoteReason.LayoutViewField = this.layoutViewField_layoutViewColumn1_39;
            this.colQuoteReason.Name = "colQuoteReason";
            // 
            // quoteReasonsItemGridLookUpEdit
            // 
            this.quoteReasonsItemGridLookUpEdit.AutoHeight = false;
            this.quoteReasonsItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.quoteReasonsItemGridLookUpEdit.DisplayMember = "QuoteReason";
            this.quoteReasonsItemGridLookUpEdit.Name = "quoteReasonsItemGridLookUpEdit";
            this.quoteReasonsItemGridLookUpEdit.NullText = "";
            this.quoteReasonsItemGridLookUpEdit.PopupView = this.gridView1;
            this.quoteReasonsItemGridLookUpEdit.ValueMember = "QuoteReason";
            // 
            // gridView1
            // 
            this.gridView1.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView1.Name = "gridView1";
            this.gridView1.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView1.OptionsView.ShowGroupPanel = false;
            // 
            // colPrintFilePath
            // 
            this.colPrintFilePath.Caption = "Print FilePath (Old)";
            this.colPrintFilePath.FieldName = "PrintFilePath";
            this.colPrintFilePath.LayoutViewField = this.layoutViewField_layoutViewColumn1_41;
            this.colPrintFilePath.Name = "colPrintFilePath";
            // 
            // colCustomerQuoteFilePath
            // 
            this.colCustomerQuoteFilePath.Caption = "Customer Quote FilePath (Old)";
            this.colCustomerQuoteFilePath.FieldName = "CustomerQuoteFilePath";
            this.colCustomerQuoteFilePath.LayoutViewField = this.layoutViewField_layoutViewColumn1_42;
            this.colCustomerQuoteFilePath.Name = "colCustomerQuoteFilePath";
            // 
            // colEmpireMarketSegment
            // 
            this.colEmpireMarketSegment.Caption = "EmpireMarketSegment";
            this.colEmpireMarketSegment.ColumnEdit = this.marketSegmentItemGridLookUpEdit;
            this.colEmpireMarketSegment.FieldName = "EmpireMarketSegment";
            this.colEmpireMarketSegment.LayoutViewField = this.layoutViewField_layoutViewColumn1_43;
            this.colEmpireMarketSegment.Name = "colEmpireMarketSegment";
            // 
            // marketSegmentItemGridLookUpEdit
            // 
            this.marketSegmentItemGridLookUpEdit.AutoHeight = false;
            this.marketSegmentItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.marketSegmentItemGridLookUpEdit.DisplayMember = "EmpireMarketSegment";
            this.marketSegmentItemGridLookUpEdit.Name = "marketSegmentItemGridLookUpEdit";
            this.marketSegmentItemGridLookUpEdit.NullText = "";
            this.marketSegmentItemGridLookUpEdit.PopupView = this.gridView14;
            this.marketSegmentItemGridLookUpEdit.ValueMember = "EmpireMarketSegment";
            // 
            // gridView14
            // 
            this.gridView14.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView14.Name = "gridView14";
            this.gridView14.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView14.OptionsView.ShowGroupPanel = false;
            // 
            // colEmpireMarketSubsegment
            // 
            this.colEmpireMarketSubsegment.Caption = "EmpireMarketSubsegment";
            this.colEmpireMarketSubsegment.ColumnEdit = this.marketSubsegmentItemGridLookUpEdit;
            this.colEmpireMarketSubsegment.FieldName = "EmpireMarketSubsegment";
            this.colEmpireMarketSubsegment.LayoutViewField = this.layoutViewField_layoutViewColumn1_44;
            this.colEmpireMarketSubsegment.Name = "colEmpireMarketSubsegment";
            // 
            // marketSubsegmentItemGridLookUpEdit
            // 
            this.marketSubsegmentItemGridLookUpEdit.AutoHeight = false;
            this.marketSubsegmentItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.marketSubsegmentItemGridLookUpEdit.DisplayMember = "EmpireMarketSubsegment";
            this.marketSubsegmentItemGridLookUpEdit.Name = "marketSubsegmentItemGridLookUpEdit";
            this.marketSubsegmentItemGridLookUpEdit.NullText = "";
            this.marketSubsegmentItemGridLookUpEdit.PopupView = this.gridView15;
            this.marketSubsegmentItemGridLookUpEdit.ValueMember = "EmpireMarketSubsegment";
            // 
            // gridView15
            // 
            this.gridView15.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView15.Name = "gridView15";
            this.gridView15.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView15.OptionsView.ShowGroupPanel = false;
            // 
            // applicationNamesItemGridLookUpEdit
            // 
            this.applicationNamesItemGridLookUpEdit.AutoHeight = false;
            this.applicationNamesItemGridLookUpEdit.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.applicationNamesItemGridLookUpEdit.DisplayMember = "ApplicationName";
            this.applicationNamesItemGridLookUpEdit.Name = "applicationNamesItemGridLookUpEdit";
            this.applicationNamesItemGridLookUpEdit.NullText = "";
            this.applicationNamesItemGridLookUpEdit.PopupView = this.gridView11;
            this.applicationNamesItemGridLookUpEdit.ValueMember = "ApplicationName";
            // 
            // gridView11
            // 
            this.gridView11.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            this.gridView11.Name = "gridView11";
            this.gridView11.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.gridView11.OptionsView.ShowGroupPanel = false;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.LightSteelBlue;
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Controls.Add(this.panelPrint);
            this.panel1.Controls.Add(this.linkRemoveCustomerQuote);
            this.panel1.Controls.Add(this.linkAddViewCustomerQuote);
            this.panel1.Controls.Add(this.tbxCustQuoteFilePath);
            this.panel1.Controls.Add(this.labelControl1);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.linkRemovePrint);
            this.panel1.Controls.Add(this.linkAddViewPrint);
            this.panel1.Controls.Add(this.tbxPrintFilePath);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(4, 530);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1916, 86);
            this.panel1.TabIndex = 3;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.lblCustomerQuote);
            this.panel2.Controls.Add(this.lnkSaveQuotePrint);
            this.panel2.Controls.Add(this.lblQuotePrint);
            this.panel2.Controls.Add(this.lnkSaveCustomerQuote);
            this.panel2.Controls.Add(this.label4);
            this.panel2.Controls.Add(this.lnkGetQuotePrint);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Controls.Add(this.lnkGetCustomerQuote);
            this.panel2.Controls.Add(this.labelControl3);
            this.panel2.Controls.Add(this.lnkDeleteQuotePrint);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.lnkDeleteCustomerQuote);
            this.panel2.Location = new System.Drawing.Point(8, 4);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(944, 78);
            this.panel2.TabIndex = 26;
            // 
            // lblCustomerQuote
            // 
            this.lblCustomerQuote.AutoSize = true;
            this.lblCustomerQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCustomerQuote.Location = new System.Drawing.Point(502, 42);
            this.lblCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCustomerQuote.Name = "lblCustomerQuote";
            this.lblCustomerQuote.Size = new System.Drawing.Size(127, 20);
            this.lblCustomerQuote.TabIndex = 25;
            this.lblCustomerQuote.Text = "CustomerQuote";
            // 
            // lnkSaveQuotePrint
            // 
            this.lnkSaveQuotePrint.AutoSize = true;
            this.lnkSaveQuotePrint.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkSaveQuotePrint.Location = new System.Drawing.Point(329, 14);
            this.lnkSaveQuotePrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkSaveQuotePrint.Name = "lnkSaveQuotePrint";
            this.lnkSaveQuotePrint.Size = new System.Drawing.Size(41, 18);
            this.lnkSaveQuotePrint.TabIndex = 14;
            this.lnkSaveQuotePrint.TabStop = true;
            this.lnkSaveQuotePrint.Text = "Save";
            this.lnkSaveQuotePrint.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkSaveQuotePrint_LinkClicked);
            // 
            // lblQuotePrint
            // 
            this.lblQuotePrint.AutoSize = true;
            this.lblQuotePrint.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblQuotePrint.Location = new System.Drawing.Point(502, 16);
            this.lblQuotePrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblQuotePrint.Name = "lblQuotePrint";
            this.lblQuotePrint.Size = new System.Drawing.Size(89, 20);
            this.lblQuotePrint.TabIndex = 24;
            this.lblQuotePrint.Text = "QuotePrint";
            // 
            // lnkSaveCustomerQuote
            // 
            this.lnkSaveCustomerQuote.AutoSize = true;
            this.lnkSaveCustomerQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkSaveCustomerQuote.Location = new System.Drawing.Point(329, 42);
            this.lnkSaveCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkSaveCustomerQuote.Name = "lnkSaveCustomerQuote";
            this.lnkSaveCustomerQuote.Size = new System.Drawing.Size(41, 18);
            this.lnkSaveCustomerQuote.TabIndex = 15;
            this.lnkSaveCustomerQuote.TabStop = true;
            this.lnkSaveCustomerQuote.Text = "Save";
            this.lnkSaveCustomerQuote.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkSaveCustomerQuote_LinkClicked);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.Gray;
            this.label4.Location = new System.Drawing.Point(12, 37);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(127, 25);
            this.label4.TabIndex = 23;
            this.label4.Text = "Management";
            // 
            // lnkGetQuotePrint
            // 
            this.lnkGetQuotePrint.AutoSize = true;
            this.lnkGetQuotePrint.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkGetQuotePrint.Location = new System.Drawing.Point(451, 15);
            this.lnkGetQuotePrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkGetQuotePrint.Name = "lnkGetQuotePrint";
            this.lnkGetQuotePrint.Size = new System.Drawing.Size(32, 18);
            this.lnkGetQuotePrint.TabIndex = 16;
            this.lnkGetQuotePrint.TabStop = true;
            this.lnkGetQuotePrint.Text = "Get";
            this.lnkGetQuotePrint.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkGetQuotePrint_LinkClicked);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.Gray;
            this.label3.Location = new System.Drawing.Point(12, 14);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(87, 25);
            this.label3.TabIndex = 22;
            this.label3.Text = "PDF File";
            // 
            // lnkGetCustomerQuote
            // 
            this.lnkGetCustomerQuote.AutoSize = true;
            this.lnkGetCustomerQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkGetCustomerQuote.Location = new System.Drawing.Point(451, 42);
            this.lnkGetCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkGetCustomerQuote.Name = "lnkGetCustomerQuote";
            this.lnkGetCustomerQuote.Size = new System.Drawing.Size(32, 18);
            this.lnkGetCustomerQuote.TabIndex = 17;
            this.lnkGetCustomerQuote.TabStop = true;
            this.lnkGetCustomerQuote.Text = "Get";
            this.lnkGetCustomerQuote.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkGetCustomerQuote_LinkClicked);
            // 
            // labelControl3
            // 
            this.labelControl3.Appearance.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelControl3.Appearance.Options.UseFont = true;
            this.labelControl3.Location = new System.Drawing.Point(185, 43);
            this.labelControl3.Margin = new System.Windows.Forms.Padding(4);
            this.labelControl3.Name = "labelControl3";
            this.labelControl3.Size = new System.Drawing.Size(113, 18);
            this.labelControl3.TabIndex = 21;
            this.labelControl3.Text = "Customer Quote:";
            // 
            // lnkDeleteQuotePrint
            // 
            this.lnkDeleteQuotePrint.AutoSize = true;
            this.lnkDeleteQuotePrint.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkDeleteQuotePrint.Location = new System.Drawing.Point(384, 14);
            this.lnkDeleteQuotePrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkDeleteQuotePrint.Name = "lnkDeleteQuotePrint";
            this.lnkDeleteQuotePrint.Size = new System.Drawing.Size(50, 18);
            this.lnkDeleteQuotePrint.TabIndex = 18;
            this.lnkDeleteQuotePrint.TabStop = true;
            this.lnkDeleteQuotePrint.Text = "Delete";
            this.lnkDeleteQuotePrint.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkDeleteQuotePrint_LinkClicked);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(182, 15);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(87, 18);
            this.label2.TabIndex = 20;
            this.label2.Text = "Quote Print:";
            // 
            // lnkDeleteCustomerQuote
            // 
            this.lnkDeleteCustomerQuote.AutoSize = true;
            this.lnkDeleteCustomerQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lnkDeleteCustomerQuote.Location = new System.Drawing.Point(384, 42);
            this.lnkDeleteCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lnkDeleteCustomerQuote.Name = "lnkDeleteCustomerQuote";
            this.lnkDeleteCustomerQuote.Size = new System.Drawing.Size(50, 18);
            this.lnkDeleteCustomerQuote.TabIndex = 19;
            this.lnkDeleteCustomerQuote.TabStop = true;
            this.lnkDeleteCustomerQuote.Text = "Delete";
            this.lnkDeleteCustomerQuote.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkDeleteCustomerQuote_LinkClicked);
            // 
            // panelPrint
            // 
            this.panelPrint.Controls.Add(this.tbxPrintNo);
            this.panelPrint.Controls.Add(this.labelControl2);
            this.panelPrint.Controls.Add(this.dateEditPrint);
            this.panelPrint.Location = new System.Drawing.Point(1495, 4);
            this.panelPrint.Margin = new System.Windows.Forms.Padding(4);
            this.panelPrint.Name = "panelPrint";
            this.panelPrint.Size = new System.Drawing.Size(292, 43);
            this.panelPrint.TabIndex = 11;
            this.panelPrint.Visible = false;
            // 
            // tbxPrintNo
            // 
            this.tbxPrintNo.Location = new System.Drawing.Point(65, 4);
            this.tbxPrintNo.Margin = new System.Windows.Forms.Padding(4);
            this.tbxPrintNo.Name = "tbxPrintNo";
            this.tbxPrintNo.Size = new System.Drawing.Size(76, 22);
            this.tbxPrintNo.TabIndex = 11;
            // 
            // labelControl2
            // 
            this.labelControl2.Location = new System.Drawing.Point(5, 6);
            this.labelControl2.Margin = new System.Windows.Forms.Padding(4);
            this.labelControl2.Name = "labelControl2";
            this.labelControl2.Size = new System.Drawing.Size(50, 16);
            this.labelControl2.TabIndex = 10;
            this.labelControl2.Text = "Print No:";
            // 
            // dateEditPrint
            // 
            this.dateEditPrint.EditValue = null;
            this.dateEditPrint.Location = new System.Drawing.Point(151, 4);
            this.dateEditPrint.Margin = new System.Windows.Forms.Padding(4);
            this.dateEditPrint.Name = "dateEditPrint";
            this.dateEditPrint.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.dateEditPrint.Properties.CalendarTimeProperties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton()});
            this.dateEditPrint.Size = new System.Drawing.Size(133, 22);
            this.dateEditPrint.TabIndex = 9;
            // 
            // linkRemoveCustomerQuote
            // 
            this.linkRemoveCustomerQuote.AutoSize = true;
            this.linkRemoveCustomerQuote.Location = new System.Drawing.Point(1392, 37);
            this.linkRemoveCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkRemoveCustomerQuote.Name = "linkRemoveCustomerQuote";
            this.linkRemoveCustomerQuote.Size = new System.Drawing.Size(103, 17);
            this.linkRemoveCustomerQuote.TabIndex = 7;
            this.linkRemoveCustomerQuote.TabStop = true;
            this.linkRemoveCustomerQuote.Text = "Remove Quote";
            this.linkRemoveCustomerQuote.Visible = false;
            this.linkRemoveCustomerQuote.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkRemoveCustomerQuote_LinkClicked);
            // 
            // linkAddViewCustomerQuote
            // 
            this.linkAddViewCustomerQuote.AutoSize = true;
            this.linkAddViewCustomerQuote.Location = new System.Drawing.Point(1311, 37);
            this.linkAddViewCustomerQuote.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkAddViewCustomerQuote.Name = "linkAddViewCustomerQuote";
            this.linkAddViewCustomerQuote.Size = new System.Drawing.Size(76, 17);
            this.linkAddViewCustomerQuote.TabIndex = 6;
            this.linkAddViewCustomerQuote.TabStop = true;
            this.linkAddViewCustomerQuote.Text = "Add Quote";
            this.linkAddViewCustomerQuote.Visible = false;
            this.linkAddViewCustomerQuote.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkAddViewCustomerQuote_LinkClicked);
            // 
            // tbxCustQuoteFilePath
            // 
            this.tbxCustQuoteFilePath.Location = new System.Drawing.Point(100, 33);
            this.tbxCustQuoteFilePath.Margin = new System.Windows.Forms.Padding(4);
            this.tbxCustQuoteFilePath.Name = "tbxCustQuoteFilePath";
            this.tbxCustQuoteFilePath.ReadOnly = true;
            this.tbxCustQuoteFilePath.Size = new System.Drawing.Size(1203, 22);
            this.tbxCustQuoteFilePath.TabIndex = 5;
            this.tbxCustQuoteFilePath.Visible = false;
            // 
            // labelControl1
            // 
            this.labelControl1.Location = new System.Drawing.Point(15, 37);
            this.labelControl1.Margin = new System.Windows.Forms.Padding(4);
            this.labelControl1.Name = "labelControl1";
            this.labelControl1.Size = new System.Drawing.Size(68, 16);
            this.labelControl1.TabIndex = 4;
            this.labelControl1.Text = "Cust Quote:";
            this.labelControl1.Visible = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(11, 9);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(84, 17);
            this.label1.TabIndex = 3;
            this.label1.Text = "Quote Print:";
            this.label1.Visible = false;
            // 
            // linkRemovePrint
            // 
            this.linkRemovePrint.AutoSize = true;
            this.linkRemovePrint.Location = new System.Drawing.Point(1392, 9);
            this.linkRemovePrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkRemovePrint.Name = "linkRemovePrint";
            this.linkRemovePrint.Size = new System.Drawing.Size(93, 17);
            this.linkRemovePrint.TabIndex = 2;
            this.linkRemovePrint.TabStop = true;
            this.linkRemovePrint.Text = "Remove Print";
            this.linkRemovePrint.Visible = false;
            this.linkRemovePrint.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkRemovePrint_LinkClicked);
            // 
            // linkAddViewPrint
            // 
            this.linkAddViewPrint.AutoSize = true;
            this.linkAddViewPrint.Location = new System.Drawing.Point(1311, 9);
            this.linkAddViewPrint.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkAddViewPrint.Name = "linkAddViewPrint";
            this.linkAddViewPrint.Size = new System.Drawing.Size(66, 17);
            this.linkAddViewPrint.TabIndex = 1;
            this.linkAddViewPrint.TabStop = true;
            this.linkAddViewPrint.Text = "Add Print";
            this.linkAddViewPrint.Visible = false;
            this.linkAddViewPrint.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkAddViewPrint_LinkClicked);
            // 
            // tbxPrintFilePath
            // 
            this.tbxPrintFilePath.Location = new System.Drawing.Point(100, 4);
            this.tbxPrintFilePath.Margin = new System.Windows.Forms.Padding(4);
            this.tbxPrintFilePath.Name = "tbxPrintFilePath";
            this.tbxPrintFilePath.ReadOnly = true;
            this.tbxPrintFilePath.Size = new System.Drawing.Size(1203, 22);
            this.tbxPrintFilePath.TabIndex = 0;
            this.tbxPrintFilePath.Visible = false;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 440F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.tableLayoutPanel4, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.btnCSM, 1, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(4, 624);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(4);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(1916, 162);
            this.tableLayoutPanel2.TabIndex = 4;
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 2;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 65F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Controls.Add(this.gridControl3, 1, 0);
            this.tableLayoutPanel4.Controls.Add(this.label5, 0, 0);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 1;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(434, 136);
            this.tableLayoutPanel4.TabIndex = 7;
            // 
            // gridControl3
            // 
            this.gridControl3.EmbeddedNavigator.Margin = new System.Windows.Forms.Padding(4);
            this.gridControl3.Location = new System.Drawing.Point(69, 4);
            this.gridControl3.MainView = this.gridView4;
            this.gridControl3.Margin = new System.Windows.Forms.Padding(4);
            this.gridControl3.Name = "gridControl3";
            this.gridControl3.Size = new System.Drawing.Size(361, 128);
            this.gridControl3.TabIndex = 13;
            this.gridControl3.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gridView4});
            // 
            // gridView4
            // 
            this.gridView4.GridControl = this.gridControl3;
            this.gridView4.Name = "gridView4";
            this.gridView4.OptionsCustomization.AllowGroup = false;
            this.gridView4.OptionsView.ShowGroupPanel = false;
            this.gridView4.CustomColumnDisplayText += new DevExpress.XtraGrid.Views.Base.CustomColumnDisplayTextEventHandler(this.gridView4_CustomColumnDisplayText);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(3, 3);
            this.label5.Margin = new System.Windows.Forms.Padding(3, 3, 3, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(54, 20);
            this.label5.TabIndex = 14;
            this.label5.Text = "LTAs:";
            // 
            // btnCSM
            // 
            this.btnCSM.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCSM.Location = new System.Drawing.Point(475, 4);
            this.btnCSM.Margin = new System.Windows.Forms.Padding(35, 4, 4, 4);
            this.btnCSM.Name = "btnCSM";
            this.btnCSM.Size = new System.Drawing.Size(201, 34);
            this.btnCSM.TabIndex = 4;
            this.btnCSM.Text = "CSM";
            this.btnCSM.UseVisualStyleBackColor = true;
            this.btnCSM.Click += new System.EventHandler(this.btnCSM_Click);
            // 
            // colMinimumOrderQuantity
            // 
            this.colMinimumOrderQuantity.Caption = "MinimumOrderQuantity";
            this.colMinimumOrderQuantity.FieldName = "MinimumOrderQuantity";
            this.colMinimumOrderQuantity.LayoutViewField = this.layoutViewField_layoutViewColumn1_45;
            this.colMinimumOrderQuantity.Name = "colMinimumOrderQuantity";
            // 
            // colAwardedDate
            // 
            this.colAwardedDate.Caption = "AwardedDate";
            this.colAwardedDate.FieldName = "AwardedDate";
            this.colAwardedDate.LayoutViewField = this.layoutViewField_layoutViewColumn1_46;
            this.colAwardedDate.Name = "colAwardedDate";
            // 
            // layoutViewCard1
            // 
            this.layoutViewCard1.CustomizationFormText = "TemplateCard";
            this.layoutViewCard1.HeaderButtonsLocation = DevExpress.Utils.GroupElementLocation.AfterText;
            this.layoutViewCard1.Items.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[] {
            this.layoutViewField_layoutViewColumn1,
            this.layoutViewField_layoutViewColumn1_8,
            this.item1,
            this.layoutViewField_layoutViewColumn1_21,
            this.layoutViewField_layoutViewColumn1_3,
            this.layoutViewField_layoutViewColumn1_1,
            this.layoutViewField_layoutViewColumn1_22,
            this.layoutViewField_layoutViewColumn1_23,
            this.layoutViewField_layoutViewColumn1_24,
            this.layoutViewField_layoutViewColumn1_25,
            this.layoutViewField_layoutViewColumn1_2,
            this.layoutViewField_layoutViewColumn1_4,
            this.layoutViewField_layoutViewColumn1_5,
            this.layoutViewField_layoutViewColumn1_13,
            this.layoutViewField_layoutViewColumn1_6,
            this.layoutViewField_layoutViewColumn1_18,
            this.layoutViewField_layoutViewColumn1_20,
            this.layoutViewField_layoutViewColumn1_10,
            this.layoutViewField_layoutViewColumn1_11,
            this.layoutViewField_layoutViewColumn1_9,
            this.layoutViewField_layoutViewColumn1_26,
            this.item2,
            this.item3,
            this.item4,
            this.layoutViewField_layoutViewColumn1_30,
            this.layoutViewField_layoutViewColumn1_31,
            this.layoutViewField_layoutViewColumn1_32,
            this.layoutViewField_layoutViewColumn1_34,
            this.layoutViewField_layoutViewColumn1_12,
            this.layoutViewField_layoutViewColumn1_14,
            this.layoutViewField_layoutViewColumn1_27,
            this.layoutViewField_layoutViewColumn1_28,
            this.layoutViewField_layoutViewColumn1_19,
            this.layoutViewField_layoutViewColumn1_17,
            this.layoutViewField_layoutViewColumn1_29,
            this.layoutViewField_layoutViewColumn1_35,
            this.layoutViewField_layoutViewColumn1_36,
            this.layoutViewField_layoutViewColumn1_7,
            this.layoutViewField_layoutViewColumn1_37,
            this.layoutViewField_layoutViewColumn1_15,
            this.layoutViewField_layoutViewColumn1_38,
            this.layoutViewField_layoutViewColumn1_41,
            this.layoutViewField_layoutViewColumn1_42,
            this.layoutViewField_layoutViewColumn1_43,
            this.layoutViewField_layoutViewColumn1_44,
            this.layoutViewField_layoutViewColumn1_16,
            this.layoutViewField_layoutViewColumn1_40,
            this.layoutViewField_layoutViewColumn1_39,
            this.layoutViewField_layoutViewColumn1_45,
            this.layoutViewField_layoutViewColumn1_46});
            this.layoutViewCard1.Name = "layoutViewCard1";
            this.layoutViewCard1.OptionsItemText.TextToControlDistance = 5;
            this.layoutViewCard1.Text = "TemplateCard";
            // 
            // layoutViewField_layoutViewColumn1
            // 
            this.layoutViewField_layoutViewColumn1.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1.Location = new System.Drawing.Point(0, 0);
            this.layoutViewField_layoutViewColumn1.Name = "layoutViewField_layoutViewColumn1";
            this.layoutViewField_layoutViewColumn1.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_8
            // 
            this.layoutViewField_layoutViewColumn1_8.EditorPreferredWidth = 1357;
            this.layoutViewField_layoutViewColumn1_8.Location = new System.Drawing.Point(0, 367);
            this.layoutViewField_layoutViewColumn1_8.Name = "layoutViewField_layoutViewColumn1_8";
            this.layoutViewField_layoutViewColumn1_8.Size = new System.Drawing.Size(1363, 49);
            this.layoutViewField_layoutViewColumn1_8.TextLocation = DevExpress.Utils.Locations.Top;
            this.layoutViewField_layoutViewColumn1_8.TextSize = new System.Drawing.Size(180, 16);
            // 
            // item1
            // 
            this.item1.AllowHotTrack = false;
            this.item1.CustomizationFormText = "item1";
            this.item1.Location = new System.Drawing.Point(0, 364);
            this.item1.Name = "item1";
            this.item1.Size = new System.Drawing.Size(1363, 3);
            // 
            // layoutViewField_layoutViewColumn1_21
            // 
            this.layoutViewField_layoutViewColumn1_21.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_21.Location = new System.Drawing.Point(316, 0);
            this.layoutViewField_layoutViewColumn1_21.Name = "layoutViewField_layoutViewColumn1_21";
            this.layoutViewField_layoutViewColumn1_21.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_21.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_3
            // 
            this.layoutViewField_layoutViewColumn1_3.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_3.Location = new System.Drawing.Point(316, 28);
            this.layoutViewField_layoutViewColumn1_3.Name = "layoutViewField_layoutViewColumn1_3";
            this.layoutViewField_layoutViewColumn1_3.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_3.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_1
            // 
            this.layoutViewField_layoutViewColumn1_1.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_1.Location = new System.Drawing.Point(0, 28);
            this.layoutViewField_layoutViewColumn1_1.Name = "layoutViewField_layoutViewColumn1_1";
            this.layoutViewField_layoutViewColumn1_1.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_1.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_22
            // 
            this.layoutViewField_layoutViewColumn1_22.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_22.Location = new System.Drawing.Point(631, 0);
            this.layoutViewField_layoutViewColumn1_22.Name = "layoutViewField_layoutViewColumn1_22";
            this.layoutViewField_layoutViewColumn1_22.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_22.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_23
            // 
            this.layoutViewField_layoutViewColumn1_23.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_23.Location = new System.Drawing.Point(631, 28);
            this.layoutViewField_layoutViewColumn1_23.Name = "layoutViewField_layoutViewColumn1_23";
            this.layoutViewField_layoutViewColumn1_23.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_23.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_24
            // 
            this.layoutViewField_layoutViewColumn1_24.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_24.Location = new System.Drawing.Point(631, 56);
            this.layoutViewField_layoutViewColumn1_24.Name = "layoutViewField_layoutViewColumn1_24";
            this.layoutViewField_layoutViewColumn1_24.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_24.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_25
            // 
            this.layoutViewField_layoutViewColumn1_25.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_25.Location = new System.Drawing.Point(986, 0);
            this.layoutViewField_layoutViewColumn1_25.Name = "layoutViewField_layoutViewColumn1_25";
            this.layoutViewField_layoutViewColumn1_25.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_25.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_2
            // 
            this.layoutViewField_layoutViewColumn1_2.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_2.Location = new System.Drawing.Point(0, 56);
            this.layoutViewField_layoutViewColumn1_2.Name = "layoutViewField_layoutViewColumn1_2";
            this.layoutViewField_layoutViewColumn1_2.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_2.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_4
            // 
            this.layoutViewField_layoutViewColumn1_4.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_4.Location = new System.Drawing.Point(316, 56);
            this.layoutViewField_layoutViewColumn1_4.Name = "layoutViewField_layoutViewColumn1_4";
            this.layoutViewField_layoutViewColumn1_4.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_4.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_5
            // 
            this.layoutViewField_layoutViewColumn1_5.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_5.Location = new System.Drawing.Point(0, 84);
            this.layoutViewField_layoutViewColumn1_5.Name = "layoutViewField_layoutViewColumn1_5";
            this.layoutViewField_layoutViewColumn1_5.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_5.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_13
            // 
            this.layoutViewField_layoutViewColumn1_13.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_13.Location = new System.Drawing.Point(316, 84);
            this.layoutViewField_layoutViewColumn1_13.Name = "layoutViewField_layoutViewColumn1_13";
            this.layoutViewField_layoutViewColumn1_13.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_13.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_6
            // 
            this.layoutViewField_layoutViewColumn1_6.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_6.Location = new System.Drawing.Point(0, 112);
            this.layoutViewField_layoutViewColumn1_6.Name = "layoutViewField_layoutViewColumn1_6";
            this.layoutViewField_layoutViewColumn1_6.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_6.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_18
            // 
            this.layoutViewField_layoutViewColumn1_18.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_18.Location = new System.Drawing.Point(316, 112);
            this.layoutViewField_layoutViewColumn1_18.Name = "layoutViewField_layoutViewColumn1_18";
            this.layoutViewField_layoutViewColumn1_18.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_18.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_20
            // 
            this.layoutViewField_layoutViewColumn1_20.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_20.Location = new System.Drawing.Point(0, 140);
            this.layoutViewField_layoutViewColumn1_20.Name = "layoutViewField_layoutViewColumn1_20";
            this.layoutViewField_layoutViewColumn1_20.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_20.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_10
            // 
            this.layoutViewField_layoutViewColumn1_10.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_10.Location = new System.Drawing.Point(316, 140);
            this.layoutViewField_layoutViewColumn1_10.Name = "layoutViewField_layoutViewColumn1_10";
            this.layoutViewField_layoutViewColumn1_10.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_10.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_11
            // 
            this.layoutViewField_layoutViewColumn1_11.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_11.Location = new System.Drawing.Point(316, 168);
            this.layoutViewField_layoutViewColumn1_11.Name = "layoutViewField_layoutViewColumn1_11";
            this.layoutViewField_layoutViewColumn1_11.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_11.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_9
            // 
            this.layoutViewField_layoutViewColumn1_9.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_9.Location = new System.Drawing.Point(316, 224);
            this.layoutViewField_layoutViewColumn1_9.Name = "layoutViewField_layoutViewColumn1_9";
            this.layoutViewField_layoutViewColumn1_9.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_9.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_26
            // 
            this.layoutViewField_layoutViewColumn1_26.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_26.Location = new System.Drawing.Point(0, 196);
            this.layoutViewField_layoutViewColumn1_26.Name = "layoutViewField_layoutViewColumn1_26";
            this.layoutViewField_layoutViewColumn1_26.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_26.TextSize = new System.Drawing.Size(180, 16);
            // 
            // item2
            // 
            this.item2.AllowHotTrack = false;
            this.item2.CustomizationFormText = "item2";
            this.item2.Location = new System.Drawing.Point(313, 0);
            this.item2.Name = "item2";
            this.item2.Size = new System.Drawing.Size(3, 280);
            // 
            // item3
            // 
            this.item3.AllowHotTrack = false;
            this.item3.CustomizationFormText = "item3";
            this.item3.Location = new System.Drawing.Point(628, 0);
            this.item3.Name = "item3";
            this.item3.Size = new System.Drawing.Size(3, 364);
            // 
            // item4
            // 
            this.item4.AllowHotTrack = false;
            this.item4.CustomizationFormText = "item4";
            this.item4.Location = new System.Drawing.Point(983, 0);
            this.item4.Name = "item4";
            this.item4.Size = new System.Drawing.Size(3, 364);
            // 
            // layoutViewField_layoutViewColumn1_30
            // 
            this.layoutViewField_layoutViewColumn1_30.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_30.Location = new System.Drawing.Point(0, 252);
            this.layoutViewField_layoutViewColumn1_30.Name = "layoutViewField_layoutViewColumn1_30";
            this.layoutViewField_layoutViewColumn1_30.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_30.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_31
            // 
            this.layoutViewField_layoutViewColumn1_31.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_31.Location = new System.Drawing.Point(316, 252);
            this.layoutViewField_layoutViewColumn1_31.Name = "layoutViewField_layoutViewColumn1_31";
            this.layoutViewField_layoutViewColumn1_31.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_31.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_32
            // 
            this.layoutViewField_layoutViewColumn1_32.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_32.Location = new System.Drawing.Point(0, 308);
            this.layoutViewField_layoutViewColumn1_32.Name = "layoutViewField_layoutViewColumn1_32";
            this.layoutViewField_layoutViewColumn1_32.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_32.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_34
            // 
            this.layoutViewField_layoutViewColumn1_34.EditorPreferredWidth = 124;
            this.layoutViewField_layoutViewColumn1_34.Location = new System.Drawing.Point(313, 280);
            this.layoutViewField_layoutViewColumn1_34.Name = "layoutViewField_layoutViewColumn1_34";
            this.layoutViewField_layoutViewColumn1_34.Size = new System.Drawing.Size(315, 28);
            this.layoutViewField_layoutViewColumn1_34.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_12
            // 
            this.layoutViewField_layoutViewColumn1_12.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_12.Location = new System.Drawing.Point(986, 56);
            this.layoutViewField_layoutViewColumn1_12.Name = "layoutViewField_layoutViewColumn1_12";
            this.layoutViewField_layoutViewColumn1_12.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_12.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_14
            // 
            this.layoutViewField_layoutViewColumn1_14.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_14.Location = new System.Drawing.Point(986, 84);
            this.layoutViewField_layoutViewColumn1_14.Name = "layoutViewField_layoutViewColumn1_14";
            this.layoutViewField_layoutViewColumn1_14.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_14.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_27
            // 
            this.layoutViewField_layoutViewColumn1_27.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_27.Location = new System.Drawing.Point(986, 112);
            this.layoutViewField_layoutViewColumn1_27.Name = "layoutViewField_layoutViewColumn1_27";
            this.layoutViewField_layoutViewColumn1_27.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_27.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_28
            // 
            this.layoutViewField_layoutViewColumn1_28.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_28.Location = new System.Drawing.Point(986, 140);
            this.layoutViewField_layoutViewColumn1_28.Name = "layoutViewField_layoutViewColumn1_28";
            this.layoutViewField_layoutViewColumn1_28.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_28.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_19
            // 
            this.layoutViewField_layoutViewColumn1_19.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_19.Location = new System.Drawing.Point(986, 168);
            this.layoutViewField_layoutViewColumn1_19.Name = "layoutViewField_layoutViewColumn1_19";
            this.layoutViewField_layoutViewColumn1_19.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_19.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_17
            // 
            this.layoutViewField_layoutViewColumn1_17.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_17.Location = new System.Drawing.Point(986, 196);
            this.layoutViewField_layoutViewColumn1_17.Name = "layoutViewField_layoutViewColumn1_17";
            this.layoutViewField_layoutViewColumn1_17.Size = new System.Drawing.Size(377, 168);
            this.layoutViewField_layoutViewColumn1_17.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_29
            // 
            this.layoutViewField_layoutViewColumn1_29.EditorPreferredWidth = 186;
            this.layoutViewField_layoutViewColumn1_29.Location = new System.Drawing.Point(986, 28);
            this.layoutViewField_layoutViewColumn1_29.Name = "layoutViewField_layoutViewColumn1_29";
            this.layoutViewField_layoutViewColumn1_29.Size = new System.Drawing.Size(377, 28);
            this.layoutViewField_layoutViewColumn1_29.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_35
            // 
            this.layoutViewField_layoutViewColumn1_35.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_35.Location = new System.Drawing.Point(0, 336);
            this.layoutViewField_layoutViewColumn1_35.Name = "layoutViewField_layoutViewColumn1_35";
            this.layoutViewField_layoutViewColumn1_35.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_35.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_36
            // 
            this.layoutViewField_layoutViewColumn1_36.EditorPreferredWidth = 124;
            this.layoutViewField_layoutViewColumn1_36.Location = new System.Drawing.Point(313, 336);
            this.layoutViewField_layoutViewColumn1_36.Name = "layoutViewField_layoutViewColumn1_36";
            this.layoutViewField_layoutViewColumn1_36.Size = new System.Drawing.Size(315, 28);
            this.layoutViewField_layoutViewColumn1_36.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_7
            // 
            this.layoutViewField_layoutViewColumn1_7.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_7.Location = new System.Drawing.Point(0, 168);
            this.layoutViewField_layoutViewColumn1_7.Name = "layoutViewField_layoutViewColumn1_7";
            this.layoutViewField_layoutViewColumn1_7.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_7.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_37
            // 
            this.layoutViewField_layoutViewColumn1_37.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_37.Location = new System.Drawing.Point(0, 224);
            this.layoutViewField_layoutViewColumn1_37.Name = "layoutViewField_layoutViewColumn1_37";
            this.layoutViewField_layoutViewColumn1_37.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_37.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_15
            // 
            this.layoutViewField_layoutViewColumn1_15.EditorPreferredWidth = 122;
            this.layoutViewField_layoutViewColumn1_15.Location = new System.Drawing.Point(0, 280);
            this.layoutViewField_layoutViewColumn1_15.Name = "layoutViewField_layoutViewColumn1_15";
            this.layoutViewField_layoutViewColumn1_15.Size = new System.Drawing.Size(313, 28);
            this.layoutViewField_layoutViewColumn1_15.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_38
            // 
            this.layoutViewField_layoutViewColumn1_38.EditorPreferredWidth = 124;
            this.layoutViewField_layoutViewColumn1_38.Location = new System.Drawing.Point(313, 308);
            this.layoutViewField_layoutViewColumn1_38.Name = "layoutViewField_layoutViewColumn1_38";
            this.layoutViewField_layoutViewColumn1_38.Size = new System.Drawing.Size(315, 28);
            this.layoutViewField_layoutViewColumn1_38.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_41
            // 
            this.layoutViewField_layoutViewColumn1_41.EditorPreferredWidth = 1172;
            this.layoutViewField_layoutViewColumn1_41.Location = new System.Drawing.Point(0, 416);
            this.layoutViewField_layoutViewColumn1_41.Name = "layoutViewField_layoutViewColumn1_41";
            this.layoutViewField_layoutViewColumn1_41.Size = new System.Drawing.Size(1363, 28);
            this.layoutViewField_layoutViewColumn1_41.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_42
            // 
            this.layoutViewField_layoutViewColumn1_42.EditorPreferredWidth = 1172;
            this.layoutViewField_layoutViewColumn1_42.Location = new System.Drawing.Point(0, 444);
            this.layoutViewField_layoutViewColumn1_42.Name = "layoutViewField_layoutViewColumn1_42";
            this.layoutViewField_layoutViewColumn1_42.Size = new System.Drawing.Size(1363, 56);
            this.layoutViewField_layoutViewColumn1_42.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_43
            // 
            this.layoutViewField_layoutViewColumn1_43.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_43.Location = new System.Drawing.Point(631, 168);
            this.layoutViewField_layoutViewColumn1_43.Name = "layoutViewField_layoutViewColumn1_43";
            this.layoutViewField_layoutViewColumn1_43.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_43.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_44
            // 
            this.layoutViewField_layoutViewColumn1_44.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_44.Location = new System.Drawing.Point(631, 196);
            this.layoutViewField_layoutViewColumn1_44.Name = "layoutViewField_layoutViewColumn1_44";
            this.layoutViewField_layoutViewColumn1_44.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_44.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_16
            // 
            this.layoutViewField_layoutViewColumn1_16.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_16.Location = new System.Drawing.Point(631, 112);
            this.layoutViewField_layoutViewColumn1_16.Name = "layoutViewField_layoutViewColumn1_16";
            this.layoutViewField_layoutViewColumn1_16.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_16.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_40
            // 
            this.layoutViewField_layoutViewColumn1_40.EditorPreferredWidth = 121;
            this.layoutViewField_layoutViewColumn1_40.Location = new System.Drawing.Point(316, 196);
            this.layoutViewField_layoutViewColumn1_40.Name = "layoutViewField_layoutViewColumn1_40";
            this.layoutViewField_layoutViewColumn1_40.Size = new System.Drawing.Size(312, 28);
            this.layoutViewField_layoutViewColumn1_40.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_39
            // 
            this.layoutViewField_layoutViewColumn1_39.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_39.Location = new System.Drawing.Point(631, 224);
            this.layoutViewField_layoutViewColumn1_39.Name = "layoutViewField_layoutViewColumn1_39";
            this.layoutViewField_layoutViewColumn1_39.Size = new System.Drawing.Size(352, 140);
            this.layoutViewField_layoutViewColumn1_39.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_45
            // 
            this.layoutViewField_layoutViewColumn1_45.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_45.Location = new System.Drawing.Point(631, 84);
            this.layoutViewField_layoutViewColumn1_45.Name = "layoutViewField_layoutViewColumn1_45";
            this.layoutViewField_layoutViewColumn1_45.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_45.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_46
            // 
            this.layoutViewField_layoutViewColumn1_46.EditorPreferredWidth = 161;
            this.layoutViewField_layoutViewColumn1_46.Location = new System.Drawing.Point(631, 140);
            this.layoutViewField_layoutViewColumn1_46.Name = "layoutViewField_layoutViewColumn1_46";
            this.layoutViewField_layoutViewColumn1_46.Size = new System.Drawing.Size(352, 28);
            this.layoutViewField_layoutViewColumn1_46.TextSize = new System.Drawing.Size(180, 16);
            // 
            // layoutViewField_layoutViewColumn1_33
            // 
            this.layoutViewField_layoutViewColumn1_33.EditorPreferredWidth = 13;
            this.layoutViewField_layoutViewColumn1_33.Location = new System.Drawing.Point(0, 0);
            this.layoutViewField_layoutViewColumn1_33.Name = "layoutViewField_layoutViewColumn1_33";
            this.layoutViewField_layoutViewColumn1_33.Size = new System.Drawing.Size(1363, 500);
            this.layoutViewField_layoutViewColumn1_33.TextSize = new System.Drawing.Size(187, 25);
            // 
            // formQuoteMaintenance
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1924, 1017);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "formQuoteMaintenance";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Quote Maintenance";
            this.tableLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridControl2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.customersItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.functionsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView10)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.applicationCodeItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView12)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.customerQuoteInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView9)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.programManagerInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemGridLookUpEdit1View)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.engineeringInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.salesInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.salesInitialsItemGridLookUpEditView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.quoteReviewInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView7)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.quotePricingInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView8)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.engineeringMaterialsInitialsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView6)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.requoteItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.productLinesItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView13)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.quoteReasonsItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.marketSegmentItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView14)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.marketSubsegmentItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView15)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.applicationNamesItemGridLookUpEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView11)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panelPrint.ResumeLayout(false);
            this.panelPrint.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dateEditPrint.Properties.CalendarTimeProperties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dateEditPrint.Properties)).EndInit();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel4.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridControl3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewCard1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_8)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.item1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_21)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_22)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_23)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_24)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_25)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_13)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_6)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_18)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_20)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_10)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_11)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_9)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_26)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.item2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.item3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.item4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_30)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_31)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_32)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_34)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_12)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_14)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_27)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_28)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_19)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_17)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_29)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_35)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_36)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_7)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_37)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_15)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_38)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_41)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_42)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_43)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_44)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_16)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_40)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_39)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_45)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_46)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutViewField_layoutViewColumn1_33)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.Button btnSave;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuoteNumber;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomer;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomerRFQNumber;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colRequestedDueDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEEIPromisedDueDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomerPartNumber;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEEIPartNumber;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colNotes;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEAU;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colApplicationName;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colFunctionName;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colOEM;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuotePrice;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colAwarded;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit customersItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView3;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit requoteItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView2;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomerQuoteDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colApplicationCode;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomerQuoteInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colModelYear;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colReceiptDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colProgramManagerInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEngineeringInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colSalesInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colStraightMaterialCost;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit salesInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView salesInitialsItemGridLookUpEditView;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuoteReviewInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuoteReviewDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuotePricingInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuotePricingDate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEngineeringMaterialsInitials;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEngineeringMaterialsDate;
        private System.Windows.Forms.Button btnPrint;
        private System.Windows.Forms.Button btnClose;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit programManagerInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView repositoryItemGridLookUpEdit1View;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit engineeringInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView5;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit engineeringMaterialsInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView6;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit quoteReviewInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView7;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit quotePricingInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView8;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit customerQuoteInitialsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView9;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colTooling;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit applicationNamesItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView11;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit functionsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView10;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colProgram;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit applicationCodeItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView12;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label1;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colPrototypePrice;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colParentQuoteID;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colNamePlate;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colSOP;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEOP;
        private DevExpress.XtraEditors.LabelControl labelControl1;
        public DevExpress.XtraGrid.GridControl gridControl2;
        public DevExpress.XtraGrid.Views.Layout.LayoutView layoutView1;
        public System.Windows.Forms.LinkLabel linkRemovePrint;
        public System.Windows.Forms.LinkLabel linkAddViewPrint;
        public System.Windows.Forms.TextBox tbxPrintFilePath;
        public System.Windows.Forms.LinkLabel linkRemoveCustomerQuote;
        public System.Windows.Forms.LinkLabel linkAddViewCustomerQuote;
        public System.Windows.Forms.TextBox tbxCustQuoteFilePath;
        public System.Windows.Forms.Label lblMessage;
        public System.Windows.Forms.CheckBox cbxRepeat;
        private System.Windows.Forms.Button btnCSM;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colRequote;
        private DevExpress.XtraEditors.LabelControl labelControl2;
        private DevExpress.XtraEditors.DateEdit dateEditPrint;
        private System.Windows.Forms.Panel panelPrint;
        private System.Windows.Forms.TextBox tbxPrintNo;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colStdHours;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colPackageNuber;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colQuoteReason;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit quoteReasonsItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView1;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colProductLine;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit productLinesItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView13;
        public System.Windows.Forms.LinkLabel lnkDeleteCustomerQuote;
        public System.Windows.Forms.LinkLabel lnkDeleteQuotePrint;
        public System.Windows.Forms.LinkLabel lnkGetCustomerQuote;
        public System.Windows.Forms.LinkLabel lnkGetQuotePrint;
        public System.Windows.Forms.LinkLabel lnkSaveCustomerQuote;
        public System.Windows.Forms.LinkLabel lnkSaveQuotePrint;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private DevExpress.XtraEditors.LabelControl labelControl3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lblCustomerQuote;
        private System.Windows.Forms.Label lblQuotePrint;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        public DevExpress.XtraGrid.GridControl gridControl3;
        public DevExpress.XtraGrid.Views.Grid.GridView gridView4;
        private System.Windows.Forms.Label label5;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colPrintFilePath;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colCustomerQuoteFilePath;
        private System.Windows.Forms.Panel panel2;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEmpireMarketSegment;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit marketSegmentItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView14;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colEmpireMarketSubsegment;
        private DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit marketSubsegmentItemGridLookUpEdit;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView15;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colMinimumOrderQuantity;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_1;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_2;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_3;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_4;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_5;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_6;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_8;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_9;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_10;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_11;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_13;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_15;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_16;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_17;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_18;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_19;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_20;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_21;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_22;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_23;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_24;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_26;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_12;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_14;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_27;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_28;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_25;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_29;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_30;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_31;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_32;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_33;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_34;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_35;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_36;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_7;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_37;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_38;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_40;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_39;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_41;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_42;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_43;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_44;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_45;
        private DevExpress.XtraGrid.Columns.LayoutViewColumn colAwardedDate;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewField layoutViewField_layoutViewColumn1_46;
        private DevExpress.XtraGrid.Views.Layout.LayoutViewCard layoutViewCard1;
        private DevExpress.XtraLayout.SimpleSeparator item1;
        private DevExpress.XtraLayout.SimpleSeparator item2;
        private DevExpress.XtraLayout.SimpleSeparator item3;
        private DevExpress.XtraLayout.SimpleSeparator item4;
    }
}