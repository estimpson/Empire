using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.Controllers;
using RmaMaintenance.Controls;

namespace RmaMaintenance.Views
{
    public partial class AssignPoView : Form
    {
        #region Class Objects

        private readonly AssignPoController _controller;
        private readonly Messages _messages;

        #endregion


        #region Variables

        private int _rtvShipper;
        private string _part;

        #endregion


        #region Properties

        public string OperatorCode { get; set; }

        #endregion


        #region Constructor

        public AssignPoView()
        {
            InitializeComponent();

            _controller = new AssignPoController();
            _messages = new Messages();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            //int thickness = 2;
            //int halfThickness = thickness / 2;
            //using (var p = new Pen(Color.FromArgb(0, 122, 204), thickness))
            //{
            //    e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
            //                                              halfThickness,
            //                                              panel1.ClientSize.Width - thickness,
            //                                              panel1.ClientSize.Height - thickness));
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


        #region Button Click Event

        private void mesBtnAssignPo_Click(object sender, EventArgs e)
        {
            AssignPo();
        }

        #endregion


        #region Methods

        private void AssignPo()
        {
            string input = mesTbxSerial.Text.Trim();
            if (input == "")
            {
                _messages.Message = "Enter a serial number.";
                _messages.ShowDialog();
                return;
            }

            int serial;
            bool result = Int32.TryParse(input, out serial);
            if (!result)
            {
                _messages.Message = "Serial must be numeric.";
                _messages.ShowDialog();
                return;
            }

            _controller.AssignPo(OperatorCode, serial);
            mesTbxSerial.Text = "";
        }
        
        #endregion


    }
}
