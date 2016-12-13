using System;
using System.Data.Objects;
using ImportSpreadsheetData.Model;

namespace ImportSpreadsheetData.DataLayer
{
    public class ImportDataSUS
    {
        #region Class Objects

        private readonly MONITOREntities_SUS _context;

        #endregion


        #region Constructor

        public ImportDataSUS()
        {
            _context = new MONITOREntities_SUS();
        }

        #endregion


        #region Methods

        public void Import(string customerPart, string part, string destination, decimal quantity, DateTime dueDate, string release, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_Stage_2_ManualImport(release, customerPart, part, destination, quantity, dueDate, tranDt, result);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void ResetImport(string release, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_DeleteRecords_ManualImport(release, tranDt, result);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void Process(string destination, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            try
            {
                _context.usp_Process_ManualImport(destination, tranDt, result, 0, 0);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}
