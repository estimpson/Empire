using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using ImportCSM.Controls;
using ImportCSM.DataAccess;
using Microsoft.VisualBasic.FileIO;
using System.Collections.Generic;

namespace ImportCSM
{
    public partial class formMain : Form
    {
        #region Class Objects

        private readonly CustomMessageBox _messageBox;
        private readonly ProcessData _processData;

        private readonly CsmNaGc _csmNaGc;

        #endregion


        #region Constructor, Load Event

        public formMain()
        {
            InitializeComponent();

            _processData = new ProcessData();
            _messageBox = new CustomMessageBox();

            _csmNaGc = new CsmNaGc("ASB");

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            SetInitialCsmForm();
            SetReleaseIDs();
            SetInitialOfficialForecastForm();

            //tbxPriorReleaseId.Focus();
            tabControl1.TabPages.Remove(tpCsm);
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
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
        }

        #endregion


        #region LinkLabel Events

        private void linkLblClose_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Close();
        }

        private void linkLblClose_MouseEnter(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = Color.Red;
        }

        private void linkLblClose_MouseLeave(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }

        #endregion


        #region Button MouseDown Events

        private void btnRollForward_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnImport_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnImportGreaterChina_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnDeltaImport_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnInsertForecast_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnInsertHistoricalSales_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void btnMidModel_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        #endregion


        #region Button Click Events

        private void btnRollForward_Click(object sender, EventArgs e)
        {
            string priorRelease = tbxPriorReleaseId.Text.Trim();
            string currentRelease = tbxCurrentReleaseId.Text.Trim();

            if (priorRelease == "")
            {
                _messageBox.Message = "Please enter a prior release.";
                _messageBox.ShowDialog();
                return;
            }
            if (currentRelease == "")
            {
                _messageBox.Message = "Please enter a current release.";
                _messageBox.ShowDialog();
                return;
            }

            // Roll old CSM data forward one month
            if (RollCSMForward(priorRelease, currentRelease) == 1) ControlScreenState(ClearTabs.RollForwardClear);
            Cursor.Current = Cursors.Default;
        }

        private void btnImport_Click(object sender, EventArgs e)
        {
            if (ProcessCsm() == 1)
            {
                _messageBox.Message = "Successful import of North America CSM.  Ready for Greater China CSM import.";
                _messageBox.ShowDialog();
                ControlScreenState(ClearTabs.ImportCsmClear);
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnImportGreaterChina_Click(object sender, EventArgs e)
        {
            int status = 0;
            // Import Greater China CSM
            if (ProcessCsmGreaterChina() == 1)
            {
                status = 1;
                _messageBox.Message = "Successful import of Greater China CSM.  Click OK to insert Official Sales Forecast, then wait for the next message.";
                _messageBox.ShowDialog();

                // Insert Official Sales Forecast
                string forecastName = DateTime.Now.ToString("yyyy/MM/dd") + " OSF";
                if (InsertOfficialForecast(forecastName) == 1)
                {
                    status = 2;
                    _messageBox.Message = "Successful Sales Forecast insert.";
                    _messageBox.ShowDialog();
                }                
            }

            if (status == 1)
            {
                ControlScreenState(ClearTabs.ImportCsmGreaterChinaClear);
            }
            else if (status == 2)
            {
                ControlScreenState(ClearTabs.ImportCsmGreaterChinaAndForecastClear);
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnDeltaImport_Click(object sender, EventArgs e)
        {
            //if (LocateFile() == 0) return;
            //if (ValidateReleaseId() == 0) return;

            if (ProcessCsmDelta() == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();

                if (btnDeltaImport.Text == "Import NA Delta")
                {
                    ControlScreenState(ClearTabs.ImportNaDeltaClear);
                }
                else
                {
                    ControlScreenState(ClearTabs.ImportGcDeltaClear);
                }        
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnInsertForecast_Click(object sender, EventArgs e)
        {
            if (InsertOfficialForecast() == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();
                ControlScreenState(ClearTabs.InsertOfficialForecastClear);
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnInsertHistoricalSales_Click(object sender, EventArgs e)
        {
            if (InsertHistoricalSales() == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();
                ControlScreenState(ClearTabs.InsertHistoricalSalesClear);
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnMidModel_Click(object sender, EventArgs e)
        {
            ProcessMidModel();
            Cursor.Current = Cursors.Default;
        }

        #endregion



        #region Checkbox Events

        private void cbxRollForward_CheckedChanged(object sender, EventArgs e)
        {
            ControlScreenState(ClearTabs.RollForwardClear);
        }

        private void cbxImportNaCsm_CheckedChanged(object sender, EventArgs e)
        {
            ControlScreenState(ClearTabs.ImportCsmClear);
        }

        private void cbxNaDeltaImport_CheckedChanged(object sender, EventArgs e)
        {
            ControlScreenState(ClearTabs.ImportNaDeltaClear);
        }

        #endregion



        #region CSM Methods

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

        //private void RollForwardEmpireForecast(string priorRelease, string currentRelease)
        //{
        //    string error;
        //    _processData.RollEmpireForecast(priorRelease, currentRelease, out error);
        //    if (error != "")
        //    {
        //        _messageBox.Message = "Error thrown at RollForwardEmpireForecast().  " + error;
        //        _messageBox.ShowDialog();
        //    }
        //}

        private int ProcessCsm()
        {
            string currentRelease = tbxCurrentReleaseId.Text.Trim();
            if (currentRelease == "")
            {
                _messageBox.Message = "Please enter a current release.";
                _messageBox.ShowDialog();
                return 0;
            }

            // Create a temp table and insert the raw data into it
            if (ImportRawData() == 0) return 0;
       
            // Import new CSM data
            //if (ImportCsm(currentRelease) == 0) return 0;

            // Clean up the database
            //RemoveTempTable();
            return 1;
        }

        private int ProcessCsmGreaterChina()
        {
            string currentRelease = tbxCurrentReleaseId.Text.Trim();
            if (currentRelease == "")
            {
                _messageBox.Message = "Please enter a current release.";
                _messageBox.ShowDialog();
                return 0;
            }

            // Create a temp table and insert the raw data into it
            if (ImportRawData() == 0) return 0;

            // Import new Greater China CSM data
            if (ImportCsm(currentRelease) == 0) return 0;

            // Clean up the database
            RemoveTempTable();
            return 1;
        }

        private int ImportRawData()
        {
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the clipboard
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
                    if (row.Contains("\0")) break;
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
                        //foreach (var item in arry)
                        //{
                        //    //if (item == "37942")
                        //    //{
                        //    //    string i = item;
                        //    //}
                        //    rowData += (item + ",");
                        //}

                        //// Place quotes around each field
                        //string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";



                        string newRow = "";
                        foreach (var field in arry)
                        {
                            //fieldCount++;
                            //if (fieldCount > 13) break;

                            // Handle any single quotes
                            string editedField = field.Replace("'", "''");
                                
                            // Wrap each field in single quotes
                            string newField = "'" + editedField + "',";
                            newRow += newField;
                        }
         
                        // End of string correction
                        int stringLength = newRow.Length;
                        newRow = newRow.Remove(stringLength - 1, 1);

                        //// End of string correction
                        //int stringLength = rowDataFormatted.Length;
                        //rowDataFormatted = rowDataFormatted.Remove(stringLength - 3, 3);

                        //if (rowDataFormatted.Trim() == "'") break;


                        // Insert a row of data into the table
                        int result = InsertDataRow(newRow);
                        //int result = InsertDataRow(rowDataFormatted);
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
                //new SqlConnection(
                //    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");
                new SqlConnection(
                    "data source=eeisql2;initial catalog=MONITOR;persist security info=True;user id=cdipaola;password=emp1reFt1");

            try
            {
                var command = new SqlCommand("if exists (" +
                                             "select * " +
                                             "from sys.tables " +
                                             "where name like 'tempCSM' ) begin " +
                                             "drop table tempCSM " +
                                             "create table tempCSM(" +
                                             columns + ") end " +
                                             "else begin " +
                                             "create table tempCSM(" +
                                             columns + ") end",
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
                    "data source=eeisql2;initial catalog=MONITOR;persist security info=True;user id=cdipaola;password=emp1reFt1");

            try
            {
                //var command = new SqlCommand("IF EXISTS (" +
                //                             "SELECT 1 " +
                //                             "FROM sys.tables " +
                //                             "WHERE name LIKE 'tempCSM') " +
                //                             "INSERT INTO tempCSM " +
                //                             "VALUES (" +
                //                             values + ");",
                //                             con);

                var command = new SqlCommand("insert into tempCSM " +
                                             "values (" +
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

        //private int LocateFile()
        //{
        //    string folderPathImport = @"S:\CSM Data";
        //    string filePath = @"S:\CSM Data\NA Delta.csv";

        //    if (!File.Exists(filePath))
        //    {
        //        _messageBox.Message = string.Format("A file named NA Delta.csv was not found in {0}.  Cannot import data.", folderPathImport);
        //        _messageBox.ShowDialog();
        //        return 0;
        //    }
        //    return 1;
        //}

        //private void DeleteFile()
        //{
        //    try
        //    {
        //        File.Delete(@"S:\CSM Data\NA Delta.csv");
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //        _messageBox.Message = string.Format("Error when attempting to delete the file.  {0}", error);
        //        _messageBox.ShowDialog();
        //    }
        //}

        private int ProcessCsmDelta()
        {
            string release = tbxCurrentDeltaReleaseId.Text.Trim();
            const string VERSION = "CSM";

            string error;
            CheckPriorDeltaImport(out error);
            if (error != "")
            {
                DialogResult result = MessageBox.Show(error + string.Format(" Is release {0} correct?", release), "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (result == DialogResult.No) return 0;
            }

            // Import new CSM Delta data
            int importResult = ImportCsmDelta(release, VERSION);

            // If the import failed at any point, roll back
            if (importResult == 0)
            {
                DeleteCsmDelta(release, VERSION);
                return importResult;
            }

            // Success
            //DeleteFile(); 
            return importResult;
        }

        //private int ValidateReleaseId()
        //{
        //    int result = 1;

        //    string release = tbxCurrentDeltaReleaseId.Text.Trim();
        //    const string VERSION = "CSM";
        //    if (release == "")
        //    {
        //        _messageBox.Message = "Please enter a current release.";
        //        _messageBox.ShowDialog();
        //        return 0;
        //    }

        //    var con =
        //        new SqlConnection(
        //            "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

        //    try
        //    {
        //        string rowCount = "";

        //        var cmd = new SqlCommand();
        //        cmd.CommandText = "SELECT COUNT(1) AS cnt FROM EEIUser.acctg_csm_NAIHS_Delta WHERE Release_ID = '" +
        //                          release + "' AND Version = '" + VERSION + "'";
        //        cmd.CommandType = CommandType.Text;
        //        cmd.Connection = con;
        //        con.Open();

        //        SqlDataReader reader = cmd.ExecuteReader();
        //        while (reader.Read())
        //        {
        //            rowCount = reader[0].ToString();
        //        }
        //        reader.Close();

        //        int iRowCount = Convert.ToInt32(rowCount);
        //        if (iRowCount > 0)
        //        {
        //            _messageBox.Message = string.Format("Release ID {0} already exists in the Delta table.", release);
        //            _messageBox.ShowDialog();
        //            result = 0;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //        _messageBox.Message = string.Format("Error when attempting to validate the release ID {0}.", error);
        //        _messageBox.ShowDialog();
        //        result = 0;
        //    }
        //    finally
        //    {
        //        con.Close();
        //        con.Dispose();
        //    }
        //    return result;
        //}

        private int ImportCsmDelta(string release, string version)
        {
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the clipboard for data copied from a spreadsheet
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

                // Split the data into rows and loop through them
                var rows = data.Split('\r');
                foreach (var rowRaw in rows)
                {
                    // Create an ID, and build the beginning of a comma-separated string called identityData
                    string guidStr = Guid.NewGuid().ToString();
                    string identityData = "'" + guidStr + "','" + release + "','" + version + "',";
                    
                    // Exit if an empty row is found
                    var row = rowRaw.Replace("\n", "");
                    row = row.Replace("\0", "");
                    //if (row == "\0") break;
                    if (row == "") break;

                    // Split on double quotes, which are found when a comma exists within a field (comma will cause two fields to be created from one) 
                    string[] quotesSplit = row.Split('"');
                    if (quotesSplit.Count() > 1)
                    {
                        // Correct the Notes field by removing the double quotes (combining two fields into one)
                        string notes = quotesSplit[1].Replace("\"", "");

                        // Handle (escape) any single quotes within the Notes field
                        notes = notes.Replace("'", "''");

                        // Create an array of all the other copied data fields
                        string otherFields = quotesSplit[0];
                        string[] arry = otherFields.Split(',');

                        // Restart the loop if we are in one of the header rows
                        if (arry[0] == "North America Delta") continue;
                        if (arry[0] == "Greater China Delta") continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        // Exit the loop if we have reached the footer row
                        if (arry[0] == "Source: IHS Markit") break;


                        // Capture the mnemonic field (used to check if this data has already been imported)
                        string mnemonic = arry[9];

                        // Clean the copied data if necessary
                        string newRow = "";
                        foreach (var field in arry)
                        {
                            // Handle (escape) any single quotes within the fields
                            string editedField = field.Replace("'", "''");

                            // Wrap each field in single quotes and separate with commas
                            string newField = "'" + editedField + "',";
                            newRow += newField;
                        }

                        // Combine the identity data with the copied spreadsheet data
                        newRow = identityData + newRow;

                        // Remove extra characters at the end of the string
                        int stringLength = newRow.Length;
                        newRow = newRow.Remove(stringLength - 3, 3);

                        // Add the corrected Notes field to the end of the string
                        newRow += "'" + notes + "'";

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(release, version, mnemonic, newRow);
                        if (result == 0) return 0;
                    }
                    else
                    {
                        // Create an array of data fields
                        string[] arry = row.Split(',');

                        // Restart the loop if we are in one of the header rows
                        if (arry[0] == "North America Delta") continue;
                        if (arry[0] == "Greater China Delta") continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        // Exit the loop if we have reached the footer row
                        if (arry[0] == "Source: IHS Markit") break;


                        // Capture the mnemonic field (used to check if this data has already been imported)
                        string mnemonic = arry[9];

                        // Clean the copied data if necessary
                        string newRow = "";
                        foreach (var field in arry)
                        {
                            // Handle (escape) any single quotes within the fields
                            string editedField = field.Replace("'", "''");

                            // Wrap each field in single quotes and separate with commas
                            string newField = "'" + editedField + "',";
                            newRow += newField;
                        }

                        // Combine the identity data with the copied spreadsheet data
                        newRow = identityData + newRow;

                        // Perform end of string correction
                        int stringLength = newRow.Length;
                        newRow = newRow.Remove(stringLength - 1, 1);

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(release, version, mnemonic, newRow);
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

        private void CheckPriorDeltaImport(out string error)
        {
            error = "";

            string priorRelease = tbxPriorReleaseId.Text.Trim();
            if (priorRelease == "") return;

            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                string rowCount = "";

                var cmd = new SqlCommand();
                cmd.CommandText = "SELECT COUNT(1) AS cnt FROM EEIUser.acctg_csm_NAIHS_Delta WHERE Release_ID = '" + priorRelease + "'";
                cmd.CommandType = CommandType.Text;
                cmd.Connection = con;
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    rowCount = reader[0].ToString();
                }
                reader.Close();

                int iRowCount = Convert.ToInt32(rowCount);
                if (iRowCount < 1) error = string.Format("The prior release ({0}) does not have any Delta data.", priorRelease);
            }
            catch (Exception)
            {
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        private int InsertCsmDeltaDataRow(string release, string version, string mnemonic, string values)
        {
            // Ignore any empty rows
            var arr = values.Split(',');
            if (arr[3] == "''") return 1;

            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("if not exists (" +
                                            "select 1 from EEIUser.acctg_csm_NAIHS_Delta d " + 
                                            "where d.Release_ID = '" + release + "' " +
                                            "and d.Version = '" + version + "' " + 
                                            "and d.[Mnemonic-Vehicle] = '" + mnemonic + "') " +
                                            "begin " +
                                            "insert into EEIUser.acctg_csm_NAIHS_Delta " +
                                            "values (" +
                                            values + ") end;",
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

        private void DeleteCsmDelta(string release, string version)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("DELETE FROM EEIUser.acctg_csm_NAIHS_Delta " +
                                             "WHERE Release_ID = '" + release + "' AND Version = '" + version + "'",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                //string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                //_messageBox.Message = "Import failed.  Exception thrown at InsertCsmDeltaDataRow().  " + error;
                //_messageBox.ShowDialog();
                //return 0;
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
            //return 1;
        }

        #endregion



        #region Official Forecast Methods

        /// <summary>
        /// Overloaded function run automatically after the GC CSM import
        /// </summary>
        /// <param name="forecastName"></param>
        /// <returns></returns>
        private int InsertOfficialForecast(string forecastName)
        {
            string error;
            DateTime dt = DateTime.Now;

            _processData.InsertOfficialForecast(forecastName, dt, out error);
            if (error != "")
            {
                _messageBox.Message = string.Format("Insert failed.  Exception thrown at InsertOfficialForecast().  {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }
        
        private int InsertOfficialForecast()
        {
            string forecastName = tbxForecastName.Text.Trim();
            if (forecastName == "")
            {
                _messageBox.Message = "Please enter a forecast name.";
                _messageBox.ShowDialog();
                return 0;
            }
            if (!forecastName.Contains("OSF"))
            {
                _messageBox.Message = "Forecast name must contain OSF.";
                _messageBox.ShowDialog();
                return 0;
            }

            DateTime dateTimeStamp = dtpDateTimeStamp.Value;
            string error;
            _processData.InsertOfficialForecast(forecastName, dateTimeStamp, out error);
            if (error != "")
            {
                _messageBox.Message = string.Format("Insert failed.  Exception thrown at InsertOfficialForecast().  {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion



        #region Historical Sales Methods

        private int InsertHistoricalSales()
        {
            string forecastName = tbxHistoricalForecastName.Text.Trim();
            if (forecastName == "")
            {
                _messageBox.Message = "Please enter a forecast name.";
                _messageBox.ShowDialog();
                return 0;
            }

            DateTime dateTimeStamp = dtpHistoricalDateTimeStamp.Value;
            DateTime startDate = dtpStartDate.Value;
            DateTime endDate = dtpEndDate.Value;

            string error;
            _processData.InsertHistoricalSales(forecastName, dateTimeStamp, startDate, endDate, out error);
            if (error != "")
            {
                _messageBox.Message = string.Format("Insert failed.  Exception thrown at InsertHistoricalSales().  {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion



        #region Mid-model Year

        private void ProcessMidModel()
        {
            string release = tbxReleaseMidModel.Text.Trim();
            if (release == "")
            {
                _messageBox.Message = "Please enter a release.";
                _messageBox.ShowDialog();
                return;
            }

            string error;
            CheckPriorMidModelImport(out error);
            if (error != "")
            {
                DialogResult result = MessageBox.Show(error + string.Format(" Is release {0} correct?", release), "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (result == DialogResult.No) return;
            }

            // Make sure the raw table is empty
            if (DeleteMidModelRaw() == 0) return;

            // Import copied spreadsheet data into a raw data table
            if (ImportMidModel(release) == 0) return;

            // Insert into the final table from the raw table
            if (InsertMidModel(release) == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();

                ControlScreenState(ClearTabs.MidModelClear);
            }

            // Clean up the raw table
            DeleteMidModelRaw();
        }

        //private int ImportMidModelYear_Old()
        //{
        //    try
        //    {
        //        var format = DataFormats.CommaSeparatedValue;

        //        // Read the clipboard
        //        var dataObject = Clipboard.GetDataObject();
        //        var stream = (System.IO.Stream)dataObject.GetData(format);
        //        if (stream == null)
        //        {
        //            _messageBox.Message = "Please copy spreadsheet data.";
        //            _messageBox.ShowDialog();
        //            return 0;
        //        }
        //        var encoding = new System.Text.UTF8Encoding();
        //        var reader = new System.IO.StreamReader(stream, encoding);
        //        string data = reader.ReadToEnd();

        //        var rows = data.Split('\r');
        //        bool header = true;

        //        // Loop through spreadsheet rows
        //        foreach (var rowRaw in rows)
        //        {
        //            var row = rowRaw.Replace("\n", "");
        //            if (row.Contains("\0")) break;
        //            if (row == "") break;

        //            int fieldCount = 0;
        //            string basePart = "";
        //            string newTiming = "";
        //            string priorTiming = "";
        //            string reason = "";
        //            string midModel = "";
        //            List<String> basePartNewTimingList = new List<string>();

        //            string[] arry = row.Split(',');
        //            foreach (var item in arry)
        //            {
        //                if (header)
        //                {
        //                    if (item == "")
        //                    {
        //                        header = false;
        //                        break;
        //                    }
        //                }

        //                if (item == "parent_customer")
        //                {
        //                    break;
        //                }
        //                else
        //                {
        //                    fieldCount++;

        //                    if (fieldCount == 4) { basePart = item.ToString(); }
        //                    if (fieldCount == 11) { newTiming = item.ToString(); }
        //                    if (fieldCount == 12) { priorTiming = item.ToString(); }
        //                    if (fieldCount == 13) { reason = item.ToString(); }
        //                    if (fieldCount == 14) { midModel = item.ToString(); }

        //                    if (fieldCount > 13 && newTiming != "")
        //                    {
        //                        string year = newTiming.Remove(0, 11);
        //                        int len = year.Length;
        //                        year = year.Remove(4, len - 4);
        //                        int iYear = Convert.ToInt32(year);

        //                        // If the EOP year of the new timing is the current year, send an email alert
        //                        if (iYear == DateTime.Now.Year)
        //                        {
        //                            if (!basePartNewTimingList.Contains(basePart))
        //                            {
        //                                // First instance of a new timing change for this base part, so send email alert
        //                                SendNewTimingAlert(basePart, newTiming, priorTiming, reason);

        //                                basePartNewTimingList.Add(basePart);
        //                            }
        //                        }
        //                    }

        //                    if (basePart != "" && midModel != "")
        //                    {
        //                        if (UpdateMidModelYear(basePart, midModel) == 0) return 0;

        //                        basePart = midModel = "";
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
        //        _messageBox.Message = "Import failed.  Exception thwrown at ImportMidModelYear().  " + error;
        //        _messageBox.ShowDialog();
        //        return 0;
        //    }
        //    return 1;
        //}

        private void CheckPriorMidModelImport(out string error)
        {
            error = "";

            string priorRelease = tbxPriorReleaseId.Text.Trim();
            if (priorRelease == "") return;

            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                string rowCount = "";

                var cmd = new SqlCommand();
                cmd.CommandText = "SELECT COUNT(1) AS cnt FROM EEIUser.acctg_csm_mid_model WHERE Release_ID = '" + priorRelease + "'";
                cmd.CommandType = CommandType.Text;
                cmd.Connection = con;
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    rowCount = reader[0].ToString();
                }
                reader.Close();

                int iRowCount = Convert.ToInt32(rowCount);
                if (iRowCount < 1) error = string.Format("The prior release ({0}) does not have any Mid Model data.", priorRelease);
            }
            catch (Exception)
            {
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        private int ImportMidModel(string release)
        {
            string newRow = "";
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the clipboard for data copied from a spreadsheet
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

                // Split the data into rows and loop through them
                var rows = data.Split('\r');
                foreach (var rowRaw in rows)
                {
                    // Exit if an empty row is found
                    var row = rowRaw.Replace("\n", "");
                    row = row.Replace("\0", "");
                    //if (row == "\0") break;
                    if (row == "") break;

                    // Create an array of data fields
                    string[] arry = row.Split(',');

                    // Restart the loop if we are in one of the header rows
                    if (arry[0] == "Concept" || arry[0] == "Regions" || arry[0] == "Date" || arry[0] == "V: Region") continue;

                    // Capture specific fields to use as parameters in checking if this data set has already been imported
                    //string platform = arry[2];
                    //string program = arry[3];
                    //string nameplate = arry[16];

                    // Create the data string, cleaning the copied data if necessary
                    newRow = "'" + release + "',";
                    foreach (var field in arry)
                    {
                        // Handle (escape) any single quotes within the fields
                        string editedField = field.Replace("'", "''");

                        // Wrap each field in single quotes and separate with commas
                        string newField = "'" + editedField + "',";
                        newRow += newField;
                    }

                    // Perform end of string correction
                    int stringLength = newRow.Length;
                    newRow = newRow.Remove(stringLength - 1, 1);

                    // Insert a row of data into the raw table
                    //int result = InsertMidModelRaw(release, platform, program, nameplate, newRow);
                    int result = InsertMidModelRaw(newRow);
                    if (result == 0) return 0;
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messageBox.Message = "Import failed.  Exception thrown at ImportMidModel().  " + " " + newRow + " " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        //private int InsertMidModelRaw(string release, string platform, string program, string nameplate, string values)
        private int InsertMidModelRaw(string values)
        {
            // Ignore any empty rows
            var arr = values.Split(',');
            if (arr[3] == "''") return 1;

            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                //var command = new SqlCommand("if not exists (" +
                //                            "select 1 from EEIUser.acctg_csm_mid_model mm " +
                //                            "where mm.Release_ID = '" + release + "' " +
                //                            "and mm.Platform = '" + platform + "' " +
                //                            "and mm.Program = '" + program + "' " +
                //                            "and mm.ProductionNameplate = '" + nameplate + "') " +
                //                            "begin " +
                //                            "insert into EEIUser.acctg_csm_mid_model_raw " +
                //                            "values (" +
                //                            values + ") end;",
                //                            con);

                var command = new SqlCommand("insert into EEIUser.acctg_csm_mid_model_raw " +
                                            "values (" +
                                            values + ");",
                                            con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at InsertMidModelRaw().  " + error;
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

        private int InsertMidModel(string release)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("insert into EEIUser.acctg_csm_mid_model " +
                            "(Release_ID, Region, DesignParent, [Platform], Program, Vehicle, " +
                            "Sop, Eop, ChangeDate, ChangeType, Exterior, Interior, Engine, " +
                            "Transmission, Chassis, Suspension, Location, ProductionNameplate, " + 
                            "Brand, RowCreateDT) " +

                            "select Release_ID, Region, DesignParent, [Platform], Program, Vehicle, " +
                            "convert(datetime, (Sop + '-01')), convert(datetime, (Eop + '-01')), convert(datetime, ChangeDate), " + 
                            "ChangeType, Exterior, Interior, Engine, Transmission, Chassis, Suspension, Location, ProductionNameplate, " +
                            "Brand, " + "getdate() " +
                            "from EEIUser.acctg_csm_mid_model_raw " +
                            "where Release_ID = '" + release + "';",
                            con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at InsertMidModel().  " + error;
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

        private int DeleteMidModelRaw()
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("if exists (" +
                                            "select 1 from EEIUser.acctg_csm_mid_model_raw) " +
                                            "begin " +
                                            "delete from EEIUser.acctg_csm_mid_model_raw " +
                                            "end;",
                                            con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at DeleteMidModelRaw().  " + error;
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

        private void SendNewTimingAlert(string basePart, string newTiming, string priorTiming, string reason)
        {
            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("exec FT.ftsp_EMailAlert_NewEopTiming '" + basePart + "', '" + newTiming + "', '" + priorTiming + "', '" + reason + "'", con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception)
            {
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        private int UpdateMidModelYear(string basePart, string midModel)
        {
            DateTime midModelYear = Convert.ToDateTime(midModel);

            var con =
                new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("UPDATE EEIUser.acctg_csm_base_part_attributes " +
                                             "SET mid_model_year = '" + midModelYear + "' " +
                                             "WHERE base_part = '" + basePart + "' " +
                                             "AND release_id = ( select [dbo].[fn_ReturnLatestCSMRelease]('CSM') )",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Exception thrown at UpdateMidModelYear().  " + error;
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

        private void SetReleaseIDs()
        {
            var con = new SqlConnection(
                    "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("select[dbo].[fn_ReturnLatestCSMRelease]('CSM');",
                                             con);

                con.Open();
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    // Set prior release ID text
                    string release = (string)reader[0];
                    tbxPriorReleaseId.Text = release;

                    // Set current release ID text
                    int l = release.Length;
                    string year = release.Substring(0, 4);
                    string priorMonth = release.Substring(l - 2, 2);

                    int iYear = Convert.ToInt16(year);
                    int iPriorMonth = Convert.ToInt16(priorMonth);

                    string currentMonth, currentYear;
                    if (iPriorMonth == 12)
                    {
                        // Roll over to the next year
                        currentMonth = "01";
                        currentYear = (iYear + 1).ToString();
                    }
                    else if (iPriorMonth < 10)
                    {
                        // Prefix the month digit with a zero
                        currentMonth = "0" + (iPriorMonth + 1).ToString();
                        currentYear = year;
                    }
                    else
                    {
                        currentMonth = (iPriorMonth + 1).ToString();
                        currentYear = year;
                    }

                    tbxCurrentReleaseId.Text = tbxCurrentDeltaReleaseId.Text = tbxReleaseMidModel.Text = currentYear + '-' + currentMonth;
                }
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Failed to retrieve latest release ID.";
                _messageBox.ShowDialog();
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

        private void SetInitialOfficialForecastForm()
        {
            // Set the control values to the middle of the month
            string year = DateTime.Now.Year.ToString();
            int iMonth = DateTime.Now.Month;
            string month = (iMonth < 10) ? "0" + DateTime.Now.Month.ToString() : DateTime.Now.Month.ToString();
            string day = "15";

            string dt = year + "/" + month + "/" + day;
            string forecastName = year + "/" + month + "/" + day + " OSF";
            tbxForecastName.Text = forecastName;

            dtpDateTimeStamp.Value = Convert.ToDateTime(dt);
        }

        private void SetInitialCsmForm()
        {
            lblInstruction1.Text = "1.  Roll CSM data forward one month.";

            lblInstruction1A.Visible = lblInstruction1A1.Visible = lblInstruction1A2.Visible = 
                lblInstruction1A3.Visible = lblInstruction1B.Visible = false;

            btnImport.Visible = cbxImportNaCsm.Visible = btnImportGreaterChina.Visible = false;
        }

        private void ControlScreenState(ClearTabs clearTab)
        {
            switch (clearTab)
            {
                case ClearTabs.RollForwardClear:
                    lblInstruction1.Text = "2.  Import North America CSM data (China will be next).";
                    btnRollForward.Visible = cbxRollForward.Visible = false;

                    lblInstruction1A.Visible = lblInstruction1A1.Visible = lblInstruction1A2.Visible =
                        lblInstruction1A3.Visible = lblInstruction1B.Visible = true;

                    lblCompleteCsmRf.Visible = true;
                    lblPriorReleaseId.Visible = tbxPriorReleaseId.Visible = false;
                    btnImport.Visible = cbxImportNaCsm.Visible = true;
                    break;
                case ClearTabs.ImportCsmClear:
                    lblInstruction1.Text = "3.  Import Greater China CSM data. (Official Sales Forecast will automatically be completed.)";

                    lblCompleteCsmNa.Visible = true;
                    btnImport.Visible = cbxImportNaCsm.Visible = false;
                    btnImportGreaterChina.Visible = true;
                    break;
                case ClearTabs.ImportCsmGreaterChinaClear:
                    lblCompleteCsmGc.Visible = true;
                    btnImportGreaterChina.Visible = false;
                    break;
                case ClearTabs.ImportCsmGreaterChinaAndForecastClear:
                    lblCompleteCsmGc.Visible = lblAutoForecast.Visible = true;
                    btnImportGreaterChina.Visible = false;
                    break;
                case ClearTabs.ImportNaDeltaClear:
                    lblCompleteDeltaNa.Visible = true;
                    lblDeltaInstructions.Text = "2.  Import Greater China Delta.";
                    cbxNaDeltaImport.Visible = false;
                    btnDeltaImport.Text = "Import GC Delta";
                    break;
                case ClearTabs.ImportGcDeltaClear:
                    lblCompleteDeltaNa.Visible = true;
                    btnDeltaImport.Visible = false;
                    break;
                case ClearTabs.InsertOfficialForecastClear:
                    tbxForecastName.Text = "";
                    tbxForecastName.Focus();
                    break;
                case ClearTabs.InsertHistoricalSalesClear:
                    tbxHistoricalForecastName.Text = "";
                    tbxHistoricalForecastName.Focus();
                    break;
                case ClearTabs.MidModelClear:
                    lblCompleteMidModel.Visible = true;
                    btnMidModel.Visible = false;
                    break;
            }
        }


        #endregion










        #region Events CSM North America

        private void btnImportNA_Click(object sender, EventArgs e)
        {
            ProcessCsmNa();
        }

        #endregion



        #region Events CSM Greater China

        private void btnImportGC_Click(object sender, EventArgs e)
        {
            ProcessCsmGc();
        }

        #endregion



        #region Methods CSM North America

        private void ProcessCsmNa()
        {
            string release;
            string returnMessage = CheckReleaseFormat(out release);
            if (returnMessage != "")
            {
                _messageBox.Message = returnMessage;
                _messageBox.ShowDialog();
                return;
            }

            if (ValidateReleaseNa(release) == 0) return;

            if (CheckDateColumns(release) == 0) return;

            if (ImportRawCsmData() == 0) return;

            //// Move raw data into CSM tables
            //if (ImportNa(release) == 1)
            //{
            //    MessageBox.Show("Success!");
            //    lblNaImportComplete.Visible = true;
            //}
        }

        private int ValidateReleaseNa(string release)
        {
            string error, message;
            string region = "North America";
            _csmNaGc.ValidateRelease(release, region, out message, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed at ValidateReleaseNa().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            if (message != "")
            {
                DialogResult dr = MessageBox.Show(message, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                if (dr == DialogResult.No)
                {
                    tbxCurrentReleaseNA.Text = "";
                    return 0;
                }
            }
            return 1;
        }

        private int ImportNa(string release)
        {
            string error;
            _csmNaGc.ImportNa(release, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed at ImportNa().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion



        #region Methods CSM Greater China

        private void ProcessCsmGc()
        {
            string release;
            string returnMessage = CheckReleaseFormat(out release);
            if (returnMessage != "")
            {
                _messageBox.Message = returnMessage;
                _messageBox.ShowDialog();
                return;
            }

            if (ValidateReleaseGc(release) == 0) return;

            if (CheckDateColumns(release) == 0) return;

            if (ImportRawCsmData() == 0) return;

            // Move raw data into CSM tables
            if (ImportGc(release) == 1)
            {
                MessageBox.Show("Success!");
                lblGcImportComplete.Visible = true;
            }
        }

        private int ValidateReleaseGc(string release)
        {
            string error, message;
            string region = "Greater China";
            _csmNaGc.ValidateRelease(release, region, out message, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed at ValidateReleaseGc().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            if (message != "")
            {
                DialogResult dr = MessageBox.Show(message, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                if (dr == DialogResult.No)
                {
                    tbxCurrentReleaseGC.Text = "";
                    return 0;
                }
            }
            return 1;
        }

        private int ImportGc(string release)
        {
            string error;
            _csmNaGc.ImportGc(release, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed at ImportGc().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion



        #region Methods shared by CSM North America and Greater China

        private string CheckReleaseFormat(out string currentRelease)
        {
            string message = "";

            currentRelease = tbxCurrentReleaseNA.Text.Trim();
            if (string.IsNullOrWhiteSpace(currentRelease)) message = "Please enter the current Release ID.";

            if (message == "")
            {
                // Proper length
                if (currentRelease.Length != 7) message = "The Release ID format or value is not correct.";
            }

            if (message == "")
            {
                // Valid year
                string year = currentRelease.Substring(0, 4);
                try
                {
                    int iYear = Convert.ToDateTime("01-01-" + year).Year;
                }
                catch (Exception)
                {
                    message = "The Release ID format or value is not correct.";
                }
            }

            if (message == "")
            {
                // Valid month
                string month = currentRelease.Substring(5, 2);
                try
                {
                    int iMonth = Convert.ToDateTime("01-" + month + "-2030").Month;
                }
                catch (Exception ex)
                {
                    message = "The Release ID format or value is not correct.";
                }
            }

            if (message == "")
            {
                // Dash format
                string dash = currentRelease.Substring(4, 1);
                if (dash != "-")
                {
                    message = "The Release ID format or value is not correct.";
                }
            }
            return message;
        }

        private int CheckDateColumns(string release)
        {
            string error, message;
            _csmNaGc.CheckDateColumns(release, out message, out error);
            if (error != "")
            {
                _messageBox.Message = "Import failed at CheckDateColumns().  " + error;
                _messageBox.ShowDialog();
                return 0;
            }
            if (message != "")
            {
                DialogResult dr = MessageBox.Show(message, "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                if (dr == DialogResult.No) return 0;
            }
            return 1;
        }

        private int ImportRawCsmData()
        {
            try
            {
                bool columnsCaptured = false;
                var format = DataFormats.CommaSeparatedValue;

                // Read the clipboard for data copied from a spreadsheet
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

                // Split the data into rows and loop through them
                var rows = data.Split('\r');
                foreach (var rowRaw in rows)
                {
                    // Exit if an empty row is found
                    var row = rowRaw.Replace("\n", "");
                    row = row.Replace("\0", "");
                    //if (row == "\0") break;
                    if (row == "") break;

                    // Create an array of data fields
                    string[] arry = row.Split(',');

                    // If colum names have not been captured yet, create a string of them and use that string to create a table
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
                        string newRow = "";
                        foreach (var field in arry)
                        {
                            // Handle any single quotes
                            string editedField = field.Replace("'", "''");

                            // Wrap each field in single quotes
                            string newField = "'" + editedField + "',";
                            newRow += newField;
                        }

                        // End of string correction
                        int stringLength = newRow.Length;
                        newRow = newRow.Remove(stringLength - 1, 1);

                        // Insert a row of data into the table
                        int result = InsertDataRow(newRow);
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

        #endregion


    }
}
