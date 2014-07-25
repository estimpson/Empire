namespace PhysicalInventory
{
    partial class ScanToLocationView
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ScanToLocationView));
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.menuItemRefresh = new System.Windows.Forms.MenuItem();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.PositionSelection = new System.Windows.Forms.ComboBox();
            this.ShelfSelection = new System.Windows.Forms.ComboBox();
            this.RackSelection = new System.Windows.Forms.ComboBox();
            this.uxGridProgress = new System.Windows.Forms.DataGrid();
            this.uxLabelOperatorCode = new System.Windows.Forms.Label();
            this.uxLabelProgress = new System.Windows.Forms.Label();
            this.uxLabelMessage = new System.Windows.Forms.Label();
            this.uxTextBoxSerial = new System.Windows.Forms.TextBox();
            this.uxCBSerialEnter = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.Add(this.menuItemClose);
            this.mainMenu1.MenuItems.Add(this.menuItemRefresh);
            // 
            // menuItemClose
            // 
            resources.ApplyResources(this.menuItemClose, "menuItemClose");
            this.menuItemClose.Click += new System.EventHandler(this.MenuItemCloseClick);
            // 
            // menuItemRefresh
            // 
            resources.ApplyResources(this.menuItemRefresh, "menuItemRefresh");
            this.menuItemRefresh.Click += new System.EventHandler(this.MenuItemRefreshClick);
            // 
            // label1
            // 
            resources.ApplyResources(this.label1, "label1");
            this.label1.Name = "label1";
            // 
            // label2
            // 
            resources.ApplyResources(this.label2, "label2");
            this.label2.Name = "label2";
            // 
            // label3
            // 
            resources.ApplyResources(this.label3, "label3");
            this.label3.Name = "label3";
            // 
            // PositionSelection
            // 
            this.PositionSelection.BackColor = System.Drawing.Color.Chartreuse;
            resources.ApplyResources(this.PositionSelection, "PositionSelection");
            this.PositionSelection.Name = "PositionSelection";
            // 
            // ShelfSelection
            // 
            this.ShelfSelection.BackColor = System.Drawing.Color.Chartreuse;
            resources.ApplyResources(this.ShelfSelection, "ShelfSelection");
            this.ShelfSelection.Name = "ShelfSelection";
            // 
            // RackSelection
            // 
            this.RackSelection.BackColor = System.Drawing.Color.Chartreuse;
            resources.ApplyResources(this.RackSelection, "RackSelection");
            this.RackSelection.Name = "RackSelection";
            // 
            // uxGridProgress
            // 
            this.uxGridProgress.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            resources.ApplyResources(this.uxGridProgress, "uxGridProgress");
            this.uxGridProgress.Name = "uxGridProgress";
            // 
            // uxLabelOperatorCode
            // 
            resources.ApplyResources(this.uxLabelOperatorCode, "uxLabelOperatorCode");
            this.uxLabelOperatorCode.Name = "uxLabelOperatorCode";
            // 
            // uxLabelProgress
            // 
            resources.ApplyResources(this.uxLabelProgress, "uxLabelProgress");
            this.uxLabelProgress.Name = "uxLabelProgress";
            // 
            // uxLabelMessage
            // 
            resources.ApplyResources(this.uxLabelMessage, "uxLabelMessage");
            this.uxLabelMessage.Name = "uxLabelMessage";
            // 
            // uxTextBoxSerial
            // 
            this.uxTextBoxSerial.AcceptsReturn = true;
            resources.ApplyResources(this.uxTextBoxSerial, "uxTextBoxSerial");
            this.uxTextBoxSerial.Name = "uxTextBoxSerial";
            // 
            // uxCBSerialEnter
            // 
            resources.ApplyResources(this.uxCBSerialEnter, "uxCBSerialEnter");
            this.uxCBSerialEnter.Name = "uxCBSerialEnter";
            this.uxCBSerialEnter.Click += new System.EventHandler(this.UxCbSerialEnterClick);
            // 
            // ScanToLocationView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            resources.ApplyResources(this, "$this");
            this.ControlBox = false;
            this.Controls.Add(this.uxCBSerialEnter);
            this.Controls.Add(this.uxTextBoxSerial);
            this.Controls.Add(this.uxLabelMessage);
            this.Controls.Add(this.uxLabelProgress);
            this.Controls.Add(this.uxLabelOperatorCode);
            this.Controls.Add(this.uxGridProgress);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.PositionSelection);
            this.Controls.Add(this.ShelfSelection);
            this.Controls.Add(this.RackSelection);
            this.Menu = this.mainMenu1;
            this.Name = "ScanToLocationView";
            this.Deactivate += new System.EventHandler(this.ScanToLocationViewDeactivated);
            this.Load += new System.EventHandler(this.ScanToLocationViewLoad);
            this.Activated += new System.EventHandler(this.ScanToLocationViewActivated);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox PositionSelection;
        private System.Windows.Forms.ComboBox ShelfSelection;
        private System.Windows.Forms.ComboBox RackSelection;
        private System.Windows.Forms.DataGrid uxGridProgress;
        private System.Windows.Forms.Label uxLabelOperatorCode;
        private System.Windows.Forms.MenuItem menuItemRefresh;
        private System.Windows.Forms.Label uxLabelProgress;
        private System.Windows.Forms.Label uxLabelMessage;
        private System.Windows.Forms.TextBox uxTextBoxSerial;
        private System.Windows.Forms.Button uxCBSerialEnter;
    }
}