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

        #endregion


        #region Constructor, Load Event

        public formMain()
        {
            InitializeComponent();

            _processData = new ProcessData();
            _messageBox = new CustomMessageBox();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            SetInitialCsmForm();
            SetReleaseIDs();
            SetInitialOfficialForecastForm();

            tbxPriorReleaseId.Focus();
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
            //if (tabControl1.SelectedTab == tabControl1.TabPages["tpCsm"])
            //{
            //    ControlScreenState(ClearTabs.ImportCsmClear);
            //}
            //else if(tabControl1.SelectedTab == tabControl1.TabPages["tpCsmDelta"])
            //{
            //    ControlScreenState(ClearTabs.ImportDeltaCsmClear);
            //}
            //else if (tabControl1.SelectedTab == tabControl1.TabPages["tpOfficialForecast"])
            //{
            //    ControlScreenState(ClearTabs.InsertOfficialForecastClear);
            //}
            //else
            //{
            //    ControlScreenState(ClearTabs.InsertHistoricalSalesClear);
            //}
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
            // Import Greater China CSM
            if (ProcessCsmGreaterChina() == 1)
            {
                _messageBox.Message = "Successful import of Greater China CSM.  Click OK to insert Official Sales Forecast.";
                _messageBox.ShowDialog();

                // Insert Official Sales Forecast
                string forecastName = DateTime.Now.ToString("yyyy/MM/dd") + " OSF";
                if (InsertOfficialForecast(forecastName) == 1)
                {
                    _messageBox.Message = "Successful Sales Forecast insert.";
                    _messageBox.ShowDialog();
                }

                ControlScreenState(ClearTabs.ImportCsmGreaterChinaClear);
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
            if (ImportCsm(currentRelease) == 0) return 0;

            // Clean up the database
            RemoveTempTable();
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

            // Import new CSM Delta data
            //int importResult = ImportCsmDelta(release, VERSION);
            int importResult = ImportCsmDeltaNew(release, VERSION);

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



        //private int ImportCsmDeltaOld(string release, string version)
        //{
        //    try
        //    {
        //        var format = DataFormats.CommaSeparatedValue;

        //        // Read the CSV
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

        //         // Loop through spreadsheet rows
        //        foreach (var rowRaw in rows)
        //        {
        //            string guidStr = Guid.NewGuid().ToString();

        //            string rowData = guidStr + "," + release + "," + version + ",";

        //            var row = rowRaw.Replace("\n", "");
        //            if (row == "\0") break;
        //            if (row == "") break;


        //            string[] quotesSplit = row.Split('"');
        //            if (quotesSplit.Count() > 1)
        //            {
        //                string otherFields = quotesSplit[0];
        //                string notes = quotesSplit[1].Replace("\"", "");
        //                notes = notes.Replace("'", "''");

        //                // Skip the header row
        //                string[] arry = otherFields.Split(',');
        //                if (arry.Count() < 13) continue;
        //                if (arry[0] == "Design parent/ manufacturer") continue;

        //                foreach (var item in arry) rowData += (item + ",");

        //                // Place quotes around each field
        //                string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

        //                // End of string correction
        //                int stringLength = rowDataFormatted.Length;
        //                rowDataFormatted = rowDataFormatted.Remove(stringLength -4, 4);
        //                //MessageBox.Show("Formatted remove:  " + rowDataFormatted);

        //                rowDataFormatted += notes;
        //                rowDataFormatted += "'";

        //                //MessageBox.Show("Formatted with notes:  " + rowDataFormatted);

        //                // Insert a row of data into the table
        //                int result = InsertCsmDeltaDataRow(rowDataFormatted);
        //                if (result == 0) return 0;
        //            }
        //            else
        //            {
        //                // Skip the header row
        //                string[] arry = row.Split(',');
        //                if (arry.Count() < 13) continue;
        //                if (arry[0] == "Design parent/ manufacturer") continue;

        //                foreach (var item in arry) rowData += (item + ",");

        //                // Place quotes around each field
        //                string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

        //                // End of string correction
        //                int stringLength = rowDataFormatted.Length;
        //                rowDataFormatted = rowDataFormatted.Remove(stringLength - 3, 3);

        //                // Insert a row of data into the table
        //                int result = InsertCsmDeltaDataRow(rowDataFormatted);
        //                if (result == 0) return 0;   
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
        //        _messageBox.Message = "Import failed.  Exception thrown at ImportCsmDelta().  " + error;
        //        _messageBox.ShowDialog();
        //        return 0;
        //    }
        //    return 1;
        //}

        private int ImportCsmDeltaNew(string release, string version)
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
                    if (row == "\0") break;
                    if (row == "") break;

                    string[] quotesSplit = row.Split('"');
                    if (quotesSplit.Count() > 1)
                    {
                        string otherFields = quotesSplit[0];
                        string notes = quotesSplit[1].Replace("\"", "");
                        notes = notes.Replace("'", "''");

                        string[] arry = otherFields.Split(',');

                        // Skip header rows
                        if (arry[0] == "North America Delta") continue;
                        if (arry[0] == "Greater China Delta") continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        // Comma separate fields
                        foreach (var item in arry) rowData += (item + ",");

                        // Place quotes around each field
                        string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

                        // End of string correction
                        int stringLength = rowDataFormatted.Length;
                        rowDataFormatted = rowDataFormatted.Remove(stringLength - 4, 4);

                        rowDataFormatted += notes;
                        rowDataFormatted += "'";

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(rowDataFormatted);
                        if (result == 0) return 0;
                    }
                    else
                    { 
                        string[] arry = row.Split(',');

                        // Skip header rows
                        if (arry[0] == "North America Delta") continue;
                        if (arry[0] == "Greater China Delta") continue;
                        if (arry[0] == "Design parent/ manufacturer") continue;

                        //foreach (var item in arry) rowData += (item + ",");

                        //// Place quotes around each field
                        //string rowDataFormatted = "'" + rowData.Replace(",", "','") + "'";

                        string newRow = "";
                        foreach (var field in arry)
                        {
                            // Handle any single quotes
                            string editedField = field.Replace("'", "''");

                            // Wrap each field in single quotes and separate with commas
                            string newField = "'" + editedField + "',";
                            newRow += newField;
                        }

                        // End of string correction
                        int stringLength = newRow.Length;
                        newRow = newRow.Remove(stringLength - 1, 1);

                        // Insert a row of data into the table
                        int result = InsertCsmDeltaDataRow(newRow);
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

        //private int ImportCsmDelta(string release, string version)
        //{
        //    int methodResult = 1;

        //    //var parser = new TextFieldParser(@"S:\LogisticsVariance\FedEx\FedExVariance.csv") {HasFieldsEnclosedInQuotes = true};
        //    var parser = new TextFieldParser(@"S:\CSM Data\NA Delta.csv") { HasFieldsEnclosedInQuotes = true };
        //    parser.SetDelimiters(",");

        //    try
        //    {
        //        while (!parser.EndOfData)
        //        {
        //            string guidStr = Guid.NewGuid().ToString();
        //            string newRow = "'" + guidStr + "','" + release + "','" + version + "',";

        //            int fieldCount = 0;
        //            string[] fields = parser.ReadFields();
        //            foreach (var field in fields)
        //            {
        //                fieldCount++;
        //                if (fieldCount > 13) break;

        //                // Handle any single quotes
        //                string editedField = field.Replace("'", "''");

        //                string newField = "'" + editedField + "',";
        //                newRow += newField;
        //            }

        //            // End of string correction
        //            int stringLength = newRow.Length;
        //            newRow = newRow.Remove(stringLength - 1, 1);

        //            if (!newRow.Contains("North America Delta") && !newRow.Contains("Design parent/ manufacturer") &&
        //                !newRow.Contains("Design parent/manufacturer") && !newRow.Contains("Design parent / manufacturer") &&
        //                !newRow.Contains("Design parent /manufacturer") && !newRow.Contains("Source: IHS Markit"))
        //            {
        //                // Insert row into the raw data table
        //                int result = InsertCsmDeltaDataRow(newRow);
        //                if (result == 0) return 0;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        methodResult = 0;

        //        string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
        //        _messageBox.Message = string.Format("Failed to import raw CSM Delta data.  {0}", error);
        //        _messageBox.ShowDialog();
        //    }
        //    finally
        //    {
        //        parser.Close();
        //    }

        //    return methodResult;
        //}

        private int InsertCsmDeltaDataRow(string values)
        {
            // Ignore any empty rows
            var arr = values.Split(',');
            if (arr[3] == "''") return 1;

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

                    tbxCurrentReleaseId.Text = tbxCurrentDeltaReleaseId.Text = currentYear + '-' + currentMonth;
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
            }
        }

        #endregion


        #region Mid-model Year

        private void btnMidModel_Click(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
            if (ImportMidModelYear() == 0) return;
            Cursor.Current = Cursors.Default;

            _messageBox.Message = "Success.";
            _messageBox.ShowDialog();            
        }

        private int ImportMidModelYear()
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
                bool header = true;

                // Loop through spreadsheet rows
                foreach (var rowRaw in rows)
                {
                    var row = rowRaw.Replace("\n", "");
                    if (row.Contains("\0")) break;
                    if (row == "") break;

                    int fieldCount = 0;
                    string basePart = "";
                    string newTiming = "";
                    string priorTiming = "";
                    string reason = "";
                    string midModel = "";
                    List<String> basePartNewTimingList = new List<string>();

                    string[] arry = row.Split(',');
                    foreach (var item in arry)
                    {
                        if (header)
                        {
                            if (item == "")
                            {
                                header = false;
                                break;
                            }
                        }

                        if (item == "parent_customer")
                        {
                            break;
                        } 
                        else
                        {
                            fieldCount++;

                            if (fieldCount == 4) { basePart = item.ToString(); }
                            if (fieldCount == 11) { newTiming = item.ToString(); }
                            if (fieldCount == 12) { priorTiming = item.ToString(); }
                            if (fieldCount == 13) { reason = item.ToString(); }
                            if (fieldCount == 14) { midModel = item.ToString(); }

                            if (fieldCount > 13 && newTiming != "")
                            {
                                string year = newTiming.Remove(0, 11);
                                int len = year.Length;
                                year = year.Remove(4, len - 4);
                                int iYear = Convert.ToInt32(year);

                                // If the EOP year of the new timing is the current year, send an email alert
                                if (iYear == DateTime.Now.Year)
                                {
                                    if (!basePartNewTimingList.Contains(basePart))
                                    {
                                        // First instance of a new timing change for this base part, so send email alert
                                        SendNewTimingAlert(basePart, newTiming, priorTiming, reason);

                                        basePartNewTimingList.Add(basePart);
                                    }
                                }
                            }

                            if (basePart != "" && midModel != "")
                            {
                                if (UpdateMidModelYear(basePart, midModel) == 0) return 0;

                                basePart = midModel = "";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messageBox.Message = "Import failed.  Exception thwrown at ImportMidModelYear().  " + error;
                _messageBox.ShowDialog();
                return 0;
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
            catch (Exception ex)
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


    }
}
