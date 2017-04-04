#region Using

using System;
using System.Drawing;
using System.Windows.Forms;
using RmaMaintenance.UserControls;

#endregion

namespace RmaMaintenance.Views
{
    public partial class NewRmaView : Form
    {
        #region Properties

        public string OperatorCode { get; set; }

        public string RMANumber
        {
            get { return ucNewRmaCreate1.RMANumber; }
            set { ucNewRmaCreate1.RMANumber = value; }
        }

        public string RTVNumber
        {
            get { return ucNewRmaCreate1.RTVNumber; }
            set { ucNewRmaCreate1.RTVNumber = value; }
        }

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
                    ucNewRmaCreate1.ShowOptionOne = true;
                }
                else // Enter parts and quantities
                {
                    tlpCreateRma.Visible = true;
                    ucNewRmaCreate1.ShowOptionOne = false;
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

                ucNewRmaCreate1.ClearAll();
                tlpCreateRma.Visible = false;
                Error = "";
            }
        }

        #endregion

        #region Constuctor, Load, Activated

        public NewRmaView()
        {
            InitializeComponent();

            ucNewRmaCreate1.SetView(this);
            ucNewRmaOptions1.SetView(this);

            RMAButton.Click += RMAButtonOnClick;
            RTVButton.Click += RTVButtonOnClick;
        }

        private void RMAButtonOnClick(object sender, EventArgs eventArgs)
        {
            RMAButton.Checked = false;
            RTVButton.Checked = false;
            ucNewRmaOptions1.RMAMode = true;
        }

        private void RTVButtonOnClick(object sender, EventArgs eventArgs)
        {
            RMAButton.Checked = false;
            RTVButton.Checked = false;
            ucNewRmaOptions1.RTVMode = true;
        }

        private void NewRmaViewLoad(object sender, EventArgs e)
        {
            ucNewRmaOptions1.ShowOptions = tlpCreateRma.Visible = false;
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            GetDestinations();
        }

        private void NewRmaViewActivated(object sender, EventArgs e)
        {
            ucNewRmaOptions1.mesTxtRmaNumber.Focus();
        }

        #endregion

        #region Panel Events

        private void Panel1Paint(object sender, PaintEventArgs e)
        {
            const int THICKNESS = 2;
            const int HALF_THICKNESS = THICKNESS/2;
            using (var p = new Pen(Color.FromArgb(0, 122, 204), THICKNESS))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(HALF_THICKNESS,
                    HALF_THICKNESS,
                    panel1.ClientSize.Width - THICKNESS,
                    panel1.ClientSize.Height - THICKNESS));
            }
        }

        #endregion

        #region LinkLabel Events

        private void LinkLblCloseLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Close();
        }

        private void LinkLblCloseMouseEnter(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = Color.Red;
        }

        private void LinkLblCloseMouseLeave(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }

        #endregion

        #region Methods

        private void GetDestinations()
        {
            Error = "";

            string error;
            ucNewRmaCreate1.GetDestinations(out error);
            if (error != "")
            {
                Error = error;
            }
        }

        #endregion
    }
}