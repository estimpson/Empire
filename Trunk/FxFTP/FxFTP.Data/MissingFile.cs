//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class MissingFile
    {
        public string SourceFileName { get; set; }
        public int Status { get; set; }
        public int Type { get; set; }
        public int SourceFileLength { get; set; }
        public byte[] SourceCRC32 { get; set; }
        public System.DateTime SourceFileDT { get; set; }
        public int SourceFileAvailable { get; set; }
        public Nullable<System.Guid> ReceiveFileGUID { get; set; }
        public string ReceiveFileName { get; set; }
        public byte[] ReceiveCRC32 { get; set; }
        public Nullable<int> ReceiveFileLength { get; set; }
        public int RowID { get; set; }
        public Nullable<System.DateTime> RowCreateDT { get; set; }
        public string RowCreateUser { get; set; }
        public Nullable<System.DateTime> RowModifiedDT { get; set; }
        public string RowModifiedUser { get; set; }
    }
}
