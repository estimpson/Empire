using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ImportSpreadsheetData.DataLayer;

namespace ImportSpreadsheetData
{
    public partial class frmImport : Form
    {
        #region Class Objects

        private readonly ImportDataSLAmerica _importDataSlAmerica;
        private readonly ImportDataSLAKorea _importDataSlaKorea;
        private readonly ImportDataLiteTek _importDataLiteTek;

        #endregion


        #region Properties

        private string _customer;
        public string Customer
        {
            get { return _customer; }
            set
            {
                _customer = value;

                if (value == "")
                {
                    ClearForm();
                    btnImport.Visible = false;
                    return;
                }
                btnImport.Visible = true;
            }
        }
        #endregion


        #region Variables

        private bool _firstRow;
        private bool _datesRow;
        private readonly bool _dataBinding;

        #endregion


        #region Constructor

        public frmImport()
        {
            InitializeComponent();

            _importDataSlAmerica = new ImportDataSLAmerica();
            _importDataSlaKorea = new ImportDataSLAKorea();
            _importDataLiteTek = new ImportDataLiteTek();

            lvwImportedData.Columns.Add("Part", 90);
            lvwImportedData.Columns.Add("Customer Part", 100);
            lvwImportedData.Columns.Add("Quantity", 70);
            lvwImportedData.Columns.Add("Due Date", 110);

            _dataBinding = true;

            cbxCustomer.Items.Add("");
            cbxCustomer.Items.Add("LiteTek");
            cbxCustomer.Items.Add("SLAmerica");
            cbxCustomer.Items.Add("SLAKOREA");
            //cbxCustomer.Items.Add("Stanley");
            
            _dataBinding = false;

            btnImport.Visible = false;
        }

        #endregion
        

        #region Button Events

        private void btnImport_Click(object sender, EventArgs e)
        {
            if (LocateFile() == 0) return;

            if (ImportData() == 0)
            {
                ResetImport();
                return;
            }

            if (ProcessData() == 1) RenameFile();
        }

        private void btnSetOrderUpdateFlag_Click(object sender, EventArgs e)
        {
            string dest = tbxDestination.Text.Trim();
            var frm = new frmSalesOrderMaintenance(dest);

            frm.ToggleDestinationPanels(dest != "");

            frm.ShowDialog();
        }

        #endregion


        #region ComboBox Events

        private void cbxCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_dataBinding) return;

            Customer = cbxCustomer.Text.Trim();
        }

        #endregion


        #region Methods

        //private int ImportDataOld()
        //{
        //    int result = 1;
        //    Cursor.Current = Cursors.WaitCursor;

        //    try
        //    {
        //        lvwImportedData.Items.Clear();
        //        lbxExceptions.Items.Clear();

        //        var format = DataFormats.CommaSeparatedValue;

        //        // Read the CSV
        //        var dataObject = Clipboard.GetDataObject();
        //        var stream = (System.IO.Stream)dataObject.GetData(format);
        //        if (stream == null)
        //        {
        //            Cursor.Current = Cursors.Default;
        //            MessageBox.Show("Please copy spreadsheet data.", "Message");
        //            return 0;
        //        }
        //        var encoding = new System.Text.UTF8Encoding();
        //        var reader = new System.IO.StreamReader(stream, encoding);
        //        string data = reader.ReadToEnd();


        //        Boolean headerFound = false;
        //        string headerRow = string.Empty;
        //        var rows = data.Split('\r');
        //        var dateList = new List<DateTime>();
        //        var quantityList = new List<int>();
        //        var exceptionList = new List<string>();
        //        string release = string.Empty;

        //        // Loop through spreadsheet rows
        //        foreach (var rowRaw in rows)
        //        {
        //            var row = rowRaw.Replace("\n", "");

        //            // Extract the data that will used as the Release / Document Number
        //            if (!headerFound && row.Split(',')[0].Length >= 16 && 
        //                (row.Split(',')[0].Substring(0, 16) == "Stanley FORECAST" ||
        //                row.Split(',')[0].Substring(0, 16) == "STANLEY Forecast" ||
        //                row.Split(',')[0].Substring(0, 16) == "Stanley Forecast" ||
        //                row.Split(',')[0].Substring(0, 16) == "STANLEY FORECAST"))
        //            {
        //                release = row.Split(',')[0];
        //            }

        //            // Extract order due date data from column headers
        //            if (!headerFound && row.Split(',')[0] == "SUS PART DESCRIPTION")
        //            {
        //                headerRow = row;
        //                headerFound = true;

        //                var fields = headerRow.Split(',');
        //                DateTime dummy;
        //                dateList = fields.Where(f => DateTime.TryParse(f, out dummy)).Select(s => DateTime.Parse(s)).ToList();
        //            }

        //            // When we get to the row where the rest of the order data begins, capture it
        //            if (headerFound && row.Split(',')[0] != "SUS PART DESCRIPTION" && row.Split(',').Count() >= 3 && row.Split(',')[2].Length > 0)
        //            {
        //                string partDesc = row.Split(',')[0];
        //                string icsNumber = row.Split(',')[1];
        //                string part = row.Split(',')[2];

        //                var fields = row.Split(',');
        //                int dummy;

        //                quantityList = fields.ToList()
        //                      .GetRange(3, dateList.Count())
        //                      .Where(f => Int32.TryParse(f, out dummy))
        //                      .Select(s => Int32.Parse(s)).ToList();

        //                // For each due date, assemble a row of data
        //                for (int j = 0; j < dateList.Count - 1 && j < quantityList.Count - 1; j++)
        //                {
        //                    // Import the data into the database
        //                    string error;
        //                    _importData.Import(icsNumber, part, quantityList[j], dateList[j], release, out error);
        //                    if (error != "")
        //                    {
        //                        string qty = quantityList[j].ToString();
        //                        string dt = dateList[j].ToShortDateString();
        //                        string exception = string.Format("{0} {1} {2}", part, qty, dt);
        //                        exceptionList.Add(exception);
        //                    }
        //                    else
        //                    {
        //                        // Display the imported data
        //                        string[] arr = new string[6];
        //                        arr[0] = icsNumber;
        //                        arr[1] = part;
        //                        arr[2] = partDesc;
        //                        arr[3] = quantityList[j].ToString();
        //                        arr[4] = dateList[j].ToShortDateString();
        //                        arr[5] = release;

        //                        var itm = new ListViewItem(arr);
        //                        lvwImportedData.Items.Add(itm);
        //                    }
        //                }

        //            }
        //        }
        //        if (exceptionList.Any())
        //        {
        //            foreach (var item in exceptionList)
        //            {
        //                lbxExceptions.Items.Add(item);
        //            }
        //            result = 0;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
        //        MessageBox.Show(error, "Error");
        //        result = 0;
        //    }

        //    Cursor.Current = Cursors.Default;
        //    return result;
        //}

        private int ImportData()
        {
            int result = 1;
            Cursor.Current = Cursors.WaitCursor;

            string release = "";
            string destination = "";
            var dueDateList = new List<DateTime>();
            var quantityList = new List<int>();
            //var exceptionList = new List<string>();

            ClearForm();

            try
            {
                //var reader = new StreamReader(File.OpenRead(@"C:\PlanningReleases\" + _customer + @"\Import.csv"));
                var reader = new StreamReader(File.OpenRead(@"S:\PlanningReleases\" + _customer + @"\Import.csv"));
                while (!reader.EndOfStream)
                {
                    string line = reader.ReadLine();
                    char[] charSeparators = new char[] { ',' };
                    string[] values = line.Split(charSeparators, StringSplitOptions.RemoveEmptyEntries);


                    if (_firstRow)
                    {
                        // Get the release number and destination
                        release = tbxRelease.Text = values[0];
                        destination = tbxDestination.Text = values[1];
                        _firstRow = false;
                        _datesRow = true;
                    }
                    else if (_datesRow)
                    {
                        // Create a list of due dates (will be converted from column data to row data)
                        foreach (var value in values)
                        {
                            string b = value;
                            try
                            {
                                var dt = DateTime.Parse(b);
                                dueDateList.Add(dt);
                            }
                            catch (Exception)
                            {
                                // Do nothing
                            }
                        }
                        _datesRow = false;
                    }
                    else
                    {
                        // Get row data (part, customer part, forecast quantities)
                        string part = values[0];
                        string customerPart = values[1];

                        quantityList.Clear();
                        foreach (var value in values)
                        {
                            // Skip over part and customer part columns
                            if (value == values[0] || value == values[1]) continue; 

                            string qty = value;
                            if (qty == "") qty = "0";
                            try
                            {
                                var quantity = Int32.Parse(qty);
                                quantityList.Add(quantity);
                            }
                            catch (Exception)
                            {
                                // Do nothing
                            }
                        }

                        // For each due date, assemble a row of data
                        for (int j = 0; j < dueDateList.Count; j++)
                        {
                            // Import the data into the database
                            string error = "";

                            switch (_customer)
                            {
                                case "SLAmerica":
                                    _importDataSlAmerica.Import(customerPart, part, destination, quantityList[j], dueDateList[j], release, out error);
                                    break;
                                case "SLAKOREA":
                                    _importDataSlaKorea.Import(customerPart, part, destination, quantityList[j], dueDateList[j], release, out error);
                                    break;
                                case "LiteTek":
                                    _importDataLiteTek.Import(customerPart, part, destination, quantityList[j], dueDateList[j], release, out error);
                                    break;
                            }

                            if (error != "")
                            {
                                //string quantity = quantityList[j].ToString();
                                //string dt = dueDateList[j].ToShortDateString();
                                //string exception = string.Format("{0} {1} {2}", part, quantity, dt);
                                //exceptionList.Add(exception);

                                MessageBox.Show(error, "Import Failed");
                                return 0;
                            }

                            string[] arr = new string[4];
                            arr[0] = part;
                            arr[1] = customerPart;
                            arr[2] = quantityList[j].ToString();
                            arr[3] = dueDateList[j].ToShortDateString();

                            var itm = new ListViewItem(arr);
                            lvwImportedData.Items.Add(itm);
                        }
                        //if (exceptionList.Any())
                        //{
                        //    foreach (var item in exceptionList)
                        //    {
                        //        lbxExceptions.Items.Add(item);
                        //    }
                        //    result = 0;
                        //}
                    }

                }
                reader.Close();
                reader.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) 
                    ? "Unable to process releases.  The spreadsheet may not be in the proper format.  " +  ex.InnerException.Message
                    : "Unable to process releases.  The spreadsheet may not be in the proper format.  " + ex.Message;
                MessageBox.Show(error, "Error at ImportData()");
                return 0;
            }

            Cursor.Current = Cursors.Default;
            return result;
        }

        private void ResetImport()
        {
            string error = "";
            string release = tbxRelease.Text.Trim();

            switch (_customer)
            {
                case "SLAmerica":
                    _importDataSlAmerica.ResetImport(release, out error);
                    break;
                case "SLAKOREA":
                    _importDataSlaKorea.ResetImport(release, out error);
                    break;
                case "LiteTek":
                    _importDataLiteTek.ResetImport(release, out error);
                    break;
            }

            if (error != "") MessageBox.Show(error, "Error at ResetImport()");

            ClearForm();
        }

        private int ProcessData()
        {
            string error = "";
            string destination = tbxDestination.Text.Trim();

            if (destination == "")
            {
                MessageBox.Show("Cannot process releases because a destination was not supplied in the data.", "Error");
                return 0;
            }

            switch (_customer)
            {
                case "SLAmerica":
                    _importDataSlAmerica.Process(destination, out error);
                    break;
                case "SLAKOREA":
                    _importDataSlaKorea.Process(destination, out error);
                    break;
                case "LiteTek":
                    _importDataLiteTek.Process(destination, out error);
                    break;
            }

            if (error != "")
            {
                MessageBox.Show(error, "Error at ProcessData()");
                return 0;
            }
            return 1;
        }

        private int LocateFile()
        {
            string folderPathImport = @"S:\PlanningReleases\" + _customer;
            string filePath = @"S:\PlanningReleases\" + _customer + @"\Import.csv";

            if (!Directory.Exists(folderPathImport))
            {
                MessageBox.Show("Folder path " + folderPathImport + " was not found.  Cannot process releases.", "Error");
                return 0;
            }
            if (!File.Exists(filePath))
            {
                MessageBox.Show("A file named Import.csv was not found in " + folderPathImport + ".  Cannot process releases.", "Error");
                return 0;
            }
            return 1;
        }

        private void RenameFile()
        {
            try
            {
                string fileName = "Import.csv";
                string fileNameNew = "Import_" + DateTime.Now.ToString("yyyy-MM-dd HHmmss") + ".csv";

                string sourcePath = @"S:\PlanningReleases\" + _customer;
                string targetPath = @"S:\PlanningReleases\" + _customer + @"\History";

                string sourceFile = Path.Combine(sourcePath, fileName);
                string destFile = Path.Combine(targetPath, fileNameNew);

                // Create a new target folder if necessary
                if (!Directory.Exists(targetPath))
                {
                    Directory.CreateDirectory(targetPath);
                }
                File.Move(sourceFile, destFile);
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(error, "Error at RenameFile()");
            }
        }

        private void ClearForm()
        {
            tbxRelease.Text = tbxDestination.Text = "";
            lvwImportedData.Items.Clear();
            //lbxExceptions.Items.Clear();
            _firstRow = true;
            _datesRow = false;
        }
        
        #endregion


    }
}
