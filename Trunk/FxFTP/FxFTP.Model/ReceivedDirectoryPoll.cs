#region Using

using System;
using System.Diagnostics;
using System.Linq;
using FxFTP.Data;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Core.Objects;

#endregion

namespace FxFTP.Model
{
    public class ReceivedDirectoryPoll
    {
        public static DateTime[] GetPendingDateRange()
        {
            var range = new DateTime[2];
            using (var context = new FxEDIEntities())
            {
                var rr = context.PendingRDPDateRanges.FirstOrDefault(r => r.RowID == 1);
                Debug.Assert(rr != null, "rr != null");
                range[0] = rr.FromDT;
                range[1] = rr.ToDT;
            }
            return range;
        }

        public static void RecordReceiveFileLog(string rdpFiles)
        {
            using (var context = new FxEDIEntities())
            {
                ((IObjectContextAdapter) context).ObjectContext.CommandTimeout = 1200;

                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof (Int32?));
                context.usp_RecordReceiveFileLog(rdpFiles, tranDT, result);
            }
        }

        public static void UpdateReceivedDirectoryPoll()
        {
            using (var context = new FxEDIEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof (DateTime?));
                var result = new ObjectParameter("Result", typeof (Int32?));
                context.usp_UpdateReceivedDirectoryPoll(tranDT, result);
            }
        }
    }
}