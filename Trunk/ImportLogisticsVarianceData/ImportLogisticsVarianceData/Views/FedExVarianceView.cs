using System;
using System.Data.Objects;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using ImportLogisticsVarianceData.Controls;
using Microsoft.VisualBasic.FileIO;
using ImportLogisticsVarianceData.Model;

namespace ImportLogisticsVarianceData.Views
{
    public partial class FedExVarianceView : Form
    {
        #region Class Objects

        private readonly CustomMessageBox _messageBox;

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public FedExVarianceView(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;

            _messageBox = new CustomMessageBox();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
        }

        #endregion


        #region LinkButton Events

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
            linkLblClose.LinkColor = Color.RoyalBlue;
        }

        #endregion


        #region Button Events

        private void mesBtnImport_MouseDown(object sender, MouseEventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void mesBtnImport_Click(object sender, EventArgs e)
        {
            Import();
            Cursor.Current = Cursors.Default;
        }

        #endregion


        #region Methods

        private void Import()
        {
            //if (LocateFile() == 0) return;

            if (DeleteRawData() == 0) return;

            if (ImportRawData() == 0) return;

            //if (ProcessData() == 0) return;

            //RenameFile();            
        }

        private int DeleteRawData()
        {
            var con =
               new SqlConnection(
                   "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("DELETE FROM FedEx.VarianceRawDataTemp",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed.  Could not clear old data.  Exception thrown at DeleteRawData().  " + error;
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

        private int ImportRawData()
        {
            int methodResult = 1;
            bool isHeader = false;

            //var parser = new TextFieldParser(@"S:\LogisticsVariance\FedEx\FedExVariance.csv") {HasFieldsEnclosedInQuotes = true};
            var parser = new TextFieldParser(@"C:\test\FedExVariance3.csv") { HasFieldsEnclosedInQuotes = true };
            parser.SetDelimiters(",");

            try
            {
                while (!parser.EndOfData)
                {
                    string newRow = "";

                    string[] fields = parser.ReadFields();
                    foreach (var field in fields)
                    {
                        if (field == "Bill to Account Number")
                        {
                            isHeader = true;
                            break;
                        }

                        // Handle any single quotes
                        string editedField = field.Replace("'", "''");

                        string newField = "'" + editedField + "',";
                        newRow += newField;
                    }

                    if (isHeader)
                    {
                        isHeader = false;
                        continue;
                    }

                    // End of string correction
                    int stringLength = newRow.Length;
                    newRow = newRow.Remove(stringLength - 1, 1);

                    // Insert row into the raw data table
                    int result = InsertRawData(newRow);
                    if (result == 0) return 0;
                }
            }
            catch (Exception ex)
            {
                methodResult = 0;

                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to import raw data.  {0}", error);
                _messageBox.ShowDialog();
            }
            finally
            {
                parser.Close();
            }

            return methodResult;
        }

        private int InsertRawData(string values)
        {
            var con =
               new SqlConnection(
                   "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("INSERT INTO FedEx.VarianceRawDataTemp " +
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
                _messageBox.Message = "Import failed.  Exception thrown at InsertRawData().  " + error;
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

        private int ProcessData()
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_Variance_InsertFromRaw(_operatorCode, dt, result);
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                string error = String.Format("Failed to process the imported raw data.  Exception at ProcessData().  Error: {0}", errorMsg);
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }







        private int ImportRates()
        {
            int methodResult = 1;
            bool isHeader = false;

            var parser = new TextFieldParser(@"C:\test\FedExRates.csv") { HasFieldsEnclosedInQuotes = true };
            parser.SetDelimiters(",");

            try
            {
                while (!parser.EndOfData)
                {
                    string newRow = "";
                    //bool firstCell = true;

                    string[] fields = parser.ReadFields();
                    foreach (var field in fields)
                    {
                        if (field == "International Export Priority Freight - Door to Door" || field == "Weight (in Lbs)" || field == "151 - 299" ||
                            field == "300 - 499" || field == "500 - 999" || field == "1000 - 1999" ||
                            field == "2000 - 2999" || field == "Exceed")
                        {
                            isHeader = true;
                            break;
                        }

                        string newField = "'" + field + "',";
                        newRow += newField;
                    }

                    if (isHeader)
                    {
                        isHeader = false;
                        continue;
                    }

                    // Remove the last comma
                    int stringLength = newRow.Length;
                    newRow = newRow.Remove(stringLength - 1, 1);

                    // Insert row into the raw data table
                    int result = InsertRates(newRow);
                    if (result == 0) return 0;
                }
            }
            catch (Exception ex)
            {
                methodResult = 0;

                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to import raw data.  {0}", error);
                _messageBox.ShowDialog();
            }
            finally
            {
                parser.Close();
            }

            return methodResult;
        }

        private int InsertRates(string values)
        {
            var con =
               new SqlConnection(
                   "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("INSERT INTO FedEx.IP_Rates (Weight, ZoneA, ZoneB, ZoneC, ZoneD, ZoneE, ZoneF, ZoneG, ZoneH, ZoneI, ZoneJ, ZoneK, ZoneL, ZoneM, ZoneN, ZoneO) " +
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
                _messageBox.Message = "Import failed.  Exception thrown at InsertRates().  " + error;
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








        private int LocateFile()
        {
            string folderPathImport = @"S:\LogisticsVariance\FedEx";
            string filePath = @"S:\LogisticsVariance\FedEx\FedExVariance.csv";

            if (!Directory.Exists(folderPathImport))
            {
                MessageBox.Show("Folder path " + folderPathImport + " was not found.  Cannot process releases.", "Error");
                return 0;
            }
            if (!File.Exists(filePath))
            {
                _messageBox.Message = string.Format("A file named FedExVariance.csv was not found in {0}.  Cannot import data.", folderPathImport);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private void RenameFile()
        {
            try
            {
                string fileName = "FedExVariance.csv";
                string fileNameNew = "FedExVariance_" + DateTime.Now.ToString("yyyy-MM-dd HHmmss") + ".csv";

                string sourcePath = @"S:\LogisticsVariance\FedEx";
                string targetPath = @"S:\LogisticsVariance\FedEx\History";

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
                _messageBox.Message = string.Format("Error when attempting to rename / move the file.  {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


    }
}
