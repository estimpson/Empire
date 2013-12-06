namespace ShippingDockWM5
{
    partial class frmShippingDock
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenuShippingDock;

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
            this.components = new System.ComponentModel.Container();
            this.mainMenuShippingDock = new System.Windows.Forms.MainMenu();
            this.menuItemClose = new System.Windows.Forms.MenuItem();
            this.panel1 = new System.Windows.Forms.Panel();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPageShipperSelection = new System.Windows.Forms.TabPage();
            this.uxShipper = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.uxSelectSID = new System.Windows.Forms.Button();
            this.tabPageStaging = new System.Windows.Forms.TabPage();
            this.uxUnstage = new System.Windows.Forms.RadioButton();
            this.uxStage = new System.Windows.Forms.RadioButton();
            this.stagedInventoryDataTableBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.uxStagedInventory = new System.Windows.Forms.DataGrid();
            this.tsStagedInventory = new System.Windows.Forms.DataGridTableStyle();
            this.Serial = new System.Windows.Forms.DataGridTextBoxColumn();
            this.Part1 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.Qty = new System.Windows.Forms.DataGridTextBoxColumn();
            this.PalletSerial1 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.shipperLineItemsDataTableBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.uxLineItems = new System.Windows.Forms.DataGrid();
            this.tsShipperLineItems = new System.Windows.Forms.DataGridTableStyle();
            this.Part = new System.Windows.Forms.DataGridTextBoxColumn();
            this.QtyRequired = new System.Windows.Forms.DataGridTextBoxColumn();
            this.QtyPacked = new System.Windows.Forms.DataGridTextBoxColumn();
            this.Boxes = new System.Windows.Forms.DataGridTextBoxColumn();
            this.Pallets = new System.Windows.Forms.DataGridTextBoxColumn();
            this.uxConfirmPWD = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.uxPWD = new System.Windows.Forms.TextBox();
            this.uxOperator = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPageShipperSelection.SuspendLayout();
            this.tabPageStaging.SuspendLayout();
            this.SuspendLayout();
            // 
            // mainMenuShippingDock
            // 
            this.mainMenuShippingDock.MenuItems.Add(this.menuItemClose);
            // 
            // menuItemClose
            // 
            this.menuItemClose.Text = "Close";
            this.menuItemClose.Click += new System.EventHandler(this.menuItemClose_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.tabControl1);
            this.panel1.Location = new System.Drawing.Point(0, 31);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(240, 237);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPageShipperSelection);
            this.tabControl1.Controls.Add(this.tabPageStaging);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.tabControl1.Enabled = false;
            this.tabControl1.Location = new System.Drawing.Point(0, 6);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(240, 231);
            this.tabControl1.TabIndex = 0;
            // 
            // tabPageShipperSelection
            // 
            this.tabPageShipperSelection.Controls.Add(this.uxShipper);
            this.tabPageShipperSelection.Controls.Add(this.label2);
            this.tabPageShipperSelection.Controls.Add(this.uxSelectSID);
            this.tabPageShipperSelection.Location = new System.Drawing.Point(0, 0);
            this.tabPageShipperSelection.Name = "tabPageShipperSelection";
            this.tabPageShipperSelection.Size = new System.Drawing.Size(240, 208);
            this.tabPageShipperSelection.Text = "Select SID";
            // 
            // uxShipper
            // 
            this.uxShipper.Location = new System.Drawing.Point(44, 38);
            this.uxShipper.Name = "uxShipper";
            this.uxShipper.Size = new System.Drawing.Size(93, 21);
            this.uxShipper.TabIndex = 1;
            this.uxShipper.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxShipper_KeyDown);
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(4, 14);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(233, 20);
            this.label2.Text = "Scan or Enter Shipper #";
            // 
            // uxSelectSID
            // 
            this.uxSelectSID.Location = new System.Drawing.Point(161, 38);
            this.uxSelectSID.Name = "uxSelectSID";
            this.uxSelectSID.Size = new System.Drawing.Size(72, 21);
            this.uxSelectSID.TabIndex = 1;
            this.uxSelectSID.Text = "Select";
            this.uxSelectSID.Click += new System.EventHandler(this.uxSelectSID_Click);
            // 
            // tabPageStaging
            // 
            this.tabPageStaging.Controls.Add(this.uxUnstage);
            this.tabPageStaging.Controls.Add(this.uxStage);
            this.tabPageStaging.Controls.Add(this.uxStagedInventory);
            this.tabPageStaging.Controls.Add(this.uxLineItems);
            this.tabPageStaging.Location = new System.Drawing.Point(0, 0);
            this.tabPageStaging.Name = "tabPageStaging";
            this.tabPageStaging.Size = new System.Drawing.Size(240, 208);
            this.tabPageStaging.Text = "Staging";
            // 
            // uxUnstage
            // 
            this.uxUnstage.Location = new System.Drawing.Point(159, 185);
            this.uxUnstage.Name = "uxUnstage";
            this.uxUnstage.Size = new System.Drawing.Size(74, 20);
            this.uxUnstage.TabIndex = 2;
            this.uxUnstage.TabStop = false;
            this.uxUnstage.Text = "Unstage";
            // 
            // uxStage
            // 
            this.uxStage.Checked = true;
            this.uxStage.Location = new System.Drawing.Point(8, 186);
            this.uxStage.Name = "uxStage";
            this.uxStage.Size = new System.Drawing.Size(58, 20);
            this.uxStage.TabIndex = 2;
            this.uxStage.TabStop = false;
            this.uxStage.Text = "Stage";
            // 
            // stagedInventoryDataTableBindingSource
            // 
            this.stagedInventoryDataTableBindingSource.DataSource = typeof(ShippingDockData.dsShippingDock.StagedInventoryDataTable);
            // 
            // uxStagedInventory
            // 
            this.uxStagedInventory.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.uxStagedInventory.DataSource = this.stagedInventoryDataTableBindingSource;
            this.uxStagedInventory.Dock = System.Windows.Forms.DockStyle.Top;
            this.uxStagedInventory.Location = new System.Drawing.Point(0, 92);
            this.uxStagedInventory.Name = "uxStagedInventory";
            this.uxStagedInventory.RowHeadersVisible = false;
            this.uxStagedInventory.Size = new System.Drawing.Size(240, 87);
            this.uxStagedInventory.TabIndex = 1;
            this.uxStagedInventory.TableStyles.Add(this.tsStagedInventory);
            // 
            // tsStagedInventory
            // 
            this.tsStagedInventory.GridColumnStyles.Add(this.Serial);
            this.tsStagedInventory.GridColumnStyles.Add(this.Part1);
            this.tsStagedInventory.GridColumnStyles.Add(this.Qty);
            this.tsStagedInventory.GridColumnStyles.Add(this.PalletSerial1);
            this.tsStagedInventory.MappingName = "StagedInventory";
            // 
            // Serial
            // 
            this.Serial.Format = "";
            this.Serial.FormatInfo = null;
            this.Serial.HeaderText = "Serial";
            this.Serial.MappingName = "Serial";
            // 
            // Part1
            // 
            this.Part1.Format = "";
            this.Part1.FormatInfo = null;
            this.Part1.HeaderText = "Part";
            this.Part1.MappingName = "Part";
            this.Part1.Width = 80;
            // 
            // Qty
            // 
            this.Qty.Format = "0";
            this.Qty.FormatInfo = null;
            this.Qty.HeaderText = "Qty";
            this.Qty.MappingName = "Qty";
            this.Qty.Width = 30;
            // 
            // PalletSerial1
            // 
            this.PalletSerial1.Format = "";
            this.PalletSerial1.FormatInfo = null;
            this.PalletSerial1.HeaderText = "Pallet Serial";
            this.PalletSerial1.MappingName = "PalletSerial";
            this.PalletSerial1.NullText = "N/A";
            // 
            // shipperLineItemsDataTableBindingSource
            // 
            this.shipperLineItemsDataTableBindingSource.DataSource = typeof(ShippingDockData.dsShippingDock.ShipperLineItemsDataTable);
            // 
            // uxLineItems
            // 
            this.uxLineItems.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.uxLineItems.DataSource = this.shipperLineItemsDataTableBindingSource;
            this.uxLineItems.Dock = System.Windows.Forms.DockStyle.Top;
            this.uxLineItems.Location = new System.Drawing.Point(0, 0);
            this.uxLineItems.Name = "uxLineItems";
            this.uxLineItems.RowHeadersVisible = false;
            this.uxLineItems.Size = new System.Drawing.Size(240, 92);
            this.uxLineItems.TabIndex = 0;
            this.uxLineItems.TableStyles.Add(this.tsShipperLineItems);
            // 
            // tsShipperLineItems
            // 
            this.tsShipperLineItems.GridColumnStyles.Add(this.Part);
            this.tsShipperLineItems.GridColumnStyles.Add(this.QtyRequired);
            this.tsShipperLineItems.GridColumnStyles.Add(this.QtyPacked);
            this.tsShipperLineItems.GridColumnStyles.Add(this.Boxes);
            this.tsShipperLineItems.GridColumnStyles.Add(this.Pallets);
            this.tsShipperLineItems.MappingName = "ShipperLineItems";
            // 
            // Part
            // 
            this.Part.Format = "";
            this.Part.FormatInfo = null;
            this.Part.HeaderText = "Part";
            this.Part.MappingName = "Part";
            this.Part.Width = 80;
            // 
            // QtyRequired
            // 
            this.QtyRequired.Format = "0";
            this.QtyRequired.FormatInfo = null;
            this.QtyRequired.HeaderText = "Reqd";
            this.QtyRequired.MappingName = "QtyRequired";
            this.QtyRequired.Width = 40;
            // 
            // QtyPacked
            // 
            this.QtyPacked.Format = "0";
            this.QtyPacked.FormatInfo = null;
            this.QtyPacked.HeaderText = "Pckd";
            this.QtyPacked.MappingName = "QtyPacked";
            this.QtyPacked.Width = 40;
            // 
            // Boxes
            // 
            this.Boxes.Format = "0";
            this.Boxes.FormatInfo = null;
            this.Boxes.HeaderText = "Boxes";
            this.Boxes.MappingName = "Boxes";
            this.Boxes.Width = 40;
            // 
            // Pallets
            // 
            this.Pallets.Format = "0";
            this.Pallets.FormatInfo = null;
            this.Pallets.HeaderText = "Pallets";
            this.Pallets.MappingName = "Pallets";
            this.Pallets.Width = 40;
            // 
            // uxConfirmPWD
            // 
            this.uxConfirmPWD.Location = new System.Drawing.Point(161, 4);
            this.uxConfirmPWD.Name = "uxConfirmPWD";
            this.uxConfirmPWD.Size = new System.Drawing.Size(72, 21);
            this.uxConfirmPWD.TabIndex = 1;
            this.uxConfirmPWD.Text = "Confirm";
            this.uxConfirmPWD.Click += new System.EventHandler(this.uxConfirmPWD_Click);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(4, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(34, 20);
            this.label1.Text = "Pwd:";
            // 
            // uxPWD
            // 
            this.uxPWD.Location = new System.Drawing.Point(44, 4);
            this.uxPWD.MaxLength = 5;
            this.uxPWD.Name = "uxPWD";
            this.uxPWD.PasswordChar = '*';
            this.uxPWD.Size = new System.Drawing.Size(93, 21);
            this.uxPWD.TabIndex = 1;
            this.uxPWD.KeyDown += new System.Windows.Forms.KeyEventHandler(this.uxPWD_KeyDown);
            // 
            // uxOperator
            // 
            this.uxOperator.Location = new System.Drawing.Point(44, 5);
            this.uxOperator.Name = "uxOperator";
            this.uxOperator.Size = new System.Drawing.Size(111, 20);
            this.uxOperator.Text = "label2";
            this.uxOperator.Visible = false;
            // 
            // frmShippingDock
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.AutoValidate = System.Windows.Forms.AutoValidate.Disable;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.uxPWD);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.uxConfirmPWD);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.uxOperator);
            this.Menu = this.mainMenuShippingDock;
            this.Name = "frmShippingDock";
            this.Text = "Shipping Dock";
            this.Load += new System.EventHandler(this.frmShippingDock_Load);
            this.Closing += new System.ComponentModel.CancelEventHandler(this.frmShippingDock_Closing);
            this.panel1.ResumeLayout(false);
            this.tabControl1.ResumeLayout(false);
            this.tabPageShipperSelection.ResumeLayout(false);
            this.tabPageStaging.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItemClose;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button uxConfirmPWD;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TabPage tabPageShipperSelection;
        private System.Windows.Forms.TabPage tabPageStaging;
        private System.Windows.Forms.TextBox uxPWD;
        private System.Windows.Forms.Label uxOperator;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox uxShipper;
        private System.Windows.Forms.Button uxSelectSID;
        private System.Windows.Forms.DataGrid uxStagedInventory;
        private System.Windows.Forms.DataGrid uxLineItems;
        private System.Windows.Forms.RadioButton uxUnstage;
        private System.Windows.Forms.RadioButton uxStage;
        private System.Windows.Forms.BindingSource stagedInventoryDataTableBindingSource;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.BindingSource shipperLineItemsDataTableBindingSource;
        private System.Windows.Forms.DataGridTableStyle tsShipperLineItems;
        private System.Windows.Forms.DataGridTextBoxColumn Part;
        private System.Windows.Forms.DataGridTextBoxColumn QtyRequired;
        private System.Windows.Forms.DataGridTextBoxColumn QtyPacked;
        private System.Windows.Forms.DataGridTextBoxColumn Boxes;
        private System.Windows.Forms.DataGridTextBoxColumn Pallets;
        private System.Windows.Forms.DataGridTableStyle tsStagedInventory;
        private System.Windows.Forms.DataGridTextBoxColumn Serial;
        private System.Windows.Forms.DataGridTextBoxColumn Part1;
        private System.Windows.Forms.DataGridTextBoxColumn Qty;
        private System.Windows.Forms.DataGridTextBoxColumn PalletSerial1;
    }
}

