﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Objects;
using System.Linq;
using FASTT.Controls;
using FASTT.Model;
using FASTT.DataModels;

namespace FASTT.Controllers
{
    public class ReportsController
    {
        #region Class Objects

        private MONITOREntities _context;
        private readonly CustomMessageBox _messageBox;

        public List<string> CustomersList = new List<string>(); 

        private ReportOpenQuotesDataModel _openQuotesDataModel;
        public readonly List<ReportOpenQuotesDataModel> ListOpenQuotes = new List<ReportOpenQuotesDataModel>();

        private ReportNewQuotesDataModel _newQuotesDataModel;
        public readonly List<ReportNewQuotesDataModel> ListNewQuotes = new List<ReportNewQuotesDataModel>();

        private Metrics_ProgramsLaunchingByCustomer _programsLaunchingByCustomer;
        public List<Metrics_ProgramsLaunchingByCustomer> ProgramsLaunchingByCustomerList = new List<Metrics_ProgramsLaunchingByCustomer>();

        private Metrics_PeakVolumeOfProgramsLaunching _peakVolumeOfProgramsLaunching;
        public List<Metrics_PeakVolumeOfProgramsLaunching> PeakVolumeOfProgramsLaunchingList = new List<Metrics_PeakVolumeOfProgramsLaunching>();

        private Metrics_PeakVolumeOfProgramsLaunching2017 _peakVolumeOfProgramsLaunching2017;
        public List<Metrics_PeakVolumeOfProgramsLaunching2017> PeakVolumeOfProgramsLaunching2017List = new List<Metrics_PeakVolumeOfProgramsLaunching2017>();

        private Metrics_PeakVolumeOfProgramsLaunching2018 _peakVolumeOfProgramsLaunching2018;
        public List<Metrics_PeakVolumeOfProgramsLaunching2018> PeakVolumeOfProgramsLaunching2018List = new List<Metrics_PeakVolumeOfProgramsLaunching2018>();

        private Metrics_PeakVolumeOfProgramsLaunching2019 _peakVolumeOfProgramsLaunching2019;
        public List<Metrics_PeakVolumeOfProgramsLaunching2019> PeakVolumeOfProgramsLaunching2019List = new List<Metrics_PeakVolumeOfProgramsLaunching2019>();

        private Metrics_PeakVolumeOfProgramsClosing2017 _peakVolumeOfProgramsClosing2017;
        public List<Metrics_PeakVolumeOfProgramsClosing2017> PeakVolumeOfProgramsClosing2017List = new List<Metrics_PeakVolumeOfProgramsClosing2017>();

        private Metrics_PeakVolumeOfProgramsClosing2018 _peakVolumeOfProgramsClosing2018;
        public List<Metrics_PeakVolumeOfProgramsClosing2018> PeakVolumeOfProgramsClosing2018List = new List<Metrics_PeakVolumeOfProgramsClosing2018>();

        private Metrics_PeakVolumeOfProgramsClosing2019 _peakVolumeOfProgramsClosing2019;
        public List<Metrics_PeakVolumeOfProgramsClosing2019> PeakVolumeOfProgramsClosing2019List = new List<Metrics_PeakVolumeOfProgramsClosing2019>();

        private ReportSalesPersonActivityDataModel _salesPersonActivityDataModel;
        public readonly List<ReportSalesPersonActivityDataModel> ListSalesPersonActivity = new List<ReportSalesPersonActivityDataModel>();

        private ReportTopLeadsDataModel _topLeadsDataModel;
        public readonly List<ReportTopLeadsDataModel> ListTopLeads = new List<ReportTopLeadsDataModel>();

        private Metrics_TotalSalesActivity_ThirtyDays _totalSalesActivityThirtyDays;
        public readonly List<Metrics_TotalSalesActivity_ThirtyDays> TotalSalesActivityThirtyDaysList = new List<Metrics_TotalSalesActivity_ThirtyDays>();

        #endregion


        #region Constructor

        public ReportsController()
        {
            _context = new MONITOREntities();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Methods

        public int GetCustomersForProgramsLaunching2017()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsLaunching2017.Load();
                    if (!_context.ST_CustomersWithProgramsLaunching2017.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunching2017
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetCustomersForProgramsLaunching2018()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsLaunching2018.Load();
                    if (!_context.ST_CustomersWithProgramsLaunching2018.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunching2018
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetCustomersForProgramsLaunching2019()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsLaunching2019.Load();
                    if (!_context.ST_CustomersWithProgramsLaunching2019.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunching2019
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetCustomersForProgramsClosing2017()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsClosing2017.Load();
                    if (!_context.ST_CustomersWithProgramsClosing2017.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsClosing2017
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetCustomersForProgramsClosing2018()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsClosing2018.Load();
                    if (!_context.ST_CustomersWithProgramsClosing2018.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsClosing2018
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetCustomersForProgramsClosing2019()
        {
            CustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    _context.ST_CustomersWithProgramsClosing2019.Load();
                    if (!_context.ST_CustomersWithProgramsClosing2019.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsClosing2019
                            orderby pl.Customer
                            select pl;

                    CustomersList.Add("");
                    CustomersList.AddRange(q.Select(item => item.Customer));
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public void GetOpenQuotes()
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            ListOpenQuotes.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_OpenQuotes(td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _openQuotesDataModel = new ReportOpenQuotesDataModel
                        {
                            QuoteNumber = item.QuoteNumber,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            Customer = item.Customer,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            EeiPartNumber = item.EEIPartNumber,
                            TotalQuotedSales = string.Format("{0:n0}", item.TotalQuotedSales)
                        };
                        ListOpenQuotes.Add(_openQuotesDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return open quote data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetNewQuotes()
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            ListNewQuotes.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_NewQuotes(td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _newQuotesDataModel = new ReportNewQuotesDataModel
                        {
                            QuoteNumber = item.QuoteNumber,
                            QuoteStatus = item.QuoteStatus,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            Customer = item.Customer,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            EeiPartNumber = item.EEIPartNumber,
                            TotalQuotedSales = string.Format("{0:n0}", item.TotalQuotedSales),
                        };
                        ListNewQuotes.Add(_newQuotesDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return new quote data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetSalesActivityHistory()
        {
            try
            {
                ListSalesPersonActivity.Clear();

                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                { 
                    var queryResult = _context.usp_ST_Report_SalesActivityOneWeek();
                    foreach (var item in queryResult)
                    {
                        _salesPersonActivityDataModel = new ReportSalesPersonActivityDataModel
                            {
                                SalesPerson = item.SalesPerson,
                                Customer = item.Customer,
                                Program = item.Program,
                                Application = item.Application,
                                SOP = item.SOP,
                                EOP = item.EOP,
                                PeakVolume = item.PeakVolume,
                                Status = item.Status,
                                ActivityDate = item.ActivityDate,
                                Activity = item.Activity,
                                MeetingLocation = item.MeetingLocation,
                                ContactName = item.ContactName,
                                ContactPhoneNumber = item.ContactPhoneNumber,
                                ContactEmailAddress = item.ContactEmailAddress,
                                Duration = item.Duration,
                                Notes = item.Notes,
                                SalesPersonCode = item.SalesPersonCode,
                                RowId = Convert.ToInt32(item.RowID),
                                CombinedLightingStudyId = item.CombinedLightingId
                            };
                        ListSalesPersonActivity.Add(_salesPersonActivityDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales activity history.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetTopLeads()
        {
            ListTopLeads.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_Report_TopLeads();
                    foreach (var item in queryResult)
                    {
                        _topLeadsDataModel = new ReportTopLeadsDataModel
                        {
                            PeakVolume = item.Volume,
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            SOP = item.SOP,
                            EOP = item.EOP,
                            SalesLeadStatus = item.SalesLeadStatus,
                            SalesPerson = item.SalesPerson,
                            RowId = item.SalesLeadId,
                            CombinedLightingStudyId = item.CombinedLightingId
                        };
                        ListTopLeads.Add(_topLeadsDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return top leads data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetProgramsLaunchingByCustomer(out string error)
        {
            error = "";
            ProgramsLaunchingByCustomerList.Clear();

            try
            {
                foreach (ProgramsLaunchingByCustomer item in _context.usp_ST_Metrics_ProgramsLaunchingByCustomer())
                {
                    _programsLaunchingByCustomer = new Metrics_ProgramsLaunchingByCustomer
                    {
                        Customer = item.Customer,
                        HeadLampCount = (item.HeadLampCount.HasValue) ? item.HeadLampCount : 0,
                        TailLampCount = (item.TailLampCount.HasValue) ? item.TailLampCount : 0
                    };
                    ProgramsLaunchingByCustomerList.Add(_programsLaunchingByCustomer);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null)
                    ? msg + ex.Message
                    : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsLaunchingByCustomer(out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunchingList.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching())
                {
                    _peakVolumeOfProgramsLaunching = new Metrics_PeakVolumeOfProgramsLaunching
                    {
                        Customer = item.Customer,
                        HalogenHeadLampPeakVolume = (item.HalogenHeadLampPeakVolume.HasValue) ? item.HalogenHeadLampPeakVolume : 0,
                        LedHeadLampPeakVolume = (item.LedHeadLampPeakVolume.HasValue) ? item.LedHeadLampPeakVolume : 0,
                        ConventionalTailLampPeakVolume = (item.ConventionalTailLampPeakVolume.HasValue) ? item.ConventionalTailLampPeakVolume : 0,
                        LedTailLampPeakVolume = (item.LedTailLampPeakVolume.HasValue) ? item.LedTailLampPeakVolume : 0
                    };
                    PeakVolumeOfProgramsLaunchingList.Add(_peakVolumeOfProgramsLaunching);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null)
                    ? msg + ex.Message
                    : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsLaunching2017ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2017List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2017_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2017(customer))
                {
                    _peakVolumeOfProgramsLaunching2017 = new Metrics_PeakVolumeOfProgramsLaunching2017
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2017.HasValue) ? item.HalogenHeadlampPeakVolume2017 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2017.HasValue) ? item.LedHeadlampPeakVolume2017 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2017.HasValue) ? item.XenonHeadlampPeakVolume2017 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2017.HasValue) ? item.LedTaillampPeakVolume2017 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2017.HasValue) ? item.ConventionalTaillampPeakVolume2017 : 0,
                    };
                    PeakVolumeOfProgramsLaunching2017List.Add(_peakVolumeOfProgramsLaunching2017);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsLaunching2018ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2018List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2018_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2018(customer))
                {
                    _peakVolumeOfProgramsLaunching2018 = new Metrics_PeakVolumeOfProgramsLaunching2018
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2018.HasValue) ? item.HalogenHeadlampPeakVolume2018 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2018.HasValue) ? item.LedHeadlampPeakVolume2018 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2018.HasValue) ? item.XenonHeadlampPeakVolume2018 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2018.HasValue) ? item.LedTaillampPeakVolume2018 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2018.HasValue) ? item.ConventionalTaillampPeakVolume2018 : 0,
                    };
                    PeakVolumeOfProgramsLaunching2018List.Add(_peakVolumeOfProgramsLaunching2018);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsLaunching2019ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2019List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2019_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2019(customer))
                {
                    _peakVolumeOfProgramsLaunching2019 = new Metrics_PeakVolumeOfProgramsLaunching2019
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2019.HasValue) ? item.HalogenHeadlampPeakVolume2019 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2019.HasValue) ? item.LedHeadlampPeakVolume2019 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2019.HasValue) ? item.XenonHeadlampPeakVolume2019 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2019.HasValue) ? item.LedTaillampPeakVolume2019 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2019.HasValue) ? item.ConventionalTaillampPeakVolume2019 : 0,
                    };
                    PeakVolumeOfProgramsLaunching2019List.Add(_peakVolumeOfProgramsLaunching2019);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsClosing2017ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2017List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2017_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2017(customer))
                {
                    _peakVolumeOfProgramsClosing2017 = new Metrics_PeakVolumeOfProgramsClosing2017
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2017.HasValue) ? item.HalogenHeadlampPeakVolume2017 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2017.HasValue) ? item.LedHeadlampPeakVolume2017 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2017.HasValue) ? item.XenonHeadlampPeakVolume2017 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2017.HasValue) ? item.LedTaillampPeakVolume2017 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2017.HasValue) ? item.ConventionalTaillampPeakVolume2017 : 0,
                    };
                    PeakVolumeOfProgramsClosing2017List.Add(_peakVolumeOfProgramsClosing2017);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsClosing2018ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2018List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2018_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2018(customer))
                {
                    _peakVolumeOfProgramsClosing2018 = new Metrics_PeakVolumeOfProgramsClosing2018
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2018.HasValue) ? item.HalogenHeadlampPeakVolume2018 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2018.HasValue) ? item.LedHeadlampPeakVolume2018 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2018.HasValue) ? item.XenonHeadlampPeakVolume2018 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2018.HasValue) ? item.LedTaillampPeakVolume2018 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2018.HasValue) ? item.ConventionalTaillampPeakVolume2018 : 0,
                    };
                    PeakVolumeOfProgramsClosing2018List.Add(_peakVolumeOfProgramsClosing2018);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetPeakVolumeOfProgramsClosing2019ByCustomer(string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2019List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2019_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2019(customer))
                {
                    _peakVolumeOfProgramsClosing2019 = new Metrics_PeakVolumeOfProgramsClosing2019
                    {
                        Program = item.Program,
                        HalogenHeadlampPeakVolume = (item.HalogenHeadlampPeakVolume2019.HasValue) ? item.HalogenHeadlampPeakVolume2019 : 0,
                        LedHeadlampPeakVolume = (item.LedHeadlampPeakVolume2019.HasValue) ? item.LedHeadlampPeakVolume2019 : 0,
                        XenonHeadlampPeakVolume = (item.XenonHeadlampPeakVolume2019.HasValue) ? item.XenonHeadlampPeakVolume2019 : 0,
                        LedTaillampPeakVolume = (item.LedTaillampPeakVolume2019.HasValue) ? item.LedTaillampPeakVolume2019 : 0,
                        ConventionalTaillampPeakVolume = (item.ConventionalTaillampPeakVolume2019.HasValue) ? item.ConventionalTaillampPeakVolume2019 : 0,
                    };
                    PeakVolumeOfProgramsClosing2019List.Add(_peakVolumeOfProgramsClosing2019);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }

        public void GetTotalSalesActivityThirtyDays(out string error)
        {
            error = "";
            TotalSalesActivityThirtyDaysList.Clear();

            try
            {
                foreach (usp_ST_Metrics_TotalSalesActivityOneMonth_Result item in _context.usp_ST_Metrics_TotalSalesActivityOneMonth())
                {
                    _totalSalesActivityThirtyDays = new Metrics_TotalSalesActivity_ThirtyDays
                    {
                        Opened = item.Opened,
                        Quoted = item.Quoted,
                        Awarded = item.Awarded,
                        Closed = item.Closed
                    };
                    TotalSalesActivityThirtyDaysList.Add(_totalSalesActivityThirtyDays);
                }
            }
            catch (Exception ex)
            {
                string msg = "Failed to return data.  Error: ";
                error = (ex.InnerException == null) ? msg + ex.Message : msg + ex.InnerException.Message;
            }
        }


        #endregion


    }
}
