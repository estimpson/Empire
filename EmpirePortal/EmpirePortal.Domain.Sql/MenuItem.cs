//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace EmpirePortal.Domain.Sql
{
    using System;
    using System.Collections.Generic;
    
    public partial class MenuItem
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MenuItem()
        {
            this.ChildMenuItems = new HashSet<MenuItem>();
        }
    
        public string ShortName { get; set; }
        public int Status { get; set; }
        public int Type { get; set; }
        public string Caption { get; set; }
        public string Url { get; set; }
        public decimal MenuOrder { get; set; }
        public bool IsModule { get; set; }
        public Nullable<int> ParentMenuItem_Id { get; set; }
        public System.Guid AssetGuid { get; set; }
        public int Id { get; set; }
        public Nullable<System.DateTime> RowCreateDT { get; set; }
        public string RowCreateUser { get; set; }
        public Nullable<System.DateTime> RowModifiedDT { get; set; }
        public string RowModifiedUser { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MenuItem> ChildMenuItems { get; set; }
        public virtual MenuItem ParentMenuItem { get; set; }
    }
}
