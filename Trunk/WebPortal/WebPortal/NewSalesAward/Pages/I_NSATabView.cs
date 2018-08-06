using System;
using WebPortal.NewSalesAward.Models;

namespace WebPortal.NewSalesAward.Pages
{
    public interface I_NSATabView
    {
        void SetQuote(usp_GetAwardedQuotes_Result awardedQuote);
        void Save();
    }
}