namespace RmaMaintenance.Views
{
    partial class SerialEntryOptions
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
            this.rbtnTypeSerials = new System.Windows.Forms.RadioButton();
            this.rbtnCopyParts = new System.Windows.Forms.RadioButton();
            this.rbtnCopySerials = new System.Windows.Forms.RadioButton();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.label7 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.mesBtnGo);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Controls.Add(this.label7);
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
            this.mesBtnGo.Location = new System.Drawing.Point(738, 394);
            this.mesBtnGo.Name = "mesBtnGo";
            this.mesBtnGo.Size = new System.Drawing.Size(83, 35);
            this.mesBtnGo.TabIndex = 19;
            this.mesBtnGo.Text = "GO";
            this.mesBtnGo.UseVisualStyleBackColor = false;
            this.mesBtnGo.Click += new System.EventHandler(this.mesBtnGo_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbtnTypeSerials);
            this.groupBox1.Controls.Add(this.rbtnCopyParts);
            this.groupBox1.Controls.Add(this.rbtnCopySerials);
            this.groupBox1.ForeColor = System.Drawing.Color.White;
            this.groupBox1.Location = new System.Drawing.Point(248, 180);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(573, 199);
            this.groupBox1.TabIndex = 18;
            this.groupBox1.TabStop = false;
            // 
            // rbtnTypeSerials
            // 
            this.rbtnTypeSerials.AutoSize = true;
            this.rbtnTypeSerials.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnTypeSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnTypeSerials.Location = new System.Drawing.Point(37, 139);
            this.rbtnTypeSerials.Name = "rbtnTypeSerials";
            this.rbtnTypeSerials.Size = new System.Drawing.Size(177, 22);
            this.rbtnTypeSerials.TabIndex = 2;
            this.rbtnTypeSerials.TabStop = true;
            this.rbtnTypeSerials.Text = "Type in serial numbers.";
            this.rbtnTypeSerials.UseVisualStyleBackColor = true;
            // 
            // rbtnCopyParts
            // 
            this.rbtnCopyParts.AutoSize = true;
            this.rbtnCopyParts.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCopyParts.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCopyParts.Location = new System.Drawing.Point(37, 92);
            this.rbtnCopyParts.Name = "rbtnCopyParts";
            this.rbtnCopyParts.Size = new System.Drawing.Size(507, 22);
            this.rbtnCopyParts.TabIndex = 1;
            this.rbtnCopyParts.TabStop = true;
            this.rbtnCopyParts.Text = "Copy part numbers from a spreadsheet and let the system pull the serials.";
            this.rbtnCopyParts.UseVisualStyleBackColor = true;
            // 
            // rbtnCopySerials
            // 
            this.rbtnCopySerials.AutoSize = true;
            this.rbtnCopySerials.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rbtnCopySerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCopySerials.Location = new System.Drawing.Point(37, 45);
            this.rbtnCopySerials.Name = "rbtnCopySerials";
            this.rbtnCopySerials.Size = new System.Drawing.Size(297, 22);
            this.rbtnCopySerials.TabIndex = 0;
            this.rbtnCopySerials.TabStop = true;
            this.rbtnCopySerials.Text = "Copy serial numbers from a spreadsheet.";
            this.rbtnCopySerials.UseVisualStyleBackColor = true;
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(963, 9);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(58, 20);
            this.linkLblClose.TabIndex = 17;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label7.Location = new System.Drawing.Point(245, 149);
            this.label7.Margin = new System.Windows.Forms.Padding(3, 2, 3, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(321, 20);
            this.label7.TabIndex = 16;
            this.label7.Text = "Select a method for entering serial numbers:";
            // 
            // SerialEntryOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "SerialEntryOptions";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "SerialOptions";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label7;
        private Fx.WinForms.Flat.MESButton mesBtnGo;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbtnTypeSerials;
        private System.Windows.Forms.RadioButton rbtnCopyParts;
        private System.Windows.Forms.RadioButton rbtnCopySerials;
        private System.Windows.Forms.LinkLabel linkLblClose;
    }
}