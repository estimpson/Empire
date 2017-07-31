namespace QuoteLogGrid.Forms
{
    partial class formCSM
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
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.rbtnNonNorthAmericanMnemonic = new System.Windows.Forms.RadioButton();
            this.pnlNorthAmericanMnemonic = new System.Windows.Forms.Panel();
            this.gridControl1 = new DevExpress.XtraGrid.GridControl();
            this.gridView1 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.gridColumnPlatform = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnProgram = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnNameplate = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnSOP = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnEOP = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnPlant = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnManufacturer = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnCY2013 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnCY2014 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnCY2015 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnCY2016 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnMnemonic_Vehicle_Plant = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnRelease_ID = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumnVersion = new DevExpress.XtraGrid.Columns.GridColumn();
            this.repositoryItemCheckEdit1 = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            this.pnlNonNorthAmericanMnemonic = new System.Windows.Forms.Panel();
            this.cbxDeleteMnemonic = new System.Windows.Forms.CheckBox();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.tbxNameplate = new System.Windows.Forms.TextBox();
            this.tbxProgram = new System.Windows.Forms.TextBox();
            this.tbxPlatform = new System.Windows.Forms.TextBox();
            this.tbxManufacturer = new System.Windows.Forms.TextBox();
            this.rbtnNorthAmericanMnemonic = new System.Windows.Forms.RadioButton();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.lblMessage = new System.Windows.Forms.Label();
            this.tableLayoutPanel2.SuspendLayout();
            this.pnlNorthAmericanMnemonic.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridControl1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).BeginInit();
            this.pnlNonNorthAmericanMnemonic.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 25F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.rbtnNonNorthAmericanMnemonic, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.pnlNorthAmericanMnemonic, 1, 1);
            this.tableLayoutPanel2.Controls.Add(this.pnlNonNorthAmericanMnemonic, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.rbtnNorthAmericanMnemonic, 0, 1);
            this.tableLayoutPanel2.Controls.Add(this.flowLayoutPanel1, 1, 2);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 3;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 56F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(1220, 586);
            this.tableLayoutPanel2.TabIndex = 6;
            // 
            // rbtnNonNorthAmericanMnemonic
            // 
            this.rbtnNonNorthAmericanMnemonic.AutoSize = true;
            this.rbtnNonNorthAmericanMnemonic.Location = new System.Drawing.Point(3, 3);
            this.rbtnNonNorthAmericanMnemonic.Name = "rbtnNonNorthAmericanMnemonic";
            this.rbtnNonNorthAmericanMnemonic.Size = new System.Drawing.Size(14, 13);
            this.rbtnNonNorthAmericanMnemonic.TabIndex = 1;
            this.rbtnNonNorthAmericanMnemonic.TabStop = true;
            this.rbtnNonNorthAmericanMnemonic.UseVisualStyleBackColor = true;
            this.rbtnNonNorthAmericanMnemonic.CheckedChanged += new System.EventHandler(this.rbtnNonNorthAmericanMnemonic_CheckedChanged);
            // 
            // pnlNorthAmericanMnemonic
            // 
            this.pnlNorthAmericanMnemonic.Controls.Add(this.gridControl1);
            this.pnlNorthAmericanMnemonic.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlNorthAmericanMnemonic.Location = new System.Drawing.Point(28, 59);
            this.pnlNorthAmericanMnemonic.Name = "pnlNorthAmericanMnemonic";
            this.pnlNorthAmericanMnemonic.Size = new System.Drawing.Size(1189, 484);
            this.pnlNorthAmericanMnemonic.TabIndex = 4;
            // 
            // gridControl1
            // 
            this.gridControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.gridControl1.Location = new System.Drawing.Point(0, 0);
            this.gridControl1.MainView = this.gridView1;
            this.gridControl1.Name = "gridControl1";
            this.gridControl1.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.repositoryItemCheckEdit1});
            this.gridControl1.Size = new System.Drawing.Size(1189, 484);
            this.gridControl1.TabIndex = 0;
            this.gridControl1.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gridView1});
            // 
            // gridView1
            // 
            this.gridView1.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.gridColumnPlatform,
            this.gridColumnProgram,
            this.gridColumnNameplate,
            this.gridColumnSOP,
            this.gridColumnEOP,
            this.gridColumnPlant,
            this.gridColumnManufacturer,
            this.gridColumnCY2013,
            this.gridColumnCY2014,
            this.gridColumnCY2015,
            this.gridColumnCY2016,
            this.gridColumnMnemonic_Vehicle_Plant,
            this.gridColumnRelease_ID,
            this.gridColumnVersion});
            this.gridView1.GridControl = this.gridControl1;
            this.gridView1.Name = "gridView1";
            this.gridView1.OptionsSelection.MultiSelect = true;
            // 
            // gridColumnPlatform
            // 
            this.gridColumnPlatform.Caption = "Platform";
            this.gridColumnPlatform.FieldName = "Platform";
            this.gridColumnPlatform.Name = "gridColumnPlatform";
            this.gridColumnPlatform.Visible = true;
            this.gridColumnPlatform.VisibleIndex = 0;
            // 
            // gridColumnProgram
            // 
            this.gridColumnProgram.Caption = "Program";
            this.gridColumnProgram.FieldName = "Program";
            this.gridColumnProgram.Name = "gridColumnProgram";
            this.gridColumnProgram.Visible = true;
            this.gridColumnProgram.VisibleIndex = 1;
            // 
            // gridColumnNameplate
            // 
            this.gridColumnNameplate.Caption = "Nameplate";
            this.gridColumnNameplate.FieldName = "Nameplate";
            this.gridColumnNameplate.Name = "gridColumnNameplate";
            this.gridColumnNameplate.Visible = true;
            this.gridColumnNameplate.VisibleIndex = 2;
            // 
            // gridColumnSOP
            // 
            this.gridColumnSOP.Caption = "SOP";
            this.gridColumnSOP.FieldName = "SOP";
            this.gridColumnSOP.Name = "gridColumnSOP";
            this.gridColumnSOP.Visible = true;
            this.gridColumnSOP.VisibleIndex = 3;
            // 
            // gridColumnEOP
            // 
            this.gridColumnEOP.Caption = "EOP";
            this.gridColumnEOP.FieldName = "EOP";
            this.gridColumnEOP.Name = "gridColumnEOP";
            this.gridColumnEOP.Visible = true;
            this.gridColumnEOP.VisibleIndex = 4;
            // 
            // gridColumnPlant
            // 
            this.gridColumnPlant.Caption = "Plant";
            this.gridColumnPlant.FieldName = "Plant";
            this.gridColumnPlant.Name = "gridColumnPlant";
            this.gridColumnPlant.Visible = true;
            this.gridColumnPlant.VisibleIndex = 5;
            // 
            // gridColumnManufacturer
            // 
            this.gridColumnManufacturer.Caption = "Manufacturer";
            this.gridColumnManufacturer.FieldName = "Manufacturer";
            this.gridColumnManufacturer.Name = "gridColumnManufacturer";
            this.gridColumnManufacturer.Visible = true;
            this.gridColumnManufacturer.VisibleIndex = 6;
            // 
            // gridColumnCY2013
            // 
            this.gridColumnCY2013.Caption = "CY 2013";
            this.gridColumnCY2013.FieldName = "CY 2013";
            this.gridColumnCY2013.Name = "gridColumnCY2013";
            this.gridColumnCY2013.Visible = true;
            this.gridColumnCY2013.VisibleIndex = 7;
            // 
            // gridColumnCY2014
            // 
            this.gridColumnCY2014.Caption = "CY 2014";
            this.gridColumnCY2014.FieldName = "CY 2014";
            this.gridColumnCY2014.Name = "gridColumnCY2014";
            this.gridColumnCY2014.Visible = true;
            this.gridColumnCY2014.VisibleIndex = 8;
            // 
            // gridColumnCY2015
            // 
            this.gridColumnCY2015.Caption = "CY 2015";
            this.gridColumnCY2015.FieldName = "CY 2015";
            this.gridColumnCY2015.Name = "gridColumnCY2015";
            this.gridColumnCY2015.Visible = true;
            this.gridColumnCY2015.VisibleIndex = 9;
            // 
            // gridColumnCY2016
            // 
            this.gridColumnCY2016.Caption = "CY 2016";
            this.gridColumnCY2016.FieldName = "CY 2016";
            this.gridColumnCY2016.Name = "gridColumnCY2016";
            this.gridColumnCY2016.Visible = true;
            this.gridColumnCY2016.VisibleIndex = 10;
            // 
            // gridColumnMnemonic_Vehicle_Plant
            // 
            this.gridColumnMnemonic_Vehicle_Plant.Caption = "Mnemonic_Vehicle_Plant";
            this.gridColumnMnemonic_Vehicle_Plant.FieldName = "Mnemonic_Vehicle_Plant";
            this.gridColumnMnemonic_Vehicle_Plant.Name = "gridColumnMnemonic_Vehicle_Plant";
            // 
            // gridColumnRelease_ID
            // 
            this.gridColumnRelease_ID.FieldName = "Release_ID";
            this.gridColumnRelease_ID.Name = "gridColumnRelease_ID";
            // 
            // gridColumnVersion
            // 
            this.gridColumnVersion.FieldName = "Version";
            this.gridColumnVersion.Name = "gridColumnVersion";
            // 
            // repositoryItemCheckEdit1
            // 
            this.repositoryItemCheckEdit1.AutoHeight = false;
            this.repositoryItemCheckEdit1.Name = "repositoryItemCheckEdit1";
            // 
            // pnlNonNorthAmericanMnemonic
            // 
            this.pnlNonNorthAmericanMnemonic.BackColor = System.Drawing.Color.WhiteSmoke;
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.cbxDeleteMnemonic);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label13);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label12);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label11);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label10);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label9);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.label8);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.tbxNameplate);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.tbxProgram);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.tbxPlatform);
            this.pnlNonNorthAmericanMnemonic.Controls.Add(this.tbxManufacturer);
            this.pnlNonNorthAmericanMnemonic.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlNonNorthAmericanMnemonic.Location = new System.Drawing.Point(28, 3);
            this.pnlNonNorthAmericanMnemonic.Name = "pnlNonNorthAmericanMnemonic";
            this.pnlNonNorthAmericanMnemonic.Size = new System.Drawing.Size(1189, 50);
            this.pnlNonNorthAmericanMnemonic.TabIndex = 3;
            // 
            // cbxDeleteMnemonic
            // 
            this.cbxDeleteMnemonic.AutoSize = true;
            this.cbxDeleteMnemonic.Location = new System.Drawing.Point(805, 23);
            this.cbxDeleteMnemonic.Name = "cbxDeleteMnemonic";
            this.cbxDeleteMnemonic.Size = new System.Drawing.Size(109, 17);
            this.cbxDeleteMnemonic.TabIndex = 24;
            this.cbxDeleteMnemonic.Text = "Delete Mnemonic";
            this.cbxDeleteMnemonic.UseVisualStyleBackColor = true;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.Location = new System.Drawing.Point(45, 26);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(66, 15);
            this.label13.TabIndex = 23;
            this.label13.Text = "Mnemonic";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.SystemColors.ControlText;
            this.label12.Location = new System.Drawing.Point(18, 9);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(119, 15);
            this.label12.TabIndex = 22;
            this.label12.Text = "Non-North American";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(643, 6);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(58, 13);
            this.label11.TabIndex = 21;
            this.label11.Text = "Nameplate";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(482, 6);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(46, 13);
            this.label10.TabIndex = 20;
            this.label10.Text = "Program";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(319, 6);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(45, 13);
            this.label9.TabIndex = 19;
            this.label9.Text = "Platform";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(162, 6);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(70, 13);
            this.label8.TabIndex = 18;
            this.label8.Text = "Manufacturer";
            // 
            // tbxNameplate
            // 
            this.tbxNameplate.Location = new System.Drawing.Point(643, 21);
            this.tbxNameplate.Name = "tbxNameplate";
            this.tbxNameplate.Size = new System.Drawing.Size(150, 20);
            this.tbxNameplate.TabIndex = 17;
            // 
            // tbxProgram
            // 
            this.tbxProgram.Location = new System.Drawing.Point(482, 21);
            this.tbxProgram.Name = "tbxProgram";
            this.tbxProgram.Size = new System.Drawing.Size(150, 20);
            this.tbxProgram.TabIndex = 16;
            // 
            // tbxPlatform
            // 
            this.tbxPlatform.Location = new System.Drawing.Point(322, 21);
            this.tbxPlatform.Name = "tbxPlatform";
            this.tbxPlatform.Size = new System.Drawing.Size(150, 20);
            this.tbxPlatform.TabIndex = 15;
            // 
            // tbxManufacturer
            // 
            this.tbxManufacturer.Location = new System.Drawing.Point(162, 21);
            this.tbxManufacturer.Name = "tbxManufacturer";
            this.tbxManufacturer.Size = new System.Drawing.Size(150, 20);
            this.tbxManufacturer.TabIndex = 14;
            // 
            // rbtnNorthAmericanMnemonic
            // 
            this.rbtnNorthAmericanMnemonic.AutoSize = true;
            this.rbtnNorthAmericanMnemonic.Location = new System.Drawing.Point(3, 59);
            this.rbtnNorthAmericanMnemonic.Name = "rbtnNorthAmericanMnemonic";
            this.rbtnNorthAmericanMnemonic.Size = new System.Drawing.Size(14, 13);
            this.rbtnNorthAmericanMnemonic.TabIndex = 2;
            this.rbtnNorthAmericanMnemonic.TabStop = true;
            this.rbtnNorthAmericanMnemonic.UseVisualStyleBackColor = true;
            this.rbtnNorthAmericanMnemonic.CheckedChanged += new System.EventHandler(this.rbtnNorthAmericanMnemonic_CheckedChanged);
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.btnCancel);
            this.flowLayoutPanel1.Controls.Add(this.btnSave);
            this.flowLayoutPanel1.Controls.Add(this.lblMessage);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.RightToLeft;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(28, 549);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(1189, 34);
            this.flowLayoutPanel1.TabIndex = 5;
            // 
            // btnCancel
            // 
            this.btnCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCancel.Location = new System.Drawing.Point(1071, 3);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(115, 31);
            this.btnCancel.TabIndex = 0;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnSave
            // 
            this.btnSave.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSave.Location = new System.Drawing.Point(950, 3);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(115, 31);
            this.btnSave.TabIndex = 1;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // lblMessage
            // 
            this.lblMessage.AutoSize = true;
            this.lblMessage.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMessage.Location = new System.Drawing.Point(886, 0);
            this.lblMessage.Name = "lblMessage";
            this.lblMessage.Size = new System.Drawing.Size(58, 15);
            this.lblMessage.TabIndex = 1;
            this.lblMessage.Text = "Message";
            this.lblMessage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // formCSM
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1220, 586);
            this.Controls.Add(this.tableLayoutPanel2);
            this.Name = "formCSM";
            this.Text = "formCSM";
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.pnlNorthAmericanMnemonic.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.gridControl1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).EndInit();
            this.pnlNonNorthAmericanMnemonic.ResumeLayout(false);
            this.pnlNonNorthAmericanMnemonic.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        public System.Windows.Forms.RadioButton rbtnNonNorthAmericanMnemonic;
        public System.Windows.Forms.Panel pnlNorthAmericanMnemonic;
        public DevExpress.XtraGrid.GridControl gridControl1;
        public DevExpress.XtraGrid.Views.Grid.GridView gridView1;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnPlatform;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnProgram;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnNameplate;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnSOP;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnEOP;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnPlant;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnManufacturer;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnCY2013;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnCY2014;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnCY2015;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnCY2016;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnMnemonic_Vehicle_Plant;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnRelease_ID;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumnVersion;
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit repositoryItemCheckEdit1;
        public System.Windows.Forms.Panel pnlNonNorthAmericanMnemonic;
        public System.Windows.Forms.CheckBox cbxDeleteMnemonic;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label8;
        public System.Windows.Forms.TextBox tbxNameplate;
        public System.Windows.Forms.TextBox tbxProgram;
        public System.Windows.Forms.TextBox tbxPlatform;
        public System.Windows.Forms.TextBox tbxManufacturer;
        public System.Windows.Forms.RadioButton rbtnNorthAmericanMnemonic;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.Label lblMessage;
    }
}