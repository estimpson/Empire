using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogData.Models;
using QuoteLogGrid.Controllers;
using DevExpress.XtraGrid.Views.Base;

namespace QuoteLogGrid.Forms
{
    public partial class formCSM : Form
    {
        private CSMController _csmController;

        private QuoteTypes _quoteType = new QuoteTypes();

        private ArrayList _unboundData = new ArrayList();
        private ArrayList _originalChecked = new ArrayList();


        #region North American Data

        public BindingList<CSM_Mnemonic> CsmMnemonicDataSource
        {
            set
            {
                gridControl1.DataSource = value;
            }
        }

        private IQueryable<QuoteCSM> _quoteCsmData;
        public IQueryable<QuoteCSM> QuoteCsmData
        {
            set
            {
                _quoteCsmData = value;
                CreateUnboundCheckboxColumn();
            }
        }

        #endregion


        #region Non-North American Data

        private IQueryable<QuoteManualProgramData> _nonNorthAmericanCsmData;
        public IQueryable<QuoteManualProgramData> NonNorthAmericanCsmData
        {
            set
            {
                _nonNorthAmericanCsmData = value;
                if (_nonNorthAmericanCsmData != null)
                {
                    PopulateNonNorthAmericanCsmData();
                    ExistsNonNorthAmericanMnemonic = true;
                }
                else
                {
                    ExistsNonNorthAmericanMnemonic = false;
                }
            }
        }

        private bool _existsNonNorthAmericanMnemonic;
        public bool ExistsNonNorthAmericanMnemonic
        {
            get { return _existsNonNorthAmericanMnemonic; }
            set
            {
                _existsNonNorthAmericanMnemonic = value;
                if (value)
                {
                    rbtnNonNorthAmericanMnemonic.Checked = true;
                    rbtnNorthAmericanMnemonic.Checked = false;
                }
                else
                {
                    rbtnNonNorthAmericanMnemonic.Checked = cbxDeleteMnemonic.Enabled = false;
                    rbtnNorthAmericanMnemonic.Checked = true;
                }
            }
        }

        #endregion



        #region Constructor

        public formCSM(string quoteNumber, QuoteTypes quoteType)
        {
            InitializeComponent();

            this.Text = "Quote Number: " + quoteNumber;
            lblMessage.Text = "";

            _quoteType = quoteType;
            _csmController = new CSMController(quoteNumber);

            // North American CSM data
            if (GetAllNorthAmericanCsmData() == 0) this.Close();
            if (GetNorthAmericanCsmDataForQuote() == 0) this.Close();

            // Non-North American CSM data
            if (GetNonNorthAmericanCsmData() == 0) this.Close();
        }

        #endregion


        #region North American

        private int GetAllNorthAmericanCsmData()
        {
            string errorMessage;

            // Get all North American CSM data
            CsmMnemonicDataSource = _csmController.GetNorthAmericanCsmData(out errorMessage);
            if (errorMessage != "")
            {
                MessageBox.Show(errorMessage, "GetNorthAmericanCsmData()");
                return 0;
            }
            return 1;
        }

        private int GetNorthAmericanCsmDataForQuote()
        {
            string errorMessage;

            // Get North American CSM data tied to this particular quote, which will be displayed as checked checkboxes
            QuoteCsmData = _csmController.GetNorthAmericanCsmDataforQuote(out errorMessage);
            if (errorMessage != "")
            {
                MessageBox.Show(errorMessage, "GetNorthAmericanCsmDataForQuote()");
                return 0;
            }
            return 1;
        }

        public void CreateUnboundCheckboxColumn()
        {
            string mnemonic;
            string mnemonicVehiclePlant;

            // Disable editing of visible columns
            foreach (var c in gridView1.Columns)
            {
                ((DevExpress.XtraGrid.Columns.GridColumn)c).OptionsColumn.AllowEdit = false;
            }

            // Create an arraylist of unbound checkboxes, setting them all to false    
            _unboundData.Clear();
            for (int i = 0; i <= gridView1.RowCount; i++)
            {
                _unboundData.Add(false);
            }

            // Create unbound checkbox column
            gridView1.BeginUpdate();
            DevExpress.XtraGrid.Columns.GridColumn ColumnCheck = gridView1.Columns.AddField("chkEditColumn");
            DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit RepositoryCheck = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            ColumnCheck.ColumnEdit = RepositoryCheck;
            ColumnCheck.Name = "chkEditColumn";
            ColumnCheck.UnboundType = DevExpress.Data.UnboundColumnType.Boolean;
            ColumnCheck.VisibleIndex = 0;
            ColumnCheck.OptionsColumn.ShowCaption = false;
            gridView1.CustomUnboundColumnData += gridView1_CustomUnboundColumnData;
            gridView1.EndUpdate();

            if (_quoteType != QuoteTypes.New && _quoteCsmData != null)
            {
                foreach (var item in _quoteCsmData)
                {
                    mnemonic = item.CSM_Mnemonic;
                    for (int i = 0; i < gridView1.RowCount; i++)
                    {
                        mnemonicVehiclePlant = gridView1.GetRowCellValue(i, "Mnemonic_Vehicle_Plant").ToString();
                        if (mnemonicVehiclePlant == mnemonic)
                        {
                            gridView1.SetRowCellValue(i, "chkEditColumn", true);
                        }
                    }
                }
            }
            // Get a list of CSM Mnemonics that were originally tied to this Quote
            _originalChecked.AddRange(_unboundData);
        }

        private void gridView1_CustomUnboundColumnData(object sender, CustomColumnDataEventArgs e)
        {
            if (e.Column.FieldName != "chkEditColumn") return;
            if (e.IsGetData) // Raised when grid is loaded (all checkboxes are initially set to false)
            {
                e.Value = _unboundData[e.ListSourceRowIndex];
            }
            else if (e.IsSetData) // Raised when column data is modified
            {
                _unboundData[e.ListSourceRowIndex] = e.Value;
            }
        }

        public void SetFormStateNorthAmericanCsm()
        {
            pnlNorthAmericanMnemonic.Enabled = true;
            pnlNonNorthAmericanMnemonic.Enabled = false;

            lblMessage.Text = (_existsNonNorthAmericanMnemonic) ?
                "Note:  If you save CSM Mnemonics, the Non-NorthAmerican Mnemonic will be deleted." : "";
        }

        #endregion



        #region Non-North American

        private int GetNonNorthAmericanCsmData()
        {
            string errorMessage;

            if (_quoteType == QuoteTypes.New)
            {
                ExistsNonNorthAmericanMnemonic = false;
                return 1;
            }
            
            NonNorthAmericanCsmData = _csmController.GetNonNorthAmericanCMSData(out errorMessage);
            if (errorMessage != "")
            {
                MessageBox.Show(errorMessage, "GetNonNorthAmericanCsmData()");
                return 0;
            }
            return 1;
        }

        private void PopulateNonNorthAmericanCsmData()
        {
            foreach (var item in _nonNorthAmericanCsmData)
            {
                tbxManufacturer.Text = item.Manufacturer;
                tbxPlatform.Text = item.Platform;
                tbxProgram.Text = item.Program;
                tbxNameplate.Text = item.Nameplate;
            }
        }

        public void SetFormStateNonNorthAmericanCsm()
        {
            pnlNonNorthAmericanMnemonic.Enabled = true;
            pnlNorthAmericanMnemonic.Enabled = false;
            lblMessage.Text = "";
            cbxDeleteMnemonic.Visible = true;
        }

        #endregion



        #region Control Events

        private void rbtnNonNorthAmericanMnemonic_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnNonNorthAmericanMnemonic.Checked) SetFormStateNonNorthAmericanCsm();
        }

        private void rbtnNorthAmericanMnemonic_CheckedChanged(object sender, EventArgs e)
        {
            if (rbtnNorthAmericanMnemonic.Checked) SetFormStateNorthAmericanCsm();
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            SaveCSM();
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        #endregion



        #region Save Methods

        private void SaveCSM()
        {
            if (rbtnNonNorthAmericanMnemonic.Checked)
            {
                if (cbxDeleteMnemonic.Checked)
                {
                    DeleteNonNorthAmericanCsm();
                }
                else
                {
                    SaveNonNorthAmericanCsm();
                }
                return;
            }

            if (rbtnNorthAmericanMnemonic.Checked)
            {
                if (_existsNonNorthAmericanMnemonic)
                {
                    SaveNorthAmericanCSM();
                    DeleteNonNorthAmericanCsm();
                }
                else
                {
                    SaveNorthAmericanCSM();
                }
            }
        }

        private void SaveNorthAmericanCSM()
        {
            string errorMessage;
            string mnemonicVehiclePlant = "";
            string releaseId = "";
            string version = "";

            // Save changes made to CMS grid
            for (int i = 0; i < _unboundData.Count; i++)
            {
                bool isChecked = (bool)_unboundData[i];
                if (isChecked)
                {
                    if ((bool)_originalChecked[i] == false)
                    {
                        // Mnemonic was not originally tied to this quote; user checked it, so save
                        mnemonicVehiclePlant = gridView1.GetRowCellValue(i, "Mnemonic_Vehicle_Plant").ToString();
                        releaseId = gridView1.GetRowCellValue(i, "Release_ID").ToString();
                        version = gridView1.GetRowCellValue(i, "Version").ToString();

                        _csmController.SaveMnemonics(mnemonicVehiclePlant, releaseId, version, out errorMessage);
                        if (errorMessage != "") MessageBox.Show(errorMessage, "SaveMnemonics()");
                    }
                }
                else
                {
                    if ((bool)_originalChecked[i] == true)
                    {
                        // Mnemonic was originally tied to this quote; user un-checked it, so delete
                        mnemonicVehiclePlant = gridView1.GetRowCellValue(i, "Mnemonic_Vehicle_Plant").ToString();
                       
                        _csmController.DeleteMnemonics(mnemonicVehiclePlant, out errorMessage);
                        if (errorMessage != "") MessageBox.Show(errorMessage, "DeleteMnemonics()");
                    }
                }
            }
        }

        private void SaveNonNorthAmericanCsm()
        {
            string errorMessage;
            string manufacturer = tbxManufacturer.Text.Trim();
            string platform = tbxPlatform.Text.Trim();
            string program = tbxProgram.Text.Trim();
            string nameplate = tbxNameplate.Text.Trim();

            _csmController.SaveNonNorthAmericanCSM(manufacturer, platform, program, nameplate, out errorMessage);
            if (errorMessage != "") MessageBox.Show(errorMessage, "SaveNonNorthAmericanCSM()");
        }

        public void DeleteNonNorthAmericanCsm()
        {
            string errorMessage;
            _csmController.DeleteNonNorthAmericanCsm(out errorMessage);
            if (errorMessage != "") MessageBox.Show(errorMessage, "DeleteNonNorthAmericanCSM()");
        }

        #endregion


    }
}
