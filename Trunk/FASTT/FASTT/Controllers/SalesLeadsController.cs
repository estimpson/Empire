using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using FASTT.Model;
using FASTT.DataModels;
using FASTT.Controls;

namespace FASTT.Controllers
{
    public class SalesLeadsController
    {
        #region Class Objects

        private MONITOREntities1 _context;
        private readonly CustomMessageBox _messageBox;

        //public BindingSource BindingSource;
        private SalesLeadDataModel _salesLeadDataModel;
        public List<SalesLeadDataModel> SalesLeadsList = new List<SalesLeadDataModel>();

        #endregion


        #region Constructor

        public SalesLeadsController()
        {
            _context = new MONITOREntities1();
            _messageBox = new CustomMessageBox();
            //BindingSource = new BindingSource();
        }

        #endregion


        #region Methods

        public List<string> GetCustomers(out string error)
        {
            error = "";
            var customersList = new List<string>();

            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    _context.vw_ST_CombinedLighting.Load();
                    if (!_context.vw_ST_CombinedLighting.Any()) return null;

                    var q = from cl in _context.vw_ST_CombinedLighting
                            group cl by new { cl.Customer }    
                            into clGroup
                            orderby clGroup.Key.Customer
                            select new { cust = clGroup.Key.Customer };

                    customersList.Add("");
                    customersList.Add("All");
                    customersList.AddRange(q.Select(item => item.cust));
                    return customersList;
                }
            }
            catch (Exception ex)
            {
                error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            }
            return null;
        }

        public void GetGridDataByCustomer(string customer)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            //BindingSource = null;
            //BindingSource = new BindingSource();

            SalesLeadsList.Clear();
            if (customer == "") return;

            try
            {              
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    //_context.ST_Csm_SalesForecast.Where(sf => sf.parent_customer == parentCustomer).Load();
                    //if (!_context.ST_Csm_SalesForecast.Any()) return;
                    //BindingSource.DataSource = _context.ST_Csm_SalesForecast.Local;

                    if (customer == "All")
                    {
                        var q = from cl in _context.vw_ST_CombinedLighting
                                orderby cl.Customer, cl.Sop, cl.Program
                                select cl;

                        foreach (var item in q.ToList())
                        {
                            _salesLeadDataModel = new SalesLeadDataModel
                            {
                                Customer = item.Customer,
                                Program = item.Program,
                                Application = item.Application,
                                Sop = item.Sop,
                                Volume = item.TotalComponentVolume,
                                ID = item.ID
                            };
                            SalesLeadsList.Add(_salesLeadDataModel);
                        }
                    }
                    else
                    {
                        var q = from cl in _context.vw_ST_CombinedLighting
                                where cl.Customer == customer 
                                orderby cl.Sop, cl.Program
                                select cl;

                        foreach (var item in q.ToList())
                        {
                            _salesLeadDataModel = new SalesLeadDataModel
                            {
                                Customer = item.Customer,
                                Program = item.Program,
                                Application = item.Application,
                                Sop = item.Sop,
                                Volume = item.TotalComponentVolume,
                                ID = item.ID
                            };
                            SalesLeadsList.Add(_salesLeadDataModel);
                        }
                    }


                    if (SalesLeadsList.Count < 1)
                    {
                        _messageBox.Message = string.Format("No sales leads were found for {0}.", customer);
                        _messageBox.ShowDialog();
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


    }
}
