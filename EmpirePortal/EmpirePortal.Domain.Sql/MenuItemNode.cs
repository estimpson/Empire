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
    
    public partial class MenuItemNode
    {
        public int Id { get; set; }
        public string ShortName { get; set; }
        public string PartialName { get; set; }
        public string ParentMenuName { get; set; }
        public string Caption { get; set; }
        public string Url { get; set; }
        public decimal MenuOrder { get; set; }
        public bool IsModule { get; set; }
        public int Level { get; set; }
        public bool HasChildren { get; set; }
        public int Sequence { get; set; }
    }
}
