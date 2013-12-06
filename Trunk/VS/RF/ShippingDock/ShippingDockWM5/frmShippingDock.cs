using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Reflection;
using ShippingDockData;
using ShippingDockData.dsShippingDockTableAdapters;
using CommonData;
using CommonData.dsCommonTableAdapters;
using System.Data.SqlClient;
using SymbolRFGun;

namespace ShippingDockWM5
{
    public partial class frmShippingDock : Form
    {
        #region Windows Form
#if PocketPC
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
#endif
        private Int32? SID = null;
        private Int32? PalletSerial = null;
        private String Operator = null;

        public frmShippingDock()
        {
            InitializeComponent();
        }

        private void frmShippingDock_Load(object sender, EventArgs e)
        {
        }

        private void menuItemClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void frmShippingDock_Closing(object sender, CancelEventArgs e)
        {
#if PocketPC
            if (MyRFGun != null) MyRFGun.Close();
#endif
        }
        #endregion

        #region Operator
        private void uxPWD_KeyDown(object sender, KeyEventArgs e)
        {
#if PocketPC
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxConfirmPWD.Focus();
                e.Handled = false;
            }
#endif
        }

        private void uxConfirmPWD_Click(object sender, EventArgs e)
        {
            try
            {
                switch (uxConfirmPWD.Text)
                {
                    case "Confirm":
                        Login(uxPWD.Text);
                        break;
                    case "Log Off":
                        LogOff();
                        break;
                    default:
                        throw new Exception("Invalid button text for login control.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void Login(string sPassword)
        {
            EEIEmployeeTableAdapter taEmployee = new EEIEmployeeTableAdapter();
            dsCommon.EEIEmployeeDataTable dtEmployees = taEmployee.GetOperatorCodeByPassword(uxPWD.Text);
            string sOperatorCode;
            switch (dtEmployees.Rows.Count)
            {
                case 1:
                    sOperatorCode = dtEmployees[0].OperatorCode;
                    OperatorConfirmed(sOperatorCode);
#if PocketPC
                    MyRFGun = new SymbolRFGun.SymbolRFGun();
                    MyRFGun.RFScan += new RFScanEventHandler(MyRFGun_RFScan);
#endif
                    break;
                case 0:
                    uxPWD.Text = "";
                    uxPWD.Focus();
                    throw new Exception("Invalid password.");
                default:
                    uxPWD.Focus();
                    throw new Exception("Unknown error validating password.");
            }
        }

        private void OperatorConfirmed(string sOperator)
        {
            Operator = sOperator;
            uxConfirmPWD.Text = "Log Off";
            uxPWD.Visible = false;
            uxPWD.Text = "";
            uxPWD.Enabled = false;
            uxOperator.Text = sOperator;
            uxOperator.Visible = true;
            tabControl1.Enabled = true;
        }

        private void LogOff()
        {
            Operator = null;
            uxConfirmPWD.Text = "Confirm";
            uxOperator.Visible = false;
            uxPWD.Visible = true;
            uxPWD.Enabled = true;
            uxOperator.Text = "";
            tabControl1.Enabled = false;

#if PocketPC
            if (MyRFGun != null) MyRFGun.Close();
#endif
        }
        #endregion

        #region Scan Data
        void MyRFGun_RFScan(object sender, RFScanEventArgs e)
        {
            try
            {
                ScanData scanData = e.Text;
                switch (scanData.ScanDataType)
                {
                    case eScanDataType.Serial:
                        if (SID == null)
                        {
                            throw new Exception("Select a shipper before scanning inventory to stage.");
                        }
                        else
                        {
                            if (uxStage.Checked)
                            {
                                StageObject(Convert.ToInt32(scanData.DataValue));
                            }
                            else
                            {
                                UnstageObject(Convert.ToInt32(scanData.DataValue));
                            }
                        }
                        break;
                    case eScanDataType.Shipper:
                        SelectShipper(Convert.ToInt32(scanData.DataValue));
                        break;
                    case eScanDataType.Undef:
                        if (uxStage.Checked)
                        {
                            StageObject(Convert.ToInt32(scanData.DataValue));
                        }
                        else
                        {
                            UnstageObject(Convert.ToInt32(scanData.DataValue));
                        }
                        break;
                }
            }
            catch (SqlException ex)
            {
#if PocketPC
                MyRFGun.BadReadNotification();
#endif
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
#if PocketPC
                MyRFGun.BadReadNotification();
#endif
                MessageBox.Show(ex.Message);
            }
        }
        #endregion

        #region Select Shipper
        private void uxShipper_KeyDown(object sender, KeyEventArgs e)
        {
#if PocketPC
            //  MC9090 enter key is 134.
            if ((Int32)e.KeyCode == 134)
            {
                uxSelectSID.Focus();
                e.Handled = false;
            }
#endif
        }

        private void uxSelectSID_Click(object sender, EventArgs e)
        {
            try
            {
                Int32 iSID = Convert.ToInt32(uxShipper.Text);
                SelectShipper(iSID);
            }
            catch (SqlException ex)
            {
#if PocketPC
                MyRFGun.BadReadNotification();
#endif
                MessageBox.Show(ex.Message);
            }
            catch (Exception ex)
            {
#if PocketPC
                MyRFGun.BadReadNotification();
#endif
                MessageBox.Show(ex.Message);
            }
        }

        private void SelectShipper(Int32 iSID)
        {
            ShipperHeaderTableAdapter taShipperHeader = new ShipperHeaderTableAdapter();
            dsShippingDock.ShipperHeaderDataTable dtShipperHeaders = taShipperHeader.GetOpenShipper(iSID);
            switch (dtShipperHeaders.Rows.Count)
            {
                case 1:
                    SID = iSID;
                    RefreshShipperDetails();
                    tabControl1.SelectedIndex = 1;
                    break;
                case 0:
                    uxShipper.Focus();
                    throw new Exception("Invalid shipper.");
                default:
                    uxShipper.Focus();
                    throw new Exception("Unknown error validating shipper.");
            }
#if PocketPC
            MyRFGun.GoodReadNotification();
#endif
        }
        #endregion

        #region Staging (Unstaging)
        private void StageObject(Int32 iSerial)
        {
            Nullable<Int32> iResult = null;
            StagedInventoryTableAdapter taStagedInventory = new StagedInventoryTableAdapter();
            taStagedInventory.AddInvToShipper(Operator, SID, (int?)iSerial, PalletSerial, ref iResult);
            RefreshShipperDetails(iSerial);
#if PocketPC
            MyRFGun.GoodReadNotification();
#endif
        }

        private void UnstageObject(Int32 iSerial)
        {
            Nullable<Int32> iResult = null;
            StagedInventoryTableAdapter taStagedInventory = new StagedInventoryTableAdapter();
            taStagedInventory.RemoveInvFromShipper(Operator, (int?)iSerial, ref iResult);
            RefreshShipperDetails(iSerial);
#if PocketPC
            MyRFGun.GoodReadNotification();
#endif
        }

        private void RefreshShipperDetails()
        {
            ShipperLineItemsTableAdapter taShipperLineItems = new ShipperLineItemsTableAdapter();
            uxLineItems.DataSource = taShipperLineItems.GetShipperLineItems((int)SID);
            StagedInventoryTableAdapter taStagedInventory = new StagedInventoryTableAdapter();
            uxStagedInventory.DataSource = taStagedInventory.GetStagedInventory(SID);
        }

        private void RefreshShipperDetails(Int32 iSerial)
        {
            RefreshShipperDetails();
            StagedInventoryTableAdapter taStagedInventory = new StagedInventoryTableAdapter();
            String ScannedPart = (String)taStagedInventory.GetPart_bySerial(iSerial);
            if (ScannedPart != null)
            {
                dsShippingDock.ShipperLineItemsDataTable dtLineItems = (dsShippingDock.ShipperLineItemsDataTable)uxLineItems.DataSource;
                for (int i = 0; i < dtLineItems.Rows.Count; i++)
                {
                    dsShippingDock.ShipperLineItemsRow drRow = (dsShippingDock.ShipperLineItemsRow)dtLineItems.Rows[i];
                    if (drRow.Part == ScannedPart)
                    {
                        uxLineItems.Select(i);
                        VScrollBar vertsbar = (VScrollBar)uxLineItems.GetType().GetField("m_sbVert", BindingFlags.NonPublic | BindingFlags.Instance).GetValue(uxLineItems);
                        vertsbar.Value = i;
                        break;
                    }
                }
            }
        }
#endregion
    }
}