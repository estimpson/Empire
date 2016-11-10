using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ImportSpreadsheetData.DataLayer;

namespace ImportSpreadsheetData
{
    public partial class frmSalesOrderMaintenance : Form
    {
        #region Class Objects

        private readonly SalesOrderMaintenance _salesOrderMaintenance;

        #endregion


        #region Variables

        private bool _isDatabinding;
        private int _orderNo;
        private string _modelYear;

        #endregion


        #region Constructor

        public frmSalesOrderMaintenance(string destination)
        {
            InitializeComponent();

            _salesOrderMaintenance = new SalesOrderMaintenance();
            tbxDestination.Text = destination;

            ShowUpdateOrdersPanel(false);
        }

        #endregion


        #region Events

        private void tbxDestinationEnter_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                string dest = tbxDestinationEnter.Text.Trim();
                if (dest == "")
                {
                    MessageBox.Show("Enter a destination.", "Message");
                    return;
                }

                _isDatabinding = true;

                GetSalesOrders(dest);
                dgvSalesOrders.ClearSelection();

                _isDatabinding = false;
            }
        }

        private void btnEnterDestination_Click(object sender, EventArgs e)
        {
            string dest = tbxDestinationEnter.Text.Trim();
            if (dest == "")
            {
                MessageBox.Show("Enter a destination.", "Message");
                return;
            }

            _isDatabinding = true;

            GetSalesOrders(dest);
            dgvSalesOrders.ClearSelection();

            _isDatabinding = false;
        }

        private void dgvSalesOrders_SelectionChanged(object sender, EventArgs e)
        {
            if (_isDatabinding) return;

            int i = dgvSalesOrders.SelectedCells[0].RowIndex;

            _orderNo = Convert.ToInt32(dgvSalesOrders.Rows[i].Cells[0].Value);
            _modelYear = dgvSalesOrders.Rows[i].Cells[3].Value.ToString();

            btnUpdateOrder.Text = _modelYear == "P" ? "Remove" : "Add";
        }

        private void btnUpdateOrder_Click(object sender, EventArgs e)
        {
            if (_orderNo == 0)
            {
                MessageBox.Show("Select an order to update.", "Message");
                return;
            }
            UpdateSalesOrder();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


        #region Methods
        
        public void GetSalesOrders(string destination)
        {
            string error;
            dgvSalesOrders.DataSource = null;

            _salesOrderMaintenance.GetSalesOrders(destination, out error);
            if (error != "")
            {
                MessageBox.Show(error, "Error at GetSalesOrders()");
                ShowUpdateOrdersPanel(false);
                return;
            }
            dgvSalesOrders.DataSource = _salesOrderMaintenance.SalesOrdersList;
            ShowUpdateOrdersPanel(true);
        }

        private void UpdateSalesOrder()
        {
            string error;
            _modelYear = (_modelYear == "") ? "P" : null;

            _salesOrderMaintenance.UpdateSalesOrder(_orderNo, _modelYear, out error);
            if (error != "") MessageBox.Show(error, "Error at UpdateSalesOrder()");

            _isDatabinding = true;

            string dest = pnlDestEnter.Visible ? tbxDestinationEnter.Text.Trim() : tbxDestination.Text.Trim();

            GetSalesOrders(dest);
            dgvSalesOrders.ClearSelection();

            _isDatabinding = false;
        }

        public void ToggleDestinationPanels(bool destImported)
        {
            pnlDestImported.Visible = (destImported);
            pnlDestEnter.Visible = (!destImported);
        }

        private void ShowUpdateOrdersPanel(bool visibility)
        {
            pnlUpdateOrders.Visible = visibility;
        }

        #endregion


    }
}
