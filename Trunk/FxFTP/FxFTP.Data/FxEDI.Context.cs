﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FxFTP.Data
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class FxEDIEntities : DbContext
    {
        public FxEDIEntities()
            : base("name=FxEDIEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<ReceivedDirectoryPoll> ReceivedDirectoryPolls { get; set; }
        public virtual DbSet<ReceiveFileLog> ReceiveFileLogs { get; set; }
        public virtual DbSet<BadFile> BadFiles { get; set; }
        public virtual DbSet<MissingFile> MissingFiles { get; set; }
        public virtual DbSet<OverallStatu> OverallStatus { get; set; }
        public virtual DbSet<PendingRDPDateRange> PendingRDPDateRanges { get; set; }
        public virtual DbSet<TaskActivity> TaskActivities { get; set; }
    
        public virtual int usp_RecordReceiveFileLog(string rDPFiles, ObjectParameter tranDT, ObjectParameter result)
        {
            var rDPFilesParameter = rDPFiles != null ?
                new ObjectParameter("RDPFiles", rDPFiles) :
                new ObjectParameter("RDPFiles", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_RecordReceiveFileLog", rDPFilesParameter, tranDT, result);
        }
    
        public virtual int usp_RemoveBadFile(Nullable<int> badFileRowID, ObjectParameter tranDT, ObjectParameter result)
        {
            var badFileRowIDParameter = badFileRowID.HasValue ?
                new ObjectParameter("BadFileRowID", badFileRowID) :
                new ObjectParameter("BadFileRowID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_RemoveBadFile", badFileRowIDParameter, tranDT, result);
        }
    
        public virtual int usp_UpdateReceivedDirectoryPoll(ObjectParameter tranDT, ObjectParameter result)
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_UpdateReceivedDirectoryPoll", tranDT, result);
        }
    
        public virtual int usp_UpdateReceiveFileLogForMissingFile(Nullable<int> missingFileRowID, ObjectParameter tranDT, ObjectParameter result)
        {
            var missingFileRowIDParameter = missingFileRowID.HasValue ?
                new ObjectParameter("MissingFileRowID", missingFileRowID) :
                new ObjectParameter("MissingFileRowID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_UpdateReceiveFileLogForMissingFile", missingFileRowIDParameter, tranDT, result);
        }
    
        public virtual int usp_UpdateReceiveFileLogForReplacedBadFile(Nullable<int> replacedBadFileRowID, ObjectParameter tranDT, ObjectParameter result)
        {
            var replacedBadFileRowIDParameter = replacedBadFileRowID.HasValue ?
                new ObjectParameter("ReplacedBadFileRowID", replacedBadFileRowID) :
                new ObjectParameter("ReplacedBadFileRowID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_UpdateReceiveFileLogForReplacedBadFile", replacedBadFileRowIDParameter, tranDT, result);
        }
    
        public virtual int usp_UpdateReceiveFileLogForUnavailableFile(Nullable<int> unavailableFileRowID, ObjectParameter tranDT, ObjectParameter result)
        {
            var unavailableFileRowIDParameter = unavailableFileRowID.HasValue ?
                new ObjectParameter("UnavailableFileRowID", unavailableFileRowID) :
                new ObjectParameter("UnavailableFileRowID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_UpdateReceiveFileLogForUnavailableFile", unavailableFileRowIDParameter, tranDT, result);
        }
    }
}
