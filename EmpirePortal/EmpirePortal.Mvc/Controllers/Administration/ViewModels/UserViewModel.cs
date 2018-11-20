using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public class UserViewModel
    {
        [Required]
        [DisplayFormat(NullDisplayText = "Enter user name...")]
        public string UserName { get; set; }
        [Required]
        [DisplayFormat(NullDisplayText = "Enter first name...")]
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        [Required]
        [DisplayFormat(NullDisplayText = "Enter last name...")]
        public string LastName { get; set; }

        //[Required]  - Not required for existing records.
        [Display(Name = "New Password")]
        [DataType(DataType.Password)]
        [DisplayFormat(NullDisplayText = "Enter password...")]
        [RegularExpression("^(?=.*[A-Za-z])(?=.*[^A-Za-z])[\\s\\S]{8,}$", ErrorMessage = "Password must be at least 8 characters and contain one or more non-letter characters.")]
        [AdditionalMetadata("Tooltip", "Password must be at least 8 characters and contain one or more non-letter characters.")]
        public string NewAccountPassword { get; set; }

        //[Required]  - Not required for existing records.
        [Display(Name = "Confirm Password", Description = "Desc: Password must be at least 8 characters and contain one or more non-letter characters.", Prompt = "***")]
        [DataType(DataType.Password)]
        [DisplayFormat(NullDisplayText = "Re-enter password...")]
        [System.ComponentModel.DataAnnotations.Compare("NewAccountPassword", ErrorMessage = "Passwords don't match.")]
        public string ConfirmNewAccountPassword { get; set; }

        // Not an editable property.  Utilized by update to keep existing password hash.
        public string CurrentPasswordHash { get; set; }

        [DataType(DataType.Password)]
        [DisplayFormat(NullDisplayText = "Enter to change password...")]
        [RegularExpression("^(?=.*[A-Za-z])(?=.*[^A-Za-z])[\\s\\S]{8,}$", ErrorMessage = "Password must be at least 8 characters and contain one or more non-letter characters.")]
        public string ChangePassword { get; set; }

        [DataType(DataType.Password)]
        [System.ComponentModel.DataAnnotations.Compare("ChangePassword", ErrorMessage = "Passwords don't match.")]
        [AdditionalMetadata("NullText", "Re-enter to change password...")]
        public string ConfirmChangePassword { get; set; }

        [Required]
        [DisplayFormat(NullDisplayText = "Enter user's email address...")]
        [EmailAddress]
        [RegularExpression("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*", ErrorMessage = "Email is invalid.")]
        public string EmailAddress { get; set; }

        [Required]
        public bool IsAccountActive { get; set; }

        [Display(Name = "Monitor EEH Operator")]
        public string MonitorOperator_EEH { get; set; }

        [Display(Name = "Monitor EEI Operator")]
        public string MonitorOperator_EEI { get; set; }
    }
}