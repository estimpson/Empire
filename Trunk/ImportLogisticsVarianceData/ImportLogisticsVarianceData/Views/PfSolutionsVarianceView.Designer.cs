namespace ImportLogisticsVarianceData.Views
{
    partial class PfSolutionsVarianceView
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
            this.lblProcessing = new System.Windows.Forms.Label();
            this.mesBtnImport = new Fx.WinForms.Flat.MESButton();
            this.label1 = new System.Windows.Forms.Label();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.SuspendLayout();
            // 
            // lblProcessing
            // 
            this.lblProcessing.AutoSize = true;
            this.lblProcessing.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblProcessing.ForeColor = System.Drawing.Color.White;
            this.lblProcessing.Location = new System.Drawing.Point(298, 401);
            this.lblProcessing.Name = "lblProcessing";
            this.lblProcessing.Size = new System.Drawing.Size(110, 20);
            this.lblProcessing.TabIndex = 60;
            this.lblProcessing.Text = "Processing ...";
            // 
            // mesBtnImport
            // 
            this.mesBtnImport.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnImport.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnImport.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnImport.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnImport.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnImport.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnImport.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnImport.Location = new System.Drawing.Point(302, 343);
            this.mesBtnImport.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnImport.Name = "mesBtnImport";
            this.mesBtnImport.Size = new System.Drawing.Size(237, 43);
            this.mesBtnImport.TabIndex = 63;
            this.mesBtnImport.Text = "Import PFS";
            this.mesBtnImport.UseVisualStyleBackColor = false;
            this.mesBtnImport.Click += new System.EventHandler(this.mesBtnImport_Click);
            this.mesBtnImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnImport_MouseDown);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.RoyalBlue;
            this.label1.Location = new System.Drawing.Point(298, 293);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(756, 24);
            this.label1.TabIndex = 62;
            this.label1.Text = "1.  Save the spreadsheet as PFSolutions.CSV in the LogisticsVariance\\PFSolutions " +
    "folder.";
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Constantia", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.RoyalBlue;
            this.linkLblClose.Location = new System.Drawing.Point(1229, 34);
            this.linkLblClose.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(80, 33);
            this.linkLblClose.TabIndex = 61;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // PfSolutionsView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1331, 714);
            this.ControlBox = false;
            this.Controls.Add(this.lblProcessing);
            this.Controls.Add(this.mesBtnImport);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.linkLblClose);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "PfSolutionsView";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "PfSolutionsView";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblProcessing;
        private Fx.WinForms.Flat.MESButton mesBtnImport;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.LinkLabel linkLblClose;
    }
}