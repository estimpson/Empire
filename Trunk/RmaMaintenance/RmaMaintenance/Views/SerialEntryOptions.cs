using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Views;

namespace RmaMaintenance.Views
{
    public partial class SerialEntryOptions : Form
    {
        #region Class Objects

        private SerialEntryCopy _serialEntryCopy;
        private SerialEntryManual _serialEntryManual;
        //private SerialEntryParts _serialEntryParts;
        private SerialEntryPartsCopy _serialEntryPartsCopy;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public SerialEntryOptions(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            rbtnCopySerials.Checked = true;

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

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            ShowNextForm();
        }

        #endregion


        #region Methods

        private void ShowNextForm()
        {
            if (rbtnCopySerials.Checked)
            {
                _serialEntryCopy = new SerialEntryCopy(_operatorCode);
                _serialEntryCopy.ShowDialog();

                if (_serialEntryCopy.CloseAll) Close();
            }
            else if (rbtnTypeSerials.Checked)
            {
                _serialEntryManual = new SerialEntryManual(_operatorCode);
                _serialEntryManual.ShowDialog();

                if (_serialEntryManual.CloseAll) Close();
            }
            else // Get serials from copied parts
            {
                _serialEntryPartsCopy = new SerialEntryPartsCopy(_operatorCode);
                _serialEntryPartsCopy.ShowDialog();

                if (_serialEntryPartsCopy.CloseAll) Close();
            }
        }

        #endregion


    }
}
