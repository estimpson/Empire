using System.ComponentModel.DataAnnotations;
using FxWeb.Domain.Core.Security.Menu;
using FxWeb.Mvc.Infrastructure.Mapping;

namespace EmpirePortal.Mvc.Controllers.Administration
{
    public class MenuItemNodeViewModel : IMapsFrom<IMenuItemNode>
    {
        [Key]
        [Display(Order = -1)]
        public virtual int Id { get; set; }

        [Required]
        [Display(Name = "Menu Name")]
        [DisplayFormat(NullDisplayText = "Enter name of menu...")]
        [RegularExpression("^[^.]*$", ErrorMessage = "Menu name must not contain a dot separator.")]
        public virtual string PartialName { get; set; }

        [Display(Name = "Parent Menu")]
        [DisplayFormat(NullDisplayText = "Select parent menu or leave blank for module menu...")]
        public virtual string ParentMenuName { get; set; }

        [Required]
        [Display(Name = "Menu Caption")]
        [DisplayFormat(NullDisplayText = "Enter caption (display text) of menu item...")]
        public virtual string Caption { get; set; }

        [Display(Name = "Menu Url")]
        [DisplayFormat(NullDisplayText = "Enter url menu item...")]
        [RegularExpression("^~/.*$", ErrorMessage = "Url must begin with ~/....")]
        public virtual string Url { get; set; }

        [Display(Name = "Menu Order")]
        [DisplayFormat(NullDisplayText = "Enter to specify order or leave blank to add to end...")]
        public virtual decimal? MenuOrder { get; set; }

        [Display(Order = -1)]
        public virtual int? Level { get; set; }
    }
}