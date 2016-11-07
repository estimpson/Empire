using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FASTT.Controllers;
using FASTT.Views;
//using Fx.RFID.Controller;


namespace FASTT
{
    public partial class formMain : Form
    {
        #region Class Objects

        private readonly MainController _controller;
        private SalesLeadsView _salesLeadsView;
        private SalesLeadsActivityView _salesLeadsActivityView;
        private ReportsView _reportsView;
        
        #endregion


        #region Variables

        private string _name;
        private string _operatorCode;

        #endregion


        #region Constants

        private const int CGrip = 16;      // Grip size
        private const int CCaption = 24;   // Caption bar height;

        #endregion


        #region Enums

        private enum ManualLogon
        {
            Hide,
            Show
        }

        #endregion


        #region Constructor, Load, Activated

        public formMain()
        {
            InitializeComponent();

            _controller = new MainController();
        }

        private void formMain_Load(object sender, EventArgs e)
        {
            SetLinkLabelProperties();

            //this.KeyPress += RFIDReader.ViewOnKeyPress;
            //this.KeyPreview = true;

            //RFIDReader.RFIDRead += RFIDReader_RFIDRead;

            var salesOpportunitiesToolTip = new ToolTip();
            salesOpportunitiesToolTip.SetToolTip(mesBtnPrograms, "Click here to create a new sales lead.");

            var openSalesLeadsToolTip = new ToolTip();
            openSalesLeadsToolTip.SetToolTip(mesBtnSalesActivity, "Click here to view open sales leads.");

            mesBtnCharts.Visible = false;
            lblScanInstructions.Visible = false;
            TogglePasswordEntry(ManualLogon.Show, "");
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
            mesTbxPassword.Focus();
        }

        #endregion


        #region RFIDReader Event

        //void RFIDReader_RFIDRead(object sender, RFIDReader.RFIDReaderReadArgs e)
        //{
        //    // `  (badge begin character) removed 
        //    // ~  (badge end character) removed

        //    ValidateLogonAttempt(e.ReaderData);
        //}

        #endregion


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
            linkLblClose.LinkColor = ColorTranslator.FromHtml("240,240,240");
        }

        #endregion


        #region Button Click Events

        private void mesBtnLogon_Click(object sender, EventArgs e)
        {
            string password = mesTbxPassword.Text.Trim();
            if (password == "") return;

            ValidateLogonAttempt(password);
        }

        private void mesBtnSalesLeads_Click(object sender, EventArgs e)
        {
            _salesLeadsView = new SalesLeadsView();
            _salesLeadsView.OperatorCode = _operatorCode;
            _salesLeadsView.ShowDialog();
        }

        private void mesBtnSalesActivity_Click(object sender, EventArgs e)
        {
            _salesLeadsActivityView = new SalesLeadsActivityView();
            _salesLeadsActivityView.OperatorCode = _operatorCode;
            _salesLeadsActivityView.ShowDialog();
        }

        private void mesBtnReports_Click(object sender, EventArgs e)
        {
            _reportsView = new ReportsView();
            _reportsView.OperatorCode = _operatorCode;
            _reportsView.ShowDialog();
        }

        #endregion


        #region Other Methods

        private void mesTbxPassword_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                string password = mesTbxPassword.Text.Trim();
                if (password == "") return;

                ValidateLogonAttempt(password);
            }
        }

        #endregion


        #region Methods

        private void SetLinkLabelProperties()
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("240,240,240");
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        protected override void WndProc(ref Message m)
        {
            if (m.Msg == 0x84)
            {
                // Trap WM_NCHITTEST
                var pos = new Point(m.LParam.ToInt32() & 0xffff, m.LParam.ToInt32() >> 16);
                pos = this.PointToClient(pos);
                if (pos.Y < CCaption)
                {
                    m.Result = (IntPtr)2;  // HTCAPTION
                    return;
                }
                if (pos.X >= this.ClientSize.Width - CGrip && pos.Y >= this.ClientSize.Height - CGrip)
                {
                    m.Result = (IntPtr)17; // HTBOTTOMRIGHT
                    return;
                }
            }
            base.WndProc(ref m);
        }

        private void ValidateLogonAttempt(string password)
        {
            string error;
            _controller.ValidateLogon(password, out _name, out _operatorCode, out error);

            TogglePasswordEntry(error != "" ? ManualLogon.Show : ManualLogon.Hide, error);
        }

        private void TogglePasswordEntry(ManualLogon manualLogon, string errorMessage)
        {
            lblLogonError.Text = errorMessage;
            mesTbxPassword.Text = "";

            if (manualLogon == ManualLogon.Show)
            {
                lblPassword.Visible = mesTbxPassword.Visible =
                    mesBtnLogon.Visible = lblLogonError.Visible = true;

                flowLayoutPanel1.Enabled = false;

                mesTbxPassword.Focus();
            }
            else
            {
                lblPassword.Visible = mesTbxPassword.Visible =
                    mesBtnLogon.Visible = lblLogonError.Visible = false;

                flowLayoutPanel1.Enabled = true;
            }
        }

        #endregion


    }
}
