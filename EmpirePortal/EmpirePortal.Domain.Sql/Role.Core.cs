using System.Collections.Generic;
using System.Linq;
using FxWeb.Domain.Core.Security;
using FxWeb.Domain.Core.Security.Privileges;

namespace EmpirePortal.Domain.Sql
{
    public partial class Role : IRole
    {
        public ICollection<IRoleMenuItemPrivilege> MenuItemPrivileges { get; }

        ICollection<IUser> IRole.Users => Users.ToList<IUser>();
    }
}
