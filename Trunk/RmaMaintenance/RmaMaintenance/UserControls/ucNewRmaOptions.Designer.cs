namespace RmaMaintenance.UserControls
{
    partial class ucNewRmaOptions
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
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.PanelRMA = new System.Windows.Forms.TableLayoutPanel();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.rbtnPasteSerials = new System.Windows.Forms.RadioButton();
            this.rbtnEnterPartQty = new System.Windows.Forms.RadioButton();
            this.mesTxtRmaNumber = new Fx.WinForms.Flat.MESTextEdit();
            this.label2 = new System.Windows.Forms.Label();
            this.mesBtnEnterRmaNumber = new Fx.WinForms.Flat.MESButton();
            this.label1 = new System.Windows.Forms.Label();
            this.PanelRTV = new System.Windows.Forms.TableLayoutPanel();
            this.rbtnPasteSerials2 = new System.Windows.Forms.RadioButton();
            this.EnterRTVNumber = new Fx.WinForms.Flat.MESButton();
            this.RTVNumberEdit = new Fx.WinForms.Flat.MESTextEdit();
            this.label3 = new System.Windows.Forms.Label();
            this.tableLayoutPanel4.SuspendLayout();
            this.PanelRMA.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.PanelRTV.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.AutoSize = true;
            this.tableLayoutPanel4.ColumnCount = 1;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 1000F));
            this.tableLayoutPanel4.Controls.Add(this.PanelRMA, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.label1, 0, 1);
            this.tableLayoutPanel4.Controls.Add(this.PanelRTV, 0, 2);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel4.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 3;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(1000, 99);
            this.tableLayoutPanel4.TabIndex = 2;
            // 
            // PanelRMA
            // 
            this.PanelRMA.AutoSize = true;
            this.PanelRMA.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.PanelRMA.ColumnCount = 4;
            this.PanelRMA.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 142F));
            this.PanelRMA.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 151F));
            this.PanelRMA.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 94F));
            this.PanelRMA.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.PanelRMA.Controls.Add(this.flowLayoutPanel1, 3, 0);
            this.PanelRMA.Controls.Add(this.mesTxtRmaNumber, 1, 0);
            this.PanelRMA.Controls.Add(this.label2, 0, 0);
            this.PanelRMA.Controls.Add(this.mesBtnEnterRmaNumber, 2, 0);
            this.PanelRMA.Dock = System.Windows.Forms.DockStyle.Fill;
            this.PanelRMA.Location = new System.Drawing.Point(0, 0);
            this.PanelRMA.Margin = new System.Windows.Forms.Padding(0);
            this.PanelRMA.Name = "PanelRMA";
            this.PanelRMA.RowCount = 1;
            this.PanelRMA.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.PanelRMA.Size = new System.Drawing.Size(1000, 41);
            this.PanelRMA.TabIndex = 11;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.rbtnPasteSerials);
            this.flowLayoutPanel1.Controls.Add(this.rbtnEnterPartQty);
            this.flowLayoutPanel1.Location = new System.Drawing.Point(390, 6);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(3, 6, 3, 3);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(398, 30);
            this.flowLayoutPanel1.TabIndex = 14;
            // 
            // rbtnPasteSerials
            // 
            this.rbtnPasteSerials.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.rbtnPasteSerials.AutoSize = true;
            this.rbtnPasteSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnPasteSerials.ForeColor = System.Drawing.Color.White;
            this.rbtnPasteSerials.Location = new System.Drawing.Point(12, 3);
            this.rbtnPasteSerials.Margin = new System.Windows.Forms.Padding(12, 3, 9, 3);
            this.rbtnPasteSerials.Name = "rbtnPasteSerials";
            this.rbtnPasteSerials.Size = new System.Drawing.Size(169, 20);
            this.rbtnPasteSerials.TabIndex = 5;
            this.rbtnPasteSerials.Text = "Paste serials from Excel";
            this.rbtnPasteSerials.UseVisualStyleBackColor = true;
            this.rbtnPasteSerials.CheckedChanged += new System.EventHandler(this.rbtnPasteSerials_CheckedChanged);
            // 
            // rbtnEnterPartQty
            // 
            this.rbtnEnterPartQty.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.rbtnEnterPartQty.AutoSize = true;
            this.rbtnEnterPartQty.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnEnterPartQty.ForeColor = System.Drawing.Color.White;
            this.rbtnEnterPartQty.Location = new System.Drawing.Point(193, 3);
            this.rbtnEnterPartQty.Name = "rbtnEnterPartQty";
            this.rbtnEnterPartQty.Size = new System.Drawing.Size(139, 20);
            this.rbtnEnterPartQty.TabIndex = 5;
            this.rbtnEnterPartQty.Text = "Enter part / quantity";
            this.rbtnEnterPartQty.UseVisualStyleBackColor = true;
            this.rbtnEnterPartQty.CheckedChanged += new System.EventHandler(this.rbtnEnterPartQty_CheckedChanged);
            // 
            // mesTxtRmaNumber
            // 
            this.mesTxtRmaNumber.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.mesTxtRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtRmaNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtRmaNumber.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtRmaNumber.Location = new System.Drawing.Point(145, 7);
            this.mesTxtRmaNumber.MaxLength = 50;
            this.mesTxtRmaNumber.Name = "mesTxtRmaNumber";
            this.mesTxtRmaNumber.Size = new System.Drawing.Size(131, 27);
            this.mesTxtRmaNumber.TabIndex = 2;
            this.mesTxtRmaNumber.KeyUp += new System.Windows.Forms.KeyEventHandler(this.MESTxtRmaNumberKeyUp);
            // 
            // label2
            // 
            this.label2.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(3, 12);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(127, 16);
            this.label2.TabIndex = 1;
            this.label2.Text = "Quality RMA/RTV #:";
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
            this.mesBtnEnterRmaNumber.Location = new System.Drawing.Point(296, 3);
            this.mesBtnEnterRmaNumber.Name = "mesBtnEnterRmaNumber";
            this.mesBtnEnterRmaNumber.Size = new System.Drawing.Size(85, 35);
            this.mesBtnEnterRmaNumber.TabIndex = 15;
            this.mesBtnEnterRmaNumber.Text = "Enter";
            this.mesBtnEnterRmaNumber.UseVisualStyleBackColor = false;
            this.mesBtnEnterRmaNumber.Click += new System.EventHandler(this.mesBtnEnterRmaNumber_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.LightGray;
            this.label1.Location = new System.Drawing.Point(3, 41);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(20, 16);
            this.label1.TabIndex = 4;
            this.label1.Text = "or";
            this.label1.Visible = false;
            // 
            // PanelRTV
            // 
            this.PanelRTV.AutoSize = true;
            this.PanelRTV.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.PanelRTV.ColumnCount = 4;
            this.PanelRTV.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.PanelRTV.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.PanelRTV.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.PanelRTV.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.PanelRTV.Controls.Add(this.rbtnPasteSerials2, 3, 0);
            this.PanelRTV.Controls.Add(this.EnterRTVNumber, 0, 0);
            this.PanelRTV.Controls.Add(this.RTVNumberEdit, 0, 0);
            this.PanelRTV.Controls.Add(this.label3, 2, 0);
            this.PanelRTV.Dock = System.Windows.Forms.DockStyle.Fill;
            this.PanelRTV.Location = new System.Drawing.Point(3, 60);
            this.PanelRTV.Name = "PanelRTV";
            this.PanelRTV.RowCount = 1;
            this.PanelRTV.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.PanelRTV.Size = new System.Drawing.Size(994, 36);
            this.PanelRTV.TabIndex = 13;
            // 
            // rbtnPasteSerials2
            // 
            this.rbtnPasteSerials2.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.rbtnPasteSerials2.AutoSize = true;
            this.rbtnPasteSerials2.Checked = true;
            this.rbtnPasteSerials2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnPasteSerials2.ForeColor = System.Drawing.Color.White;
            this.rbtnPasteSerials2.Location = new System.Drawing.Point(562, 8);
            this.rbtnPasteSerials2.Name = "rbtnPasteSerials2";
            this.rbtnPasteSerials2.Size = new System.Drawing.Size(212, 20);
            this.rbtnPasteSerials2.TabIndex = 13;
            this.rbtnPasteSerials2.TabStop = true;
            this.rbtnPasteSerials2.Text = "Paste serials from spreadsheet";
            this.rbtnPasteSerials2.UseVisualStyleBackColor = true;
            // 
            // EnterRTVNumber
            // 
            this.EnterRTVNumber.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.EnterRTVNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.EnterRTVNumber.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.EnterRTVNumber.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.EnterRTVNumber.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.EnterRTVNumber.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.EnterRTVNumber.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.EnterRTVNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.EnterRTVNumber.Location = new System.Drawing.Point(134, 3);
            this.EnterRTVNumber.Name = "EnterRTVNumber";
            this.EnterRTVNumber.Size = new System.Drawing.Size(110, 30);
            this.EnterRTVNumber.TabIndex = 12;
            this.EnterRTVNumber.Text = "New";
            this.EnterRTVNumber.UseVisualStyleBackColor = false;
            this.EnterRTVNumber.Click += new System.EventHandler(this.EnterRTVButtonClick);
            // 
            // RTVNumberEdit
            // 
            this.RTVNumberEdit.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.RTVNumberEdit.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.RTVNumberEdit.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.RTVNumberEdit.Font = new System.Drawing.Font("Tahoma", 12F);
            this.RTVNumberEdit.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.RTVNumberEdit.Location = new System.Drawing.Point(3, 4);
            this.RTVNumberEdit.MaxLength = 50;
            this.RTVNumberEdit.Name = "RTVNumberEdit";
            this.RTVNumberEdit.Size = new System.Drawing.Size(125, 27);
            this.RTVNumberEdit.TabIndex = 11;
            // 
            // label3
            // 
            this.label3.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(250, 10);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(90, 16);
            this.label3.TabIndex = 10;
            this.label3.Text = "RTV Number:";
            // 
            // ucNewRmaOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.Black;
            this.Controls.Add(this.tableLayoutPanel4);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "ucNewRmaOptions";
            this.Size = new System.Drawing.Size(1000, 99);
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel4.PerformLayout();
            this.PanelRMA.ResumeLayout(false);
            this.PanelRMA.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.PanelRTV.ResumeLayout(false);
            this.PanelRTV.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private System.Windows.Forms.TableLayoutPanel PanelRMA;
        public Fx.WinForms.Flat.MESTextEdit mesTxtRmaNumber;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TableLayoutPanel PanelRTV;
        private System.Windows.Forms.RadioButton rbtnPasteSerials2;
        private Fx.WinForms.Flat.MESButton EnterRTVNumber;
        public Fx.WinForms.Flat.MESTextEdit RTVNumberEdit;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.RadioButton rbtnPasteSerials;
        private System.Windows.Forms.RadioButton rbtnEnterPartQty;
        private System.Windows.Forms.Label label1;
        private Fx.WinForms.Flat.MESButton mesBtnEnterRmaNumber;
    }
}
