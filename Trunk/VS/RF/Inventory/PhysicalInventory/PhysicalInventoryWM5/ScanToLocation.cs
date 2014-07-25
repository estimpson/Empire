#region Using

using System;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Windows.Forms;
using PhysicalInventoryData.dsPhysicalInventoryTableAdapters;
using Symbol.Audio;
using Symbol.Exceptions;
using Symbol.StandardForms;
using SymbolRFGun;

#endregion

namespace PhysicalInventory
{
    public partial class ScanToLocationView : Form
    {
        public string Plant, OperatorCode;
        public string BeginPhysicalRack, BeginPhysicalShelf, BeginPhysicalPosition;
        private string _putAwayRack;
        private string _putAwayShelf;
        private string _putAwayPosition;
        private SymbolRFGun.SymbolRFGun _myRFGun;
        private Controller _myAudioController;

        public ScanToLocationView()
        {
            InitializeComponent();
        }

        private void MenuItemCloseClick(object sender, EventArgs e)
        {
            _myAudioController.Dispose();
            _myRFGun.Close();
            Close();
        }

        private void ScanToLocationViewLoad(object sender, EventArgs e)
        {
            uxLabelOperatorCode.Text = OperatorCode;

            try
            {
                _myRFGun = new SymbolRFGun.SymbolRFGun();
                _myRFGun.RFScan += MyRFGunRFScan;
            }
            catch (SymbolRFGunException ex)
            {
                MessageBox.Show(ex.Message);
                Close();
            }

            try
            {
                //Select Device from device list
                Debug.Assert(Device.AvailableDevices != null, "Device.AvailableDevices != null");
                var myDevice = (Device) SelectDevice.Select(
                    Controller.Title,
                    Device.AvailableDevices);

                if (myDevice == null)
                {
                    MessageBox.Show("No Device Selected", "SelectDevice");

                    //close the form
                    Close();

                    return;
                }

                //check the device type
                switch (myDevice.AudioType)
                {
                        //if standard device
                    case AudioType.StandardAudio:
                        _myAudioController = new StandardAudio(myDevice);
                        break;

                        //if simulated device
                    case AudioType.SimulatedAudio:
                        _myAudioController = new SimulatedAudio(myDevice);
                        break;

                    default:
                        throw new InvalidDataTypeException("Unknown Device Type");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            try
            {
                using (var racksDT = new RackListTableAdapter().GetRackList(Plant))
                {
                    RackSelection.DataSource = racksDT;
                    RackSelection.DisplayMember = "Rack";
                    RackSelection.Text = BeginPhysicalRack;
                }
                using (var shelvesDT = new ShelfListTableAdapter().GetShelfList(Plant))
                {
                    ShelfSelection.DataSource = shelvesDT;
                    ShelfSelection.DisplayMember = "Shelf";
                    ShelfSelection.Text = BeginPhysicalShelf;
                }
                using (var positionsDT = new PositionListTableAdapter().GetPositionList(Plant))
                {
                    PositionSelection.DataSource = positionsDT;
                    PositionSelection.DisplayMember = "Position";
                    PositionSelection.Text = BeginPhysicalPosition;
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            RefreshProgress();
        }

        private void ResetGun()
        {
            try
            {
                _myRFGun.Close();
                _myRFGun = new SymbolRFGun.SymbolRFGun();
                _myRFGun.RFScan += MyRFGunRFScan;
            }
            catch (SymbolRFGunException ex)
            {
                MessageBox.Show(ex.Message);
                Close();
            }
        }

        private void RefreshProgress()
        {
            try
            {
                _putAwayRack = RackSelection.Text;
                _putAwayShelf = ShelfSelection.Text;
                if (string.IsNullOrEmpty(_putAwayShelf))
                {
                    ShelfSelection.Focus();
                    return;
                }
                _putAwayPosition = PositionSelection.Text;
                if (string.IsNullOrEmpty(_putAwayPosition))
                {
                    PositionSelection.Focus();
                    return;
                }

                using (var ppTA = new PhysicalProgressTableAdapter())
                {
                    uxGridProgress.DataSource = ppTA.GetCycleCountProgressByAddress(Plant, _putAwayRack, _putAwayShelf,
                        _putAwayPosition);
                }

                using (var ppsTA = new PhysicalProgressSummaryTableAdapter())
                {
                    var ppsDT = ppsTA.GetCycleCountProgressSummary(Plant, _putAwayRack, _putAwayShelf, _putAwayPosition);

                    switch (ppsDT.Rows.Count)
                    {
                        case 1:
                            uxLabelProgress.Text = ppsDT[0].FoundCount +
                                                   " Found, " +
                                                   ppsDT[0].MissingCount +
                                                   " Missing, " +
                                                   ppsDT[0].TotalCount +
                                                   " Total";
                            break;
                        default:
                            throw new Exception("Unable to retrieve summary.");
                    }
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private int TryProcessSerial(Int32 boxSerial)
        {
            try
            {
                //  Verify that shelf and subshelf are selected.
                _putAwayRack = RackSelection.Text;
                _putAwayShelf = ShelfSelection.Text;
                if (string.IsNullOrEmpty(_putAwayShelf))
                {
                    ShelfSelection.Focus();
                    throw new Exception("Shelf not selected.");
                }
                _putAwayPosition = PositionSelection.Text;
                if (string.IsNullOrEmpty(_putAwayPosition))
                {
                    PositionSelection.Focus();
                    throw new Exception("Subshelf not selected.");
                }

                //  Scan object to location.
                using (var ppTA = new PhysicalProgressTableAdapter())
                {
                    DateTime? tranDT = null;
                    Int32? result = null;
                    ppTA.ScanSerial(OperatorCode, boxSerial, Plant, _putAwayRack, _putAwayShelf, _putAwayPosition,
                        ref tranDT,
                        ref result);
                }

                //  Refresh screen and find row.
                using (var wiTA = new WarehouseInventoryTableAdapter())
                {
                    var wiDT = wiTA.GetInventoryBySerial(boxSerial);
                    switch (wiDT.Rows.Count)
                    {
                        case 1:
                            uxLabelMessage.Text = "Serial " + boxSerial + " Part " + wiDT[0].Part;
                            break;
                        default:
                            throw new Exception("Part not found!");
                    }
                }
                RefreshProgress();
                return 1;
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
                return -1;
            }
            catch (Exception ex)
            {
                uxLabelMessage.Text = ex.Message;
                const int DURATION = 1500; //millisec
                const int FREQUENCY = 2670; //hz

                try
                {
                    _myAudioController.PlayAudio(DURATION, FREQUENCY); //play Default beep
                }
                catch
                {
                    MessageBox.Show("PlayAudio failed. Speaker may not be present", "PlayAudio");
                }
                return -1;
            }
        }

        private void MyRFGunRFScan(object sender, RFScanEventArgs e)
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
                    throw new Exception(string.Format("{0} No identifier, but scan data {1} not recognized.", ex.Message,
                        scanData));
                }

                //  Look first for serial scan.
                if (scanData.Substring(0, 1) == "S" || scanData.Substring(0, 1) == " ")
                {
                    //  Scan object to location.
                    serial = Int32.Parse(scanData.Substring(1));
                    if (TryProcessSerial(serial) == -1)
                    {
                        throw new Exception(string.Format("\"S\" identifier found, but scan data {0} not recognized",
                            scanData));
                    }
                    RefreshProgress();
                    return;
                }
                if (scanData.Substring(1, 1) == "S" || scanData.Substring(0, 1) == "1T")
                {
                    //  Scan object to location.
                    serial = Int32.Parse(scanData.Substring(2));
                    if (TryProcessSerial(serial) == -1)
                    {
                        throw new Exception(
                            string.Format("\"#S\" or 1T identifier found, but scan data {0} not recognized", scanData));
                    }
                    RefreshProgress();
                    return;
                }

                //  Handle a location label scan.
                using (var wlTA = new WarehouseLocationsTableAdapter())
                {
                    var wlDT = wlTA.GetDataByLocation(scanData);
                    switch (wlDT.Rows.Count)
                    {
                        case 1:
                            RackSelection.Text = wlDT[0].Rack;
                            ShelfSelection.Text = wlDT[0].Shelf;
                            PositionSelection.Text = wlDT[0].Position;
                            RefreshProgress();
                            return;
                    }
                    throw new Exception("Expecting label or serial scan.");
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
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

        private void MenuItemRefreshClick(object sender, EventArgs e)
        {
            RefreshProgress();
        }

        private void ScanToLocationViewActivated(object sender, EventArgs e)
        {
            ResetGun();
        }

        private void ScanToLocationViewDeactivated(object sender, EventArgs e)
        {
            //this.StopRead();
        }

        private void UxCbSerialEnterClick(object sender, EventArgs e)
        {
            string serialData = uxTextBoxSerial.Text;
            try
            {
                //  Scan object to location.
                TryProcessSerial(Int32.Parse(serialData));
            }
            catch (ArgumentNullException ex)
            {
                uxLabelMessage.Text = ex.Message + "Entered data not recognized.";
            }
            catch (OverflowException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + serialData;
            }
            catch (FormatException ex)
            {
                uxLabelMessage.Text = ex.Message + "Scan not recognized.  " + serialData;
            }
            catch (Exception ex)
            {
                uxLabelMessage.Text = ex.Message + serialData;
            }
        }
    }
}