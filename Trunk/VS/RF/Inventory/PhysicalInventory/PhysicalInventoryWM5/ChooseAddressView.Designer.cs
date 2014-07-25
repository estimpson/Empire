namespace PhysicalInventory
{
    partial class ChooseAddressView
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
            this.RackSelection = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.ShelfSelection = new System.Windows.Forms.ComboBox();
            this.PositionSelection = new System.Windows.Forms.ComboBox();
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
            this.menuItemClose.Click += new System.EventHandler(this.MenuItemCloseClick);
            // 
            // RackSelection
            // 
            this.RackSelection.BackColor = System.Drawing.Color.Chartreuse;
            this.RackSelection.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.RackSelection.Location = new System.Drawing.Point(21, 72);
            this.RackSelection.Name = "RackSelection";
            this.RackSelection.Size = new System.Drawing.Size(49, 29);
            this.RackSelection.TabIndex = 20;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(5, 30);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(60, 19);
            this.label3.Text = "Location:";
            // 
            // ShelfSelection
            // 
            this.ShelfSelection.BackColor = System.Drawing.Color.Chartreuse;
            this.ShelfSelection.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.ShelfSelection.Location = new System.Drawing.Point(86, 72);
            this.ShelfSelection.Name = "ShelfSelection";
            this.ShelfSelection.Size = new System.Drawing.Size(49, 29);
            this.ShelfSelection.TabIndex = 21;
            // 
            // PositionSelection
            // 
            this.PositionSelection.BackColor = System.Drawing.Color.Chartreuse;
            this.PositionSelection.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.PositionSelection.Location = new System.Drawing.Point(152, 72);
            this.PositionSelection.Name = "PositionSelection";
            this.PositionSelection.Size = new System.Drawing.Size(69, 29);
            this.PositionSelection.TabIndex = 22;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(21, 49);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(218, 20);
            this.label2.Text = "Choose rack, shelf, and position.";
            // 
            // uxButtonBeginPhysical
            // 
            this.uxButtonBeginPhysical.BackColor = System.Drawing.Color.Chartreuse;
            this.uxButtonBeginPhysical.Location = new System.Drawing.Point(21, 116);
            this.uxButtonBeginPhysical.Name = "uxButtonBeginPhysical";
            this.uxButtonBeginPhysical.Size = new System.Drawing.Size(206, 53);
            this.uxButtonBeginPhysical.TabIndex = 30;
            this.uxButtonBeginPhysical.Text = "Begin Physical";
            this.uxButtonBeginPhysical.Click += new System.EventHandler(this.UxButtonBeginPhysicalClick);
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
            this.uxButtonContinuePhysical.Click += new System.EventHandler(this.UxButtonContinuePhysicalClick);
            // 
            // ChooseAddressView
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
            this.Controls.Add(this.PositionSelection);
            this.Controls.Add(this.ShelfSelection);
            this.Controls.Add(this.RackSelection);
            this.MaximizeBox = false;
            this.Menu = this.mainMenu1;
            this.MinimizeBox = false;
            this.Name = "ChooseAddressView";
            this.Text = "Physical Inventory";
            this.Load += new System.EventHandler(this.ChooseAddressViewLoad);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.ComboBox RackSelection;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox ShelfSelection;
        private System.Windows.Forms.ComboBox PositionSelection;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button uxButtonBeginPhysical;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox uxTextBoxPassword;
        private System.Windows.Forms.Button uxButtonContinuePhysical;
    }
}

