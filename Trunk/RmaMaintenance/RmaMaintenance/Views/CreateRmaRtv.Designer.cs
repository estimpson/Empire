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
            this.cbxRmaToLocation = new System.Windows.Forms.ComboBox();
            this.lblInstructionOne = new System.Windows.Forms.Label();
            this.mesBtnCreateRma = new Fx.WinForms.Flat.MESButton();
            this.mesTbxRmaNote = new Fx.WinForms.Flat.MESTextEdit();
            this.lblInstructionThree = new System.Windows.Forms.Label();
            this.lblInstructionTwo = new System.Windows.Forms.Label();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.mesTxtRmaNumber = new Fx.WinForms.Flat.MESTextEdit();
            this.mesBtnAutoGenerateRma = new Fx.WinForms.Flat.MESButton();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.panel1.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
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
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(1);
            this.panel1.Size = new System.Drawing.Size(1384, 716);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(691, 92);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 2, 4, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(66, 20);
            this.label1.TabIndex = 51;
            this.label1.Text = "Serials:";
            // 
            // lbxSerials
            // 
            this.lbxSerials.BackColor = System.Drawing.Color.Black;
            this.lbxSerials.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbxSerials.ForeColor = System.Drawing.Color.White;
            this.lbxSerials.FormattingEnabled = true;
            this.lbxSerials.ItemHeight = 19;
            this.lbxSerials.Location = new System.Drawing.Point(768, 92);
            this.lbxSerials.Margin = new System.Windows.Forms.Padding(4);
            this.lbxSerials.Name = "lbxSerials";
            this.lbxSerials.Size = new System.Drawing.Size(353, 555);
            this.lbxSerials.TabIndex = 50;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.cbxRmaToLocation, 0, 4);
            this.tableLayoutPanel1.Controls.Add(this.lblInstructionOne, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.mesBtnCreateRma, 0, 7);
            this.tableLayoutPanel1.Controls.Add(this.mesTbxRmaNote, 0, 6);
            this.tableLayoutPanel1.Controls.Add(this.lblInstructionThree, 0, 5);
            this.tableLayoutPanel1.Controls.Add(this.lblInstructionTwo, 0, 3);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 1);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(289, 92);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(4);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 8;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(318, 443);
            this.tableLayoutPanel1.TabIndex = 49;
            // 
            // cbxRmaToLocation
            // 
            this.cbxRmaToLocation.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.cbxRmaToLocation.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.cbxRmaToLocation.BackColor = System.Drawing.Color.Black;
            this.cbxRmaToLocation.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbxRmaToLocation.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbxRmaToLocation.ForeColor = System.Drawing.Color.White;
            this.cbxRmaToLocation.FormattingEnabled = true;
            this.cbxRmaToLocation.Location = new System.Drawing.Point(4, 123);
            this.cbxRmaToLocation.Margin = new System.Windows.Forms.Padding(4, 4, 4, 18);
            this.cbxRmaToLocation.Name = "cbxRmaToLocation";
            this.cbxRmaToLocation.Size = new System.Drawing.Size(290, 31);
            this.cbxRmaToLocation.TabIndex = 52;
            // 
            // lblInstructionOne
            // 
            this.lblInstructionOne.AutoSize = true;
            this.lblInstructionOne.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructionOne.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructionOne.Location = new System.Drawing.Point(4, 2);
            this.lblInstructionOne.Margin = new System.Windows.Forms.Padding(4, 2, 4, 4);
            this.lblInstructionOne.Name = "lblInstructionOne";
            this.lblInstructionOne.Size = new System.Drawing.Size(199, 24);
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
            this.mesBtnCreateRma.Location = new System.Drawing.Point(4, 341);
            this.mesBtnCreateRma.Margin = new System.Windows.Forms.Padding(4);
            this.mesBtnCreateRma.Name = "mesBtnCreateRma";
            this.mesBtnCreateRma.Size = new System.Drawing.Size(290, 43);
            this.mesBtnCreateRma.TabIndex = 2;
            this.mesBtnCreateRma.Text = "RMA Serials On Hold";
            this.mesBtnCreateRma.UseVisualStyleBackColor = false;
            this.mesBtnCreateRma.Click += new System.EventHandler(this.mesBtnCreateRma_Click);
            this.mesBtnCreateRma.MouseDown += new System.Windows.Forms.MouseEventHandler(this.mesBtnCreateRma_MouseDown);
            // 
            // mesTbxRmaNote
            // 
            this.mesTbxRmaNote.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTbxRmaNote.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTbxRmaNote.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesTbxRmaNote.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTbxRmaNote.Location = new System.Drawing.Point(4, 206);
            this.mesTbxRmaNote.Margin = new System.Windows.Forms.Padding(4, 4, 4, 18);
            this.mesTbxRmaNote.MaxLength = 110;
            this.mesTbxRmaNote.Multiline = true;
            this.mesTbxRmaNote.Name = "mesTbxRmaNote";
            this.mesTbxRmaNote.Size = new System.Drawing.Size(290, 113);
            this.mesTbxRmaNote.TabIndex = 1;
            // 
            // lblInstructionThree
            // 
            this.lblInstructionThree.AutoSize = true;
            this.lblInstructionThree.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructionThree.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructionThree.Location = new System.Drawing.Point(4, 174);
            this.lblInstructionThree.Margin = new System.Windows.Forms.Padding(4, 2, 4, 4);
            this.lblInstructionThree.Name = "lblInstructionThree";
            this.lblInstructionThree.Size = new System.Drawing.Size(293, 24);
            this.lblInstructionThree.TabIndex = 45;
            this.lblInstructionThree.Text = "Add a note to the RMA (optional): ";
            // 
            // lblInstructionTwo
            // 
            this.lblInstructionTwo.AutoSize = true;
            this.lblInstructionTwo.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInstructionTwo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblInstructionTwo.Location = new System.Drawing.Point(3, 95);
            this.lblInstructionTwo.Name = "lblInstructionTwo";
            this.lblInstructionTwo.Size = new System.Drawing.Size(152, 24);
            this.lblInstructionTwo.TabIndex = 46;
            this.lblInstructionTwo.Text = "Select a location:";
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 210F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.mesTxtRmaNumber, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.mesBtnAutoGenerateRma, 1, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 33);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(312, 59);
            this.tableLayoutPanel2.TabIndex = 53;
            // 
            // mesTxtRmaNumber
            // 
            this.mesTxtRmaNumber.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.mesTxtRmaNumber.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(37)))), ((int)(((byte)(37)))), ((int)(((byte)(38)))));
            this.mesTxtRmaNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.mesTxtRmaNumber.Font = new System.Drawing.Font("Tahoma", 12F);
            this.mesTxtRmaNumber.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesTxtRmaNumber.Location = new System.Drawing.Point(4, 6);
            this.mesTxtRmaNumber.Margin = new System.Windows.Forms.Padding(4, 4, 4, 18);
            this.mesTxtRmaNumber.MaxLength = 50;
            this.mesTxtRmaNumber.Name = "mesTxtRmaNumber";
            this.mesTxtRmaNumber.Size = new System.Drawing.Size(196, 32);
            this.mesTxtRmaNumber.TabIndex = 0;
            // 
            // mesBtnAutoGenerateRma
            // 
            this.mesBtnAutoGenerateRma.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnAutoGenerateRma.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnAutoGenerateRma.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnAutoGenerateRma.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnAutoGenerateRma.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnAutoGenerateRma.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mesBtnAutoGenerateRma.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnAutoGenerateRma.Location = new System.Drawing.Point(213, 3);
            this.mesBtnAutoGenerateRma.Name = "mesBtnAutoGenerateRma";
            this.mesBtnAutoGenerateRma.Size = new System.Drawing.Size(78, 35);
            this.mesBtnAutoGenerateRma.TabIndex = 1;
            this.mesBtnAutoGenerateRma.Text = "Auto";
            this.mesBtnAutoGenerateRma.UseVisualStyleBackColor = false;
            this.mesBtnAutoGenerateRma.Click += new System.EventHandler(this.mesBtnAutoGenerateRma_Click);
            // 
            // linkLblClose
            // 
            this.linkLblClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(1291, 11);
            this.linkLblClose.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(73, 25);
            this.linkLblClose.TabIndex = 3;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "< Back";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // CreateRmaRtv
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1384, 716);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "CreateRmaRtv";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "CreateRmaRtv";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel linkLblClose;
        public Fx.WinForms.Flat.MESTextEdit mesTxtRmaNumber;
        private Fx.WinForms.Flat.MESTextEdit mesTbxRmaNote;
        private System.Windows.Forms.Label lblInstructionThree;
        private System.Windows.Forms.Label lblInstructionOne;
        private Fx.WinForms.Flat.MESButton mesBtnCreateRma;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ListBox lbxSerials;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cbxRmaToLocation;
        private System.Windows.Forms.Label lblInstructionTwo;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private Fx.WinForms.Flat.MESButton mesBtnAutoGenerateRma;
    }
}