using System;
using System.Data;
using System.Data.Objects;
using System.Data.SqlClient;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class TransferInventoryController
    {
        #region Methods

        public void TransferRmaSerials(string operatorCode, int rmaShipper, string location, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));
            
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.usp_CreateRma_TransferOnHoldSerials(operatorCode, rmaShipper, location, dt, result);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null) 
                    ? "Failed to transfer RMA serials.  Error: " + ex.Message 
                    : "Failed to transfer RMA serials.  Error: " + ex.InnerException.Message;
            }
        }

        public void TransferHondurasLocation(string opCode, int rtvShipper, string toLoc, out string error)
        {
            error = "";
            //string connString = "Server=eehsql1;Database=Monitor;Trusted_Connection=Yes;";
            const string CONN_STRING = "Initial Catalog=Monitor;Data Source=eehsql1.empireelect.local;Integrated Security=SSPI;";

            opCode = "5555";

            using (var sqlConnection = new SqlConnection(CONN_STRING))
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
                    }
                    catch (Exception ex)
                    {
                        string errMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                        error = String.Format("Failed to transfer RTV serials to Honduras location {0}.  Error: {1}", toLoc, errMsg);
                    }
                }
            }
        }

        #endregion


    }
}
