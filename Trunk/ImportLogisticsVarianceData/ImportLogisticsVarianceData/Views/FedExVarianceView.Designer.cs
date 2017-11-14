namespace ImportLogisticsVarianceData.Views
{
    partial class FedExVarianceView
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
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.mesBtnImport = new Fx.WinForms.Flat.MESButton();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Constantia", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.RoyalBlue;
            this.linkLblClose.Location = new System.Drawing.Point(921, 36);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(62, 26);
            this.linkLblClose.TabIndex = 1;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
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
            this.mesBtnImport.Location = new System.Drawing.Point(425, 284);
            this.mesBtnImport.Name = "mesBtnImport";
            this.mesBtnImport.Size = new System.Drawing.Size(150, 35);
            this.mesBtnImport.TabIndex = 0;
            this.mesBtnImport.Text = "Import";
            this.mesBtnImport.UseVisualStyleBackColor = false;
            this.mesBtnImport.Click += new System.EventHandler(this.mesBtnImport_Click);
            this.mesBtnImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnImport_MouseDown);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.RoyalBlue;
            this.label1.Location = new System.Drawing.Point(235, 244);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(557, 18);
            this.label1.TabIndex = 57;
            this.label1.Text = "Save the spreadsheet as FedExVariance.CSV in the LogisticsVariance\\FedEx folder.";
            // 
            // FedExVarianceView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(998, 580);
            this.ControlBox = false;
            this.Controls.Add(this.label1);
            this.Controls.Add(this.mesBtnImport);
            this.Controls.Add(this.linkLblClose);
            this.ForeColor = System.Drawing.Color.White;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "FedExVarianceView";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "FedExVarianceView";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.LinkLabel linkLblClose;
        private Fx.WinForms.Flat.MESButton mesBtnImport;
        private System.Windows.Forms.Label label1;
    }
}