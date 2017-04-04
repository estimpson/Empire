using RmaMaintenance.Views.Helpers;

namespace RmaMaintenance.UserControls
{
    partial class RtvOpenList
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
            openRTVListView.StoreViewPreferences();
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle1 = new BrightIdeasSoftware.HeaderStateStyle();
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle2 = new BrightIdeasSoftware.HeaderStateStyle();
            BrightIdeasSoftware.HeaderStateStyle headerStateStyle3 = new BrightIdeasSoftware.HeaderStateStyle();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.ControlActivePanel = new System.Windows.Forms.Panel();
            this.openRTVListView = new BrightIdeasSoftware.ObjectListView();
            this.olvColumn1 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn2 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn3 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn4 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.olvColumn5 = ((BrightIdeasSoftware.OLVColumn)(new BrightIdeasSoftware.OLVColumn()));
            this.DarkHeaderStyle = new BrightIdeasSoftware.HeaderFormatStyle();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.ActivateDeactivateButton = new Fx.WinForms.Flat.MESCheckButton();
            this.ShowHideInstruction = new System.Windows.Forms.Label();
            this.tableLayoutPanel3.SuspendLayout();
            this.ControlActivePanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.openRTVListView)).BeginInit();
            this.tableLayoutPanel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.AutoSize = true;
            this.tableLayoutPanel3.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel3.ColumnCount = 1;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.ControlActivePanel, 0, 1);
            this.tableLayoutPanel3.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 2;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.Size = new System.Drawing.Size(404, 173);
            this.tableLayoutPanel3.TabIndex = 2;
            // 
            // ControlActivePanel
            // 
            this.ControlActivePanel.Controls.Add(this.openRTVListView);
            this.ControlActivePanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ControlActivePanel.Location = new System.Drawing.Point(3, 44);
            this.ControlActivePanel.Name = "ControlActivePanel";
            this.ControlActivePanel.Size = new System.Drawing.Size(398, 126);
            this.ControlActivePanel.TabIndex = 11;
            // 
            // openRTVListView
            // 
            this.openRTVListView.AllColumns.Add(this.olvColumn1);
            this.openRTVListView.AllColumns.Add(this.olvColumn2);
            this.openRTVListView.AllColumns.Add(this.olvColumn3);
            this.openRTVListView.AllColumns.Add(this.olvColumn4);
            this.openRTVListView.AllColumns.Add(this.olvColumn5);
            this.openRTVListView.AlternateRowBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(29)))), ((int)(((byte)(29)))), ((int)(((byte)(29)))));
            this.openRTVListView.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.openRTVListView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.openRTVListView.CellEditUseWholeCell = false;
            this.openRTVListView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.olvColumn1,
            this.olvColumn2,
            this.olvColumn3,
            this.olvColumn4,
            this.olvColumn5});
            this.openRTVListView.Cursor = System.Windows.Forms.Cursors.Default;
            this.openRTVListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.openRTVListView.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.openRTVListView.FullRowSelect = true;
            this.openRTVListView.HeaderFormatStyle = this.DarkHeaderStyle;
            this.openRTVListView.HideSelection = false;
            this.openRTVListView.Location = new System.Drawing.Point(0, 0);
            this.openRTVListView.Name = "openRTVListView";
            this.openRTVListView.SelectedBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(69)))), ((int)(((byte)(69)))), ((int)(((byte)(69)))));
            this.openRTVListView.ShowImagesOnSubItems = true;
            this.openRTVListView.ShowItemToolTips = true;
            this.openRTVListView.Size = new System.Drawing.Size(398, 126);
            this.openRTVListView.TabIndex = 10;
            this.openRTVListView.UseAlternatingBackColors = true;
            this.openRTVListView.UseCompatibleStateImageBehavior = false;
            this.openRTVListView.UseSubItemCheckBoxes = true;
            this.openRTVListView.View = System.Windows.Forms.View.Details;
            // 
            // olvColumn1
            // 
            this.olvColumn1.AspectName = "RTVShipper";
            this.olvColumn1.Groupable = false;
            this.olvColumn1.IsEditable = false;
            this.olvColumn1.Text = "RTV Number";
            this.olvColumn1.Width = 107;
            // 
            // olvColumn2
            // 
            this.olvColumn2.AspectName = "PackingSlipPrinted";
            this.olvColumn2.CheckBoxes = true;
            this.olvColumn2.Groupable = false;
            this.olvColumn2.IsEditable = false;
            this.olvColumn2.Text = "Printed";
            this.olvColumn2.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.olvColumn2.Width = 72;
            // 
            // olvColumn3
            // 
            this.olvColumn3.AspectName = "HN_RMA_Location";
            this.olvColumn3.Groupable = false;
            this.olvColumn3.IsEditable = false;
            this.olvColumn3.Text = "HN Location";
            this.olvColumn3.Width = 113;
            // 
            // olvColumn4
            // 
            this.olvColumn4.AspectName = "ProductLine";
            this.olvColumn4.Groupable = false;
            this.olvColumn4.IsEditable = false;
            this.olvColumn4.Text = "Product Line";
            this.olvColumn4.Width = 101;
            // 
            // olvColumn5
            // 
            this.olvColumn5.AspectName = "SerialList";
            this.olvColumn5.FillsFreeSpace = true;
            this.olvColumn5.Groupable = false;
            this.olvColumn5.Hideable = false;
            this.olvColumn5.IsEditable = false;
            this.olvColumn5.Text = "Serials";
            // 
            // DarkHeaderStyle
            // 
            headerStateStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle1.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Hot = headerStateStyle1;
            headerStateStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle2.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Normal = headerStateStyle2;
            headerStateStyle3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            headerStateStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            headerStateStyle3.FrameColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.DarkHeaderStyle.Pressed = headerStateStyle3;
            // 
            // tableLayoutPanel2
            // 
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
            this.tableLayoutPanel2.Size = new System.Drawing.Size(404, 41);
            this.tableLayoutPanel2.TabIndex = 9;
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
            this.ActivateDeactivateButton.Location = new System.Drawing.Point(275, 3);
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
            this.ShowHideInstruction.Size = new System.Drawing.Size(257, 20);
            this.ShowHideInstruction.TabIndex = 1;
            this.ShowHideInstruction.Text = "Show to display a list of open RTVs";
            // 
            // RtvOpenList
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(19)))), ((int)(((byte)(19)))), ((int)(((byte)(19)))));
            this.Controls.Add(this.tableLayoutPanel3);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "RtvOpenList";
            this.Size = new System.Drawing.Size(404, 173);
            this.Load += new System.EventHandler(this.RtvOpenListLoad);
            this.tableLayoutPanel3.ResumeLayout(false);
            this.ControlActivePanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.openRTVListView)).EndInit();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.Panel ControlActivePanel;
        private BrightIdeasSoftware.ObjectListView openRTVListView;
        private BrightIdeasSoftware.OLVColumn olvColumn1;
        private BrightIdeasSoftware.OLVColumn olvColumn2;
        private BrightIdeasSoftware.OLVColumn olvColumn3;
        private BrightIdeasSoftware.OLVColumn olvColumn4;
        private BrightIdeasSoftware.OLVColumn olvColumn5;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private Fx.WinForms.Flat.MESCheckButton ActivateDeactivateButton;
        private System.Windows.Forms.Label ShowHideInstruction;
        private BrightIdeasSoftware.HeaderFormatStyle DarkHeaderStyle;


    }
}
