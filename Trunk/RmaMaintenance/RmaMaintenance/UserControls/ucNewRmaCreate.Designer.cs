namespace RmaMaintenance.UserControls
{
    partial class ucNewRmaCreate
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            this.tlpMain = new System.Windows.Forms.TableLayoutPanel();
            this.flowLayoutPanel2 = new System.Windows.Forms.FlowLayoutPanel();
            this.rbtnPasteSerials = new System.Windows.Forms.RadioButton();
            this.rbtnEnterPartQty = new System.Windows.Forms.RadioButton();
            this.mesBtnEnterRmaNumber = new Fx.WinForms.Flat.MESButton();
            this.tlpPasteSerials = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.mesBtnImportSerials = new Fx.WinForms.Flat.MESButton();
            this.mesBtnClearList = new Fx.WinForms.Flat.MESButton();
            this.lbxSerials = new System.Windows.Forms.ListBox();
            this.tlpEnterPartQty = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.cbxDestination = new System.Windows.Forms.ComboBox();
            this.dgvPartsQuantities = new System.Windows.Forms.DataGridView();
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.mesBtnClear = new Fx.WinForms.Flat.MESButton();
            this.mesBtnShowSerials = new Fx.WinForms.Flat.MESButton();
            this.tlpRmaProcess = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel10 = new System.Windows.Forms.TableLayoutPanel();
            this.label8 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.mesTbxWarehouseLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnTransferSerials = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.rbtnTransferHonduras = new System.Windows.Forms.RadioButton();
            this.rbtnTransferWarehouse = new System.Windows.Forms.RadioButton();
            this.tableLayoutPanel8 = new System.Windows.Forms.TableLayoutPanel();
            this.label7 = new System.Windows.Forms.Label();
            this.lblRmaShipper = new System.Windows.Forms.Label();
            this.mesTbxRmaShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxRtvShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.mesTbxHonLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnRtvShipper = new Fx.WinForms.Flat.MESButton();
            this.RTVPackingSlipButton = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel7 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel9 = new System.Windows.Forms.TableLayoutPanel();
            this.mesBtnCreateRma = new Fx.WinForms.Flat.MESButton();
            this.mesBtnCreateRmaOnly = new Fx.WinForms.Flat.MESButton();
            this.mesBtnCreateRtvOnly = new Fx.WinForms.Flat.MESButton();
            this.label6 = new System.Windows.Forms.Label();
            this.tableLayoutPanel5 = new System.Windows.Forms.TableLayoutPanel();
            this.dgvNewShippers = new System.Windows.Forms.DataGridView();
            this.tableLayoutPanel11 = new System.Windows.Forms.TableLayoutPanel();
            this.label4 = new System.Windows.Forms.Label();
            this.mesTbxRmaNote = new Fx.WinForms.Flat.MESTextEdit();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.linkLabel2 = new System.Windows.Forms.LinkLabel();
            this.linkLabel1 = new System.Windows.Forms.LinkLabel();
            this.tableLayoutPanel6 = new System.Windows.Forms.TableLayoutPanel();
            this.mesTxtRmaNumber = new Fx.WinForms.Flat.MESTextEdit();
            this.label9 = new System.Windows.Forms.Label();
            this.tlpMain.SuspendLayout();
            this.flowLayoutPanel2.SuspendLayout();
            this.tlpPasteSerials.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tlpEnterPartQty.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPartsQuantities)).BeginInit();
            this.tableLayoutPanel4.SuspendLayout();
            this.tlpRmaProcess.SuspendLayout();
            this.tableLayoutPanel10.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.tableLayoutPanel8.SuspendLayout();
            this.tableLayoutPanel7.SuspendLayout();
            this.tableLayoutPanel9.SuspendLayout();
            this.tableLayoutPanel5.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).BeginInit();
            this.tableLayoutPanel11.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel6.SuspendLayout();
            this.SuspendLayout();
            // 
            // tlpMain
            // 
            this.tlpMain.AutoSize = true;
            this.tlpMain.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpMain.ColumnCount = 3;
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpMain.Controls.Add(this.flowLayoutPanel2, 2, 0);
            this.tlpMain.Controls.Add(this.mesBtnEnterRmaNumber, 1, 0);
            this.tlpMain.Controls.Add(this.tlpPasteSerials, 0, 1);
            this.tlpMain.Controls.Add(this.tlpEnterPartQty, 1, 1);
            this.tlpMain.Controls.Add(this.tlpRmaProcess, 2, 1);
            this.tlpMain.Controls.Add(this.tableLayoutPanel6, 0, 0);
            this.tlpMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpMain.Location = new System.Drawing.Point(0, 0);
            this.tlpMain.Name = "tlpMain";
            this.tlpMain.RowCount = 2;
            this.tlpMain.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tlpMain.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpMain.Size = new System.Drawing.Size(1252, 651);
            this.tlpMain.TabIndex = 0;
            // 
            // flowLayoutPanel2
            // 
            this.flowLayoutPanel2.Controls.Add(this.rbtnPasteSerials);
            this.flowLayoutPanel2.Controls.Add(this.rbtnEnterPartQty);
            this.flowLayoutPanel2.Location = new System.Drawing.Point(577, 11);
            this.flowLayoutPanel2.Margin = new System.Windows.Forms.Padding(3, 11, 3, 3);
            this.flowLayoutPanel2.Name = "flowLayoutPanel2";
            this.flowLayoutPanel2.Size = new System.Drawing.Size(398, 30);
            this.flowLayoutPanel2.TabIndex = 17;
            // 
            // rbtnPasteSerials
            // 
            this.rbtnPasteSerials.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.rbtnPasteSerials.AutoSize = true;
            this.rbtnPasteSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnPasteSerials.ForeColor = System.Drawing.Color.White;
            this.rbtnPasteSerials.Location = new System.Drawing.Point(3, 3);
            this.rbtnPasteSerials.Margin = new System.Windows.Forms.Padding(3, 3, 13, 3);
            this.rbtnPasteSerials.Name = "rbtnPasteSerials";
            this.rbtnPasteSerials.Size = new System.Drawing.Size(169, 20);
            this.rbtnPasteSerials.TabIndex = 5;
            this.rbtnPasteSerials.Text = "Paste serials from Excel";
            this.rbtnPasteSerials.UseVisualStyleBackColor = true;
            // 
            // rbtnEnterPartQty
            // 
            this.rbtnEnterPartQty.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.rbtnEnterPartQty.AutoSize = true;
            this.rbtnEnterPartQty.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnEnterPartQty.ForeColor = System.Drawing.Color.White;
            this.rbtnEnterPartQty.Location = new System.Drawing.Point(188, 3);
            this.rbtnEnterPartQty.Name = "rbtnEnterPartQty";
            this.rbtnEnterPartQty.Size = new System.Drawing.Size(157, 20);
            this.rbtnEnterPartQty.TabIndex = 5;
            this.rbtnEnterPartQty.Text = "Enter parts / quantities";
            this.rbtnEnterPartQty.UseVisualStyleBackColor = true;
            // 
            // mesBtnEnterRmaNumber
            // 
            this.mesBtnEnterRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnEnterRmaNumber.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnEnterRmaNumber.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnEnterRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnEnterRmaNumber.Location = new System.Drawing.Point(290, 5);
            this.mesBtnEnterRmaNumber.Margin = new System.Windows.Forms.Padding(3, 5, 3, 3);
            this.mesBtnEnterRmaNumber.Name = "mesBtnEnterRmaNumber";
            this.mesBtnEnterRmaNumber.Size = new System.Drawing.Size(85, 35);
            this.mesBtnEnterRmaNumber.TabIndex = 16;
            this.mesBtnEnterRmaNumber.Text = "Enter";
            this.mesBtnEnterRmaNumber.UseVisualStyleBackColor = false;
            this.mesBtnEnterRmaNumber.Click += new System.EventHandler(this.mesBtnEnterRmaNumber_Click);
            // 
            // tlpPasteSerials
            // 
            this.tlpPasteSerials.AutoSize = true;
            this.tlpPasteSerials.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpPasteSerials.ColumnCount = 1;
            this.tlpPasteSerials.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 281F));
            this.tlpPasteSerials.Controls.Add(this.tableLayoutPanel1, 0, 1);
            this.tlpPasteSerials.Controls.Add(this.lbxSerials, 0, 0);
            this.tlpPasteSerials.Location = new System.Drawing.Point(3, 48);
            this.tlpPasteSerials.Name = "tlpPasteSerials";
            this.tlpPasteSerials.RowCount = 2;
            this.tlpPasteSerials.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 340F));
            this.tlpPasteSerials.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpPasteSerials.Size = new System.Drawing.Size(281, 385);
            this.tlpPasteSerials.TabIndex = 0;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.mesBtnImportSerials, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.mesBtnClearList, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 340);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(281, 45);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // mesBtnImportSerials
            // 
            this.mesBtnImportSerials.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnImportSerials.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnImportSerials.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnImportSerials.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnImportSerials.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnImportSerials.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnImportSerials.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnImportSerials.Location = new System.Drawing.Point(3, 3);
            this.mesBtnImportSerials.Name = "mesBtnImportSerials";
            this.mesBtnImportSerials.Size = new System.Drawing.Size(126, 35);
            this.mesBtnImportSerials.TabIndex = 0;
            this.mesBtnImportSerials.Text = "Import";
            this.mesBtnImportSerials.UseVisualStyleBackColor = false;
            this.mesBtnImportSerials.Click += new System.EventHandler(this.mesBtnImportSerials_Click);
            // 
            // mesBtnClearList
            // 
            this.mesBtnClearList.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnClearList.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnClearList.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnClearList.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnClearList.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnClearList.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnClearList.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnClearList.Location = new System.Drawing.Point(143, 3);
            this.mesBtnClearList.Name = "mesBtnClearList";
            this.mesBtnClearList.Size = new System.Drawing.Size(126, 35);
            this.mesBtnClearList.TabIndex = 1;
            this.mesBtnClearList.Text = "Clear";
            this.mesBtnClearList.UseVisualStyleBackColor = false;
            this.mesBtnClearList.Click += new System.EventHandler(this.mesBtnClearList_Click);
            // 
            // lbxSerials
            // 
            this.lbxSerials.BackColor = System.Drawing.Color.Black;
            this.lbxSerials.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbxSerials.ForeColor = System.Drawing.Color.White;
            this.lbxSerials.FormattingEnabled = true;
            this.lbxSerials.ItemHeight = 16;
            this.lbxSerials.Location = new System.Drawing.Point(3, 3);
            this.lbxSerials.Name = "lbxSerials";
            this.lbxSerials.Size = new System.Drawing.Size(266, 324);
            this.lbxSerials.TabIndex = 2;
            // 
            // tlpEnterPartQty
            // 
            this.tlpEnterPartQty.AutoSize = true;
            this.tlpEnterPartQty.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpEnterPartQty.ColumnCount = 1;
            this.tlpEnterPartQty.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpEnterPartQty.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tlpEnterPartQty.Controls.Add(this.dgvPartsQuantities, 0, 1);
            this.tlpEnterPartQty.Controls.Add(this.tableLayoutPanel4, 0, 2);
            this.tlpEnterPartQty.Location = new System.Drawing.Point(290, 48);
            this.tlpEnterPartQty.Name = "tlpEnterPartQty";
            this.tlpEnterPartQty.RowCount = 3;
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 300F));
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpEnterPartQty.Size = new System.Drawing.Size(281, 435);
            this.tlpEnterPartQty.TabIndex = 1;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 82F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.cbxDestination, 1, 0);
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(281, 40);
            this.tableLayoutPanel2.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(3, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(76, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Destination:";
            // 
            // cbxDestination
            // 
            this.cbxDestination.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.cbxDestination.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.cbxDestination.BackColor = System.Drawing.Color.Black;
            this.cbxDestination.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbxDestination.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxDestination.ForeColor = System.Drawing.Color.White;
            this.cbxDestination.FormattingEnabled = true;
            this.cbxDestination.Location = new System.Drawing.Point(85, 3);
            this.cbxDestination.Name = "cbxDestination";
            this.cbxDestination.Size = new System.Drawing.Size(185, 26);
            this.cbxDestination.TabIndex = 1;
            // 
            // dgvPartsQuantities
            // 
            this.dgvPartsQuantities.BackgroundColor = System.Drawing.Color.Black;
            this.dgvPartsQuantities.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPartsQuantities.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgvPartsQuantities.Location = new System.Drawing.Point(3, 43);
            this.dgvPartsQuantities.Name = "dgvPartsQuantities";
            this.dgvPartsQuantities.Size = new System.Drawing.Size(267, 284);
            this.dgvPartsQuantities.TabIndex = 1;
            this.dgvPartsQuantities.RowPrePaint += new System.Windows.Forms.DataGridViewRowPrePaintEventHandler(this.dgvPartsQuantities_RowPrePaint);
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 2;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 141F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel4.Controls.Add(this.mesBtnClear, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.mesBtnShowSerials, 1, 0);
            this.tableLayoutPanel4.Location = new System.Drawing.Point(0, 340);
            this.tableLayoutPanel4.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 1;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel4.Size = new System.Drawing.Size(281, 95);
            this.tableLayoutPanel4.TabIndex = 2;
            // 
            // mesBtnClear
            // 
            this.mesBtnClear.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnClear.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnClear.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnClear.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnClear.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnClear.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnClear.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnClear.Location = new System.Drawing.Point(3, 3);
            this.mesBtnClear.Name = "mesBtnClear";
            this.mesBtnClear.Size = new System.Drawing.Size(126, 35);
            this.mesBtnClear.TabIndex = 1;
            this.mesBtnClear.Text = "Clear";
            this.mesBtnClear.UseVisualStyleBackColor = false;
            this.mesBtnClear.Click += new System.EventHandler(this.mesBtnClear_Click);
            // 
            // mesBtnShowSerials
            // 
            this.mesBtnShowSerials.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnShowSerials.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnShowSerials.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnShowSerials.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnShowSerials.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnShowSerials.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnShowSerials.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnShowSerials.Location = new System.Drawing.Point(144, 3);
            this.mesBtnShowSerials.Name = "mesBtnShowSerials";
            this.mesBtnShowSerials.Size = new System.Drawing.Size(126, 36);
            this.mesBtnShowSerials.TabIndex = 2;
            this.mesBtnShowSerials.Text = "Get Serials";
            this.mesBtnShowSerials.UseVisualStyleBackColor = false;
            this.mesBtnShowSerials.Click += new System.EventHandler(this.mesBtnShowSerials_Click);
            // 
            // tlpRmaProcess
            // 
            this.tlpRmaProcess.AutoSize = true;
            this.tlpRmaProcess.ColumnCount = 1;
            this.tlpRmaProcess.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel10, 0, 2);
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel8, 0, 1);
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel7, 0, 0);
            this.tlpRmaProcess.Controls.Add(this.flowLayoutPanel1, 0, 3);
            this.tlpRmaProcess.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpRmaProcess.Location = new System.Drawing.Point(577, 48);
            this.tlpRmaProcess.Name = "tlpRmaProcess";
            this.tlpRmaProcess.RowCount = 4;
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 175F));
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpRmaProcess.Size = new System.Drawing.Size(672, 600);
            this.tlpRmaProcess.TabIndex = 2;
            // 
            // tableLayoutPanel10
            // 
            this.tableLayoutPanel10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(25)))), ((int)(((byte)(25)))), ((int)(((byte)(25)))));
            this.tableLayoutPanel10.ColumnCount = 3;
            this.tableLayoutPanel10.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 160F));
            this.tableLayoutPanel10.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 264F));
            this.tableLayoutPanel10.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel10.Controls.Add(this.label8, 0, 0);
            this.tableLayoutPanel10.Controls.Add(this.label5, 0, 1);
            this.tableLayoutPanel10.Controls.Add(this.mesTbxWarehouseLoc, 1, 1);
            this.tableLayoutPanel10.Controls.Add(this.mesBtnTransferSerials, 2, 2);
            this.tableLayoutPanel10.Controls.Add(this.tableLayoutPanel3, 1, 2);
            this.tableLayoutPanel10.Location = new System.Drawing.Point(3, 342);
            this.tableLayoutPanel10.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.tableLayoutPanel10.Name = "tableLayoutPanel10";
            this.tableLayoutPanel10.RowCount = 3;
            this.tableLayoutPanel10.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22F));
            this.tableLayoutPanel10.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36F));
            this.tableLayoutPanel10.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel10.Size = new System.Drawing.Size(666, 103);
            this.tableLayoutPanel10.TabIndex = 3;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label8.Location = new System.Drawing.Point(3, 2);
            this.label8.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(93, 13);
            this.label8.TabIndex = 16;
            this.label8.Text = "Inventory Transfer";
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.Color.White;
            this.label5.Location = new System.Drawing.Point(22, 22);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(135, 16);
            this.label5.TabIndex = 9;
            this.label5.Text = "Transfer To Location:";
            // 
            // mesTbxWarehouseLoc
            // 
            this.mesTbxWarehouseLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxWarehouseLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxWarehouseLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxWarehouseLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxWarehouseLoc.Location = new System.Drawing.Point(163, 25);
            this.mesTbxWarehouseLoc.Name = "mesTbxWarehouseLoc";
            this.mesTbxWarehouseLoc.Size = new System.Drawing.Size(128, 27);
            this.mesTbxWarehouseLoc.TabIndex = 10;
            // 
            // mesBtnTransferSerials
            // 
            this.mesBtnTransferSerials.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnTransferSerials.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnTransferSerials.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnTransferSerials.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnTransferSerials.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnTransferSerials.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnTransferSerials.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnTransferSerials.Location = new System.Drawing.Point(427, 61);
            this.mesBtnTransferSerials.Name = "mesBtnTransferSerials";
            this.mesBtnTransferSerials.Size = new System.Drawing.Size(157, 35);
            this.mesBtnTransferSerials.TabIndex = 11;
            this.mesBtnTransferSerials.Text = "Transfer Inv";
            this.mesBtnTransferSerials.UseVisualStyleBackColor = false;
            this.mesBtnTransferSerials.Click += new System.EventHandler(this.mesBtnTransferSerials_Click);
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 95F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.rbtnTransferHonduras, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.rbtnTransferWarehouse, 1, 0);
            this.tableLayoutPanel3.Location = new System.Drawing.Point(160, 58);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(264, 45);
            this.tableLayoutPanel3.TabIndex = 12;
            // 
            // rbtnTransferHonduras
            // 
            this.rbtnTransferHonduras.AutoSize = true;
            this.rbtnTransferHonduras.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnTransferHonduras.ForeColor = System.Drawing.Color.White;
            this.rbtnTransferHonduras.Location = new System.Drawing.Point(3, 3);
            this.rbtnTransferHonduras.Name = "rbtnTransferHonduras";
            this.rbtnTransferHonduras.Size = new System.Drawing.Size(85, 20);
            this.rbtnTransferHonduras.TabIndex = 0;
            this.rbtnTransferHonduras.TabStop = true;
            this.rbtnTransferHonduras.Text = "Honduras";
            this.rbtnTransferHonduras.UseVisualStyleBackColor = true;
            this.rbtnTransferHonduras.CheckedChanged += new System.EventHandler(this.rbtnTransferHonduras_CheckedChanged);
            // 
            // rbtnTransferWarehouse
            // 
            this.rbtnTransferWarehouse.AutoSize = true;
            this.rbtnTransferWarehouse.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnTransferWarehouse.ForeColor = System.Drawing.Color.White;
            this.rbtnTransferWarehouse.Location = new System.Drawing.Point(98, 3);
            this.rbtnTransferWarehouse.Name = "rbtnTransferWarehouse";
            this.rbtnTransferWarehouse.Size = new System.Drawing.Size(127, 20);
            this.rbtnTransferWarehouse.TabIndex = 1;
            this.rbtnTransferWarehouse.TabStop = true;
            this.rbtnTransferWarehouse.Text = "Other warehouse";
            this.rbtnTransferWarehouse.UseVisualStyleBackColor = true;
            this.rbtnTransferWarehouse.CheckedChanged += new System.EventHandler(this.rbtnTransferWarehouse_CheckedChanged);
            // 
            // tableLayoutPanel8
            // 
            this.tableLayoutPanel8.AutoSize = true;
            this.tableLayoutPanel8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(25)))), ((int)(((byte)(25)))), ((int)(((byte)(25)))));
            this.tableLayoutPanel8.ColumnCount = 3;
            this.tableLayoutPanel8.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 164F));
            this.tableLayoutPanel8.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 260F));
            this.tableLayoutPanel8.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel8.Controls.Add(this.label7, 0, 0);
            this.tableLayoutPanel8.Controls.Add(this.lblRmaShipper, 0, 1);
            this.tableLayoutPanel8.Controls.Add(this.mesTbxRmaShipper, 1, 1);
            this.tableLayoutPanel8.Controls.Add(this.label3, 0, 3);
            this.tableLayoutPanel8.Controls.Add(this.label2, 0, 2);
            this.tableLayoutPanel8.Controls.Add(this.mesTbxRtvShipper, 1, 2);
            this.tableLayoutPanel8.Controls.Add(this.mesTbxHonLoc, 1, 3);
            this.tableLayoutPanel8.Controls.Add(this.mesBtnRtvShipper, 2, 3);
            this.tableLayoutPanel8.Controls.Add(this.RTVPackingSlipButton, 2, 2);
            this.tableLayoutPanel8.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel8.Location = new System.Drawing.Point(3, 178);
            this.tableLayoutPanel8.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.tableLayoutPanel8.Name = "tableLayoutPanel8";
            this.tableLayoutPanel8.RowCount = 4;
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 44F));
            this.tableLayoutPanel8.Size = new System.Drawing.Size(666, 146);
            this.tableLayoutPanel8.TabIndex = 1;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label7.Location = new System.Drawing.Point(3, 2);
            this.label7.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(68, 13);
            this.label7.TabIndex = 15;
            this.label7.Text = "RTV Shipout";
            // 
            // lblRmaShipper
            // 
            this.lblRmaShipper.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblRmaShipper.AutoSize = true;
            this.lblRmaShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblRmaShipper.ForeColor = System.Drawing.Color.White;
            this.lblRmaShipper.Location = new System.Drawing.Point(70, 22);
            this.lblRmaShipper.Name = "lblRmaShipper";
            this.lblRmaShipper.Size = new System.Drawing.Size(91, 16);
            this.lblRmaShipper.TabIndex = 2;
            this.lblRmaShipper.Text = "RMA Shipper:";
            // 
            // mesTbxRmaShipper
            // 
            this.mesTbxRmaShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRmaShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaShipper.Location = new System.Drawing.Point(167, 25);
            this.mesTbxRmaShipper.Name = "mesTbxRmaShipper";
            this.mesTbxRmaShipper.Size = new System.Drawing.Size(124, 27);
            this.mesTbxRmaShipper.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(33, 102);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(128, 16);
            this.label3.TabIndex = 8;
            this.label3.Text = "Honduras RMA Loc:";
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(72, 62);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 16);
            this.label2.TabIndex = 14;
            this.label2.Text = "RTV Shipper:";
            // 
            // mesTbxRtvShipper
            // 
            this.mesTbxRtvShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRtvShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRtvShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRtvShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRtvShipper.Location = new System.Drawing.Point(167, 65);
            this.mesTbxRtvShipper.Name = "mesTbxRtvShipper";
            this.mesTbxRtvShipper.Size = new System.Drawing.Size(124, 27);
            this.mesTbxRtvShipper.TabIndex = 13;
            // 
            // mesTbxHonLoc
            // 
            this.mesTbxHonLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxHonLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxHonLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxHonLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxHonLoc.Location = new System.Drawing.Point(167, 105);
            this.mesTbxHonLoc.MaxLength = 20;
            this.mesTbxHonLoc.Name = "mesTbxHonLoc";
            this.mesTbxHonLoc.Size = new System.Drawing.Size(124, 27);
            this.mesTbxHonLoc.TabIndex = 9;
            // 
            // mesBtnRtvShipper
            // 
            this.mesBtnRtvShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnRtvShipper.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnRtvShipper.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnRtvShipper.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnRtvShipper.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnRtvShipper.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnRtvShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnRtvShipper.Location = new System.Drawing.Point(427, 105);
            this.mesBtnRtvShipper.Name = "mesBtnRtvShipper";
            this.mesBtnRtvShipper.Size = new System.Drawing.Size(150, 35);
            this.mesBtnRtvShipper.TabIndex = 1;
            this.mesBtnRtvShipper.Text = "Shipout RTV";
            this.mesBtnRtvShipper.UseVisualStyleBackColor = false;
            this.mesBtnRtvShipper.Click += new System.EventHandler(this.mesBtnRtvShipper_Click);
            // 
            // RTVPackingSlipButton
            // 
            this.RTVPackingSlipButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.RTVPackingSlipButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.RTVPackingSlipButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RTVPackingSlipButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.RTVPackingSlipButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.RTVPackingSlipButton.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.RTVPackingSlipButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.RTVPackingSlipButton.Location = new System.Drawing.Point(427, 65);
            this.RTVPackingSlipButton.Name = "RTVPackingSlipButton";
            this.RTVPackingSlipButton.Size = new System.Drawing.Size(150, 28);
            this.RTVPackingSlipButton.TabIndex = 7;
            this.RTVPackingSlipButton.Text = "Print Packing Slip";
            this.RTVPackingSlipButton.UseVisualStyleBackColor = false;
            this.RTVPackingSlipButton.Click += new System.EventHandler(this.RtvPackingSlipButtonClick);
            // 
            // tableLayoutPanel7
            // 
            this.tableLayoutPanel7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(25)))), ((int)(((byte)(25)))), ((int)(((byte)(25)))));
            this.tableLayoutPanel7.ColumnCount = 2;
            this.tableLayoutPanel7.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 160F));
            this.tableLayoutPanel7.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel7.Controls.Add(this.tableLayoutPanel9, 0, 0);
            this.tableLayoutPanel7.Controls.Add(this.tableLayoutPanel5, 1, 0);
            this.tableLayoutPanel7.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel7.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel7.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.tableLayoutPanel7.Name = "tableLayoutPanel7";
            this.tableLayoutPanel7.RowCount = 1;
            this.tableLayoutPanel7.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel7.Size = new System.Drawing.Size(666, 157);
            this.tableLayoutPanel7.TabIndex = 0;
            // 
            // tableLayoutPanel9
            // 
            this.tableLayoutPanel9.ColumnCount = 1;
            this.tableLayoutPanel9.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel9.Controls.Add(this.mesBtnCreateRma, 0, 1);
            this.tableLayoutPanel9.Controls.Add(this.mesBtnCreateRmaOnly, 0, 2);
            this.tableLayoutPanel9.Controls.Add(this.mesBtnCreateRtvOnly, 0, 3);
            this.tableLayoutPanel9.Controls.Add(this.label6, 0, 0);
            this.tableLayoutPanel9.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel9.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel9.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel9.Name = "tableLayoutPanel9";
            this.tableLayoutPanel9.RowCount = 4;
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 22F));
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel9.Size = new System.Drawing.Size(160, 157);
            this.tableLayoutPanel9.TabIndex = 3;
            // 
            // mesBtnCreateRma
            // 
            this.mesBtnCreateRma.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnCreateRma.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnCreateRma.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnCreateRma.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnCreateRma.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnCreateRma.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnCreateRma.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnCreateRma.Location = new System.Drawing.Point(3, 25);
            this.mesBtnCreateRma.Name = "mesBtnCreateRma";
            this.mesBtnCreateRma.Size = new System.Drawing.Size(154, 35);
            this.mesBtnCreateRma.TabIndex = 1;
            this.mesBtnCreateRma.Text = "RMA + RTV";
            this.mesBtnCreateRma.UseVisualStyleBackColor = false;
            this.mesBtnCreateRma.Click += new System.EventHandler(this.mesBtnCreateRma_Click);
            // 
            // mesBtnCreateRmaOnly
            // 
            this.mesBtnCreateRmaOnly.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnCreateRmaOnly.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnCreateRmaOnly.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnCreateRmaOnly.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnCreateRmaOnly.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnCreateRmaOnly.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnCreateRmaOnly.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnCreateRmaOnly.Location = new System.Drawing.Point(3, 70);
            this.mesBtnCreateRmaOnly.Name = "mesBtnCreateRmaOnly";
            this.mesBtnCreateRmaOnly.Size = new System.Drawing.Size(154, 35);
            this.mesBtnCreateRmaOnly.TabIndex = 3;
            this.mesBtnCreateRmaOnly.Text = "RMA Only";
            this.mesBtnCreateRmaOnly.UseVisualStyleBackColor = false;
            this.mesBtnCreateRmaOnly.Click += new System.EventHandler(this.mesBtnCreateRmaOnly_Click);
            // 
            // mesBtnCreateRtvOnly
            // 
            this.mesBtnCreateRtvOnly.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnCreateRtvOnly.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnCreateRtvOnly.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnCreateRtvOnly.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnCreateRtvOnly.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnCreateRtvOnly.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnCreateRtvOnly.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnCreateRtvOnly.Location = new System.Drawing.Point(3, 115);
            this.mesBtnCreateRtvOnly.Name = "mesBtnCreateRtvOnly";
            this.mesBtnCreateRtvOnly.Size = new System.Drawing.Size(154, 35);
            this.mesBtnCreateRtvOnly.TabIndex = 4;
            this.mesBtnCreateRtvOnly.Text = "RTV Only";
            this.mesBtnCreateRtvOnly.UseVisualStyleBackColor = false;
            this.mesBtnCreateRtvOnly.Click += new System.EventHandler(this.mesBtnCreateRtvOnly_Click);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.BackColor = System.Drawing.Color.Transparent;
            this.label6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label6.Location = new System.Drawing.Point(3, 2);
            this.label6.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(77, 13);
            this.label6.TabIndex = 5;
            this.label6.Text = "Create Options";
            // 
            // tableLayoutPanel5
            // 
            this.tableLayoutPanel5.ColumnCount = 2;
            this.tableLayoutPanel5.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 260F));
            this.tableLayoutPanel5.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel5.Controls.Add(this.dgvNewShippers, 0, 0);
            this.tableLayoutPanel5.Controls.Add(this.tableLayoutPanel11, 1, 0);
            this.tableLayoutPanel5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel5.Location = new System.Drawing.Point(163, 3);
            this.tableLayoutPanel5.Name = "tableLayoutPanel5";
            this.tableLayoutPanel5.RowCount = 1;
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.Size = new System.Drawing.Size(500, 151);
            this.tableLayoutPanel5.TabIndex = 4;
            // 
            // dgvNewShippers
            // 
            this.dgvNewShippers.BackgroundColor = System.Drawing.Color.Black;
            this.dgvNewShippers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.Black;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvNewShippers.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvNewShippers.Location = new System.Drawing.Point(3, 3);
            this.dgvNewShippers.MultiSelect = false;
            this.dgvNewShippers.Name = "dgvNewShippers";
            this.dgvNewShippers.ReadOnly = true;
            this.dgvNewShippers.RowHeadersVisible = false;
            this.dgvNewShippers.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvNewShippers.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvNewShippers.Size = new System.Drawing.Size(250, 144);
            this.dgvNewShippers.TabIndex = 4;
            this.dgvNewShippers.RowPrePaint += new System.Windows.Forms.DataGridViewRowPrePaintEventHandler(this.dgvNewShippers_RowPrePaint);
            this.dgvNewShippers.SelectionChanged += new System.EventHandler(this.dgvNewShippers_SelectionChanged);
            // 
            // tableLayoutPanel11
            // 
            this.tableLayoutPanel11.ColumnCount = 1;
            this.tableLayoutPanel11.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel11.Controls.Add(this.label4, 0, 0);
            this.tableLayoutPanel11.Controls.Add(this.mesTbxRmaNote, 0, 1);
            this.tableLayoutPanel11.Location = new System.Drawing.Point(260, 0);
            this.tableLayoutPanel11.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel11.Name = "tableLayoutPanel11";
            this.tableLayoutPanel11.RowCount = 2;
            this.tableLayoutPanel11.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel11.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel11.Size = new System.Drawing.Size(211, 153);
            this.tableLayoutPanel11.TabIndex = 5;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(3, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(39, 16);
            this.label4.TabIndex = 1;
            this.label4.Text = "Note:";
            // 
            // mesTbxRmaNote
            // 
            this.mesTbxRmaNote.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaNote.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaNote.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesTbxRmaNote.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaNote.Location = new System.Drawing.Point(3, 23);
            this.mesTbxRmaNote.MaxLength = 110;
            this.mesTbxRmaNote.Multiline = true;
            this.mesTbxRmaNote.Name = "mesTbxRmaNote";
            this.mesTbxRmaNote.Size = new System.Drawing.Size(205, 124);
            this.mesTbxRmaNote.TabIndex = 2;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.flowLayoutPanel1.Controls.Add(this.linkLabel2);
            this.flowLayoutPanel1.Controls.Add(this.linkLabel1);
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.RightToLeft;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(381, 460);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(0);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(291, 100);
            this.flowLayoutPanel1.TabIndex = 4;
            // 
            // linkLabel2
            // 
            this.linkLabel2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLabel2.AutoSize = true;
            this.linkLabel2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLabel2.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLabel2.Location = new System.Drawing.Point(167, 0);
            this.linkLabel2.Name = "linkLabel2";
            this.linkLabel2.Size = new System.Drawing.Size(121, 16);
            this.linkLabel2.TabIndex = 3;
            this.linkLabel2.TabStop = true;
            this.linkLabel2.Text = "RMA / RTV History";
            // 
            // linkLabel1
            // 
            this.linkLabel1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLabel1.AutoSize = true;
            this.linkLabel1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLabel1.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLabel1.Location = new System.Drawing.Point(112, 0);
            this.linkLabel1.Margin = new System.Windows.Forms.Padding(3, 0, 15, 0);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new System.Drawing.Size(37, 16);
            this.linkLabel1.TabIndex = 4;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "Help";
            // 
            // tableLayoutPanel6
            // 
            this.tableLayoutPanel6.ColumnCount = 2;
            this.tableLayoutPanel6.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel6.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel6.Controls.Add(this.mesTxtRmaNumber, 0, 0);
            this.tableLayoutPanel6.Controls.Add(this.label9, 0, 0);
            this.tableLayoutPanel6.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel6.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel6.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel6.Name = "tableLayoutPanel6";
            this.tableLayoutPanel6.RowCount = 1;
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel6.Size = new System.Drawing.Size(287, 45);
            this.tableLayoutPanel6.TabIndex = 3;
            // 
            // mesTxtRmaNumber
            // 
            this.mesTxtRmaNumber.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.mesTxtRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtRmaNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtRmaNumber.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtRmaNumber.Location = new System.Drawing.Point(146, 9);
            this.mesTxtRmaNumber.MaxLength = 50;
            this.mesTxtRmaNumber.Name = "mesTxtRmaNumber";
            this.mesTxtRmaNumber.Size = new System.Drawing.Size(131, 27);
            this.mesTxtRmaNumber.TabIndex = 3;
            // 
            // label9
            // 
            this.label9.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.ForeColor = System.Drawing.Color.White;
            this.label9.Location = new System.Drawing.Point(3, 14);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(127, 16);
            this.label9.TabIndex = 2;
            this.label9.Text = "Quality RMA/RTV #:";
            // 
            // ucNewRmaCreate
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.BackColor = System.Drawing.Color.Black;
            this.Controls.Add(this.tlpMain);
            this.Name = "ucNewRmaCreate";
            this.Size = new System.Drawing.Size(1252, 651);
            this.tlpMain.ResumeLayout(false);
            this.tlpMain.PerformLayout();
            this.flowLayoutPanel2.ResumeLayout(false);
            this.flowLayoutPanel2.PerformLayout();
            this.tlpPasteSerials.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tlpEnterPartQty.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPartsQuantities)).EndInit();
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tlpRmaProcess.ResumeLayout(false);
            this.tlpRmaProcess.PerformLayout();
            this.tableLayoutPanel10.ResumeLayout(false);
            this.tableLayoutPanel10.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.tableLayoutPanel8.ResumeLayout(false);
            this.tableLayoutPanel8.PerformLayout();
            this.tableLayoutPanel7.ResumeLayout(false);
            this.tableLayoutPanel9.ResumeLayout(false);
            this.tableLayoutPanel9.PerformLayout();
            this.tableLayoutPanel5.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).EndInit();
            this.tableLayoutPanel11.ResumeLayout(false);
            this.tableLayoutPanel11.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.tableLayoutPanel6.ResumeLayout(false);
            this.tableLayoutPanel6.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tlpMain;
        private System.Windows.Forms.TableLayoutPanel tlpPasteSerials;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private Fx.WinForms.Flat.MESButton mesBtnImportSerials;
        private Fx.WinForms.Flat.MESButton mesBtnClearList;
        private System.Windows.Forms.TableLayoutPanel tlpEnterPartQty;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cbxDestination;
        private System.Windows.Forms.DataGridView dgvPartsQuantities;
        private System.Windows.Forms.ListBox lbxSerials;
        private Fx.WinForms.Flat.MESButton mesBtnRtvShipper;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaShipper;
        private Fx.WinForms.Flat.MESButton mesBtnTransferSerials;
        private System.Windows.Forms.Label label5;
        private Fx.WinForms.Flat.MESTextEdit mesTbxWarehouseLoc;
        private System.Windows.Forms.TableLayoutPanel tlpRmaProcess;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel10;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel8;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel7;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.RadioButton rbtnTransferHonduras;
        private System.Windows.Forms.RadioButton rbtnTransferWarehouse;
        private Fx.WinForms.Flat.MESButton mesBtnClear;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private Fx.WinForms.Flat.MESButton mesBtnShowSerials;
        private Fx.WinForms.Flat.MESTextEdit mesTbxHonLoc;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.DataGridView dgvNewShippers;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel9;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRma;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel5;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel11;
        private System.Windows.Forms.Label label4;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaNote;
        private Fx.WinForms.Flat.MESButton RTVPackingSlipButton;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRtvShipper;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRmaOnly;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRtvOnly;
        private System.Windows.Forms.Label lblRmaShipper;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.LinkLabel linkLabel2;
        private System.Windows.Forms.LinkLabel linkLabel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel6;
        private System.Windows.Forms.Label label9;
        public Fx.WinForms.Flat.MESTextEdit mesTxtRmaNumber;
        private Fx.WinForms.Flat.MESButton mesBtnEnterRmaNumber;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel2;
        private System.Windows.Forms.RadioButton rbtnPasteSerials;
        private System.Windows.Forms.RadioButton rbtnEnterPartQty;
    }
}
