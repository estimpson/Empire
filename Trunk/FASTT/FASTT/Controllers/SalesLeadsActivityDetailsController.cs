using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using FASTT.Controls;
using FASTT.DataModels;
using FASTT.Model;

namespace FASTT.Controllers
{
    public class SalesLeadsActivityDetailsController
    {
        #region Class Objects

        private MONITOREntities1 _context;
        private readonly CustomMessageBox _messageBox;

        #endregion


        #region Properties

        public string ContactName { get; private set; }
        public string ContactPhone { get; private set; }
        public string ContactEmail { get; private set; }

        #endregion


        #region Constructor

        public SalesLeadsActivityDetailsController()
        {
            _context = new MONITOREntities1();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Methods

        public void GetSalesLeadContactInfo(int id)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                var query = _context.usp_ST_SalesLeadLog_GetContactInfo(id, td, res);
                foreach (var item in query.ToList())
                {
                    ContactName = item.ContactName;
                    ContactPhone = item.ContactPhoneNumber;
                    ContactEmail = item.ContactEmailAddress;
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return contact information.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public int SaveSalesLeadActivity(string operatorCode, int? combinedLightingId, int? salesLeadId, int salesLeadStatus, int? activityRowId, string activity,
            DateTime activityDate, string contactName, string contactPhone, string contactEmail, decimal duration, string notes)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    _context.usp_ST_SalesLeadLog_Update(operatorCode, combinedLightingId, salesLeadId, salesLeadStatus, activityRowId, activity,
                        activityDate, contactName, contactPhone, contactEmail, duration, notes, td, res);

                    _messageBox.Message = "Success.";
                    _messageBox.ShowDialog();
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to save sales lead activity.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion


    }
}
