using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controls;
using RmaMaintenance.Controllers;
using RmaMaintenance.DataModels;

namespace RmaMaintenance.Views
{
    public partial class CreateRmaRtv : Form
    {
        #region Class Objects

        //private RmaCreditMemo _rmaCreditMemo;
        private ReviewRmaRtv _reviewRmaRtv;
        private readonly CreateRmaRtvConroller _controller;
        private readonly Messages _messages;

        private readonly List<SerialQuantityDataModel> _serialQuantityList = new List<SerialQuantityDataModel>();

        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;
        private readonly int _transactionType; // 0 = rma + rtv, 1 = rma only, 2 = rma only w/serials on hold, 3 = rtv only

        #endregion


        #region Constructor

        public CreateRmaRtv(string operatorCode, int transactionType, List<SerialQuantityDataModel> serialQuantityList)
        {
            InitializeComponent();

            _operatorCode = operatorCode;
            _transactionType = transactionType;
            _serialQuantityList = serialQuantityList;

            _controller = new CreateRmaRtvConroller();
            _messages = new Messages();

            PopulateLocationList();
            ShowSerialsList();
            SetControlAppearance();

            ShowInTaskbar = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            mesTxtRmaNumber.Focus();
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

        private void mesBtnAutoGenerateRma_Click(object sender, EventArgs e)
        {
            GenerateRmaNumber();
        }

        private void mesBtnCreateRma_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnCreateRma_Click(object sender, EventArgs e)
        {
            string rmaRtvNumber = mesTxtRmaNumber.Text.Trim();
            if (rmaRtvNumber == "" && _transactionType < 3) // RMA involved, but RMA number not entered
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = "Please enter the RMA number.";
                _messages.ShowDialog();
                return;
            }

            if (_transactionType < 3)
            {
                if (ProcessSerials(rmaRtvNumber) == 0) return;
            }
            else
            {
                if (ProcessSerialsRtvOnly() == 0) return;
            }
            
            if (_transactionType == 1 || _transactionType == 2) // RMA-only (without or with serials on hold)
            {
                Cursor.Current = Cursors.WaitCursor;

                // Send RMA-only email report
                string error;
                _controller.SendEmail(_operatorCode, rmaRtvNumber, out error);



                // ***** A call to the RMA credit memo procedure has been built into RMA processing (7/21/2017). *****

                // Since there will be no RTV to ship, go directly to the Create Credit Memo form
                //_rmaCreditMemo = new RmaCreditMemo(_operatorCode, rmaRtvNumber, _transactionType, _controller.NewShippersList);
                //_rmaCreditMemo.ShowDialog();

                Cursor.Current = Cursors.Default;
                CloseAll = true;
                Close();
            }

            // RMA / RTV created; show the user the results before proceeding to the shipout form
            _reviewRmaRtv = new ReviewRmaRtv(_operatorCode, _transactionType, _controller.ReturnedRmaRtvNumber, _controller.NewShippersList);
            _reviewRmaRtv.ShowDialog();

            if (!_reviewRmaRtv.CloseAll) return;
            CloseAll = true;
            Close();
        }

        #endregion


        #region Methods

        private void PopulateLocationList()
        {
            List<string> locationList = new List<string>();
            locationList.Add("");
            locationList.Add("EEA RMA");
            locationList.Add("EEI RMA");
            locationList.Add("EEP RMA");
            locationList.Add("EEHRMA");

            cbxRmaToLocation.DataSource = locationList;
        }

        private void ShowSerialsList()
        {
            foreach (var item in _serialQuantityList)
            {
                string data = string.Format("{0} : {1}", item.Serial.ToString(), item.Quantity.ToString());
                lbxSerials.Items.Add(data);
            }
        }

        private void SetControlAppearance()
        {
            switch (_transactionType)
            {
                case 0:
                    lblInstructionOne.Visible = lblInstructionTwo.Visible = lblInstructionThree.Visible = true;
                    mesTxtRmaNumber.Visible = mesBtnAutoGenerateRma.Visible = cbxRmaToLocation.Visible = mesTbxRmaNote.Visible = true;

                    mesBtnCreateRma.Text = "Create RMA / RTV";
                    break;
                case 1:
                    lblInstructionOne.Visible = lblInstructionTwo.Visible = lblInstructionThree.Visible = true;
                    mesTxtRmaNumber.Visible = mesBtnAutoGenerateRma.Visible = cbxRmaToLocation.Visible = mesTbxRmaNote.Visible = true;

                    mesBtnCreateRma.Text = "Create RMA";
                    break;
                case 2:
                    lblInstructionOne.Visible = lblInstructionTwo.Visible = lblInstructionThree.Visible = true;
                    mesTxtRmaNumber.Visible = mesBtnAutoGenerateRma.Visible = cbxRmaToLocation.Visible = mesTbxRmaNote.Visible = true;

                    mesBtnCreateRma.Text = "RMA Serials On Hold";
                    break;
                case 3:
                    lblInstructionOne.Visible = lblInstructionTwo.Visible = lblInstructionThree.Visible = false;
                    mesTxtRmaNumber.Visible = mesBtnAutoGenerateRma.Visible = cbxRmaToLocation.Visible = mesTbxRmaNote.Visible = false;

                    mesBtnCreateRma.Text = "Create RTV";
                    break;
            }
        }

        private void GenerateRmaNumber()
        {
            string error;
            _controller.GenerateRmaNumber(_operatorCode, out error);
            if (error != "")
            {
                _messages.Message = error;
                _messages.ShowDialog();
            }
            mesTxtRmaNumber.Text = _controller.ReturnedRmaNumber;
        }

        private int ProcessSerials(string rmaRtvNumber)
        {
            string notes = mesTbxRmaNote.Text.Trim();
            string location = cbxRmaToLocation.Text.Trim();
            if (location == "") location = null;

            string error;
            _controller.ProcessSerials(_operatorCode, rmaRtvNumber, _transactionType, location, notes, out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }
            Cursor.Current = Cursors.Default;
            return 1;
        }

        private int ProcessSerialsRtvOnly()
        {
            string error;
            _controller.ProcessSerialsRtvOnly(_operatorCode, out error);
            if (error != "")
            {
                Cursor.Current = Cursors.Default;
                _messages.Message = error;
                _messages.ShowDialog();
                return 0;
            }
            Cursor.Current = Cursors.Default;
            return 1;
        }


        #endregion


    }
}
