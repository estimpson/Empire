#region Using

using System;
using System.Data.SqlClient;
using System.Windows.Forms;
using PhysicalInventoryData.dsPhysicalInventoryTableAdapters;

#endregion

namespace PhysicalInventory
{
    public partial class ChooseAddressView : Form
    {
        private string _plant;
        private string _operatorCode;
        private string _rack;
        private string _shelf;
        private string _position;

        public ChooseAddressView()
        {
            InitializeComponent();
        }

        private void ChooseAddressViewLoad(object sender, EventArgs e)
        {
            try
            {
                _plant = RFGlobals.GetInstance().Plant;

                using (var racksDT = new RackListTableAdapter().GetRackList(_plant))
                {
                    RackSelection.DataSource = racksDT;
                    RackSelection.DisplayMember = "Rack";
                }
                using (var shelvesDT = new ShelfListTableAdapter().GetShelfList(_plant))
                {
                    ShelfSelection.DataSource = shelvesDT;
                    ShelfSelection.DisplayMember = "Shelf";
                }
                using (var positionsDT = new PositionListTableAdapter().GetPositionList(_plant))
                {
                    PositionSelection.DataSource = positionsDT;
                    PositionSelection.DisplayMember = "Position";
                }
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void MenuItemCloseClick(object sender, EventArgs e)
        {
            Close();
        }

        private void UxButtonBeginPhysicalClick(object sender, EventArgs e)
        {
            try
            {
                using (var taEmployee = new EmployeeTableAdapter())
                {
                    var employeeDT = taEmployee.GetOperatorCodeByPassword(uxTextBoxPassword.Text);
                    switch (employeeDT.Rows.Count)
                    {
                        case 1:
                            _operatorCode = employeeDT[0].OperatorCode;
                            break;
                        case 0:
                            uxTextBoxPassword.Focus();
                            throw new Exception("Invalid password.");
                        default:
                            uxTextBoxPassword.Focus();
                            throw new Exception("Unknown error validating password.");
                    }
                }

                using (var taPhysicalProgressTableAdapter = new PhysicalProgressTableAdapter())
                {
                    _rack = RackSelection.Text;
                    _shelf = ShelfSelection.Text;
                    _position = PositionSelection.Text;

                    //  Validate before continuing.
                    string validationMessage = _operatorCode + " will initiate a cycle count on aisle " + _rack;
                    if (string.IsNullOrEmpty(_shelf)) validationMessage += " all shelves and";
                    else validationMessage += string.Format(" shelf {0} and", _shelf);
                    if (string.IsNullOrEmpty(_position)) validationMessage += " all positions.";
                    else validationMessage += string.Format(" position {0}.", _position);
                    if (MessageBox.Show(validationMessage, "Confirmation",
                        MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) ==
                        DialogResult.Cancel)
                    {   
                        RackSelection.Focus();
                        throw new Exception("Operation cancelled.");
                    }

                    //  Begin cycle count for specified address.
                    DateTime? tranDT = null;
                    Int32? result = null;
                    taPhysicalProgressTableAdapter.BeginPhysical(_operatorCode, _plant, _rack, _shelf, _position, ref tranDT, ref result);
                }

                var scanningView = new ScanToLocationView
                {
                    Plant = _plant,
                    OperatorCode = _operatorCode,
                    BeginPhysicalRack = _rack,
                    BeginPhysicalShelf = _shelf,
                    BeginPhysicalPosition = _position
                };
                scanningView.Show();
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void UxButtonContinuePhysicalClick(object sender, EventArgs e)
        {
            try
            {
                using (var taEmployee = new EmployeeTableAdapter())
                {
                    var employeeDT = taEmployee.GetOperatorCodeByPassword(uxTextBoxPassword.Text);
                    switch (employeeDT.Rows.Count)
                    {
                        case 1:
                            _operatorCode = employeeDT[0].OperatorCode;
                            break;
                        case 0:
                            uxTextBoxPassword.Focus();
                            throw new Exception("Invalid password.");
                        default:
                            uxTextBoxPassword.Focus();
                            throw new Exception("Unknown error validating password.");
                    }
                }

                _rack = RackSelection.Text;
                _shelf = ShelfSelection.Text;
                _position = PositionSelection.Text;

                var scanningView = new ScanToLocationView
                {
                    Plant = _plant,
                    OperatorCode = _operatorCode,
                    BeginPhysicalRack = _rack,
                    BeginPhysicalShelf = _shelf,
                    BeginPhysicalPosition = _position
                };
                scanningView.Show();
            }
            catch (SqlException ex)
            {
                foreach (SqlError sqlErr in ex.Errors) MessageBox.Show(sqlErr.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}