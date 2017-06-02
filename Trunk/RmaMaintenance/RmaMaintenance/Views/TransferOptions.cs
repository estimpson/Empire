using System;
using System.Drawing;
using System.Windows.Forms;

using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class TransferOptions : Form
    {
        #region Class Objects

        private TransferInventory _transferInventory;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public TransferOptions(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            rbtnHondurasTransfer.Checked = true;
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

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            ShowNextForm();
        }

        #endregion


        #region Methods

        private void ShowNextForm()
        {
            _transferInventory = rbtnHondurasTransfer.Checked ? new TransferInventory(_operatorCode, true) : new TransferInventory(_operatorCode, false);
            _transferInventory.ShowDialog();

            if (_transferInventory.CloseAll) Close();
        }

        #endregion


    }
}
