namespace RmaMaintenance.Views
{
    partial class CreateOptions
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
            this.rbtnCreateRmaOnlyHold = new System.Windows.Forms.RadioButton();
            this.rbtnCreateRmaOnly = new System.Windows.Forms.RadioButton();
            this.rbtnCreateRtvOnly = new System.Windows.Forms.RadioButton();
            this.rbtnCreateRmaRtv = new System.Windows.Forms.RadioButton();
            this.label7 = new System.Windows.Forms.Label();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
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
            this.mesBtnGo.Location = new System.Drawing.Point(670, 425);
            this.mesBtnGo.Name = "mesBtnGo";
            this.mesBtnGo.Size = new System.Drawing.Size(83, 35);
            this.mesBtnGo.TabIndex = 22;
            this.mesBtnGo.Text = "GO";
            this.mesBtnGo.UseVisualStyleBackColor = false;
            this.mesBtnGo.Click += new System.EventHandler(this.mesBtnGo_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbtnCreateRmaOnlyHold);
            this.groupBox1.Controls.Add(this.rbtnCreateRmaOnly);
            this.groupBox1.Controls.Add(this.rbtnCreateRtvOnly);
            this.groupBox1.Controls.Add(this.rbtnCreateRmaRtv);
            this.groupBox1.ForeColor = System.Drawing.Color.White;
            this.groupBox1.Location = new System.Drawing.Point(351, 163);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(402, 245);
            this.groupBox1.TabIndex = 21;
            this.groupBox1.TabStop = false;
            // 
            // rbtnCreateRmaOnlyHold
            // 
            this.rbtnCreateRmaOnlyHold.AutoSize = true;
            this.rbtnCreateRmaOnlyHold.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCreateRmaOnlyHold.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCreateRmaOnlyHold.Location = new System.Drawing.Point(37, 133);
            this.rbtnCreateRmaOnlyHold.Name = "rbtnCreateRmaOnlyHold";
            this.rbtnCreateRmaOnlyHold.Size = new System.Drawing.Size(312, 22);
            this.rbtnCreateRmaOnlyHold.TabIndex = 3;
            this.rbtnCreateRmaOnlyHold.TabStop = true;
            this.rbtnCreateRmaOnlyHold.Text = "Create RMA only, and place serials on hold.";
            this.rbtnCreateRmaOnlyHold.UseVisualStyleBackColor = true;
            // 
            // rbtnCreateRmaOnly
            // 
            this.rbtnCreateRmaOnly.AutoSize = true;
            this.rbtnCreateRmaOnly.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCreateRmaOnly.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCreateRmaOnly.Location = new System.Drawing.Point(37, 89);
            this.rbtnCreateRmaOnly.Name = "rbtnCreateRmaOnly";
            this.rbtnCreateRmaOnly.Size = new System.Drawing.Size(141, 22);
            this.rbtnCreateRmaOnly.TabIndex = 2;
            this.rbtnCreateRmaOnly.TabStop = true;
            this.rbtnCreateRmaOnly.Text = "Create RMA only.";
            this.rbtnCreateRmaOnly.UseVisualStyleBackColor = true;
            // 
            // rbtnCreateRtvOnly
            // 
            this.rbtnCreateRtvOnly.AutoSize = true;
            this.rbtnCreateRtvOnly.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCreateRtvOnly.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCreateRtvOnly.Location = new System.Drawing.Point(37, 177);
            this.rbtnCreateRtvOnly.Name = "rbtnCreateRtvOnly";
            this.rbtnCreateRtvOnly.Size = new System.Drawing.Size(137, 22);
            this.rbtnCreateRtvOnly.TabIndex = 1;
            this.rbtnCreateRtvOnly.TabStop = true;
            this.rbtnCreateRtvOnly.Text = "Create RTV only.";
            this.rbtnCreateRtvOnly.UseVisualStyleBackColor = true;
            // 
            // rbtnCreateRmaRtv
            // 
            this.rbtnCreateRmaRtv.AutoSize = true;
            this.rbtnCreateRmaRtv.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCreateRmaRtv.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCreateRmaRtv.Location = new System.Drawing.Point(37, 46);
            this.rbtnCreateRmaRtv.Name = "rbtnCreateRmaRtv";
            this.rbtnCreateRmaRtv.Size = new System.Drawing.Size(204, 22);
            this.rbtnCreateRmaRtv.TabIndex = 0;
            this.rbtnCreateRmaRtv.TabStop = true;
            this.rbtnCreateRmaRtv.Text = "Create both RMA and RTV.";
            this.rbtnCreateRmaRtv.UseVisualStyleBackColor = true;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label7.Location = new System.Drawing.Point(348, 138);
            this.label7.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(236, 20);
            this.label7.TabIndex = 20;
            this.label7.Text = "Choose an action for the serials:";
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
            this.linkLblClose.TabIndex = 18;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // CreateOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "CreateOptions";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "CreateOptions";
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
        private System.Windows.Forms.RadioButton rbtnCreateRmaOnly;
        private System.Windows.Forms.RadioButton rbtnCreateRtvOnly;
        private System.Windows.Forms.RadioButton rbtnCreateRmaRtv;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.RadioButton rbtnCreateRmaOnlyHold;
    }
}