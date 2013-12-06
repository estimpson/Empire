namespace SmartDeviceProject1
{
    partial class Form1
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
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.uxMessage = new System.Windows.Forms.Label();
            this.uxListBox1 = new System.Windows.Forms.ListBox();
            this.label2 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.uxCount = new System.Windows.Forms.Label();
            this.button2 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(114, 30);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(100, 21);
            this.textBox1.TabIndex = 8;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular);
            this.label1.Location = new System.Drawing.Point(17, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(100, 22);
            this.label1.Text = "Location:";
            this.label1.ParentChanged += new System.EventHandler(this.label1_ParentChanged);
            // 
            // uxMessage
            // 
            this.uxMessage.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular);
            this.uxMessage.Location = new System.Drawing.Point(27, 228);
            this.uxMessage.Name = "uxMessage";
            this.uxMessage.Size = new System.Drawing.Size(187, 20);
            this.uxMessage.Text = "Waiting For Scan...";
            this.uxMessage.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.uxMessage.ParentChanged += new System.EventHandler(this.uxMessage_ParentChanged);
            // 
            // uxListBox1
            // 
            this.uxListBox1.Location = new System.Drawing.Point(27, 114);
            this.uxListBox1.Name = "uxListBox1";
            this.uxListBox1.Size = new System.Drawing.Size(187, 100);
            this.uxListBox1.TabIndex = 13;
            this.uxListBox1.SelectedIndexChanged += new System.EventHandler(this.uxListBox1_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular);
            this.label2.Location = new System.Drawing.Point(62, 91);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(100, 20);
            this.label2.Text = "Counter:";
            this.label2.ParentChanged += new System.EventHandler(this.label2_ParentChanged);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(36, 57);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(163, 20);
            this.button1.TabIndex = 12;
            this.button1.Text = "Create Super Object";
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // uxCount
            // 
            this.uxCount.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular);
            this.uxCount.Location = new System.Drawing.Point(140, 91);
            this.uxCount.Name = "uxCount";
            this.uxCount.Size = new System.Drawing.Size(74, 20);
            this.uxCount.Text = "0";
            this.uxCount.ParentChanged += new System.EventHandler(this.uxCount_ParentChanged);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(217, 3);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(20, 20);
            this.button2.TabIndex = 16;
            this.button2.Text = "x";
            this.button2.Click += new System.EventHandler(this.button2_Click_1);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.uxCount);
            this.Controls.Add(this.uxMessage);
            this.Controls.Add(this.uxListBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Menu = this.mainMenu1;
            this.Name = "Form1";
            this.Text = "Transfer 1.0";
            this.Load += new System.EventHandler(this.ScanForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label uxMessage;
        private System.Windows.Forms.ListBox uxListBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label uxCount;
        private System.Windows.Forms.Button button2;
    }
}