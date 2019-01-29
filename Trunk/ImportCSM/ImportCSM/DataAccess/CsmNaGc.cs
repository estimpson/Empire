using System;
using System.Data.Entity.Infrastructure;
using System.Data.Objects;
using ImportCSM.Model;

namespace ImportCSM.DataAccess
{
    public class CsmNaGc
    {
        #region Variables

        string _operatorCode;

        #endregion


        #region Constructor

        public CsmNaGc(string operatorCode)
        {
            _operatorCode = operatorCode;
        }

        #endregion


        #region Methods

        public void ValidateRelease(string currentRelease, string region, out string message, out string error)
        {
            var returnMessage = new ObjectParameter("Message", typeof(String));
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = message = "";

            try
            {
                using (var context = new MONITOREntitiesTest())
                {
                    context.acctg_csm_sp_validate_release(_operatorCode, currentRelease, region, returnMessage, dt, res);

                    message = returnMessage.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void CheckDateColumns(string currentRelease, out string message, out string error)
        {
            var returnMessage = new ObjectParameter("Message", typeof(String));
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = message = "";

            try
            {
                using (var context = new MONITOREntitiesTest())
                {
                    context.acctg_csm_sp_check_datecolumns(_operatorCode, currentRelease, returnMessage, dt, res);

                    message = returnMessage.Value.ToString();
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void ImportNa(string currentRelease, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = "";

            try
            {
                using (var context = new MONITOREntitiesTest())
                {
                    ((IObjectContextAdapter)context).ObjectContext.CommandTimeout = 300;
                    context.acctg_csm_sp_import_NA(_operatorCode, currentRelease, dt, res);
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void ImportGc(string currentRelease, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = "";

            try
            {
                using (var context = new MONITOREntitiesTest())
                {
                    ((IObjectContextAdapter)context).ObjectContext.CommandTimeout = 300;
                    context.acctg_csm_sp_import_GC(_operatorCode, currentRelease, dt, res);
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
