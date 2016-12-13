using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ImportSpreadsheetData.Model;
using ImportSpreadsheetData.DataModels;

namespace ImportSpreadsheetData.DataLayer
{
    public class SalesOrderMaintenance
    {
        #region Class Objects

        private MONITOREntities_OrderMaintenance _context;

        private SalesOrderDataModel _salesOrder;
        public List<SalesOrderDataModel> SalesOrdersList = new List<SalesOrderDataModel>(); 

        #endregion


        #region Constructor

        public SalesOrderMaintenance()
        {
            _context = new MONITOREntities_OrderMaintenance();
        }

        #endregion


        #region Methods

        public void GetSalesOrders(string destination, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(Int32));

            try
            {
                SalesOrdersList.Clear(); 

                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities_OrderMaintenance(); 
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_PlanningReleaseManualImport_GetOrders(destination, tranDt, result);
                    foreach (var item in queryResult.ToList())
                    {
                        _salesOrder = new SalesOrderDataModel()
                        {
                            OrderNo = Convert.ToInt32(item.OrderNo),
                            BlanketPart = item.BlanketPart,
                            CustomerPart = item.CustomerPart,
                            ModelYear = item.ModelYear
                        };
                        SalesOrdersList.Add(_salesOrder);
                    }
                    if (!SalesOrdersList.Any())
                    {
                        error = string.Format("No active sales orders were found for destination {0}", destination);
                    }
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        public void UpdateSalesOrder(int orderNo, string modelYear, out string error)
        {
            error = "";
            var tranDt = new ObjectParameter("TranDT", typeof(DateTime));
            var result = new ObjectParameter("Result", typeof(Int32));

            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities_OrderMaintenance();
                }

                if (_context != null) _context.usp_PlanningReleaseManualImport_UpdateModelYear(orderNo, modelYear, tranDt, result);
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
        }

        #endregion


    }
}
