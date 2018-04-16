using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Objects;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogGrid.SupportClasses;

namespace QuoteLogGrid.Forms
{
    public partial class formNewSegmentRequest : Form
    {
        #region Class Objects

        private DataLayerEmpireMarket _viewModel;

        #endregion


        #region Constructor

        public formNewSegmentRequest()
        {
            InitializeComponent();

            _viewModel = new DataLayerEmpireMarket();

            rbtnSegment.Checked = true;
        }

        #endregion


        #region Control Events

        private void rbtnSegment_CheckedChanged(object sender, EventArgs e)
        {
            rbtnSubsegment.Checked = !rbtnSegment.Checked;
        }

        private void rbtnSubsegment_CheckedChanged(object sender, EventArgs e)
        {
            rbtnSegment.Checked = !rbtnSubsegment.Checked;
        }

        private void btnSubmit_Click(object sender, EventArgs e)
        {
            if (ValidateForm() == 0) return;

            if (rbtnSegment.Checked)
            {
                if (EmpireMarketSegmentRequest() == 0) return; // Save the request

                //EmpireMarketSegmentRequestSendEmail();
            }
            else
            {
                if (EmpireMarketSubsegmentRequest() == 0) return; // Save the request

                //EmpireMarketSubsegmentRequestSendEmail();
            }

            ClearForm();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


        #region Methods

        private int ValidateForm()
        {
            _viewModel.OperatorCode = tbxOperatorCode.Text.Trim();
            if (_viewModel.OperatorCode == "")
            {
                MessageBox.Show("Operator code is required.", "Message");
                return 0;
            }

            if (rbtnSegment.Checked)
            {
                _viewModel.Segment = tbxEmpireMarket.Text.Trim();
                if (_viewModel.Segment == "")
                {
                    MessageBox.Show("Empire Market Segment is required.", "Message");
                    return 0;
                }
            }
            else
            {
                _viewModel.Subsegment = tbxEmpireMarket.Text.Trim();
                if (_viewModel.Subsegment == "")
                {
                    MessageBox.Show("Empire Market Subsegment is required.", "Message");
                    return 0;
                }
            }

            _viewModel.Note = tbxNote.Text;
            return 1;
        }

        private int EmpireMarketSegmentRequest()
        {
            _viewModel.EmpireMarketSegmentRequest();
            if(_viewModel.ErrorMessage != "")
            {
                MessageBox.Show(_viewModel.ErrorMessage, "Error at EmpireMarketSegmentRequest()");
                return 0;
            }
            return 1;
        }

        private void EmpireMarketSegmentRequestSendEmail()
        {
            _viewModel.EmpireMarketSegmentRequestSendEmail();
            if (_viewModel.ErrorMessage != "")
            {
                MessageBox.Show(_viewModel.ErrorMessage, "Error at EmpireMarketSegmentRequestSendEmail()");
                return;
            }
        }

        private int EmpireMarketSubsegmentRequest()
        {
            _viewModel.EmpireMarketSubsegmentRequest();
            if (_viewModel.ErrorMessage != "")
            {
                MessageBox.Show(_viewModel.ErrorMessage, "Error at EmpireMarketSubsegmentRequest()");
                return 0;
            }
            return 1;
        }

        private void EmpireMarketSubsegmentRequestSendEmail()
        {
            _viewModel.EmpireMarketSubsegmentRequestSendEmail();
            if (_viewModel.ErrorMessage != "")
            {
                MessageBox.Show(_viewModel.ErrorMessage, "Error at EmpireMarketSubsegmentRequestSendEmail()");
                return;
            }
        }

        private void ClearForm()
        {
            tbxEmpireMarket.Text = tbxNote.Text = "";
        }

        #endregion


    }
}
