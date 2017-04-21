namespace ImportCSM
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
            this.btnImport = new System.Windows.Forms.Button();
            this.btnExit = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.lblPriorReleaseId = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.tbxPriorReleaseId = new System.Windows.Forms.TextBox();
            this.tbxCurrentReleaseId = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tpCsm = new System.Windows.Forms.TabPage();
            this.lblStep3 = new System.Windows.Forms.Label();
            this.lblStep1 = new System.Windows.Forms.Label();
            this.pnlImport = new System.Windows.Forms.Panel();
            this.lblStep2 = new System.Windows.Forms.Label();
            this.lblStep4 = new System.Windows.Forms.Label();
            this.tpCsmDelta = new System.Windows.Forms.TabPage();
            this.lblDeltaImportComplete = new System.Windows.Forms.Label();
            this.pnlDeltaImport = new System.Windows.Forms.Panel();
            this.btnDeltaImport = new System.Windows.Forms.Button();
            this.label8 = new System.Windows.Forms.Label();
            this.tbxCurrentDeltaReleaseId = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tpCsm.SuspendLayout();
            this.pnlImport.SuspendLayout();
            this.tpCsmDelta.SuspendLayout();
            this.pnlDeltaImport.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnImport
            // 
            this.btnImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnImport.Location = new System.Drawing.Point(180, 98);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(114, 41);
            this.btnImport.TabIndex = 2;
            this.btnImport.Text = "Import";
            this.btnImport.UseVisualStyleBackColor = true;
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            // 
            // btnExit
            // 
            this.btnExit.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnExit.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnExit.Location = new System.Drawing.Point(537, 31);
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(114, 41);
            this.btnExit.TabIndex = 3;
            this.btnExit.Text = "Close";
            this.btnExit.UseVisualStyleBackColor = true;
            this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(33, 31);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(224, 29);
            this.label1.TabIndex = 2;
            this.label1.Text = "Empire CSM Import";
            // 
            // lblPriorReleaseId
            // 
            this.lblPriorReleaseId.AutoSize = true;
            this.lblPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPriorReleaseId.ForeColor = System.Drawing.Color.White;
            this.lblPriorReleaseId.Location = new System.Drawing.Point(54, 24);
            this.lblPriorReleaseId.Name = "lblPriorReleaseId";
            this.lblPriorReleaseId.Size = new System.Drawing.Size(120, 18);
            this.lblPriorReleaseId.TabIndex = 4;
            this.lblPriorReleaseId.Text = "Prior Release ID:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(37, 57);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(137, 18);
            this.label3.TabIndex = 5;
            this.label3.Text = "Current Release ID:";
            // 
            // tbxPriorReleaseId
            // 
            this.tbxPriorReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxPriorReleaseId.Location = new System.Drawing.Point(180, 21);
            this.tbxPriorReleaseId.Name = "tbxPriorReleaseId";
            this.tbxPriorReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxPriorReleaseId.TabIndex = 0;
            // 
            // tbxCurrentReleaseId
            // 
            this.tbxCurrentReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentReleaseId.Location = new System.Drawing.Point(180, 54);
            this.tbxCurrentReleaseId.Name = "tbxCurrentReleaseId";
            this.tbxCurrentReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxCurrentReleaseId.TabIndex = 1;
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.tabControl1);
            this.panel1.Controls.Add(this.btnExit);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(693, 550);
            this.panel1.TabIndex = 11;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tpCsm);
            this.tabControl1.Controls.Add(this.tpCsmDelta);
            this.tabControl1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tabControl1.Location = new System.Drawing.Point(38, 91);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(613, 415);
            this.tabControl1.TabIndex = 18;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tpCsm
            // 
            this.tpCsm.BackColor = System.Drawing.Color.Black;
            this.tpCsm.Controls.Add(this.label2);
            this.tpCsm.Controls.Add(this.lblStep3);
            this.tpCsm.Controls.Add(this.lblStep1);
            this.tpCsm.Controls.Add(this.pnlImport);
            this.tpCsm.Controls.Add(this.lblStep2);
            this.tpCsm.Controls.Add(this.lblStep4);
            this.tpCsm.Location = new System.Drawing.Point(4, 27);
            this.tpCsm.Name = "tpCsm";
            this.tpCsm.Padding = new System.Windows.Forms.Padding(3);
            this.tpCsm.Size = new System.Drawing.Size(605, 384);
            this.tpCsm.TabIndex = 0;
            this.tpCsm.Text = "CSM";
            // 
            // lblStep3
            // 
            this.lblStep3.AutoSize = true;
            this.lblStep3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStep3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.lblStep3.Location = new System.Drawing.Point(198, 259);
            this.lblStep3.Name = "lblStep3";
            this.lblStep3.Size = new System.Drawing.Size(172, 16);
            this.lblStep3.TabIndex = 13;
            this.lblStep3.Text = "3)  Importing new CSM data.";
            // 
            // lblStep1
            // 
            this.lblStep1.AutoSize = true;
            this.lblStep1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStep1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.lblStep1.Location = new System.Drawing.Point(198, 223);
            this.lblStep1.Name = "lblStep1";
            this.lblStep1.Size = new System.Drawing.Size(221, 16);
            this.lblStep1.TabIndex = 11;
            this.lblStep1.Text = "1)  Creating table, inserting raw data.";
            // 
            // pnlImport
            // 
            this.pnlImport.Controls.Add(this.btnImport);
            this.pnlImport.Controls.Add(this.lblPriorReleaseId);
            this.pnlImport.Controls.Add(this.label3);
            this.pnlImport.Controls.Add(this.tbxCurrentReleaseId);
            this.pnlImport.Controls.Add(this.tbxPriorReleaseId);
            this.pnlImport.Location = new System.Drawing.Point(21, 64);
            this.pnlImport.Name = "pnlImport";
            this.pnlImport.Size = new System.Drawing.Size(343, 151);
            this.pnlImport.TabIndex = 17;
            // 
            // lblStep2
            // 
            this.lblStep2.AutoSize = true;
            this.lblStep2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStep2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.lblStep2.Location = new System.Drawing.Point(198, 241);
            this.lblStep2.Name = "lblStep2";
            this.lblStep2.Size = new System.Drawing.Size(149, 16);
            this.lblStep2.TabIndex = 12;
            this.lblStep2.Text = "2)  Rolling CSM forward.";
            // 
            // lblStep4
            // 
            this.lblStep4.AutoSize = true;
            this.lblStep4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStep4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.lblStep4.Location = new System.Drawing.Point(198, 277);
            this.lblStep4.Name = "lblStep4";
            this.lblStep4.Size = new System.Drawing.Size(124, 16);
            this.lblStep4.TabIndex = 14;
            this.lblStep4.Text = "4)  Import complete.";
            // 
            // tpCsmDelta
            // 
            this.tpCsmDelta.BackColor = System.Drawing.Color.Black;
            this.tpCsmDelta.Controls.Add(this.label4);
            this.tpCsmDelta.Controls.Add(this.lblDeltaImportComplete);
            this.tpCsmDelta.Controls.Add(this.pnlDeltaImport);
            this.tpCsmDelta.Location = new System.Drawing.Point(4, 27);
            this.tpCsmDelta.Name = "tpCsmDelta";
            this.tpCsmDelta.Padding = new System.Windows.Forms.Padding(3);
            this.tpCsmDelta.Size = new System.Drawing.Size(616, 384);
            this.tpCsmDelta.TabIndex = 1;
            this.tpCsmDelta.Text = "CSM Delta";
            // 
            // lblDeltaImportComplete
            // 
            this.lblDeltaImportComplete.AutoSize = true;
            this.lblDeltaImportComplete.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblDeltaImportComplete.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.lblDeltaImportComplete.Location = new System.Drawing.Point(199, 223);
            this.lblDeltaImportComplete.Name = "lblDeltaImportComplete";
            this.lblDeltaImportComplete.Size = new System.Drawing.Size(107, 16);
            this.lblDeltaImportComplete.TabIndex = 11;
            this.lblDeltaImportComplete.Text = "Import complete.";
            // 
            // pnlDeltaImport
            // 
            this.pnlDeltaImport.Controls.Add(this.btnDeltaImport);
            this.pnlDeltaImport.Controls.Add(this.label8);
            this.pnlDeltaImport.Controls.Add(this.tbxCurrentDeltaReleaseId);
            this.pnlDeltaImport.Location = new System.Drawing.Point(21, 64);
            this.pnlDeltaImport.Name = "pnlDeltaImport";
            this.pnlDeltaImport.Size = new System.Drawing.Size(343, 151);
            this.pnlDeltaImport.TabIndex = 19;
            // 
            // btnDeltaImport
            // 
            this.btnDeltaImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDeltaImport.Location = new System.Drawing.Point(180, 98);
            this.btnDeltaImport.Name = "btnDeltaImport";
            this.btnDeltaImport.Size = new System.Drawing.Size(114, 41);
            this.btnDeltaImport.TabIndex = 2;
            this.btnDeltaImport.Text = "Import";
            this.btnDeltaImport.UseVisualStyleBackColor = true;
            this.btnDeltaImport.Click += new System.EventHandler(this.btnDeltaImport_Click);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.White;
            this.label8.Location = new System.Drawing.Point(37, 24);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(137, 18);
            this.label8.TabIndex = 5;
            this.label8.Text = "Current Release ID:";
            // 
            // tbxCurrentDeltaReleaseId
            // 
            this.tbxCurrentDeltaReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentDeltaReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentDeltaReleaseId.Location = new System.Drawing.Point(180, 21);
            this.tbxCurrentDeltaReleaseId.Name = "tbxCurrentDeltaReleaseId";
            this.tbxCurrentDeltaReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxCurrentDeltaReleaseId.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label2.Location = new System.Drawing.Point(58, 34);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(342, 16);
            this.label2.TabIndex = 18;
            this.label2.Text = "Copy column names and row data from the spreadsheet.";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label4.Location = new System.Drawing.Point(58, 34);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(254, 16);
            this.label4.TabIndex = 20;
            this.label4.Text = "Copy row data only from the spreadsheet.";
            // 
            // formMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(693, 550);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.Black;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "formMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            this.Activated += new System.EventHandler(this.formMain_Activated);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tpCsm.ResumeLayout(false);
            this.tpCsm.PerformLayout();
            this.pnlImport.ResumeLayout(false);
            this.pnlImport.PerformLayout();
            this.tpCsmDelta.ResumeLayout(false);
            this.tpCsmDelta.PerformLayout();
            this.pnlDeltaImport.ResumeLayout(false);
            this.pnlDeltaImport.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnImport;
        private System.Windows.Forms.Button btnExit;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblPriorReleaseId;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox tbxPriorReleaseId;
        private System.Windows.Forms.TextBox tbxCurrentReleaseId;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label lblStep1;
        private System.Windows.Forms.Label lblStep4;
        private System.Windows.Forms.Label lblStep3;
        private System.Windows.Forms.Label lblStep2;
        private System.Windows.Forms.Panel pnlImport;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tpCsm;
        private System.Windows.Forms.TabPage tpCsmDelta;
        private System.Windows.Forms.Label lblDeltaImportComplete;
        private System.Windows.Forms.Panel pnlDeltaImport;
        private System.Windows.Forms.Button btnDeltaImport;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox tbxCurrentDeltaReleaseId;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label4;
    }
}

