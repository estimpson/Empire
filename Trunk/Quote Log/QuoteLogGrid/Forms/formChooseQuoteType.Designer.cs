namespace QuoteLogGrid.Forms
{
    partial class formChooseQuoteType
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
            this.rbtnNewQuote = new System.Windows.Forms.RadioButton();
            this.rbtnCopyQuote = new System.Windows.Forms.RadioButton();
            this.rbtnBomModification = new System.Windows.Forms.RadioButton();
            this.rbtnPriceChange = new System.Windows.Forms.RadioButton();
            this.btnOK = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.rbtnModifyExisting = new System.Windows.Forms.RadioButton();
            this.SuspendLayout();
            // 
            // rbtnNewQuote
            // 
            this.rbtnNewQuote.AutoSize = true;
            this.rbtnNewQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnNewQuote.Location = new System.Drawing.Point(49, 58);
            this.rbtnNewQuote.Name = "rbtnNewQuote";
            this.rbtnNewQuote.Size = new System.Drawing.Size(96, 21);
            this.rbtnNewQuote.TabIndex = 0;
            this.rbtnNewQuote.TabStop = true;
            this.rbtnNewQuote.Text = "New Quote";
            this.rbtnNewQuote.UseVisualStyleBackColor = true;
            this.rbtnNewQuote.CheckedChanged += new System.EventHandler(this.rbtnNewQuote_CheckedChanged);
            // 
            // rbtnCopyQuote
            // 
            this.rbtnCopyQuote.AutoSize = true;
            this.rbtnCopyQuote.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnCopyQuote.Location = new System.Drawing.Point(49, 93);
            this.rbtnCopyQuote.Name = "rbtnCopyQuote";
            this.rbtnCopyQuote.Size = new System.Drawing.Size(101, 21);
            this.rbtnCopyQuote.TabIndex = 1;
            this.rbtnCopyQuote.TabStop = true;
            this.rbtnCopyQuote.Text = "Copy Quote";
            this.rbtnCopyQuote.UseVisualStyleBackColor = true;
            this.rbtnCopyQuote.CheckedChanged += new System.EventHandler(this.rbtnCopyQuote_CheckedChanged);
            // 
            // rbtnBomModification
            // 
            this.rbtnBomModification.AutoSize = true;
            this.rbtnBomModification.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnBomModification.Location = new System.Drawing.Point(49, 127);
            this.rbtnBomModification.Name = "rbtnBomModification";
            this.rbtnBomModification.Size = new System.Drawing.Size(136, 21);
            this.rbtnBomModification.TabIndex = 2;
            this.rbtnBomModification.TabStop = true;
            this.rbtnBomModification.Text = "BOM Modification";
            this.rbtnBomModification.UseVisualStyleBackColor = true;
            this.rbtnBomModification.CheckedChanged += new System.EventHandler(this.rbtnBomModification_CheckedChanged);
            // 
            // rbtnPriceChange
            // 
            this.rbtnPriceChange.AutoSize = true;
            this.rbtnPriceChange.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnPriceChange.Location = new System.Drawing.Point(49, 161);
            this.rbtnPriceChange.Name = "rbtnPriceChange";
            this.rbtnPriceChange.Size = new System.Drawing.Size(111, 21);
            this.rbtnPriceChange.TabIndex = 3;
            this.rbtnPriceChange.TabStop = true;
            this.rbtnPriceChange.Text = "Price Change";
            this.rbtnPriceChange.UseVisualStyleBackColor = true;
            this.rbtnPriceChange.CheckedChanged += new System.EventHandler(this.rbtnPriceChange_CheckedChanged);
            // 
            // btnOK
            // 
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnOK.Location = new System.Drawing.Point(32, 209);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(75, 30);
            this.btnOK.TabIndex = 4;
            this.btnOK.Text = "OK";
            this.btnOK.UseVisualStyleBackColor = true;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCancel.Location = new System.Drawing.Point(136, 209);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 31);
            this.btnCancel.TabIndex = 5;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // rbtnModifyExisting
            // 
            this.rbtnModifyExisting.AutoSize = true;
            this.rbtnModifyExisting.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnModifyExisting.Location = new System.Drawing.Point(49, 25);
            this.rbtnModifyExisting.Name = "rbtnModifyExisting";
            this.rbtnModifyExisting.Size = new System.Drawing.Size(162, 21);
            this.rbtnModifyExisting.TabIndex = 6;
            this.rbtnModifyExisting.TabStop = true;
            this.rbtnModifyExisting.Text = "Modify Existing Quote";
            this.rbtnModifyExisting.UseVisualStyleBackColor = true;
            this.rbtnModifyExisting.CheckedChanged += new System.EventHandler(this.rbtnModifyExisting_CheckedChanged);
            // 
            // formChooseQuoteType
            // 
            this.AcceptButton = this.btnOK;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(246, 262);
            this.ControlBox = false;
            this.Controls.Add(this.rbtnModifyExisting);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.rbtnPriceChange);
            this.Controls.Add(this.rbtnBomModification);
            this.Controls.Add(this.rbtnCopyQuote);
            this.Controls.Add(this.rbtnNewQuote);
            this.Name = "formChooseQuoteType";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Choose Quote Type";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RadioButton rbtnNewQuote;
        private System.Windows.Forms.RadioButton rbtnCopyQuote;
        private System.Windows.Forms.RadioButton rbtnBomModification;
        private System.Windows.Forms.RadioButton rbtnPriceChange;
        private System.Windows.Forms.Button btnOK;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.RadioButton rbtnModifyExisting;
    }
}