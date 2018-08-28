using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebPortal.QuoteLogIntegration.Models;

namespace WebPortal.QuoteLogIntegration.PageViewModels
{
    public class QtQuoteTransferViewModel
    {
        public List<usp_QL_GetQuoteTransfers_Result> GetQuoteTransfers()
        {
            using (var context = new MONITOREntitiesQuoteLogIntegrationQuoteTransfer())
            {
                return context.usp_QL_GetQuoteTransfers().ToList();
            }
        }
    }
}