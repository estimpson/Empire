namespace RmaMaintenance.UserControls
{
    partial class ucEditRmaQuantities
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
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.tlpEditQty = new System.Windows.Forms.TableLayoutPanel();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxSerial = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnEnter = new Fx.WinForms.Flat.MESButton();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.mesTbxCurrentQty = new Fx.WinForms.Flat.MESTextEdit();
            this.mesTbxNewQty = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnSave = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.tlpEditQty.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 1);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(351, 236);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(3, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(139, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Change Serial Quantity";
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 1;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.tableLayoutPanel3, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.tlpEditQty, 0, 1);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 33);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 60F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(345, 200);
            this.tableLayoutPanel2.TabIndex = 1;
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 3;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 85F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 140F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.label2, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.mesTbxSerial, 1, 0);
            this.tableLayoutPanel3.Controls.Add(this.mesBtnEnter, 2, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(345, 60);
            this.tableLayoutPanel3.TabIndex = 0;
            // 
            // tlpEditQty
            // 
            this.tlpEditQty.ColumnCount = 2;
            this.tlpEditQty.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 85F));
            this.tlpEditQty.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpEditQty.Controls.Add(this.label3, 0, 0);
            this.tlpEditQty.Controls.Add(this.label4, 0, 1);
            this.tlpEditQty.Controls.Add(this.mesTbxCurrentQty, 1, 0);
            this.tlpEditQty.Controls.Add(this.mesTbxNewQty, 1, 1);
            this.tlpEditQty.Controls.Add(this.mesBtnSave, 1, 2);
            this.tlpEditQty.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpEditQty.Location = new System.Drawing.Point(0, 60);
            this.tlpEditQty.Margin = new System.Windows.Forms.Padding(0);
            this.tlpEditQty.Name = "tlpEditQty";
            this.tlpEditQty.RowCount = 3;
            this.tlpEditQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tlpEditQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tlpEditQty.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tlpEditQty.Size = new System.Drawing.Size(345, 140);
            this.tlpEditQty.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(3, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(46, 16);
            this.label2.TabIndex = 1;
            this.label2.Text = "Serial:";
            // 
            // mesTbxSerial
            // 
            this.mesTbxSerial.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxSerial.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxSerial.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxSerial.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxSerial.Location = new System.Drawing.Point(88, 3);
            this.mesTbxSerial.Name = "mesTbxSerial";
            this.mesTbxSerial.Size = new System.Drawing.Size(100, 27);
            this.mesTbxSerial.TabIndex = 2;
            // 
            // mesBtnEnter
            // 
            this.mesBtnEnter.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnEnter.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnEnter.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnEnter.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnEnter.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnEnter.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnEnter.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnEnter.Location = new System.Drawing.Point(228, 3);
            this.mesBtnEnter.Name = "mesBtnEnter";
            this.mesBtnEnter.Size = new System.Drawing.Size(93, 35);
            this.mesBtnEnter.TabIndex = 3;
            this.mesBtnEnter.Text = "Enter";
            this.mesBtnEnter.UseVisualStyleBackColor = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(3, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(79, 16);
            this.label3.TabIndex = 2;
            this.label3.Text = "Current Qty:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(3, 40);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(61, 16);
            this.label4.TabIndex = 3;
            this.label4.Text = "New Qty:";
            // 
            // mesTbxCurrentQty
            // 
            this.mesTbxCurrentQty.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxCurrentQty.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxCurrentQty.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxCurrentQty.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxCurrentQty.Location = new System.Drawing.Point(88, 3);
            this.mesTbxCurrentQty.MaxLength = 5;
            this.mesTbxCurrentQty.Name = "mesTbxCurrentQty";
            this.mesTbxCurrentQty.ReadOnly = true;
            this.mesTbxCurrentQty.Size = new System.Drawing.Size(66, 27);
            this.mesTbxCurrentQty.TabIndex = 4;
            // 
            // mesTbxNewQty
            // 
            this.mesTbxNewQty.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxNewQty.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxNewQty.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxNewQty.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxNewQty.Location = new System.Drawing.Point(88, 43);
            this.mesTbxNewQty.MaxLength = 5;
            this.mesTbxNewQty.Name = "mesTbxNewQty";
            this.mesTbxNewQty.Size = new System.Drawing.Size(66, 27);
            this.mesTbxNewQty.TabIndex = 5;
            // 
            // mesBtnSave
            // 
            this.mesBtnSave.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnSave.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnSave.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnSave.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnSave.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnSave.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnSave.Location = new System.Drawing.Point(88, 83);
            this.mesBtnSave.Name = "mesBtnSave";
            this.mesBtnSave.Size = new System.Drawing.Size(95, 35);
            this.mesBtnSave.TabIndex = 6;
            this.mesBtnSave.Text = "Save";
            this.mesBtnSave.UseVisualStyleBackColor = false;
            // 
            // ucEditRmaQuantities
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.Controls.Add(this.tableLayoutPanel1);
            this.Name = "ucEditRmaQuantities";
            this.Size = new System.Drawing.Size(351, 236);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.tlpEditQty.ResumeLayout(false);
            this.tlpEditQty.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.Label label2;
        private Fx.WinForms.Flat.MESTextEdit mesTbxSerial;
        private Fx.WinForms.Flat.MESButton mesBtnEnter;
        private System.Windows.Forms.TableLayoutPanel tlpEditQty;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private Fx.WinForms.Flat.MESTextEdit mesTbxCurrentQty;
        private Fx.WinForms.Flat.MESTextEdit mesTbxNewQty;
        private Fx.WinForms.Flat.MESButton mesBtnSave;
    }
}
