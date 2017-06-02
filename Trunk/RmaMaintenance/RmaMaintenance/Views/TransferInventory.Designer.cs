namespace RmaMaintenance.Views
{
    partial class TransferInventory
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.lblInstructions1 = new System.Windows.Forms.Label();
            this.mesTxtShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.lblInstructions2 = new System.Windows.Forms.Label();
            this.mesTbxTransferLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnTransferSerials = new Fx.WinForms.Flat.MESButton();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.lblInstructions1);
            this.panel1.Controls.Add(this.mesTxtShipper);
            this.panel1.Controls.Add(this.lblInstructions2);
            this.panel1.Controls.Add(this.mesTbxTransferLoc);
            this.panel1.Controls.Add(this.mesBtnTransferSerials);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // lblInstructions1
            // 
            this.lblInstructions1.AutoSize = true;
            this.lblInstructions1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructions1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructions1.Location = new System.Drawing.Point(432, 184);
            this.lblInstructions1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 3);
            this.lblInstructions1.Name = "lblInstructions1";
            this.lblInstructions1.Size = new System.Drawing.Size(335, 18);
            this.lblInstructions1.TabIndex = 101;
            this.lblInstructions1.Text = "1.  Enter the RTV shipper of the serials to transfer:";
            // 
            // mesTxtShipper
            // 
            this.mesTxtShipper.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.mesTxtShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtShipper.Location = new System.Drawing.Point(435, 208);
            this.mesTxtShipper.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.mesTxtShipper.MaxLength = 50;
            this.mesTxtShipper.Name = "mesTxtShipper";
            this.mesTxtShipper.Size = new System.Drawing.Size(177, 27);
            this.mesTxtShipper.TabIndex = 0;
            // 
            // lblInstructions2
            // 
            this.lblInstructions2.AutoSize = true;
            this.lblInstructions2.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructions2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructions2.Location = new System.Drawing.Point(432, 251);
            this.lblInstructions2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.lblInstructions2.Name = "lblInstructions2";
            this.lblInstructions2.Size = new System.Drawing.Size(304, 18);
            this.lblInstructions2.TabIndex = 90;
            this.lblInstructions2.Text = "2.  Enter the Honduras location to transfer to:";
            // 
            // mesTbxTransferLoc
            // 
            this.mesTbxTransferLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxTransferLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxTransferLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxTransferLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxTransferLoc.Location = new System.Drawing.Point(435, 275);
            this.mesTbxTransferLoc.Name = "mesTbxTransferLoc";
            this.mesTbxTransferLoc.Size = new System.Drawing.Size(177, 27);
            this.mesTbxTransferLoc.TabIndex = 1;
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
            this.mesBtnTransferSerials.Location = new System.Drawing.Point(435, 334);
            this.mesBtnTransferSerials.Name = "mesBtnTransferSerials";
            this.mesBtnTransferSerials.Size = new System.Drawing.Size(177, 35);
            this.mesBtnTransferSerials.TabIndex = 2;
            this.mesBtnTransferSerials.Text = "Transfer Inv";
            this.mesBtnTransferSerials.UseVisualStyleBackColor = false;
            this.mesBtnTransferSerials.Click += new System.EventHandler(this.mesBtnTransferSerials_Click);
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
            this.linkLblClose.TabIndex = 3;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // TransferInventory
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "TransferInventory";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "TransferInventory";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.Label lblInstructions2;
        private Fx.WinForms.Flat.MESTextEdit mesTbxTransferLoc;
        private Fx.WinForms.Flat.MESButton mesBtnTransferSerials;
        private System.Windows.Forms.Label lblInstructions1;
        public Fx.WinForms.Flat.MESTextEdit mesTxtShipper;
    }
}