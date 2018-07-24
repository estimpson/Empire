using System;
using System.Data.Entity.Core.Objects;
using System.Linq;
using SupplierEDI.Web.SupplierEDIModule.Models;

namespace SupplierEDI.Web.SupplierEDIModule.ViewModels
{
    public class PurchaseOrder830ViewModel
    {
        public string GetPreview(Int32 purchaseOrderNumber)
        {
            using (var context = new SupplierEDI_Entities())
            {
                var tradingPartnerCode = context.PurchaseOrders
                    .First(po => po.PurchaseOrderNumber == purchaseOrderNumber).TradingPartnerCode;

                var xml830 = new ObjectParameter("xml830", typeof(string));
                var tranDT = new ObjectParameter("tranDT", typeof(DateTime?));
                var result = new ObjectParameter("result", typeof(int?));
                var debugMsg = new ObjectParameter("debugMsg", typeof(string));
                context.usp_Get830XML(tradingPartnerCode, purchaseOrderNumber.ToString(), null, "05", false, xml830, result,
                    tranDT, 0, debugMsg);

                return (string) xml830.Value;
            }
        }
    }
}