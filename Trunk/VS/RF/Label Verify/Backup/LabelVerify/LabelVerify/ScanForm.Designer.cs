using SymbolRFGun;

namespace LabelVerify
{
    partial class ScanForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenu1;
        
    
 
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
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.txPart = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtQty = new System.Windows.Forms.TextBox();
            this.lblCount = new System.Windows.Forms.Label();
            this.uxWhitePart = new System.Windows.Forms.TextBox();
            this.uxWhiteQty = new System.Windows.Forms.TextBox();
            this.lblScanCount = new System.Windows.Forms.Label();
            this.uxYellowPart = new System.Windows.Forms.TextBox();
            this.uxYellowQty = new System.Windows.Forms.TextBox();
            this.uxReset = new System.Windows.Forms.Button();
            this.uxWhitePartEnter = new System.Windows.Forms.Button();
            this.uxWhiteQtyEnter = new System.Windows.Forms.Button();
            this.uxYellowQtyEnter = new System.Windows.Forms.Button();
            this.uxYellowPartEnter = new System.Windows.Forms.Button();
            this.uxWP = new System.Windows.Forms.Label();
            this.uxWQ = new System.Windows.Forms.Label();
            this.uxYQ = new System.Windows.Forms.Label();
            this.uxYP = new System.Windows.Forms.Label();
            this.uxMessage = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // txPart
            // 
            this.txPart.Location = new System.Drawing.Point(59, 47);
            this.txPart.Name = "txPart";
            this.txPart.Size = new System.Drawing.Size(168, 21);
            this.txPart.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(3, 44);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(41, 24);
            this.label1.Text = "Part:";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(10, 94);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(34, 25);
            this.label2.Text = "Qty:";
            // 
            // txtQty
            // 
            this.txtQty.Location = new System.Drawing.Point(59, 93);
            this.txtQty.Name = "txtQty";
            this.txtQty.Size = new System.Drawing.Size(168, 21);
            this.txtQty.TabIndex = 3;
            // 
            // lblCount
            // 
            this.lblCount.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold);
            this.lblCount.Location = new System.Drawing.Point(43, 7);
            this.lblCount.Name = "lblCount";
            this.lblCount.Size = new System.Drawing.Size(141, 20);
            this.lblCount.Text = "Scan Count: 0";
            this.lblCount.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // uxWhitePart
            // 
            this.uxWhitePart.Location = new System.Drawing.Point(39, 61);
            this.uxWhitePart.Name = "uxWhitePart";
            this.uxWhitePart.Size = new System.Drawing.Size(132, 21);
            this.uxWhitePart.TabIndex = 0;
            // 
            // uxWhiteQty
            // 
            this.uxWhiteQty.Location = new System.Drawing.Point(39, 93);
            this.uxWhiteQty.Name = "uxWhiteQty";
            this.uxWhiteQty.Size = new System.Drawing.Size(131, 21);
            this.uxWhiteQty.TabIndex = 1;
            // 
            // lblScanCount
            // 
            this.lblScanCount.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Bold);
            this.lblScanCount.Location = new System.Drawing.Point(22, 8);
            this.lblScanCount.Name = "lblScanCount";
            this.lblScanCount.Size = new System.Drawing.Size(198, 36);
            this.lblScanCount.Text = "Scan Count:0";
            this.lblScanCount.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.lblScanCount.ParentChanged += new System.EventHandler(this.lblScanCount_ParentChanged);
            // 
            // uxYellowPart
            // 
            this.uxYellowPart.BackColor = System.Drawing.SystemColors.Info;
            this.uxYellowPart.Location = new System.Drawing.Point(39, 143);
            this.uxYellowPart.Name = "uxYellowPart";
            this.uxYellowPart.Size = new System.Drawing.Size(129, 21);
            this.uxYellowPart.TabIndex = 3;
            // 
            // uxYellowQty
            // 
            this.uxYellowQty.BackColor = System.Drawing.SystemColors.Info;
            this.uxYellowQty.Location = new System.Drawing.Point(39, 176);
            this.uxYellowQty.Name = "uxYellowQty";
            this.uxYellowQty.Size = new System.Drawing.Size(129, 21);
            this.uxYellowQty.TabIndex = 4;
            this.uxYellowQty.TextChanged += new System.EventHandler(this.uxYellowQty_TextChanged);
            // 
            // uxReset
            // 
            this.uxReset.Location = new System.Drawing.Point(65, 239);
            this.uxReset.Name = "uxReset";
            this.uxReset.Size = new System.Drawing.Size(114, 40);
            this.uxReset.TabIndex = 5;
            this.uxReset.Text = "Reset Counter";
            this.uxReset.Click += new System.EventHandler(this.uxReset_Click);
            // 
            // uxWhitePartEnter
            // 
            this.uxWhitePartEnter.Location = new System.Drawing.Point(178, 62);
            this.uxWhitePartEnter.Name = "uxWhitePartEnter";
            this.uxWhitePartEnter.Size = new System.Drawing.Size(54, 20);
            this.uxWhitePartEnter.TabIndex = 6;
            this.uxWhitePartEnter.Text = "Enter";
            this.uxWhitePartEnter.Visible = false;
            this.uxWhitePartEnter.Click += new System.EventHandler(this.uxWhitePartEnter_Click);
            // 
            // uxWhiteQtyEnter
            // 
            this.uxWhiteQtyEnter.Location = new System.Drawing.Point(178, 95);
            this.uxWhiteQtyEnter.Name = "uxWhiteQtyEnter";
            this.uxWhiteQtyEnter.Size = new System.Drawing.Size(54, 19);
            this.uxWhiteQtyEnter.TabIndex = 7;
            this.uxWhiteQtyEnter.Text = "Enter";
            this.uxWhiteQtyEnter.Visible = false;
            this.uxWhiteQtyEnter.Click += new System.EventHandler(this.uxWhiteQtyEnter_Click);
            // 
            // uxYellowQtyEnter
            // 
            this.uxYellowQtyEnter.Location = new System.Drawing.Point(178, 177);
            this.uxYellowQtyEnter.Name = "uxYellowQtyEnter";
            this.uxYellowQtyEnter.Size = new System.Drawing.Size(54, 19);
            this.uxYellowQtyEnter.TabIndex = 9;
            this.uxYellowQtyEnter.Text = "Enter";
            this.uxYellowQtyEnter.Visible = false;
            this.uxYellowQtyEnter.Click += new System.EventHandler(this.uxYellowQtyEnter_Click);
            // 
            // uxYellowPartEnter
            // 
            this.uxYellowPartEnter.Location = new System.Drawing.Point(178, 144);
            this.uxYellowPartEnter.Name = "uxYellowPartEnter";
            this.uxYellowPartEnter.Size = new System.Drawing.Size(54, 20);
            this.uxYellowPartEnter.TabIndex = 8;
            this.uxYellowPartEnter.Text = "Enter";
            this.uxYellowPartEnter.Visible = false;
            this.uxYellowPartEnter.Click += new System.EventHandler(this.uxYellowPartEnter_Click);
            // 
            // uxWP
            // 
            this.uxWP.Location = new System.Drawing.Point(5, 62);
            this.uxWP.Name = "uxWP";
            this.uxWP.Size = new System.Drawing.Size(28, 20);
            this.uxWP.Text = "WP:";
            // 
            // uxWQ
            // 
            this.uxWQ.Location = new System.Drawing.Point(5, 93);
            this.uxWQ.Name = "uxWQ";
            this.uxWQ.Size = new System.Drawing.Size(28, 20);
            this.uxWQ.Text = "WQ:";
            // 
            // uxYQ
            // 
            this.uxYQ.BackColor = System.Drawing.SystemColors.Info;
            this.uxYQ.Location = new System.Drawing.Point(5, 175);
            this.uxYQ.Name = "uxYQ";
            this.uxYQ.Size = new System.Drawing.Size(28, 20);
            this.uxYQ.Text = "YQ:";
            // 
            // uxYP
            // 
            this.uxYP.BackColor = System.Drawing.SystemColors.Info;
            this.uxYP.Location = new System.Drawing.Point(5, 144);
            this.uxYP.Name = "uxYP";
            this.uxYP.Size = new System.Drawing.Size(28, 20);
            this.uxYP.Text = "YP:";
            // 
            // uxMessage
            // 
            this.uxMessage.Location = new System.Drawing.Point(14, 209);
            this.uxMessage.Name = "uxMessage";
            this.uxMessage.Size = new System.Drawing.Size(212, 18);
            this.uxMessage.Text = "Waiting for Scan...";
            this.uxMessage.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // ScanForm
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit;
            this.ClientSize = new System.Drawing.Size(240, 294);
            this.Controls.Add(this.uxMessage);
            this.Controls.Add(this.uxYQ);
            this.Controls.Add(this.uxYP);
            this.Controls.Add(this.uxWQ);
            this.Controls.Add(this.uxWP);
            this.Controls.Add(this.uxYellowQtyEnter);
            this.Controls.Add(this.uxYellowPartEnter);
            this.Controls.Add(this.uxWhiteQtyEnter);
            this.Controls.Add(this.uxWhitePartEnter);
            this.Controls.Add(this.uxReset);
            this.Controls.Add(this.uxYellowQty);
            this.Controls.Add(this.uxYellowPart);
            this.Controls.Add(this.lblScanCount);
            this.Controls.Add(this.uxWhiteQty);
            this.Controls.Add(this.uxWhitePart);
            this.Name = "ScanForm";
            this.Text = "Label Verify 1.0";
            this.Load += new System.EventHandler(this.ScanForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox txPart;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtQty;
        private System.Windows.Forms.Label lblCount;
        private System.Windows.Forms.TextBox uxWhitePart;
        private System.Windows.Forms.TextBox uxWhiteQty;
        private System.Windows.Forms.Label lblScanCount;
        private System.Windows.Forms.TextBox uxYellowPart;
        private System.Windows.Forms.TextBox uxYellowQty;
        private System.Windows.Forms.Button uxReset;
        private System.Windows.Forms.Button uxWhitePartEnter;
        private System.Windows.Forms.Button uxWhiteQtyEnter;
        private System.Windows.Forms.Button uxYellowQtyEnter;
        private System.Windows.Forms.Button uxYellowPartEnter;
        private System.Windows.Forms.Label uxWP;
        private System.Windows.Forms.Label uxWQ;
        private System.Windows.Forms.Label uxYQ;
        private System.Windows.Forms.Label uxYP;
        private System.Windows.Forms.Label uxMessage;
    }
}

