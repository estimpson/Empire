using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FASTT.Controllers;

namespace FASTT.Views
{
    public partial class ReportsView : Form
    {
        #region Class Objects

        private ReportsController _controller;
        
        #endregion


        #region Properties

        public string OperatorCode { get; set; }

        private string _error;
        public string Error
        {
            get { return _error; }
            set
            {
                _error = lblErrorMessage.Text = value;
                lblErrorMessage.Visible = (_error != "");
            }
        }

        #endregion


        #region Constructor, Load

        public ReportsView()
        {
            InitializeComponent();

            _controller = new ReportsController();
        }

        private void ReportsView_Load(object sender, EventArgs e)
        {
            gridView1.OptionsBehavior.Editable = false;
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            Error = "";
        }
        
        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            int thickness = 2;
            int halfThickness = thickness / 2;
            using (var p = new Pen(Color.FromArgb(0, 122, 204), thickness))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
                                                          halfThickness,
                                                          panel1.ClientSize.Width - thickness,
                                                          panel1.ClientSize.Height - thickness));
            }
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

        private void mesBtnOpenQuotes_Click(object sender, EventArgs e)
        {
            GetOpenQuotes();
        }

        private void mesBtnNewQuotes_Click(object sender, EventArgs e)
        {
            GetNewQuotes();
        }

        #endregion


        #region Methods

        private void GetOpenQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdReports.DataSource = null;

            _controller.GetOpenQuotes();
            if (!_controller.ListOpenQuotes.Any()) return;

            grdReports.DataSource = _controller.ListOpenQuotes;

            //gridView1.Columns["Quote Number"].Visible = false;

            Cursor.Current = Cursors.Default;

            gridView1.Focus();
        }

        private void GetNewQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdReports.DataSource = null;

            _controller.GetNewQuotes();
            if (!_controller.ListNewQuotes.Any()) return;

            grdReports.DataSource = _controller.ListNewQuotes;

            //gridView1.Columns["Quote Number"].Visible = false;

            Cursor.Current = Cursors.Default;

            gridView1.Focus();
        }
        
        #endregion


    }
}
