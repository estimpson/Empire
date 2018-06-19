using System;
using System.Drawing;
using System.Windows.Forms;
using ImportLogisticsVarianceData.Views;
using ImportLogisticsVarianceData.Model;
using System.Data.Objects;

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

        private void formMain_Load(object sender, EventArgs e)
        {
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            lblErrorMessage.Text = "";
            mesBtnFedExImport.Enabled = mesBtnImportChRobinson.Enabled = mesBtnPfSolutions.Enabled = mesBtnUpsImport.Enabled = false;
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
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

        private void mesTbxPassword_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != (char)Keys.Enter) return;

            string user = mesTbxOperatorCode.Text.Trim();
            string password = mesTbxPassword.Text.Trim();

            if (user == "")
            {
                lblErrorMessage.Text = "Please enter an operator code.";
                return;
            }
            if (password == "")
            {
                lblErrorMessage.Text = "Please enter a password.";
                return;
            }
            ValidateOperator(user, password);
        }

        private void mesBtnLogin_Click(object sender, EventArgs e)
        {
            string user = mesTbxOperatorCode.Text.Trim();
            string password = mesTbxPassword.Text.Trim();

            if (user == "")
            {
                lblErrorMessage.Text = "Please enter an operator code.";
                return;
            }
            if (password == "")
            {
                lblErrorMessage.Text = "Please enter a password.";
                return;
            }
            ValidateOperator(user, password);
        }

        private void mesBtnFedExImport_Click(object sender, EventArgs e)
        {
            var view = new FedExVarianceView(_operatorCode);
            view.ShowDialog();
        }

        private void mesBtnImportChRobinson_Click(object sender, EventArgs e)
        {
            var view = new ChRobinsonVarianceView(_operatorCode);
            view.ShowDialog();
        }

        private void mesBtnPfSolutions_Click(object sender, EventArgs e)
        {
            var view = new PfSolutionsVarianceView(_operatorCode);
            view.ShowDialog();
        }

        private void mesBtnUpsImport_Click(object sender, EventArgs e)
        {
            var view = new UpsVarianceView(_operatorCode);
            view.ShowDialog();
        }

        #endregion


        #region Methods

        private void ValidateOperator(string user, string password)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_Variance_ValidateOperator(user, password, dt, result);
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message; ;
                return;
            }

            _operatorCode = user;
            lblErrorMessage.Text = "";
            pnlLogin.Visible = false;
            mesBtnFedExImport.Enabled = mesBtnImportChRobinson.Enabled = mesBtnPfSolutions.Enabled = mesBtnUpsImport.Enabled = true;
        }


        #endregion


    }
}
