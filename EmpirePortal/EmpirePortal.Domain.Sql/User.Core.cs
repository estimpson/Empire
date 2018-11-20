using System;
using System.Collections.Generic;
using System.Linq;
using FxWeb.Domain.Core.Security;
using FxWeb.Domain.Core.Security.Privileges;
using FxWeb.Domain.Core.Types;

namespace EmpirePortal.Domain.Sql
{
    public partial class User : IUser
    {
        public Person Person
        {
            get => new Person
            {
                FirstName = FirstName,
                MiddleName = MiddleName,
                LastName = LastName,
            };
            set
            {
                FirstName = value?.FirstName;
                MiddleName = value?.MiddleName;
                LastName = value?.LastName;
            }
        }

        public Guid ActivationCode { get; set; }
        public bool IsActive { get; set; }
        public ICollection<IUserMenuItemPrivilege> MenuItemPrivileges { get; }

        ICollection<IRole> IUser.Roles => Roles.ToList<IRole>();
    }
}