#region Using

//using Fx.RFID.Controller;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Views;

#endregion

namespace RmaMaintenance
{
    public partial class formMain : Form
    {
        #region Class Objects

        private readonly MainController _controller;
        //private NewRmaView _newRmaView;
        private SerialEntryOptions _serialOptions;
        private AssignPoView _assignPoView;
        private TransferOptions _transferOptions;
        private ShipoutExistingRtvOnly _shipoutExistingRtvOnly;
        private RmaRtvHistoryOptions _rmaRtvHistoryOptions;
        //private RmaCreditMemoExisting _rmaCreditMemoExisting;

        #endregion


        #region Variables

        private string _operatorCode;

        #endregion


        #region Constants

        private const int CGrip = 16; // Grip size
        private const int CCaption = 24; // Caption bar height;

        #endregion


        #region Enums

        private enum ManualLogon
        {
            Hide,
            Show
        }

        #endregion


        #region Constructor, Load, Activated

        public formMain()
        {
            InitializeComponent();

            _controller = new MainController();

            //var newRtvView = new NewRtvView();
            //newRtvView.SetViewModel(new RtvController { OperatorCode = _operatorCode });
            //newRtvView.ShowDialog();
        }

        private void formMain_Load(object sender, EventArgs e)
        {
            linkLblClose.TabStop = false;

            SetLinkLabelProperties();

            //this.KeyPress += RFIDReader.ViewOnKeyPress;
            //this.KeyPreview = true;

            //RFIDReader.RFIDRead += RFIDReader_RFIDRead;

            lblScanInstructions.Visible = false;
            lblLogonError.Text = "";

            flowLayoutPanel1.Enabled = false;
        }


        private void formMain_Activated(object sender, EventArgs e)
        {
            mesTbxOpCode.Focus();
        }

        #endregion


        #region LinkButton Events

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
            linkLblClose.LinkColor = ColorTranslator.FromHtml("240,240,240");
        }

        #endregion


        #region Button Click Events

        private void mesBtnLogon_Click(object sender, EventArgs e)
        {
            ValidateLogonAttempt();
        }

        private void mesBtnNewRma_Click(object sender, EventArgs e)
        {
            //_newRmaView = new NewRmaView {OperatorCode = _operatorCode};
            //_newRmaView.OptionOneSelected = true;
            //_newRmaView.ShowDialog();

            _serialOptions = new SerialEntryOptions(_operatorCode);
            _serialOptions.ShowDialog();
        }

        private void RtvButtonClick(object sender, EventArgs e)
        {
            var newRtvView = new NewRtvView();
            newRtvView.SetViewModel(new RtvController { OperatorCode = _operatorCode });
            newRtvView.ShowDialog();
        }

        private void mesBtnAssignPo_Click(object sender, EventArgs e)
        {
            _assignPoView = new AssignPoView {OperatorCode = _operatorCode};
            _assignPoView.ShowDialog();
        }

        private void mesBtnTransferInv_Click(object sender, EventArgs e)
        {
            _transferOptions = new TransferOptions(_operatorCode);
            _transferOptions.ShowDialog();
        }

        private void mesBtnEditRma_Click(object sender, EventArgs e)
        {
        }

        private void mesBtnShipoutExistingRtv_Click(object sender, EventArgs e)
        {
            _shipoutExistingRtvOnly = new ShipoutExistingRtvOnly(_operatorCode);
            _shipoutExistingRtvOnly.ShowDialog();
        }

        private void mesBtnHistory_Click(object sender, EventArgs e)
        {
            _rmaRtvHistoryOptions = new RmaRtvHistoryOptions(_operatorCode);
            _rmaRtvHistoryOptions.ShowDialog();
        }

        private void mesBtnCreditMemo_Click(object sender, EventArgs e)
        {
            // ***** A call to the RMA credit memo procedure has been built into RMA processing (7/21/2017). *****

            //_rmaCreditMemoExisting = new RmaCreditMemoExisting(_operatorCode);
            //_rmaCreditMemoExisting.ShowDialog();
        }

        #endregion


        #region Textbox KeyDown Events

        private void MESTbxPasswordKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter) ValidateLogonAttempt();
        }

        #endregion


        #region Methods

        private void SetLinkLabelProperties()
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("240,240,240");
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        protected override void WndProc(ref Message m)
        {
            if (m.Msg == 0x84)
            {
                // Trap WM_NCHITTEST
                var pos = new Point(m.LParam.ToInt32() & 0xffff, m.LParam.ToInt32() >> 16);
                pos = PointToClient(pos);
                if (pos.Y < CCaption)
                {
                    m.Result = (IntPtr)2; // HTCAPTION
                    return;
                }
                if (pos.X >= ClientSize.Width - CGrip && pos.Y >= ClientSize.Height - CGrip)
                {
                    m.Result = (IntPtr)17; // HTBOTTOMRIGHT
                    return;
                }
            }
            base.WndProc(ref m);
        }

        private void ValidateLogonAttempt()
        {
            string operatorCode = mesTbxOpCode.Text.Trim();
            string password = mesTbxPassword.Text.Trim();
            if (operatorCode == "")
            {
                lblLogonError.Text = "Please enter your operator code.";
                return;
            }
            if (password == "")
            {
                lblLogonError.Text = "Please enter your password.";
                return;
            }

            string error;
            _controller.ValidateLogon(operatorCode, password, out error);
            if (error != "")
            {
                lblLogonError.Text = error;
                mesTbxPassword.Text = "";
                flowLayoutPanel1.Enabled = false;

                mesTbxOpCode.Focus();
            }
            else
            {
                _operatorCode = operatorCode;
                lblLogonError.Text = "";
                lblOpCode.Visible = lblPassword.Visible = mesTbxOpCode.Visible = mesTbxPassword.Visible = mesBtnLogon.Visible = false;
                flowLayoutPanel1.Enabled = true;
            }
        }

        #endregion


    }
}