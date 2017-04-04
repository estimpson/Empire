namespace RmaMaintenance.Views
{
    partial class NewRtvView
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
            this.panelMain = new System.Windows.Forms.Panel();
            this.tablePanel = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.warningsLabel = new System.Windows.Forms.Label();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.newButton = new Fx.WinForms.Flat.MESCheckButton();
            this.lookupButton = new Fx.WinForms.Flat.MESCheckButton();
            this.rtvNumberLabel = new System.Windows.Forms.Label();
            this.tableLayoutScrollPanel = new System.Windows.Forms.TableLayoutPanel();
            this.rtvPrintSend1 = new RmaMaintenance.UserControls.RtvPrintSend();
            this.rtvAddInventoryOLV1 = new RmaMaintenance.UserControls.RtvAddInventoryOLV();
            this.rtvOpenList1 = new RmaMaintenance.UserControls.RtvOpenList();
            this.panelMain.SuspendLayout();
            this.tablePanel.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutScrollPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelMain
            // 
            this.panelMain.BackColor = System.Drawing.Color.Black;
            this.panelMain.Controls.Add(this.tablePanel);
            this.panelMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelMain.Location = new System.Drawing.Point(1, 1);
            this.panelMain.Margin = new System.Windows.Forms.Padding(0);
            this.panelMain.Name = "panelMain";
            this.panelMain.Padding = new System.Windows.Forms.Padding(20);
            this.panelMain.Size = new System.Drawing.Size(1038, 582);
            this.panelMain.TabIndex = 0;
            // 
            // tablePanel
            // 
            this.tablePanel.ColumnCount = 1;
            this.tablePanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tablePanel.Controls.Add(this.label1, 0, 3);
            this.tablePanel.Controls.Add(this.warningsLabel, 0, 4);
            this.tablePanel.Controls.Add(this.tableLayoutPanel1, 0, 0);
            this.tablePanel.Controls.Add(this.tableLayoutScrollPanel, 0, 2);
            this.tablePanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tablePanel.Location = new System.Drawing.Point(20, 20);
            this.tablePanel.Name = "tablePanel";
            this.tablePanel.RowCount = 5;
            this.tablePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tablePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tablePanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tablePanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tablePanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 60F));
            this.tablePanel.Size = new System.Drawing.Size(998, 542);
            this.tablePanel.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.label1.Location = new System.Drawing.Point(3, 469);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(992, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Instructions";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // warningsLabel
            // 
            this.warningsLabel.AutoSize = true;
            this.warningsLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.warningsLabel.ForeColor = System.Drawing.Color.Red;
            this.warningsLabel.Location = new System.Drawing.Point(3, 482);
            this.warningsLabel.Name = "warningsLabel";
            this.warningsLabel.Size = new System.Drawing.Size(992, 60);
            this.warningsLabel.TabIndex = 2;
            this.warningsLabel.Text = "Warnings / Errors";
            this.warningsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.AutoSize = true;
            this.tableLayoutPanel1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.tableLayoutPanel1.ColumnCount = 4;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.Controls.Add(this.linkLblClose, 3, 0);
            this.tableLayoutPanel1.Controls.Add(this.newButton, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.lookupButton, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.rtvNumberLabel, 2, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(992, 45);
            this.tableLayoutPanel1.TabIndex = 3;
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(926, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(63, 20);
            this.linkLblClose.TabIndex = 2;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "CLOSE";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LinkLblCloseLinkClicked);
            // 
            // newButton
            // 
            this.newButton.Checked = false;
            this.newButton.CheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.newButton.CheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.newButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.newButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.newButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.newButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.newButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.newButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.newButton.Location = new System.Drawing.Point(5, 5);
            this.newButton.Margin = new System.Windows.Forms.Padding(5);
            this.newButton.Name = "newButton";
            this.newButton.Size = new System.Drawing.Size(150, 35);
            this.newButton.TabIndex = 3;
            this.newButton.Text = "New";
            this.newButton.UncheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.newButton.UncheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.newButton.UseVisualStyleBackColor = false;
            // 
            // lookupButton
            // 
            this.lookupButton.Checked = false;
            this.lookupButton.CheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.lookupButton.CheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lookupButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.lookupButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lookupButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.lookupButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.lookupButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.lookupButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.lookupButton.Location = new System.Drawing.Point(165, 5);
            this.lookupButton.Margin = new System.Windows.Forms.Padding(5);
            this.lookupButton.Name = "lookupButton";
            this.lookupButton.Size = new System.Drawing.Size(150, 35);
            this.lookupButton.TabIndex = 4;
            this.lookupButton.Text = "Lookup";
            this.lookupButton.UncheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.lookupButton.UncheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.lookupButton.UseVisualStyleBackColor = false;
            // 
            // rtvNumberLabel
            // 
            this.rtvNumberLabel.AutoSize = true;
            this.rtvNumberLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rtvNumberLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rtvNumberLabel.ForeColor = System.Drawing.Color.Red;
            this.rtvNumberLabel.Location = new System.Drawing.Point(323, 0);
            this.rtvNumberLabel.Name = "rtvNumberLabel";
            this.rtvNumberLabel.Size = new System.Drawing.Size(597, 45);
            this.rtvNumberLabel.TabIndex = 5;
            this.rtvNumberLabel.Text = "RTV Number";
            this.rtvNumberLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutScrollPanel
            // 
            this.tableLayoutScrollPanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutScrollPanel.ColumnCount = 1;
            this.tableLayoutScrollPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutScrollPanel.Controls.Add(this.rtvPrintSend1, 0, 2);
            this.tableLayoutScrollPanel.Controls.Add(this.rtvAddInventoryOLV1, 0, 0);
            this.tableLayoutScrollPanel.Controls.Add(this.rtvOpenList1, 0, 1);
            this.tableLayoutScrollPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutScrollPanel.Location = new System.Drawing.Point(3, 54);
            this.tableLayoutScrollPanel.Name = "tableLayoutScrollPanel";
            this.tableLayoutScrollPanel.RowCount = 3;
            this.tableLayoutScrollPanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutScrollPanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutScrollPanel.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutScrollPanel.Size = new System.Drawing.Size(992, 412);
            this.tableLayoutScrollPanel.TabIndex = 7;
            // 
            // rtvPrintSend1
            // 
            this.rtvPrintSend1.AutoSize = true;
            this.rtvPrintSend1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.rtvPrintSend1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.rtvPrintSend1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rtvPrintSend1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.rtvPrintSend1.Location = new System.Drawing.Point(3, 105);
            this.rtvPrintSend1.Name = "rtvPrintSend1";
            this.rtvPrintSend1.Size = new System.Drawing.Size(986, 304);
            this.rtvPrintSend1.TabIndex = 6;
            // 
            // rtvAddInventoryOLV1
            // 
            this.rtvAddInventoryOLV1.AutoSize = true;
            this.rtvAddInventoryOLV1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.rtvAddInventoryOLV1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.rtvAddInventoryOLV1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rtvAddInventoryOLV1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rtvAddInventoryOLV1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.rtvAddInventoryOLV1.IsControlActive = false;
            this.rtvAddInventoryOLV1.Location = new System.Drawing.Point(4, 5);
            this.rtvAddInventoryOLV1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.rtvAddInventoryOLV1.Name = "rtvAddInventoryOLV1";
            this.rtvAddInventoryOLV1.SerialList = null;
            this.rtvAddInventoryOLV1.Size = new System.Drawing.Size(984, 41);
            this.rtvAddInventoryOLV1.TabIndex = 7;
            // 
            // rtvOpenList1
            // 
            this.rtvOpenList1.AutoSize = true;
            this.rtvOpenList1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.rtvOpenList1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.rtvOpenList1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rtvOpenList1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rtvOpenList1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.rtvOpenList1.IsControlActive = false;
            this.rtvOpenList1.Location = new System.Drawing.Point(4, 56);
            this.rtvOpenList1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.rtvOpenList1.Name = "rtvOpenList1";
            this.rtvOpenList1.OpenRTVList = null;
            this.rtvOpenList1.Size = new System.Drawing.Size(984, 41);
            this.rtvOpenList1.TabIndex = 8;
            // 
            // NewRtvView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.ClientSize = new System.Drawing.Size(1040, 584);
            this.ControlBox = false;
            this.Controls.Add(this.panelMain);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "NewRtvView";
            this.Opacity = 0.96D;
            this.Padding = new System.Windows.Forms.Padding(1);
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "NewRtvView";
            this.panelMain.ResumeLayout(false);
            this.tablePanel.ResumeLayout(false);
            this.tablePanel.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutScrollPanel.ResumeLayout(false);
            this.tableLayoutScrollPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelMain;
        private System.Windows.Forms.TableLayoutPanel tablePanel;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label warningsLabel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private Fx.WinForms.Flat.MESCheckButton newButton;
        private Fx.WinForms.Flat.MESCheckButton lookupButton;
        private UserControls.RtvPrintSend rtvPrintSend1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutScrollPanel;
        private System.Windows.Forms.Label rtvNumberLabel;
        private UserControls.RtvAddInventoryOLV rtvAddInventoryOLV1;
        private UserControls.RtvOpenList rtvOpenList1;

    }
}