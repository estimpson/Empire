#region Using

using System;
using System.Diagnostics;
using System.Linq;
using FxFTP.Data;

#endregion

namespace FxFTP.Model
{
    public class OverallStatus
    {
        public static Object[] GetOverallStatus()
        {
            DateTime currentDT;
            int filesMissing;
            int corruptFiles;

            using (var context = new FxEDIEntities())
            {
                var rr = context.OverallStatus.First(r => r.RowID == 1);
                Debug.Assert(rr != null, "rr != null");
                currentDT = rr.CurrentDatetime;
                filesMissing = rr.FilesMissing ?? -1;
                corruptFiles = rr.CorruptFiles ?? -1;
            }
            return new Object[] {currentDT, filesMissing, corruptFiles};
        }
    }
}