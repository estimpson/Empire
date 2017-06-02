using System;
using System.Data.Objects;
using ImportCSM.Model;

namespace ImportCSM.DataAccess
{
    public class ProcessData
    {
        #region Constructor

        public ProcessData()
        {
        }

        #endregion


        #region Methods

        public void RollCsmForward(string priorRelease, string currentRelease, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.acctg_csm_sp_roll_forward_CSM_data_one_month(priorRelease, currentRelease, dt, res);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void Import(string currentRelease, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            const string VERSION = "CSM";
            error = "";

            try
            {
                using (var context = new MONITOREntities())
                {
                    context.acctg_csm_sp_import_CSM_demand(currentRelease, VERSION, dt, res);   
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void InsertOfficialForecast(string forecastName, DateTime dateTimeStamp, out string error)
        {
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.acctg_sales_sp_insert_official_forecast(forecastName, dateTimeStamp);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void InsertHistoricalSales(string forecastName, DateTime dateTimeStamp, DateTime startDate, DateTime endDate, out string error)
        {
            error = "";
            try
            {
                using (var context = new MONITOREntities())
                {
                    context.acctg_sales_sp_insert_historical_sales(forecastName, dateTimeStamp, startDate, endDate);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}
