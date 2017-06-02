using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class SerialEntryPartsCopy : Form
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

        public SerialEntryPartsCopy(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            _controller = new SerialEntryPartsController();
            _messages = new Messages();

            GetDestinations();

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

        private void mesBtnImportParts_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnImportParts_Click(object sender, EventArgs e)
        {
            string destination = cbxDestination.Text.Trim();
            if (destination == "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = "The original destination (where the parts came from) must be selected.";
                _messages.ShowDialog();
                return ;
            }

            // Delete the last batch of serials this operator processed
            if (DeleteSerialsQuantities() == 0) return;

            // Get parts / quantities from clipboard
            if (ImportPartsQuantities() == 0) return;

            // Validate copied data and create serials list from the list of parts / quantities
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

        private int ImportPartsQuantities()
        {
            string error;

            // Get spreadsheet serials and quantities
            _controller.GetSpreadsheetData(out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int GetSerialsFromPartDest(string destination)
        {
            _controller.SerialsList.Clear();

            foreach (var item in _controller.PartsList)
            {            
                // Create a list of the most recent serials for the parts entered that had been shipped to the destination
                string error;
                _controller.GetSerialsFromPartDest(_operatorCode, destination, item.Part, item.Quantity, out error);
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

        #endregion


    }
}
