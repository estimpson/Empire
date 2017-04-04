using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RmaMaintenance.Views.Interfaces
{
    public interface IPreferencesView
    {
        void StoreViewPreferences();
        void RestoreViewPreferences();
    }
}
