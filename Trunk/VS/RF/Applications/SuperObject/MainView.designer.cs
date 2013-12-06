namespace SuperObject
{
    partial class MainView
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenu1;

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
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.menuItem1 = new System.Windows.Forms.MenuItem();
            this.menuItemPrintServer = new System.Windows.Forms.MenuItem();
            this.menuItemDPrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem1PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem2PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem3PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItem4PrintServer = new System.Windows.Forms.MenuItem();
            this.menuItemMenu = new System.Windows.Forms.MenuItem();
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.menuItemEnterSerial = new System.Windows.Forms.MenuItem();
            this.menuItemEditSO = new System.Windows.Forms.MenuItem();
            this.menuItemDeleteSerial = new System.Windows.Forms.MenuItem();
            this.menuItemReprint = new System.Windows.Forms.MenuItem();
            this.logOnOffControl1 = new Controls.LogOnOffControl();
            this.SuspendLayout();
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.Add(this.menuItem1);
            this.mainMenu1.MenuItems.Add(this.menuItemPrintServer);
            this.mainMenu1.MenuItems.Add(this.menuItemMenu);
            // 
            // menuItem1
            // 
            this.menuItem1.Text = "";
            // 
            // menuItemPrintServer
            // 
            this.menuItemPrintServer.MenuItems.Add(this.menuItemDPrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem1PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem2PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem3PrintServer);
            this.menuItemPrintServer.MenuItems.Add(this.menuItem4PrintServer);
            this.menuItemPrintServer.Text = "";
            // 
            // menuItemDPrintServer
            // 
            this.menuItemDPrintServer.Text = "";
            // 
            // menuItem1PrintServer
            // 
            this.menuItem1PrintServer.Text = "";
            // 
            // menuItem2PrintServer
            // 
            this.menuItem2PrintServer.Text = "";
            // 
            // menuItem3PrintServer
            // 
            this.menuItem3PrintServer.Text = "";
            // 
            // menuItem4PrintServer
            // 
            this.menuItem4PrintServer.Text = "";
            // 
            // menuItemMenu
            // 
            this.menuItemMenu.MenuItems.Add(this.menuItemClose);
            this.menuItemMenu.MenuItems.Add(this.menuItemEnterSerial);
            this.menuItemMenu.MenuItems.Add(this.menuItemEditSO);
            this.menuItemMenu.MenuItems.Add(this.menuItemDeleteSerial);
            this.menuItemMenu.MenuItems.Add(this.menuItemReprint);
            this.menuItemMenu.Text = "Menu";
            // 
            // menuItemClose
            // 
            this.menuItemClose.Text = "Close";
            this.menuItemClose.Click += new System.EventHandler(this.MenuItemCloseClick);
            // 
            // menuItemEnterSerial
            // 
            this.menuItemEnterSerial.Text = "Enter Serial";
            // 
            // menuItemEditSO
            // 
            this.menuItemEditSO.Text = "Edit SO";
            // 
            // menuItemDeleteSerial
            // 
            this.menuItemDeleteSerial.Text = "Delete Serial";
            // 
            // menuItemReprint
            // 
            this.menuItemReprint.Text = "Reprint";
            // 
            // logOnOffControl1
            // 
            this.logOnOffControl1.Location = new System.Drawing.Point(0, 65);
            this.logOnOffControl1.Name = "logOnOffControl1";
            this.logOnOffControl1.Size = new System.Drawing.Size(240, 39);
            this.logOnOffControl1.TabIndex = 33;
            this.logOnOffControl1.OperatorCodeChanged += new Controls.LogOnOffControl.OperatorCodeChangedEventHandler(this.logOnOffControl1_OperatorCodeChanged);
            this.logOnOffControl1.LogOnOffChanged += new Controls.LogOnOffControl.LogOnOffChangedEventHandler(this.logOnOffControl1_LogOnOffChanged);
            // 
            // MainView
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.ControlBox = false;
            this.Controls.Add(this.logOnOffControl1);
            this.Menu = this.mainMenu1;
            this.Name = "MainView";
            this.Text = "Transfer ver 1.05";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItemMenu;
        private System.Windows.Forms.MenuItem menuItemPrintServer;
        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.MenuItem menuItemEnterSerial;
        private System.Windows.Forms.MenuItem menuItemEditSO;
        private System.Windows.Forms.MenuItem menuItemDeleteSerial;
        private System.Windows.Forms.MenuItem menuItem1PrintServer;
        private System.Windows.Forms.MenuItem menuItem2PrintServer;
        private System.Windows.Forms.MenuItem menuItem3PrintServer;
        private System.Windows.Forms.MenuItem menuItem4PrintServer;
        private System.Windows.Forms.MenuItem menuItemDPrintServer;
        private System.Windows.Forms.MenuItem menuItemReprint;
        private Controls.LogOnOffControl logOnOffControl1;
    }
}