using FxWeb.Domain.Core.Security.Menu;
using FxWeb.Domain.Core.Security.Privileges;
using System.Collections.Generic;
using System.Linq;

namespace EmpirePortal.Domain.Sql
{
    public partial class MenuItem : IMenuItem
    {
        public ICollection<IUserMenuItemPrivilege> UserPrivileges { get; set; }
        public ICollection<IRoleMenuItemPrivilege> RolePrivileges { get; set; }
        IMenuItem IMenuItem.ParentMenuItem { get => ParentMenuItem; set => ParentMenuItem = (MenuItem) value; }

        ICollection<IMenuItem> IMenuItem.ChildMenuItems => ChildMenuItems.ToList<IMenuItem>();
    }
}
