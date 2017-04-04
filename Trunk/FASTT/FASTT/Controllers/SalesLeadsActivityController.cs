using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using FASTT.Controls;
using FASTT.Model;
using FASTT.DataModels;

namespace FASTT.Controllers
{
    public class SalesLeadsActivityController
    {
        #region Class Objects

        private MONITOREntities1 _context;
        private readonly CustomMessageBox _messageBox;

        private SalesLeadActivityDataModel _salesLeadActivityDataModel;
        public List<SalesLeadActivityDataModel> SalesLeadList = new List<SalesLeadActivityDataModel>();

        #endregion


        #region Properties

        public string ContactName { get; private set; }
        public string ContactPhone { get; private set; }
        public string ContactEmail { get; private set; }

        #endregion


        #region Constructor

        public SalesLeadsActivityController()
        {
            _context = new MONITOREntities1();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Methods

        public void GetSalesLeadsBySalesPerson(string operatorCode)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                SalesLeadList.Clear();

                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Hitlist_GetActivity(operatorCode, td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _salesLeadActivityDataModel = new SalesLeadActivityDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            Status = item.Status,
                            PeakVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            LastSalesActivity = item.LastSalesActivity,
                            ID = item.ID,
                            SalesLeadID = item.SalesLeadID
                        };
                        SalesLeadList.Add(_salesLeadActivityDataModel);
                    }
                    if (SalesLeadList.Count < 1)
                    {
                        _messageBox.Message = "You have no open sales leads.";
                        _messageBox.ShowDialog();
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetSalesLeadContactInfo(int rowId)
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
                    var queryResult = _context.usp_ST_SalesLeadLog_GetContactInfo(rowId, td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        ContactName = item.ContactName;
                        ContactPhone = item.ContactPhoneNumber;
                        ContactEmail = item.ContactPhoneNumber;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return contact info.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


    }
}
