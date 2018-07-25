using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using WebPortal.QuoteLogIntegration.Models;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    [Serializable]
    public class MarketSegmentSubsegmentViewModel
    {
        #region Properties

        public String OperatorCode { get; set; }
        public String Segment { get; set; }
        public String SegmentNote { get; set; }
        public String Subsegment { get; set; }
        public String SubsegmentNote { get; set; }
        public String Error { get; private set; }

        #endregion


        #region Constructor

        public MarketSegmentSubsegmentViewModel()
        {
            OperatorCode = System.Web.HttpContext.Current.Session["OpCode"].ToString();
        }

        #endregion


        #region Empire Market Segment Methods

        public List<usp_Web_EmpireMarketSegment_Result> GetSegments()
        {
            var segmentList = new List<usp_Web_EmpireMarketSegment_Result>();
            using (var context = new MONITOREntitiesQuteLog())
            {
                segmentList = context.usp_Web_EmpireMarketSegment().ToList();
            }
            return segmentList;
        }

        public void ApproveSegment()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSegment_Approve(OperatorCode, Segment, SegmentNote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void DenySegment()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSegment_Deny(OperatorCode, Segment, SegmentNote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SendSegmentEmail()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSegment_ApproveDeny_SendEmail(Segment, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


        #region Empire Market Subsegment Methods

        public List<usp_Web_EmpireMarketSubsegment_Result> GetSubsegments()
        {
            var subSegmentList = new List<usp_Web_EmpireMarketSubsegment_Result>();
            using (var context = new MONITOREntitiesQuteLog())
            {
                subSegmentList = context.usp_Web_EmpireMarketSubsegment().ToList();
            }
            return subSegmentList;
        }

        public void ApproveSubsegment()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSubsegment_Approve(OperatorCode, Subsegment, SubsegmentNote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void DenySubsegment()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSubsegment_Deny(OperatorCode, Subsegment, SubsegmentNote, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void SendSubsegmentEmail()
        {
            ObjectParameter tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32?));

            Error = "";
            try
            {
                using (var context = new MONITOREntitiesQuteLog())
                {
                    context.usp_Web_EmpireMarketSubsegment_ApproveDeny_SendEmail(Subsegment, tranDT, result);
                }
            }
            catch (Exception ex)
            {
                Error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}