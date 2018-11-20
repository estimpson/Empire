using System;
using System.ComponentModel.DataAnnotations;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    [Serializable]
    public class RoleViewModel
    {
        [Required]
        [MaxLength(50)]
        [DisplayFormat(NullDisplayText = "Enter role name...")]
        public string Name { get; set; }

        [Required]
        [MaxLength(100)]
        [DisplayFormat(NullDisplayText = "Enter role description...")]
        public virtual string Description { get; set; }
    }
}