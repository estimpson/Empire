using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;
using RmaMaintenance.DataModels;
using RmaMaintenance.LabelPrinting;

namespace RmaMaintenance.Views
{
    public partial class ShipoutExistingRtvOnly : Form
    {
        #region Class Objects

        private readonly ShipoutRmaRtvController _controller;
        private readonly Messages _messages;
        private readonly MessagesDialogResult _messagesDialogResult;

        //private DocumentPrinter _documentPrinter;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor 
        
        public ShipoutExistingRtvOnly(string operatorCode)
        {
            InitializeComponent();

            _controller = new ShipoutRmaRtvController();
            _messages = new Messages();
            _messagesDialogResult = new MessagesDialogResult();

            _operatorCode = operatorCode;

            ShowInTaskbar = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

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

        #endregion


        #region Button Events

        private void mesBtnRtvPackingSlip_Click(object sender, EventArgs e)
        {
            PrintPackingSlip();
        }
        private void mesBtnRtvLabels_MouseDown(object sender, MouseEventArgs e)
        {
        }

        private void mesBtnRtvLabels_Click(object sender, EventArgs e)
        {
            panel2.Dock = DockStyle.Fill;
            Cursor.Current = Cursors.WaitCursor;

            PrintLabels();

            panel2.Dock = DockStyle.None;
            Cursor.Current = Cursors.Default;
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
                SendEmail(rtvShipper);

                mesTbxHonLoc.Text = mesTbxRtvShipper.Text = "";
                mesTbxRtvShipper.Focus();
            }
            panel2.Dock = DockStyle.None;
            Cursor.Current = Cursors.Default;
        }
        
        #endregion


        #region Methods

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
                _messages.Message = "FAILED to create the Honduras RMA!  Click the Shipout RTV button again for this shipper to complete the RMA.";
                _messages.ShowDialog();
                return 0;
            }

            // Honduras RMA succeeded
            if (previouslyShipped)
            {
                successMessage += "Successfully created the Honduras RMA.";
            }
            else
            {
                successMessage += "  AND created the Honduras RMA.";
            }

            _messages.Message = successMessage;
            _messages.ShowDialog();
            return 1;
        }

        private void SendEmail(string shipper)
        {
            string error;

            // Send out an email report showing all Troy and Honduras serial transactions that took place
            _controller.SendExistingRtvEmail(_operatorCode, shipper, out error);

            Cursor.Current = Cursors.Default;
        }



        #endregion


    }
}
