namespace RmaMaintenance.UserControls
{
    partial class RtvAddInventory
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.ListViewItem listViewItem1 = new System.Windows.Forms.ListViewItem(new string[] {
            "1",
            "XYZ",
            "100",
            "ABC",
            "Yes"}, -1);
            System.Windows.Forms.ListViewItem listViewItem2 = new System.Windows.Forms.ListViewItem(new string[] {
            "2",
            "XYZ",
            "-1",
            "ABC",
            "No"}, -1, System.Drawing.Color.Red, System.Drawing.Color.Empty, null);
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.mesCheckButton1 = new Fx.WinForms.Flat.MESCheckButton();
            this.label1 = new System.Windows.Forms.Label();
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.listView1 = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader5 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader6 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.label2 = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.mesButton1 = new Fx.WinForms.Flat.MESButton();
            this.mesButton2 = new Fx.WinForms.Flat.MESButton();
            this.mesButton3 = new Fx.WinForms.Flat.MESButton();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel4.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.AutoSize = true;
            this.tableLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel4, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.mesButton3, 0, 2);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 3;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(805, 339);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.Controls.Add(this.mesCheckButton1, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(805, 63);
            this.tableLayoutPanel2.TabIndex = 0;
            // 
            // mesCheckButton1
            // 
            this.mesCheckButton1.AutoSize = true;
            this.mesCheckButton1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.mesCheckButton1.Checked = false;
            this.mesCheckButton1.CheckedBorderColor = System.Drawing.Color.Empty;
            this.mesCheckButton1.CheckedColor = System.Drawing.Color.Empty;
            this.mesCheckButton1.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesCheckButton1.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesCheckButton1.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesCheckButton1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesCheckButton1.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesCheckButton1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesCheckButton1.Location = new System.Drawing.Point(676, 3);
            this.mesCheckButton1.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.mesCheckButton1.Name = "mesCheckButton1";
            this.mesCheckButton1.Padding = new System.Windows.Forms.Padding(20, 0, 20, 0);
            this.mesCheckButton1.Size = new System.Drawing.Size(119, 35);
            this.mesCheckButton1.TabIndex = 0;
            this.mesCheckButton1.Text = "-  Hide";
            this.mesCheckButton1.UncheckedBorderColor = System.Drawing.Color.Empty;
            this.mesCheckButton1.UncheckedColor = System.Drawing.Color.Empty;
            this.mesCheckButton1.UseVisualStyleBackColor = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(4, 0);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(219, 20);
            this.label1.TabIndex = 1;
            this.label1.Text = "Show to add inventory to RTV";
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.AutoSize = true;
            this.tableLayoutPanel4.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel4.ColumnCount = 1;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Controls.Add(this.listView1, 0, 1);
            this.tableLayoutPanel4.Controls.Add(this.label2, 0, 0);
            this.tableLayoutPanel4.Controls.Add(this.tableLayoutPanel3, 0, 2);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(0, 63);
            this.tableLayoutPanel4.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 3;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 31F));
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 154F));
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel4.Size = new System.Drawing.Size(805, 235);
            this.tableLayoutPanel4.TabIndex = 0;
            // 
            // listView1
            // 
            this.listView1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.listView1.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.listView1.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader3,
            this.columnHeader2,
            this.columnHeader4,
            this.columnHeader5,
            this.columnHeader6});
            this.listView1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listView1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.listView1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.listView1.FullRowSelect = true;
            listViewItem1.StateImageIndex = 0;
            listViewItem2.StateImageIndex = 0;
            this.listView1.Items.AddRange(new System.Windows.Forms.ListViewItem[] {
            listViewItem1,
            listViewItem2});
            this.listView1.Location = new System.Drawing.Point(4, 36);
            this.listView1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(797, 144);
            this.listView1.TabIndex = 3;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Serial";
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Part";
            this.columnHeader3.Width = 117;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Quantity";
            this.columnHeader2.Width = 93;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Product Line";
            this.columnHeader4.Width = 136;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "Valid ?";
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "Message";
            this.columnHeader6.Width = 167;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(4, 0);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(198, 20);
            this.label2.TabIndex = 4;
            this.label2.Text = "Copy and paste from Excel";
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 23.25228F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 76.74772F));
            this.tableLayoutPanel3.Controls.Add(this.mesButton1, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.mesButton2, 1, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(0, 185);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(805, 50);
            this.tableLayoutPanel3.TabIndex = 5;
            // 
            // mesButton1
            // 
            this.mesButton1.AutoSize = true;
            this.mesButton1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.mesButton1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesButton1.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesButton1.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesButton1.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesButton1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesButton1.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesButton1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesButton1.Location = new System.Drawing.Point(10, 3);
            this.mesButton1.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.mesButton1.Name = "mesButton1";
            this.mesButton1.Padding = new System.Windows.Forms.Padding(10, 0, 10, 0);
            this.mesButton1.Size = new System.Drawing.Size(99, 35);
            this.mesButton1.TabIndex = 0;
            this.mesButton1.Text = "Import";
            this.mesButton1.UseVisualStyleBackColor = false;
            // 
            // mesButton2
            // 
            this.mesButton2.AutoSize = true;
            this.mesButton2.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.mesButton2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesButton2.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesButton2.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesButton2.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesButton2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesButton2.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesButton2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesButton2.Location = new System.Drawing.Point(197, 3);
            this.mesButton2.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.mesButton2.Name = "mesButton2";
            this.mesButton2.Padding = new System.Windows.Forms.Padding(10, 0, 10, 0);
            this.mesButton2.Size = new System.Drawing.Size(84, 35);
            this.mesButton2.TabIndex = 1;
            this.mesButton2.Text = "Clear";
            this.mesButton2.UseVisualStyleBackColor = false;
            // 
            // mesButton3
            // 
            this.mesButton3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mesButton3.AutoSize = true;
            this.mesButton3.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.mesButton3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesButton3.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesButton3.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesButton3.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesButton3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesButton3.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesButton3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesButton3.Location = new System.Drawing.Point(565, 301);
            this.mesButton3.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.mesButton3.Name = "mesButton3";
            this.mesButton3.Size = new System.Drawing.Size(230, 35);
            this.mesButton3.TabIndex = 1;
            this.mesButton3.Text = "Add Inventory To RTV(s)";
            this.mesButton3.UseVisualStyleBackColor = false;
            // 
            // RtvAddInventory
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.Controls.Add(this.tableLayoutPanel1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "RtvAddInventory";
            this.Size = new System.Drawing.Size(805, 339);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel4.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private Fx.WinForms.Flat.MESCheckButton mesCheckButton1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private Fx.WinForms.Flat.MESButton mesButton1;
        private Fx.WinForms.Flat.MESButton mesButton2;
        private Fx.WinForms.Flat.MESButton mesButton3;
    }
}
