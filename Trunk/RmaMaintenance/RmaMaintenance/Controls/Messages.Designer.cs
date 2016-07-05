namespace RmaMaintenance.Controls
{
    partial class Messages
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
            this.mesBtnOk = new Fx.WinForms.Flat.MESButton();
            this.tbxMessage = new System.Windows.Forms.TextBox();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.mesBtnOk);
            this.panel1.Controls.Add(this.tbxMessage);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(355, 224);
            this.panel1.TabIndex = 0;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // mesBtnOk
            // 
            this.mesBtnOk.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnOk.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnOk.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnOk.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnOk.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnOk.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnOk.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnOk.Location = new System.Drawing.Point(255, 180);
            this.mesBtnOk.Name = "mesBtnOk";
            this.mesBtnOk.Size = new System.Drawing.Size(88, 35);
            this.mesBtnOk.TabIndex = 1;
            this.mesBtnOk.Text = "OK";
            this.mesBtnOk.UseVisualStyleBackColor = false;
            this.mesBtnOk.Click += new System.EventHandler(this.mesBtnOk_Click);
            // 
            // tbxMessage
            // 
            this.tbxMessage.BackColor = System.Drawing.Color.Black;
            this.tbxMessage.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tbxMessage.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxMessage.ForeColor = System.Drawing.Color.White;
            this.tbxMessage.Location = new System.Drawing.Point(12, 17);
            this.tbxMessage.Multiline = true;
            this.tbxMessage.Name = "tbxMessage";
            this.tbxMessage.Size = new System.Drawing.Size(331, 153);
            this.tbxMessage.TabIndex = 0;
            this.tbxMessage.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // Messages
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(355, 224);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Messages";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "DeleteMessageBox";
            this.Activated += new System.EventHandler(this.MessageBox_Activated);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private Fx.WinForms.Flat.MESButton mesBtnOk;
        private System.Windows.Forms.TextBox tbxMessage;
    }
}