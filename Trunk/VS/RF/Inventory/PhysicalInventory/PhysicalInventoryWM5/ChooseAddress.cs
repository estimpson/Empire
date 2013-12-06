using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using SymbolRFGun;
using PhysicalInventoryData;
using PhysicalInventoryData.DataSetPhysicalInventoryTableAdapters;
using SAF.Configuration;
using SAF.Cache;

namespace PhysicalInventory
{
    public partial class ChooseAddress : Form
    {
        private Cache cache = SAF.Cache.Cache.GetSAFCacheService();
        private WarehouseInventoryTableAdapter taWarehouseInventory = null;
        private DataSetPhysicalInventory dsPhysicalInventory = null;
        private WarehouseLocationsTableAdapter taWarehouseLocations = null;
        private PhysicalProgressTableAdapter taPhysicalProgress = null;
        private PhysicalProgressSummaryTableAdapter taPhysicalProgressSummary = null;
        private EmployeeTableAdapter taEmployee = null;
        private string BeginPhysicalAisle = null;
        private Int32 BeginPhysicalShelf = -1;
        private Int32 BeginPhysicalSubshelf = -1;

        public ChooseAddress()
        {
            InitializeComponent();
        }

        private void ChooseAddress_Load(object sender, EventArgs e)
        {
            uxCBAisle.SelectedIndex = 0;
            uxCBShelf.SelectedIndex = 0;
            uxCBSubshelf.SelectedIndex = 0;

            try
            {
                dsPhysicalInventory = new DataSetPhysicalInventory();
                cache.AddObject(CacheAddress.PhysicalInventoryData, dsPhysicalInventory);

                taWarehouseInventory = new WarehouseInventoryTableAdapter();
                taWarehouseLocations = new WarehouseLocationsTableAdapter();
                taPhysicalProgress = new PhysicalProgressTableAdapter();
                taPhysicalProgressSummary = new PhysicalProgressSummaryTableAdapter();
                taEmployee = new EmployeeTableAdapter();

                cache.AddObject(CacheAddress.WarehouseInventoryTableAdapter, taWarehouseInventory);
                cache.AddObject(CacheAddress.WarehouseLocationsTableAdapter, taWarehouseLocations);
                cache.AddObject(CacheAddress.PhysicalProgressTableAdapter, taPhysicalProgress);
                cache.AddObject(CacheAddress.PhysicalProgressSummaryTableAdapter, taPhysicalProgressSummary);
                cache.AddObject(CacheAddress.EmployeeTableAdapter, taEmployee);
                cache.AddObject(CacheAddress.BeginPhysicalAisle, BeginPhysicalAisle);
                cache.AddObject(CacheAddress.BeginPhysicalShelf, BeginPhysicalShelf);
                cache.AddObject(CacheAddress.BeginPhysicalSubshelf, BeginPhysicalSubshelf);
                taWarehouseLocations.Fill(dsPhysicalInventory.WarehouseLocations);       
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
        }

        private void menuItemClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void uxButtonBeginPhysical_Click(object sender, EventArgs e)
        {
            try
            {
                DataSetPhysicalInventory dsPhysicalInventory = (DataSetPhysicalInventory)cache.RetrieveObject(CacheAddress.PhysicalInventoryData);

                EmployeeTableAdapter taEmployee = (EmployeeTableAdapter)cache.RetrieveObject(CacheAddress.EmployeeTableAdapter);
                taEmployee.Fill(dsPhysicalInventory.Employee, uxTextBoxPassword.Text);
                string OperatorCode;
                Exception ex = null;
                switch (dsPhysicalInventory.Employee.Rows.Count)
                {
                    case 1:
                        OperatorCode = dsPhysicalInventory.Employee [0].OperatorCode;
                        break;
                    case 0:
                        ex = new Exception("Invalid password.");
                        uxTextBoxPassword.Focus();
                        throw ex;
                    default:
                        ex = new Exception("Unknown error validating password.");
                        uxTextBoxPassword.Focus();
                        throw ex;
                }

                PhysicalProgressTableAdapter taPhysicalProgressTableAdapter = (PhysicalProgressTableAdapter)cache.RetrieveObject(CacheAddress.PhysicalProgressTableAdapter);
                BeginPhysicalAisle = uxCBAisle.Text;
                BeginPhysicalShelf = Int32.Parse(uxCBShelf.Text);
                BeginPhysicalSubshelf = Int32.Parse(uxCBSubshelf.Text);
                
                //  Validate before continuing.
                string ValidationMessage = OperatorCode + " will initiate a cycle count on aisle " + BeginPhysicalAisle;
                if (BeginPhysicalShelf == 0) ValidationMessage += " all shelves and"; else ValidationMessage += " shelf " + BeginPhysicalShelf.ToString() + " and";
                if (BeginPhysicalSubshelf == 0) ValidationMessage += " all positions."; else ValidationMessage += " position " + BeginPhysicalSubshelf.ToString() + ".";
                if (MessageBox.Show(ValidationMessage, "Confirmation",
                    MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.Cancel)
                {
                    ex = new Exception("Operation cancelled.");
                    uxCBAisle.Focus();
                    throw ex;
                }
                cache.RemoveObject(CacheAddress.BeginPhysicalAisle);
                cache.RemoveObject(CacheAddress.BeginPhysicalShelf);
                cache.RemoveObject(CacheAddress.BeginPhysicalSubshelf);
                cache.AddObject(CacheAddress.BeginPhysicalAisle, BeginPhysicalAisle);
                cache.AddObject(CacheAddress.BeginPhysicalShelf, BeginPhysicalShelf);
                cache.AddObject(CacheAddress.BeginPhysicalSubshelf, BeginPhysicalSubshelf);

                //  Begin cycle count for specified address.
                Int32 Result;
                taPhysicalProgressTableAdapter.BeginPhysical_ByAddress(OperatorCode, BeginPhysicalAisle, BeginPhysicalShelf, BeginPhysicalSubshelf, out Result);
                taPhysicalProgressTableAdapter.Fill(dsPhysicalInventory.PhysicalProgress, BeginPhysicalAisle, BeginPhysicalShelf, BeginPhysicalSubshelf);
                cache.AddObject(CacheAddress.PhysicalInventoryData, dsPhysicalInventory);

                Application.Run(new frmScanToLocation());
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
            catch (Exception ex)
            {
                //  Getting exception when loading frmScanToLocation.
                //MessageBox.Show (ex.Message);
            }
        }

        private void uxButtonContinuePhysical_Click(object sender, EventArgs e)
        {
            try
            {
                DataSetPhysicalInventory dsPhysicalInventory = (DataSetPhysicalInventory)cache.RetrieveObject(CacheAddress.PhysicalInventoryData);

                EmployeeTableAdapter taEmployee = (EmployeeTableAdapter)cache.RetrieveObject(CacheAddress.EmployeeTableAdapter);
                taEmployee.Fill(dsPhysicalInventory.Employee, uxTextBoxPassword.Text);
                string OperatorCode;
                Exception ex = null;
                switch (dsPhysicalInventory.Employee.Rows.Count)
                {
                    case 1:
                        OperatorCode = dsPhysicalInventory.Employee[0].OperatorCode;
                        break;
                    case 0:
                        ex = new Exception("Invalid password.");
                        uxTextBoxPassword.Focus();
                        throw ex;
                    default:
                        ex = new Exception("Unknown error validating password.");
                        uxTextBoxPassword.Focus();
                        throw ex;
                }

                PhysicalProgressTableAdapter taPhysicalProgressTableAdapter = (PhysicalProgressTableAdapter)cache.RetrieveObject(CacheAddress.PhysicalProgressTableAdapter);
                BeginPhysicalAisle = uxCBAisle.Text;
                BeginPhysicalShelf = Int32.Parse(uxCBShelf.Text);
                BeginPhysicalSubshelf = Int32.Parse(uxCBSubshelf.Text);

                cache.RemoveObject(CacheAddress.BeginPhysicalAisle);
                cache.RemoveObject(CacheAddress.BeginPhysicalShelf);
                cache.RemoveObject(CacheAddress.BeginPhysicalSubshelf);
                cache.AddObject(CacheAddress.BeginPhysicalAisle, BeginPhysicalAisle);
                cache.AddObject(CacheAddress.BeginPhysicalShelf, BeginPhysicalShelf);
                cache.AddObject(CacheAddress.BeginPhysicalSubshelf, BeginPhysicalSubshelf);

                //  Continue cycle count for specified address.
                taPhysicalProgressTableAdapter.Fill(dsPhysicalInventory.PhysicalProgress, BeginPhysicalAisle, BeginPhysicalShelf, BeginPhysicalSubshelf);
                cache.AddObject(CacheAddress.PhysicalInventoryData, dsPhysicalInventory);

                Application.Run(new frmScanToLocation());
            }
            catch (SqlException ex)
            {
                foreach (SqlError SQLErr in ex.Errors) MessageBox.Show(SQLErr.Message);
            }
            catch (Exception ex)
            {
                //  Getting exception when loading frmScanToLocation.
                //MessageBox.Show (ex.Message);
            }
        }
    }
}