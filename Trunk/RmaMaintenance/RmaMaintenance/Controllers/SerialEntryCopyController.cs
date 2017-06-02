using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class SerialEntryCopyController
    {
        #region Class Objects

        private SerialQuantityDataModel _serialQuantityDataModel;
        public List<SerialQuantityDataModel> SerialsList = new List<SerialQuantityDataModel>();

        #endregion


        #region Methods

        public void GetSpreadsheetData(out string error)
        {
            SerialsList.Clear();

            error = "";
            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the Clipboard
                var dataObject = Clipboard.GetDataObject();
                Debug.Assert(dataObject != null, "dataObject != null");
                var stream = (Stream)dataObject.GetData(format);
                
                if (stream == null) error = "Please copy spreadsheet data.";
                
                var encoding = new UTF8Encoding();
                var reader = new StreamReader(stream, encoding);
                string data = reader.ReadToEnd();

                var rows = data.Split('\r');

                // Loop through spreadsheet rows
                foreach (var rowRaw in rows)
                {
                    var row = rowRaw.Replace("\n", "");
                    if (row == "\0") break;

                    string serial = row.Split(',')[0];
                    string quantity = row.Split(',')[1];

                    int iSerial = Convert.ToInt32(serial);
                    int iQuantity = Convert.ToInt32(quantity);

                    _serialQuantityDataModel = new SerialQuantityDataModel { Serial = iSerial, Quantity = iQuantity };
                    SerialsList.Add(_serialQuantityDataModel);
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                if (error == "") error = String.Format("Make sure each serial has a quantity.  Error at GetSpreadsheetData: {0}  ", errorMsg);    
            }
        }

        public void DeleteOldSerialsQuantities(string operatorCode, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_DeleteSerialsQuantitiesByOperator(operatorCode, dt, result);
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
               error = String.Format("Failed to delete old RMA serials.  Nothing was processed.  Error: {0}", errorMsg);
            }
        }

        public void ImportDataIntoSql(string operatorCode, int serial, decimal quantity, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_ImportSerialsQuantitiesByOperator(operatorCode, serial, quantity, dt, result);
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                error = String.Format("Nothing has been processed.  {0}", errorMsg);
            }
        }

        #endregion


    }
}
