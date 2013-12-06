namespace PhysicalInventory
{
    partial class ChooseAddress
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
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.uxCBAisle = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.uxCBShelf = new System.Windows.Forms.ComboBox();
            this.uxCBSubshelf = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.uxButtonBeginPhysical = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.uxTextBoxPassword = new System.Windows.Forms.TextBox();
            this.uxButtonContinuePhysical = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.Add(this.menuItemClose);
            // 
            // menuItemClose
            // 
            this.menuItemClose.Text = "Close";
            this.menuItemClose.Click += new System.EventHandler(this.menuItemClose_Click);
            // 
            // uxCBAisle
            // 
            this.uxCBAisle.BackColor = System.Drawing.Color.Chartreuse;
            this.uxCBAisle.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.uxCBAisle.Items.Add("A");
            this.uxCBAisle.Items.Add("B");
            this.uxCBAisle.Items.Add("C");
            this.uxCBAisle.Items.Add("D");
            this.uxCBAisle.Items.Add("E");
            this.uxCBAisle.Items.Add("F");
            this.uxCBAisle.Items.Add("G");
            this.uxCBAisle.Items.Add("H");
            this.uxCBAisle.Items.Add("J");
            this.uxCBAisle.Items.Add("K");
            this.uxCBAisle.Location = new System.Drawing.Point(21, 72);
            this.uxCBAisle.Name = "uxCBAisle";
            this.uxCBAisle.Size = new System.Drawing.Size(49, 29);
            this.uxCBAisle.TabIndex = 20;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(5, 30);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(60, 19);
            this.label3.Text = "Location:";
            // 
            // uxCBShelf
            // 
            this.uxCBShelf.BackColor = System.Drawing.Color.Chartreuse;
            this.uxCBShelf.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.uxCBShelf.Items.Add("0");
            this.uxCBShelf.Items.Add("1");
            this.uxCBShelf.Items.Add("2");
            this.uxCBShelf.Items.Add("3");
            this.uxCBShelf.Items.Add("4");
            this.uxCBShelf.Location = new System.Drawing.Point(86, 72);
            this.uxCBShelf.Name = "uxCBShelf";
            this.uxCBShelf.Size = new System.Drawing.Size(49, 29);
            this.uxCBShelf.TabIndex = 21;
            // 
            // uxCBSubshelf
            // 
            this.uxCBSubshelf.BackColor = System.Drawing.Color.Chartreuse;
            this.uxCBSubshelf.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.uxCBSubshelf.Items.Add("0");
            this.uxCBSubshelf.Items.Add("1");
            this.uxCBSubshelf.Items.Add("2");
            this.uxCBSubshelf.Items.Add("3");
            this.uxCBSubshelf.Items.Add("4");
            this.uxCBSubshelf.Items.Add("5");
            this.uxCBSubshelf.Items.Add("6");
            this.uxCBSubshelf.Items.Add("7");
            this.uxCBSubshelf.Items.Add("8");
            this.uxCBSubshelf.Items.Add("9");
            this.uxCBSubshelf.Items.Add("10");
            this.uxCBSubshelf.Items.Add("11");
            this.uxCBSubshelf.Items.Add("12");
            this.uxCBSubshelf.Location = new System.Drawing.Point(152, 72);
            this.uxCBSubshelf.Name = "uxCBSubshelf";
            this.uxCBSubshelf.Size = new System.Drawing.Size(49, 29);
            this.uxCBSubshelf.TabIndex = 22;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(21, 49);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(218, 20);
            this.label2.Text = "Choose aisle, shelf, and subshelf.";
            // 
            // uxButtonBeginPhysical
            // 
            this.uxButtonBeginPhysical.BackColor = System.Drawing.Color.Chartreuse;
            this.uxButtonBeginPhysical.Location = new System.Drawing.Point(21, 116);
            this.uxButtonBeginPhysical.Name = "uxButtonBeginPhysical";
            this.uxButtonBeginPhysical.Size = new System.Drawing.Size(206, 53);
            this.uxButtonBeginPhysical.TabIndex = 30;
            this.uxButtonBeginPhysical.Text = "Begin Physical";
            this.uxButtonBeginPhysical.Click += new System.EventHandler(this.uxButtonBeginPhysical_Click);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(5, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 22);
            this.label1.Text = "Login:";
            // 
            // uxTextBoxPassword
            // 
            this.uxTextBoxPassword.AcceptsReturn = true;
            this.uxTextBoxPassword.Location = new System.Drawing.Point(71, 3);
            this.uxTextBoxPassword.Name = "uxTextBoxPassword";
            this.uxTextBoxPassword.PasswordChar = '*';
            this.uxTextBoxPassword.Size = new System.Drawing.Size(120, 23);
            this.uxTextBoxPassword.TabIndex = 10;
            // 
            // uxButtonContinuePhysical
            // 
            this.uxButtonContinuePhysical.BackColor = System.Drawing.Color.Chartreuse;
            this.uxButtonContinuePhysical.Location = new System.Drawing.Point(21, 175);
            this.uxButtonContinuePhysical.Name = "uxButtonContinuePhysical";
            this.uxButtonContinuePhysical.Size = new System.Drawing.Size(206, 53);
            this.uxButtonContinuePhysical.TabIndex = 30;
            this.uxButtonContinuePhysical.Text = "Continue Physical";
            this.uxButtonContinuePhysical.Click += new System.EventHandler(this.uxButtonContinuePhysical_Click);
            // 
            // ChooseAddress
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(239, 250);
            this.ControlBox = false;
            this.Controls.Add(this.uxTextBoxPassword);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.uxButtonContinuePhysical);
            this.Controls.Add(this.uxButtonBeginPhysical);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.uxCBSubshelf);
            this.Controls.Add(this.uxCBShelf);
            this.Controls.Add(this.uxCBAisle);
            this.MaximizeBox = false;
            this.Menu = this.mainMenu1;
            this.MinimizeBox = false;
            this.Name = "ChooseAddress";
            this.Text = "Physical Inventory";
            this.Load += new System.EventHandler(this.ChooseAddress_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.ComboBox uxCBAisle;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox uxCBShelf;
        private System.Windows.Forms.ComboBox uxCBSubshelf;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button uxButtonBeginPhysical;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox uxTextBoxPassword;
        private System.Windows.Forms.Button uxButtonContinuePhysical;
    }
}

