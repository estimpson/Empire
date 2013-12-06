namespace ReceivingDockWM5
{
    partial class frmReceivingDock
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
            this.label2 = new System.Windows.Forms.Label();
            this.uxSID = new System.Windows.Forms.TextBox();
            this.uxEnterSID = new System.Windows.Forms.Button();
            this.uxReceive = new System.Windows.Forms.Button();
            this.uxMessage = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.uxPO = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.uxPWD = new System.Windows.Forms.TextBox();
            this.uxQty = new System.Windows.Forms.TextBox();
            this.uxLot = new System.Windows.Forms.TextBox();
            this.uxPart = new System.Windows.Forms.TextBox();
            this.uxEnterPO = new System.Windows.Forms.Button();
            this.uxEnterQty = new System.Windows.Forms.Button();
            this.uxEnterLot = new System.Windows.Forms.Button();
            this.uxEnterPart = new System.Windows.Forms.Button();
            this.uxConfirmPWD = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.uxOperator = new System.Windows.Forms.Label();
            this.panelStdReceiving = new System.Windows.Forms.Panel();
            this.uxStoreSID = new System.Windows.Forms.CheckBox();
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.mainMenuReceivingDock = new System.Windows.Forms.MainMenu();
            this.menuItemPrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem1PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem2PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem3PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem4PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem5PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItemLocation = new System.Windows.Forms.MenuItem();
            this.panelStdReceiving.SuspendLayout();
            this.SuspendLayout();
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(0, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(34, 20);
            this.label2.Text = "SID:";
            // 
            // uxSID
            // 
            this.uxSID.Location = new System.Drawing.Point(40, 1);
            this.uxSID.Name = "uxSID";
            this.uxSID.Size = new System.Drawing.Size(93, 21);
            this.uxSID.TabIndex = 0;
            this.uxSID.GotFocus += new System.EventHandler(this.uxSID_GotFocus);
            this.uxSID.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxSID_KeyDown);
            // 
            // uxEnterSID
            // 
            this.uxEnterSID.Location = new System.Drawing.Point(157, 1);
            this.uxEnterSID.Name = "uxEnterSID";
            this.uxEnterSID.Size = new System.Drawing.Size(72, 21);
            this.uxEnterSID.TabIndex = 2;
            this.uxEnterSID.Text = "Enter";
            this.uxEnterSID.Click += new System.EventHandler(this.uxEnterSID_Click);
            // 
            // uxReceive
            // 
            this.uxReceive.Location = new System.Drawing.Point(40, 140);
            this.uxReceive.Name = "uxReceive";
            this.uxReceive.Size = new System.Drawing.Size(189, 30);
            this.uxReceive.TabIndex = 11;
            this.uxReceive.Text = "Clear Fields";
            this.uxReceive.Click += new System.EventHandler(this.uxReceive_Click);
            // 
            // uxMessage
            // 
            this.uxMessage.Location = new System.Drawing.Point(0, 182);
            this.uxMessage.Name = "uxMessage";
            this.uxMessage.Size = new System.Drawing.Size(229, 50);
            this.uxMessage.Text = "Login.";
            this.uxMessage.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.uxMessage.ParentChanged += new System.EventHandler(this.uxMessage_ParentChanged);
            // 
            // label4
            // 
            this.label4.Location = new System.Drawing.Point(0, 81);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(34, 20);
            this.label4.Text = "Qty:";
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(0, 28);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(34, 20);
            this.label3.Text = "PO:";
            // 
            // label6
            // 
            this.label6.Location = new System.Drawing.Point(0, 54);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(34, 20);
            this.label6.Text = "Part:";
            // 
            // uxPO
            // 
            this.uxPO.Location = new System.Drawing.Point(40, 28);
            this.uxPO.Name = "uxPO";
            this.uxPO.Size = new System.Drawing.Size(93, 21);
            this.uxPO.TabIndex = 3;
            this.uxPO.TextChanged += new System.EventHandler(this.uxPO_TextChanged);
            this.uxPO.GotFocus += new System.EventHandler(this.uxPO_GotFocus);
            this.uxPO.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxPO_KeyDown);
            // 
            // label5
            // 
            this.label5.Location = new System.Drawing.Point(-1, 108);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(41, 20);
            this.label5.Text = "Serial:";
            // 
            // uxPWD
            // 
            this.uxPWD.Location = new System.Drawing.Point(46, 3);
            this.uxPWD.MaxLength = 5;
            this.uxPWD.Name = "uxPWD";
            this.uxPWD.PasswordChar = '*';
            this.uxPWD.Size = new System.Drawing.Size(93, 21);
            this.uxPWD.TabIndex = 6;
            this.uxPWD.TextChanged += new System.EventHandler(this.uxPWD_TextChanged);
            this.uxPWD.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxPWD_KeyDown);
            // 
            // uxQty
            // 
            this.uxQty.Location = new System.Drawing.Point(40, 81);
            this.uxQty.Name = "uxQty";
            this.uxQty.Size = new System.Drawing.Size(93, 21);
            this.uxQty.TabIndex = 7;
            this.uxQty.GotFocus += new System.EventHandler(this.uxQty_GotFocus);
            this.uxQty.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxQty_KeyDown);
            // 
            // uxLot
            // 
            this.uxLot.Location = new System.Drawing.Point(40, 108);
            this.uxLot.Name = "uxLot";
            this.uxLot.Size = new System.Drawing.Size(93, 21);
            this.uxLot.TabIndex = 9;
            this.uxLot.TextChanged += new System.EventHandler(this.uxLot_TextChanged);
            this.uxLot.GotFocus += new System.EventHandler(this.uxLot_GotFocus);
            this.uxLot.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxLot_KeyDown);
            // 
            // uxPart
            // 
            this.uxPart.Location = new System.Drawing.Point(40, 54);
            this.uxPart.Name = "uxPart";
            this.uxPart.Size = new System.Drawing.Size(93, 21);
            this.uxPart.TabIndex = 5;
            this.uxPart.TextChanged += new System.EventHandler(this.uxPart_TextChanged);
            this.uxPart.GotFocus += new System.EventHandler(this.uxPart_GotFocus);
            this.uxPart.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxPart_KeyDown);
            // 
            // uxEnterPO
            // 
            this.uxEnterPO.Location = new System.Drawing.Point(157, 28);
            this.uxEnterPO.Name = "uxEnterPO";
            this.uxEnterPO.Size = new System.Drawing.Size(72, 21);
            this.uxEnterPO.TabIndex = 4;
            this.uxEnterPO.Text = "Enter";
            this.uxEnterPO.Click += new System.EventHandler(this.uxEnterPO_Click);
            // 
            // uxEnterQty
            // 
            this.uxEnterQty.Location = new System.Drawing.Point(157, 81);
            this.uxEnterQty.Name = "uxEnterQty";
            this.uxEnterQty.Size = new System.Drawing.Size(72, 21);
            this.uxEnterQty.TabIndex = 8;
            this.uxEnterQty.Text = "Enter";
            this.uxEnterQty.Click += new System.EventHandler(this.uxEnterQty_Click);
            // 
            // uxEnterLot
            // 
            this.uxEnterLot.Location = new System.Drawing.Point(157, 108);
            this.uxEnterLot.Name = "uxEnterLot";
            this.uxEnterLot.Size = new System.Drawing.Size(72, 21);
            this.uxEnterLot.TabIndex = 10;
            this.uxEnterLot.Text = "Enter";
            this.uxEnterLot.Click += new System.EventHandler(this.uxEnterLot_Click);
            // 
            // uxEnterPart
            // 
            this.uxEnterPart.Location = new System.Drawing.Point(157, 54);
            this.uxEnterPart.Name = "uxEnterPart";
            this.uxEnterPart.Size = new System.Drawing.Size(72, 21);
            this.uxEnterPart.TabIndex = 6;
            this.uxEnterPart.Text = "Enter";
            this.uxEnterPart.Click += new System.EventHandler(this.uxEnterPart_Click);
            // 
            // uxConfirmPWD
            // 
            this.uxConfirmPWD.Location = new System.Drawing.Point(163, 3);
            this.uxConfirmPWD.Name = "uxConfirmPWD";
            this.uxConfirmPWD.Size = new System.Drawing.Size(72, 21);
            this.uxConfirmPWD.TabIndex = 7;
            this.uxConfirmPWD.Text = "Confirm";
            this.uxConfirmPWD.Click += new System.EventHandler(this.uxConfirmPWD_Click);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(6, 3);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(34, 20);
            this.label1.Text = "Pwd:";
            // 
            // uxOperator
            // 
            this.uxOperator.Location = new System.Drawing.Point(46, 4);
            this.uxOperator.Name = "uxOperator";
            this.uxOperator.Size = new System.Drawing.Size(111, 19);
            this.uxOperator.Text = "label2";
            this.uxOperator.Visible = false;
            this.uxOperator.ParentChanged += new System.EventHandler(this.uxOperator_ParentChanged);
            // 
            // panelStdReceiving
            // 
            this.panelStdReceiving.Controls.Add(this.uxStoreSID);
            this.panelStdReceiving.Controls.Add(this.label2);
            this.panelStdReceiving.Controls.Add(this.uxSID);
            this.panelStdReceiving.Controls.Add(this.uxEnterSID);
            this.panelStdReceiving.Controls.Add(this.uxReceive);
            this.panelStdReceiving.Controls.Add(this.uxMessage);
            this.panelStdReceiving.Controls.Add(this.label4);
            this.panelStdReceiving.Controls.Add(this.label3);
            this.panelStdReceiving.Controls.Add(this.label5);
            this.panelStdReceiving.Controls.Add(this.label6);
            this.panelStdReceiving.Controls.Add(this.uxPO);
            this.panelStdReceiving.Controls.Add(this.uxQty);
            this.panelStdReceiving.Controls.Add(this.uxLot);
            this.panelStdReceiving.Controls.Add(this.uxPart);
            this.panelStdReceiving.Controls.Add(this.uxEnterPO);
            this.panelStdReceiving.Controls.Add(this.uxEnterQty);
            this.panelStdReceiving.Controls.Add(this.uxEnterLot);
            this.panelStdReceiving.Controls.Add(this.uxEnterPart);
            this.panelStdReceiving.Enabled = false;
            this.panelStdReceiving.Location = new System.Drawing.Point(6, 33);
            this.panelStdReceiving.Name = "panelStdReceiving";
            this.panelStdReceiving.Size = new System.Drawing.Size(229, 232);
            this.panelStdReceiving.GotFocus += new System.EventHandler(this.panelStdReceiving_GotFocus);
            // 
            // uxStoreSID
            // 
            this.uxStoreSID.Location = new System.Drawing.Point(136, 3);
            this.uxStoreSID.Name = "uxStoreSID";
            this.uxStoreSID.Size = new System.Drawing.Size(19, 20);
            this.uxStoreSID.TabIndex = 1;
            this.uxStoreSID.Visible = false;
            // 
            // menuItemClose
            // 
            this.menuItemClose.Text = "Close";
            this.menuItemClose.Click += new System.EventHandler(this.menuItemClose_Click);
            // 
            // mainMenuReceivingDock
            // 
            this.mainMenuReceivingDock.MenuItems.Add(this.menuItemClose);
            this.mainMenuReceivingDock.MenuItems.Add(this.menuItemPrintServer);
            this.mainMenuReceivingDock.MenuItems.Add(this.menuItemLocation);
            // 
            // menuItemPrintServer
            // 
            this.menuItemPrintServer.MenuItems.Add(this.menuItem1PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem2PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem3PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem4PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem5PrintServer);
            this.menuItemPrintServer.Text = "";
            this.menuItemPrintServer.Click += new System.EventHandler(this.menuItemPrintServer_Click);
            // 
            // menuItem1PrintServer
            // 
            this.menuItem1PrintServer.Text = "";
            this.menuItem1PrintServer.Click += new System.EventHandler(this.menuItem1PrintServer_Click);
            // 
            // menuItem2PrintServer
            // 
            this.menuItem2PrintServer.Text = "";
            this.menuItem2PrintServer.Click += new System.EventHandler(this.menuItem2PrintServer_Click);
            // 
            // menuItem3PrintServer
            // 
            this.menuItem3PrintServer.Text = "";
            this.menuItem3PrintServer.Click += new System.EventHandler(this.menuItem3PrintServer_Click);
            // 
            // menuItem4PrintServer
            // 
            this.menuItem4PrintServer.Text = "";
            this.menuItem4PrintServer.Click += new System.EventHandler(this.menuItem4PrintServer_Click);
            // 
            // menuItem5PrintServer
            // 
            this.menuItem5PrintServer.Text = "";
            this.menuItem5PrintServer.Click += new System.EventHandler(this.menuItem5PrintServer_Click);
            // 
            // menuItemLocation
            // 
            this.menuItemLocation.Text = "Location";
            this.menuItemLocation.Click += new System.EventHandler(this.menuItem1_Click);
            // 
            // frmReceivingDock
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.ControlBox = false;
            this.Controls.Add(this.uxPWD);
            this.Controls.Add(this.uxConfirmPWD);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.uxOperator);
            this.Controls.Add(this.panelStdReceiving);
            this.Menu = this.mainMenuReceivingDock;
            this.Name = "frmReceivingDock";
            this.Text = "Receiving Dock 1.02";
            this.Load += new System.EventHandler(this.frmReceivingDock_Load);
            this.Closing += new System.ComponentModel.CancelEventHandler(this.frmReceivingDock_Closing);
            this.panelStdReceiving.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox uxSID;
        private System.Windows.Forms.Button uxEnterSID;
        private System.Windows.Forms.Button uxReceive;
        private System.Windows.Forms.Label uxMessage;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox uxPO;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox uxPWD;
        private System.Windows.Forms.TextBox uxQty;
        private System.Windows.Forms.TextBox uxLot;
        private System.Windows.Forms.TextBox uxPart;
        private System.Windows.Forms.Button uxEnterPO;
        private System.Windows.Forms.Button uxEnterQty;
        private System.Windows.Forms.Button uxEnterLot;
        private System.Windows.Forms.Button uxEnterPart;
        private System.Windows.Forms.Button uxConfirmPWD;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label uxOperator;
        private System.Windows.Forms.Panel panelStdReceiving;
        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.MainMenu mainMenuReceivingDock;
        private System.Windows.Forms.MenuItem menuItemPrintServer;
        private System.Windows.Forms.CheckBox uxStoreSID;
        private System.Windows.Forms.MenuItem menuItem1PrintServer;
        private System.Windows.Forms.MenuItem menuItem2PrintServer;
        private System.Windows.Forms.MenuItem menuItem3PrintServer;
        private System.Windows.Forms.MenuItem menuItem4PrintServer;
        private System.Windows.Forms.MenuItem menuItem5PrintServer;
        private System.Windows.Forms.MenuItem menuItemLocation;
    }
}