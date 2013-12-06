namespace Controls
{
    partial class MessageBoxControl
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
            this.ucMessageBox = new System.Windows.Forms.Label();
            this.ucPrevMessage = new System.Windows.Forms.Button();
            this.ucNextMessage = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // ucMessageBox
            // 
            this.ucMessageBox.BackColor = System.Drawing.Color.White;
            this.ucMessageBox.Location = new System.Drawing.Point(20, 0);
            this.ucMessageBox.Name = "ucMessageBox";
            this.ucMessageBox.Size = new System.Drawing.Size(198, 54);
            this.ucMessageBox.Text = "Message";
            this.ucMessageBox.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.ucMessageBox.TextChanged += new System.EventHandler(this.MessageBoxControl_TextChanged);
            // 
            // ucPrevMessage
            // 
            this.ucPrevMessage.Location = new System.Drawing.Point(0, 0);
            this.ucPrevMessage.Name = "ucPrevMessage";
            this.ucPrevMessage.Size = new System.Drawing.Size(19, 54);
            this.ucPrevMessage.TabIndex = 1;
            this.ucPrevMessage.Text = "<";
            this.ucPrevMessage.Click += new System.EventHandler(this.ucPrevMessage_Click);
            // 
            // ucNextMessage
            // 
            this.ucNextMessage.Location = new System.Drawing.Point(219, 0);
            this.ucNextMessage.Name = "ucNextMessage";
            this.ucNextMessage.Size = new System.Drawing.Size(19, 54);
            this.ucNextMessage.TabIndex = 2;
            this.ucNextMessage.Text = ">";
            this.ucNextMessage.Click += new System.EventHandler(this.ucNextMessage_Click);
            // 
            // MessageBoxControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.Controls.Add(this.ucNextMessage);
            this.Controls.Add(this.ucPrevMessage);
            this.Controls.Add(this.ucMessageBox);
            this.Name = "MessageBoxControl";
            this.Size = new System.Drawing.Size(238, 55);
            this.ResumeLayout(false);

        }

        #endregion

        public System.Windows.Forms.Label ucMessageBox;
        public System.Windows.Forms.Button ucPrevMessage;
        public System.Windows.Forms.Button ucNextMessage;

    }
}
