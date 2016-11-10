namespace ImportSpreadsheetData
{
    partial class frmImport
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
            this.lvwImportedData = new System.Windows.Forms.ListView();
            this.label1 = new System.Windows.Forms.Label();
            this.lbxExceptions = new System.Windows.Forms.ListBox();
            this.tbxRelease = new System.Windows.Forms.TextBox();
            this.cbxCustomer = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.tbxDestination = new System.Windows.Forms.TextBox();
            this.btnSetOrderUpdateFlag = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnImport
            // 
            this.btnImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnImport.Location = new System.Drawing.Point(31, 102);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(208, 45);
            this.btnImport.TabIndex = 0;
            this.btnImport.Text = "Import Releases";
            this.btnImport.UseVisualStyleBackColor = true;
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            // 
            // lvwImportedData
            // 
            this.lvwImportedData.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lvwImportedData.Location = new System.Drawing.Point(287, 102);
            this.lvwImportedData.Name = "lvwImportedData";
            this.lvwImportedData.Size = new System.Drawing.Size(563, 516);
            this.lvwImportedData.TabIndex = 6;
            this.lvwImportedData.UseCompatibleStateImageBehavior = false;
            this.lvwImportedData.View = System.Windows.Forms.View.Details;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(859, 60);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(107, 15);
            this.label1.TabIndex = 7;
            this.label1.Text = "Import exceptions:";
            this.label1.Visible = false;
            // 
            // lbxExceptions
            // 
            this.lbxExceptions.FormattingEnabled = true;
            this.lbxExceptions.Location = new System.Drawing.Point(862, 81);
            this.lbxExceptions.Name = "lbxExceptions";
            this.lbxExceptions.Size = new System.Drawing.Size(194, 537);
            this.lbxExceptions.TabIndex = 8;
            this.lbxExceptions.Visible = false;
            // 
            // tbxRelease
            // 
            this.tbxRelease.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxRelease.Location = new System.Drawing.Point(287, 49);
            this.tbxRelease.Name = "tbxRelease";
            this.tbxRelease.ReadOnly = true;
            this.tbxRelease.Size = new System.Drawing.Size(277, 26);
            this.tbxRelease.TabIndex = 9;
            // 
            // cbxCustomer
            // 
            this.cbxCustomer.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxCustomer.FormattingEnabled = true;
            this.cbxCustomer.Location = new System.Drawing.Point(31, 49);
            this.cbxCustomer.Name = "cbxCustomer";
            this.cbxCustomer.Size = new System.Drawing.Size(208, 28);
            this.cbxCustomer.TabIndex = 11;
            this.cbxCustomer.SelectedIndexChanged += new System.EventHandler(this.cbxCustomer_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.Black;
            this.label3.Location = new System.Drawing.Point(28, 28);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(135, 18);
            this.label3.TabIndex = 12;
            this.label3.Text = "Select a Customer:";
            // 
            // tbxDestination
            // 
            this.tbxDestination.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxDestination.Location = new System.Drawing.Point(573, 49);
            this.tbxDestination.Name = "tbxDestination";
            this.tbxDestination.ReadOnly = true;
            this.tbxDestination.Size = new System.Drawing.Size(277, 26);
            this.tbxDestination.TabIndex = 14;
            // 
            // btnSetOrderUpdateFlag
            // 
            this.btnSetOrderUpdateFlag.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSetOrderUpdateFlag.Location = new System.Drawing.Point(31, 583);
            this.btnSetOrderUpdateFlag.Name = "btnSetOrderUpdateFlag";
            this.btnSetOrderUpdateFlag.Size = new System.Drawing.Size(208, 35);
            this.btnSetOrderUpdateFlag.TabIndex = 15;
            this.btnSetOrderUpdateFlag.Text = "Set Order Update Flag";
            this.btnSetOrderUpdateFlag.UseVisualStyleBackColor = true;
            this.btnSetOrderUpdateFlag.Click += new System.EventHandler(this.btnSetOrderUpdateFlag_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.Black;
            this.label2.Location = new System.Drawing.Point(284, 33);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 13);
            this.label2.TabIndex = 16;
            this.label2.Text = "Release:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.Black;
            this.label4.Location = new System.Drawing.Point(570, 33);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(63, 13);
            this.label4.TabIndex = 17;
            this.label4.Text = "Destination:";
            // 
            // frmImport
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.LightGray;
            this.ClientSize = new System.Drawing.Size(886, 650);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnSetOrderUpdateFlag);
            this.Controls.Add(this.tbxDestination);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.cbxCustomer);
            this.Controls.Add(this.tbxRelease);
            this.Controls.Add(this.lbxExceptions);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lvwImportedData);
            this.Controls.Add(this.btnImport);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "frmImport";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Planning Release Import";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnImport;
        private System.Windows.Forms.ListView lvwImportedData;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListBox lbxExceptions;
        private System.Windows.Forms.TextBox tbxRelease;
        private System.Windows.Forms.ComboBox cbxCustomer;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox tbxDestination;
        private System.Windows.Forms.Button btnSetOrderUpdateFlag;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label4;
    }
}

