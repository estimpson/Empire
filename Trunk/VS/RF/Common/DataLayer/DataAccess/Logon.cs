using System;
using System.Data.SqlClient;
using Connection;
using DataLayer.dsLogonTableAdapters;

namespace DataLayer.DataAccess
{
    public class Logon
    {
        public void ValidatePassword(string connectionString, string password, out string opName, out string opCode, out string error)
        {
            opName = "";
            opCode = "";
            error = "";
            try
            {
                using (var eta = new employeeTableAdapter())
                {
                    eta.Connection.ConnectionString = connectionString;
                    dsLogon.employeeDataTable edt = eta.GetData(password);

                    if (edt.Rows.Count > 0)
                    {
                        opName = edt[0].name;
                        opCode = edt[0].operator_code;
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.InnerException != null)
                {
                    error = "Sql Exception: " + ex.InnerException.ToString();
                }
                else
                {
                    error = "Sql Exception: " + ex.Message;
                }
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                {
                    error = "Exception: " + ex.InnerException.ToString();
                }
                else
                {
                    error = "Exception: " + ex.Message;
                }
            }
        }

    }
}
