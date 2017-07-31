namespace QuoteLogGrid.Forms
{
    partial class formLightingData
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
            this.btnDone = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.ddlApplication = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.ddlProgram = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.btnRemove = new System.Windows.Forms.Button();
            this.lvwLightingData = new System.Windows.Forms.ListView();
            this.ddlSop = new System.Windows.Forms.ComboBox();
            this.lblSop = new System.Windows.Forms.Label();
            this.btnAdd = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.btnRefresh = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.ddlLedHarness = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // btnDone
            // 
            this.btnDone.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDone.Location = new System.Drawing.Point(427, 337);
            this.btnDone.Name = "btnDone";
            this.btnDone.Size = new System.Drawing.Size(343, 42);
            this.btnDone.TabIndex = 0;
            this.btnDone.Text = "Close";
            this.btnDone.UseVisualStyleBackColor = true;
            this.btnDone.Click += new System.EventHandler(this.btnDone_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(35, 116);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(70, 18);
            this.label1.TabIndex = 1;
            this.label1.Text = "Program:";
            // 
            // ddlApplication
            // 
            this.ddlApplication.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ddlApplication.FormattingEnabled = true;
            this.ddlApplication.Location = new System.Drawing.Point(143, 76);
            this.ddlApplication.Name = "ddlApplication";
            this.ddlApplication.Size = new System.Drawing.Size(254, 26);
            this.ddlApplication.TabIndex = 2;
            this.ddlApplication.SelectedIndexChanged += new System.EventHandler(this.ddlApplication_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(35, 79);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(83, 18);
            this.label2.TabIndex = 3;
            this.label2.Text = "Application:";
            // 
            // ddlProgram
            // 
            this.ddlProgram.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ddlProgram.FormattingEnabled = true;
            this.ddlProgram.Location = new System.Drawing.Point(143, 113);
            this.ddlProgram.Name = "ddlProgram";
            this.ddlProgram.Size = new System.Drawing.Size(254, 26);
            this.ddlProgram.TabIndex = 4;
            this.ddlProgram.SelectedIndexChanged += new System.EventHandler(this.ddlPrograms_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.SteelBlue;
            this.label3.Location = new System.Drawing.Point(34, 24);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(363, 25);
            this.label3.TabIndex = 11;
            this.label3.Text = "Tie this quote to Lighting Study data:";
            // 
            // btnRemove
            // 
            this.btnRemove.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnRemove.Location = new System.Drawing.Point(1028, 272);
            this.btnRemove.Name = "btnRemove";
            this.btnRemove.Size = new System.Drawing.Size(126, 33);
            this.btnRemove.TabIndex = 10;
            this.btnRemove.Text = "Delete";
            this.btnRemove.UseVisualStyleBackColor = true;
            this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
            // 
            // lvwLightingData
            // 
            this.lvwLightingData.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lvwLightingData.FullRowSelect = true;
            this.lvwLightingData.GridLines = true;
            this.lvwLightingData.Location = new System.Drawing.Point(416, 76);
            this.lvwLightingData.MultiSelect = false;
            this.lvwLightingData.Name = "lvwLightingData";
            this.lvwLightingData.Size = new System.Drawing.Size(738, 190);
            this.lvwLightingData.TabIndex = 9;
            this.lvwLightingData.UseCompatibleStateImageBehavior = false;
            this.lvwLightingData.View = System.Windows.Forms.View.Details;
            // 
            // ddlSop
            // 
            this.ddlSop.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ddlSop.FormattingEnabled = true;
            this.ddlSop.Location = new System.Drawing.Point(143, 185);
            this.ddlSop.Name = "ddlSop";
            this.ddlSop.Size = new System.Drawing.Size(254, 26);
            this.ddlSop.TabIndex = 8;
            this.ddlSop.SelectedIndexChanged += new System.EventHandler(this.ddlSop_SelectedIndexChanged);
            // 
            // lblSop
            // 
            this.lblSop.AutoSize = true;
            this.lblSop.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblSop.Location = new System.Drawing.Point(35, 188);
            this.lblSop.Name = "lblSop";
            this.lblSop.Size = new System.Drawing.Size(44, 18);
            this.lblSop.TabIndex = 7;
            this.lblSop.Text = "SOP:";
            // 
            // btnAdd
            // 
            this.btnAdd.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnAdd.Location = new System.Drawing.Point(143, 224);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(254, 42);
            this.btnAdd.TabIndex = 6;
            this.btnAdd.Text = "Save";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.SteelBlue;
            this.label7.Location = new System.Drawing.Point(866, 272);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(159, 15);
            this.label7.TabIndex = 17;
            this.label7.Text = "* Highlight a row to delete it.";
            // 
            // btnRefresh
            // 
            this.btnRefresh.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnRefresh.Location = new System.Drawing.Point(1028, 37);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Size = new System.Drawing.Size(126, 33);
            this.btnRefresh.TabIndex = 7;
            this.btnRefresh.Text = "Refresh";
            this.btnRefresh.UseVisualStyleBackColor = true;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(35, 151);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(101, 18);
            this.label4.TabIndex = 19;
            this.label4.Text = "LED/Harness:";
            // 
            // ddlLedHarness
            // 
            this.ddlLedHarness.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ddlLedHarness.FormattingEnabled = true;
            this.ddlLedHarness.Location = new System.Drawing.Point(143, 149);
            this.ddlLedHarness.Name = "ddlLedHarness";
            this.ddlLedHarness.Size = new System.Drawing.Size(254, 26);
            this.ddlLedHarness.TabIndex = 20;
            this.ddlLedHarness.SelectedIndexChanged += new System.EventHandler(this.ddlLedHarness_SelectedIndexChanged);
            // 
            // formLightingData
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1199, 406);
            this.ControlBox = false;
            this.Controls.Add(this.ddlLedHarness);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.btnRefresh);
            this.Controls.Add(this.btnDone);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.lvwLightingData);
            this.Controls.Add(this.ddlApplication);
            this.Controls.Add(this.ddlSop);
            this.Controls.Add(this.ddlProgram);
            this.Controls.Add(this.lblSop);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnAdd);
            this.Name = "formLightingData";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Lighting Data Entry";
            this.Load += new System.EventHandler(this.formLightingData_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnDone;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox ddlApplication;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox ddlProgram;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnRemove;
        private System.Windows.Forms.ComboBox ddlSop;
        private System.Windows.Forms.Label lblSop;
        private System.Windows.Forms.ListView lvwLightingData;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button btnRefresh;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox ddlLedHarness;
    }
}