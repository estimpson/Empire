using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;
using RmaMaintenance.DataModels;

namespace RmaMaintenance.Views
{
    public partial class SerialEntryManual : Form
    {
        #region Class Objects

        private readonly SerialEntryManualController _controller;
        private readonly Messages _messages;
        private CreateOptions _createOptions;

        private SerialQuantityDataModel _serialQuantityDataModel;
        private readonly List<SerialQuantityDataModel> _serialQuantityList = new List<SerialQuantityDataModel>();

        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public SerialEntryManual(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            _controller = new SerialEntryManualController();
            _messages = new Messages();

            SetPartsGridColumnProperties();
            SetPartsGridProperties();

            ShowInTaskbar = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            dgvSerialsQuantities.Focus();
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

        private void mesBtnGo_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            // Delete the last batch of serials this operator processed
            if (DeleteSerialsQuantities() == 0) return;

            // Validate entered data and create serials list
            if (GetSerialsList() == 0) return;

            // Import serials for processing
            if (ImportSerialsQuantities() == 0) return;

            Cursor.Current = Cursors.Default;

            _createOptions = new CreateOptions(_operatorCode, _serialQuantityList);
            _createOptions.ShowDialog();

            if (!_createOptions.CloseAll) return;
            CloseAll = true;
            Close();
        }
        
        #endregion


        #region Methods

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

        private int GetSerialsList()
        {
            _serialQuantityList.Clear();
            bool serialEntered = false;

            foreach (DataGridViewRow dr in dgvSerialsQuantities.Rows)
            {
                if (!serialEntered)
                {
                    if ((dr.Cells[0].Value == null || dr.Cells[0].Value.ToString() == ""))
                    {
                        Cursor.Current = Cursors.Default;
                        _messages.Message = "At least one serial and quantity must be entered.";
                        _messages.ShowDialog();
                        return 0;
                    }
                    serialEntered = true;
                }
                if (dr.Cells[0].Value == null) break;  // We have serials, and the end of the entered serials has been reached

                string serial = dr.Cells[0].Value.ToString();
                string quantity = (dr.Cells[1].Value != null) ? dr.Cells[1].Value.ToString() : "";
                if (quantity == "")
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = string.Format("A quantity needs to be entered for serial {0}.", serial);
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
                    _messages.Message = string.Format("Invalid quantity found for serial {0}.", serial);
                    _messages.ShowDialog();
                    return 0;
                }

                // Create list to process and send forward
                _serialQuantityDataModel = new SerialQuantityDataModel {Quantity = qty, Serial = Convert.ToInt32(serial)};
                _serialQuantityList.Add(_serialQuantityDataModel);
            }
            return 1;            
        }

        private int ImportSerialsQuantities()
        {
            string error;

            // Import the data into a table
            int importResult = 1;
            foreach (var item in _serialQuantityList)
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
            dgvSerialsQuantities.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 10);

            var serialCol = new DataGridViewTextBoxColumn { HeaderText = "Serial", Name = "colSerial", Width = 158 };
            var quantityCol = new DataGridViewTextBoxColumn { HeaderText = "Qty", Name = "colQuantity", Width = 66 };
            dgvSerialsQuantities.Columns.AddRange(new DataGridViewColumn[] { serialCol, quantityCol });
        }

        private void SetPartsGridProperties()
        {
            dgvSerialsQuantities.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            dgvSerialsQuantities.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvSerialsQuantities.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvSerialsQuantities.ColumnHeadersHeight = 30;
            dgvSerialsQuantities.EnableHeadersVisualStyles = false;

            dgvSerialsQuantities.ClearSelection();
        }

        #endregion


    }
}
