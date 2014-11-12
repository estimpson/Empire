#region Using

using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using APInvoices.Controllers;
using APInvoices.DataLayer.ModelViews;

#endregion

namespace APInvoices.Views
{
    public partial class ApHeaderBarcodesView : Form
    {
        #region Class Objects

        private ApHeaderBarcodesModelView _barcodesModelView;
        private XmlModelView _xmlModelView;
        private ViewController _controller;

        #endregion


        #region Properties

        public string ErrorMethod { get; set; }

        public string ErrorMessage
        {  
            set { MessageBox.Show(value, ErrorMethod); }
        }

        private List<ApHeaderBarcode> _barcodesList; 
        public List<ApHeaderBarcode> BarcodesList
        {
            get { return _barcodesList; }
            set
            {
                _barcodesList = value;

                foreach (var item in value)
                {
                    var listViewItem = new ListViewItem(item.RowId.ToString());
                    listViewItem.SubItems.Add(item.Vendor);
                    listViewItem.SubItems.Add(item.InvoiceNumber);
                    listViewItem.SubItems.Add(item.InvoiceCmFlag);

                    lvwInvoicesList.Items.Add(listViewItem);
                }
            }
        }

        private List<String> _vendorsReprintList;
        public List<String> VendorsReprintList
        {
            get { return _vendorsReprintList; }
            set 
            {
                _vendorsReprintList = value;

                cbxVendor.DataSource = _vendorsReprintList;
                cbxVendor.DisplayMember = "Vendor";
            }
        }

        private List<String> _flagsReprintList;
        public List<String> FlagsReprintList
        {
            get { return _flagsReprintList; }
            set
            {
                _flagsReprintList = value;

                cbxCmFlag.DataSource = _flagsReprintList;
                cbxCmFlag.DisplayMember = "InvCMFlag";
            }
        }

        private List<String> _invoicesReprintList;
        public List<String> InvoicesReprintList
        {
            get { return _invoicesReprintList; }
            set
            {
                _invoicesReprintList = value;

                cbxVendor.DataSource = _invoicesReprintList;
                cbxVendor.DisplayMember = "InvoiceCM";
            }
        }

        #endregion


        #region Variables

        private bool _isComboBoxLoading;
        private string _vendor;
        private string _flag;
        private string _invoice;

        #endregion


        #region Construction

        public ApHeaderBarcodesView()
        {
            InitializeComponent();

            SetListViewColumns();

            _barcodesModelView = new ApHeaderBarcodesModelView();
            _xmlModelView = new XmlModelView();
            _controller = new ViewController(this, _barcodesModelView, _xmlModelView);

            _controller.GetApHeaderData();

            _isComboBoxLoading = true;
            _controller.GetPrintedVendors();
            _isComboBoxLoading = false;

            btnReprint.Enabled = false;
        }

        #endregion


        #region Control Events

        private void btnPrintBarcodes_Click(object sender, System.EventArgs e)
        {
            _controller.Print();
        }

        private void btnFileScannedInvoices_Click(object sender, System.EventArgs e)
        {
            _controller.MoveScannedInvoices();
        }

        private void cbxVendor_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isComboBoxLoading) return;

            _vendor = cbxVendor.SelectedItem.ToString();
            if (_vendor == "") return;

            _isComboBoxLoading = true;
            _controller.GetPrintedCmFlags(_vendor);
            _isComboBoxLoading = false;
        }

        private void cbxCmFlag_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isComboBoxLoading) return;

            _flag = cbxCmFlag.SelectedItem.ToString();
            if (_flag == "") return;

            _isComboBoxLoading = true;
            _controller.GetPrintedInvoices(_vendor, _flag);
            _isComboBoxLoading = false;
        }

        private void cbxInvoice_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isComboBoxLoading) return;

            _invoice = cbxInvoice.SelectedItem.ToString();

            btnReprint.Enabled = (_invoice != "");
        }

        private void btnReprint_Click(object sender, EventArgs e)
        {
            _controller.Reprint(_vendor, _flag, _invoice);

            // Reset reprint controls
            InvoicesReprintList.Clear();
            FlagsReprintList.Clear();
            VendorsReprintList.Clear();

            _isComboBoxLoading = true;
            _controller.GetPrintedVendors();
            _isComboBoxLoading = false;

            btnReprint.Enabled = false;
        }

        #endregion


        #region Methods

        private void SetListViewColumns()
        {
            lvwInvoicesList.View = View.Details;
            lvwInvoicesList.Columns.Add("ID", 50, HorizontalAlignment.Left);
            lvwInvoicesList.Columns.Add("Vendor", 130, HorizontalAlignment.Left);
            lvwInvoicesList.Columns.Add("Invoice", 160, HorizontalAlignment.Left);
            lvwInvoicesList.Columns.Add("CmFlag", 50, HorizontalAlignment.Left);
        }

        #endregion

       
    }
}
