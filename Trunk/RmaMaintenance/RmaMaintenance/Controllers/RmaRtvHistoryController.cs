using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using RmaMaintenance.DataModels;
using RmaMaintenance.Model;

namespace RmaMaintenance.Controllers
{
    public class RmaRtvHistoryController
    {
        #region Class Objects

        private RmaRtvHistoryDataModel _rmaRtvHistoryDataModel;
        public List<RmaRtvHistoryDataModel> DetailsList = new List<RmaRtvHistoryDataModel>();

        private RmaRtvHistoryByDatesDataModel _rmaRtvHistoryByDatesDataModel;
        public List<RmaRtvHistoryByDatesDataModel> DetailsByDatesList = new List<RmaRtvHistoryByDatesDataModel>();

        private RmaRtvHistoryByShipperDataModel _rmaRtvHistoryByShipperDataModel;
        public List<RmaRtvHistoryByShipperDataModel> DetailsByShipperList = new List<RmaRtvHistoryByShipperDataModel>();

        #endregion


        #region Methods

        public void GetRmaRtvHistory(string operatorCode, string rmaRtvNumber, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                DetailsList.Clear();

                using (var context = new MONITOREntities())
                {
                    var query = context.usp_CreatedRmaRtvHistory(operatorCode, rmaRtvNumber, dt, result).ToList();

                    if (!query.Any())
                    {
                        error = string.Format("{0} was not found.", rmaRtvNumber);
                        return;
                    }

                    foreach (var item in query)
                    {
                        _rmaRtvHistoryDataModel = new RmaRtvHistoryDataModel
                            {
                                Type = item.Type,
                                Shipper = item.Shipper,
                                Serial = item.Serial,
                                Part = item.Part,
                                GlSegment = item.GlSegment,
                                Quantity = item.Quantity,
                                AuditTrailDate = item.AuditTrailDate
                            };
                        DetailsList.Add(_rmaRtvHistoryDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null)
                    ? "Failed to return History.  Error: " + ex.Message
                    : "Failed to return History.  Error: " + ex.InnerException.Message;
            }
        }

        public void GetRmaRtvHistoryByDateRange(string operatorCode, DateTime startDate, DateTime endDate, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                DetailsByDatesList.Clear();

                using (var context = new MONITOREntities())
                {
                    var query = context.usp_CreatedRmaRtvHistoryByDates(operatorCode, startDate, endDate, dt, result).ToList();

                    if (!query.Any())
                    {
                        error = "No RMA / RTV records were found within this date range.";
                        return;
                    }

                    foreach (var item in query)
                    {
                        _rmaRtvHistoryByDatesDataModel = new RmaRtvHistoryByDatesDataModel
                        {
                            Type = item.Type,
                            RmaRtvNumber = item.RmaRtvNumber,
                            Shipper = item.Shipper,
                            Serial = item.Serial,
                            Part = item.Part,
                            GlSegment = item.GlSegment,
                            Quantity = item.Quantity,
                            AuditTrailDate = item.AuditTrailDate
                        };
                        DetailsByDatesList.Add(_rmaRtvHistoryByDatesDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null)
                    ? "Failed to return History.  Error: " + ex.Message
                    : "Failed to return History.  Error: " + ex.InnerException.Message;
            }
        }

        public void GetRmaRtvHistoryByShipper(string operatorCode, string shipper, out string error)
        {
            var dt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(int));

            error = "";
            try
            {
                DetailsByShipperList.Clear();

                using (var context = new MONITOREntities())
                {
                    var query = context.usp_CreatedRmaRtvHistoryByShipper(operatorCode, shipper, dt, result).ToList();

                    if (!query.Any())
                    {
                        error = string.Format("No RMA / RTV records were found for shipper {0}.", shipper);
                        return;
                    }

                    foreach (var item in query)
                    {
                        _rmaRtvHistoryByShipperDataModel = new RmaRtvHistoryByShipperDataModel
                        {
                            Type = item.Type,
                            RmaRtvNumber = item.RmaRtvNumber,
                            Serial = item.Serial,
                            Part = item.Part,
                            GlSegment = item.GlSegment,
                            Quantity = item.Quantity,
                            AuditTrailDate = item.AuditTrailDate
                        };
                        DetailsByShipperList.Add(_rmaRtvHistoryByShipperDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException == null)
                    ? "Failed to return History.  Error: " + ex.Message
                    : "Failed to return History.  Error: " + ex.InnerException.Message;
            }
        }

        #endregion


    }
}
