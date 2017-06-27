using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class RmaRtvHistoryByDateRange : Form
    {
        #region Class Objects

        private readonly RmaRtvHistoryController _controller;
        private readonly Messages _messages;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public RmaRtvHistoryByDateRange(string operatorCode)
        {
            InitializeComponent();

            _controller = new RmaRtvHistoryController();
            _messages = new Messages();

            _operatorCode = operatorCode;

            SetGridColumnProperties();
            SetGridProperties();

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
            GetHistoryByDateRange();
            Cursor.Current = Cursors.Default;
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

        private void GetHistoryByDateRange()
        {
            if (dtpStartDate.Text.Trim() == "") return;
            if (dtpEndDate.Text.Trim() == "") return;

            DateTime startDate = dtpStartDate.Value;
            DateTime endDate = dtpEndDate.Value;

            dgvRmaRtvHistory.DataSource = null;

            string error;
            _controller.GetRmaRtvHistoryByDateRange(_operatorCode, startDate, endDate, out error);
            if (error != "")
            {
                _messages.Message = error;
                _messages.ShowDialog();
                return;
            }

            dgvRmaRtvHistory.DataSource = _controller.DetailsByDatesList;
            dgvRmaRtvHistory.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            dgvRmaRtvHistory.AutoResizeColumns();
        }
        
        #endregion


    }
}
