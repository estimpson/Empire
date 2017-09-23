#region Using

using System;
using System.Diagnostics;
using System.Linq;
using FxFTP.Data;

#endregion

namespace FxFTP.Model
{
    public class TaskActivityMonitor
    {
        public static Object[] GetTaskActivity()
        {
            string lro2, lro3, lro4, lro5;
            DateTime? lr2, nr2, lr3, nr3, lr4, nr4, lr5, nr5;
            using (var context = new FxEDIEntities())
            {
                var r2 = context.TaskActivities.First(r => r.RowID == 2);
                Debug.Assert(r2 != null, "rr != null");
                lro2 = r2.LastRunOutcome;
                lr2 = r2.LastRun;
                nr2 = r2.NextRun;

                var r3 = context.TaskActivities.First(r => r.RowID == 3);
                Debug.Assert(r3 != null, "rr != null");
                lro3 = r3.LastRunOutcome;
                lr3 = r3.LastRun;
                nr3 = r3.NextRun;

                var r4 = context.TaskActivities.First(r => r.RowID == 4);
                Debug.Assert(r4 != null, "rr != null");
                lro4 = r4.LastRunOutcome;
                lr4 = r4.LastRun;
                nr4 = r4.NextRun;

                var r5 = context.TaskActivities.First(r => r.RowID == 5);
                Debug.Assert(r5 != null, "rr != null");
                lro5 = r5.LastRunOutcome;
                lr5 = r5.LastRun;
                nr5 = r5.NextRun;
            }
            return new object[] {lro2, lr2, nr2, lro3, lr3, nr3, lro4, lr4, nr4, lro5, lr5, nr5};
        }
    }
}