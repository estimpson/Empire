using System;
using System.Drawing;
using System.Windows.Forms;
using ImportLogisticsVarianceData.Views;


namespace ImportLogisticsVarianceData
{
    public partial class formMain : Form
    {
        #region Constants

        private const int CGrip = 16; // Grip size
        private const int CCaption = 24; // Caption bar height;

        #endregion


        #region Variables

        private string _operatorCode;

        #endregion


        public formMain()
        {
            InitializeComponent();
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            lblErrorMessage.Text = "";
            mesBtnFedExImport.Enabled = false;

            mesTbxOperatorCode.Focus();
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
            linkLblClose.LinkColor = Color.RoyalBlue;
        }

        #endregion


        #region Button Click Events

        private void mesBtnLogin_Click(object sender, EventArgs e)
        {
            if (mesTbxOperatorCode.Text.Trim() == "")
            {
                lblErrorMessage.Text = "Please enter an operator code.";
                return;
            }
            if (mesTbxPassword.Text.Trim() == "")
            {
                lblErrorMessage.Text = "Please enter a password.";
                return;
            }

            ValidateOperator();
        }

        private void mesBtnFedExImport_Click(object sender, EventArgs e)
        {
            var view = new FedExVarianceView(_operatorCode);
            view.ShowDialog();
        }

        #endregion


        #region Methods

        private void ValidateOperator()
        {

            _operatorCode = "ASB";

            pnlLogin.Visible = false;
            mesBtnFedExImport.Enabled = true;
        }

        #endregion


    }
}
