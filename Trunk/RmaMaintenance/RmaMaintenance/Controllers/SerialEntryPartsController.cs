using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Objects;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class SerialEntryPartsController
    {
        #region Class Objects

        private PartQuantityDataModel _partQuantityDataModel;
        public List<PartQuantityDataModel> PartsList = new List<PartQuantityDataModel>();

        private SerialQuantityDataModel _serialQuantityDataModel;
        public List<SerialQuantityDataModel> SerialsList = new List<SerialQuantityDataModel>();

        #endregion


        #region Methods

        public List<string> GetDestinations(out string error)
        {
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.vw_CreateRma_Destinations.OrderBy(d => d.destination).Load();
                    if (!context.vw_CreateRma_Destinations.Any()) return null;

                    var destsList = context.vw_CreateRma_Destinations.Local.Select(item => item.destination).ToList();
                    destsList.Insert(0, "");
                    return destsList;
                }
            }
            catch (Exception)
            {
                error = "Failed to return destinations list.  Error at GetDestinations().";
            }
            return null;
        }

        public void GetSpreadsheetData(out string error)
        {
            PartsList.Clear();

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

                    string part = row.Split(',')[0];
                    string quantity = row.Split(',')[1];
                    int iQuantity = Convert.ToInt32(quantity);

                    _partQuantityDataModel = new PartQuantityDataModel { Part = part, Quantity = iQuantity };
                    PartsList.Add(_partQuantityDataModel);
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                if (error == "") error = String.Format("Make sure each part has a quantity.  Error at GetSpreadsheetData: {0}  ", errorMsg);
            }
        }

        public void GetSerialsFromPartDest(string operatorCode, string destination, string part, decimal quantity, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_GetSerialsFromPartDest(operatorCode, destination, part, quantity, dt, result);

                    var query = from s in context.SerialsQuantitiesToAutoRMA_RTV
                                where s.OperatorCode == operatorCode 
                                select s;

                    foreach (var item in query)
                    {
                        _serialQuantityDataModel = new SerialQuantityDataModel
                        {
                            Serial = item.Serial,
                            Quantity = Math.Round(item.Quantity, 2)
                        };

                        // Querying the SerialsQuantitiesToAutoRMA_RTV table every time will duplicate List items,
                        //   so only add an item if it isn't already in the List.
                        if (!SerialsList.Any(x => x.Serial == item.Serial)) SerialsList.Add(_serialQuantityDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                error = String.Format("Failed to create serials for part {0}.  Error: {1}", part, errorMsg);
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
