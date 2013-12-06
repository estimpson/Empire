namespace Controls
{
    partial class LogOnOffControl
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
            this.lblOperator = new System.Windows.Forms.Label();
            this.btnLogOnOff = new System.Windows.Forms.Button();
            this.txtOperator = new System.Windows.Forms.TextBox();
            this.tbxOpCode = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // lblOperator
            // 
            this.lblOperator.Location = new System.Drawing.Point(3, 6);
            this.lblOperator.Name = "lblOperator";
            this.lblOperator.Size = new System.Drawing.Size(60, 20);
            this.lblOperator.Text = "Operator:";
            // 
            // btnLogOnOff
            // 
            this.btnLogOnOff.Location = new System.Drawing.Point(168, 5);
            this.btnLogOnOff.Name = "btnLogOnOff";
            this.btnLogOnOff.Size = new System.Drawing.Size(66, 20);
            this.btnLogOnOff.TabIndex = 2;
            this.btnLogOnOff.Text = "Log On";
            this.btnLogOnOff.Click += new System.EventHandler(this.BtnLogOnOffClick);
            // 
            // txtOperator
            // 
            this.txtOperator.Location = new System.Drawing.Point(64, 4);
            this.txtOperator.Name = "txtOperator";
            this.txtOperator.Size = new System.Drawing.Size(98, 21);
            this.txtOperator.TabIndex = 2;
            this.txtOperator.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.TxtOperatorKeyPress);
            // 
            // tbxOpCode
            // 
            this.tbxOpCode.Location = new System.Drawing.Point(64, 4);
            this.tbxOpCode.Name = "tbxOpCode";
            this.tbxOpCode.PasswordChar = '*';
            this.tbxOpCode.Size = new System.Drawing.Size(90, 21);
            this.tbxOpCode.TabIndex = 1;
            this.tbxOpCode.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.TbxOpCodeKeyPress);
            // 
            // LogOnOffControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.tbxOpCode);
            this.Controls.Add(this.txtOperator);
            this.Controls.Add(this.btnLogOnOff);
            this.Controls.Add(this.lblOperator);
            this.Name = "LogOnOffControl";
            this.Size = new System.Drawing.Size(241, 28);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label lblOperator;
        private System.Windows.Forms.Button btnLogOnOff;
        public System.Windows.Forms.TextBox txtOperator;
        private System.Windows.Forms.TextBox tbxOpCode;
    }
}
