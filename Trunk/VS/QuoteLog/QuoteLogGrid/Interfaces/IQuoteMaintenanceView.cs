using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogData.Models;

namespace QuoteLogGrid.Forms
{
    public interface IQuoteMaintenanceView
    {
        // Business model...
        BindingList<QuoteEntry> HeaderGridDataSource { set; }
        BindingList<QuoteLTA> LtaDataSource { set; }
        IEnumerable<string> QuotePrintFile { set; } 
        IEnumerable<string> CustomerQuoteFile { set; }

        string QuoteNumber { get; set; }

        bool ExistsQuotePrint { get; set; }
        bool ExistsCustomerQuote { get; set; }

        void BindLookupColumns();
    }
}
