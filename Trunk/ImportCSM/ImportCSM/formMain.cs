﻿using System;
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

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        private void formMain_Activated(object sender, EventArgs e)
        {
            tbxPriorReleaseId.Focus();
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
                ControlScreenState(ClearTabs.ImportCsmClear);
            }
            else if(tabControl1.SelectedTab == tabControl1.TabPages["tpCsmDelta"])
            {
                ControlScreenState(ClearTabs.ImportDeltaCsmClear);
            }
            else if (tabControl1.SelectedTab == tabControl1.TabPages["tpOfficialForecast"])
            {
                ControlScreenState(ClearTabs.InsertOfficialForecastClear);
            }
            else
            {
                ControlScreenState(ClearTabs.InsertHistoricalSalesClear);
            }
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

        private void btnImport_MouseDown(object sender, MouseEventArgs e)
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

        private void btnImport_Click(object sender, EventArgs e)
        {
            if (ProcessCsm() == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();
                ControlScreenState(ClearTabs.ImportCsmClear);
            }
            Cursor.Current = Cursors.Default;
        }

        private void btnDeltaImport_Click(object sender, EventArgs e)
        {
            if (ProcessCsmDelta() == 1)
            {
                _messageBox.Message = "Success.";
                _messageBox.ShowDialog();
                ControlScreenState(ClearTabs.ImportDeltaCsmClear);
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


        #region CSM Methods

        private int ProcessCsm()
        {
            string priorRelease = tbxPriorReleaseId.Text.Trim();
            string currentRelease = tbxCurrentReleaseId.Text.Trim();
            if (priorRelease == "")
            {
                _messageBox.Message = "Enter a prior release.";
                _messageBox.ShowDialog();
                return 0;
            }
            if (currentRelease == "")
            {
                _messageBox.Message = "Enter a current release.";
                _messageBox.ShowDialog();
                return 0;
            }

            // Create a temp table and insert the raw data into it
            if (ImportRawData() == 0) return 0;

            // Roll old CSM data forward
            if (RollCSMForward(priorRelease, currentRelease) == 0) return 0;
       
            // Import new CSM data
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

        private int ProcessCsmDelta()
        {
            string release = tbxCurrentDeltaReleaseId.Text.Trim();
            const string VERSION = "CSM";
            if (release == "")
            {
                _messageBox.Message = "Enter a current release.";
                _messageBox.ShowDialog();
                return 0;
            }

            // Import new CSM Delta data
            return ImportCsmDelta(release, VERSION) == 0 ? 0 : 1;
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
        

        #region Official Forecast Methods
        
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

        private void ControlScreenState(ClearTabs clearTab)
        {
            switch (clearTab)
            {
                case ClearTabs.ImportCsmClear:
                    tbxPriorReleaseId.Text = tbxCurrentReleaseId.Text = "";
                    tbxPriorReleaseId.Focus();
                    break;
                case ClearTabs.ImportDeltaCsmClear:
                    tbxCurrentDeltaReleaseId.Text = "";
                    tbxCurrentDeltaReleaseId.Focus();
                    break;
                case ClearTabs.InsertOfficialForecastClear:
                    dtpDateTimeStamp.Value = DateTime.Now;
                    tbxForecastName.Text = "";
                    tbxForecastName.Focus();
                    break;
                case ClearTabs.InsertHistoricalSalesClear:
                    dtpHistoricalDateTimeStamp.Value = dtpStartDate.Value = dtpEndDate.Value = DateTime.Now;
                    tbxHistoricalForecastName.Text = "";
                    tbxHistoricalForecastName.Focus();
                    break;
            }
        }

        #endregion


    }
}
