using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.Scheduling.Models;
using WebPortal.Scheduling.DataModels;

namespace WebPortal.Scheduling.PageViewModels
{
    [Serializable]
    public class SchedulersViewModel
    {
        public List<SchedulersDataModel> SchedulersList = new List<SchedulersDataModel>();
        public List<FinishedPartsDataModel> FinishedPartsList = new List<FinishedPartsDataModel>();
        public List<HeaderInfoDataModel> HeaderInfoList = new List<HeaderInfoDataModel>();
        public List<SnapshotCalendarDataModel> SnapshotCalendarList = new List<SnapshotCalendarDataModel>();


        public SchedulersViewModel()
        {
        }

        public string GetSchedulers()
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            SchedulersList.Clear();
            using (var context = new MONITOREntities3())
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
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

        public string GetFinishedParts(string schedulerId)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            FinishedPartsList.Clear();
            using (var context = new MONITOREntities3())
            {
                try
                {
                    var query = context.usp_PlanningSnapshot_Q_CurrentPartList(schedulerId, tranDt, res, debug, debugMsg);
                    foreach (var item in query)
                    {
                        var finishedPart = new FinishedPartsDataModel();
                        finishedPart.FinishedPart = item.FinishedPart;
                        finishedPart.Revision = item.Revision;
                        FinishedPartsList.Add(finishedPart);
                    }
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

        public string GetHeaderInfo(string finishedPart, string revision)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            HeaderInfoList.Clear();
            using (var context = new MONITOREntities3())
            {
                try
                {
                    var query = context.usp_PlanningSnapshot_Q_GetHeaderInfo(finishedPart, revision, tranDt, res, debug, debugMsg);
                    foreach (var item in query)
                    {
                        var headerInfo = new HeaderInfoDataModel();
                        headerInfo.CustomerPart = item.CustomerPart;
                        headerInfo.Description = item.Description;
                        headerInfo.StandardPack = String.Format("{0:#,###}", item.StandardPack);
                        headerInfo.DefaultPo = String.Format("{0:#}", item.DefaultPO);
                        headerInfo.SalesPrice = String.Format("{0:$#,###.00}", item.ABC_Class_2);
                        headerInfo.AbcClass1 = item.ABC_Class_1;
                        headerInfo.AbcClass2 = String.Format("{0:#,###;(#,###)}", item.ABC_Class_2);
                        headerInfo.EauEei = String.Format("{0:#,###;(#,###)}", item.EAU_EEI);
                        headerInfo.EehCapacity = String.Format("{0:#,###;(#,###)}", item.EEH_Capacity);
                        headerInfo.Sop = String.Format("{0:yyyy-MM-dd}", item.SOP);
                        headerInfo.Eop = String.Format("{0:yyyy-MM-dd}", item.EOP);
                        HeaderInfoList.Add(headerInfo);
                    }
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

        public string GetSnapShotCalendar(string part, string revision)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            SnapshotCalendarList.Clear();
            using (var context = new MONITOREntities3())
            {
                try
                {
                    var query = context.usp_PlanningSnapshot_Q_GetSnapshotCalendar(part, revision, tranDt, res, debug, debugMsg);
                    foreach (var item in query)
                    {
                        var snapshotCalendar = new SnapshotCalendarDataModel();
                        snapshotCalendar.CalendarDT = String.Format("{0:yyyy-MM-dd}", item.CalendarDT);
                        snapshotCalendar.DailyWeekly = item.DailyWeekly;
                        snapshotCalendar.WeekNo = item.WeekNo;
                        snapshotCalendar.Holiday = item.Holiday;
                        snapshotCalendar.EEIContainerDT = String.Format("{0:yyyy-MM-dd}", item.EEIContainerDT);
                        snapshotCalendar.SchedulingDT = String.Format("{0:yyyy-MM-dd}", item.SchedulingDT);
                        snapshotCalendar.PlanningDays = item.PlanningDays;
                        snapshotCalendar.CustomerRequirement = String.Format("{0:#,###;(#,###)}", item.CustomerRequirement);
                        snapshotCalendar.OverrideCustomerRequirement = String.Format("{0:#,###;(#,###)}", item.OverrideCustomerRequirement);
                        snapshotCalendar.InTransQty = String.Format("{0:#,###;(#,###)}", item.InTransQty);
                        snapshotCalendar.OnOrderEEH = String.Format("{0:#,###;(#,###)}", item.OnOrderEEH);
                        snapshotCalendar.NewOnOrderEEH = String.Format("{0:#,###;(#,###)}", item.NewOnOrderEEH);
                        snapshotCalendar.TotalInventory = String.Format("{0:#,###;(#,###)}", item.TotalInventory);
                        snapshotCalendar.Balance = String.Format("{0:#,###;(#,###)}", item.Balance);
                        snapshotCalendar.WeeksOnHand = String.Format("{0:#,###.00;(#,###.00)}", item.WeeksOnHand);
                        snapshotCalendar.WeeksOnHandWarnFlag = item.WeeksOnHandWarnFlag;
                        snapshotCalendar.RowID = item.RowID;

                        SnapshotCalendarList.Add(snapshotCalendar);
                    }
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

        public string UpdateSnapshotCalendarOverrideCustReq(string opCode, string part, string revision, DateTime calDate, Decimal? newRequirement)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            using (var context = new MONITOREntities3())
            {
                try
                {
                    context.usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement(opCode, part, revision, calDate, newRequirement, tranDt, res, debug, debugMsg);
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

        public string UpdateSnapshotCalendarNewOnOrderEeh(string opCode, string part, string revision, DateTime calDate, Decimal? newOnorderEeh)
        {
            string result = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime?));
            var res = new ObjectParameter("Result", typeof(int?));
            var debugMsg = new ObjectParameter("DebugMsg", typeof(string));
            int debug = 0;

            using (var context = new MONITOREntities3())
            {
                try
                {
                    context.usp_PlanningSnapshot_CRUD_NewOnOrderEEH(opCode, part, revision, calDate, newOnorderEeh, tranDt, res, debug, debugMsg);
                }
                catch (Exception ex)
                {
                    result = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                }
            }
            return result;
        }

    }
}