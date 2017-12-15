namespace ImportLogisticsVarianceData
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.pnlLogin = new System.Windows.Forms.Panel();
            this.lblErrorMessage = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.mesBtnLogin = new Fx.WinForms.Flat.MESButton();
            this.mesTbxPassword = new Fx.WinForms.Flat.MESTextEdit();
            this.label2 = new System.Windows.Forms.Label();
            this.mesTbxOperatorCode = new Fx.WinForms.Flat.MESTextEdit();
            this.label1 = new System.Windows.Forms.Label();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.mesBtnImportChRobinson = new Fx.WinForms.Flat.MESButton();
            this.mesBtnFedExImport = new Fx.WinForms.Flat.MESButton();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.mesBtnPfSolutions = new Fx.WinForms.Flat.MESButton();
            this.panel1.SuspendLayout();
            this.pnlLogin.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.Black;
            this.panel1.Controls.Add(this.pnlLogin);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.flowLayoutPanel1);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Location = new System.Drawing.Point(3, 28);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1328, 686);
            this.panel1.TabIndex = 0;
            // 
            // pnlLogin
            // 
            this.pnlLogin.Controls.Add(this.lblErrorMessage);
            this.pnlLogin.Controls.Add(this.label3);
            this.pnlLogin.Controls.Add(this.mesBtnLogin);
            this.pnlLogin.Controls.Add(this.mesTbxPassword);
            this.pnlLogin.Controls.Add(this.label2);
            this.pnlLogin.Controls.Add(this.mesTbxOperatorCode);
            this.pnlLogin.Location = new System.Drawing.Point(429, 17);
            this.pnlLogin.Margin = new System.Windows.Forms.Padding(4);
            this.pnlLogin.Name = "pnlLogin";
            this.pnlLogin.Size = new System.Drawing.Size(743, 108);
            this.pnlLogin.TabIndex = 61;
            // 
            // lblErrorMessage
            // 
            this.lblErrorMessage.AutoSize = true;
            this.lblErrorMessage.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblErrorMessage.ForeColor = System.Drawing.Color.Red;
            this.lblErrorMessage.Location = new System.Drawing.Point(24, 75);
            this.lblErrorMessage.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblErrorMessage.Name = "lblErrorMessage";
            this.lblErrorMessage.Size = new System.Drawing.Size(191, 24);
            this.lblErrorMessage.TabIndex = 63;
            this.lblErrorMessage.Text = "Invalid operator code.";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(189, 9);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(88, 20);
            this.label3.TabIndex = 62;
            this.label3.Text = "Password:";
            // 
            // mesBtnLogin
            // 
            this.mesBtnLogin.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnLogin.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnLogin.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnLogin.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnLogin.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnLogin.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnLogin.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnLogin.Location = new System.Drawing.Point(357, 26);
            this.mesBtnLogin.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnLogin.Name = "mesBtnLogin";
            this.mesBtnLogin.Size = new System.Drawing.Size(116, 43);
            this.mesBtnLogin.TabIndex = 2;
            this.mesBtnLogin.Text = "Log In";
            this.mesBtnLogin.UseVisualStyleBackColor = false;
            this.mesBtnLogin.Click += new System.EventHandler(this.mesBtnLogin_Click);
            // 
            // mesTbxPassword
            // 
            this.mesTbxPassword.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxPassword.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxPassword.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxPassword.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxPassword.Location = new System.Drawing.Point(193, 32);
            this.mesTbxPassword.Margin = new System.Windows.Forms.Padding(4);
            this.mesTbxPassword.Name = "mesTbxPassword";
            this.mesTbxPassword.PasswordChar = '*';
            this.mesTbxPassword.Size = new System.Drawing.Size(133, 32);
            this.mesTbxPassword.TabIndex = 1;
            this.mesTbxPassword.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.mesTbxPassword_KeyPress);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(24, 9);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(124, 20);
            this.label2.TabIndex = 60;
            this.label2.Text = "Operator Code:";
            // 
            // mesTbxOperatorCode
            // 
            this.mesTbxOperatorCode.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxOperatorCode.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxOperatorCode.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTbxOperatorCode.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxOperatorCode.Location = new System.Drawing.Point(28, 32);
            this.mesTbxOperatorCode.Margin = new System.Windows.Forms.Padding(4);
            this.mesTbxOperatorCode.Name = "mesTbxOperatorCode";
            this.mesTbxOperatorCode.Size = new System.Drawing.Size(133, 32);
            this.mesTbxOperatorCode.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(524, 305);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(319, 31);
            this.label1.TabIndex = 56;
            this.label1.Text = "Logistics Variance Import";
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Constantia", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.RoyalBlue;
            this.linkLblClose.Location = new System.Drawing.Point(1225, 16);
            this.linkLblClose.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(80, 33);
            this.linkLblClose.TabIndex = 4;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // mesBtnImportChRobinson
            // 
            this.mesBtnImportChRobinson.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnImportChRobinson.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnImportChRobinson.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnImportChRobinson.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnImportChRobinson.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnImportChRobinson.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnImportChRobinson.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnImportChRobinson.Location = new System.Drawing.Point(4, 63);
            this.mesBtnImportChRobinson.Margin = new System.Windows.Forms.Padding(4, 4, 4, 12);
            this.mesBtnImportChRobinson.Name = "mesBtnImportChRobinson";
            this.mesBtnImportChRobinson.Size = new System.Drawing.Size(239, 43);
            this.mesBtnImportChRobinson.TabIndex = 4;
            this.mesBtnImportChRobinson.Text = "Import CHR";
            this.mesBtnImportChRobinson.UseVisualStyleBackColor = false;
            this.mesBtnImportChRobinson.Click += new System.EventHandler(this.mesBtnImportChRobinson_Click);
            // 
            // mesBtnFedExImport
            // 
            this.mesBtnFedExImport.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnFedExImport.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnFedExImport.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnFedExImport.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnFedExImport.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnFedExImport.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnFedExImport.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnFedExImport.Location = new System.Drawing.Point(4, 4);
            this.mesBtnFedExImport.Margin = new System.Windows.Forms.Padding(4, 4, 4, 12);
            this.mesBtnFedExImport.Name = "mesBtnFedExImport";
            this.mesBtnFedExImport.Size = new System.Drawing.Size(239, 43);
            this.mesBtnFedExImport.TabIndex = 3;
            this.mesBtnFedExImport.Text = "Import FedEx";
            this.mesBtnFedExImport.UseVisualStyleBackColor = false;
            this.mesBtnFedExImport.Click += new System.EventHandler(this.mesBtnFedExImport_Click);
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.mesBtnFedExImport);
            this.flowLayoutPanel1.Controls.Add(this.mesBtnImportChRobinson);
            this.flowLayoutPanel1.Controls.Add(this.mesBtnPfSolutions);
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(28, 33);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(4);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(267, 620);
            this.flowLayoutPanel1.TabIndex = 55;
            // 
            // mesBtnPfSolutions
            // 
            this.mesBtnPfSolutions.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnPfSolutions.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnPfSolutions.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnPfSolutions.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnPfSolutions.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnPfSolutions.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnPfSolutions.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnPfSolutions.Location = new System.Drawing.Point(4, 122);
            this.mesBtnPfSolutions.Margin = new System.Windows.Forms.Padding(4, 4, 4, 12);
            this.mesBtnPfSolutions.Name = "mesBtnPfSolutions";
            this.mesBtnPfSolutions.Size = new System.Drawing.Size(239, 43);
            this.mesBtnPfSolutions.TabIndex = 5;
            this.mesBtnPfSolutions.Text = "Import PFS";
            this.mesBtnPfSolutions.UseVisualStyleBackColor = false;
            this.mesBtnPfSolutions.Click += new System.EventHandler(this.mesBtnPfSolutions_Click);
            // 
            // formMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.DimGray;
            this.ClientSize = new System.Drawing.Size(1333, 716);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.White;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "formMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            this.Activated += new System.EventHandler(this.formMain_Activated);
            this.Load += new System.EventHandler(this.formMain_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.pnlLogin.ResumeLayout(false);
            this.pnlLogin.PerformLayout();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.Panel pnlLogin;
        private System.Windows.Forms.Label label3;
        private Fx.WinForms.Flat.MESButton mesBtnLogin;
        private Fx.WinForms.Flat.MESTextEdit mesTbxPassword;
        private System.Windows.Forms.Label label2;
        private Fx.WinForms.Flat.MESTextEdit mesTbxOperatorCode;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblErrorMessage;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private Fx.WinForms.Flat.MESButton mesBtnFedExImport;
        private Fx.WinForms.Flat.MESButton mesBtnImportChRobinson;
        private Fx.WinForms.Flat.MESButton mesBtnPfSolutions;
    }
}

