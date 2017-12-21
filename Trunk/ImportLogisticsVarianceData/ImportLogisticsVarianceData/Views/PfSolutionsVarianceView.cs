using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ImportLogisticsVarianceData.Controls;
using System.IO;
using System.Data.SqlClient;
using Microsoft.VisualBasic.FileIO;
using System.Data.Objects;
using ImportLogisticsVarianceData.Model;

namespace ImportLogisticsVarianceData.Views
{
    public partial class PfSolutionsVarianceView : Form
    {
        #region Class Objects

        private readonly CustomMessageBox _messageBox;

        #endregion


        #region Properties

        private string _status;
        public string Status
        {
            get { return _status; }
            set
            {
                _status = value;
                ToggleStatusLabel();
            }
        }

        #endregion


        #region Variables

        private readonly string _operatorCode;

        #endregion


        #region Constructor

        public PfSolutionsVarianceView(string operatorCode)
        {
            InitializeComponent();

            _operatorCode = operatorCode;
            _messageBox = new CustomMessageBox();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            lblProcessing.Visible = false;
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
            Status = StatusEnums.Processing.ToString();
        }

        private void mesBtnImport_Click(object sender, EventArgs e)
        {
            Import();
        }

        #endregion


        #region Methods

        private void Import()
        {
            if (LocateFile() == 0)
            {
                Status = StatusEnums.Failure.ToString();
                return;
            }
            if (DeleteRawData() == 0)
            {
                Status = StatusEnums.Failure.ToString();
                return;
            }
            if (ImportRawData() == 0)
            {
                Status = StatusEnums.Failure.ToString();
                return;
            }
            if (ProcessData() == 0)
            {
                Status = StatusEnums.Failure.ToString();
                return;
            }

            RenameFile();
            Status = StatusEnums.Success.ToString();
            return;
        }

        private int LocateFile()
        {
            string folderPathImport = @"S:\LogisticsVariance\PFSolutions";
            string filePath = @"S:\LogisticsVariance\PFSolutions\PFSolutionsVariance.csv";

            if (!Directory.Exists(folderPathImport))
            {
                _messageBox.Message = string.Format("Folder path {0} was not found.  Cannot import data.", folderPathImport);
                _messageBox.ShowDialog();
                return 0;
            }
            if (!File.Exists(filePath))
            {
                _messageBox.Message = string.Format("A file named PFSolutionsVariance.csv was not found in {0}.  Cannot import data.", folderPathImport);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        private int DeleteRawData()
        {
            var con =
               new SqlConnection(
                   "data source=eeisql1.empireelect.local;initial catalog=MONITOR;persist security info=True;user id=Andre");

            try
            {
                var command = new SqlCommand("DELETE FROM PFS.VarianceRawDataTemp",
                                             con);

                con.Open();
                command.ExecuteNonQuery();
                command.Dispose();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = "Import failed at DeleteRawData().  Could not clear old data.  " + error;
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

            var parser = new TextFieldParser(@"S:\LogisticsVariance\PFSolutions\PFSolutionsVariance.csv") { HasFieldsEnclosedInQuotes = true };
            //var parser = new TextFieldParser(@"C:\test\PFSolutions.csv") { HasFieldsEnclosedInQuotes = true };
            parser.SetDelimiters(",");

            try
            {
                while (!parser.EndOfData)
                {
                    string newRow = "";

                    string[] fields = parser.ReadFields();
                    foreach (var field in fields)
                    {
                        if (field == "Load")
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
                var command = new SqlCommand("INSERT INTO PFS.VarianceRawDataTemp " +
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
                    context.usp_Variance_InsertPfsFromRaw(_operatorCode, dt, result);
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

        private void RenameFile()
        {
            try
            {
                string fileName = "PFSolutionsVariance.csv";
                string fileNameNew = "PFSolutionsVariance_" + DateTime.Now.ToString("yyyy-MM-dd HHmmss") + ".csv";

                string sourcePath = @"S:\LogisticsVariance\PFSolutions";
                string targetPath = @"S:\LogisticsVariance\PFSolutions\History";

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

        private void ToggleStatusLabel()
        {
            switch (_status)
            {
                case "Processing":
                    lblProcessing.Text = "Processing ...";
                    lblProcessing.Visible = true;
                    break;
                case "Success":
                    lblProcessing.Text = "Complete.";
                    break;
                case "Failure":
                    lblProcessing.Visible = false;
                    break;
            }
        }

        #endregion


    }
}
