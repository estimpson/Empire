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
            this.rbtnEnterPartQty = new System.Windows.Forms.RadioButton();
            this.rbtnPasteSerials = new System.Windows.Forms.RadioButton();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTxtRmaNumber = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnEnterRmaNumber = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel4.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 5;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 145F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 145F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 175F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 230F));
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Controls.Add(this.rbtnEnterPartQty, 5, 0);
            this.tableLayoutPanel4.Controls.Add(this.rbtnPasteSerials, 3, 0);
            this.tableLayoutPanel4.Controls.Add(this.label2, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.mesTxtRmaNumber, 1, 0);
            this.tableLayoutPanel4.Controls.Add(this.mesBtnEnterRmaNumber, 2, 0);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel4.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 1;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(992, 50);
            this.tableLayoutPanel4.TabIndex = 2;
            // 
            // rbtnEnterPartQty
            // 
            this.rbtnEnterPartQty.AutoSize = true;
            this.rbtnEnterPartQty.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnEnterPartQty.ForeColor = System.Drawing.Color.White;
            this.rbtnEnterPartQty.Location = new System.Drawing.Point(698, 3);
            this.rbtnEnterPartQty.Name = "rbtnEnterPartQty";
            this.rbtnEnterPartQty.Size = new System.Drawing.Size(158, 20);
            this.rbtnEnterPartQty.TabIndex = 3;
            this.rbtnEnterPartQty.TabStop = true;
            this.rbtnEnterPartQty.Text = "Enter part and quantity";
            this.rbtnEnterPartQty.UseVisualStyleBackColor = true;
            this.rbtnEnterPartQty.CheckedChanged += new System.EventHandler(this.rbtnEnterPartQty_CheckedChanged);
            // 
            // rbtnPasteSerials
            // 
            this.rbtnPasteSerials.AutoSize = true;
            this.rbtnPasteSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnPasteSerials.ForeColor = System.Drawing.Color.White;
            this.rbtnPasteSerials.Location = new System.Drawing.Point(468, 3);
            this.rbtnPasteSerials.Name = "rbtnPasteSerials";
            this.rbtnPasteSerials.Size = new System.Drawing.Size(212, 20);
            this.rbtnPasteSerials.TabIndex = 0;
            this.rbtnPasteSerials.TabStop = true;
            this.rbtnPasteSerials.Text = "Paste serials from spreadsheet";
            this.rbtnPasteSerials.UseVisualStyleBackColor = true;
            this.rbtnPasteSerials.CheckedChanged += new System.EventHandler(this.rbtnPasteSerials_CheckedChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(3, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(136, 16);
            this.label2.TabIndex = 0;
            this.label2.Text = "Quality RMA Number:";
            // 
            // mesTxtRmaNumber
            // 
            this.mesTxtRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtRmaNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtRmaNumber.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtRmaNumber.Location = new System.Drawing.Point(148, 3);
            this.mesTxtRmaNumber.MaxLength = 50;
            this.mesTxtRmaNumber.Name = "mesTxtRmaNumber";
            this.mesTxtRmaNumber.Size = new System.Drawing.Size(129, 27);
            this.mesTxtRmaNumber.TabIndex = 1;
            // 
            // mesBtnEnterRmaNumber
            // 
            this.mesBtnEnterRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnEnterRmaNumber.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnEnterRmaNumber.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnEnterRmaNumber.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesBtnEnterRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnEnterRmaNumber.Location = new System.Drawing.Point(293, 3);
            this.mesBtnEnterRmaNumber.Name = "mesBtnEnterRmaNumber";
            this.mesBtnEnterRmaNumber.Size = new System.Drawing.Size(100, 30);
            this.mesBtnEnterRmaNumber.TabIndex = 2;
            this.mesBtnEnterRmaNumber.Text = "Enter";
            this.mesBtnEnterRmaNumber.UseVisualStyleBackColor = false;
            this.mesBtnEnterRmaNumber.Click += new System.EventHandler(this.mesBtnEnterRmaNumber_Click);
            // 
            // ucNewRmaOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.Controls.Add(this.tableLayoutPanel4);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "ucNewRmaOptions";
            this.Size = new System.Drawing.Size(992, 50);
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel4.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private System.Windows.Forms.RadioButton rbtnEnterPartQty;
        private System.Windows.Forms.RadioButton rbtnPasteSerials;
        private System.Windows.Forms.Label label2;
        private Fx.WinForms.Flat.MESButton mesBtnEnterRmaNumber;
        public Fx.WinForms.Flat.MESTextEdit mesTxtRmaNumber;
    }
}
