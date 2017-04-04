using RmaMaintenance.Views.Helpers;

namespace RmaMaintenance.UserControls
{
    partial class RtvAddInventoryOLV
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
            serialListView.StoreViewPreferences();
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle4 = new BrightIdeasSoftware.HeaderStateStyle();
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle5 = new BrightIdeasSoftware.HeaderStateStyle();
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle6 = new BrightIdeasSoftware.HeaderStateStyle();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.ActivateDeactivateButton = new Fx.WinForms.Flat.MESCheckButton();
            this.ShowHideInstruction = new System.Windows.Forms.Label();
            this.ControlActivePanel = new System.Windows.Forms.TableLayoutPanel();
            this.label2 = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.importButton = new Fx.WinForms.Flat.MESButton();
            this.clearButton = new Fx.WinForms.Flat.MESButton();
            this.addInventoryButton = new Fx.WinForms.Flat.MESButton();
            this.serialListView = new BrightIdeasSoftware.ObjectListView();
            this.olvColumn1 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn2 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn3 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn4 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn5 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn6 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.DarkHeaderStyle = new BrightIdeasSoftware.HeaderFormatStyle();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.ControlActivePanel.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.serialListView)).BeginInit();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.AutoSize = true;
            this.tableLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.ControlActivePanel, 0, 1);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(805, 311);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.AutoSize = true;
            this.tableLayoutPanel2.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.Controls.Add(this.ActivateDeactivateButton, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.ShowHideInstruction, 0, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(805, 41);
            this.tableLayoutPanel2.TabIndex = 0;
            // 
            // ActivateDeactivateButton
            // 
            this.ActivateDeactivateButton.AutoSize = true;
            this.ActivateDeactivateButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ActivateDeactivateButton.Checked = false;
            this.ActivateDeactivateButton.CheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.ActivateDeactivateButton.CheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.ActivateDeactivateButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.ActivateDeactivateButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.ActivateDeactivateButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.ActivateDeactivateButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.ActivateDeactivateButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.ActivateDeactivateButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.ActivateDeactivateButton.Location = new System.Drawing.Point(676, 3);
            this.ActivateDeactivateButton.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.ActivateDeactivateButton.Name = "ActivateDeactivateButton";
            this.ActivateDeactivateButton.Padding = new System.Windows.Forms.Padding(20, 0, 20, 0);
            this.ActivateDeactivateButton.Size = new System.Drawing.Size(119, 35);
            this.ActivateDeactivateButton.TabIndex = 0;
            this.ActivateDeactivateButton.Text = "-  Hide";
            this.ActivateDeactivateButton.UncheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.ActivateDeactivateButton.UncheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.ActivateDeactivateButton.UseVisualStyleBackColor = false;
            this.ActivateDeactivateButton.Click += new System.EventHandler(this.ActivateDeactivateButtonClick);
            // 
            // ShowHideInstruction
            // 
            this.ShowHideInstruction.AutoSize = true;
            this.ShowHideInstruction.Location = new System.Drawing.Point(4, 0);
            this.ShowHideInstruction.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.ShowHideInstruction.Name = "ShowHideInstruction";
            this.ShowHideInstruction.Size = new System.Drawing.Size(219, 20);
            this.ShowHideInstruction.TabIndex = 1;
            this.ShowHideInstruction.Text = "Show to add inventory to RTV";
            // 
            // ControlActivePanel
            // 
            this.ControlActivePanel.AutoSize = true;
            this.ControlActivePanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ControlActivePanel.ColumnCount = 1;
            this.ControlActivePanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.ControlActivePanel.Controls.Add(this.label2, 0, 0);
            this.ControlActivePanel.Controls.Add(this.tableLayoutPanel3, 0, 2);
            this.ControlActivePanel.Controls.Add(this.addInventoryButton, 0, 3);
            this.ControlActivePanel.Controls.Add(this.serialListView, 0, 1);
            this.ControlActivePanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ControlActivePanel.Location = new System.Drawing.Point(0, 41);
            this.ControlActivePanel.Margin = new System.Windows.Forms.Padding(0);
            this.ControlActivePanel.Name = "ControlActivePanel";
            this.ControlActivePanel.RowCount = 4;
            this.ControlActivePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.ControlActivePanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 154F));
            this.ControlActivePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.ControlActivePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.ControlActivePanel.Size = new System.Drawing.Size(805, 270);
            this.ControlActivePanel.TabIndex = 0;
            this.ControlActivePanel.Visible = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label2.Location = new System.Drawing.Point(4, 0);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 10);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(152, 15);
            this.label2.TabIndex = 4;
            this.label2.Text = "Copy and paste from Excel";
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 23.25228F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 76.74772F));
            this.tableLayoutPanel3.Controls.Add(this.importButton, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.clearButton, 1, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(0, 179);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(805, 50);
            this.tableLayoutPanel3.TabIndex = 5;
            // 
            // importButton
            // 
            this.importButton.AutoSize = true;
            this.importButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.importButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.importButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.importButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.importButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.importButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.importButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.importButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.importButton.Location = new System.Drawing.Point(10, 3);
            this.importButton.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.importButton.Name = "importButton";
            this.importButton.Padding = new System.Windows.Forms.Padding(10, 0, 10, 0);
            this.importButton.Size = new System.Drawing.Size(99, 35);
            this.importButton.TabIndex = 0;
            this.importButton.Text = "Import";
            this.importButton.UseVisualStyleBackColor = false;
            this.importButton.Click += new System.EventHandler(this.ImportButtonClick);
            // 
            // clearButton
            // 
            this.clearButton.AutoSize = true;
            this.clearButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.clearButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.clearButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.clearButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.clearButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.clearButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.clearButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.clearButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.clearButton.Location = new System.Drawing.Point(197, 3);
            this.clearButton.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.clearButton.Name = "clearButton";
            this.clearButton.Padding = new System.Windows.Forms.Padding(10, 0, 10, 0);
            this.clearButton.Size = new System.Drawing.Size(84, 35);
            this.clearButton.TabIndex = 1;
            this.clearButton.Text = "Clear";
            this.clearButton.UseVisualStyleBackColor = false;
            // 
            // addInventoryButton
            // 
            this.addInventoryButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.addInventoryButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.addInventoryButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.addInventoryButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.addInventoryButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.addInventoryButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.addInventoryButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.addInventoryButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.addInventoryButton.Location = new System.Drawing.Point(565, 232);
            this.addInventoryButton.Margin = new System.Windows.Forms.Padding(10, 3, 10, 3);
            this.addInventoryButton.Name = "addInventoryButton";
            this.addInventoryButton.Size = new System.Drawing.Size(230, 35);
            this.addInventoryButton.TabIndex = 1;
            this.addInventoryButton.Text = "Add Inventory To RTV(s)";
            this.addInventoryButton.UseVisualStyleBackColor = false;
            // 
            // serialListView
            // 
            this.serialListView.AllColumns.Add(this.olvColumn1);
            this.serialListView.AllColumns.Add(this.olvColumn2);
            this.serialListView.AllColumns.Add(this.olvColumn3);
            this.serialListView.AllColumns.Add(this.olvColumn4);
            this.serialListView.AllColumns.Add(this.olvColumn5);
            this.serialListView.AllColumns.Add(this.olvColumn6);
            this.serialListView.AlternateRowBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(29)))), ((int)(((byte)(29)))), ((int)(((byte)(29)))));
            this.serialListView.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.serialListView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.serialListView.CellEditUseWholeCell = false;
            this.serialListView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.olvColumn1,
            this.olvColumn2,
            this.olvColumn3,
            this.olvColumn4,
            this.olvColumn5,
            this.olvColumn6});
            this.serialListView.Cursor = System.Windows.Forms.Cursors.Default;
            this.serialListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.serialListView.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.serialListView.HasCollapsibleGroups = false;
            this.serialListView.HeaderFormatStyle = this.DarkHeaderStyle;
            this.serialListView.Location = new System.Drawing.Point(3, 28);
            this.serialListView.Name = "serialListView";
            this.serialListView.Size = new System.Drawing.Size(799, 148);
            this.serialListView.TabIndex = 6;
            this.serialListView.UseAlternatingBackColors = true;
            this.serialListView.UseCompatibleStateImageBehavior = false;
            this.serialListView.View = System.Windows.Forms.View.Details;
            // 
            // olvColumn1
            // 
            this.olvColumn1.AspectName = "Serial";
            this.olvColumn1.Groupable = false;
            this.olvColumn1.Text = "Serial";
            // 
            // olvColumn2
            // 
            this.olvColumn2.AspectName = "Part";
            this.olvColumn2.Text = "Part";
            // 
            // olvColumn3
            // 
            this.olvColumn3.AspectName = "Quantity";
            this.olvColumn3.AspectToStringFormat = "{0:G6}";
            this.olvColumn3.Text = "Quantity";
            this.olvColumn3.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // olvColumn4
            // 
            this.olvColumn4.AspectName = "ProductLine";
            this.olvColumn4.Text = "Product Line";
            // 
            // olvColumn5
            // 
            this.olvColumn5.AspectName = "Valid";
            this.olvColumn5.Text = "Valid";
            // 
            // olvColumn6
            // 
            this.olvColumn6.AspectName = "Message";
            this.olvColumn6.FillsFreeSpace = true;
            this.olvColumn6.Text = "Message";
            // 
            // DarkHeaderStyle
            // 
            headerStateStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle4.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Hot = headerStateStyle4;
            headerStateStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle5.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Normal = headerStateStyle5;
            headerStateStyle6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle6.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Pressed = headerStateStyle6;
            // 
            // RtvAddInventoryOLV
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.Controls.Add(this.tableLayoutPanel1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "RtvAddInventoryOLV";
            this.Size = new System.Drawing.Size(805, 311);
            this.Load += new System.EventHandler(this.RtvAddInventoryOLVLoad);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.ControlActivePanel.ResumeLayout(false);
            this.ControlActivePanel.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.serialListView)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private Fx.WinForms.Flat.MESCheckButton ActivateDeactivateButton;
        private System.Windows.Forms.TableLayoutPanel ControlActivePanel;
        private System.Windows.Forms.Label ShowHideInstruction;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private Fx.WinForms.Flat.MESButton importButton;
        private Fx.WinForms.Flat.MESButton clearButton;
        private Fx.WinForms.Flat.MESButton addInventoryButton;
        private BrightIdeasSoftware.ObjectListView serialListView;
        private BrightIdeasSoftware.OLVColumn olvColumn1;
        private BrightIdeasSoftware.OLVColumn olvColumn2;
        private BrightIdeasSoftware.OLVColumn olvColumn3;
        private BrightIdeasSoftware.OLVColumn olvColumn4;
        private BrightIdeasSoftware.OLVColumn olvColumn5;
        private BrightIdeasSoftware.OLVColumn olvColumn6;
        private BrightIdeasSoftware.HeaderFormatStyle DarkHeaderStyle;
    }
}