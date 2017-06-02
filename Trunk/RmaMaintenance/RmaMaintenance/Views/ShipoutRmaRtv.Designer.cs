namespace RmaMaintenance.Views
{
    partial class ShipoutRmaRtv
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
            this.linkLblCloseAll = new System.Windows.Forms.LinkLabel();
            this.label4 = new System.Windows.Forms.Label();
            this.dgvNewShippers = new System.Windows.Forms.DataGridView();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxRtvShipper = new Fx.WinForms.Flat.MESTextEdit();
            this.mesTbxHonLoc = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnShipout = new Fx.WinForms.Flat.MESButton();
            this.mesBtnRtvPackingSlip = new Fx.WinForms.Flat.MESButton();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.label1 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.linkLblCloseAll);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Controls.Add(this.dgvNewShippers);
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Controls.Add(this.mesTbxRtvShipper);
            this.panel1.Controls.Add(this.mesTbxHonLoc);
            this.panel1.Controls.Add(this.mesBtnShipout);
            this.panel1.Controls.Add(this.mesBtnRtvPackingSlip);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // linkLblCloseAll
            // 
            this.linkLblCloseAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblCloseAll.AutoSize = true;
            this.linkLblCloseAll.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblCloseAll.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblCloseAll.Location = new System.Drawing.Point(977, 9);
            this.linkLblCloseAll.Name = "linkLblCloseAll";
            this.linkLblCloseAll.Size = new System.Drawing.Size(49, 20);
            this.linkLblCloseAll.TabIndex = 6;
            this.linkLblCloseAll.TabStop = true;
            this.linkLblCloseAll.Text = "Close";
            this.linkLblCloseAll.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblCloseAll_LinkClicked);
            this.linkLblCloseAll.MouseEnter += new System.EventHandler(this.linkLblCloseAll_MouseEnter);
            this.linkLblCloseAll.MouseLeave += new System.EventHandler(this.linkLblCloseAll_MouseLeave);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label4.Location = new System.Drawing.Point(370, 75);
            this.label4.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(109, 18);
            this.label4.TabIndex = 86;
            this.label4.Text = "Highlight a row:";
            // 
            // dgvNewShippers
            // 
            this.dgvNewShippers.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.dgvNewShippers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.Black;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvNewShippers.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvNewShippers.Location = new System.Drawing.Point(373, 98);
            this.dgvNewShippers.MultiSelect = false;
            this.dgvNewShippers.Name = "dgvNewShippers";
            this.dgvNewShippers.ReadOnly = true;
            this.dgvNewShippers.RowHeadersVisible = false;
            this.dgvNewShippers.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvNewShippers.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvNewShippers.Size = new System.Drawing.Size(301, 211);
            this.dgvNewShippers.TabIndex = 0;
            this.dgvNewShippers.SelectionChanged += new System.EventHandler(this.dgvNewShippers_SelectionChanged);
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(390, 364);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(128, 16);
            this.label3.TabIndex = 74;
            this.label3.Text = "Honduras RMA Loc:";
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(429, 327);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 16);
            this.label2.TabIndex = 77;
            this.label2.Text = "RTV Shipper:";
            // 
            // mesTbxRtvShipper
            // 
            this.mesTbxRtvShipper.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRtvShipper.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRtvShipper.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxRtvShipper.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRtvShipper.Location = new System.Drawing.Point(524, 329);
            this.mesTbxRtvShipper.Name = "mesTbxRtvShipper";
            this.mesTbxRtvShipper.Size = new System.Drawing.Size(150, 27);
            this.mesTbxRtvShipper.TabIndex = 1;
            // 
            // mesTbxHonLoc
            // 
            this.mesTbxHonLoc.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxHonLoc.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxHonLoc.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxHonLoc.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxHonLoc.Location = new System.Drawing.Point(524, 366);
            this.mesTbxHonLoc.MaxLength = 20;
            this.mesTbxHonLoc.Name = "mesTbxHonLoc";
            this.mesTbxHonLoc.Size = new System.Drawing.Size(150, 27);
            this.mesTbxHonLoc.TabIndex = 2;
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
            this.mesBtnShipout.Location = new System.Drawing.Point(524, 461);
            this.mesBtnShipout.Name = "mesBtnShipout";
            this.mesBtnShipout.Size = new System.Drawing.Size(150, 35);
            this.mesBtnShipout.TabIndex = 4;
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
            this.mesBtnRtvPackingSlip.Location = new System.Drawing.Point(524, 410);
            this.mesBtnRtvPackingSlip.Name = "mesBtnRtvPackingSlip";
            this.mesBtnRtvPackingSlip.Size = new System.Drawing.Size(150, 31);
            this.mesBtnRtvPackingSlip.TabIndex = 3;
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
            this.linkLblClose.Location = new System.Drawing.Point(913, 9);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(58, 20);
            this.linkLblClose.TabIndex = 5;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(679, 416);
            this.label1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(218, 16);
            this.label1.TabIndex = 87;
            this.label1.Text = "* Make sure labels are printed also.";
            // 
            // ShipoutRmaRtv
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "ShipoutRmaRtv";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "ShipoutRmaRtv";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvNewShippers)).EndInit();
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
        private System.Windows.Forms.DataGridView dgvNewShippers;
        private System.Windows.Forms.LinkLabel linkLblCloseAll;
        private System.Windows.Forms.Label label1;
    }
}