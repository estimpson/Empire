using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class MainController
    {
        #region Class Objects

        private readonly MONITOREntities _context; 

        #endregion


        #region Constructor

        public MainController()
        {
            _context = new MONITOREntities();
        }

        #endregion


        #region Methods

        public void ValidateLogon(string operatorCode, string password, out string error)
        {
            error = "";
            try
            {
                _context.employees.Where(e => e.operator_code == operatorCode && e.password == password).Load();
                if (!_context.employees.Local.Any())
                {
                    error = "Operator code is invalid or password is incorrect.";
                }
            }
            catch (Exception ex)
            {
                error = "Failed to validate logon.  Please try again.";

                //error = (ex.InnerException == null)
                //    ? "Failed to validate logon.  " + ex.Message
                //    : "Failed to validate logon.  " + ex.InnerException.Message;
            }
        }

        #endregion


    }
}
