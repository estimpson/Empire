using System;
using System.Windows.Forms;
using RmaMaintenance.Views;

namespace RmaMaintenance.UserControls
{
    public partial class ucNewRmaOptions : UserControl
    {
        #region Class Objects

        private readonly NewRmaView _view;

        #endregion


        #region Properties

        private bool _showOptions;
        public bool ShowOptions
        {
            get { return _showOptions; }
            set
            {
                _showOptions = value;
                rbtnPasteSerials.Visible = rbtnEnterPartQty.Visible = (value);
            }
        }

        #endregion


        #region Variables

        private bool _formClearing;

        #endregion


        #region Constructor

        public ucNewRmaOptions()
        {
            InitializeComponent();
        }
        
        public ucNewRmaOptions(NewRmaView view)
        {
            InitializeComponent();

            _view = view;
        }

        #endregion


        #region Button Click Event

        private void mesBtnEnterRmaNumber_Click(object sender, EventArgs e)
        {
            if (mesTxtRmaNumber.Text.Trim() == "") return;
         
            ToggleRmaOptions();
        }

        #endregion


        #region RadioButton Click Events

        private void rbtnPasteSerials_CheckedChanged(object sender, EventArgs e)
        {
            if (_formClearing) return;

            rbtnEnterPartQty.Checked = !rbtnPasteSerials.Checked;
            _view.OptionOneSelected = true;
        }

        private void rbtnEnterPartQty_CheckedChanged(object sender, EventArgs e)
        {
            if (_formClearing) return;

            rbtnPasteSerials.Checked = !rbtnEnterPartQty.Checked;
            _view.OptionOneSelected = false;
        }

        #endregion


        #region Methods

        public void ToggleRmaOptions()
        {
            if (mesBtnEnterRmaNumber.Text == "Enter")
            {
                rbtnPasteSerials.Visible = rbtnEnterPartQty.Visible = true;
                rbtnPasteSerials.Checked = true;

                mesTxtRmaNumber.Enabled = false;
                mesBtnEnterRmaNumber.Text = "Change";

                _view.RmaNumber = mesTxtRmaNumber.Text.Trim();
            }
            else
            {
                _view.ClearingForm = _formClearing = true;

                rbtnPasteSerials.Visible = rbtnEnterPartQty.Visible = false;
                rbtnPasteSerials.Checked = rbtnEnterPartQty.Checked = false;

                mesTxtRmaNumber.Text = "";
                mesTxtRmaNumber.Enabled = true;
                mesBtnEnterRmaNumber.Text = "Enter";

                _view.ClearingForm = _formClearing = false;
            }
        }

        #endregion


    }
}
