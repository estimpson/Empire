using System;
using System.Drawing;
using System.Windows.Forms;

namespace RmaMaintenance.Views
{
    public partial class RmaRtvHistoryOptions : Form
    {
        #region Class Objects

        private RmaRtvHistory _rmaRtvHistory;
        private RmaRtvHistoryByShipper _rmaRtvHistoryByShipper;
        private RmaRtvHistoryByDateRange _rmaRtvHistoryByDateRange;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public RmaRtvHistoryOptions(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            rbtnLookupByShipper.Checked = true;
            mesBtnGo.Focus();
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


        #region Button Click Events

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            ShowNextForm();
        }

        #endregion


        #region Methods

        private void ShowNextForm()
        {
            if (rbtnLookupByShipper.Checked)
            {
                _rmaRtvHistoryByShipper = new RmaRtvHistoryByShipper(_operatorCode);
                _rmaRtvHistoryByShipper.ShowDialog();
            }
            else if (rbtnLookupByDates.Checked)
            {
                _rmaRtvHistoryByDateRange = new RmaRtvHistoryByDateRange(_operatorCode);
                _rmaRtvHistoryByDateRange.ShowDialog();
            }
            else
            {
                _rmaRtvHistory = new RmaRtvHistory(_operatorCode);
                _rmaRtvHistory.ShowDialog();
            }
        }

        #endregion


    }
}
