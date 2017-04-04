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
                    _context.vw_ST_LightingStudy_Hitlist_2016.Load();
                    if (!_context.vw_ST_LightingStudy_Hitlist_2016.Any()) return null;

                    var q = from cl in _context.vw_ST_LightingStudy_Hitlist_2016
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

        public int GetGridDataAllCustomersAllYears()
        {
            SalesLeadsList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    var q = from cl in _context.vw_ST_LightingStudy_Hitlist_2016
                            where cl.SOPYear == 2017 || cl.SOPYear == 2018 || cl.SOPYear == 2019
                            orderby cl.SOP, cl.Program
                            select cl;

                    foreach (var item in q.ToList())
                    {
                        _salesLeadDataModel = new SalesLeadDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            Volume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            Status = item.Status,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            ID = item.ID
                        };
                        SalesLeadsList.Add(_salesLeadDataModel);
                    }

                    if (SalesLeadsList.Count < 1)
                    {
                        _messageBox.Message = "No sales leads were found.";
                        _messageBox.ShowDialog();
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetGridDataAllCustomersOneYear(string year)
        {
            int iYear;
            try
            {
                iYear = Convert.ToInt32(year);
            }
            catch (Exception ex)
            {
                _messageBox.Message = string.Format("Year must be numeric");
                _messageBox.ShowDialog();
                return 0;
            }

            SalesLeadsList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    var q = from cl in _context.vw_ST_LightingStudy_Hitlist_2016
                            where cl.SOPYear == iYear
                            orderby cl.SOP, cl.Program
                            select cl;

                    foreach (var item in q.ToList())
                    {
                        _salesLeadDataModel = new SalesLeadDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            Volume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            Status = item.Status,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            ID = item.ID
                        };
                        SalesLeadsList.Add(_salesLeadDataModel);
                    }

                    if (SalesLeadsList.Count < 1)
                    {
                        _messageBox.Message = "No sales leads were found.";
                        _messageBox.ShowDialog();
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetGridDataOneCustomerAllYears(string customer)
        {
            SalesLeadsList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    var q = from cl in _context.vw_ST_LightingStudy_Hitlist_2016
                            where cl.Customer == customer && (cl.SOPYear == 2017 || cl.SOPYear == 2018 || cl.SOPYear == 2019)
                            orderby cl.SOP, cl.Program
                            select cl;

                    foreach (var item in q.ToList())
                    {
                        _salesLeadDataModel = new SalesLeadDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            Volume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            Status = item.Status,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            ID = item.ID
                        };
                        SalesLeadsList.Add(_salesLeadDataModel);
                    }

                    if (SalesLeadsList.Count < 1)
                    {
                        _messageBox.Message = "No sales leads were found.";
                        _messageBox.ShowDialog();
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetGridDataOneCustomerOneYear(string customer, string year)
        {
            //var res = new ObjectParameter("Result", typeof(Int32));
            //var td = new ObjectParameter("TranDT", typeof(DateTime));

            //BindingSource = null;
            //BindingSource = new BindingSource();

            int iYear;
            try
            {
                iYear = Convert.ToInt32(year);
            }
            catch (Exception ex)
            {
                _messageBox.Message = string.Format("Year must be numeric");
                _messageBox.ShowDialog();
                return 0;
            }

            SalesLeadsList.Clear();
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

                    var q = from cl in _context.vw_ST_LightingStudy_Hitlist_2016
                            where cl.Customer == customer && cl.SOPYear == iYear
                            orderby cl.SOP, cl.Program
                            select cl;

                    foreach (var item in q.ToList())
                    {
                        _salesLeadDataModel = new SalesLeadDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            Volume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            Status = item.Status,
                            SalesPerson = item.SalesPerson,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            ID = item.ID
                        };
                        SalesLeadsList.Add(_salesLeadDataModel);
                    }

                    if (SalesLeadsList.Count < 1)
                    {
                        _messageBox.Message = string.Format("No sales leads were found for {0}.", customer);
                        _messageBox.ShowDialog();
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales lead data.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int SearchForExistingSalesLead(int combinedLightingId)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities1();
                }

                if (_context != null)
                {
                    _context.usp_ST_SalesLeadLog_Hitlist_SearchForSalesLeads(combinedLightingId, td, res);
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion


    }
}
