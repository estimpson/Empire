namespace RmaMaintenance.Views
{
    partial class RmaRtvHistory
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label1 = new System.Windows.Forms.Label();
            this.mesBtnSubmit = new Fx.WinForms.Flat.MESButton();
            this.mesTbxRmaRtv = new Fx.WinForms.Flat.MESTextEdit();
            this.label9 = new System.Windows.Forms.Label();
            this.dgvRmaRtvHistory = new System.Windows.Forms.DataGridView();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRmaRtvHistory)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.mesBtnSubmit);
            this.panel1.Controls.Add(this.mesTbxRmaRtv);
            this.panel1.Controls.Add(this.label9);
            this.panel1.Controls.Add(this.dgvRmaRtvHistory);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(648, 539);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(328, 16);
            this.label1.TabIndex = 99;
            this.label1.Text = "* Will only find shippers that were created with this app.";
            // 
            // mesBtnSubmit
            // 
            this.mesBtnSubmit.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnSubmit.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnSubmit.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnSubmit.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnSubmit.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnSubmit.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnSubmit.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnSubmit.Location = new System.Drawing.Point(244, 54);
            this.mesBtnSubmit.Name = "mesBtnSubmit";
            this.mesBtnSubmit.Size = new System.Drawing.Size(107, 35);
            this.mesBtnSubmit.TabIndex = 1;
            this.mesBtnSubmit.Text = "Submit";
            this.mesBtnSubmit.UseVisualStyleBackColor = false;
            this.mesBtnSubmit.Click += new System.EventHandler(this.mesBtnSubmit_Click);
            this.mesBtnSubmit.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnSubmit_MouseDown);
            // 
            // mesTbxRmaRtv
            // 
            this.mesTbxRmaRtv.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaRtv.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaRtv.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRmaRtv.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaRtv.Location = new System.Drawing.Point(64, 59);
            this.mesTbxRmaRtv.Name = "mesTbxRmaRtv";
            this.mesTbxRmaRtv.Size = new System.Drawing.Size(164, 27);
            this.mesTbxRmaRtv.TabIndex = 0;
            this.mesTbxRmaRtv.KeyDown += new System.Windows.Forms.KeyEventHandler(this.mesTbxRmaRtv_KeyDown);
            // 
            // label9
            // 
            this.label9.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label9.Location = new System.Drawing.Point(61, 40);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(130, 16);
            this.label9.TabIndex = 90;
            this.label9.Text = "RMA / RTV Number:";
            // 
            // dgvRmaRtvHistory
            // 
            this.dgvRmaRtvHistory.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.dgvRmaRtvHistory.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.Black;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvRmaRtvHistory.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvRmaRtvHistory.Location = new System.Drawing.Point(64, 98);
            this.dgvRmaRtvHistory.Name = "dgvRmaRtvHistory";
            this.dgvRmaRtvHistory.ReadOnly = true;
            this.dgvRmaRtvHistory.RowHeadersVisible = false;
            this.dgvRmaRtvHistory.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvRmaRtvHistory.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvRmaRtvHistory.Size = new System.Drawing.Size(908, 438);
            this.dgvRmaRtvHistory.TabIndex = 89;
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(968, 9);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(58, 20);
            this.linkLblClose.TabIndex = 2;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // RmaRtvHistory
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "RmaRtvHistory";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "RmaRtvHistory";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRmaRtvHistory)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.DataGridView dgvRmaRtvHistory;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaRtv;
        private System.Windows.Forms.Label label9;
        private Fx.WinForms.Flat.MESButton mesBtnSubmit;
        private System.Windows.Forms.Label label1;
    }
}