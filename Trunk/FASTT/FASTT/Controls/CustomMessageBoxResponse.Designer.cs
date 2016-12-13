namespace FASTT.Controls
{
    partial class CustomMessageBoxResponse
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
            this.mesBtnYes = new Fx.WinForms.Flat.MESButton();
            this.mesBtnNo = new Fx.WinForms.Flat.MESButton();
            this.tbxMessage = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // mesBtnYes
            // 
            this.mesBtnYes.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnYes.DialogResult = System.Windows.Forms.DialogResult.Yes;
            this.mesBtnYes.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnYes.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnYes.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnYes.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnYes.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnYes.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnYes.Location = new System.Drawing.Point(247, 177);
            this.mesBtnYes.Name = "mesBtnYes";
            this.mesBtnYes.Size = new System.Drawing.Size(96, 35);
            this.mesBtnYes.TabIndex = 0;
            this.mesBtnYes.Text = "YES";
            this.mesBtnYes.UseVisualStyleBackColor = false;
            this.mesBtnYes.Click += new System.EventHandler(this.mesBtnYes_Click);
            // 
            // mesBtnNo
            // 
            this.mesBtnNo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(31)))), ((int)(((byte)(31)))), ((int)(((byte)(32)))));
            this.mesBtnNo.DialogResult = System.Windows.Forms.DialogResult.No;
            this.mesBtnNo.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(67)))), ((int)(((byte)(67)))), ((int)(((byte)(70)))));
            this.mesBtnNo.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.mesBtnNo.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(84)))), ((int)(((byte)(92)))));
            this.mesBtnNo.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.mesBtnNo.Font = new System.Drawing.Font("Tahoma", 14F);
            this.mesBtnNo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(240)))), ((int)(((byte)(240)))));
            this.mesBtnNo.Location = new System.Drawing.Point(12, 177);
            this.mesBtnNo.Name = "mesBtnNo";
            this.mesBtnNo.Size = new System.Drawing.Size(96, 35);
            this.mesBtnNo.TabIndex = 1;
            this.mesBtnNo.Text = "NO";
            this.mesBtnNo.UseVisualStyleBackColor = false;
            this.mesBtnNo.Click += new System.EventHandler(this.mesBtnNo_Click);
            // 
            // tbxMessage
            // 
            this.tbxMessage.BackColor = System.Drawing.Color.Black;
            this.tbxMessage.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tbxMessage.Font = new System.Drawing.Font("Tahoma", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxMessage.ForeColor = System.Drawing.Color.White;
            this.tbxMessage.Location = new System.Drawing.Point(12, 12);
            this.tbxMessage.Multiline = true;
            this.tbxMessage.Name = "tbxMessage";
            this.tbxMessage.Size = new System.Drawing.Size(331, 146);
            this.tbxMessage.TabIndex = 2;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.mesBtnNo);
            this.panel1.Controls.Add(this.tbxMessage);
            this.panel1.Controls.Add(this.mesBtnYes);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(355, 224);
            this.panel1.TabIndex = 3;
            // 
            // CustomMessageBoxResponse
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(355, 224);
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.White;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "CustomMessageBoxResponse";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CustomMessageBoxResponse";
            this.Activated += new System.EventHandler(this.CustomMessageBoxResponse_Activated);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private Fx.WinForms.Flat.MESButton mesBtnYes;
        private Fx.WinForms.Flat.MESButton mesBtnNo;
        private System.Windows.Forms.TextBox tbxMessage;
        private System.Windows.Forms.Panel panel1;
    }
}