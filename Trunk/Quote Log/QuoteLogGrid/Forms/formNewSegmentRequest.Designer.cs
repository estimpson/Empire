namespace QuoteLogGrid.Forms
{
    partial class formNewSegmentRequest
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
            this.rbtnSegment = new System.Windows.Forms.RadioButton();
            this.rbtnSubsegment = new System.Windows.Forms.RadioButton();
            this.btnCancel = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.tbxOperatorCode = new System.Windows.Forms.TextBox();
            this.tbxEmpireMarket = new System.Windows.Forms.TextBox();
            this.btnSubmit = new System.Windows.Forms.Button();
            this.tbxNote = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // rbtnSegment
            // 
            this.rbtnSegment.AutoSize = true;
            this.rbtnSegment.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnSegment.Location = new System.Drawing.Point(67, 145);
            this.rbtnSegment.Name = "rbtnSegment";
            this.rbtnSegment.Size = new System.Drawing.Size(152, 24);
            this.rbtnSegment.TabIndex = 1;
            this.rbtnSegment.TabStop = true;
            this.rbtnSegment.Text = "Market Segment";
            this.rbtnSegment.UseVisualStyleBackColor = true;
            this.rbtnSegment.CheckedChanged += new System.EventHandler(this.rbtnSegment_CheckedChanged);
            // 
            // rbtnSubsegment
            // 
            this.rbtnSubsegment.AutoSize = true;
            this.rbtnSubsegment.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rbtnSubsegment.Location = new System.Drawing.Point(236, 145);
            this.rbtnSubsegment.Name = "rbtnSubsegment";
            this.rbtnSubsegment.Size = new System.Drawing.Size(179, 24);
            this.rbtnSubsegment.TabIndex = 2;
            this.rbtnSubsegment.TabStop = true;
            this.rbtnSubsegment.Text = "Market Subsegment";
            this.rbtnSubsegment.UseVisualStyleBackColor = true;
            this.rbtnSubsegment.CheckedChanged += new System.EventHandler(this.rbtnSubsegment_CheckedChanged);
            // 
            // btnCancel
            // 
            this.btnCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCancel.Location = new System.Drawing.Point(251, 366);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(135, 46);
            this.btnCancel.TabIndex = 6;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(64, 84);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(124, 20);
            this.label1.TabIndex = 3;
            this.label1.Text = "Operator Code:";
            // 
            // tbxOperatorCode
            // 
            this.tbxOperatorCode.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxOperatorCode.Location = new System.Drawing.Point(205, 81);
            this.tbxOperatorCode.Name = "tbxOperatorCode";
            this.tbxOperatorCode.Size = new System.Drawing.Size(219, 27);
            this.tbxOperatorCode.TabIndex = 0;
            // 
            // tbxEmpireMarket
            // 
            this.tbxEmpireMarket.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxEmpireMarket.Location = new System.Drawing.Point(67, 174);
            this.tbxEmpireMarket.MaxLength = 200;
            this.tbxEmpireMarket.Name = "tbxEmpireMarket";
            this.tbxEmpireMarket.Size = new System.Drawing.Size(357, 27);
            this.tbxEmpireMarket.TabIndex = 3;
            // 
            // btnSubmit
            // 
            this.btnSubmit.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSubmit.Location = new System.Drawing.Point(104, 366);
            this.btnSubmit.Name = "btnSubmit";
            this.btnSubmit.Size = new System.Drawing.Size(135, 46);
            this.btnSubmit.TabIndex = 5;
            this.btnSubmit.Text = "Submit";
            this.btnSubmit.UseVisualStyleBackColor = true;
            this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
            // 
            // tbxNote
            // 
            this.tbxNote.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxNote.Location = new System.Drawing.Point(67, 257);
            this.tbxNote.MaxLength = 250;
            this.tbxNote.Multiline = true;
            this.tbxNote.Name = "tbxNote";
            this.tbxNote.Size = new System.Drawing.Size(357, 63);
            this.tbxNote.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(64, 236);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 20);
            this.label2.TabIndex = 10;
            this.label2.Text = "Note:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.DodgerBlue;
            this.label3.Location = new System.Drawing.Point(167, 19);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(166, 29);
            this.label3.TabIndex = 11;
            this.label3.Text = "Request Form";
            // 
            // formNewSegmentRequest
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(492, 450);
            this.ControlBox = false;
            this.Controls.Add(this.label3);
            this.Controls.Add(this.tbxNote);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnSubmit);
            this.Controls.Add(this.tbxEmpireMarket);
            this.Controls.Add(this.tbxOperatorCode);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.rbtnSubsegment);
            this.Controls.Add(this.rbtnSegment);
            this.Name = "formNewSegmentRequest";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "New Empire Market Segment / Subsegment";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RadioButton rbtnSegment;
        private System.Windows.Forms.RadioButton rbtnSubsegment;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbxOperatorCode;
        private System.Windows.Forms.TextBox tbxEmpireMarket;
        private System.Windows.Forms.Button btnSubmit;
        private System.Windows.Forms.TextBox tbxNote;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
    }
}