using System;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using ImportCSM.Controls;
using ImportCSM.DataAccess;

namespace ImportCSM
{
    public partial class formMain : Form
    {
        #region Class Objects

        private readonly CustomMessageBox _messageBox;
        private readonly ProcessData _processData;

        #endregion


        #region Constructor, Load Event

        public formMain()
        {
            InitializeComponent();

            _processData = new ProcessData();
            _messageBox = new CustomMessageBox();
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
            ControlScreenState(ProgressStates.Open);
        }

        #endregion


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            int thickness = 1;
            int halfThickness = thickness / 2;
            //using (var p = new Pen(Color.FromArgb(0, 122, 204), thickness))
            using (var p = new Pen(Color.White, thickness))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
                                                          halfThickness,
                                                          panel1.ClientSize.Width - thickness,
                                                          panel1.ClientSize.Height - thickness));
            }
        }

        #endregion


        #region TabControl Events

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab == tabControl1.TabPages["tpCsm"])
            {
                tbxPriorReleaseId.Text = tbxCurrentReleaseId.Text = "";
                tbxPriorReleaseId.Focus();
            }
            else
            {
                tbxCurrentDeltaReleaseId.Text = "";
                tbxCurrentDeltaReleaseId.Focus();
            }
        }

        #endregion


        #region Button Events

        private void btnImport_Click(object sender, EventArgs e)
        {
            ProcessCsm();
        }

        private void btnDeltaImport_Click(object sender, EventArgs e)
        {
            ProcessCsmDelta();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Close();
        }

        #endregion


        #region CSM Methods

        private void ProcessCsm()
        {
            string priorRelease = tbxPriorReleaseId.Text.Trim();
            string currentRelease = tbxCurrentReleaseId.Text.Trim();
            if (priorRelease == "")
            {
                _messageBox.Message = "Enter a prior release.";
                _messageBox.ShowDialog();
                return;
            }
            if (currentRelease == "")
            {
                _messageBox.Message = "Enter a current release.";
                _messageBox.ShowDialog();
                return;
            }

            // Create a temp table and insert the raw data into it
            ControlScreenState(ProgressStates.CreateTableInsertRows);
            if (ImportRawData() == 0)
            {
                ControlScreenState(ProgressStates.ImportFailed);
                return;
            }

            // Roll old CSM data forward
            ControlScreenState(ProgressStates.RollCsmForward);
            if (RollCSMForward(priorRelease, currentRelease) == 0)
            {
                ControlScreenState(ProgressStates.ImportFailed);
                return;
            }

            // Import new CSM data
            ControlScreenState(ProgressStates.ImportCsm);
            if (ImportCsm(currentRelease) == 0)
            {
                ControlScreenState(ProgressStates.ImportFailed);
                return;
            }

            // Clean up the database
            RemoveTempTable();

            // Reset screen
            ControlScreenState(ProgressStates.ImportComplete);
        }

        private int ImportRawData()
        {
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the CSV
                var dataObject = Clipboard.GetDataObject();
                var stream = (System.IO.Stream)dataObject.GetData(format);
                if (stream == null)
                {
                    _messageBox.Message = "Please copy spreadsheet data.";
                    _messageBox.ShowDialog();
                    return 0;
                }
                var encoding = new System.Text.UTF8Encoding();
                var reader = new System.IO.StreamReader(stream, encoding);
                string data = reader.ReadToEnd();

                var rows = data.Split('\r');

                // Loop through spreadsheet rows
                bool columnsCaptured = false;
                foreach (var rowRaw in rows)
                {
                    string rowData = "";

                    var row = rowRaw.Replace("\n", "");
                    //if (row == "\0") break;
                    if (row == "") break;

                    // Skip over header data
                    string[] arry = row.Split(',');
                    if (arry.Count() < 29) continue;

                    if (!columnsCaptured)
                    {
                        string columnNames = "";
                        foreach (var item in arry) columnNames += ("[" + item + "]" + " varchar(100),");

                        // End of string correction
                        int stringLength = columnNames.Length;
                        columnNames = columnNames.Remove(stringLength - 1, 1);

                        // Create a table that will be deleted later
                        int result = CreateTable(columnNames);
                        if (result == 0) return 0;

                        columnsCaptured = true;
                    }
                    else
                    {
                        foreach (var item in arry) rowData += (item + ",");

                        // Place quotes around each field
                        string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

                        // End of string correction
                        int stringLength = rowDataFormatted.Length;
                        rowDataFormatted = rowDataFormatted.Remove(stringLength - 3, 3);

                        // Insert a row of data into the table
                        int result = InsertDataRow(rowDataFormatted);
                        if (result == 0) return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messageBox.Message = "Import failed.  Exception thwrown at ImportRawData().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int CreateTable(string columns)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("IF EXISTS (" +
                                             "SELECT 1 " +
                                             "FROM sys.tables " +
                                             "WHERE name LIKE 'tempCSM') " +
                                             "DROP TABLE tempCSM CREATE TABLE tempCSM(" +
                                             columns + ");",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at CreateTable().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            finally
            {
                con.Close();
                con.Dispose(); 
            }
            return 1;
        }

        private int InsertDataRow(string values)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("IF EXISTS (" +
                                             "SELECT 1 " +
                                             "FROM sys.tables " +
                                             "WHERE name LIKE 'tempCSM') " +
                                             "INSERT INTO tempCSM " +
                                             "VALUES (" +
                                             values + ");",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at InsertDataRow().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
            return 1;
        }

        private int RollCSMForward(string priorRelease, string currentRelease)
        {
            string error;
            _processData.RollCsmForward(priorRelease, currentRelease, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed.  Error thrown at RollCSMForward().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int ImportCsm(string currentRelease)
        {
            string error;
            _processData.Import(currentRelease, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed.  Error thrown at ImportCsm().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private void RemoveTempTable()
        {
            var con =
               new SqlConnection(
                   "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("IF EXISTS (" +
                                             "SELECT 1 " +
                                             "FROM sys.tables " +
                                             "WHERE name LIKE 'tempCSM') " +
                                             "DROP TABLE tempCSM;",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception)
            {
                // Do nothing
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        #endregion


        #region CSM Delta Methods

        private void ProcessCsmDelta()
        {
            string release = tbxCurrentDeltaReleaseId.Text.Trim();
            string version = "CSM";
            if (release == "")
            {
                _messageBox.Message = "Enter a current release.";
                _messageBox.ShowDialog();
                return;
            }

            // Import new CSM Delta data
            if (ImportCsmDelta(release, version) == 0) return;

            // Reset screen
            ControlScreenState(ProgressStates.ImportDeltaCsmComplete);
        }

        private int ImportCsmDelta(string release, string version)
        {
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the CSV
                var dataObject = Clipboard.GetDataObject();
                var stream = (System.IO.Stream)dataObject.GetData(format);
                if (stream == null)
                {
                    _messageBox.Message = "Please copy spreadsheet data.";
                    _messageBox.ShowDialog();
                    return 0;
                }
                var encoding = new System.Text.UTF8Encoding();
                var reader = new System.IO.StreamReader(stream, encoding);
                string data = reader.ReadToEnd();

                var rows = data.Split('\r');

                 // Loop through spreadsheet rows
                foreach (var rowRaw in rows)
                {
                    string guidStr = Guid.NewGuid().ToString();

                    string rowData = guidStr + "," + release + "," + version + ",";

                    var row = rowRaw.Replace("\n", "");
                    //if (row == "\0") break;
                    if (row == "") break;


                    string[] quotesSplit = row.Split('"');
                    if (quotesSplit.Count() > 1)
                    {
                        string otherFields = quotesSplit[0];
                        string notes = quotesSplit[1].Replace("\"", "");
                        notes = notes.Replace("'", "''");

                        // Skip the header row
                        string[] arry = otherFields.Split(',');
                        if (arry.Count() < 13) continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        foreach (var item in arry) rowData += (item + ",");

                        // Place quotes around each field
                        string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

                        // End of string correction
                        int stringLength = rowDataFormatted.Length;
                        rowDataFormatted = rowDataFormatted.Remove(stringLength -4, 4);
                        //MessageBox.Show("Formatted remove:  " + rowDataFormatted);

                        rowDataFormatted += notes;
                        rowDataFormatted += "'";

                        //MessageBox.Show("Formatted with notes:  " + rowDataFormatted);

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(rowDataFormatted);
                        if (result == 0) return 0;
                    }
                    else
                    {
                        // Skip the header row
                        string[] arry = row.Split(',');
                        if (arry.Count() < 13) continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        foreach (var item in arry) rowData += (item + ",");

                        // Place quotes around each field
                        string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

                        // End of string correction
                        int stringLength = rowDataFormatted.Length;
                        rowDataFormatted = rowDataFormatted.Remove(stringLength - 3, 3);

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(rowDataFormatted);
                        if (result == 0) return 0;   
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messageBox.Message = "Import failed.  Exception thrown at ImportCsmDelta().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int InsertCsmDeltaDataRow(string values)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("INSERT INTO EEIUser.acctg_csm_NAIHS_Delta " +
                                             "VALUES (" +
                                             values + ");",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at InsertCsmDeltaDataRow().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
            return 1;
        }

        #endregion


        #region Other Methods

        private void ControlScreenState(ProgressStates progressState)
        {
            switch (progressState)
            {
                case ProgressStates.Open:
                    tbxPriorReleaseId.Focus();
                    break;
                case ProgressStates.CreateTableInsertRows:
                    pnlImport.Enabled = btnExit.Enabled = false;
                    lblStep1.ForeColor = Color.White;
                    lblStep2.ForeColor = lblStep3.ForeColor = lblStep4.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
                case ProgressStates.RollCsmForward:
                    lblStep1.ForeColor = ColorTranslator.FromHtml("#333333");
                    lblStep2.ForeColor = Color.White;
                    lblStep3.ForeColor = ColorTranslator.FromHtml("#333333");
                    lblStep4.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
                case ProgressStates.ImportCsm:
                    lblStep1.ForeColor = ColorTranslator.FromHtml("#333333");
                    lblStep2.ForeColor = ColorTranslator.FromHtml("#333333");
                    lblStep3.ForeColor = Color.White;
                    lblStep4.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
                case ProgressStates.ImportComplete:
                    pnlImport.Enabled = btnExit.Enabled = true;
                    tbxPriorReleaseId.Text = tbxCurrentReleaseId.Text = "";

                    lblStep1.ForeColor = lblStep2.ForeColor = lblStep3.ForeColor = ColorTranslator.FromHtml("#333333");
                    lblStep4.ForeColor = Color.White;
                    break;
                case ProgressStates.ImportFailed:
                    pnlImport.Enabled = btnExit.Enabled = true;

                    lblStep1.ForeColor = lblStep2.ForeColor = lblStep3.ForeColor = lblStep4.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
                case ProgressStates.ImportDeltaCsm:
                    pnlDeltaImport.Enabled = btnExit.Enabled = false;
                    lblDeltaImportComplete.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
                case ProgressStates.ImportDeltaCsmComplete:
                    pnlDeltaImport.Enabled = btnExit.Enabled = true;
                    tbxCurrentDeltaReleaseId.Text = "";
                    lblDeltaImportComplete.ForeColor = Color.White;
                    break;
                case ProgressStates.ImportDeltaCsmFailed:
                    pnlDeltaImport.Enabled = btnExit.Enabled = true;
                    lblDeltaImportComplete.ForeColor = ColorTranslator.FromHtml("#333333");
                    break;
            }
        }

        #endregion


    }
}
