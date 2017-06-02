using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using RmaMaintenance.Controls;
using RmaMaintenance.Controllers;

namespace RmaMaintenance.Views
{
    public partial class SerialEntryCopy : Form
    {
        #region Class Objects

        private readonly SerialEntryCopyController _controller;
        private readonly Messages _messages;
        private CreateOptions _createOptions;

        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructior

        public SerialEntryCopy (string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            _controller = new SerialEntryCopyController();
            _messages = new Messages();

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

        private void mesBtnImportSerials_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnImportSerials_Click(object sender, EventArgs e)
        {
            // Delete the last batch of serials this operator processed
            if (DeleteSerialsQuantities() == 0) return;

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

            // Get spreadsheet serials and quantities
            _controller.GetSpreadsheetData(out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }

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
