using System.Collections;
using System.Linq;
using System.Web.UI;
using FxWeb.Domain.Core.Security.Menu;

namespace EmpirePortal.Mvc.Controllers.Home
{
    public abstract class ItemsData : IHierarchicalEnumerable
    {
        protected ItemsData()
        {
        }

        public abstract IEnumerable Data { get; set; }

        public IEnumerator GetEnumerator()
        {
            return Data.GetEnumerator();
        }
        public IHierarchyData GetHierarchyData(object enumeratedItem)
        {
            return (IHierarchyData)enumeratedItem;
        }
    }

    public class ItemData : IHierarchyData
    {
        public string Text { get; protected set; }
        public string NavigateUrl { get; protected set; }

        public ItemData(string text, string navigateUrl)
        {
            Text = text;
            NavigateUrl = navigateUrl;
        }

        // IHierarchyData
        bool IHierarchyData.HasChildren => HasChildren();
        object IHierarchyData.Item => this;

        string IHierarchyData.Path => NavigateUrl;

        string IHierarchyData.Type => GetType().ToString();

        IHierarchicalEnumerable IHierarchyData.GetChildren()
        {
            return CreateChildren();
        }

        IHierarchyData IHierarchyData.GetParent() => null;

        protected virtual bool HasChildren() => false;

        protected virtual IHierarchicalEnumerable CreateChildren() => null;
    }

    public class ModuleMenuViewModel : ItemsData
    {
        public override IEnumerable Data { get; set; }
    }

    public class ModuleMenuItemViewModel : ItemData
    {
        public IMenuItem MenuItem { get; protected set; }

        public ModuleMenuItemViewModel(IMenuItem menuItem) : base(menuItem.Caption, menuItem.Url)
        {
            MenuItem = menuItem;
        }

        protected override bool HasChildren()
        {
            return MenuItem.ChildMenuItems.Count > 0;
        }

        protected override IHierarchicalEnumerable CreateChildren()
        {
            return new ModuleMenuViewModel
            {
                Data = MenuItem.ChildMenuItems.ToList().Select(cmi => new ModuleMenuItemViewModel(cmi))
            };
        }
    }
}