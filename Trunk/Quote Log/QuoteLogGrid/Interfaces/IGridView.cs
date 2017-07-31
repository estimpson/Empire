using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuoteLogGrid.Interfaces
{
    public interface IUserPanel
    {
        void ShowData();
        void SaveData();
        void SaveLayout();
        void RestoreLayout();
        void ExportToExcel();
    }
}
