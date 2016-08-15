namespace RmaMaintenance
{
    partial class formMain
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
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.mesBtnNewRma = new Fx.WinForms.Flat.MESButton();
            this.mesBtnAssignPo = new Fx.WinForms.Flat.MESButton();
            this.mesBtnEditRma = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.lblPassword = new System.Windows.Forms.Label();
            this.mesTbxPassword = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnLogon = new Fx.WinForms.Flat.MESButton();
            this.lblLogonError = new System.Windows.Forms.Label();
            this.lblScanInstructions = new System.Windows.Forms.Label();
            this.tableLayoutPanel1.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.BackColor = System.Drawing.Color.Black;
            this.tableLayoutPanel1.ColumnCount = 3;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 180F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 70F));
            this.tableLayoutPanel1.Controls.Add(this.linkLblClose, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.flowLayoutPanel1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 24);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.Padding = new System.Windows.Forms.Padding(20, 0, 20, 20);
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(1038, 558);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.Location = new System.Drawing.Point(951, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(63, 20);
            this.linkLblClose.TabIndex = 0;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "CLOSE";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.mesBtnNewRma);
            this.flowLayoutPanel1.Controls.Add(this.mesBtnAssignPo);
            this.flowLayoutPanel1.Controls.Add(this.mesBtnEditRma);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(23, 3);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(174, 532);
            this.flowLayoutPanel1.TabIndex = 1;
            // 
            // mesBtnNewRma
            // 
            this.mesBtnNewRma.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnNewRma.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnNewRma.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnNewRma.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnNewRma.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnNewRma.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesBtnNewRma.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnNewRma.Location = new System.Drawing.Point(3, 3);
            this.mesBtnNewRma.Margin = new System.Windows.Forms.Padding(3, 3, 3, 9);
            this.mesBtnNewRma.Name = "mesBtnNewRma";
            this.mesBtnNewRma.Size = new System.Drawing.Size(158, 35);
            this.mesBtnNewRma.TabIndex = 0;
            this.mesBtnNewRma.Text = "RMA / RTV";
            this.mesBtnNewRma.UseVisualStyleBackColor = false;
            this.mesBtnNewRma.Click += new System.EventHandler(this.mesBtnNewRma_Click);
            // 
            // mesBtnAssignPo
            // 
            this.mesBtnAssignPo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnAssignPo.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnAssignPo.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnAssignPo.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnAssignPo.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnAssignPo.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnAssignPo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnAssignPo.Location = new System.Drawing.Point(3, 50);
            this.mesBtnAssignPo.Margin = new System.Windows.Forms.Padding(3, 3, 3, 9);
            this.mesBtnAssignPo.Name = "mesBtnAssignPo";
            this.mesBtnAssignPo.Size = new System.Drawing.Size(158, 35);
            this.mesBtnAssignPo.TabIndex = 2;
            this.mesBtnAssignPo.Text = "Assign PO";
            this.mesBtnAssignPo.UseVisualStyleBackColor = false;
            this.mesBtnAssignPo.Click += new System.EventHandler(this.mesBtnAssignPo_Click);
            // 
            // mesBtnEditRma
            // 
            this.mesBtnEditRma.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnEditRma.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnEditRma.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnEditRma.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnEditRma.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnEditRma.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnEditRma.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnEditRma.Location = new System.Drawing.Point(3, 97);
            this.mesBtnEditRma.Margin = new System.Windows.Forms.Padding(3, 3, 3, 6);
            this.mesBtnEditRma.Name = "mesBtnEditRma";
            this.mesBtnEditRma.Size = new System.Drawing.Size(158, 35);
            this.mesBtnEditRma.TabIndex = 1;
            this.mesBtnEditRma.Text = "Edit";
            this.mesBtnEditRma.UseVisualStyleBackColor = false;
            this.mesBtnEditRma.Click += new System.EventHandler(this.mesBtnEditRma_Click);
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 90F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.Controls.Add(this.label1, 1, 1);
            this.tableLayoutPanel2.Controls.Add(this.tableLayoutPanel3, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.lblScanInstructions, 1, 2);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(203, 3);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 3;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 200F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 60F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(742, 532);
            this.tableLayoutPanel2.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Century Gothic", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(93, 200);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(462, 58);
            this.label1.TabIndex = 0;
            this.label1.Text = "RMA Maintenance";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 4;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 80F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 120F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 130F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel3.Controls.Add(this.lblPassword, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.mesTbxPassword, 1, 0);
            this.tableLayoutPanel3.Controls.Add(this.mesBtnLogon, 2, 0);
            this.tableLayoutPanel3.Controls.Add(this.lblLogonError, 3, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(93, 3);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(656, 194);
            this.tableLayoutPanel3.TabIndex = 1;
            // 
            // lblPassword
            // 
            this.lblPassword.AutoSize = true;
            this.lblPassword.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPassword.ForeColor = System.Drawing.Color.White;
            this.lblPassword.Location = new System.Drawing.Point(3, 0);
            this.lblPassword.Name = "lblPassword";
            this.lblPassword.Size = new System.Drawing.Size(68, 16);
            this.lblPassword.TabIndex = 0;
            this.lblPassword.Text = "Password:";
            // 
            // mesTbxPassword
            // 
            this.mesTbxPassword.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxPassword.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxPassword.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxPassword.Location = new System.Drawing.Point(83, 3);
            this.mesTbxPassword.MaxLength = 10;
            this.mesTbxPassword.Name = "mesTbxPassword";
            this.mesTbxPassword.PasswordChar = '*';
            this.mesTbxPassword.Size = new System.Drawing.Size(100, 27);
            this.mesTbxPassword.TabIndex = 1;
            // 
            // mesBtnLogon
            // 
            this.mesBtnLogon.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnLogon.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnLogon.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnLogon.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnLogon.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnLogon.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnLogon.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnLogon.Location = new System.Drawing.Point(203, 3);
            this.mesBtnLogon.Name = "mesBtnLogon";
            this.mesBtnLogon.Size = new System.Drawing.Size(110, 35);
            this.mesBtnLogon.TabIndex = 2;
            this.mesBtnLogon.Text = "Log On";
            this.mesBtnLogon.UseVisualStyleBackColor = false;
            this.mesBtnLogon.Click += new System.EventHandler(this.mesBtnLogon_Click);
            // 
            // lblLogonError
            // 
            this.lblLogonError.AutoSize = true;
            this.lblLogonError.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblLogonError.ForeColor = System.Drawing.Color.Red;
            this.lblLogonError.Location = new System.Drawing.Point(333, 0);
            this.lblLogonError.Name = "lblLogonError";
            this.lblLogonError.Size = new System.Drawing.Size(92, 16);
            this.lblLogonError.TabIndex = 3;
            this.lblLogonError.Text = "Error message";
            // 
            // lblScanInstructions
            // 
            this.lblScanInstructions.AutoSize = true;
            this.lblScanInstructions.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblScanInstructions.ForeColor = System.Drawing.Color.White;
            this.lblScanInstructions.Location = new System.Drawing.Point(93, 260);
            this.lblScanInstructions.Name = "lblScanInstructions";
            this.lblScanInstructions.Padding = new System.Windows.Forms.Padding(10, 0, 0, 0);
            this.lblScanInstructions.Size = new System.Drawing.Size(190, 18);
            this.lblScanInstructions.TabIndex = 2;
            this.lblScanInstructions.Text = "Scan your badge to begin.";
            // 
            // formMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(15)))), ((int)(((byte)(15)))), ((int)(((byte)(15)))));
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.tableLayoutPanel1);
            this.ForeColor = System.Drawing.SystemColors.ControlText;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MinimumSize = new System.Drawing.Size(1038, 582);
            this.Name = "formMain";
            this.Padding = new System.Windows.Forms.Padding(0, 24, 0, 0);
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Activated += new System.EventHandler(this.formMain_Activated);
            this.Load += new System.EventHandler(this.formMain_Load);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.Label lblPassword;
        private Fx.WinForms.Flat.MESButton mesBtnNewRma;
        private Fx.WinForms.Flat.MESTextEdit mesTbxPassword;
        private Fx.WinForms.Flat.MESButton mesBtnLogon;
        private System.Windows.Forms.Label lblLogonError;
        private System.Windows.Forms.Label lblScanInstructions;
        private Fx.WinForms.Flat.MESButton mesBtnEditRma;
        private Fx.WinForms.Flat.MESButton mesBtnAssignPo;
    }
}

