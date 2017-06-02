using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class TransferInventory : Form
    {
        #region Class Objects

        private readonly TransferInventoryController _controller;
        private readonly Messages _messages;
        
        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;
        private readonly bool _hondurasTransfer;
        
        private int _rmaRtvShipper;
        private string _toLocation;

        #endregion


        #region Constuctor

        public TransferInventory(string operatorCode, bool hondurasTransfer)
        {
            InitializeComponent();

            _controller = new TransferInventoryController();
            _messages = new Messages();

            _operatorCode = operatorCode;
            _hondurasTransfer = hondurasTransfer;

            SetInstructions();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            mesTbxTransferLoc.Focus();
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

        private void mesBtnTransferSerials_Click(object sender, EventArgs e)
        {
            if (ValidateForm() == 0) return;

            if (Transfer() == 1)
            {
                CloseAll = true;
                Close();
            }
        }

        #endregion


        #region Methods
        
        private void SetInstructions()
        {
            if (_hondurasTransfer)
            {
                lblInstructions1.Text = "1.  Enter the RTV shipper of the serials to transfer:";
                lblInstructions2.Text = "2.  Enter the Honduras location to transfer to:";
            }
            else
            {
                lblInstructions1.Text = "1.  Enter the RMA shipper of the serials to transfer:";
                lblInstructions2.Text = "2.  Enter the Troy warehouse location to transfer to:";
            }
        }

        private int ValidateForm()
        {
            string rmaRtvShipper = mesTxtShipper.Text.Trim();
            if (rmaRtvShipper == "")
            {
                _messages.Message = (_hondurasTransfer) ? "Please enter the RTV shipper." : "Please enter the RMA shipper.";
                _messages.ShowDialog();
                return 0;
            }

            _toLocation = mesTbxTransferLoc.Text.Trim();
            if (_toLocation == "")
            {
                _messages.Message = "Please enter a location to transfer the serials to.";
                _messages.ShowDialog();
                return 0;
            }

            try
            {
                _rmaRtvShipper = Convert.ToInt32(rmaRtvShipper);
            }
            catch (Exception)
            {
                _messages.Message = "Shipper must be a number.";
                _messages.ShowDialog();
                return 0;
            }

            return 1;
        }

        private int Transfer()
        {
            string error;
            if (_hondurasTransfer)
            {
                _controller.TransferHondurasLocation(_operatorCode, _rmaRtvShipper, _toLocation, out error);
                if (error != "")
                {
                    _messages.Message = error;
                    _messages.ShowDialog();
                    return 0;
                }
            }
            else
            {
                _controller.TransferRmaSerials(_operatorCode, _rmaRtvShipper, _toLocation, out error);
                if (error != "")
                {
                    _messages.Message = error;
                    _messages.ShowDialog();
                    return 0;
                }
            }
            return 1;
        }

        #endregion


    }
}
