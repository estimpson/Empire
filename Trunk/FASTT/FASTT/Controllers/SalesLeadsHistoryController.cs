using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using FASTT.Controls;
using FASTT.Model;
using FASTT.DataModels;


namespace FASTT.Controllers
{
    public class SalesLeadsHistoryController
    {
        #region ClassObjects

        private MONITOREntities1 _context;
        private readonly CustomMessageBox _messageBox;

        private SalesLeadHistoryDataModel _salesLeadHistoryDataModel;
        public List<SalesLeadHistoryDataModel> SalesLeadHistoryList = new List<SalesLeadHistoryDataModel>();

        #endregion


        #region Constructor

        public SalesLeadsHistoryController()
        {
            _context = new MONITOREntities1();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Methods
        
        public void GetSalesActivityHistory(int salesLeadId)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            SalesLeadHistoryList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_GetActivityHistory(salesLeadId, td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _salesLeadHistoryDataModel = new SalesLeadHistoryDataModel
                            {
                                Activity = item.Activity,
                                ActivityDate = item.ActivityDate,
                                Duration = item.Duration,
                                ContactName = item.ContactName,
                                ContactEmailAddress = item.ContactEmailAddress,
                                ContactPhoneNumber = item.ContactPhoneNumber,
                                Notes = item.Notes,
                                RowId = item.RowID
                            };
                        SalesLeadHistoryList.Add(_salesLeadHistoryDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return activity history for this sales lead.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


    }
}
