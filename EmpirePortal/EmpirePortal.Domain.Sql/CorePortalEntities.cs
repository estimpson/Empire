using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using DevExpress.Web;
using FxWeb.Domain.Core;
using FxWeb.Domain.Core.Logging;
using FxWeb.Domain.Core.Security;
using FxWeb.Domain.Core.Security.Menu;
using FxWeb.Domain.Core.Security.Privileges;

namespace EmpirePortal.Domain.Sql
{
    public static class ICoreDataSourceExtensions
    {
        public static ICollection<MonitorOperators> GetMonitorOperators(this ICoreDataSource db,
            string monitorLoginLocation)
        {
            // db must be CorePortalEntities:
            var dbCPE = (CorePortalEntities) db;
            var tranDT = new ObjectParameter("tranDT", typeof(DateTime?));
            var result = new ObjectParameter("result", typeof(int?));
            var debugMsg = new ObjectParameter("debugMsg", typeof(string));
            return dbCPE.GetMonitorOperators(monitorLoginLocation, tranDT, result, 0, debugMsg).ToList();
        }
        public static IEnumerable<MonitorOperators> GetEehMonitorOperatorsRange(this ICoreDataSource db, ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            // db must be CorePortalEntities:
            var dbCPE = (CorePortalEntities)db;
            var tranDT = new ObjectParameter("tranDT", typeof(DateTime?));
            var result = new ObjectParameter("result", typeof(int?));
            var debugMsg = new ObjectParameter("debugMsg", typeof(string));
            return dbCPE.GetEehMonitorOperatorsByRange($"%{args.Filter}%", args.BeginIndex, args.EndIndex, tranDT, result, 0,
                debugMsg).ToList();
        }

        public static MonitorOperators GetEehMonitorOperatorsByOperator(this ICoreDataSource db, ListEditItemRequestedByValueEventArgs args)
        {
            if (args.Value == null) return (MonitorOperators) null;
            // db must be CorePortalEntities:
            var dbCPE = (CorePortalEntities)db;
            var tranDT = new ObjectParameter("tranDT", typeof(DateTime?));
            var result = new ObjectParameter("result", typeof(int?));
            var debugMsg = new ObjectParameter("debugMsg", typeof(string));
            return dbCPE.GetEehMonitorOperator(args.Value.ToString(), tranDT, result, 0, debugMsg)
                .SingleOrDefault();
        }
    }

    public partial class CorePortalEntities : ICoreDataSource
    {
        public IQueryable<ILogAction> LogActions { get; }
        public IQueryable<IRole> Roles { get; }
        IQueryable<IUser> ICoreDataSource.Users => Users;
        IQueryable<IMenuItem> ICoreDataSource.MenuItems => MenuItems;
        public IQueryable<IMenuItemNode> MenuItemTree { get; }
        public IQueryable<IRoleMenuItemPrivilege> RoleMenuItemPrivilege { get; }
        public IQueryable<IUserMenuItemPrivilege> UserMenuItemPrivilege { get; }
        public IList<ILogAction> GetLogActions()
        {
            throw new NotImplementedException();
        }

        public IList<IRole> GetRoles()
        {
            throw new NotImplementedException();
        }

        public IList<IUser> GetUsers()
        {
            throw new NotImplementedException();
        }

        public IList<IMenuItem> GetMenuItems()
        {
            throw new NotImplementedException();
        }

        public IList<IMenuItemNode> GetMenuItemTree()
        {
            throw new NotImplementedException();
        }

        public IList<IRoleMenuItemPrivilege> GetRoleMenuItemPrivileges()
        {
            throw new NotImplementedException();
        }

        public IList<IUserMenuItemPrivilege> GetUserMenuItemPrivileges()
        {
            throw new NotImplementedException();
        }

        public void AddEntity(object item)
        {
            Set(item.GetType()).Add(item);
        }

        public void UpdateEntity(object modelItem, object item)
        {
            Entry(modelItem).CurrentValues.SetValues(item);
        }

        public void RemoveEntity(object item)
        {
            Set(item.GetType()).Remove(item);
        }

        public void DeleteUser(string userName)
        {
            var modelItem = Users.Single(it => it.UserName == userName);
            RemoveEntity(modelItem);
            SaveChanges();
        }
    }
}