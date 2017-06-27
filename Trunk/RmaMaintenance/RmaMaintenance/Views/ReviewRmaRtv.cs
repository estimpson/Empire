using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;
using RmaMaintenance.DataModels;

namespace RmaMaintenance.Views
{
    public partial class ReviewRmaRtv : Form
    {
        #region Class Objects

        private readonly ReviewRmaRtvController _controller;
        private readonly Messages _messages;
        private ShipoutRmaRtv _shipoutRmaRtv;

        private readonly List<NewShippersDataModel> _newShippersList = new List<NewShippersDataModel>();

        #endregion

        
        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;
        private readonly int _transactionType;
        private readonly string _rmaRtvNumber;

        #endregion


        #region Constructor

        public ReviewRmaRtv(string operatorCode, int transactionType, string rmaRtvNumber, List<NewShippersDataModel> newShippersList)
        {
            InitializeComponent();

            _operatorCode = operatorCode;
            _transactionType = transactionType;
            _rmaRtvNumber = rmaRtvNumber;
            _newShippersList = newShippersList;

            _controller = new ReviewRmaRtvController();
            _messages = new Messages();

            SetControls();
            SetGridColumnProperties();
            SetGridProperties();
            PopulateGrid();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            mesBtnContinue.Focus();
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

        private void mesBtnUndoAll_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnUndoAll_Click(object sender, EventArgs e)
        {
            UndoRmaRtv();

            CloseAll = true;
            Close();
        }

        private void mesBtnContinue_Click(object sender, EventArgs e)
        {
            _shipoutRmaRtv = new ShipoutRmaRtv(_operatorCode, _rmaRtvNumber, _newShippersList);
            _shipoutRmaRtv.ShowDialog();

            if (!_shipoutRmaRtv.CloseAll) return;
            CloseAll = true;
            Close();
        }

        #endregion


        #region Methods

        private void SetControls()
        {
            lblRmaRtvNumber.Text = _rmaRtvNumber;

            if (_transactionType == 1 || _transactionType == 2)
            {
                // RMA Only, so processing is complete
                lblInstructions.Text = "RMA processing is complete.";
                mesBtnContinue.Visible = mesBtnUndoAll.Visible = false;
                linkLblClose.Visible = true;
            }
            else
            {
                // RTV shipper needs to be shipped out
                lblInstructions.Text = "If everything looks okay, click Continue to ship out the RTV and create the Honduras RMA.";
                mesBtnContinue.Visible = mesBtnUndoAll.Visible = true;
                linkLblClose.Visible = false;
            }
        }

        private void SetGridColumnProperties()
        {
            dgvReviewRmaRtv.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 11);

            //var partCol = new DataGridViewTextBoxColumn { HeaderText = "Part", Name = "colPart", Width = 158 };
            //var quantityCol = new DataGridViewTextBoxColumn { HeaderText = "Qty", Name = "colQuantity", Width = 66 };
            //dgvReviewRmaRtv.Columns.AddRange(new DataGridViewColumn[] { partCol, quantityCol });
        }

        private void SetGridProperties()
        {
            dgvReviewRmaRtv.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            //dgvReviewRmaRtv.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvReviewRmaRtv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            dgvReviewRmaRtv.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvReviewRmaRtv.ColumnHeadersHeight = 30;
            dgvReviewRmaRtv.EnableHeadersVisualStyles = false;

            dgvReviewRmaRtv.ClearSelection();
        }

        private void PopulateGrid()
        {
            dgvReviewRmaRtv.DataSource = null;

            string error;
            _controller.GetRmaRtvDetails(_operatorCode, _rmaRtvNumber, out error);
            if (error != "")
            {
                _messages.Message = error;
                _messages.ShowDialog();
                return;
            }

            dgvReviewRmaRtv.DataSource = _controller.ReviewList;
            dgvReviewRmaRtv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            dgvReviewRmaRtv.AutoResizeColumns();
        }

        private void UndoRmaRtv()
        {
            string error;
            _controller.UndoRmaRtv(_operatorCode, _rmaRtvNumber, out error);

            Cursor.Current = Cursors.Default;
            _messages.Message = error != "" ? string.Format("Failed to undo.  {0}", error) : "Success.";
            _messages.ShowDialog();
        }

        #endregion


    }
}
