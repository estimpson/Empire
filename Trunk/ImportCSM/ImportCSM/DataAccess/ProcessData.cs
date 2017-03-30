using System;
using System.Data.Objects;
using ImportCSM.Model;

namespace ImportCSM.DataAccess
{
    public class ProcessData
    {
        #region Class Objects

        private readonly MONITOREntities _context;

        #endregion


        #region Constructor

        public ProcessData()
        {
            _context = new MONITOREntities();
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
                _context.acctg_csm_sp_roll_forward_CSM_data_one_month(priorRelease, currentRelease, dt, res);
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
                _context.acctg_csm_sp_import_CSM_demand(currentRelease, VERSION, dt, res);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}
