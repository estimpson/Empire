namespace ImportCSM
{
    partial class formMain
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
            this.btnImport = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.lblPriorReleaseId = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.tbxPriorReleaseId = new System.Windows.Forms.TextBox();
            this.tbxCurrentReleaseId = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.linkLblClose = new System.Windows.Forms.LinkLabel();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tpCsm = new System.Windows.Forms.TabPage();
            this.lblTitle = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.pnlImport = new System.Windows.Forms.Panel();
            this.tpCsmDelta = new System.Windows.Forms.TabPage();
            this.label19 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.pnlDeltaImport = new System.Windows.Forms.Panel();
            this.btnDeltaImport = new System.Windows.Forms.Button();
            this.label8 = new System.Windows.Forms.Label();
            this.tbxCurrentDeltaReleaseId = new System.Windows.Forms.TextBox();
            this.tpOfficialForecast = new System.Windows.Forms.TabPage();
            this.label14 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.dtpDateTimeStamp = new System.Windows.Forms.DateTimePicker();
            this.label7 = new System.Windows.Forms.Label();
            this.btnInsertForecast = new System.Windows.Forms.Button();
            this.label6 = new System.Windows.Forms.Label();
            this.tbxForecastName = new System.Windows.Forms.TextBox();
            this.tpHistoricalSales = new System.Windows.Forms.TabPage();
            this.label15 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.dtpHistoricalDateTimeStamp = new System.Windows.Forms.DateTimePicker();
            this.label13 = new System.Windows.Forms.Label();
            this.dtpEndDate = new System.Windows.Forms.DateTimePicker();
            this.label12 = new System.Windows.Forms.Label();
            this.dtpStartDate = new System.Windows.Forms.DateTimePicker();
            this.btnInsertHistoricalSales = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.tbxHistoricalForecastName = new System.Windows.Forms.TextBox();
            this.btnImportGreaterChina = new System.Windows.Forms.Button();
            this.label18 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tpCsm.SuspendLayout();
            this.pnlImport.SuspendLayout();
            this.tpCsmDelta.SuspendLayout();
            this.pnlDeltaImport.SuspendLayout();
            this.tpOfficialForecast.SuspendLayout();
            this.panel2.SuspendLayout();
            this.tpHistoricalSales.SuspendLayout();
            this.panel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnImport
            // 
            this.btnImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnImport.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.btnImport.Location = new System.Drawing.Point(240, 120);
            this.btnImport.Margin = new System.Windows.Forms.Padding(4);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(170, 50);
            this.btnImport.TabIndex = 2;
            this.btnImport.Text = "Import NA";
            this.btnImport.UseVisualStyleBackColor = true;
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            this.btnImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnImport_MouseDown);
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(12, 8);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(247, 29);
            this.label1.TabIndex = 2;
            this.label1.Text = "Data Import and Insert";
            // 
            // lblPriorReleaseId
            // 
            this.lblPriorReleaseId.AutoSize = true;
            this.lblPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPriorReleaseId.ForeColor = System.Drawing.Color.White;
            this.lblPriorReleaseId.Location = new System.Drawing.Point(72, 30);
            this.lblPriorReleaseId.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblPriorReleaseId.Name = "lblPriorReleaseId";
            this.lblPriorReleaseId.Size = new System.Drawing.Size(150, 24);
            this.lblPriorReleaseId.TabIndex = 4;
            this.lblPriorReleaseId.Text = "Prior Release ID:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(49, 70);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(173, 24);
            this.label3.TabIndex = 5;
            this.label3.Text = "Current Release ID:";
            // 
            // tbxPriorReleaseId
            // 
            this.tbxPriorReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxPriorReleaseId.Location = new System.Drawing.Point(240, 26);
            this.tbxPriorReleaseId.Margin = new System.Windows.Forms.Padding(4);
            this.tbxPriorReleaseId.Name = "tbxPriorReleaseId";
            this.tbxPriorReleaseId.Size = new System.Drawing.Size(170, 29);
            this.tbxPriorReleaseId.TabIndex = 0;
            // 
            // tbxCurrentReleaseId
            // 
            this.tbxCurrentReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentReleaseId.Location = new System.Drawing.Point(240, 66);
            this.tbxCurrentReleaseId.Margin = new System.Windows.Forms.Padding(4);
            this.tbxCurrentReleaseId.Name = "tbxCurrentReleaseId";
            this.tbxCurrentReleaseId.Size = new System.Drawing.Size(170, 29);
            this.tbxCurrentReleaseId.TabIndex = 1;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(40)))), ((int)(((byte)(40)))));
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.label18);
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Controls.Add(this.tabControl1);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1193, 709);
            this.panel1.TabIndex = 11;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(1131, 8);
            this.linkLblClose.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(48, 25);
            this.linkLblClose.TabIndex = 19;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "[ X ]";
            this.linkLblClose.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLblClose_LinkClicked);
            this.linkLblClose.MouseEnter += new System.EventHandler(this.linkLblClose_MouseEnter);
            this.linkLblClose.MouseLeave += new System.EventHandler(this.linkLblClose_MouseLeave);
            // 
            // tabControl1
            // 
            this.tabControl1.Appearance = System.Windows.Forms.TabAppearance.FlatButtons;
            this.tabControl1.Controls.Add(this.tpCsm);
            this.tabControl1.Controls.Add(this.tpCsmDelta);
            this.tabControl1.Controls.Add(this.tpOfficialForecast);
            this.tabControl1.Controls.Add(this.tpHistoricalSales);
            this.tabControl1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tabControl1.Location = new System.Drawing.Point(4, 120);
            this.tabControl1.Margin = new System.Windows.Forms.Padding(4);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(1183, 583);
            this.tabControl1.TabIndex = 18;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tpCsm
            // 
            this.tpCsm.BackColor = System.Drawing.Color.Black;
            this.tpCsm.Controls.Add(this.lblTitle);
            this.tpCsm.Controls.Add(this.label17);
            this.tpCsm.Controls.Add(this.label2);
            this.tpCsm.Controls.Add(this.pnlImport);
            this.tpCsm.Location = new System.Drawing.Point(4, 32);
            this.tpCsm.Margin = new System.Windows.Forms.Padding(4);
            this.tpCsm.Name = "tpCsm";
            this.tpCsm.Padding = new System.Windows.Forms.Padding(4);
            this.tpCsm.Size = new System.Drawing.Size(1175, 547);
            this.tpCsm.TabIndex = 0;
            this.tpCsm.Text = "CSM";
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.lblTitle.Location = new System.Drawing.Point(71, 55);
            this.lblTitle.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(187, 25);
            this.lblTitle.TabIndex = 22;
            this.lblTitle.Text = "North America CSM";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label17.ForeColor = System.Drawing.Color.White;
            this.label17.Location = new System.Drawing.Point(272, 82);
            this.label17.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(92, 24);
            this.label17.TabIndex = 21;
            this.label17.Text = "2.  Import.";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(272, 55);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(473, 24);
            this.label2.TabIndex = 18;
            this.label2.Text = "1.  Copy column names and data from the spreadsheet.";
            // 
            // pnlImport
            // 
            this.pnlImport.Controls.Add(this.btnImport);
            this.pnlImport.Controls.Add(this.lblPriorReleaseId);
            this.pnlImport.Controls.Add(this.label3);
            this.pnlImport.Controls.Add(this.tbxCurrentReleaseId);
            this.pnlImport.Controls.Add(this.tbxPriorReleaseId);
            this.pnlImport.Controls.Add(this.btnImportGreaterChina);
            this.pnlImport.Location = new System.Drawing.Point(36, 111);
            this.pnlImport.Margin = new System.Windows.Forms.Padding(4);
            this.pnlImport.Name = "pnlImport";
            this.pnlImport.Size = new System.Drawing.Size(669, 221);
            this.pnlImport.TabIndex = 17;
            // 
            // tpCsmDelta
            // 
            this.tpCsmDelta.BackColor = System.Drawing.Color.Black;
            this.tpCsmDelta.Controls.Add(this.label19);
            this.tpCsmDelta.Controls.Add(this.label16);
            this.tpCsmDelta.Controls.Add(this.label4);
            this.tpCsmDelta.Controls.Add(this.pnlDeltaImport);
            this.tpCsmDelta.Location = new System.Drawing.Point(4, 32);
            this.tpCsmDelta.Margin = new System.Windows.Forms.Padding(4);
            this.tpCsmDelta.Name = "tpCsmDelta";
            this.tpCsmDelta.Padding = new System.Windows.Forms.Padding(4);
            this.tpCsmDelta.Size = new System.Drawing.Size(1175, 547);
            this.tpCsmDelta.TabIndex = 1;
            this.tpCsmDelta.Text = "CSM Delta";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label19.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label19.Location = new System.Drawing.Point(150, 55);
            this.label19.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(108, 25);
            this.label19.TabIndex = 23;
            this.label19.Text = "CSM Delta";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label16.ForeColor = System.Drawing.Color.White;
            this.label16.Location = new System.Drawing.Point(272, 82);
            this.label16.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(92, 24);
            this.label16.TabIndex = 21;
            this.label16.Text = "2.  Import.";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(272, 55);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(584, 24);
            this.label4.TabIndex = 20;
            this.label4.Text = "1.  Save the spreadsheet into the CSM Data folder as:  NA Delta.CSV.";
            // 
            // pnlDeltaImport
            // 
            this.pnlDeltaImport.Controls.Add(this.btnDeltaImport);
            this.pnlDeltaImport.Controls.Add(this.label8);
            this.pnlDeltaImport.Controls.Add(this.tbxCurrentDeltaReleaseId);
            this.pnlDeltaImport.Location = new System.Drawing.Point(36, 111);
            this.pnlDeltaImport.Margin = new System.Windows.Forms.Padding(4);
            this.pnlDeltaImport.Name = "pnlDeltaImport";
            this.pnlDeltaImport.Size = new System.Drawing.Size(457, 149);
            this.pnlDeltaImport.TabIndex = 19;
            // 
            // btnDeltaImport
            // 
            this.btnDeltaImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDeltaImport.Location = new System.Drawing.Point(240, 76);
            this.btnDeltaImport.Margin = new System.Windows.Forms.Padding(4);
            this.btnDeltaImport.Name = "btnDeltaImport";
            this.btnDeltaImport.Size = new System.Drawing.Size(180, 50);
            this.btnDeltaImport.TabIndex = 2;
            this.btnDeltaImport.Text = "Import Delta";
            this.btnDeltaImport.UseVisualStyleBackColor = true;
            this.btnDeltaImport.Click += new System.EventHandler(this.btnDeltaImport_Click);
            this.btnDeltaImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnDeltaImport_MouseDown);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.White;
            this.label8.Location = new System.Drawing.Point(49, 30);
            this.label8.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(173, 24);
            this.label8.TabIndex = 5;
            this.label8.Text = "Current Release ID:";
            // 
            // tbxCurrentDeltaReleaseId
            // 
            this.tbxCurrentDeltaReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentDeltaReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentDeltaReleaseId.Location = new System.Drawing.Point(240, 26);
            this.tbxCurrentDeltaReleaseId.Margin = new System.Windows.Forms.Padding(4);
            this.tbxCurrentDeltaReleaseId.Name = "tbxCurrentDeltaReleaseId";
            this.tbxCurrentDeltaReleaseId.Size = new System.Drawing.Size(180, 29);
            this.tbxCurrentDeltaReleaseId.TabIndex = 1;
            // 
            // tpOfficialForecast
            // 
            this.tpOfficialForecast.BackColor = System.Drawing.Color.Black;
            this.tpOfficialForecast.Controls.Add(this.label14);
            this.tpOfficialForecast.Controls.Add(this.label5);
            this.tpOfficialForecast.Controls.Add(this.panel2);
            this.tpOfficialForecast.Location = new System.Drawing.Point(4, 32);
            this.tpOfficialForecast.Margin = new System.Windows.Forms.Padding(4);
            this.tpOfficialForecast.Name = "tpOfficialForecast";
            this.tpOfficialForecast.Size = new System.Drawing.Size(1175, 547);
            this.tpOfficialForecast.TabIndex = 2;
            this.tpOfficialForecast.Text = "Official Forecast";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.ForeColor = System.Drawing.Color.White;
            this.label14.Location = new System.Drawing.Point(593, 114);
            this.label14.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(225, 20);
            this.label14.TabIndex = 21;
            this.label14.Text = "* Example:   2017/06/20 OSF";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label5.Location = new System.Drawing.Point(272, 47);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(255, 24);
            this.label5.TabIndex = 20;
            this.label5.Text = "Insert official forecast records.";
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.dtpDateTimeStamp);
            this.panel2.Controls.Add(this.label7);
            this.panel2.Controls.Add(this.btnInsertForecast);
            this.panel2.Controls.Add(this.label6);
            this.panel2.Controls.Add(this.tbxForecastName);
            this.panel2.Location = new System.Drawing.Point(36, 84);
            this.panel2.Margin = new System.Windows.Forms.Padding(4);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(549, 209);
            this.panel2.TabIndex = 19;
            // 
            // dtpDateTimeStamp
            // 
            this.dtpDateTimeStamp.Location = new System.Drawing.Point(240, 71);
            this.dtpDateTimeStamp.Margin = new System.Windows.Forms.Padding(4);
            this.dtpDateTimeStamp.Name = "dtpDateTimeStamp";
            this.dtpDateTimeStamp.Size = new System.Drawing.Size(291, 27);
            this.dtpDateTimeStamp.TabIndex = 8;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.White;
            this.label7.Location = new System.Drawing.Point(68, 71);
            this.label7.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(154, 24);
            this.label7.TabIndex = 7;
            this.label7.Text = "DateTime Stamp:";
            // 
            // btnInsertForecast
            // 
            this.btnInsertForecast.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnInsertForecast.Location = new System.Drawing.Point(240, 127);
            this.btnInsertForecast.Margin = new System.Windows.Forms.Padding(4);
            this.btnInsertForecast.Name = "btnInsertForecast";
            this.btnInsertForecast.Size = new System.Drawing.Size(291, 50);
            this.btnInsertForecast.TabIndex = 2;
            this.btnInsertForecast.Text = "Insert Forecast";
            this.btnInsertForecast.UseVisualStyleBackColor = true;
            this.btnInsertForecast.Click += new System.EventHandler(this.btnInsertForecast_Click);
            this.btnInsertForecast.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnInsertForecast_MouseDown);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.ForeColor = System.Drawing.Color.White;
            this.label6.Location = new System.Drawing.Point(79, 26);
            this.label6.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(144, 24);
            this.label6.TabIndex = 4;
            this.label6.Text = "Forecast Name:";
            // 
            // tbxForecastName
            // 
            this.tbxForecastName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxForecastName.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxForecastName.Location = new System.Drawing.Point(240, 26);
            this.tbxForecastName.Margin = new System.Windows.Forms.Padding(4);
            this.tbxForecastName.Name = "tbxForecastName";
            this.tbxForecastName.Size = new System.Drawing.Size(291, 29);
            this.tbxForecastName.TabIndex = 0;
            // 
            // tpHistoricalSales
            // 
            this.tpHistoricalSales.BackColor = System.Drawing.Color.Black;
            this.tpHistoricalSales.Controls.Add(this.label15);
            this.tpHistoricalSales.Controls.Add(this.label9);
            this.tpHistoricalSales.Controls.Add(this.panel3);
            this.tpHistoricalSales.Location = new System.Drawing.Point(4, 32);
            this.tpHistoricalSales.Margin = new System.Windows.Forms.Padding(4);
            this.tpHistoricalSales.Name = "tpHistoricalSales";
            this.tpHistoricalSales.Size = new System.Drawing.Size(1175, 547);
            this.tpHistoricalSales.TabIndex = 3;
            this.tpHistoricalSales.Text = "Historical Sales";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.ForeColor = System.Drawing.Color.White;
            this.label15.Location = new System.Drawing.Point(593, 114);
            this.label15.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(257, 20);
            this.label15.TabIndex = 23;
            this.label15.Text = "* Example:   2017/06/20 ACTUAL";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label9.Location = new System.Drawing.Point(272, 47);
            this.label9.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(255, 24);
            this.label9.TabIndex = 22;
            this.label9.Text = "Insert historical sales records.";
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.dtpHistoricalDateTimeStamp);
            this.panel3.Controls.Add(this.label13);
            this.panel3.Controls.Add(this.dtpEndDate);
            this.panel3.Controls.Add(this.label12);
            this.panel3.Controls.Add(this.dtpStartDate);
            this.panel3.Controls.Add(this.btnInsertHistoricalSales);
            this.panel3.Controls.Add(this.label10);
            this.panel3.Controls.Add(this.label11);
            this.panel3.Controls.Add(this.tbxHistoricalForecastName);
            this.panel3.Location = new System.Drawing.Point(36, 84);
            this.panel3.Margin = new System.Windows.Forms.Padding(4);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(553, 316);
            this.panel3.TabIndex = 21;
            // 
            // dtpHistoricalDateTimeStamp
            // 
            this.dtpHistoricalDateTimeStamp.Location = new System.Drawing.Point(240, 71);
            this.dtpHistoricalDateTimeStamp.Margin = new System.Windows.Forms.Padding(4);
            this.dtpHistoricalDateTimeStamp.Name = "dtpHistoricalDateTimeStamp";
            this.dtpHistoricalDateTimeStamp.Size = new System.Drawing.Size(291, 27);
            this.dtpHistoricalDateTimeStamp.TabIndex = 10;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.ForeColor = System.Drawing.Color.White;
            this.label13.Location = new System.Drawing.Point(68, 71);
            this.label13.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(154, 24);
            this.label13.TabIndex = 9;
            this.label13.Text = "DateTime Stamp:";
            // 
            // dtpEndDate
            // 
            this.dtpEndDate.Location = new System.Drawing.Point(240, 165);
            this.dtpEndDate.Margin = new System.Windows.Forms.Padding(4);
            this.dtpEndDate.Name = "dtpEndDate";
            this.dtpEndDate.Size = new System.Drawing.Size(291, 27);
            this.dtpEndDate.TabIndex = 8;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.Color.White;
            this.label12.Location = new System.Drawing.Point(135, 165);
            this.label12.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(93, 24);
            this.label12.TabIndex = 7;
            this.label12.Text = "End Date:";
            // 
            // dtpStartDate
            // 
            this.dtpStartDate.Location = new System.Drawing.Point(240, 118);
            this.dtpStartDate.Margin = new System.Windows.Forms.Padding(4);
            this.dtpStartDate.Name = "dtpStartDate";
            this.dtpStartDate.Size = new System.Drawing.Size(291, 27);
            this.dtpStartDate.TabIndex = 6;
            // 
            // btnInsertHistoricalSales
            // 
            this.btnInsertHistoricalSales.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnInsertHistoricalSales.Location = new System.Drawing.Point(240, 222);
            this.btnInsertHistoricalSales.Margin = new System.Windows.Forms.Padding(4);
            this.btnInsertHistoricalSales.Name = "btnInsertHistoricalSales";
            this.btnInsertHistoricalSales.Size = new System.Drawing.Size(291, 50);
            this.btnInsertHistoricalSales.TabIndex = 2;
            this.btnInsertHistoricalSales.Text = "Insert Historical";
            this.btnInsertHistoricalSales.UseVisualStyleBackColor = true;
            this.btnInsertHistoricalSales.Click += new System.EventHandler(this.btnInsertHistoricalSales_Click);
            this.btnInsertHistoricalSales.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnInsertHistoricalSales_MouseDown);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.Color.White;
            this.label10.Location = new System.Drawing.Point(79, 26);
            this.label10.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(144, 24);
            this.label10.TabIndex = 4;
            this.label10.Text = "Forecast Name:";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.ForeColor = System.Drawing.Color.White;
            this.label11.Location = new System.Drawing.Point(131, 118);
            this.label11.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(94, 24);
            this.label11.TabIndex = 5;
            this.label11.Text = "Start Date:";
            // 
            // tbxHistoricalForecastName
            // 
            this.tbxHistoricalForecastName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxHistoricalForecastName.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxHistoricalForecastName.Location = new System.Drawing.Point(240, 26);
            this.tbxHistoricalForecastName.Margin = new System.Windows.Forms.Padding(4);
            this.tbxHistoricalForecastName.Name = "tbxHistoricalForecastName";
            this.tbxHistoricalForecastName.Size = new System.Drawing.Size(291, 29);
            this.tbxHistoricalForecastName.TabIndex = 0;
            // 
            // btnImportGreaterChina
            // 
            this.btnImportGreaterChina.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnImportGreaterChina.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(0)))), ((int)(((byte)(20)))));
            this.btnImportGreaterChina.Location = new System.Drawing.Point(240, 117);
            this.btnImportGreaterChina.Name = "btnImportGreaterChina";
            this.btnImportGreaterChina.Size = new System.Drawing.Size(170, 50);
            this.btnImportGreaterChina.TabIndex = 6;
            this.btnImportGreaterChina.Text = "Import GC";
            this.btnImportGreaterChina.UseVisualStyleBackColor = true;
            this.btnImportGreaterChina.Click += new System.EventHandler(this.btnImportGreaterChina_Click);
            this.btnImportGreaterChina.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnImportGreaterChina_MouseDown);
            // 
            // label18
            // 
            this.label18.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label18.ForeColor = System.Drawing.Color.White;
            this.label18.Location = new System.Drawing.Point(270, 15);
            this.label18.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(151, 20);
            this.label18.TabIndex = 20;
            this.label18.Text = "Empire Electronics";
            // 
            // formMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1193, 709);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.Black;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "formMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            this.Activated += new System.EventHandler(this.formMain_Activated);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tpCsm.ResumeLayout(false);
            this.tpCsm.PerformLayout();
            this.pnlImport.ResumeLayout(false);
            this.pnlImport.PerformLayout();
            this.tpCsmDelta.ResumeLayout(false);
            this.tpCsmDelta.PerformLayout();
            this.pnlDeltaImport.ResumeLayout(false);
            this.pnlDeltaImport.PerformLayout();
            this.tpOfficialForecast.ResumeLayout(false);
            this.tpOfficialForecast.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.tpHistoricalSales.ResumeLayout(false);
            this.tpHistoricalSales.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnImport;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblPriorReleaseId;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox tbxPriorReleaseId;
        private System.Windows.Forms.TextBox tbxCurrentReleaseId;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel pnlImport;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tpCsm;
        private System.Windows.Forms.TabPage tpCsmDelta;
        private System.Windows.Forms.Panel pnlDeltaImport;
        private System.Windows.Forms.Button btnDeltaImport;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox tbxCurrentDeltaReleaseId;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.LinkLabel linkLblClose;
        private System.Windows.Forms.TabPage tpOfficialForecast;
        private System.Windows.Forms.TabPage tpHistoricalSales;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Button btnInsertForecast;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox tbxForecastName;
        private System.Windows.Forms.DateTimePicker dtpDateTimeStamp;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.DateTimePicker dtpHistoricalDateTimeStamp;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.DateTimePicker dtpEndDate;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.DateTimePicker dtpStartDate;
        private System.Windows.Forms.Button btnInsertHistoricalSales;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TextBox tbxHistoricalForecastName;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label lblTitle;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Button btnImportGreaterChina;
        private System.Windows.Forms.Label label18;
    }
}

