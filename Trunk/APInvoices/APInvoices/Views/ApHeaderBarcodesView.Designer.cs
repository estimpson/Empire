namespace APInvoices.Views
{
    partial class ApHeaderBarcodesView
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
            this.btnPrintBarcodes = new System.Windows.Forms.Button();
            this.lvwInvoicesList = new System.Windows.Forms.ListView();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.cbxInvoice = new System.Windows.Forms.ComboBox();
            this.cbxCmFlag = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.cbxVendor = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnReprint = new System.Windows.Forms.Button();
            this.btnFileScannedInvoices = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnPrintBarcodes
            // 
            this.btnPrintBarcodes.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnPrintBarcodes.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPrintBarcodes.Location = new System.Drawing.Point(549, 42);
            this.btnPrintBarcodes.Name = "btnPrintBarcodes";
            this.btnPrintBarcodes.Size = new System.Drawing.Size(226, 45);
            this.btnPrintBarcodes.TabIndex = 0;
            this.btnPrintBarcodes.Text = "Print Barcodes";
            this.btnPrintBarcodes.UseVisualStyleBackColor = true;
            this.btnPrintBarcodes.Click += new System.EventHandler(this.btnPrintBarcodes_Click);
            // 
            // lvwInvoicesList
            // 
            this.lvwInvoicesList.Location = new System.Drawing.Point(15, 42);
            this.lvwInvoicesList.Name = "lvwInvoicesList";
            this.lvwInvoicesList.Size = new System.Drawing.Size(435, 570);
            this.lvwInvoicesList.TabIndex = 1;
            this.lvwInvoicesList.UseCompatibleStateImageBehavior = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(12, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(196, 15);
            this.label1.TabIndex = 2;
            this.label1.Text = "Invoices ready for barcode printing:";
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.cbxInvoice);
            this.groupBox1.Controls.Add(this.cbxCmFlag);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.cbxVendor);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.btnReprint);
            this.groupBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(549, 437);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(226, 175);
            this.groupBox1.TabIndex = 3;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Reprint Barcode";
            // 
            // cbxInvoice
            // 
            this.cbxInvoice.FormattingEnabled = true;
            this.cbxInvoice.Location = new System.Drawing.Point(81, 89);
            this.cbxInvoice.Name = "cbxInvoice";
            this.cbxInvoice.Size = new System.Drawing.Size(121, 23);
            this.cbxInvoice.TabIndex = 7;
            this.cbxInvoice.SelectedIndexChanged += new System.EventHandler(this.cbxInvoice_SelectedIndexChanged);
            // 
            // cbxCmFlag
            // 
            this.cbxCmFlag.FormattingEnabled = true;
            this.cbxCmFlag.Location = new System.Drawing.Point(81, 57);
            this.cbxCmFlag.Name = "cbxCmFlag";
            this.cbxCmFlag.Size = new System.Drawing.Size(121, 23);
            this.cbxCmFlag.TabIndex = 6;
            this.cbxCmFlag.SelectedIndexChanged += new System.EventHandler(this.cbxCmFlag_SelectedIndexChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(19, 60);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(56, 15);
            this.label4.TabIndex = 5;
            this.label4.Text = "CM Flag:";
            // 
            // cbxVendor
            // 
            this.cbxVendor.FormattingEnabled = true;
            this.cbxVendor.Location = new System.Drawing.Point(81, 25);
            this.cbxVendor.Name = "cbxVendor";
            this.cbxVendor.Size = new System.Drawing.Size(121, 23);
            this.cbxVendor.TabIndex = 4;
            this.cbxVendor.SelectedIndexChanged += new System.EventHandler(this.cbxVendor_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(26, 28);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(49, 15);
            this.label3.TabIndex = 3;
            this.label3.Text = "Vendor:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(17, 92);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(58, 15);
            this.label2.TabIndex = 2;
            this.label2.Text = "Invoice #:";
            // 
            // btnReprint
            // 
            this.btnReprint.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnReprint.Location = new System.Drawing.Point(81, 123);
            this.btnReprint.Name = "btnReprint";
            this.btnReprint.Size = new System.Drawing.Size(121, 33);
            this.btnReprint.TabIndex = 1;
            this.btnReprint.Text = "Reprint";
            this.btnReprint.UseVisualStyleBackColor = true;
            this.btnReprint.Click += new System.EventHandler(this.btnReprint_Click);
            // 
            // btnFileScannedInvoices
            // 
            this.btnFileScannedInvoices.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnFileScannedInvoices.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnFileScannedInvoices.Location = new System.Drawing.Point(549, 129);
            this.btnFileScannedInvoices.Name = "btnFileScannedInvoices";
            this.btnFileScannedInvoices.Size = new System.Drawing.Size(226, 45);
            this.btnFileScannedInvoices.TabIndex = 4;
            this.btnFileScannedInvoices.Text = "File Scanned Invoices";
            this.btnFileScannedInvoices.UseVisualStyleBackColor = true;
            this.btnFileScannedInvoices.Click += new System.EventHandler(this.btnFileScannedInvoices_Click);
            // 
            // ApHeaderBarcodesView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlDarkDark;
            this.ClientSize = new System.Drawing.Size(787, 624);
            this.Controls.Add(this.btnFileScannedInvoices);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btnPrintBarcodes);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lvwInvoicesList);
            this.MaximizeBox = false;
            this.Name = "ApHeaderBarcodesView";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AP Invoice Barcode Printing";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnPrintBarcodes;
        private System.Windows.Forms.ListView lvwInvoicesList;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ComboBox cbxVendor;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnReprint;
        private System.Windows.Forms.Button btnFileScannedInvoices;
        private System.Windows.Forms.ComboBox cbxCmFlag;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox cbxInvoice;
    }
}

