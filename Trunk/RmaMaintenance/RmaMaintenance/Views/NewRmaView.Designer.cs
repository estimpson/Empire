namespace RmaMaintenance.Views
{
    partial class NewRmaView
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
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.RTVButton = new Fx.WinForms.Flat.MESCheckButton();
            this.RMAButton = new Fx.WinForms.Flat.MESCheckButton();
            this.lblErrorMessage = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.tlpCreateRma = new System.Windows.Forms.TableLayoutPanel();
            this.ucNewRmaCreate1 = new RmaMaintenance.UserControls.ucNewRmaCreate();
            this.tlpOptions = new System.Windows.Forms.TableLayoutPanel();
            this.ucNewRmaOptions1 = new RmaMaintenance.UserControls.ucNewRmaOptions();
            this.panel1 = new System.Windows.Forms.Panel();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.tlpCreateRma.SuspendLayout();
            this.tlpOptions.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.lblErrorMessage, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel3, 0, 1);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(1, 1);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.Padding = new System.Windows.Forms.Padding(20);
            this.tableLayoutPanel1.RowCount = 3;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(1038, 582);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.AutoSize = true;
            this.tableLayoutPanel2.ColumnCount = 3;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel2.Controls.Add(this.linkLblClose, 2, 0);
            this.tableLayoutPanel2.Controls.Add(this.RTVButton, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.RMAButton, 0, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(23, 23);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.Padding = new System.Windows.Forms.Padding(0, 0, 0, 20);
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(992, 61);
            this.tableLayoutPanel2.TabIndex = 0;
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.Location = new System.Drawing.Point(926, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(63, 20);
            this.linkLblClose.TabIndex = 1;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "CLOSE";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LinkLblCloseLinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.LinkLblCloseMouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.LinkLblCloseMouseLeave);
            // 
            // RTVButton
            // 
            this.RTVButton.AutoSize = true;
            this.RTVButton.Checked = false;
            this.RTVButton.CheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.RTVButton.CheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RTVButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.RTVButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.RTVButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RTVButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.RTVButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.RTVButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.RTVButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.RTVButton.Location = new System.Drawing.Point(199, 3);
            this.RTVButton.Name = "RTVButton";
            this.RTVButton.Size = new System.Drawing.Size(159, 35);
            this.RTVButton.TabIndex = 2;
            this.RTVButton.Text = "Create RTV Only";
            this.RTVButton.UncheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.RTVButton.UncheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.RTVButton.UseVisualStyleBackColor = false;
            // 
            // RMAButton
            // 
            this.RMAButton.Checked = true;
            this.RMAButton.CheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.RMAButton.CheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RMAButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.RMAButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.RMAButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RMAButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.RMAButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.RMAButton.Font = new System.Drawing.Font("Tahoma", 14F);
            this.RMAButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.RMAButton.Location = new System.Drawing.Point(3, 3);
            this.RMAButton.Name = "RMAButton";
            this.RMAButton.Size = new System.Drawing.Size(190, 35);
            this.RMAButton.TabIndex = 3;
            this.RMAButton.Text = "Create RMA / RTV";
            this.RMAButton.UncheckedBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.RMAButton.UncheckedColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.RMAButton.UseVisualStyleBackColor = false;
            // 
            // lblErrorMessage
            // 
            this.lblErrorMessage.AutoSize = true;
            this.lblErrorMessage.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblErrorMessage.ForeColor = System.Drawing.Color.Red;
            this.lblErrorMessage.Location = new System.Drawing.Point(23, 567);
            this.lblErrorMessage.Name = "lblErrorMessage";
            this.lblErrorMessage.Size = new System.Drawing.Size(92, 16);
            this.lblErrorMessage.TabIndex = 1;
            this.lblErrorMessage.Text = "Error message";
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.AutoSize = true;
            this.tableLayoutPanel3.ColumnCount = 1;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.tlpCreateRma, 0, 1);
            this.tableLayoutPanel3.Controls.Add(this.tlpOptions, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(23, 90);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 2;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 50F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(992, 474);
            this.tableLayoutPanel3.TabIndex = 2;
            // 
            // tlpCreateRma
            // 
            this.tlpCreateRma.AutoSize = true;
            this.tlpCreateRma.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tlpCreateRma.ColumnCount = 1;
            this.tlpCreateRma.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tlpCreateRma.Controls.Add(this.ucNewRmaCreate1, 0, 0);
            this.tlpCreateRma.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpCreateRma.Location = new System.Drawing.Point(0, 50);
            this.tlpCreateRma.Margin = new System.Windows.Forms.Padding(0);
            this.tlpCreateRma.Name = "tlpCreateRma";
            this.tlpCreateRma.RowCount = 1;
            this.tlpCreateRma.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tlpCreateRma.Size = new System.Drawing.Size(992, 424);
            this.tlpCreateRma.TabIndex = 2;
            // 
            // ucNewRmaCreate1
            // 
            this.ucNewRmaCreate1.AutoSize = true;
            this.ucNewRmaCreate1.BackColor = System.Drawing.Color.Black;
            this.ucNewRmaCreate1.Location = new System.Drawing.Point(3, 3);
            this.ucNewRmaCreate1.Name = "ucNewRmaCreate1";
            this.ucNewRmaCreate1.RMANumber = null;
            this.ucNewRmaCreate1.RTVNumber = null;
            this.ucNewRmaCreate1.ShowOptionOne = false;
            this.ucNewRmaCreate1.Size = new System.Drawing.Size(965, 418);
            this.ucNewRmaCreate1.TabIndex = 0;
            // 
            // tlpOptions
            // 
            this.tlpOptions.ColumnCount = 1;
            this.tlpOptions.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tlpOptions.Controls.Add(this.ucNewRmaOptions1, 0, 0);
            this.tlpOptions.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tlpOptions.Location = new System.Drawing.Point(0, 0);
            this.tlpOptions.Margin = new System.Windows.Forms.Padding(0);
            this.tlpOptions.Name = "tlpOptions";
            this.tlpOptions.RowCount = 1;
            this.tlpOptions.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tlpOptions.Size = new System.Drawing.Size(992, 50);
            this.tlpOptions.TabIndex = 3;
            // 
            // ucNewRmaOptions1
            // 
            this.ucNewRmaOptions1.AutoSize = true;
            this.ucNewRmaOptions1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ucNewRmaOptions1.BackColor = System.Drawing.Color.Black;
            this.ucNewRmaOptions1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ucNewRmaOptions1.Location = new System.Drawing.Point(0, 0);
            this.ucNewRmaOptions1.Margin = new System.Windows.Forms.Padding(0);
            this.ucNewRmaOptions1.Name = "ucNewRmaOptions1";
            this.ucNewRmaOptions1.Padding = new System.Windows.Forms.Padding(0, 0, 0, 10);
            this.ucNewRmaOptions1.RMAMode = true;
            this.ucNewRmaOptions1.RTVMode = false;
            this.ucNewRmaOptions1.ShowOptions = false;
            this.ucNewRmaOptions1.Size = new System.Drawing.Size(992, 50);
            this.ucNewRmaOptions1.TabIndex = 0;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.Black;
            this.panel1.Controls.Add(this.tableLayoutPanel1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1040, 584);
            this.panel1.TabIndex = 1;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.Panel1Paint);
            // 
            // NewRmaView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(151)))), ((int)(((byte)(234)))));
            this.ClientSize = new System.Drawing.Size(1040, 584);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "NewRmaView";
            this.Opacity = 0.96D;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "NewRmaView";
            this.Activated += new System.EventHandler(this.NewRmaViewActivated);
            this.Load += new System.EventHandler(this.NewRmaViewLoad);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.tlpCreateRma.ResumeLayout(false);
            this.tlpCreateRma.PerformLayout();
            this.tlpOptions.ResumeLayout(false);
            this.tlpOptions.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.Label lblErrorMessage;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.TableLayoutPanel tlpCreateRma;
        private System.Windows.Forms.TableLayoutPanel tlpOptions;
        private UserControls.ucNewRmaOptions ucNewRmaOptions1;
        private Fx.WinForms.Flat.MESCheckButton RTVButton;
        private Fx.WinForms.Flat.MESCheckButton RMAButton;
        private UserControls.ucNewRmaCreate ucNewRmaCreate1;
    }
}