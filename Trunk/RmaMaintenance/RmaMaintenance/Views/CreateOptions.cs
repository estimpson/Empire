using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.DataModels;

namespace RmaMaintenance.Views
{
    public partial class CreateOptions : Form
    {
        #region Class Objects

        private CreateRmaRtv _createRmaRtv;

        private readonly List<SerialQuantityDataModel> _serialQuantityList = new List<SerialQuantityDataModel>();

        #endregion


        #region Properties

        public bool CloseAll { get; private set; }

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public CreateOptions(string operatorCode, List<SerialQuantityDataModel> serialQuantityList)
        {
            InitializeComponent();

            _operatorCode = operatorCode;
            _serialQuantityList = serialQuantityList;

            ShowInTaskbar = false;

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            rbtnCreateRmaRtv.Checked = true;
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


        #region Button Events

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            ShowNextForm();
        }

        #endregion


        #region Methods

        private void ShowNextForm()
        {
            if (rbtnCreateRmaRtv.Checked)
            {
                _createRmaRtv = new CreateRmaRtv(_operatorCode, 0, _serialQuantityList);
            }
            else if (rbtnCreateRmaOnly.Checked)
            {
                _createRmaRtv = new CreateRmaRtv(_operatorCode, 1, _serialQuantityList);
            }
            else if (rbtnCreateRmaOnlyHold.Checked)
            {
                _createRmaRtv = new CreateRmaRtv(_operatorCode, 2, _serialQuantityList);
            }
            else // RTV Only
            {
                _createRmaRtv = new CreateRmaRtv(_operatorCode, 3, _serialQuantityList);
            }
            _createRmaRtv.ShowDialog();

            if (!_createRmaRtv.CloseAll) return;
            CloseAll = true;
            Close();
        }

        #endregion


    }
}
