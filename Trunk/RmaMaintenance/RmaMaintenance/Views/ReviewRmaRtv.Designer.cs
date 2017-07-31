namespace RmaMaintenance.Views
{
    partial class ReviewRmaRtv
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
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.lblRmaRtvNumber = new System.Windows.Forms.Label();
            this.mesBtnUndoAll = new Fx.WinForms.Flat.MESButton();
            this.mesBtnContinue = new Fx.WinForms.Flat.MESButton();
            this.lblInstructions = new System.Windows.Forms.Label();
            this.dgvReviewRmaRtv = new System.Windows.Forms.DataGridView();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReviewRmaRtv)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Controls.Add(this.lblRmaRtvNumber);
            this.panel1.Controls.Add(this.mesBtnUndoAll);
            this.panel1.Controls.Add(this.mesBtnContinue);
            this.panel1.Controls.Add(this.lblInstructions);
            this.panel1.Controls.Add(this.dgvReviewRmaRtv);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(977, 9);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(49, 20);
            this.linkLblClose.TabIndex = 2;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
            this.linkLblClose.Visible = false;
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // lblRmaRtvNumber
            // 
            this.lblRmaRtvNumber.AutoSize = true;
            this.lblRmaRtvNumber.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblRmaRtvNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblRmaRtvNumber.Location = new System.Drawing.Point(184, 71);
            this.lblRmaRtvNumber.Name = "lblRmaRtvNumber";
            this.lblRmaRtvNumber.Size = new System.Drawing.Size(179, 24);
            this.lblRmaRtvNumber.TabIndex = 89;
            this.lblRmaRtvNumber.Text = "RMA / RTV Number";
            // 
            // mesBtnUndoAll
            // 
            this.mesBtnUndoAll.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnUndoAll.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnUndoAll.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnUndoAll.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnUndoAll.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnUndoAll.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnUndoAll.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnUndoAll.Location = new System.Drawing.Point(495, 471);
            this.mesBtnUndoAll.Name = "mesBtnUndoAll";
            this.mesBtnUndoAll.Size = new System.Drawing.Size(128, 35);
            this.mesBtnUndoAll.TabIndex = 0;
            this.mesBtnUndoAll.Text = "Undo All";
            this.mesBtnUndoAll.UseVisualStyleBackColor = false;
            this.mesBtnUndoAll.Click += new System.EventHandler(this.mesBtnUndoAll_Click);
            this.mesBtnUndoAll.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnUndoAll_MouseDown);
            // 
            // mesBtnContinue
            // 
            this.mesBtnContinue.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnContinue.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnContinue.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnContinue.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnContinue.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnContinue.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnContinue.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnContinue.Location = new System.Drawing.Point(653, 471);
            this.mesBtnContinue.Name = "mesBtnContinue";
            this.mesBtnContinue.Size = new System.Drawing.Size(205, 35);
            this.mesBtnContinue.TabIndex = 1;
            this.mesBtnContinue.Text = "Continue";
            this.mesBtnContinue.UseVisualStyleBackColor = false;
            this.mesBtnContinue.Click += new System.EventHandler(this.mesBtnContinue_Click);
            // 
            // lblInstructions
            // 
            this.lblInstructions.AutoSize = true;
            this.lblInstructions.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructions.ForeColor = System.Drawing.Color.White;
            this.lblInstructions.Location = new System.Drawing.Point(185, 103);
            this.lblInstructions.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.lblInstructions.Name = "lblInstructions";
            this.lblInstructions.Size = new System.Drawing.Size(426, 18);
            this.lblInstructions.TabIndex = 64;
            this.lblInstructions.Text = "If everything looks okay, click Continue to go to the next screen.";
            // 
            // dgvReviewRmaRtv
            // 
            this.dgvReviewRmaRtv.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.dgvReviewRmaRtv.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.Black;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvReviewRmaRtv.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvReviewRmaRtv.Location = new System.Drawing.Point(184, 127);
            this.dgvReviewRmaRtv.MultiSelect = false;
            this.dgvReviewRmaRtv.Name = "dgvReviewRmaRtv";
            this.dgvReviewRmaRtv.ReadOnly = true;
            this.dgvReviewRmaRtv.RowHeadersVisible = false;
            this.dgvReviewRmaRtv.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvReviewRmaRtv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReviewRmaRtv.Size = new System.Drawing.Size(674, 331);
            this.dgvReviewRmaRtv.TabIndex = 50;
            // 
            // ReviewRmaRtv
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "ReviewRmaRtv";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "ShipoutRmaRtv";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReviewRmaRtv)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label lblInstructions;
        private System.Windows.Forms.DataGridView dgvReviewRmaRtv;
        private Fx.WinForms.Flat.MESButton mesBtnUndoAll;
        private Fx.WinForms.Flat.MESButton mesBtnContinue;
        private System.Windows.Forms.Label lblRmaRtvNumber;
        private System.Windows.Forms.LinkLabel linkLblClose;
    }
}