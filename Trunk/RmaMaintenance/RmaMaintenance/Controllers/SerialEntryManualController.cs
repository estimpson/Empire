using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class SerialEntryManualController
    {
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


    }
}
