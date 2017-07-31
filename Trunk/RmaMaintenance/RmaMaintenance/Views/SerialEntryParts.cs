using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controls;
using RmaMaintenance.Controllers;

namespace RmaMaintenance.Views
{
    public partial class SerialEntryParts : Form
    {
        #region Class Objects

        private readonly SerialEntryPartsController _controller;
        private readonly Messages _messages;
        private CreateOptions _createOptions;

        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public SerialEntryParts(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            _controller = new SerialEntryPartsController();
            _messages = new Messages();

            GetDestinations();

            SetPartsGridColumnProperties();
            SetPartsGridProperties();

            ShowInTaskbar = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            //const int THICKNESS = 2;
            //const int HALF_THICKNESS = THICKNESS / 2;
            //using (var p = new Pen(Color.FromArgb(0, 122, 204), THICKNESS))
            //{
            //    e.Graphics.DrawRectangle(p, new Rectangle(HALF_THICKNESS,
            //        HALF_THICKNESS,
            //        panel1.ClientSize.Width - THICKNESS,
            //        panel1.ClientSize.Height - THICKNESS));
            //}
        }

        #endregion


        #region LinkLabel Events

        private void linkLblClose_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Close();
        }

        private void linkLblClose_MouseEnter(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = Color.Red;
        }

        private void linkLblClose_MouseLeave(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }

        #endregion


        #region Button Events

        private void mesBtnShowSerials_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnShowSerials_Click(object sender, EventArgs e)
        {
            string destination = cbxDestination.Text.Trim();
            if (destination == "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = "The original destination (where the parts came from) must be selected.";
                _messages.ShowDialog();
                return;
            }

            // Delete the last batch of serials this operator processed
            if (DeleteSerialsQuantities() == 0) return;

            // Validate entered data and create serials list
            if (GetSerialsFromPartDest(destination) == 0) return;

            // Import serials for processing
            if (ImportSerialsQuantities() == 0) return;

            Cursor.Current = Cursors.Default;

            _createOptions = new CreateOptions(_operatorCode, _controller.SerialsList);
            _createOptions.ShowDialog();

            if (!_createOptions.CloseAll) return;
            CloseAll = true;
            Close();
        }

        #endregion


        #region Methods

        private void GetDestinations()
        {
            string error;
            cbxDestination.DataSource = _controller.GetDestinations(out error);
            if (error != "")
            {
                _messages.Message = error;
                _messages.ShowDialog();
                return;
            }
            cbxDestination.DisplayMember = "destination";
        }

        private int GetSerialsFromPartDest(string destination)
        {
            _controller.SerialsList.Clear();
            bool partEntered = false;

            foreach (DataGridViewRow dr in dgvPartsQuantities.Rows)
            {
                if (!partEntered)
                {
                    if ((dr.Cells[0].Value == null || dr.Cells[0].Value.ToString() == ""))
                    {
                        Cursor.Current = Cursors.Default;
                        _messages.Message = "At least one part and quantity must be entered.";
                        _messages.ShowDialog();
                        return 0;
                    }
                    partEntered = true;
                }
                if (dr.Cells[0].Value == null) break;  // We have parts, and the end of the entered parts has been reached

                string part = dr.Cells[0].Value.ToString();
                string quantity = (dr.Cells[1].Value != null) ? dr.Cells[1].Value.ToString() : "";
                if (quantity == "")
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = string.Format("A quantity needs to be entered for part {0}.  Nothing was processed.", part);
                    _messages.ShowDialog();
                    return 0;
                }

                decimal qty;
                try
                {
                    qty = Convert.ToInt32(quantity);
                }
                catch (Exception)
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = string.Format("Invalid quantity found for part {0}.  Nothing was processed.", part);
                    _messages.ShowDialog();
                    return 0;
                }

                // Create a list of the most recent serials for the parts entered that had been shipped to the destination
                string error;
                _controller.GetSerialsFromPartDest(_operatorCode, destination, part, qty, out error);
                if (error != "")
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = error;
                    _messages.ShowDialog();
                    return 0;
                }
            }
            return 1;
        }

        private int DeleteSerialsQuantities()
        {
            string error;

            // Delete the last batch of serials processed by this operator
            _controller.DeleteOldSerialsQuantities(_operatorCode, out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int ImportSerialsQuantities()
        {
            string error;

            // Import the data into a table
            int importResult = 1;
            foreach (var item in _controller.SerialsList)
            {
                _controller.ImportDataIntoSql(_operatorCode, item.Serial, item.Quantity, out error);
                if (error != "")
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = error;
                    _messages.ShowDialog();
                    importResult = 0;
                    break;
                }
            }
            return importResult;
        }

        private void SetPartsGridColumnProperties()
        {
            dgvPartsQuantities.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 10);

            var partCol = new DataGridViewTextBoxColumn { HeaderText = "Part", Name = "colPart", Width = 158 };
            var quantityCol = new DataGridViewTextBoxColumn { HeaderText = "Qty", Name = "colQuantity", Width = 66 };
            dgvPartsQuantities.Columns.AddRange(new DataGridViewColumn[] { partCol, quantityCol });
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

        #endregion


    }
}
