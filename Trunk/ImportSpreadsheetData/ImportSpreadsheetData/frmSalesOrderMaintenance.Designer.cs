namespace ImportSpreadsheetData
{
    partial class frmSalesOrderMaintenance
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
            this.label1 = new System.Windows.Forms.Label();
            this.dgvSalesOrders = new System.Windows.Forms.DataGridView();
            this.btnUpdateOrder = new System.Windows.Forms.Button();
            this.tbxDestination = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btnClose = new System.Windows.Forms.Button();
            this.pnlDestImported = new System.Windows.Forms.Panel();
            this.pnlUpdateOrders = new System.Windows.Forms.Panel();
            this.pnlDestEnter = new System.Windows.Forms.Panel();
            this.btnEnterDestination = new System.Windows.Forms.Button();
            this.tbxDestinationEnter = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvSalesOrders)).BeginInit();
            this.pnlDestImported.SuspendLayout();
            this.pnlUpdateOrders.SuspendLayout();
            this.pnlDestEnter.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(5, 27);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(474, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Highlight a row to either set an order up for planning release import or remove i" +
    "t.";
            // 
            // dgvSalesOrders
            // 
            this.dgvSalesOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvSalesOrders.Location = new System.Drawing.Point(8, 48);
            this.dgvSalesOrders.MultiSelect = false;
            this.dgvSalesOrders.Name = "dgvSalesOrders";
            this.dgvSalesOrders.ReadOnly = true;
            this.dgvSalesOrders.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvSalesOrders.Size = new System.Drawing.Size(633, 359);
            this.dgvSalesOrders.TabIndex = 1;
            this.dgvSalesOrders.SelectionChanged += new System.EventHandler(this.dgvSalesOrders_SelectionChanged);
            // 
            // btnUpdateOrder
            // 
            this.btnUpdateOrder.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnUpdateOrder.Location = new System.Drawing.Point(8, 413);
            this.btnUpdateOrder.Name = "btnUpdateOrder";
            this.btnUpdateOrder.Size = new System.Drawing.Size(159, 36);
            this.btnUpdateOrder.TabIndex = 2;
            this.btnUpdateOrder.Text = "Add";
            this.btnUpdateOrder.UseVisualStyleBackColor = true;
            this.btnUpdateOrder.Click += new System.EventHandler(this.btnUpdateOrder_Click);
            // 
            // tbxDestination
            // 
            this.tbxDestination.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxDestination.Location = new System.Drawing.Point(89, 12);
            this.tbxDestination.Name = "tbxDestination";
            this.tbxDestination.ReadOnly = true;
            this.tbxDestination.Size = new System.Drawing.Size(156, 22);
            this.tbxDestination.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(5, 15);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(78, 16);
            this.label2.TabIndex = 4;
            this.label2.Text = "Destination:";
            // 
            // btnClose
            // 
            this.btnClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnClose.Location = new System.Drawing.Point(512, 521);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(159, 36);
            this.btnClose.TabIndex = 5;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // pnlDestImported
            // 
            this.pnlDestImported.Controls.Add(this.tbxDestination);
            this.pnlDestImported.Controls.Add(this.label2);
            this.pnlDestImported.Location = new System.Drawing.Point(24, 12);
            this.pnlDestImported.Name = "pnlDestImported";
            this.pnlDestImported.Size = new System.Drawing.Size(258, 45);
            this.pnlDestImported.TabIndex = 6;
            // 
            // pnlUpdateOrders
            // 
            this.pnlUpdateOrders.Controls.Add(this.label1);
            this.pnlUpdateOrders.Controls.Add(this.dgvSalesOrders);
            this.pnlUpdateOrders.Controls.Add(this.btnUpdateOrder);
            this.pnlUpdateOrders.Location = new System.Drawing.Point(24, 63);
            this.pnlUpdateOrders.Name = "pnlUpdateOrders";
            this.pnlUpdateOrders.Size = new System.Drawing.Size(647, 452);
            this.pnlUpdateOrders.TabIndex = 7;
            // 
            // pnlDestEnter
            // 
            this.pnlDestEnter.Controls.Add(this.btnEnterDestination);
            this.pnlDestEnter.Controls.Add(this.tbxDestinationEnter);
            this.pnlDestEnter.Controls.Add(this.label3);
            this.pnlDestEnter.Location = new System.Drawing.Point(288, 12);
            this.pnlDestEnter.Name = "pnlDestEnter";
            this.pnlDestEnter.Size = new System.Drawing.Size(383, 45);
            this.pnlDestEnter.TabIndex = 8;
            // 
            // btnEnterDestination
            // 
            this.btnEnterDestination.Location = new System.Drawing.Point(302, 11);
            this.btnEnterDestination.Name = "btnEnterDestination";
            this.btnEnterDestination.Size = new System.Drawing.Size(75, 23);
            this.btnEnterDestination.TabIndex = 9;
            this.btnEnterDestination.Text = "Enter";
            this.btnEnterDestination.UseVisualStyleBackColor = true;
            this.btnEnterDestination.Click += new System.EventHandler(this.btnEnterDestination_Click);
            // 
            // tbxDestinationEnter
            // 
            this.tbxDestinationEnter.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxDestinationEnter.Location = new System.Drawing.Point(140, 12);
            this.tbxDestinationEnter.Name = "tbxDestinationEnter";
            this.tbxDestinationEnter.Size = new System.Drawing.Size(156, 22);
            this.tbxDestinationEnter.TabIndex = 6;
            this.tbxDestinationEnter.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbxDestinationEnter_KeyPress);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(13, 15);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(121, 16);
            this.label3.TabIndex = 5;
            this.label3.Text = "Enter a destination:";
            // 
            // frmSalesOrderMaintenance
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.LightGray;
            this.ClientSize = new System.Drawing.Size(695, 580);
            this.ControlBox = false;
            this.Controls.Add(this.pnlDestEnter);
            this.Controls.Add(this.pnlUpdateOrders);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.pnlDestImported);
            this.Name = "frmSalesOrderMaintenance";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Sales Order Maintenance";
            ((System.ComponentModel.ISupportInitialize)(this.dgvSalesOrders)).EndInit();
            this.pnlDestImported.ResumeLayout(false);
            this.pnlDestImported.PerformLayout();
            this.pnlUpdateOrders.ResumeLayout(false);
            this.pnlUpdateOrders.PerformLayout();
            this.pnlDestEnter.ResumeLayout(false);
            this.pnlDestEnter.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dgvSalesOrders;
        private System.Windows.Forms.Button btnUpdateOrder;
        private System.Windows.Forms.TextBox tbxDestination;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.Panel pnlDestImported;
        private System.Windows.Forms.Panel pnlUpdateOrders;
        private System.Windows.Forms.Panel pnlDestEnter;
        private System.Windows.Forms.TextBox tbxDestinationEnter;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnEnterDestination;
    }
}