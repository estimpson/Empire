﻿namespace RmaMaintenance.Views
{
    partial class ShipoutExistingRtvOnly
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
            this.panel2 = new System.Windows.Forms.Panel();
            this.mesBtnRtvLabels = new Fx.WinForms.Flat.MESButton();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxRtvShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.mesTbxHonLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnShipout = new Fx.WinForms.Flat.MESButton();
            this.mesBtnRtvPackingSlip = new Fx.WinForms.Flat.MESButton();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Controls.Add(this.mesBtnRtvLabels);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Controls.Add(this.mesTbxRtvShipper);
            this.panel1.Controls.Add(this.mesTbxHonLoc);
            this.panel1.Controls.Add(this.mesBtnShipout);
            this.panel1.Controls.Add(this.mesBtnRtvPackingSlip);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1384, 716);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.Black;
            this.panel2.Location = new System.Drawing.Point(430, 333);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(153, 98);
            this.panel2.TabIndex = 99;
            // 
            // mesBtnRtvLabels
            // 
            this.mesBtnRtvLabels.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnRtvLabels.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnRtvLabels.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnRtvLabels.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnRtvLabels.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnRtvLabels.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesBtnRtvLabels.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnRtvLabels.Location = new System.Drawing.Point(621, 393);
            this.mesBtnRtvLabels.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnRtvLabels.Name = "mesBtnRtvLabels";
            this.mesBtnRtvLabels.Size = new System.Drawing.Size(200, 38);
            this.mesBtnRtvLabels.TabIndex = 98;
            this.mesBtnRtvLabels.Text = "Print Labels";
            this.mesBtnRtvLabels.UseVisualStyleBackColor = false;
            this.mesBtnRtvLabels.Click += new System.EventHandler(this.mesBtnRtvLabels_Click);
            this.mesBtnRtvLabels.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnRtvLabels_MouseDown);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label4.Location = new System.Drawing.Point(617, 194);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 2, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(366, 24);
            this.label4.TabIndex = 96;
            this.label4.Text = "Enter RTV shipper and Honduras location:";
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(443, 274);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(162, 20);
            this.label3.TabIndex = 92;
            this.label3.Text = "Honduras RMA Loc:";
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(495, 228);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(109, 20);
            this.label2.TabIndex = 95;
            this.label2.Text = "RTV Shipper:";
            // 
            // mesTbxRtvShipper
            // 
            this.mesTbxRtvShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRtvShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRtvShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRtvShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRtvShipper.Location = new System.Drawing.Point(621, 231);
            this.mesTbxRtvShipper.Margin = new System.Windows.Forms.Padding(4);
            this.mesTbxRtvShipper.Name = "mesTbxRtvShipper";
            this.mesTbxRtvShipper.Size = new System.Drawing.Size(199, 32);
            this.mesTbxRtvShipper.TabIndex = 0;
            // 
            // mesTbxHonLoc
            // 
            this.mesTbxHonLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxHonLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxHonLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxHonLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxHonLoc.Location = new System.Drawing.Point(621, 276);
            this.mesTbxHonLoc.Margin = new System.Windows.Forms.Padding(4);
            this.mesTbxHonLoc.MaxLength = 20;
            this.mesTbxHonLoc.Name = "mesTbxHonLoc";
            this.mesTbxHonLoc.Size = new System.Drawing.Size(199, 32);
            this.mesTbxHonLoc.TabIndex = 1;
            // 
            // mesBtnShipout
            // 
            this.mesBtnShipout.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnShipout.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnShipout.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnShipout.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnShipout.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnShipout.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnShipout.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnShipout.Location = new System.Drawing.Point(621, 462);
            this.mesBtnShipout.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnShipout.Name = "mesBtnShipout";
            this.mesBtnShipout.Size = new System.Drawing.Size(200, 50);
            this.mesBtnShipout.TabIndex = 3;
            this.mesBtnShipout.Text = "Shipout RTV";
            this.mesBtnShipout.UseVisualStyleBackColor = false;
            this.mesBtnShipout.Click += new System.EventHandler(this.mesBtnShipout_Click);
            this.mesBtnShipout.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnShipout_MouseDown);
            // 
            // mesBtnRtvPackingSlip
            // 
            this.mesBtnRtvPackingSlip.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnRtvPackingSlip.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnRtvPackingSlip.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnRtvPackingSlip.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnRtvPackingSlip.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnRtvPackingSlip.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesBtnRtvPackingSlip.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnRtvPackingSlip.Location = new System.Drawing.Point(621, 333);
            this.mesBtnRtvPackingSlip.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnRtvPackingSlip.Name = "mesBtnRtvPackingSlip";
            this.mesBtnRtvPackingSlip.Size = new System.Drawing.Size(200, 38);
            this.mesBtnRtvPackingSlip.TabIndex = 2;
            this.mesBtnRtvPackingSlip.Text = "Print Packing Slip";
            this.mesBtnRtvPackingSlip.UseVisualStyleBackColor = false;
            this.mesBtnRtvPackingSlip.Click += new System.EventHandler(this.mesBtnRtvPackingSlip_Click);
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(1291, 11);
            this.linkLblClose.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(63, 25);
            this.linkLblClose.TabIndex = 4;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // ShipoutExistingRtvOnly
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1384, 716);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "ShipoutExistingRtvOnly";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "ShipoutExistingRtvOnly";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRtvShipper;
        private Fx.WinForms.Flat.MESTextEdit mesTbxHonLoc;
        private Fx.WinForms.Flat.MESButton mesBtnShipout;
        private Fx.WinForms.Flat.MESButton mesBtnRtvPackingSlip;
        private System.Windows.Forms.Label label4;
        private Fx.WinForms.Flat.MESButton mesBtnRtvLabels;
        private System.Windows.Forms.Panel panel2;
    }
}