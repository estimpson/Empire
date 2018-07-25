using System;
using System.Collections.Generic;
using System.Linq;
using WebPortal.SalesForecast.Models;
using WebPortal.SalesForecast.DataModels;
using System.Data.Entity.Core.Objects;

namespace WebPortal.SalesForecast.PageViewModels
{
    [Serializable]
    public class SalesForecastUpdatedViewModel
    {
        public String OperatorCode { get; private set; }
        public String Error { get; private set; }

        public List<EopYearDataModel> EopYearList = new List<EopYearDataModel>();
        public List<SchedulersDataModel> SchedulersList = new List<SchedulersDataModel>();


        #region Constructor

        public SalesForecastUpdatedViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["OpCode"].ToString();
        }

        #endregion


        #region Grid Methods
        public List<GetSalesForecastUpdated_Result> GetSf(int eop, int filter)
        {
            List<GetSalesForecastUpdated_Result> sfList;
            using (var context = new MONITOREntities1())
            {
                sfList = context.usp_Web_SalesForecastUpdated_GetSalesForecastUpdated(eop, filter).ToList();
            }
            return sfList;
        }

        public void UpdateSf(GetSalesForecastUpdated_Result u)
        {
            using (var context = new MONITOREntities1())
            {
                ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

                DateTime? verifiedEopDate = null;
                switch (u.VerifiedEop)
                {
                    case "CSM":
                        verifiedEopDate = u.CsmEop;
                        break;
                    case "Empire":
                        verifiedEopDate = u.EmpireEop;
                        break;
                    case "MidModel":
                        verifiedEopDate = u.MidModelYear;
                        break;
                }

                context.usp_Web_SalesForecastUpdated_UpdateBasePartCloseouts(OperatorCode, u.BasePart, u.VerifiedEop, verifiedEopDate, u.SchedulerResponsible, u.RfMpsLink, u.SchedulingTeamComments,
                    u.MaterialsComments, u.ShipToLocation, u.FgInventoryAfterBuildout, u.CostEach, u.ExcessFgAfterBuildout, u.ExcessRmAfterBuildout, u.ProgramExposure,
                    u.DateToSendCoLetter, u.ObsolescenceCost, tranDT, result);
            }
        }

        #endregion


        #region Other Methods

        public void GetEopYears()
        {
            Error = "";
            EopYearList.Clear();
            using (var context = new MONITOREntities1())
            {
                try
                {
                    var query = context.usp_Web_SalesForecastUpdated_GetEopYears();
                    foreach (var item in query)
                    {
                        var eopYear = new EopYearDataModel();
                        eopYear.EmpireEopYear = item.EopYear;
                        EopYearList.Add(eopYear);
                    }
                }
                catch (Exception ex)
                {
                    Error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
        }

        public void GetSchedulers()
        {
            Error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            SchedulersList.Clear();
            using (var context = new MONITOREntities1())
            {
                try
                {
                    var empty = new SchedulersDataModel();
                    empty.Scheduler = "";
                    SchedulersList.Add(empty);

                    var query = context.usp_PlanningSnapshot_Q_GetSchedulers(tranDt, res, debug, debugMsg);
                    foreach (var item in query)
                    {
                        var scheduler = new SchedulersDataModel();
                        scheduler.SchedulerId = item.SchedulerID;
                        scheduler.Scheduler = item.SchedulerName;
                        SchedulersList.Add(scheduler);
                    }
                }
                catch (Exception ex)
                {
                    Error = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
        }

        #endregion


    }
}