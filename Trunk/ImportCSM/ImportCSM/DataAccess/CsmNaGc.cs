using System;
using System.Data.Entity.Infrastructure;
using System.Data.Objects;
using ImportCSM.Model;

namespace ImportCSM.DataAccess
{
    public class CsmNaGc
    {
        #region Variables

        private string _operatorCode;

        #endregion


        #region Constructor

        public CsmNaGc()
        {
        }

        #endregion


        #region Methods

        public void ValidateOperator(string enteredOperatorCode, out string operatorName, out string  error)
        {
            var returnName = new ObjectParameter("OperatorName", typeof(String));
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = operatorName = "";

            try
            {
                using (var context = new MONITOREntities())
                {
                    context.acctg_csm_sp_validate_operator(enteredOperatorCode, returnName, dt, res);

                    operatorName = returnName.Value.ToString();
                    _operatorCode = enteredOperatorCode;
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void ValidateRelease(string currentRelease, string region, out string message, out string error)
        {
            var returnMessage = new ObjectParameter("Message", typeof(String));
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var res = new ObjectParameter("Result", typeof(Int32));
            error = message = "";

            try
            {
                using (var context = new MONITOREntities())
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
                using (var context = new MONITOREntities())
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
                using (var context = new MONITOREntities())
                {
                    ((IObjectContextAdapter)context).ObjectContext.CommandTimeout = 1200;
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
                using (var context = new MONITOREntities())
                {
                    ((IObjectContextAdapter)context).ObjectContext.CommandTimeout = 1200;
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
