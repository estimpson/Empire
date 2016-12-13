using System;
using System.Data.Objects;
using ImportSpreadsheetData.Model;


namespace ImportSpreadsheetData.DataLayer
{
    public class CheckDestination
    {
        #region Class Objects

        private readonly MONITOREntities _context;

        #endregion


        #region Constructor

        public CheckDestination()
        {
            _context = new MONITOREntities();
        }

        #endregion


        #region Methods

        public void CheckDestinationAgainstCustomer(string customer, string destination, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_PlanningReleaseManualImport_CheckDestination(customer, destination, tranDt, result);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion
    }
}
