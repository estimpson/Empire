#region Using

using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;
using RmaMaintenance.Views;

#endregion

namespace RmaMaintenance.UserControls
{
    public partial class ucNewRmaCreate : UserControl
    {
        #region Class Objects

        private NewRmaView _view;
        private readonly NewRmaCreateController _controller;
        private readonly Messages _message;
        private readonly MessagesDialogResult _messageDialogResult;

        #endregion

        #region Properties

        private bool _showOptionOne;
        private string _rmaNumber;

        public bool ShowOptionOne
        {
            get { return _showOptionOne; }
            set
            {
                _showOptionOne = value;
                if (value)
                {
                    tlpPasteSerials.Visible = true;
                    tlpEnterPartQty.Visible = false;
                }
                else
                {
                    tlpPasteSerials.Visible = false;
                    tlpEnterPartQty.Visible = true;
                }
            }
        }

        public string RMANumber
        {
            get { return _rmaNumber; }
            set
            {
                _rmaNumber = value;
                if (string.IsNullOrEmpty(_rmaNumber))
                {
                    return;
                }
                if (_controller.QualityRMADetails(_rmaNumber) <= 0) return;
                _messageDialogResult.Message =
                    "Existing RTV found.";

                dgvNewShippers.DataSource = null;
                dgvNewShippers.DataSource = _controller.NewShippersList;
            }
        }

        private string _rtvNumber;
        public string RTVNumber
        {
            get { return _rtvNumber; }
            set
            {
                _rtvNumber = value;
                if (string.IsNullOrEmpty(_rtvNumber))
                {
                    _rtvNumber =_controller.NewRTV();
                    return;
                }
                if (_controller.GetRTVDetails(_rtvNumber) <= 0) return;
                _messageDialogResult.Message =
                    "Existing RTV found.";

                dgvNewShippers.DataSource = null;
                dgvNewShippers.DataSource = _controller.NewShippersList;
            }
        }

        #endregion

        #region Constructor

        public ucNewRmaCreate()
        {
            InitializeComponent();
            _controller = new NewRmaCreateController();
            _message = new Messages();
            _messageDialogResult = new MessagesDialogResult();

            SetPartsGridColumnProperties();
            SetPartsGridProperties();
            SetShippersGridProperties();


            mesBtnCreateRma.Enabled = false;
            cbxCreateRtv.Visible = cbxSerialsOnHold.Visible = false;
            cbxCreateRtv.Checked = true;
            rbtnTransferWarehouse.Checked = true;
        }

        public void SetView(NewRmaView view)
        {
            _view = view;
        }

        #endregion

        #region DataGridView Events

        private void dgvPartsQuantities_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            // Set grid row properties
            dgvPartsQuantities.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Black;
            dgvPartsQuantities.Rows[e.RowIndex].DefaultCellStyle.ForeColor = Color.FromArgb(240, 240, 240);
            dgvPartsQuantities.Rows[e.RowIndex].DefaultCellStyle.Font = new Font("Tahoma", 10);
            dgvPartsQuantities.Rows[e.RowIndex].DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 122, 204);
        }

        private void dgvNewShippers_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            // Set grid row properties
            dgvNewShippers.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Black;
            dgvNewShippers.Rows[e.RowIndex].DefaultCellStyle.ForeColor = Color.FromArgb(240, 240, 240);
            dgvNewShippers.Rows[e.RowIndex].DefaultCellStyle.Font = new Font("Tahoma", 9);
            dgvNewShippers.Rows[e.RowIndex].DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 122, 204);
        }

        private void dgvNewShippers_SelectionChanged(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvNewShippers.SelectedRows)
            {
                mesTbxRmaShipper.Text = row.Cells[0].Value.ToString();
                mesTbxRtvShipper.Text = row.Cells[1].Value.ToString();
            }
        }

        #endregion

        #region CheckBox Check Changed Events

        private void cbxCreateRtv_CheckedChanged(object sender, EventArgs e)
        {
            cbxSerialsOnHold.Checked = (!cbxCreateRtv.Checked);
        }

        #endregion

        #region RadioButton Click Events

        private void rbtnTransferHonduras_CheckedChanged(object sender, EventArgs e)
        {
            rbtnTransferWarehouse.Checked = (!rbtnTransferHonduras.Checked);
        }

        private void rbtnTransferWarehouse_CheckedChanged(object sender, EventArgs e)
        {
            rbtnTransferHonduras.Checked = (!rbtnTransferWarehouse.Checked);
        }

        #endregion

        #region Serials Button Click Events

        private void mesBtnImportSerials_Click(object sender, EventArgs e)
        {
            if (ImportFromSpreadsheet() == 0) return;

            mesBtnCreateRma.Enabled = true;
            cbxCreateRtv.Visible = cbxSerialsOnHold.Visible = true;
        }

        private void mesBtnClearList_Click(object sender, EventArgs e)
        {
            ClearSerialsList();
        }

        #endregion

        #region Parts/Quantities Button Click Events

        private void mesBtnShowSerials_Click(object sender, EventArgs e)
        {
            if (mesBtnShowSerials.Text == "Get Serials")
            {
                GetSerialsList();
            }
            else
            {
                ShowSerialsList();
            }
        }

        private void mesBtnClear_Click(object sender, EventArgs e)
        {
            ClearPartsQuantitiesDataGrid();
        }

        #endregion

        #region Processing Button Click Events

        private void mesBtnCreateRma_Click(object sender, EventArgs e)
        {
            if (!cbxCreateRtv.Checked)
            {
                _messageDialogResult.Message =
                    "Create RTV shipper is not checked, so only a RMA will be created.  Continue?";
                DialogResult dr = _messageDialogResult.ShowDialog();
                if (dr == DialogResult.No) return;
            }

            if (cbxCreateRtv.Checked && cbxSerialsOnHold.Checked)
            {
                _messageDialogResult.Message =
                    "Serials will not be staged to the RTV shipper if you place them on hold.  Do you want to continue? (Not recommended.)";
                DialogResult dr = _messageDialogResult.ShowDialog();
                if (dr == DialogResult.No) return;
            }

            if (_showOptionOne)
            {
                CreateRmaSerialsOption();
            }
            else
            {
                CreateRmaPartsQuantitiesOption();
            }
        }

        private void mesBtnRtvShipper_Click(object sender, EventArgs e)
        {
            if (ShipRtvHondurasRma() == 1) ResetNewShippersList();
        }

        private void mesBtnTransferSerials_Click(object sender, EventArgs e)
        {
            TransferSerials();
        }

        #endregion

        #region PartsQuantities Option Methods

        public void GetDestinations(out string error)
        {
            cbxDestination.DataSource = _controller.GetDestinations(out error);
            if (error != "") return;

            cbxDestination.DisplayMember = "destination";
        }

        private void GetSerialsList()
        {
            string destination = cbxDestination.Text.Trim();
            if (destination == "")
            {
                _message.Message = "The destination (where the parts are coming from) must be selected.";
                _message.ShowDialog();
                return;
            }

            if (dgvPartsQuantities.Rows.Count == 0)
            {
                _message.Message = "You have not entered any parts.";
                _message.ShowDialog();
                return;
            }

            // Delete old serials
            if (DeleteOldSerialsQuantities() == 0) return;

            // Loop through parts / quantities grid and return a list of serials to RMA
            if (GetSerialsFromPartDest(destination) == 0) return;

            // Show serials
            var view = new SerialsListView();
            view.dgvSerialsList.DataSource = _controller.SerialsList;
            view.ShowDialog();

            mesBtnCreateRma.Enabled = true;
            mesBtnShowSerials.Text = "Show Serials";
        }

        private void ShowSerialsList()
        {
            var view = new SerialsListView();
            view.dgvSerialsList.DataSource = _controller.SerialsList;
            view.ShowDialog();
        }

        private void CreateRmaPartsQuantitiesOption()
        {
            Cursor.Current = Cursors.WaitCursor;
            ProcessSerials();
            Cursor.Current = Cursors.Default;
        }

        private int GetSerialsFromPartDest(string destination)
        {
            _controller.SerialsList.Clear();

            foreach (DataGridViewRow dr in dgvPartsQuantities.Rows)
            {
                if (dr.Cells[0].Value == null) break;

                string part = dr.Cells[0].Value.ToString();
                string quantity = (dr.Cells[1].Value != null) ? dr.Cells[1].Value.ToString() : "";

                if (quantity == "")
                {
                    _message.Message =
                        string.Format("A quantity needs to be entered for part {0}.  Nothing was processed.", part);
                    _message.ShowDialog();
                    return 0;
                }

                decimal qty;
                try
                {
                    qty = Convert.ToInt32(quantity);
                }
                catch (Exception)
                {
                    _message.Message = string.Format("Invalid quantity found for part {0}.  Nothing was processed.",
                        part);
                    _message.ShowDialog();
                    return 0;
                }

                // Create a list of the most recent serials for the parts entered that have been
                //  shipped to the destination to be RMA'd
                if (_controller.GetSerialsFromPartDest(_view.OperatorCode, destination, part, qty) == 0) return 0;
            }
            return 1;
        }

        private void SetPartsGridColumnProperties()
        {
            dgvPartsQuantities.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 10);

            var partCol = new DataGridViewTextBoxColumn {HeaderText = "Part", Name = "colPart", Width = 160};
            var quantityCol = new DataGridViewTextBoxColumn {HeaderText = "Quantity", Name = "colQuantity", Width = 80};
            dgvPartsQuantities.Columns.AddRange(new DataGridViewColumn[] {partCol, quantityCol});
        }

        private void SetPartsGridProperties()
        {
            dgvPartsQuantities.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            dgvPartsQuantities.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvPartsQuantities.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvPartsQuantities.ColumnHeadersHeight = 30;
            dgvPartsQuantities.EnableHeadersVisualStyles = false;

            dgvPartsQuantities.ClearSelection();
        }

        private void SetShippersGridProperties()
        {
            dgvNewShippers.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            dgvNewShippers.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvNewShippers.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvNewShippers.ColumnHeadersHeight = 30;
            dgvNewShippers.EnableHeadersVisualStyles = false;
        }

        private void ClearPartsQuantitiesDataGrid()
        {
            dgvPartsQuantities.Rows.Clear();
            dgvPartsQuantities.Refresh();

            mesBtnCreateRma.Enabled = false;
        }

        #endregion

        #region Serials Option Methods

        private void CreateRmaSerialsOption()
        {
            if (DeleteOldSerialsQuantities() == 0) return;
            if (ImportIntoSql() == 0) return;

            Cursor.Current = Cursors.WaitCursor;
            ProcessSerials();
            Cursor.Current = Cursors.Default;
        }

        private int ImportFromSpreadsheet()
        {
            int result = _controller.ImportDataFromSpreadsheet();
            if (result == 0) return result;

            foreach (var item in _controller.SerialsList)
            {
                string data = item.Serial.ToString() + " : " + item.Quantity.ToString();
                lbxSerials.Items.Add(data);
            }
            return 1;
        }

        private int DeleteOldSerialsQuantities()
        {
            int result = _controller.DeleteOldSerialsQuantities();
            return result;
        }

        private int ImportIntoSql()
        {
            int result = 1;

            foreach (var item in _controller.SerialsList)
            {
                result = _controller.ImportDataIntoSql(item.Serial, item.Quantity);
                if (result == 0) break;
            }
            return result;
        }

        private void ClearSerialsList()
        {
            lbxSerials.Items.Clear();
            mesBtnCreateRma.Enabled = false;
        }

        #endregion

        #region Overlap Methods

        private void ProcessSerials()
        {
            int createRtvShipper = (cbxCreateRtv.Checked) ? 1 : 0;
            int placeSerialsOnHold = (cbxSerialsOnHold.Checked) ? 1 : 0;
            string note = mesTbxRmaNote.Text.Trim();

            int result = _controller.ProcessData(_view.OperatorCode, RMANumber, createRtvShipper,
                placeSerialsOnHold, note);
            if (result == 0) return;

            // Success
            dgvNewShippers.DataSource = null;
            dgvNewShippers.DataSource = _controller.NewShippersList;
            if (createRtvShipper == 0)
            {
                ClearSerialsList();
                ClearPartsQuantitiesDataGrid();
            }

            mesBtnShowSerials.Text = "Get Serials";
        }

        private int ShipRtvHondurasRma()
        {
            string rtvShipper = mesTbxRtvShipper.Text.Trim();
            string location = mesTbxHonLoc.Text.Trim();

            if (rtvShipper == "")
            {
                _message.Message = "RTV shipper is required.";
                _message.ShowDialog();
                return 0;
            }

            if (location == "")
            {
                _message.Message = "You must enter a Honduras location to RMA to.";
                _message.ShowDialog();
                return 0;
            }

            int iRtvShipper;
            try
            {
                iRtvShipper = Convert.ToInt32(mesTbxRtvShipper.Text.Trim());
            }
            catch (Exception)
            {
                _message.Message = "The RTV shipper number is not valid.";
                _message.ShowDialog();
                return 0;
            }

            _messageDialogResult.Message = "Labels have been printed (if necessary)?  Packing list has been printed?";
            DialogResult dr = _messageDialogResult.ShowDialog();
            if (dr == DialogResult.No) return 0;

            Cursor.Current = Cursors.WaitCursor;
            int result = _controller.ShipRtvHondurasRma(_view.OperatorCode, iRtvShipper, location);

            if (result == 1)
            {
                // RTV has been shipped, so create the Honduras RMA
                _controller.CreateHondurasRma(_view.OperatorCode, iRtvShipper, location);
            }
            Cursor.Current = Cursors.Default;

            return result;
        }

        private void ResetNewShippersList()
        {
            string rtvShipper = mesTbxRtvShipper.Text.Trim();
            _controller.RemoveShippedOutRtvFromList(rtvShipper);

            mesTbxHonLoc.Text = mesTbxRmaShipper.Text = mesTbxRtvShipper.Text = "";

            dgvNewShippers.DataSource = null;
            dgvNewShippers.DataSource = _controller.NewShippersList;
        }

        private void TransferSerials()
        {
            string location = mesTbxWarehouseLoc.Text.Trim();
            if (location == "")
            {
                _message.Message = "Please enter a transfer location.";
                _message.ShowDialog();
                return;
            }

            if (rbtnTransferHonduras.Checked)
            {
                TransferSerialsHonduras(location);
            }
            else
            {
                TransferSerialsTroyWarehouse(location);
            }
        }

        private void TransferSerialsHonduras(string location)
        {
            string rtv = mesTbxRtvShipper.Text.Trim();
            if (rtv == "")
            {
                _message.Message = "RTV shipper is required for making a Honduras transfer.";
                _message.ShowDialog();
                return;
            }

            int rtvShipper;
            try
            {
                rtvShipper = Convert.ToInt32(mesTbxRtvShipper.Text.Trim());
            }
            catch (Exception)
            {
                _message.Message = "The RTV shipper number is not valid.";
                _message.ShowDialog();
                return;
            }

            Cursor.Current = Cursors.WaitCursor;
            int result = _controller.TransferHondurasLocation(_view.OperatorCode, rtvShipper, location);
            if (result == 1) ClearAll();
            Cursor.Current = Cursors.Default;
        }

        private void TransferSerialsTroyWarehouse(string location)
        {
            string rma = mesTbxRmaShipper.Text.Trim();
            if (rma == "")
            {
                _message.Message = "RMA shipper is required for making a Troy warehouse transfer.";
                _message.ShowDialog();
                return;
            }

            int rmaShipper;
            try
            {
                rmaShipper = Convert.ToInt32(mesTbxRmaShipper.Text.Trim());
            }
            catch (Exception)
            {
                _message.Message = "The RMA shipper number is not valid.";
                _message.ShowDialog();
                return;
            }

            Cursor.Current = Cursors.WaitCursor;
            int result = _controller.TransferRmaSerials(_view.OperatorCode, rmaShipper, location);
            if (result == 1) ClearAll();
            Cursor.Current = Cursors.Default;
        }

        public void ClearAll()
        {
            ClearSerialsList();

            mesTbxHonLoc.Text = mesTbxRmaShipper.Text = mesTbxRtvShipper.Text = mesTbxWarehouseLoc.Text = "";

            cbxCreateRtv.Checked = cbxSerialsOnHold.Checked = false;

            cbxDestination.SelectedIndex = -1;
            dgvPartsQuantities.Rows.Clear();
        }

        #endregion

        private void RtvPackingSlipButtonClick(object sender, EventArgs e)
        {
            string rtvShipperText = mesTbxRtvShipper.Text.Trim();

            if (rtvShipperText == "")
            {
                _message.Message = "RTV shipper is required.";
                _message.ShowDialog();
                return;
            }

            int rtvShipper;
            try
            {
                rtvShipper = Convert.ToInt32(rtvShipperText);
            }
            catch (Exception)
            {
                _message.Message = "The RTV shipper number is not valid.";
                _message.ShowDialog();
                return;
            }

            var dialogRTVPackingSlip = new RTVPackingSlip { RTVShipperID = rtvShipper };
            dialogRTVPackingSlip.ShowDialog();
        }
    }
}