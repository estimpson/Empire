#region Using

using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using FxFTP.Data;

#endregion

namespace FxFTP.Model
{
    public static class Files
    {
        public static List<MissingFile> TryGetMissingFiles()
        {
            using (var context = new FxEDIEntities())
            {
                return context.MissingFiles.ToList();
            }
        }

        public static List<BadFile> TryGetBadFiles()
        {
            using (var context = new FxEDIEntities())
            {
                return context.BadFiles.ToList();
            }
        }

        public static void UpdateReceiveFileLogForMissingFile(Int32? missingFileRowID)
        {
            using (var context = new FxEDIEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                context.usp_UpdateReceiveFileLogForMissingFile(missingFileRowID, tranDT, result);
            }
        }

        public static void UpdateReceiveFileLogForUnavailableFile(Int32? unavailableFileRowID)
        {
            using (var context = new FxEDIEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                context.usp_UpdateReceiveFileLogForUnavailableFile(unavailableFileRowID, tranDT, result);
            }
        }

        public static void UpdateReceiveFileLogForReplacedBadFile(Int32? replacedBadFileRowID)
        {
            using (var context = new FxEDIEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                context.usp_UpdateReceiveFileLogForReplacedBadFile(replacedBadFileRowID, tranDT, result);
            }
        }

        public static void RemoveBadFile(Int32? badFileRowID)
        {
            using (var context = new FxEDIEntities())
            {
                var tranDT = new ObjectParameter("TranDT", typeof(DateTime?));
                var result = new ObjectParameter("Result", typeof(Int32?));
                context.usp_RemoveBadFile(badFileRowID, tranDT, result);
            }
        }
    }
}