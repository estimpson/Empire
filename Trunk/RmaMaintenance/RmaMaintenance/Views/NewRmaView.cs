using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.UserControls;

namespace RmaMaintenance.Views
{
    public partial class NewRmaView : Form
    {
        #region Class Objects

        private readonly ucNewRmaCreate _ucNewRmaCreate;
        private readonly ucNewRmaOptions _ucNewRmaOptions;

        #endregion


        #region Properties

        public string OperatorCode { get; set; }
        public string RmaNumber { get; set; }

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

        private bool _optionOneSelected;
        public bool OptionOneSelected
        {
            get { return _optionOneSelected; }
            set
            {
                _optionOneSelected = value;
                if (value) // Paste serials
                {
                    tlpCreateRma.Visible = true;
                    _ucNewRmaCreate.ShowOptionOne = true;
                }
                else // Enter parts and quantities
                {
                    tlpCreateRma.Visible = true;
                    _ucNewRmaCreate.ShowOptionOne = false;
                }
            }
        }

        private bool _clearingForm;
        public bool ClearingForm
        {
            get { return _clearingForm; }
            set 
            { 
                _clearingForm = value;
                if (!value) return;

                _ucNewRmaCreate.ClearAll();
                tlpCreateRma.Visible = false;
                Error = "";
            }
        }

        #endregion


        #region Constuctor, Load, Activated

        public NewRmaView()
        {
            InitializeComponent();

            _ucNewRmaCreate = new ucNewRmaCreate(this);
            _ucNewRmaOptions = new ucNewRmaOptions(this);

            tlpCreateRma.SuspendLayout();
            tlpCreateRma.Controls.Add(_ucNewRmaCreate);
            tlpCreateRma.ResumeLayout();

            tlpOptions.SuspendLayout();
            tlpOptions.Controls.Add(_ucNewRmaOptions);
            tlpOptions.ResumeLayout();
        }

        private void NewRmaView_Load(object sender, EventArgs e)
        {
            _ucNewRmaOptions.ShowOptions = tlpCreateRma.Visible = false;
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            GetDestinations();
        }

        private void NewRmaView_Activated(object sender, EventArgs e)
        {
            _ucNewRmaOptions.mesTxtRmaNumber.Focus();
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


        #region Methods

        private int GetDestinations()
        {
            Error = "";

            string error;
            _ucNewRmaCreate.GetDestinations(out error);
            if (error != "")
            {
                Error = error;
                return 0;
            }
            return 1;
        }

        #endregion


    }
}
