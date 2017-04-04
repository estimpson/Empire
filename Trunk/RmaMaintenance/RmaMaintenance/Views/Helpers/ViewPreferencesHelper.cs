#region Using

using System.CodeDom.Compiler;
using System.Configuration;
using System.Linq;
using System.Windows.Forms;
using System.Xml.Serialization;
using BrightIdeasSoftware;
using RmaMaintenance.Properties;

#endregion

namespace RmaMaintenance.Views.Helpers
{
    public static class ViewPreferencesHelper
    {
        public static void StoreViewPreferences<TOLV>(this TOLV objectListView) where TOLV : ObjectListView
        {
            //
            var fullName = GetFullName(objectListView);
            if (Settings.Default.Properties.Cast<SettingsProperty>().Count(prop => prop.Name == fullName) == 0)
            {
                var property = new SettingsProperty(fullName)
                {
                    DefaultValue = new ObjectListViewState(),
                    IsReadOnly = false,
                    PropertyType = typeof (ObjectListViewState),
                    SerializeAs = SettingsSerializeAs.Xml,
                    Provider = Settings.Default.Providers["LocalFileSettingsProvider"]
                };
                property.Attributes.Add(typeof(UserScopedSettingAttribute), new UserScopedSettingAttribute());
                Settings.Default.Properties.Add(property);

                // Load settings now.
                Settings.Default.Reload();
            }
            var olvs = new ObjectListViewState {StateData = objectListView.SaveState()};
            Settings.Default[fullName] = olvs;
            Settings.Default.Save();
        }

        public static void RestoreViewPreferences<TOLV>(this TOLV objectListView) where TOLV : ObjectListView
        {
            //
            //System.Configuration.SettingsSerializeAsAttribute x = typeof(XmlSerializer);
            var fullName = GetFullName(objectListView);
            if (Settings.Default.Properties.Cast<SettingsProperty>().Count(prop => prop.Name == fullName) == 0)
            {
                var property = new SettingsProperty(fullName)
                {
                    DefaultValue = new ObjectListViewState(),
                    IsReadOnly = false,
                    PropertyType = typeof(ObjectListViewState),
                    SerializeAs = SettingsSerializeAs.Xml,
                    Provider = Settings.Default.Providers["LocalFileSettingsProvider"]
                };
                property.Attributes.Add(typeof(UserScopedSettingAttribute), new UserScopedSettingAttribute());
                Settings.Default.Properties.Add(property);

                // Load settings now.
                Settings.Default.Reload();
            }
            var pp = Settings.Default.Properties.Cast<SettingsProperty>()
                .FirstOrDefault(p => p.Name == fullName);

            var olvState = (ObjectListViewState)Settings.Default[fullName];
            if (olvState!=null) objectListView.RestoreState(olvState.StateData);
        }

        public static string GetFullName(Control c)
        {
            //return "Dummy";
            var name = "";
            do
            {
                name += c.Name + '/';
                c = c.Parent;
            } while (c.Parent != null);
            return name;
        }
    }
}