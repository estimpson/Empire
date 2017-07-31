using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class RmaRtvHistoryByShipper : Form
    {
        #region Class Objects

        private readonly RmaRtvHistoryController _controller;
        private readonly Messages _messages;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public RmaRtvHistoryByShipper(string operatorCode)
        {
            InitializeComponent();

            _controller = new RmaRtvHistoryController();
            _messages = new Messages();

            _operatorCode = operatorCode;

            SetGridColumnProperties();
            SetGridProperties();

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

        private void mesBtnSubmit_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnSubmit_Click(object sender, EventArgs e)
        {
            GetHistoryByShipper();
            Cursor.Current = Cursors.Default;
        }

        #endregion


        #region TextBox KeyDown Events

        private void mesTbxShipper_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                Cursor.Current = Cursors.WaitCursor;
                GetHistoryByShipper();
                Cursor.Current = Cursors.Default;
            }
        }
        #endregion


        #region Methods

        private void SetGridColumnProperties()
        {
            dgvRmaRtvHistory.ColumnHeadersDefaultCellStyle.Font = new Font("Tahoma", 11);

            //var partCol = new DataGridViewTextBoxColumn { HeaderText = "Part", Name = "colPart", Width = 158 };
            //var quantityCol = new DataGridViewTextBoxColumn { HeaderText = "Qty", Name = "colQuantity", Width = 66 };
            //dgvRmaRtvHistory.Columns.AddRange(new DataGridViewColumn[] { partCol, quantityCol });
        }

        private void SetGridProperties()
        {
            dgvRmaRtvHistory.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            //dgvRmaRtvHistory.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvRmaRtvHistory.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            dgvRmaRtvHistory.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvRmaRtvHistory.ColumnHeadersHeight = 30;
            dgvRmaRtvHistory.EnableHeadersVisualStyles = false;

            dgvRmaRtvHistory.ClearSelection();
        }

        private void GetHistoryByShipper()
        {
            string shipper = mesTbxShipper.Text.Trim();
            if (shipper == "") return;

            dgvRmaRtvHistory.DataSource = null;

            string error;
            _controller.GetRmaRtvHistoryByShipper(_operatorCode, shipper, out error);
            if (error != "")
            {
                _messages.Message = error;
                _messages.ShowDialog();
                return;
            }

            dgvRmaRtvHistory.DataSource = _controller.DetailsByShipperList;
            dgvRmaRtvHistory.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            dgvRmaRtvHistory.AutoResizeColumns();
        }

        #endregion


    }
}
