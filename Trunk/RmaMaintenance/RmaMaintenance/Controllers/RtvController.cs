using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.Model;
using RmaMaintenance.Views;

namespace RmaMaintenance.Controllers
{
    public class RtvController
    {
        private NewRtvView _myControl;

        public string OperatorCode { get; set; }
        public bool IsCurrentRtvOpen { get; set; }
        public bool IsCurrentRtvPrinted { get; set; }
        public string CurrentRTV { get; set; }
        public string HnLocation { get; set; }
        public string SerialStringList { get; set; }
        public List<InventoryToRTV> SerialsList = new List<InventoryToRTV>();
        public List<OpenRTV> OpenRTVList = new List<OpenRTV>();
        public string Instructions { get; set; }
        public string Warnings { get; set; }

        public void SetView(NewRtvView myControl)
        {
            _myControl = myControl;
            _myControl.OperatorCode = OperatorCode;
        }

        public int ClearSerialsList()
        {
            SerialsList.Clear();
            return 1;
        }

        public int ImportDataFromSpreadsheet()
        {
            try
            {
                SerialsList.Clear();
                var format = DataFormats.CommaSeparatedValue;

                // Read the CSV
                var dataObject = Clipboard.GetDataObject();
                Debug.Assert(dataObject != null, "dataObject != null");
                var stream = (Stream)dataObject.GetData(format);
                if (stream == null)
                {
                    Warnings = "Please copy spreadsheet data.";
                    return 0;
                }
                var encoding = new UTF8Encoding();
                var reader = new StreamReader(stream, encoding);
                var data = reader.ReadToEnd();

                var rows = data.Split('\r');

                // Loop through spreadsheet rows
                using (var context = new MONITOREntities())
                {
                    SerialsList.Clear();

                    foreach (var serial in from row in rows.Select(rowRaw => rowRaw.Replace("\n", "")).TakeWhile(row => row != "\0")
                        let importSerial = row.Split(',')[0]
                        let serial = Convert.ToInt32(importSerial)
                        select serial)
                    {
                        context.InventoryToRTVs.Find(serial);
                    }

                    SerialsList.AddRange(context.InventoryToRTVs.Local.ToList());
                }
            }
            catch (Exception ex)
            {
                var error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                Warnings =
                    String.Format("Error at ImportDataFromSpreadsheet: {0}  Make sure each serial has a quantity.",
                        error);
                return -1;
            }
            return 1;
        }

        public int RefreshOpenRTVList()
        {
            try
            {
                using (var context = new MONITOREntities())
                {
                    OpenRTVList.Clear();

                    OpenRTVList.AddRange(context.OpenRTVs.ToList());
                }
            }
            catch (Exception ex)
            {
                var error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                Warnings =
                    String.Format("Error at ImportDataFromSpreadsheet: {0}  Make sure each serial has a quantity.",
                        error);
                return -1;
            }
            return 1;
        }
    }
}