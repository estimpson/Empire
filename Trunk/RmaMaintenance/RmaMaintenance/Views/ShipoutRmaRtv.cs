﻿using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;
using RmaMaintenance.DataModels;
using RmaMaintenance.LabelPrinting;

namespace RmaMaintenance.Views
{
    public partial class ShipoutRmaRtv : Form
    {
        #region Class Objects

        private readonly ShipoutRmaRtvController _controller;
        private readonly Messages _messages;
        private readonly MessagesDialogResult _messagesDialogResult;

        private readonly List<NewShippersDataModel> _newShippersList = new List<NewShippersDataModel>();
        
        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;
        private readonly string _rmaRtvNumber;
        private bool _isDataBinding;

        #endregion


        #region Constructor

        public ShipoutRmaRtv(string operatorCode, string rmaRtvNumber, List<NewShippersDataModel> newShippersList)
        {
            InitializeComponent();

            _controller = new ShipoutRmaRtvController();
            _messages = new Messages();
            _messagesDialogResult = new MessagesDialogResult();

            _operatorCode = operatorCode;
            _rmaRtvNumber = rmaRtvNumber;
            _newShippersList = newShippersList;

            ShowInTaskbar = false;

            PopulateShippersList();
            mesTbxRtvShipper.Enabled = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            linkLblCloseAll.LinkBehavior = LinkBehavior.NeverUnderline;
            panel2.Dock = DockStyle.None;
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



        private void linkLblCloseAll_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            CloseAll = true;
            Close();
        }

        private void linkLblCloseAll_MouseEnter(object sender, EventArgs e)
        {
            linkLblCloseAll.LinkColor = Color.Red;
        }

        private void linkLblCloseAll_MouseLeave(object sender, EventArgs e)
        {
            linkLblCloseAll.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }

        #endregion


        #region DataGridView Events

        private void dgvNewShippers_SelectionChanged(object sender, EventArgs e)
        {
            if (_isDataBinding) return;

            foreach (DataGridViewRow row in dgvNewShippers.SelectedRows) mesTbxRtvShipper.Text = row.Cells[1].Value.ToString();
        }

        #endregion


        #region Button Events

        private void mesBtnRtvLabels_Click(object sender, EventArgs e)
        {
            panel2.Dock = DockStyle.Fill;
            Cursor.Current = Cursors.WaitCursor;

            PrintLabels();

            panel2.Dock = DockStyle.None;
            Cursor.Current = Cursors.Default;
        }

        private void mesBtnRtvPackingSlip_Click(object sender, EventArgs e)
        {
            PrintPackingSlip();
        }

        private void mesBtnShipout_MouseDown(object sender, MouseEventArgs e)
        {
        }

        private void mesBtnShipout_Click(object sender, EventArgs e)
        {
            panel2.Dock = DockStyle.Fill;
            Cursor.Current = Cursors.WaitCursor;

            string rtvShipper = mesTbxRtvShipper.Text.Trim();
            if (rtvShipper == "")
            {
                panel2.Dock = DockStyle.None;
                Cursor.Current = Cursors.Default;
                return;
            }

            string location = mesTbxHonLoc.Text.Trim();
            if (location == "")
            {
                panel2.Dock = DockStyle.None;
                Cursor.Current = Cursors.Default;
                _messages.Message = "Please enter a Honduras RMA location.";
                _messages.ShowDialog();
                return;
            }

            int shipper;
            try
            {
                shipper = Convert.ToInt32(rtvShipper);
            }
            catch (Exception)
            {
                panel2.Dock = DockStyle.None;
                Cursor.Current = Cursors.Default;
                _messages.Message = "The RTV shipper number is not valid.";
                _messages.ShowDialog();
                return;
            }

            if (ShipoutRtv(rtvShipper, shipper, location) == 1)
            {
                // Success (or the RTV shipper had previously been shipped, and the Honduras RMA was a success)
                SendEmail();
                ResetNewShippersList();
                DeleteSerialsQuantities();
            }
            panel2.Dock = DockStyle.None;
            Cursor.Current = Cursors.Default;
        }

        #endregion


        #region Methods

        private void PopulateShippersList()
        {
            _isDataBinding = true;
            dgvNewShippers.DataSource = _newShippersList;
            _isDataBinding = false;
        }

        private void PrintLabels()
        {
            string rtvShipper = mesTbxRtvShipper.Text.Trim();
            if (rtvShipper == "")
            {
                panel2.Dock = DockStyle.None;
                Cursor.Current = Cursors.Default;

                _messages.Message = "RTV shipper is required.";
                _messages.ShowDialog();
                return;
            }
            int iShipper = Convert.ToInt32(rtvShipper);

            // Get a list of serial numbers tied to this shipper
            string error;
            List<string> serials = new List<string>();
            serials = _controller.GetShipperSerials(iShipper, out error);
            if (error != "")
            {
                panel2.Dock = DockStyle.None;
                Cursor.Current = Cursors.Default;

                _messages.Message = error;
                _messages.ShowDialog();
                return;
            }

            foreach (var item in serials)
            {
                // Get label code with label data
                int serial = Convert.ToInt32(item);
                string labelCode = _controller.GetLabelCode(serial, out error);

                // Print the label
                bool result = DocumentPrinter.Print(labelCode);
                if (result == false)
                {
                    panel2.Dock = DockStyle.None;
                    Cursor.Current = Cursors.Default;

                    _messages.Message = string.Format("Failed to print a label for serial {0}.", serial.ToString());
                    _messages.ShowDialog();
                }
            }
        }

        private void PrintPackingSlip()
        {
            string rtvShipperText = mesTbxRtvShipper.Text.Trim();

            if (rtvShipperText == "")
            {
                _messages.Message = "RTV shipper is required.";
                _messages.ShowDialog();
                return;
            }

            int rtvShipper;
            try
            {
                rtvShipper = Convert.ToInt32(rtvShipperText);
            }
            catch (Exception)
            {
                _messages.Message = "The RTV shipper number is not valid.";
                _messages.ShowDialog();
                return;
            }

            var dialogRTVPackingSlip = new RTVPackingSlip { RTVShipperID = rtvShipper };
            dialogRTVPackingSlip.ShowDialog();
        }

        private int ShipoutRtv(string rtvShipper, int shipper, string location)
        {
            string error;

            // Make sure a connection to the Honduras EEH database can be established
            int? objectCount;
            _controller.CheckHondurasConnection(out objectCount, out error);
            if (!objectCount.HasValue || objectCount < 1)
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = "Failed to connect to the Honduras database.  Nothing was processed.  Please try again.";
                _messages.ShowDialog();
                return 0;
            }

            // Ship out the RTV shipper
            bool previouslyShipped;
            _controller.ShipRtvHondurasRma(_operatorCode, shipper, location, out previouslyShipped, out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }

            // Shipout RTV succeeded
            string successMessage = (previouslyShipped) 
                ? ""
                : string.Format("Successfully shipped out RTV {0}.", rtvShipper);


            // Create the Honduras RMA
            _controller.CreateHondurasRma(_operatorCode, shipper, location, out error);
            if (error != "")
            {
                if (!previouslyShipped)
                {
                    Cursor.Current = Cursors.Default;
                    _messages.Message = successMessage;  // Show that the RTV shipout succeeded
                    _messages.ShowDialog();
                }

                Cursor.Current = Cursors.Default;
                _messages.Message = string.Format("Failed to create Honduras RMA.  You'll need to click the Shipout RTV button again for this shipper.  {0}", error);
                _messages.ShowDialog();

                // Record the error returned from the Honduras RMA procedure
                string nextError;
                _controller.RecordHondurasRmaException(_operatorCode, error, out nextError);
                
                return 0;
            }

            // Honduras RMA succeeded
            if (previouslyShipped)
            {
                successMessage += "Successfully created the Honduras RMA.";
            }
            else
            {
                successMessage += "  And created the Honduras RMA.";
            }

            _messages.Message = successMessage;
            _messages.ShowDialog();

            // Refresh the shippers list grid
            dgvNewShippers.DataSource = null;
            dgvNewShippers.DataSource = _controller.NewShippersList;

            linkLblClose.Visible = false;
            return 1;
        }

        private void SendEmail()
        {
            string error;

            // Send out an email report showing all Troy and Honduras serial transactions that took place
            _controller.SendEmail(_operatorCode, _rmaRtvNumber, out error);
        }

        private void ResetNewShippersList()
        {
            string rtvShipper = mesTbxRtvShipper.Text.Trim();
            _controller.RemoveShippedOutRtvFromList(rtvShipper);

            mesTbxHonLoc.Text = mesTbxRtvShipper.Text = "";

            dgvNewShippers.DataSource = null;
            dgvNewShippers.DataSource = _controller.NewShippersList;
        }

        private void DeleteSerialsQuantities()
        {
            string error;

            // Delete this batch of serials processed by this operator
            _controller.DeleteOldSerialsQuantities(_operatorCode, out error);

            Cursor.Current = Cursors.Default;
        }


        #endregion


    }
}
