using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using SupplierEDI.Web.SupplierEDIModule.Models;

namespace SupplierEDI.Web.SupplierEDIModule.ViewModels
{
    public class PurchaseOrdersViewModel
    {
        public List<usp_GetPurchaseOrderList_Result> PurchaseOrderList = new List<usp_GetPurchaseOrderList_Result>();

        public List<usp_GetPurchaseOrderList_Result> GetList()
        {
            PurchaseOrderList.Clear();
            using (var context = new SupplierEDI_Entities())
            {
                var tranDT = new ObjectParameter("tranDT", typeof(DateTime?));
                var result = new ObjectParameter("result", typeof(int?));
                var debugMsg = new ObjectParameter("debugMsg", typeof(string));
                var resultSet = context.usp_GetPurchaseOrderList(tranDT, result, 0, debugMsg);
                PurchaseOrderList.AddRange(resultSet.ToList());
            }

            return PurchaseOrderList;
        }
    }
}