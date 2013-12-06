using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using SymbolRFGun;
using PhysicalInventoryData;
using PhysicalInventoryData.DataSetPhysicalInventoryTableAdapters;
using SAF.Configuration;
using SAF.Cache;

namespace PhysicalInventory
{
    public partial class frmScanToLocation : Form
    {
        private string OperatorCode = null;
        private string PutAwayAisle = null;
        private Int32 PutAwayShelf = -1;
        private Int32 PutAwaySubshelf = -1;
        private Int32 BeginPhysicalShelf = -1;
        private Int32 BeginPhysicalSubshelf = -1;
        private SymbolRFGun.SymbolRFGun MyRFGun = null;
        private Cache cache = SAF.Cache.Cache.GetSAFCacheService();
        private DataSetPhysicalInventory dsPhysicalInventory = null;
        private EmployeeTableAdapter taEmployee = null;
        private PhysicalProgressTableAdapter taPhysicalProgress = null;
        private PhysicalProgressSummaryTableAdapter taPhysicalProgressSummary = null;
        private WarehouseInventoryTableAdapter taWarehouseInventory = null;
        private Symbol.Audio.Controller MyAudioController = null;

        public frmScanToLocation()
        {
            InitializeComponent();
        }

        private void menuItemClose_Click(object sender, EventArgs e)
        {
            MyAudioController.Dispose();
            MyRFGun.Close();
            this.Close();
        }

        private void frmScanToLocation_Load(object sender, EventArgs e)
        {
            try
            {
                MyRFGun = new SymbolRFGun.SymbolRFGun();
                MyRFGun.RFScan += new RFScanEventHandler(MyRFGunRFScan);
            }
            catch (SymbolRFGunException ex)
            {
                MessageBox.Show(ex.Message);
                this.Close();
            }

            try
            {
                //Select Device from device list
                Symbol.Audio.Device MyDevice = (Symbol.Audio.Device)Symbol.StandardForms.SelectDevice.Select(
                    Symbol.Audio.Controller.Title,
                    Symbol.Audio.Device.AvailableDevices);

                if (MyDevice == null)
                {
                    MessageBox.Show("No Device Selected", "SelectDevice");

                    //close the form
                    this.Close();

                    return;
                }

                //check the device type
                switch (MyDevice.AudioType)
                {
                    //if standard device
                    case Symbol.Audio.AudioType.StandardAudio:
                        MyAudioController = new Symbol.Audio.StandardAudio(MyDevice);
                        break;

                    //if simulated device
                    case Symbol.Audio.AudioType.SimulatedAudio:
                        MyAudioController = new Symbol.Audio.SimulatedAudio(MyDevice);
                        break;

                    default:
                        throw new Symbol.Exceptions.InvalidDataTypeException("Unknown Device Type");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            
            try
            {
                Exception ex = null;
                dsPhysicalInventory = (DataSetPhysicalInventory)cache.RetrieveObject(CacheAddress.PhysicalInventoryData);
                taEmployee = (EmployeeTableAdapter)cache.RetrieveObject(CacheAddress.EmployeeTableAdapter);
                taPhysicalProgress = (PhysicalProgressTableAdapter)cache.RetrieveObject(CacheAddress.PhysicalProgressTableAdapter);
                taPhysicalProgressSummary = (PhysicalProgressSummaryTableAdapter)cache.RetrieveObject(CacheAddress.PhysicalProgressSummaryTableAdapter);
                taWarehouseInventory = (WarehouseInventoryTableAdapter)cache.RetrieveObject(CacheAddress.WarehouseInventoryTableAdapter);

                switch (dsPhysicalInventory.Employee.Rows.Count)
                {
                    case 1:
                        OperatorCode = dsPhysicalInventory.Employee[0].OperatorCode;
                        uxLabelOperatorCode.Text = OperatorCode;
                        break;
                    case 0:
                        ex = new Exception("Invalid password.");
                        throw ex;
                    default:
                        ex = new Exception("Unknown error validating password.");
                        throw ex;
                }
                PutAwayAisle = (string)cache.RetrieveObject(CacheAddress.BeginPhysicalAisle);
                BeginPhysicalShelf = (Int32)cache.RetrieveObject(CacheAddress.BeginPhysicalShelf);
                BeginPhysicalSubshelf = (Int32)cache.RetrieveObject(CacheAddress.BeginPhysicalSubshelf);
                uxCBAisle.Items.Add(PutAwayAisle);
                uxCBAisle.SelectedIndex = 0;
                if (BeginPhysicalShelf == 0)
                {
                    uxCBShelf.Items.Add("1");
                    uxCBShelf.Items.Add("2");
                    uxCBShelf.Items.Add("3");
                    uxCBShelf.Items.Add("4");
                    PutAwayShelf = 1;
                }
                else
                {
                    uxCBShelf.Items.Add(BeginPhysicalShelf.ToString());
                    PutAwayShelf = BeginPhysicalShelf;
                }
                uxCBShelf.SelectedIndex = 0;

                if (BeginPhysicalSubshelf == 0)
                {
                    uxCBSubshelf.Items.Add("1");
                    uxCBSubshelf.Items.Add("2");
                    uxCBSubshelf.Items.Add("3");
                    uxCBSubshelf.Items.Add("4");
                    uxCBSubshelf.Items.Add("5");
                    uxCBSubshelf.Items.Add("6");
                    uxCBSubshelf.Items.Add("7");
                    uxCBSubshelf.Items.Add("8");
                    uxCBSubshelf.Items.Add("9");
                    uxCBSubshelf.Items.Add("10");
                    uxCBSubshelf.Items.Add("11");
                    uxCBSubshelf.Items.Add("12");
                    PutAwaySubshelf = 1;
                }
                else
                {
                    uxCBSubshelf.Items.Add(BeginPhysicalSubshelf.ToString());
                    PutAwaySubshelf = BeginPhysicalSubshelf;
                }
                uxCBSubshelf.SelectedIndex = 0;
                RefreshProgress();
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        void ResetGun()
        {
            try
            {
                MyRFGun.Close();
                MyRFGun = new SymbolRFGun.SymbolRFGun();
                MyRFGun.RFScan += new RFScanEventHandler(MyRFGunRFScan);
            }
            catch (SymbolRFGunException ex)
            {
                MessageBox.Show(ex.Message);
                this.Close();
            }
        }

        void RefreshProgress()
        {
            try
            {
                Exception ex;

                PutAwayAisle = uxCBAisle.Text;
                PutAwayShelf = Int32.Parse(uxCBShelf.Text);
                if (!(PutAwayShelf > 0))
                {
                    ex = new Exception("Shelf not selected.");
                    uxCBShelf.Focus();
                    throw ex;
                }
                PutAwaySubshelf = Int32.Parse(uxCBSubshelf.Text);
                if (!(PutAwaySubshelf > 0))
                {
                    ex = new Exception("Subshelf not selected.");
                    uxCBSubshelf.Focus();
                    throw ex;
                }

                taPhysicalProgress.Fill(dsPhysicalInventory.PhysicalProgress, PutAwayAisle, PutAwayShelf, PutAwaySubshelf);
                uxGridProgress.DataSource = taPhysicalProgress.GetPhysicalProgressByAddress(PutAwayAisle, PutAwayShelf, PutAwaySubshelf);

                taPhysicalProgressSummary.Fill(dsPhysicalInventory.PhysicalProgressSummary, PutAwayAisle, PutAwayShelf, PutAwaySubshelf);
                switch (dsPhysicalInventory.PhysicalProgressSummary.Rows.Count)
                {
                    case 1:
                        uxLabelProgress.Text = dsPhysicalInventory.PhysicalProgressSummary[0].FoundCount.ToString() + " Found, " +
                            dsPhysicalInventory.PhysicalProgressSummary[0].MissingCount.ToString() + " Missing, " +
                            dsPhysicalInventory.PhysicalProgressSummary[0].TotalCount.ToString() + " Total";
                        break;
                    default:
                        ex = new Exception("Unable to retrieve summary.");
                        throw ex;
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
        }

        private int TryProcessSerial(Int32 BoxSerial)
        {
            try
            {
                Exception ex;

                //  Verify that shelf and subshelf are selected.
                PutAwayAisle = uxCBAisle.Text;
                PutAwayShelf = Int32.Parse(uxCBShelf.Text);
                if (!(PutAwayShelf > 0))
                {
                    ex = new Exception("Shelf not selected.");
                    uxCBShelf.Focus();
                    throw ex;
                }
                PutAwaySubshelf = Int32.Parse(uxCBSubshelf.Text);
                if (!(PutAwaySubshelf > 0))
                {
                    ex = new Exception("Subshelf not selected.");
                    uxCBSubshelf.Focus();
                    throw ex;
                }

                //  Scan object to location.
                Int32 Result;
                taPhysicalProgress.PutAwayObject_BySerial(OperatorCode, BoxSerial, PutAwayAisle, PutAwayShelf, PutAwaySubshelf, out Result);

                //  Refresh screen and find row.
                taWarehouseInventory.FillBySerial(dsPhysicalInventory.WarehouseInventory, BoxSerial);
                switch (dsPhysicalInventory.WarehouseInventory.Rows.Count)
                {
                    case 1:
                        string Part = dsPhysicalInventory.WarehouseInventory[0].Part;
                        uxLabelMessage.Text = "Serial " + BoxSerial.ToString() + " Part " + Part;
                        break;
                    default:
                        ex = new Exception("Part not found!");
                        throw ex;
                }
                RefreshProgress();
                return 1;
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
                return -1;
            }
            catch (Exception ex)
            {
                uxLabelMessage.Text = ex.Message;
                int Duration = 1500;//millisec
                int Frequency = 2670;//hz

                try
                {
                    this.MyAudioController.PlayAudio(Duration, Frequency);//play Default beep
                }
                catch
                {
                    MessageBox.Show("PlayAudio failed. Speaker may not be present", "PlayAudio");
                }
                return -1;
            }
        }

        void MyRFGunRFScan(object sender, RFScanEventArgs e)
        {
            string scanData = e.Text;
            try
            {
                //  Look for a serial with no identifier.
                int serial;
                try
                {
                    serial = Int32.Parse(scanData);
                    if (TryProcessSerial(serial) == -1)
                    {
                        throw new Exception(string.Format("No identifier, but scan data {0} not recognized.", scanData));
                    }
                    RefreshProgress();
                    return;
                }
                catch (FormatException)
                {
                    //  Ignore exception and continue trying to find a serial.
                }
                catch (Exception ex)
                {
                    throw new Exception(string.Format("{0} No identifier, but scan data {1} not recognized.", ex.Message, scanData));
                }

                //  Look first for serial scan.
                if (scanData.Substring(0, 1) == "S" || scanData.Substring(0,1) == " ")
                {
                    //  Scan object to location.
                    serial = Int32.Parse(scanData.Substring(1));
                    if (TryProcessSerial(serial) == -1)
                    {
                        throw new Exception(string.Format("\"S\" identifier found, but scan data {0} not recognized", scanData));
                    }
                    RefreshProgress(); 
                    return;
                }
                if (scanData.Substring(1,1) == "S" || scanData.Substring(0,1) == "1T")
                {
                    //  Scan object to location.
                    serial = Int32.Parse(scanData.Substring(2));
                    if (TryProcessSerial(serial) == -1)
                    {
                        throw new Exception(string.Format("\"#S\" or 1T identifier found, but scan data {0} not recognized", scanData));
                    }
                    RefreshProgress();
                    return;
                }
                if (scanData.Substring(1, 1) == "-" && scanData.Substring(3, 1) == "-")
                {
                    //  Look for location.
                    if (scanData.Substring(0, 1) != PutAwayAisle)
                    {
                        throw new Exception("Expecting label or serial scan.");
                    }
                    if (BeginPhysicalShelf > 0 && Int32.Parse(scanData.Substring(2,1)) != BeginPhysicalShelf)
                    {
                        throw new Exception("Shelf not part of current physical.");
                    }
                    uxCBShelf.Text = scanData.Substring(2,1);
                    PutAwayShelf = Int32.Parse(uxCBShelf.Text);
                    if (BeginPhysicalSubshelf > 0 && Int32.Parse(scanData.Substring(4,2)) != BeginPhysicalSubshelf)
                    {
                        throw new Exception("Position not part of current physical.");
                    }
                    uxCBSubshelf.Text = scanData.Substring(4,2);
                    PutAwaySubshelf = Int32.Parse(uxCBSubshelf.Text);
                    RefreshProgress ();
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
            catch (ArgumentNullException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.";
            }
            catch (OverflowException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + scanData;
            }
            catch (FormatException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + scanData;
            }
            catch (Exception ex)
            {
                uxLabelMessage.Text = ex.Message + scanData;
            }
        }

        private void menuItemRefresh_Click(object sender, EventArgs e)
        {
            RefreshProgress();
        }

        private void frmScanToLocation_Activated(object sender, EventArgs e)
        {
            ResetGun();
        }

        private void frmScanToLocation_Deactivate(object sender, EventArgs e)
        {
            //this.StopRead();
        }

        private void uxCBSerialEnter_Click(object sender, EventArgs e)
        {
            string SerialData = uxTextBoxSerial.Text;
            try
            {
                //  Scan object to location.
                TryProcessSerial(Int32.Parse(SerialData));
            }
            catch (ArgumentNullException ex)
            {
                uxLabelMessage.Text = ex.Message + "Entered data not recognized.";
            }
            catch (OverflowException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + SerialData;
            }
            catch (FormatException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + SerialData;
            }
            catch (Exception ex)
            {
                uxLabelMessage.Text = ex.Message + SerialData;
            }
        }
    }
}