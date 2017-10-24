using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Objects;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class ShipoutRmaRtvController
    {
        #region Class Objects

        private NewShippersDataModel _newShippersDataModel;
        public List<NewShippersDataModel> NewShippersList = new List<NewShippersDataModel>();

        #endregion


        #region Methods

        public List<string> GetShipperSerials(int shipper, out string error)
        {
            List<string> serialsList = new List<string>();
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    var query = context.usp_GetLabelCode_RmaMaintenance_Serials(shipper);
                    foreach (var item in query)
                    {
                        serialsList.Add(item.Serial.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
            return serialsList;
        }

        public string GetLabelCode(int serial, out string error)
        {
            var labelCode = new ObjectParameter("LabelCode", typeof(string));
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_GetLabelCode_RmaMaintenance(serial, labelCode);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
            return labelCode.Value.ToString();
        }

        public void ShipRtvHondurasRma(string operatorCode, int rtvShipper, string location, out bool previouslyShipped, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            previouslyShipped = false;
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_ShipRtv(operatorCode, rtvShipper, location, dt, result);
                    if (Convert.ToInt32(result.Value) == 100) previouslyShipped = true;
                }
            }
            catch (Exception ex)
            {
                string errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                error = String.Format("Failed to ship out RTV {0}.  Error: {1}", rtvShipper.ToString(), errorMsg);
            }
        }

        public void RemoveShippedOutRtvFromList(string rtvShipper)
        {
            NewShippersList.RemoveAll(newShippersDataModel => newShippersDataModel.RtvShipper == rtvShipper);
        }

        public void CheckHondurasConnection(out int? objectCount, out string error)
        {
            error = "";
            objectCount = 0;
            const string CONN_STRING = "Server=eehsql1;Database=EEH;User ID=sa;";

            try
            {
                using (var sqlConnection = new SqlConnection(CONN_STRING))
                {
                    sqlConnection.Open();

                    using (var cmd = new SqlCommand("select count(1) from dbo.object", sqlConnection))
                    {
                        objectCount = (int)(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception)
            {
                // Do nothing
            }
        }

        public void CreateHondurasRma(string opCode, int rtvShipper, string location, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_Honduras(opCode, rtvShipper, location, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }

        public void SendEmail(string opCode, string rmaRtvNumber, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreatedRmaRtvEmail(opCode, rmaRtvNumber, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }

        public void SendExistingRtvEmail(string opCode, string shipper, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_ShippedOutExistingRtvEmail(opCode, shipper, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }

        public void RecordHondurasRmaException(string opCode, string exception, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_Honduras_RecordException(opCode, exception, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
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
                error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
            }
        }
        
        #endregion


    }
}
