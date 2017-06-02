namespace RmaMaintenance.Views
{
    partial class RmaRtvHistoryOptions
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
            this.mesBtnGo = new Fx.WinForms.Flat.MESButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbtnLookupByDates = new System.Windows.Forms.RadioButton();
            this.rbtnLookupByNumber = new System.Windows.Forms.RadioButton();
            this.label7 = new System.Windows.Forms.Label();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.rbtnLookupByShipper = new System.Windows.Forms.RadioButton();
            this.panel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.mesBtnGo);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Controls.Add(this.label7);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // mesBtnGo
            // 
            this.mesBtnGo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnGo.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnGo.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnGo.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnGo.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnGo.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnGo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnGo.Location = new System.Drawing.Point(637, 399);
            this.mesBtnGo.Name = "mesBtnGo";
            this.mesBtnGo.Size = new System.Drawing.Size(83, 35);
            this.mesBtnGo.TabIndex = 3;
            this.mesBtnGo.Text = "GO";
            this.mesBtnGo.UseVisualStyleBackColor = false;
            this.mesBtnGo.Click += new System.EventHandler(this.mesBtnGo_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbtnLookupByShipper);
            this.groupBox1.Controls.Add(this.rbtnLookupByDates);
            this.groupBox1.Controls.Add(this.rbtnLookupByNumber);
            this.groupBox1.ForeColor = System.Drawing.Color.White;
            this.groupBox1.Location = new System.Drawing.Point(332, 185);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(388, 199);
            this.groupBox1.TabIndex = 24;
            this.groupBox1.TabStop = false;
            // 
            // rbtnLookupByDates
            // 
            this.rbtnLookupByDates.AutoSize = true;
            this.rbtnLookupByDates.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnLookupByDates.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnLookupByDates.Location = new System.Drawing.Point(37, 89);
            this.rbtnLookupByDates.Name = "rbtnLookupByDates";
            this.rbtnLookupByDates.Size = new System.Drawing.Size(175, 22);
            this.rbtnLookupByDates.TabIndex = 1;
            this.rbtnLookupByDates.TabStop = true;
            this.rbtnLookupByDates.Text = "Look up by date range.";
            this.rbtnLookupByDates.UseVisualStyleBackColor = true;
            // 
            // rbtnLookupByNumber
            // 
            this.rbtnLookupByNumber.AutoSize = true;
            this.rbtnLookupByNumber.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnLookupByNumber.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnLookupByNumber.Location = new System.Drawing.Point(37, 135);
            this.rbtnLookupByNumber.Name = "rbtnLookupByNumber";
            this.rbtnLookupByNumber.Size = new System.Drawing.Size(234, 22);
            this.rbtnLookupByNumber.TabIndex = 2;
            this.rbtnLookupByNumber.TabStop = true;
            this.rbtnLookupByNumber.Text = "Look up by RMA / RTV number.";
            this.rbtnLookupByNumber.UseVisualStyleBackColor = true;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label7.Location = new System.Drawing.Point(329, 160);
            this.label7.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(240, 20);
            this.label7.TabIndex = 23;
            this.label7.Text = "Choose a history lookup method:";
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
            this.linkLblClose.TabIndex = 4;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // rbtnLookupByShipper
            // 
            this.rbtnLookupByShipper.AutoSize = true;
            this.rbtnLookupByShipper.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnLookupByShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnLookupByShipper.Location = new System.Drawing.Point(37, 44);
            this.rbtnLookupByShipper.Name = "rbtnLookupByShipper";
            this.rbtnLookupByShipper.Size = new System.Drawing.Size(154, 22);
            this.rbtnLookupByShipper.TabIndex = 0;
            this.rbtnLookupByShipper.TabStop = true;
            this.rbtnLookupByShipper.Text = "Look up by shipper.";
            this.rbtnLookupByShipper.UseVisualStyleBackColor = true;
            // 
            // RmaRtvHistoryOptions
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "RmaRtvHistoryOptions";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "RmaRtvHistoryOptions";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private Fx.WinForms.Flat.MESButton mesBtnGo;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbtnLookupByDates;
        private System.Windows.Forms.RadioButton rbtnLookupByNumber;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.RadioButton rbtnLookupByShipper;
    }
}