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

        public void ValidateLogon(string password, out string name, out string operatorCode, out string error)
        {
            error = name = operatorCode = "";
            try
            {
                _context.employees.Where(e => e.password == password).Load();
                if (!_context.employees.Local.Any())
                {
                    error = "Invalid password.";
                    return;
                }

                foreach (var item in _context.employees.Local)
                {
                    name = item.name;
                    operatorCode = item.operator_code;
                }
            }
            catch (Exception ex)
            {
                error = "Failed to validate logon.";

                //error = (ex.InnerException == null)
                //    ? "Failed to validate logon.  " + ex.Message
                //    : "Failed to validate logon.  " + ex.InnerException.Message;
            }
        }

        #endregion


    }
}
