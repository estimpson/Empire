﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RmaMaintenance.Model;
using RmaMaintenance.Controls;
using RmaMaintenance.DataModels;
using System.Data.Entity;

namespace RmaMaintenance.Controllers
{
    public class NewRmaCreateController
    {
        #region Class Objects

        private readonly MONITOREntities _context;
        private readonly Messages _messages;
        
        private SerialQuantityDataModel _serialQuantityDataModel;
        public List<SerialQuantityDataModel> SerialsList = new List<SerialQuantityDataModel>();

        //private SerialQuantityFromRmaDataModel _serialQuantityFromRmaDataModel;
        //public List<SerialQuantityFromRmaDataModel> SerialsFromRmaList = new List<SerialQuantityFromRmaDataModel>();

        private NewShippersDataModel _newShippersDataModel;
        public List<NewShippersDataModel> NewShippersList = new List<NewShippersDataModel>();

        #endregion


        #region Constructor

        public NewRmaCreateController()
        {
            _context = new MONITOREntities();
            _messages = new Messages();
        }

        #endregion


        #region Methods

        public List<string> GetDestinations(out string error)
        {
            error = "";

            try
            {
                _context.vw_CreateRma_Destinations.OrderBy(d => d.destination).Load();
                if (!_context.vw_CreateRma_Destinations.Any()) return null;

                var destsList = _context.vw_CreateRma_Destinations.Local.Select(item => item.destination).ToList();
                destsList.Insert(0, "");
                return destsList;
            }
            catch (Exception ex)
            {
                //error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                error = "Failed to return destinations list.  Error at GetDestinations().";
            }
            return null;
        }

        public int ImportDataFromSpreadsheet()
        {
            SerialsList.Clear();

            try
            {
                var format = DataFormats.CommaSeparatedValue;

                // Read the CSV
                var dataObject = Clipboard.GetDataObject();
                var stream = (System.IO.Stream)dataObject.GetData(format);
                if (stream == null)
                {
                    _messages.Message = "Please copy spreadsheet data.";
                    _messages.ShowDialog();
                    return 0;
                }
                var encoding = new System.Text.UTF8Encoding();
                var reader = new System.IO.StreamReader(stream, encoding);
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
                    
                    _serialQuantityDataModel = new SerialQuantityDataModel {Serial = iSerial, Quantity = iQuantity};
                    SerialsList.Add(_serialQuantityDataModel);
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Error at ImportDataFromSpreadsheet: {0}  Make sure each serial has a quantity.", error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int DeleteOldSerialsQuantities()
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_CreateRma_DeleteSerialsQuantities(dt, result);
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Failed to delete old RMA serials.  Nothing was processed.  Error: {0}", error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int ImportDataIntoSql(int serial, decimal quantity)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_CreateRma_ImportSerialsQuantities(serial, quantity, dt, result);
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Failed to insert serial {0} into the database.  Nothing was processed.  Error: {1}", serial, error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetSerialsFromPartDest(string operatorCode, string destination, string part, decimal quantity)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_CreateRma_GetSerialsFromPartDest(operatorCode, destination, part, quantity, dt, result);

                 var query = from s in _context.SerialsQuantitiesToAutoRMA_RTV
                            select s;

                foreach (var item in query)
                {
                    _serialQuantityDataModel = new SerialQuantityDataModel
                        {
                            Serial = item.Serial, 
                            Quantity = item.Quantity
                        };
                    SerialsList.Add(_serialQuantityDataModel);
                }

                _messages.Message = "Success.";
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("RMA was not created.  Error: {0}", error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int ProcessData(string operatorCode, string rmaNumber, int createRtvShipper, int placeSerialsOnHold)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                var query = _context.usp_CreateRma_ProcessByDestGl(operatorCode, rmaNumber, createRtvShipper, placeSerialsOnHold, dt, result);

                foreach (var item in query)
                {
                    _newShippersDataModel = new NewShippersDataModel
                        {
                            RmaShipper = (item.RmaShipper == null) ? "" : item.RmaShipper.ToString(),
                            RtvShipper = (item.RtvShipper == null) ? "" : item.RtvShipper.ToString()
                        };

                    NewShippersList.Add(_newShippersDataModel);
                }

                string resultMessage = (createRtvShipper == 1)
                                           ? "Success.  Highlight a row to ship a RTV or to transfer serials."
                                           : "Success.";

                _messages.Message = resultMessage;
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Failed to create RMA.  Error: {0}", error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int ShipRtvHondurasRma(string operatorCode, int rtvShipper, string location)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_ShipRtv(operatorCode, rtvShipper, location, dt, result);
                if (Convert.ToInt32(result.Value) == 100) return 1;

                _messages.Message = string.Format("Success.  Shipped out RTV {0}.", rtvShipper.ToString());
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Failed to ship out RTV {0}.  Error: {1}", rtvShipper.ToString(), error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;
        }

        public void RemoveShippedOutRtvFromList(string rtvShipper)
        {
            NewShippersList.RemoveAll(_newShippersDataModel => _newShippersDataModel.RtvShipper == rtvShipper);
        }

        public int CreateHondurasRma(string opCode, int rtvShipper, string location)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_CreateRma_Honduras(opCode, rtvShipper, location, dt, result);
                _messages.Message = "Success.  Created Honduras RMA.";
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = string.Format("Failed to create Honduras RMA.  Error: {0}", error);
                _messages.ShowDialog();
                return 0;
            }
            return 1;


            //string error = "";
            ////string connString = "Server=eehsql1;Database=Monitor;Trusted_Connection=Yes;";
            //string connString = "Initial Catalog=Monitor;Data Source=eehsql1;Integrated Security=SSPI;";
            //int result = 0;

            //opCode = "5555";

            //using (var sqlConnection = new SqlConnection(connString))
            //{
            //    using (var cmd = new SqlCommand())
            //    {
            //        try
            //        {
            //            cmd.CommandText = "eehsql1.eeh.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation";
            //            cmd.CommandType = CommandType.StoredProcedure;
            //            //cmd.Parameters.AddWithValue("@OperatorPWD", opCode);
            //            //cmd.Parameters.AddWithValue("@ShipperID", rtvShipper);
            //            //cmd.Parameters.AddWithValue("@LocationCode", location);
            //            //cmd.Parameters.AddWithValue("@Result", result);
            //            cmd.Parameters.Add("@OperatorPWD", SqlDbType.VarChar).Value = opCode;
            //            cmd.Parameters.Add("@ShipperID", SqlDbType.Int).Value = rtvShipper;
            //            cmd.Parameters.Add("@LocationCode", SqlDbType.VarChar).Value = location;
            //            cmd.Parameters.Add("@Result", SqlDbType.Int).Value = result;
            //            cmd.Parameters["@Result"].Direction = ParameterDirection.Output;
            //            //cmd.Parameters.Add("@Result", SqlDbType.Int).Direction = ParameterDirection.Output;

            //            cmd.Connection = sqlConnection;
            //            sqlConnection.Open();
            //            cmd.ExecuteNonQuery();

            //            _messages.Message = "Success - created Honduras RMA.";
            //            _messages.ShowDialog();
            //        }
            //        catch (Exception ex)
            //        {
            //            error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            //            _messages.Message = String.Format("Failed to RMA to Honduras location {0}.  Error: {1}", location, error);
            //            _messages.ShowDialog();
            //        }
            //    }
            //}
            //return (error == "") ? 1 : 0;
        }

        public int TransferHondurasLocation(string opCode, int rtvShipper, string toLoc)
        {
            string error = "";
            //string connString = "Server=eehsql1;Database=Monitor;Trusted_Connection=Yes;";
            string connString = "Initial Catalog=Monitor;Data Source=eehsql1;Integrated Security=SSPI;";

            opCode = "5555";

            using (var sqlConnection = new SqlConnection(connString))
            {
                using (var cmd = new SqlCommand())
                {
                    try
                    {
                        cmd.CommandText = "dbo.usp_TransferRTVSerials";
                        cmd.CommandType = CommandType.StoredProcedure;
                        //cmd.Parameters.AddWithValue("@OperatorPWD", opCode);
                        //cmd.Parameters.AddWithValue("@ShipperID", rtvShipper);
                        //cmd.Parameters.AddWithValue("@LocationCode", location);
                        //cmd.Parameters.AddWithValue("@Result", result);
                        cmd.Parameters.Add("@OperatorCode", SqlDbType.VarChar).Value = opCode;
                        cmd.Parameters.Add("@RtvShipper", SqlDbType.Int).Value = rtvShipper;
                        cmd.Parameters.Add("@Location", SqlDbType.VarChar).Value = toLoc;
                        cmd.Parameters.Add("@Result", SqlDbType.Int).Value = null;
                        cmd.Parameters.Add("@TranDT", SqlDbType.DateTime).Value = null;

                        cmd.Connection = sqlConnection;
                        sqlConnection.Open();
                        cmd.ExecuteNonQuery();

                        _messages.Message = "Success.";
                        _messages.ShowDialog();
                    }
                    catch (Exception ex)
                    {
                        error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                        _messages.Message = String.Format("Failed to transfer RTV serials to Honduras location {0}.  Error: {1}", toLoc, error);
                        _messages.ShowDialog();
                    }
                }
            }
            return (error == "") ? 1 : 0;
        }

        public int TransferRmaSerials(string operatorCode, int rmaShipper, string location)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            string error = "";

            try
            {
                _context.usp_CreateRma_TransferOnHoldSerials(operatorCode, rmaShipper, location, dt, result);
                _messages.Message = "Success.";
                _messages.ShowDialog();
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messages.Message = String.Format("Failed to transfer RMA serials.  Error: {0}", error);
                _messages.ShowDialog();
            }
            return (error == "") ? 1 : 0;
        }

        #endregion
    
    
    }
}
