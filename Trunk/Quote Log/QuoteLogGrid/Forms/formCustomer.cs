using QuoteLogGrid.Controllers;
using System;
using System.Windows.Forms;

namespace QuoteLogGrid.Forms
{
    public partial class formCustomer : Form
    {
        CustomerController _controller;

        private bool _formLoading;
        private bool _checkChanged;


        public formCustomer()
        {
            InitializeComponent();

            _formLoading = true;

            _controller = new CustomerController(this);
            rbtnCreateNew.Checked = true;

            _formLoading = false;

            // Dropdown lists are populated on controller class initialization, so check for database errors
            if (_controller.Error != "") MessageBox.Show(_controller.Error, "Error");
        }

        private void formCustomer_Activated(object sender, EventArgs e)
        {
            tbxOperator.Focus();
        }



        #region Control Events

        private void rbtnCreateNew_CheckedChanged(object sender, EventArgs e)
        {
            if (_formLoading) return;

            _checkChanged = true;
            rbtnEditExisting.Checked = !rbtnCreateNew.Checked;

            if (rbtnCreateNew.Checked)
            {
                _controller.FormState = 1;
                _controller.ToggleForm();
                _controller.ClearForm();
            }
            _checkChanged = false;
        }

        private void rbtnEditExisting_CheckedChanged(object sender, EventArgs e)
        {
            rbtnCreateNew.Checked = !rbtnEditExisting.Checked;

            _checkChanged = true;
            if (rbtnEditExisting.Checked)
            {
                _controller.FormState = 2;
                _controller.ToggleForm(); // And get customer codes for dropdown list
                if (_controller.Error != "") MessageBox.Show(_controller.Error, "Error");

                _controller.ClearForm();
            }
            _checkChanged = false;
        }

        private void cbxCode_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_formLoading || _checkChanged) return;

            if (cbxCode.Text.Trim() == "")
            {
                _controller.ClearForm();
                pnlEdit.Enabled = false;
            }
            else
            {
                _controller.GetCustomer();
                pnlEdit.Enabled = true;
            }
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            if (tbxOperator.Text.Trim() == "")
            {
                MessageBox.Show("Please enter you operator code.", "Message");
                return;
            }
            if (_controller.ValidateForm() == 0) return;

            Save();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


        #region Methods

        private void Save()
        {
            string errorHeader = "";
            if (_controller.FormState == 1)
            {
                _controller.InsertCustomer();
                errorHeader = "Error at InsertCustomer()";
            }
            else
            {
                _controller.UpdateCustomer();
                errorHeader = "Error at UpdaeteCustomer()";
            }

            if (_controller.Error != "")
            {
                MessageBox.Show(_controller.Error, errorHeader);
            }
            else
            {
                MessageBox.Show("Success", "Message");
                _controller.ClearForm();
            }
        }


        #endregion


    }
}
