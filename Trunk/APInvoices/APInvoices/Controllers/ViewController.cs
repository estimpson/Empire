#region Using

using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using APInvoices.DataLayer.ModelViews;
using APInvoices.Views;

#endregion

namespace APInvoices.Controllers
{
    public class ViewController
    {
        private readonly ApHeaderBarcodesView _myView;

        private readonly ApHeaderBarcodesModelView _barcodesModelView;
        private readonly XmlModelView _xmlModelView;


        #region Construction

        public ViewController(ApHeaderBarcodesView myView, ApHeaderBarcodesModelView barcodesModelView, XmlModelView xmlModelView)
        {
            _myView = myView;
            _barcodesModelView = barcodesModelView;
            _xmlModelView = xmlModelView;
        }

        #endregion


        #region Print Methods

        public void GetApHeaderData()
        {
            string error;

            _barcodesModelView.GetApHeaderData(out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetApHeaderData()";
                _myView.ErrorMessage = "Failed to return vendor invoice data:  " + error;
            }
            if (_barcodesModelView.ApHeaderBarcodesList.Any())
            {
                _myView.BarcodesList = _barcodesModelView.ApHeaderBarcodesList;
            }
        }

        public void Print()
        {
            if (GetXmlConfigurationData()) PrintLabels();
        }

        private void PrintLabels()
        {
            const string COPIES = "1";

            foreach (var item in _myView.BarcodesList)
            {
                try
                {
                    using (var process = new Process())
                    {
                        process.StartInfo.FileName = _xmlModelView.BartenderPath;
                        process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

                        process.StartInfo.Arguments = @" /PRN=""" + _xmlModelView.PrinterPort + @""" /F=""" + _xmlModelView.LabelPath + @""" /?RowId=" + item.RowId + @" /C=" + COPIES + @" /P /RUN /X";

                        process.Start();
                        process.WaitForExit(); // Wait here for the process to exit

                        // Update invoice status as printed
                        UpdateApHeaderData(item.RowId);
                    }
                }
                catch (Exception ex)
                {
                    string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                    _myView.ErrorMethod = "Error at PrintLabels()";
                    _myView.ErrorMessage = error;
                }
            }
        }

        private void UpdateApHeaderData(int rowId)
        {
            string error;
            
            _barcodesModelView.UpdateApHeaderData(rowId, out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at UpdateApHeaderData()";
                _myView.ErrorMessage = error;
            }
        }

        #endregion


        #region Reprint Methods

        public void GetPrintedVendors()
        {
            string error;
            
            _barcodesModelView.GetPrintedVendors(out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetPrintedVendors()";
                _myView.ErrorMessage = "Failed to return vendor list for reprinting barcodes:  " + error;
            }
            if (_barcodesModelView.VendorsList.Any())
            {
                _myView.VendorsReprintList = _barcodesModelView.VendorsList;
            }
        }

        public void GetPrintedCmFlags(string vendor)
        {
            string error;

            _barcodesModelView.GetPrintedCmFlags(vendor, out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetPrintedCmFlags()";
                _myView.ErrorMessage = "Failed to return CM Flag list:  " + error;
            }
            if (_barcodesModelView.FlagsList.Any())
            {
                _myView.FlagsReprintList = _barcodesModelView.FlagsList;
            }
        }

        public void GetPrintedInvoices(string vendor, string flag)
        {
            string error;

            _barcodesModelView.GetPrintedInvoices(vendor, flag, out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetPrintedInvoices()";
                _myView.ErrorMessage = "Failed to return invoice list:  " + error;
            }
            if (_barcodesModelView.InvoicesList.Any())
            {
                _myView.InvoicesReprintList = _barcodesModelView.InvoicesList;
            }
        }

        public void Reprint(string vendor, string flag, string invoice)
        {
            if (_xmlModelView.BartenderPath == "")
            {
                if (GetXmlConfigurationData())
                {
                    int rowId = GetRowId(vendor, flag, invoice);
                    if (rowId > 0) ReprintLabel(rowId);
                }   
            }
        }

        private int GetRowId(string vendor, string flag, string invoice)
        {
            string error;

            int rowId = _barcodesModelView.GetRowId(vendor, flag, invoice, out error);
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetRowId()";
                _myView.ErrorMessage = "Failed to return the ID of this record.  Cannot reprint:  " + error;
            }
            else if (rowId == 0)
            {
                _myView.ErrorMethod = "GetRowId()";
                _myView.ErrorMessage = "Could not find an ID matching this record.  Cannot reprint:  " + error;
            }
            return rowId;
        }

        private void ReprintLabel(int rowId)
        {
            const string COPIES = "1";

            try
            {
                using (var process = new Process())
                {
                    process.StartInfo.FileName = _xmlModelView.BartenderPath;
                    process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

                    process.StartInfo.Arguments = @" /PRN=""" + _xmlModelView.PrinterPort + @""" /F=""" + _xmlModelView.LabelPath + @""" /?RowId=" + rowId + @" /C=" + COPIES + @" /P /RUN /X";

                    process.Start();
                    process.WaitForExit(); // Wait here for the process to exit
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _myView.ErrorMethod = "Error at ReprintLabel()";
                _myView.ErrorMessage = error;
            }
        }

        #endregion


        #region Printing Crossover Methods

        private bool GetXmlConfigurationData()
        {
            string error = _xmlModelView.GetXmlConfigurationData();
            if (error != "")
            {
                _myView.ErrorMethod = "Error at GetXmlConfigurationData()";
                _myView.ErrorMessage = error;
                return false;
            }
            return true;
        }

        #endregion


        #region Filing Methods

        public void MoveScannedInvoices()
        {
            string[] filePaths = Directory.GetFiles(@"\\SRVDATA1\Data\ACCTNG\Accounts Payable\Invoices\Scans", "*.pdf");

            if (!filePaths.Any())
            {
                _myView.ErrorMethod = "Alert";
                _myView.ErrorMessage = "There are no scanned invoices to move.";
                return;
            }

            foreach (var sourceFilePath in filePaths)
            {
                string destFilePath = GetDestinationFilePath(sourceFilePath);

                try
                {
                    if (!File.Exists(destFilePath)) File.Move(sourceFilePath, destFilePath);
                }
                catch (Exception ex)
                {
                    string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                    _myView.ErrorMethod = "Error at MoveScannedInvoices()";
                    _myView.ErrorMessage = error; 
                }
            }
        }

        private string GetDestinationFilePath(string sourceFilePath)
        {
            string fileName = Path.GetFileName(sourceFilePath);  // Filename = VendorCode_InvoiceNumber_Date
            if (fileName != null && fileName.Contains("_"))
            {
                string[] values = fileName.Split('_');
                if (values.Length == 3)
                {
                    string directory = @"\\SRVDATA1\Data\ACCTNG\Accounts Payable\Invoices\" + values[0];
                    Directory.CreateDirectory(directory);

                    return directory + values[0] + "\"" + fileName;
                }
            }
            return "";
        }

        #endregion


    }
}
