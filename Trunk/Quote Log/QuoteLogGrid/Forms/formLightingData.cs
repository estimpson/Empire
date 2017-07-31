using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Windows.Forms;
using QuoteLogData.Models;


namespace QuoteLogGrid.Forms
{
    public partial class formLightingData : Form
    {
        #region Class Objects

        private readonly QuoteLogContext _context;

        private readonly List<string> _applicationsList = new List<string>(); 
        private readonly List<string> _programsList = new List<string>();
        private readonly List<string> _ledHarnessList = new List<string>();
        private readonly List<string> _sopsList = new List<string>();

        #endregion


        #region Properties

        public string QuoteNumber { get; set; }
        public string LightingStudyId { get; private set; }
        public string Application { get; private set; }
        public string Program { get; private set; }
        public string LedHarness { get; private set; }
        public string Sop { get; private set; }

        #endregion


        #region Variables

        private bool _isDatabinding;

        #endregion


        #region Constructor

        public formLightingData()
        {
            InitializeComponent();

            _context = new QuoteLogContext();
        }

        #endregion


        #region Form Load Event

        private void formLightingData_Load(object sender, EventArgs e)
        {
            // Create ListView columns
            lvwLightingData.Columns.Add("Quote Number", 100);
            lvwLightingData.Columns.Add("Application", 180);
            lvwLightingData.Columns.Add("Program", 100);
            lvwLightingData.Columns.Add("LED/Harness", 90);
            lvwLightingData.Columns.Add("SOP", 140);
            lvwLightingData.Columns.Add("Lighting ID", 80);
            lvwLightingData.Columns.Add("RowID", 80);

            // Initialize variables
            Application = Program = LedHarness = Sop = LightingStudyId = "";

            // Search for previously saved Lighting Study data for this quote, and display if exists.  Populate dropdown lists.
            RefreshForm();
        }

        #endregion


        #region ComboBox Events

        private void ddlApplication_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDatabinding) return;

            Application = ddlApplication.Text.Trim();
            if (Application == "")
            {
                ddlProgram.Text = "";
                ddlProgram.DataSource = null;
                return;
            }
            PopulateProgramsDropDownList();
        }

        private void ddlPrograms_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDatabinding) return;

            Program = ddlProgram.Text.Trim();
            if (Program == "")
            {
                ddlLedHarness.Text = "";
                ddlLedHarness.DataSource = null;
                return;
            }
            PopulateLedHarnessDropDownList();
        }

        private void ddlLedHarness_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDatabinding) return;

            LedHarness = ddlLedHarness.Text.Trim();
            if (LedHarness == "")
            {
                ddlSop.Text = "";
                ddlSop.DataSource = null;
                return;
            }
            PopulateSopsDropDownList();
        }

        private void ddlSop_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDatabinding) return;

            Sop = ddlSop.Text.Trim();
            if (Sop == "") LightingStudyId = "";
        }

        #endregion


        #region Button Events

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            RefreshForm();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (Application == "")
            {
                MessageBox.Show("Application is required.", "Message");
                return;
            }

            if (Program != "")
            {
                if (LedHarness == "")
                {
                    MessageBox.Show("LED / Harness is required.", "Message");
                    return;
                }
                if (Sop == "")
                {
                    MessageBox.Show("SOP is required.", "Message");    
                    return;
                }

                // Get Lighting Study ID
                string lightingStudyId;
                var result = ValidateData(out lightingStudyId);
                if (result == 0) return;  // Either the data has already been saved for this quote, or the validate procedure failed
                LightingStudyId = lightingStudyId;
            }

            SaveData();

            RefreshForm();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            if (lvwLightingData.Items.Count < 1 || lvwLightingData.SelectedItems.Count < 1) return;

            if (DeleteData() == 1) RefreshForm();
        }

        private void btnDone_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


        #region Methods

        private void PopulateApplicationsDropDownList()
        {
            _isDatabinding = true;
            GetAppplications();
            _isDatabinding = false;
        }

        private void PopulateProgramsDropDownList()
        {
            _isDatabinding = true;
            GetPrograms();
            ddlProgram.Text = "";
            _isDatabinding = false;
        }
        
        private void PopulateLedHarnessDropDownList()
        {
            _isDatabinding = true;
            GetLedHarness();
            ddlLedHarness.Text = "";
            _isDatabinding = false;
        }

        private void PopulateSopsDropDownList()
        {
            _isDatabinding = true;
            GetSops();
            ddlSop.Text = "";
            _isDatabinding = false;
        }

        private void GetAppplications()
        {
            _applicationsList.Clear();
            ddlApplication.DataSource = null;

            try
            {
                var query = (from a in _context.usp_QT_LightingStudy_GetApplications().ToList()
                             select a);

                if (!query.Any()) return;

                _applicationsList.Add("");
                foreach (var item in query)
                {
                    _applicationsList.Add(item.Application);
                }
                ddlApplication.DataSource = _applicationsList;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failed to return Applications.  Try refreshing.  {0}", error), "Error at GetApplications()");
            }
        }

        private void GetPrograms()
        {
            _programsList.Clear();
            ddlProgram.DataSource = null;

            try
            {
                var query = _context.usp_QT_LightingStudy_GetPrograms(Application).ToList();
                if (!query.Any()) return;

                _programsList.Add("");
                foreach (usp_QT_LightingStudy_GetPrograms_Result item in query) _programsList.Add(item.Program);
                ddlProgram.DataSource = _programsList;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failed to return Lighting Programs.  Try refreshing.  {0}", error), "Error at GetProgramNumbers()");
            }
        }

        private void GetLedHarness()
        {
            _ledHarnessList.Clear();
            ddlLedHarness.DataSource = null;

            try
            {
                var query = (from ls in _context.usp_QT_LightingStudy_GetLEDHarness(Application, Program).ToList()
                             select ls);

                if (!query.Any()) return;

                _ledHarnessList.Add("");
                foreach (var item in query)
                {
                    _ledHarnessList.Add(item.LED_Harness);
                }
                ddlLedHarness.DataSource = _ledHarnessList;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failed to return LED/Harness data.  Try refreshing.  {0}", error), "Error at GetLedHarness()");
            }
        }

        private void GetSops()
        {
            _sopsList.Clear();
            ddlSop.DataSource = null;

            try
            {
                var query = (from ls in _context.usp_QT_LightingStudy_GetSOPs(Application, Program, LedHarness).ToList()
                             select ls);

                if (!query.Any()) return;

                _sopsList.Add("");
                foreach (var item in query) _sopsList.Add(item.SOP);
                ddlSop.DataSource = _sopsList;
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failed to return Lighting SOPs.  Try refreshing.  {0}", error), "Error at GetSops()");
            }
        }

        private void GetDataForQuote()
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(int));

            lvwLightingData.Items.Clear();
            try
            {
                var query = _context.usp_QT_LightingStudy_QuoteNumbers_GetQuoteData(QuoteNumber, dt, res).ToList();
                if (!query.Any()) return;

                foreach (usp_QT_LightingStudy_QuoteNumbers_GetQuoteData_Result item in query)
                {
                    // Add to listview
                    var lvi = new ListViewItem(QuoteNumber);
                    lvi.SubItems.Add(item.Application);
                    lvi.SubItems.Add(item.Program);
                    lvi.SubItems.Add(item.LEDHarness);
                    lvi.SubItems.Add(item.Sop.ToString());
                    lvi.SubItems.Add(item.LightingStudyId.ToString());
                    lvi.SubItems.Add(item.RowID.ToString());

                    lvwLightingData.Items.Add(lvi);
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failure when attempting to find lighting data for this quote.  Try refreshing.  {0}", error), "Error at GetDataForQuote()");
            }
        }

        private int ValidateData(out string id)
        {
            id = "";
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(int));
            var dtSop = Convert.ToDateTime(Sop);

            try
            {
                var query = _context.usp_QT_LightingStudy_QuoteNumbers_Validate(QuoteNumber, Application, Program, LedHarness, dtSop, dt, res).ToList();

                foreach (usp_QT_LightingStudy_QuoteNumbers_Validate_Result item in query) id = item.ID.ToString();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(error, "Error at ValidateData()");
                return 0;
            }
            return 1;
        }

        private void SaveData()
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(int));

            int? iLightingStudyId = null;
            if (LightingStudyId != "") iLightingStudyId = Convert.ToInt32(LightingStudyId);

            int? rowId = null;

            DateTime? dtSop = (Sop != "") ? Convert.ToDateTime(Sop) : DateTime.Now;

            try
            {
                _context.usp_QT_LightingStudy_QuoteNumbers_Update(QuoteNumber, Application, iLightingStudyId, Program, LedHarness, dtSop, rowId, dt, res);
            }
            catch (Exception ex)
            {
                string exceptionMsg = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                string error = (Program != "")
                        ? string.Format("Failed to save quote to lighting application {0}, program {1}, led/harness, {2} sop {3}.  ", Application, Program, LedHarness, Sop)
                        : string.Format("Failed to save quote to lighting application {0}.  ", Application);

                MessageBox.Show(error + exceptionMsg, "Error at SaveData()");
            }
        }

        private int DeleteData()
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(int));

            string rowId = lvwLightingData.SelectedItems[0].SubItems[6].Text;
            int? iRowId = Convert.ToInt32(rowId);
            int? iLightingStudyId = null;
            DateTime? dtSop = DateTime.Now;

            try
            {
                _context.usp_QT_LightingStudy_QuoteNumbers_Update(QuoteNumber, Application, iLightingStudyId, Program, LedHarness, dtSop, iRowId, dt, res);
            }
            catch (Exception ex)
            {
                string exceptionMsg = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(string.Format("Failed to delete lighting study data from quote.  {0}", exceptionMsg), "Error at DeleteData()");
                return 0;
            }
            return 1;
        }

        private void RefreshForm()
        {
            ddlApplication.Text = ""; // Clears all variables

            PopulateApplicationsDropDownList();

            GetDataForQuote();
        }

        #endregion


    }
}
