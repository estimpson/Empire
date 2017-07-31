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
            this.label2 = new System.Windows.Forms.Label();
            this.pnlImport = new System.Windows.Forms.Panel();
            this.tpCsmDelta = new System.Windows.Forms.TabPage();
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
            this.label16 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label19 = new System.Windows.Forms.Label();
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
            this.btnImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnImport.Location = new System.Drawing.Point(180, 98);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(114, 41);
            this.btnImport.TabIndex = 2;
            this.btnImport.Text = "Import";
            this.btnImport.UseVisualStyleBackColor = true;
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            this.btnImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnImport_MouseDown);
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label1.Location = new System.Drawing.Point(6, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(274, 25);
            this.label1.TabIndex = 2;
            this.label1.Text = "Empire Import / Insert Tools";
            // 
            // lblPriorReleaseId
            // 
            this.lblPriorReleaseId.AutoSize = true;
            this.lblPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPriorReleaseId.ForeColor = System.Drawing.Color.White;
            this.lblPriorReleaseId.Location = new System.Drawing.Point(54, 24);
            this.lblPriorReleaseId.Name = "lblPriorReleaseId";
            this.lblPriorReleaseId.Size = new System.Drawing.Size(120, 18);
            this.lblPriorReleaseId.TabIndex = 4;
            this.lblPriorReleaseId.Text = "Prior Release ID:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(37, 57);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(137, 18);
            this.label3.TabIndex = 5;
            this.label3.Text = "Current Release ID:";
            // 
            // tbxPriorReleaseId
            // 
            this.tbxPriorReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxPriorReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxPriorReleaseId.Location = new System.Drawing.Point(180, 21);
            this.tbxPriorReleaseId.Name = "tbxPriorReleaseId";
            this.tbxPriorReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxPriorReleaseId.TabIndex = 0;
            // 
            // tbxCurrentReleaseId
            // 
            this.tbxCurrentReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentReleaseId.Location = new System.Drawing.Point(180, 54);
            this.tbxCurrentReleaseId.Name = "tbxCurrentReleaseId";
            this.tbxCurrentReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxCurrentReleaseId.TabIndex = 1;
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.linkLblClose);
            this.panel1.Controls.Add(this.tabControl1);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(895, 576);
            this.panel1.TabIndex = 11;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // linkLblClose
            // 
            this.linkLblClose.AutoSize = true;
            this.linkLblClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.linkLblClose.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.LinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.linkLblClose.Location = new System.Drawing.Point(828, 8);
            this.linkLblClose.Name = "linkLblClose";
            this.linkLblClose.Size = new System.Drawing.Size(58, 24);
            this.linkLblClose.TabIndex = 19;
            this.linkLblClose.TabStop = true;
            this.linkLblClose.Text = "Close";
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
            this.tabControl1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tabControl1.Location = new System.Drawing.Point(3, 91);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(887, 480);
            this.tabControl1.TabIndex = 18;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tpCsm
            // 
            this.tpCsm.BackColor = System.Drawing.Color.Black;
            this.tpCsm.Controls.Add(this.label18);
            this.tpCsm.Controls.Add(this.label17);
            this.tpCsm.Controls.Add(this.label2);
            this.tpCsm.Controls.Add(this.pnlImport);
            this.tpCsm.Location = new System.Drawing.Point(4, 30);
            this.tpCsm.Name = "tpCsm";
            this.tpCsm.Padding = new System.Windows.Forms.Padding(3);
            this.tpCsm.Size = new System.Drawing.Size(879, 446);
            this.tpCsm.TabIndex = 0;
            this.tpCsm.Text = "CSM";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(204, 45);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(455, 18);
            this.label2.TabIndex = 18;
            this.label2.Text = "1.  Copy column names and data from the spreadsheet, then Import.";
            // 
            // pnlImport
            // 
            this.pnlImport.Controls.Add(this.btnImport);
            this.pnlImport.Controls.Add(this.lblPriorReleaseId);
            this.pnlImport.Controls.Add(this.label3);
            this.pnlImport.Controls.Add(this.tbxCurrentReleaseId);
            this.pnlImport.Controls.Add(this.tbxPriorReleaseId);
            this.pnlImport.Location = new System.Drawing.Point(27, 90);
            this.pnlImport.Name = "pnlImport";
            this.pnlImport.Size = new System.Drawing.Size(343, 151);
            this.pnlImport.TabIndex = 17;
            // 
            // tpCsmDelta
            // 
            this.tpCsmDelta.BackColor = System.Drawing.Color.Black;
            this.tpCsmDelta.Controls.Add(this.label19);
            this.tpCsmDelta.Controls.Add(this.label16);
            this.tpCsmDelta.Controls.Add(this.label4);
            this.tpCsmDelta.Controls.Add(this.pnlDeltaImport);
            this.tpCsmDelta.Location = new System.Drawing.Point(4, 30);
            this.tpCsmDelta.Name = "tpCsmDelta";
            this.tpCsmDelta.Padding = new System.Windows.Forms.Padding(3);
            this.tpCsmDelta.Size = new System.Drawing.Size(879, 446);
            this.tpCsmDelta.TabIndex = 1;
            this.tpCsmDelta.Text = "CSM Delta";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(204, 45);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(464, 18);
            this.label4.TabIndex = 20;
            this.label4.Text = "1.  Save the spreadsheet into the CSM Data folder as:  NA Delta.CSV.";
            // 
            // pnlDeltaImport
            // 
            this.pnlDeltaImport.Controls.Add(this.btnDeltaImport);
            this.pnlDeltaImport.Controls.Add(this.label8);
            this.pnlDeltaImport.Controls.Add(this.tbxCurrentDeltaReleaseId);
            this.pnlDeltaImport.Location = new System.Drawing.Point(27, 90);
            this.pnlDeltaImport.Name = "pnlDeltaImport";
            this.pnlDeltaImport.Size = new System.Drawing.Size(343, 121);
            this.pnlDeltaImport.TabIndex = 19;
            // 
            // btnDeltaImport
            // 
            this.btnDeltaImport.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDeltaImport.Location = new System.Drawing.Point(180, 65);
            this.btnDeltaImport.Name = "btnDeltaImport";
            this.btnDeltaImport.Size = new System.Drawing.Size(114, 41);
            this.btnDeltaImport.TabIndex = 2;
            this.btnDeltaImport.Text = "Import";
            this.btnDeltaImport.UseVisualStyleBackColor = true;
            this.btnDeltaImport.Click += new System.EventHandler(this.btnDeltaImport_Click);
            this.btnDeltaImport.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnDeltaImport_MouseDown);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.White;
            this.label8.Location = new System.Drawing.Point(37, 24);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(137, 18);
            this.label8.TabIndex = 5;
            this.label8.Text = "Current Release ID:";
            // 
            // tbxCurrentDeltaReleaseId
            // 
            this.tbxCurrentDeltaReleaseId.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxCurrentDeltaReleaseId.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxCurrentDeltaReleaseId.Location = new System.Drawing.Point(180, 21);
            this.tbxCurrentDeltaReleaseId.Name = "tbxCurrentDeltaReleaseId";
            this.tbxCurrentDeltaReleaseId.Size = new System.Drawing.Size(114, 24);
            this.tbxCurrentDeltaReleaseId.TabIndex = 1;
            // 
            // tpOfficialForecast
            // 
            this.tpOfficialForecast.BackColor = System.Drawing.Color.Black;
            this.tpOfficialForecast.Controls.Add(this.label14);
            this.tpOfficialForecast.Controls.Add(this.label5);
            this.tpOfficialForecast.Controls.Add(this.panel2);
            this.tpOfficialForecast.Location = new System.Drawing.Point(4, 30);
            this.tpOfficialForecast.Name = "tpOfficialForecast";
            this.tpOfficialForecast.Size = new System.Drawing.Size(879, 446);
            this.tpOfficialForecast.TabIndex = 2;
            this.tpOfficialForecast.Text = "Official Forecast";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.ForeColor = System.Drawing.Color.White;
            this.label14.Location = new System.Drawing.Point(434, 93);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(175, 16);
            this.label14.TabIndex = 21;
            this.label14.Text = "* Example:   2017/06/20 OSF";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label5.Location = new System.Drawing.Point(204, 38);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(207, 18);
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
            this.panel2.Location = new System.Drawing.Point(27, 68);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(401, 170);
            this.panel2.TabIndex = 19;
            // 
            // dtpDateTimeStamp
            // 
            this.dtpDateTimeStamp.Location = new System.Drawing.Point(180, 58);
            this.dtpDateTimeStamp.Name = "dtpDateTimeStamp";
            this.dtpDateTimeStamp.Size = new System.Drawing.Size(200, 24);
            this.dtpDateTimeStamp.TabIndex = 8;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.Color.White;
            this.label7.Location = new System.Drawing.Point(51, 58);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(123, 18);
            this.label7.TabIndex = 7;
            this.label7.Text = "DateTime Stamp:";
            // 
            // btnInsertForecast
            // 
            this.btnInsertForecast.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnInsertForecast.Location = new System.Drawing.Point(180, 103);
            this.btnInsertForecast.Name = "btnInsertForecast";
            this.btnInsertForecast.Size = new System.Drawing.Size(200, 41);
            this.btnInsertForecast.TabIndex = 2;
            this.btnInsertForecast.Text = "Insert";
            this.btnInsertForecast.UseVisualStyleBackColor = true;
            this.btnInsertForecast.Click += new System.EventHandler(this.btnInsertForecast_Click);
            this.btnInsertForecast.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnInsertForecast_MouseDown);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.ForeColor = System.Drawing.Color.White;
            this.label6.Location = new System.Drawing.Point(59, 21);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(115, 18);
            this.label6.TabIndex = 4;
            this.label6.Text = "Forecast Name:";
            // 
            // tbxForecastName
            // 
            this.tbxForecastName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxForecastName.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxForecastName.Location = new System.Drawing.Point(180, 21);
            this.tbxForecastName.Name = "tbxForecastName";
            this.tbxForecastName.Size = new System.Drawing.Size(200, 24);
            this.tbxForecastName.TabIndex = 0;
            // 
            // tpHistoricalSales
            // 
            this.tpHistoricalSales.BackColor = System.Drawing.Color.Black;
            this.tpHistoricalSales.Controls.Add(this.label15);
            this.tpHistoricalSales.Controls.Add(this.label9);
            this.tpHistoricalSales.Controls.Add(this.panel3);
            this.tpHistoricalSales.Location = new System.Drawing.Point(4, 30);
            this.tpHistoricalSales.Name = "tpHistoricalSales";
            this.tpHistoricalSales.Size = new System.Drawing.Size(879, 446);
            this.tpHistoricalSales.TabIndex = 3;
            this.tpHistoricalSales.Text = "Historical Sales";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.ForeColor = System.Drawing.Color.White;
            this.label15.Location = new System.Drawing.Point(434, 93);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(201, 16);
            this.label15.TabIndex = 23;
            this.label15.Text = "* Example:   2017/06/20 ACTUAL";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label9.Location = new System.Drawing.Point(204, 38);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(205, 18);
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
            this.panel3.Location = new System.Drawing.Point(27, 68);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(401, 257);
            this.panel3.TabIndex = 21;
            // 
            // dtpHistoricalDateTimeStamp
            // 
            this.dtpHistoricalDateTimeStamp.Location = new System.Drawing.Point(180, 58);
            this.dtpHistoricalDateTimeStamp.Name = "dtpHistoricalDateTimeStamp";
            this.dtpHistoricalDateTimeStamp.Size = new System.Drawing.Size(200, 24);
            this.dtpHistoricalDateTimeStamp.TabIndex = 10;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.ForeColor = System.Drawing.Color.White;
            this.label13.Location = new System.Drawing.Point(51, 58);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(123, 18);
            this.label13.TabIndex = 9;
            this.label13.Text = "DateTime Stamp:";
            // 
            // dtpEndDate
            // 
            this.dtpEndDate.Location = new System.Drawing.Point(180, 134);
            this.dtpEndDate.Name = "dtpEndDate";
            this.dtpEndDate.Size = new System.Drawing.Size(200, 24);
            this.dtpEndDate.TabIndex = 8;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.Color.White;
            this.label12.Location = new System.Drawing.Point(101, 134);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(73, 18);
            this.label12.TabIndex = 7;
            this.label12.Text = "End Date:";
            // 
            // dtpStartDate
            // 
            this.dtpStartDate.Location = new System.Drawing.Point(180, 96);
            this.dtpStartDate.Name = "dtpStartDate";
            this.dtpStartDate.Size = new System.Drawing.Size(200, 24);
            this.dtpStartDate.TabIndex = 6;
            // 
            // btnInsertHistoricalSales
            // 
            this.btnInsertHistoricalSales.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnInsertHistoricalSales.Location = new System.Drawing.Point(180, 180);
            this.btnInsertHistoricalSales.Name = "btnInsertHistoricalSales";
            this.btnInsertHistoricalSales.Size = new System.Drawing.Size(200, 41);
            this.btnInsertHistoricalSales.TabIndex = 2;
            this.btnInsertHistoricalSales.Text = "Insert";
            this.btnInsertHistoricalSales.UseVisualStyleBackColor = true;
            this.btnInsertHistoricalSales.Click += new System.EventHandler(this.btnInsertHistoricalSales_Click);
            this.btnInsertHistoricalSales.MouseDown += new System.Windows.Forms.MouseEventHandler(this.btnInsertHistoricalSales_MouseDown);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.Color.White;
            this.label10.Location = new System.Drawing.Point(59, 21);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(115, 18);
            this.label10.TabIndex = 4;
            this.label10.Text = "Forecast Name:";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.ForeColor = System.Drawing.Color.White;
            this.label11.Location = new System.Drawing.Point(98, 96);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(78, 18);
            this.label11.TabIndex = 5;
            this.label11.Text = "Start Date:";
            // 
            // tbxHistoricalForecastName
            // 
            this.tbxHistoricalForecastName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.tbxHistoricalForecastName.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbxHistoricalForecastName.Location = new System.Drawing.Point(180, 21);
            this.tbxHistoricalForecastName.Name = "tbxHistoricalForecastName";
            this.tbxHistoricalForecastName.Size = new System.Drawing.Size(200, 24);
            this.tbxHistoricalForecastName.TabIndex = 0;
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label16.ForeColor = System.Drawing.Color.White;
            this.label16.Location = new System.Drawing.Point(204, 67);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(74, 18);
            this.label16.TabIndex = 21;
            this.label16.Text = "2.  Import.";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label17.ForeColor = System.Drawing.Color.White;
            this.label17.Location = new System.Drawing.Point(204, 67);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(74, 18);
            this.label17.TabIndex = 21;
            this.label17.Text = "2.  Import.";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label18.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label18.Location = new System.Drawing.Point(147, 45);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(51, 24);
            this.label18.TabIndex = 22;
            this.label18.Text = "CSM";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label19.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(122)))), ((int)(((byte)(204)))));
            this.label19.Location = new System.Drawing.Point(100, 45);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(98, 24);
            this.label19.TabIndex = 23;
            this.label19.Text = "CSM Delta";
            // 
            // formMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(895, 576);
            this.ControlBox = false;
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.Black;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
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
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label label16;
    }
}

