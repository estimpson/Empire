namespace RmaMaintenance.Views
{
    partial class CreateRmaRtv
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
            this.label1 = new System.Windows.Forms.Label();
            this.lbxSerials = new System.Windows.Forms.ListBox();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.lblInstructionOne = new System.Windows.Forms.Label();
            this.mesBtnCreateRma = new Fx.WinForms.Flat.MESButton();
            this.mesTxtRmaNumber = new Fx.WinForms.Flat.MESTextEdit();
            this.lblInstructionTwo = new System.Windows.Forms.Label();
            this.mesTbxRmaNote = new Fx.WinForms.Flat.MESTextEdit();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.panel1.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.lbxSerials);
            this.panel1.Controls.Add(this.tableLayoutPanel1);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1038, 582);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(518, 75);
            this.label1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 3);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 16);
            this.label1.TabIndex = 51;
            this.label1.Text = "Serials:";
            // 
            // lbxSerials
            // 
            this.lbxSerials.BackColor = System.Drawing.Color.Black;
            this.lbxSerials.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbxSerials.ForeColor = System.Drawing.Color.White;
            this.lbxSerials.FormattingEnabled = true;
            this.lbxSerials.ItemHeight = 16;
            this.lbxSerials.Location = new System.Drawing.Point(576, 75);
            this.lbxSerials.Name = "lbxSerials";
            this.lbxSerials.Size = new System.Drawing.Size(266, 452);
            this.lbxSerials.TabIndex = 50;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.AutoSize = true;
            this.tableLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.lblInstructionOne, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.mesBtnCreateRma, 0, 5);
            this.tableLayoutPanel1.Controls.Add(this.mesTxtRmaNumber, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.lblInstructionTwo, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.mesTbxRmaNote, 0, 3);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(217, 75);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 6;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(236, 242);
            this.tableLayoutPanel1.TabIndex = 49;
            // 
            // lblInstructionOne
            // 
            this.lblInstructionOne.AutoSize = true;
            this.lblInstructionOne.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructionOne.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructionOne.Location = new System.Drawing.Point(3, 2);
            this.lblInstructionOne.Margin = new System.Windows.Forms.Padding(3, 2, 3, 3);
            this.lblInstructionOne.Name = "lblInstructionOne";
            this.lblInstructionOne.Size = new System.Drawing.Size(157, 18);
            this.lblInstructionOne.TabIndex = 44;
            this.lblInstructionOne.Text = "Enter a Quality RMA #:";
            // 
            // mesBtnCreateRma
            // 
            this.mesBtnCreateRma.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnCreateRma.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnCreateRma.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnCreateRma.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnCreateRma.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnCreateRma.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnCreateRma.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnCreateRma.Location = new System.Drawing.Point(3, 204);
            this.mesBtnCreateRma.Name = "mesBtnCreateRma";
            this.mesBtnCreateRma.Size = new System.Drawing.Size(205, 35);
            this.mesBtnCreateRma.TabIndex = 2;
            this.mesBtnCreateRma.Text = "RMA Serials On Hold";
            this.mesBtnCreateRma.UseVisualStyleBackColor = false;
            this.mesBtnCreateRma.Click += new System.EventHandler(this.mesBtnCreateRma_Click);
            this.mesBtnCreateRma.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnCreateRma_MouseDown);
            // 
            // mesTxtRmaNumber
            // 
            this.mesTxtRmaNumber.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.mesTxtRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtRmaNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtRmaNumber.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtRmaNumber.Location = new System.Drawing.Point(3, 26);
            this.mesTxtRmaNumber.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.mesTxtRmaNumber.MaxLength = 50;
            this.mesTxtRmaNumber.Name = "mesTxtRmaNumber";
            this.mesTxtRmaNumber.Size = new System.Drawing.Size(205, 27);
            this.mesTxtRmaNumber.TabIndex = 0;
            // 
            // lblInstructionTwo
            // 
            this.lblInstructionTwo.AutoSize = true;
            this.lblInstructionTwo.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructionTwo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructionTwo.Location = new System.Drawing.Point(3, 70);
            this.lblInstructionTwo.Margin = new System.Windows.Forms.Padding(3, 2, 3, 3);
            this.lblInstructionTwo.Name = "lblInstructionTwo";
            this.lblInstructionTwo.Size = new System.Drawing.Size(230, 18);
            this.lblInstructionTwo.TabIndex = 45;
            this.lblInstructionTwo.Text = "Add a note to the RMA (optional): ";
            // 
            // mesTbxRmaNote
            // 
            this.mesTbxRmaNote.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaNote.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaNote.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesTbxRmaNote.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaNote.Location = new System.Drawing.Point(3, 94);
            this.mesTbxRmaNote.Margin = new System.Windows.Forms.Padding(3, 3, 3, 15);
            this.mesTbxRmaNote.MaxLength = 110;
            this.mesTbxRmaNote.Multiline = true;
            this.mesTbxRmaNote.Name = "mesTbxRmaNote";
            this.mesTbxRmaNote.Size = new System.Drawing.Size(205, 92);
            this.mesTbxRmaNote.TabIndex = 1;
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(968, 9);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(58, 20);
            this.linkLblClose.TabIndex = 3;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // CreateRmaRtv
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1038, 582);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "CreateRmaRtv";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "CreateRmaRtv";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        public Fx.WinForms.Flat.MESTextEdit mesTxtRmaNumber;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaNote;
        private System.Windows.Forms.Label lblInstructionTwo;
        private System.Windows.Forms.Label lblInstructionOne;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRma;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ListBox lbxSerials;
        private System.Windows.Forms.Label label1;
    }
}