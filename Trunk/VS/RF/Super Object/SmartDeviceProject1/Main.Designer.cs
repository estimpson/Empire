namespace SmartDeviceProject1
{
    partial class Main
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
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.menuItem2 = new System.Windows.Forms.MenuItem();
            this.menuItem3 = new System.Windows.Forms.MenuItem();
            this.menuItem4 = new System.Windows.Forms.MenuItem();
            this.menuItem5 = new System.Windows.Forms.MenuItem();
            this.menuItem6 = new System.Windows.Forms.MenuItem();
            this.label4 = new System.Windows.Forms.Label();
            this.uxPWD = new System.Windows.Forms.TextBox();
            this.uxConfirmPWD = new System.Windows.Forms.Button();
            this.uxOperator = new System.Windows.Forms.Label();
            this.panelStdReceiving = new System.Windows.Forms.Panel();
            this.uxSODrop = new System.Windows.Forms.ComboBox();
            this.uxLocation = new System.Windows.Forms.TextBox();
            this.button3 = new System.Windows.Forms.Button();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.uxCount = new System.Windows.Forms.Label();
            this.uxMessage = new System.Windows.Forms.Label();
            this.uxListBox1 = new System.Windows.Forms.ListBox();
            this.label2 = new System.Windows.Forms.Label();
            this.uxbutton1 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.uxPanel = new System.Windows.Forms.Panel();
            this.uxContTroy = new System.Windows.Forms.RadioButton();
            this.uxEdit = new System.Windows.Forms.Button();
            this.uxLocationLabel = new System.Windows.Forms.Label();
            this.uxLocationBtn = new System.Windows.Forms.Button();
            this.uxContainer = new System.Windows.Forms.RadioButton();
            this.button2 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.uxPanelSo = new System.Windows.Forms.Panel();
            this.uxSoCancel = new System.Windows.Forms.Button();
            this.uxSoOK = new System.Windows.Forms.Button();
            this.panelStdReceiving.SuspendLayout();
            this.uxPanel.SuspendLayout();
            this.uxPanelSo.SuspendLayout();
            this.SuspendLayout();
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.Add(this.menuItem1);
            this.mainMenu1.MenuItems.Add(this.menuItemPrintServer);
            this.mainMenu1.MenuItems.Add(this.menuItemClose);
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
            this.menuItemPrintServer.Click += new System.EventHandler(this.menuItemPrint1_Click);
            // 
            // menuItemDPrintServer
            // 
            this.menuItemDPrintServer.Text = "";
            this.menuItemDPrintServer.Click += new System.EventHandler(this.menuItemDPrintServer_Click);
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
            // menuItemClose
            // 
            this.menuItemClose.MenuItems.Add(this.menuItem2);
            this.menuItemClose.MenuItems.Add(this.menuItem3);
            this.menuItemClose.MenuItems.Add(this.menuItem4);
            this.menuItemClose.MenuItems.Add(this.menuItem5);
            this.menuItemClose.MenuItems.Add(this.menuItem6);
            this.menuItemClose.Text = "Menu";
            this.menuItemClose.Click += new System.EventHandler(this.menuItemClose_Click);
            // 
            // menuItem2
            // 
            this.menuItem2.Text = "Close";
            this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click_1);
            // 
            // menuItem3
            // 
            this.menuItem3.Text = "Enter Serial";
            this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
            // 
            // menuItem4
            // 
            this.menuItem4.Text = "Edit SO";
            this.menuItem4.Click += new System.EventHandler(this.menuItem4_Click);
            // 
            // menuItem5
            // 
            this.menuItem5.Text = "Delete Serial";
            this.menuItem5.Click += new System.EventHandler(this.menuItem5_Click);
            // 
            // menuItem6
            // 
            this.menuItem6.Text = "Reprint";
            this.menuItem6.Click += new System.EventHandler(this.menuItem6_Click);
            // 
            // label4
            // 
            this.label4.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.label4.Location = new System.Drawing.Point(8, 4);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(46, 20);
            this.label4.Text = "PWD:";
            // 
            // uxPWD
            // 
            this.uxPWD.Location = new System.Drawing.Point(56, 4);
            this.uxPWD.Name = "uxPWD";
            this.uxPWD.PasswordChar = '*';
            this.uxPWD.Size = new System.Drawing.Size(87, 21);
            this.uxPWD.TabIndex = 30;
            this.uxPWD.TextChanged += new System.EventHandler(this.uxPWD_TextChanged);
            this.uxPWD.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxPWD_KeyDown);
            this.uxPWD.KeyUp += new System.Windows.Forms.KeyEventHandler(this.uxPWD_KeyDown);
            // 
            // uxConfirmPWD
            // 
            this.uxConfirmPWD.Location = new System.Drawing.Point(161, 4);
            this.uxConfirmPWD.Name = "uxConfirmPWD";
            this.uxConfirmPWD.Size = new System.Drawing.Size(58, 20);
            this.uxConfirmPWD.TabIndex = 31;
            this.uxConfirmPWD.Text = "Confirm";
            this.uxConfirmPWD.Click += new System.EventHandler(this.uxConfirmPWD_Click_1);
            // 
            // uxOperator
            // 
            this.uxOperator.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.uxOperator.Location = new System.Drawing.Point(71, 5);
            this.uxOperator.Name = "uxOperator";
            this.uxOperator.Size = new System.Drawing.Size(77, 20);
            this.uxOperator.Visible = false;
            this.uxOperator.ParentChanged += new System.EventHandler(this.uxOperator_ParentChanged);
            // 
            // panelStdReceiving
            // 
            this.panelStdReceiving.Controls.Add(this.uxSODrop);
            this.panelStdReceiving.Controls.Add(this.uxPanelSo);
            this.panelStdReceiving.Controls.Add(this.uxLocation);
            this.panelStdReceiving.Controls.Add(this.button3);
            this.panelStdReceiving.Controls.Add(this.checkBox1);
            this.panelStdReceiving.Controls.Add(this.label3);
            this.panelStdReceiving.Controls.Add(this.uxCount);
            this.panelStdReceiving.Controls.Add(this.uxMessage);
            this.panelStdReceiving.Controls.Add(this.uxListBox1);
            this.panelStdReceiving.Controls.Add(this.label2);
            this.panelStdReceiving.Controls.Add(this.uxbutton1);
            this.panelStdReceiving.Controls.Add(this.label1);
            this.panelStdReceiving.Enabled = false;
            this.panelStdReceiving.Location = new System.Drawing.Point(7, 30);
            this.panelStdReceiving.Name = "panelStdReceiving";
            this.panelStdReceiving.Size = new System.Drawing.Size(230, 206);
            this.panelStdReceiving.Visible = false;
            this.panelStdReceiving.GotFocus += new System.EventHandler(this.panelStdReceiving_GotFocus);
            // 
            // uxSODrop
            // 
            this.uxSODrop.Enabled = false;
            this.uxSODrop.Location = new System.Drawing.Point(99, 23);
            this.uxSODrop.Name = "uxSODrop";
            this.uxSODrop.Size = new System.Drawing.Size(116, 22);
            this.uxSODrop.TabIndex = 69;
            // 
            // uxLocation
            // 
            this.uxLocation.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.uxLocation.Location = new System.Drawing.Point(67, 3);
            this.uxLocation.Name = "uxLocation";
            this.uxLocation.Size = new System.Drawing.Size(117, 21);
            this.uxLocation.TabIndex = 61;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(14, 222);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(50, 17);
            this.button3.TabIndex = 62;
            this.button3.Text = "button3";
            this.button3.Visible = false;
            // 
            // checkBox1
            // 
            this.checkBox1.Location = new System.Drawing.Point(203, 59);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(21, 23);
            this.checkBox1.TabIndex = 51;
            this.checkBox1.Text = "checkBox1";
            this.checkBox1.Visible = false;
            this.checkBox1.CheckStateChanged += new System.EventHandler(this.checkBox1_CheckStateChanged);
            // 
            // label3
            // 
            this.label3.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.label3.Location = new System.Drawing.Point(-1, 23);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(100, 20);
            this.label3.Text = "Super Object:";
            // 
            // uxCount
            // 
            this.uxCount.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.uxCount.Location = new System.Drawing.Point(129, 74);
            this.uxCount.Name = "uxCount";
            this.uxCount.Size = new System.Drawing.Size(74, 20);
            this.uxCount.Text = "0";
            this.uxCount.ParentChanged += new System.EventHandler(this.uxCount_ParentChanged_2);
            // 
            // uxMessage
            // 
            this.uxMessage.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.uxMessage.Location = new System.Drawing.Point(16, 209);
            this.uxMessage.Name = "uxMessage";
            this.uxMessage.Size = new System.Drawing.Size(199, 20);
            this.uxMessage.Text = "Log in.";
            this.uxMessage.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.uxMessage.ParentChanged += new System.EventHandler(this.uxMessage_ParentChanged_2);
            // 
            // uxListBox1
            // 
            this.uxListBox1.Location = new System.Drawing.Point(16, 97);
            this.uxListBox1.Name = "uxListBox1";
            this.uxListBox1.Size = new System.Drawing.Size(199, 100);
            this.uxListBox1.TabIndex = 31;
            this.uxListBox1.SelectedIndexChanged += new System.EventHandler(this.uxListBox1_SelectedIndexChanged_1);
            this.uxListBox1.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.uxListBox1_KeyPress);
            this.uxListBox1.SelectedValueChanged += new System.EventHandler(this.uxListBox1_SelectedValueChanged);
            // 
            // label2
            // 
            this.label2.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.label2.Location = new System.Drawing.Point(67, 74);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(100, 20);
            this.label2.Text = "Counter:";
            // 
            // uxbutton1
            // 
            this.uxbutton1.Location = new System.Drawing.Point(31, 46);
            this.uxbutton1.Name = "uxbutton1";
            this.uxbutton1.Size = new System.Drawing.Size(163, 20);
            this.uxbutton1.TabIndex = 30;
            this.uxbutton1.Text = "Print Label";
            this.uxbutton1.Click += new System.EventHandler(this.button1_Click_2);
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Tahoma", 11F, System.Drawing.FontStyle.Regular);
            this.label1.Location = new System.Drawing.Point(0, 1);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(64, 22);
            this.label1.Text = "Location:";
            // 
            // uxPanel
            // 
            this.uxPanel.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.uxPanel.Controls.Add(this.uxContTroy);
            this.uxPanel.Controls.Add(this.uxEdit);
            this.uxPanel.Controls.Add(this.uxLocationLabel);
            this.uxPanel.Controls.Add(this.uxLocationBtn);
            this.uxPanel.Controls.Add(this.uxContainer);
            this.uxPanel.Controls.Add(this.button2);
            this.uxPanel.Controls.Add(this.button1);
            this.uxPanel.Location = new System.Drawing.Point(4, 30);
            this.uxPanel.Name = "uxPanel";
            this.uxPanel.Size = new System.Drawing.Size(230, 215);
            this.uxPanel.Visible = false;
            this.uxPanel.GotFocus += new System.EventHandler(this.uxPanel_GotFocus);
            // 
            // uxContTroy
            // 
            this.uxContTroy.Location = new System.Drawing.Point(13, 46);
            this.uxContTroy.Name = "uxContTroy";
            this.uxContTroy.Size = new System.Drawing.Size(100, 20);
            this.uxContTroy.TabIndex = 0;
            this.uxContTroy.CheckedChanged += new System.EventHandler(this.radioButton1_CheckedChanged);
            // 
            // uxEdit
            // 
            this.uxEdit.Location = new System.Drawing.Point(135, 48);
            this.uxEdit.Name = "uxEdit";
            this.uxEdit.Size = new System.Drawing.Size(73, 18);
            this.uxEdit.TabIndex = 34;
            this.uxEdit.Text = "Add Con.";
            this.uxEdit.Click += new System.EventHandler(this.button1_Click_3);
            // 
            // uxLocationLabel
            // 
            this.uxLocationLabel.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold);
            this.uxLocationLabel.Location = new System.Drawing.Point(32, 12);
            this.uxLocationLabel.Name = "uxLocationLabel";
            this.uxLocationLabel.Size = new System.Drawing.Size(158, 19);
            this.uxLocationLabel.Text = "Choose Location:";
            // 
            // uxLocationBtn
            // 
            this.uxLocationBtn.Location = new System.Drawing.Point(12, 115);
            this.uxLocationBtn.Name = "uxLocationBtn";
            this.uxLocationBtn.Size = new System.Drawing.Size(87, 22);
            this.uxLocationBtn.TabIndex = 2;
            this.uxLocationBtn.Text = "Continue";
            this.uxLocationBtn.Click += new System.EventHandler(this.uxLocationBtn_Click);
            // 
            // uxContainer
            // 
            this.uxContainer.Location = new System.Drawing.Point(12, 72);
            this.uxContainer.Name = "uxContainer";
            this.uxContainer.Size = new System.Drawing.Size(117, 20);
            this.uxContainer.TabIndex = 1;
            this.uxContainer.Text = "Container";
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(165, 72);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(27, 20);
            this.button2.TabIndex = 43;
            this.button2.Text = "+";
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(135, 72);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(24, 20);
            this.button1.TabIndex = 42;
            this.button1.Text = "-";
            this.button1.Click += new System.EventHandler(this.button1_Click_4);
            // 
            // uxPanelSo
            // 
            this.uxPanelSo.Controls.Add(this.uxSoCancel);
            this.uxPanelSo.Controls.Add(this.uxSoOK);
            this.uxPanelSo.Location = new System.Drawing.Point(21, 12);
            this.uxPanelSo.Name = "uxPanelSo";
            this.uxPanelSo.Size = new System.Drawing.Size(191, 79);
            this.uxPanelSo.Visible = false;
            this.uxPanelSo.GotFocus += new System.EventHandler(this.uxPanelSo_GotFocus);
            // 
            // uxSoCancel
            // 
            this.uxSoCancel.Location = new System.Drawing.Point(109, 52);
            this.uxSoCancel.Name = "uxSoCancel";
            this.uxSoCancel.Size = new System.Drawing.Size(73, 20);
            this.uxSoCancel.TabIndex = 3;
            this.uxSoCancel.Text = "Cancel";
            this.uxSoCancel.Click += new System.EventHandler(this.uxSoCancel_Click);
            // 
            // uxSoOK
            // 
            this.uxSoOK.Location = new System.Drawing.Point(29, 52);
            this.uxSoOK.Name = "uxSoOK";
            this.uxSoOK.Size = new System.Drawing.Size(73, 20);
            this.uxSoOK.TabIndex = 2;
            this.uxSoOK.Text = "OK";
            this.uxSoOK.Click += new System.EventHandler(this.uxSoOK_Click);
            // 
            // Main
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.ControlBox = false;
            this.Controls.Add(this.panelStdReceiving);
            this.Controls.Add(this.uxOperator);
            this.Controls.Add(this.uxConfirmPWD);
            this.Controls.Add(this.uxPWD);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.uxPanel);
            this.Menu = this.mainMenu1;
            this.Name = "Main";
            this.Text = "Transfer ver 1.05";
            this.Load += new System.EventHandler(this.Main_Load);
            this.panelStdReceiving.ResumeLayout(false);
            this.uxPanel.ResumeLayout(false);
            this.uxPanelSo.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox uxPWD;
        private System.Windows.Forms.Button uxConfirmPWD;
        private System.Windows.Forms.Label uxOperator;
        private System.Windows.Forms.Panel panelStdReceiving;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label uxCount;
        private System.Windows.Forms.Label uxMessage;
        private System.Windows.Forms.ListBox uxListBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button uxbutton1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.MenuItem menuItemPrintServer;
        private System.Windows.Forms.Button uxEdit;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.Panel uxPanel;
        private System.Windows.Forms.Button uxLocationBtn;
        private System.Windows.Forms.Label uxLocationLabel;
        private System.Windows.Forms.TextBox uxLocation;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.RadioButton uxContainer;
        private System.Windows.Forms.RadioButton uxContTroy;
        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.Panel uxPanelSo;
        private System.Windows.Forms.Button uxSoCancel;
        private System.Windows.Forms.Button uxSoOK;
        private System.Windows.Forms.MenuItem menuItem2;
        private System.Windows.Forms.MenuItem menuItem3;
        private System.Windows.Forms.MenuItem menuItem4;
        private System.Windows.Forms.MenuItem menuItem5;
        private System.Windows.Forms.MenuItem menuItem1PrintServer;
        private System.Windows.Forms.MenuItem menuItem2PrintServer;
        private System.Windows.Forms.MenuItem menuItem3PrintServer;
        private System.Windows.Forms.MenuItem menuItem4PrintServer;
        private System.Windows.Forms.MenuItem menuItemDPrintServer;
        private System.Windows.Forms.ComboBox uxSODrop;
        private System.Windows.Forms.MenuItem menuItem6;
    }
}