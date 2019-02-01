namespace ValidateStagedSerials
{
    partial class FormMain
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
            this.label1 = new System.Windows.Forms.Label();
            this.tbxShipper = new System.Windows.Forms.TextBox();
            this.btnShipper = new System.Windows.Forms.Button();
            this.lblMissingSerials = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.btnValidate = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.lblInvalidSerials = new System.Windows.Forms.Label();
            this.lblSuccess = new System.Windows.Forms.Label();
            this.lblShipper = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(53, 52);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(128, 20);
            this.label1.TabIndex = 0;
            this.label1.Text = "Enter a shipper:";
            // 
            // tbxShipper
            // 
            this.tbxShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxShipper.Location = new System.Drawing.Point(187, 52);
            this.tbxShipper.Name = "tbxShipper";
            this.tbxShipper.Size = new System.Drawing.Size(100, 27);
            this.tbxShipper.TabIndex = 1;
            // 
            // btnShipper
            // 
            this.btnShipper.BackColor = System.Drawing.Color.White;
            this.btnShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnShipper.Location = new System.Drawing.Point(295, 49);
            this.btnShipper.Name = "btnShipper";
            this.btnShipper.Size = new System.Drawing.Size(75, 32);
            this.btnShipper.TabIndex = 2;
            this.btnShipper.Text = "Enter";
            this.btnShipper.UseVisualStyleBackColor = false;
            // 
            // lblMissingSerials
            // 
            this.lblMissingSerials.AutoSize = true;
            this.lblMissingSerials.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lblMissingSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMissingSerials.ForeColor = System.Drawing.Color.Red;
            this.lblMissingSerials.Location = new System.Drawing.Point(53, 411);
            this.lblMissingSerials.Name = "lblMissingSerials";
            this.lblMissingSerials.Size = new System.Drawing.Size(129, 20);
            this.lblMissingSerials.TabIndex = 5;
            this.lblMissingSerials.Text = "Missing Serials:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(53, 204);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(388, 20);
            this.label3.TabIndex = 6;
            this.label3.Text = "2. Validate scanned serials against staged shipper.";
            // 
            // btnValidate
            // 
            this.btnValidate.BackColor = System.Drawing.Color.White;
            this.btnValidate.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnValidate.Location = new System.Drawing.Point(57, 233);
            this.btnValidate.Name = "btnValidate";
            this.btnValidate.Size = new System.Drawing.Size(187, 49);
            this.btnValidate.TabIndex = 7;
            this.btnValidate.Text = "Validate";
            this.btnValidate.UseVisualStyleBackColor = false;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(53, 163);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(260, 20);
            this.label4.TabIndex = 8;
            this.label4.Text = "1. Copy serials from spreadsheet.";
            // 
            // lblInvalidSerials
            // 
            this.lblInvalidSerials.AutoSize = true;
            this.lblInvalidSerials.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblInvalidSerials.ForeColor = System.Drawing.Color.Red;
            this.lblInvalidSerials.Location = new System.Drawing.Point(53, 449);
            this.lblInvalidSerials.Name = "lblInvalidSerials";
            this.lblInvalidSerials.Size = new System.Drawing.Size(118, 20);
            this.lblInvalidSerials.TabIndex = 6;
            this.lblInvalidSerials.Text = "Invalid Serials:";
            // 
            // lblSuccess
            // 
            this.lblSuccess.AutoSize = true;
            this.lblSuccess.BackColor = System.Drawing.Color.GreenYellow;
            this.lblSuccess.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblSuccess.Location = new System.Drawing.Point(53, 369);
            this.lblSuccess.Name = "lblSuccess";
            this.lblSuccess.Size = new System.Drawing.Size(411, 20);
            this.lblSuccess.TabIndex = 9;
            this.lblSuccess.Text = "Scanned serials match staged serials for this shipper.";
            // 
            // lblShipper
            // 
            this.lblShipper.AutoSize = true;
            this.lblShipper.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblShipper.Location = new System.Drawing.Point(411, 51);
            this.lblShipper.Name = "lblShipper";
            this.lblShipper.Size = new System.Drawing.Size(78, 25);
            this.lblShipper.TabIndex = 10;
            this.lblShipper.Text = "555555";
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.WhiteSmoke;
            this.ClientSize = new System.Drawing.Size(990, 564);
            this.Controls.Add(this.lblShipper);
            this.Controls.Add(this.lblSuccess);
            this.Controls.Add(this.lblMissingSerials);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.lblInvalidSerials);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btnValidate);
            this.Controls.Add(this.btnShipper);
            this.Controls.Add(this.tbxShipper);
            this.Controls.Add(this.label1);
            this.Name = "FormMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Validate Serials";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbxShipper;
        private System.Windows.Forms.Button btnShipper;
        private System.Windows.Forms.Label lblMissingSerials;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnValidate;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lblInvalidSerials;
        private System.Windows.Forms.Label lblSuccess;
        private System.Windows.Forms.Label lblShipper;
    }
}

