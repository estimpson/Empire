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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            this.tlpMain = new System.Windows.Forms.TableLayoutPanel();
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
            this.mesTbxWarehouseLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnTransferSerials = new Fx.WinForms.Flat.MESButton();
            this.label5 = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.rbtnTransferHonduras = new System.Windows.Forms.RadioButton();
            this.rbtnTransferWarehouse = new System.Windows.Forms.RadioButton();
            this.tableLayoutPanel8 = new System.Windows.Forms.TableLayoutPanel();
            this.mesTbxHonLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.lblRmaShipper = new System.Windows.Forms.Label();
            this.lblRtvShipper = new System.Windows.Forms.Label();
            this.mesTbxRmaShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxRtvShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnRtvShipper = new Fx.WinForms.Flat.MESButton();
            this.label3 = new System.Windows.Forms.Label();
            this.tableLayoutPanel7 = new System.Windows.Forms.TableLayoutPanel();
            this.dgvNewShippers = new System.Windows.Forms.DataGridView();
            this.tableLayoutPanel9 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel6 = new System.Windows.Forms.TableLayoutPanel();
            this.cbxSerialsOnHold = new System.Windows.Forms.CheckBox();
            this.cbxCreateRtv = new System.Windows.Forms.CheckBox();
            this.mesBtnCreateRma = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel5 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel11 = new System.Windows.Forms.TableLayoutPanel();
            this.label4 = new System.Windows.Forms.Label();
            this.mesTbxRmaNote = new Fx.WinForms.Flat.MESTextEdit();
            this.tlpMain.SuspendLayout();
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
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).BeginInit();
            this.tableLayoutPanel9.SuspendLayout();
            this.tableLayoutPanel6.SuspendLayout();
            this.tableLayoutPanel5.SuspendLayout();
            this.tableLayoutPanel11.SuspendLayout();
            this.SuspendLayout();
            // 
            // tlpMain
            // 
            this.tlpMain.AutoSize = true;
            this.tlpMain.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpMain.ColumnCount = 3;
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpMain.Controls.Add(this.tlpPasteSerials, 0, 0);
            this.tlpMain.Controls.Add(this.tlpEnterPartQty, 1, 0);
            this.tlpMain.Controls.Add(this.tlpRmaProcess, 2, 0);
            this.tlpMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpMain.Location = new System.Drawing.Point(0, 0);
            this.tlpMain.Name = "tlpMain";
            this.tlpMain.RowCount = 1;
            this.tlpMain.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpMain.Size = new System.Drawing.Size(1191, 412);
            this.tlpMain.TabIndex = 0;
            // 
            // tlpPasteSerials
            // 
            this.tlpPasteSerials.AutoSize = true;
            this.tlpPasteSerials.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpPasteSerials.ColumnCount = 1;
            this.tlpPasteSerials.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 220F));
            this.tlpPasteSerials.Controls.Add(this.tableLayoutPanel1, 0, 1);
            this.tlpPasteSerials.Controls.Add(this.lbxSerials, 0, 0);
            this.tlpPasteSerials.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpPasteSerials.Location = new System.Drawing.Point(3, 3);
            this.tlpPasteSerials.Name = "tlpPasteSerials";
            this.tlpPasteSerials.RowCount = 2;
            this.tlpPasteSerials.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpPasteSerials.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tlpPasteSerials.Size = new System.Drawing.Size(220, 406);
            this.tlpPasteSerials.TabIndex = 0;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 110F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.mesBtnImportSerials, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.mesBtnClearList, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 361);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(220, 45);
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
            this.mesBtnImportSerials.Size = new System.Drawing.Size(91, 35);
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
            this.mesBtnClearList.Location = new System.Drawing.Point(113, 3);
            this.mesBtnClearList.Name = "mesBtnClearList";
            this.mesBtnClearList.Size = new System.Drawing.Size(91, 35);
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
            this.lbxSerials.Size = new System.Drawing.Size(201, 340);
            this.lbxSerials.TabIndex = 2;
            // 
            // tlpEnterPartQty
            // 
            this.tlpEnterPartQty.AutoSize = true;
            this.tlpEnterPartQty.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpEnterPartQty.ColumnCount = 1;
            this.tlpEnterPartQty.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 310F));
            this.tlpEnterPartQty.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tlpEnterPartQty.Controls.Add(this.dgvPartsQuantities, 0, 1);
            this.tlpEnterPartQty.Controls.Add(this.tableLayoutPanel4, 0, 2);
            this.tlpEnterPartQty.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpEnterPartQty.Location = new System.Drawing.Point(229, 3);
            this.tlpEnterPartQty.Name = "tlpEnterPartQty";
            this.tlpEnterPartQty.RowCount = 3;
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 320F));
            this.tlpEnterPartQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpEnterPartQty.Size = new System.Drawing.Size(310, 406);
            this.tlpEnterPartQty.TabIndex = 1;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 82F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.cbxDestination, 1, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(310, 40);
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
            this.cbxDestination.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxDestination.ForeColor = System.Drawing.Color.White;
            this.cbxDestination.FormattingEnabled = true;
            this.cbxDestination.Location = new System.Drawing.Point(85, 3);
            this.cbxDestination.Name = "cbxDestination";
            this.cbxDestination.Size = new System.Drawing.Size(200, 27);
            this.cbxDestination.TabIndex = 1;
            // 
            // dgvPartsQuantities
            // 
            this.dgvPartsQuantities.BackgroundColor = System.Drawing.Color.Black;
            this.dgvPartsQuantities.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPartsQuantities.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgvPartsQuantities.Location = new System.Drawing.Point(3, 43);
            this.dgvPartsQuantities.Name = "dgvPartsQuantities";
            this.dgvPartsQuantities.Size = new System.Drawing.Size(292, 314);
            this.dgvPartsQuantities.TabIndex = 1;
            this.dgvPartsQuantities.RowPrePaint += new System.Windows.Forms.DataGridViewRowPrePaintEventHandler(this.dgvPartsQuantities_RowPrePaint);
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 2;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 147F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Controls.Add(this.mesBtnClear, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.mesBtnShowSerials, 1, 0);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(3, 363);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 1;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(304, 40);
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
            this.mesBtnClear.Size = new System.Drawing.Size(132, 34);
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
            this.mesBtnShowSerials.Location = new System.Drawing.Point(150, 3);
            this.mesBtnShowSerials.Name = "mesBtnShowSerials";
            this.mesBtnShowSerials.Size = new System.Drawing.Size(132, 34);
            this.mesBtnShowSerials.TabIndex = 2;
            this.mesBtnShowSerials.Text = "Get Serials";
            this.mesBtnShowSerials.UseVisualStyleBackColor = false;
            this.mesBtnShowSerials.Click += new System.EventHandler(this.mesBtnShowSerials_Click);
            // 
            // tlpRmaProcess
            // 
            this.tlpRmaProcess.ColumnCount = 1;
            this.tlpRmaProcess.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel10, 0, 2);
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel8, 0, 1);
            this.tlpRmaProcess.Controls.Add(this.tableLayoutPanel7, 0, 0);
            this.tlpRmaProcess.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpRmaProcess.Location = new System.Drawing.Point(545, 3);
            this.tlpRmaProcess.Name = "tlpRmaProcess";
            this.tlpRmaProcess.RowCount = 3;
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 125F));
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 185F));
            this.tlpRmaProcess.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpRmaProcess.Size = new System.Drawing.Size(643, 406);
            this.tlpRmaProcess.TabIndex = 2;
            // 
            // tableLayoutPanel10
            // 
            this.tableLayoutPanel10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.tableLayoutPanel10.ColumnCount = 2;
            this.tableLayoutPanel10.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 160F));
            this.tableLayoutPanel10.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel10.Controls.Add(this.mesTbxWarehouseLoc, 1, 1);
            this.tableLayoutPanel10.Controls.Add(this.mesBtnTransferSerials, 0, 0);
            this.tableLayoutPanel10.Controls.Add(this.label5, 0, 1);
            this.tableLayoutPanel10.Controls.Add(this.tableLayoutPanel3, 1, 0);
            this.tableLayoutPanel10.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel10.Location = new System.Drawing.Point(3, 313);
            this.tableLayoutPanel10.Name = "tableLayoutPanel10";
            this.tableLayoutPanel10.RowCount = 2;
            this.tableLayoutPanel10.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel10.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel10.Size = new System.Drawing.Size(637, 90);
            this.tableLayoutPanel10.TabIndex = 3;
            // 
            // mesTbxWarehouseLoc
            // 
            this.mesTbxWarehouseLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxWarehouseLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxWarehouseLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxWarehouseLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxWarehouseLoc.Location = new System.Drawing.Point(163, 48);
            this.mesTbxWarehouseLoc.Name = "mesTbxWarehouseLoc";
            this.mesTbxWarehouseLoc.Size = new System.Drawing.Size(113, 27);
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
            this.mesBtnTransferSerials.Location = new System.Drawing.Point(3, 3);
            this.mesBtnTransferSerials.Name = "mesBtnTransferSerials";
            this.mesBtnTransferSerials.Size = new System.Drawing.Size(132, 35);
            this.mesBtnTransferSerials.TabIndex = 11;
            this.mesBtnTransferSerials.Text = "Transfer Inv";
            this.mesBtnTransferSerials.UseVisualStyleBackColor = false;
            this.mesBtnTransferSerials.Click += new System.EventHandler(this.mesBtnTransferSerials_Click);
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.Color.White;
            this.label5.Location = new System.Drawing.Point(95, 45);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(62, 16);
            this.label5.TabIndex = 9;
            this.label5.Text = "Location:";
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 100F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.rbtnTransferHonduras, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.rbtnTransferWarehouse, 1, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(160, 0);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(477, 45);
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
            this.rbtnTransferWarehouse.Location = new System.Drawing.Point(103, 3);
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
            this.tableLayoutPanel8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.tableLayoutPanel8.ColumnCount = 2;
            this.tableLayoutPanel8.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 160F));
            this.tableLayoutPanel8.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel8.Controls.Add(this.mesTbxHonLoc, 1, 3);
            this.tableLayoutPanel8.Controls.Add(this.lblRmaShipper, 0, 1);
            this.tableLayoutPanel8.Controls.Add(this.lblRtvShipper, 0, 2);
            this.tableLayoutPanel8.Controls.Add(this.mesTbxRmaShipper, 1, 1);
            this.tableLayoutPanel8.Controls.Add(this.label2, 1, 0);
            this.tableLayoutPanel8.Controls.Add(this.mesTbxRtvShipper, 1, 2);
            this.tableLayoutPanel8.Controls.Add(this.mesBtnRtvShipper, 0, 0);
            this.tableLayoutPanel8.Controls.Add(this.label3, 0, 3);
            this.tableLayoutPanel8.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel8.Location = new System.Drawing.Point(3, 128);
            this.tableLayoutPanel8.Name = "tableLayoutPanel8";
            this.tableLayoutPanel8.RowCount = 5;
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 43F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 33F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 33F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 33F));
            this.tableLayoutPanel8.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel8.Size = new System.Drawing.Size(637, 179);
            this.tableLayoutPanel8.TabIndex = 1;
            // 
            // mesTbxHonLoc
            // 
            this.mesTbxHonLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxHonLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxHonLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxHonLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxHonLoc.Location = new System.Drawing.Point(163, 112);
            this.mesTbxHonLoc.MaxLength = 20;
            this.mesTbxHonLoc.Name = "mesTbxHonLoc";
            this.mesTbxHonLoc.Size = new System.Drawing.Size(113, 27);
            this.mesTbxHonLoc.TabIndex = 9;
            // 
            // lblRmaShipper
            // 
            this.lblRmaShipper.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblRmaShipper.AutoSize = true;
            this.lblRmaShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblRmaShipper.ForeColor = System.Drawing.Color.White;
            this.lblRmaShipper.Location = new System.Drawing.Point(66, 43);
            this.lblRmaShipper.Name = "lblRmaShipper";
            this.lblRmaShipper.Size = new System.Drawing.Size(91, 16);
            this.lblRmaShipper.TabIndex = 2;
            this.lblRmaShipper.Text = "RMA Shipper:";
            // 
            // lblRtvShipper
            // 
            this.lblRtvShipper.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblRtvShipper.AutoSize = true;
            this.lblRtvShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblRtvShipper.ForeColor = System.Drawing.Color.White;
            this.lblRtvShipper.Location = new System.Drawing.Point(68, 76);
            this.lblRtvShipper.Name = "lblRtvShipper";
            this.lblRtvShipper.Size = new System.Drawing.Size(89, 16);
            this.lblRtvShipper.TabIndex = 4;
            this.lblRtvShipper.Text = "RTV Shipper:";
            // 
            // mesTbxRmaShipper
            // 
            this.mesTbxRmaShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRmaShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaShipper.Location = new System.Drawing.Point(163, 46);
            this.mesTbxRmaShipper.Name = "mesTbxRmaShipper";
            this.mesTbxRmaShipper.Size = new System.Drawing.Size(113, 27);
            this.mesTbxRmaShipper.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label2.Location = new System.Drawing.Point(163, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(194, 18);
            this.label2.TabIndex = 6;
            this.label2.Text = "* Reminder: print packing list";
            // 
            // mesTbxRtvShipper
            // 
            this.mesTbxRtvShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRtvShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRtvShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRtvShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRtvShipper.Location = new System.Drawing.Point(163, 79);
            this.mesTbxRtvShipper.Name = "mesTbxRtvShipper";
            this.mesTbxRtvShipper.Size = new System.Drawing.Size(113, 27);
            this.mesTbxRtvShipper.TabIndex = 5;
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
            this.mesBtnRtvShipper.Location = new System.Drawing.Point(3, 3);
            this.mesBtnRtvShipper.Name = "mesBtnRtvShipper";
            this.mesBtnRtvShipper.Size = new System.Drawing.Size(132, 35);
            this.mesBtnRtvShipper.TabIndex = 1;
            this.mesBtnRtvShipper.Text = "Ship RTV";
            this.mesBtnRtvShipper.UseVisualStyleBackColor = false;
            this.mesBtnRtvShipper.Click += new System.EventHandler(this.mesBtnRtvShipper_Click);
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(39, 109);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(118, 16);
            this.label3.TabIndex = 8;
            this.label3.Text = "HN RMA Location:";
            // 
            // tableLayoutPanel7
            // 
            this.tableLayoutPanel7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.tableLayoutPanel7.ColumnCount = 2;
            this.tableLayoutPanel7.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 160F));
            this.tableLayoutPanel7.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel7.Controls.Add(this.tableLayoutPanel9, 0, 0);
            this.tableLayoutPanel7.Controls.Add(this.tableLayoutPanel5, 1, 0);
            this.tableLayoutPanel7.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel7.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel7.Name = "tableLayoutPanel7";
            this.tableLayoutPanel7.RowCount = 1;
            this.tableLayoutPanel7.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel7.Size = new System.Drawing.Size(637, 119);
            this.tableLayoutPanel7.TabIndex = 0;
            // 
            // dgvNewShippers
            // 
            this.dgvNewShippers.BackgroundColor = System.Drawing.Color.Black;
            this.dgvNewShippers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.Black;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvNewShippers.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvNewShippers.Location = new System.Drawing.Point(3, 3);
            this.dgvNewShippers.MultiSelect = false;
            this.dgvNewShippers.Name = "dgvNewShippers";
            this.dgvNewShippers.ReadOnly = true;
            this.dgvNewShippers.RowHeadersVisible = false;
            this.dgvNewShippers.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvNewShippers.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvNewShippers.Size = new System.Drawing.Size(250, 107);
            this.dgvNewShippers.TabIndex = 4;
            this.dgvNewShippers.RowPrePaint += new System.Windows.Forms.DataGridViewRowPrePaintEventHandler(this.dgvNewShippers_RowPrePaint);
            this.dgvNewShippers.SelectionChanged += new System.EventHandler(this.dgvNewShippers_SelectionChanged);
            // 
            // tableLayoutPanel9
            // 
            this.tableLayoutPanel9.ColumnCount = 1;
            this.tableLayoutPanel9.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel9.Controls.Add(this.tableLayoutPanel6, 0, 1);
            this.tableLayoutPanel9.Controls.Add(this.mesBtnCreateRma, 0, 0);
            this.tableLayoutPanel9.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel9.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel9.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel9.Name = "tableLayoutPanel9";
            this.tableLayoutPanel9.RowCount = 2;
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 45F));
            this.tableLayoutPanel9.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel9.Size = new System.Drawing.Size(160, 119);
            this.tableLayoutPanel9.TabIndex = 3;
            // 
            // tableLayoutPanel6
            // 
            this.tableLayoutPanel6.ColumnCount = 1;
            this.tableLayoutPanel6.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel6.Controls.Add(this.cbxSerialsOnHold, 0, 1);
            this.tableLayoutPanel6.Controls.Add(this.cbxCreateRtv, 0, 0);
            this.tableLayoutPanel6.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel6.Location = new System.Drawing.Point(0, 45);
            this.tableLayoutPanel6.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel6.Name = "tableLayoutPanel6";
            this.tableLayoutPanel6.RowCount = 2;
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 28F));
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel6.Size = new System.Drawing.Size(160, 74);
            this.tableLayoutPanel6.TabIndex = 2;
            // 
            // cbxSerialsOnHold
            // 
            this.cbxSerialsOnHold.AutoSize = true;
            this.cbxSerialsOnHold.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxSerialsOnHold.ForeColor = System.Drawing.Color.White;
            this.cbxSerialsOnHold.Location = new System.Drawing.Point(3, 31);
            this.cbxSerialsOnHold.Name = "cbxSerialsOnHold";
            this.cbxSerialsOnHold.Size = new System.Drawing.Size(152, 20);
            this.cbxSerialsOnHold.TabIndex = 1;
            this.cbxSerialsOnHold.Text = "Place serials on hold";
            this.cbxSerialsOnHold.UseVisualStyleBackColor = true;
            // 
            // cbxCreateRtv
            // 
            this.cbxCreateRtv.AutoSize = true;
            this.cbxCreateRtv.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxCreateRtv.ForeColor = System.Drawing.Color.White;
            this.cbxCreateRtv.Location = new System.Drawing.Point(3, 3);
            this.cbxCreateRtv.Name = "cbxCreateRtv";
            this.cbxCreateRtv.Size = new System.Drawing.Size(146, 20);
            this.cbxCreateRtv.TabIndex = 0;
            this.cbxCreateRtv.Text = "Create RTV shipper";
            this.cbxCreateRtv.UseVisualStyleBackColor = true;
            this.cbxCreateRtv.CheckedChanged += new System.EventHandler(this.cbxCreateRtv_CheckedChanged);
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
            this.mesBtnCreateRma.Location = new System.Drawing.Point(3, 3);
            this.mesBtnCreateRma.Name = "mesBtnCreateRma";
            this.mesBtnCreateRma.Size = new System.Drawing.Size(132, 35);
            this.mesBtnCreateRma.TabIndex = 1;
            this.mesBtnCreateRma.Text = "RMA";
            this.mesBtnCreateRma.UseVisualStyleBackColor = false;
            this.mesBtnCreateRma.Click += new System.EventHandler(this.mesBtnCreateRma_Click);
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
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel5.Size = new System.Drawing.Size(471, 113);
            this.tableLayoutPanel5.TabIndex = 4;
            // 
            // tableLayoutPanel11
            // 
            this.tableLayoutPanel11.ColumnCount = 1;
            this.tableLayoutPanel11.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel11.Controls.Add(this.label4, 0, 0);
            this.tableLayoutPanel11.Controls.Add(this.mesTbxRmaNote, 0, 1);
            this.tableLayoutPanel11.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel11.Location = new System.Drawing.Point(260, 0);
            this.tableLayoutPanel11.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel11.Name = "tableLayoutPanel11";
            this.tableLayoutPanel11.RowCount = 2;
            this.tableLayoutPanel11.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 25F));
            this.tableLayoutPanel11.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel11.Size = new System.Drawing.Size(211, 113);
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
            this.mesTbxRmaNote.Location = new System.Drawing.Point(3, 28);
            this.mesTbxRmaNote.MaxLength = 110;
            this.mesTbxRmaNote.Multiline = true;
            this.mesTbxRmaNote.Name = "mesTbxRmaNote";
            this.mesTbxRmaNote.Size = new System.Drawing.Size(202, 82);
            this.mesTbxRmaNote.TabIndex = 2;
            // 
            // ucNewRmaCreate
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.Controls.Add(this.tlpMain);
            this.Name = "ucNewRmaCreate";
            this.Size = new System.Drawing.Size(1191, 412);
            this.tlpMain.ResumeLayout(false);
            this.tlpMain.PerformLayout();
            this.tlpPasteSerials.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tlpEnterPartQty.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPartsQuantities)).EndInit();
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tlpRmaProcess.ResumeLayout(false);
            this.tableLayoutPanel10.ResumeLayout(false);
            this.tableLayoutPanel10.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.tableLayoutPanel8.ResumeLayout(false);
            this.tableLayoutPanel8.PerformLayout();
            this.tableLayoutPanel7.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).EndInit();
            this.tableLayoutPanel9.ResumeLayout(false);
            this.tableLayoutPanel6.ResumeLayout(false);
            this.tableLayoutPanel6.PerformLayout();
            this.tableLayoutPanel5.ResumeLayout(false);
            this.tableLayoutPanel11.ResumeLayout(false);
            this.tableLayoutPanel11.PerformLayout();
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
        private System.Windows.Forms.Label lblRmaShipper;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaShipper;
        private System.Windows.Forms.Label lblRtvShipper;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRtvShipper;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox cbxSerialsOnHold;
        private System.Windows.Forms.CheckBox cbxCreateRtv;
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
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel6;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRma;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel5;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel11;
        private System.Windows.Forms.Label label4;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaNote;
    }
}
