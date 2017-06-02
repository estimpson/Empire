using System;
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
        public List<string> HitlistCustomersList = new List<string>();
        public List<string> HitlistCustomerSopsList = new List<string>();

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

        private ReportHitlistMsfDataModel _hitlistMsfDataModel;
        public readonly List<ReportHitlistMsfDataModel> ListHitlistMsf = new List<ReportHitlistMsfDataModel>(); 

        private DashboardSalesForecastDataModel _dashboardSalesForecast;
        public readonly List<DashboardSalesForecastDataModel> DashboardSalesForecastList = new List<DashboardSalesForecastDataModel>();

        private DashboardNewQuotesByCustomerDataModel _dashboardNewQuotesByCustomer;
        public readonly List<DashboardNewQuotesByCustomerDataModel> DashboardNewQuotesByCustomerList = new List<DashboardNewQuotesByCustomerDataModel>();

        #endregion


        #region Constructor

        public ReportsController()
        {
            _context = new MONITOREntities();
            _messageBox = new CustomMessageBox();
        }

        #endregion


        #region Customer ComboBox Methods (Charts)

        public int GetAllLightingStudyCustomers(string region)
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
                    _context.ST_CustomersAll.Load();
                    if (!_context.ST_CustomersAll.Any()) return 0;

                    var q = from ca in _context.ST_CustomersAll
                            where ca.Region == region
                            orderby ca.Customer
                            select ca;

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

        public int GetCustomersForProgramsLaunchingClosing2017(string region)
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
                    _context.ST_CustomersWithProgramsLaunchingClosing2017.Load();
                    if (!_context.ST_CustomersWithProgramsLaunchingClosing2017.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunchingClosing2017
                            where pl.Region == region
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

        public int GetCustomersForProgramsLaunchingClosing2018(string region)
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
                    _context.ST_CustomersWithProgramsLaunchingClosing2018.Load();
                    if (!_context.ST_CustomersWithProgramsLaunchingClosing2018.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunchingClosing2018
                            where pl.Region == region
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

        public int GetCustomersForProgramsLaunchingClosing2019(string region)
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
                    _context.ST_CustomersWithProgramsLaunchingClosing2019.Load();
                    if (!_context.ST_CustomersWithProgramsLaunchingClosing2019.Any()) return 0;

                    var q = from pl in _context.ST_CustomersWithProgramsLaunchingClosing2019
                            where pl.Region == region
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

        #endregion


        #region Customer ComboBox Methods (Hitlist report)

        public int GetHitListCustomers(string region)
        {
            HitlistCustomersList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    HitlistCustomersList.Add("");
                    var queryResult = _context.usp_ST_Report_Hitlist_GetCustomerList(region).ToList();
                    foreach (var item in queryResult) HitlistCustomersList.Add(item.Customer);
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customers list for report.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        public int GetHitListCustomerSops(string customer)
        {
            HitlistCustomerSopsList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    HitlistCustomerSopsList.Add("All");
                    var queryResult = _context.usp_ST_Report_Hitlist_GetSopList(customer).ToList();
                    foreach (var item in queryResult) HitlistCustomerSopsList.Add(item.SOPYear.ToString());
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return Customer SOPs list for report.  Error: {0}", error);
                _messageBox.ShowDialog();
                return 0;
            }
            return 1;
        }

        #endregion


        #region Quote Log Grid Methods

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
                            Status = item.QuoteStatus,
                            Customer = item.Customer,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            EeiPartNumber = item.EEIPartNumber,
                            //TotalQuotedSales = string.Format("{0:n0}", item.TotalQuotedSales),
                            TotalQuotedSales = item.TotalQuotedSales,
                            Notes = item.Notes,                           
                            Eau = item.EAU,
                            QuotePrice = item.QuotePrice,
                            QuotePricingDate = item.QuotePricingDate,
                            Awarded = item.Awarded,
                            MaterialPercentage = (item.MaterialPercentage > 0) ? string.Format("{0:P2}", item.MaterialPercentage) : ""
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

        public void GetNewQuotes(int numberOfDays)
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
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_NewQuotes(numberOfDays, td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _newQuotesDataModel = new ReportNewQuotesDataModel
                        {
                            QuoteStatus = item.QuoteStatus,
                            Customer = item.Customer,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            EeiPartNumber = item.EEIPartNumber,
                            //TotalQuotedSales = string.Format("{0:n0}", item.TotalQuotedSales),
                            TotalQuotedSales = item.TotalQuotedSales,
                            Notes = item.Notes,
                            Eau = item.EAU,
                            QuotePrice = item.QuotePrice,
                            QuotePricingDate = item.QuotePricingDate,
                            Awarded = item.Awarded,
                            MaterialPercentage = (item.MaterialPercentage > 0) ? string.Format("{0:P2}", item.MaterialPercentage) : ""
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

        #endregion


        #region Sales Activity Grid Methods

        public void GetSalesActivityHistory(int numberOfDays)
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
                    var queryResult = _context.usp_ST_Report_Hitlist_SalesActivity(numberOfDays);
                    foreach (var item in queryResult)
                    {
                        _salesPersonActivityDataModel = new ReportSalesPersonActivityDataModel
                        {
                            LastSalesPerson = item.SalesPerson,
                            OEM = item.OEM,
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Type = item.Type,
                            Nameplate = item.Nameplate,
                            Region = item.Region,
                            SOP = item.SOP,
                            EOP = item.EOP,
                            PeakYearlyVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            EstYearlySales = item.EstYearlySales,
                            Status = item.Status,
                            ActivityDate = item.ActivityDate,
                            Activity = item.Activity,
                            MeetingLocation = item.MeetingLocation,
                            ContactName = item.ContactName,
                            ContactPhoneNumber = item.ContactPhoneNumber,
                            ContactEmailAddress = item.ContactEmailAddress,
                            Duration = item.Duration,
                            Notes = item.Notes,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            Price = item.Price,
                            SOPYear = item.SOPYear,
                            Component = item.Component,
                            LED_Harness = item.LED_Harness,
                            ID = item.ID,
                            SalesLeadID = Convert.ToInt32(item.RowID)
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

        public void GetHitlist(string region, string customer, int? sopYear)
        {
            ListHitlistMsf.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    //var queryResult = _context.usp_ST_Report_Hitlist_MSF(customer, region, sopYear);            
                    var queryResult = _context.usp_ST_Report_Hitlist_MSF_New3(customer, region, sopYear);
                    foreach (var item in queryResult)
                    {
                        _hitlistMsfDataModel = new ReportHitlistMsfDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            EstYearlySales = item.EstYearlySales,
                            PeakYearlyVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            SOPYear = item.SOPYear,
                            LED_Harness = item.LED_Harness,
                            Application = item.Application, 
                            Region = item.Region,
                            OEM = item.OEM,
                            Nameplate = item.NamePlate,
                            Component = item.Component,
                            SOP = item.SOP,
                            EOP = item.EOP,
                            Type = item.Type,
                            Price = item.Price,
                            Volume2017 = item.Volume2017,
                            Volume2018 = item.Volume2018,
                            Volume2019 = item.Volume2019,
                            Volume2020 = item.Volume2020,
                            Volume2021 = item.Volume2021,
                            Volume2022 = item.Volume2022,
                            ID = item.ID,
                            SalesLeadID = item.SalesLeadId,
                            SalesPerson = item.SalesPerson,
                            QuoteNumber = item.QuoteNumber,
                            EEIPartNumber = item.EEIPartNumber,
                            EAU = item.EAU,
                            ApplicationName = item.ApplicationName,
                            SalesInitials = item.SalesInitials,
                            QuotePrice = item.QuotePrice,
                            Awarded = item.Awarded,
                            QuoteStatus = item.QuoteStatus,
                            StraightMaterialCost = item.StraightMaterialCost,
                            TotalQuotedSales = (item.TotalQuotedSales.HasValue) ?item.TotalQuotedSales : 0,
                            MsfVehicle = item.SalesForecastVehicle,
                            MsfEeiBasePart = item.SalesForecastEEIBasePart,
                            MsfSopYear = item.SalesForecastSopYear,
                            MsfEopYear = item.SalesForecastEopYear,
                            MsfTotalPeakYearlySales = (item.SalesForecastTotalPeakYearlySales.HasValue) ? item.SalesForecastTotalPeakYearlySales : 0,
                            MsfApplication = item.SalesForecastApplication
                        };
                        ListHitlistMsf.Add(_hitlistMsfDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales hitlist data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


        #region Programs Charts Methods

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

        public void GetPeakVolumeOfProgramsLaunching2017ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2017List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2017_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2017(customer, region))
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

        public void GetPeakVolumeOfProgramsLaunching2018ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2018List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2018_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2018(customer, region))
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

        public void GetPeakVolumeOfProgramsLaunching2019ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsLaunching2019List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsLaunching2019_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsLaunching2019(customer, region))
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

        public void GetPeakVolumeOfProgramsClosing2017ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2017List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2017_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2017(customer, region))
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

        public void GetPeakVolumeOfProgramsClosing2018ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2018List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2018_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2018(customer, region))
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

        public void GetPeakVolumeOfProgramsClosing2019ByCustomer(string region, string customer, out string error)
        {
            error = "";
            PeakVolumeOfProgramsClosing2019List.Clear();

            try
            {
                foreach (PeakVolumeOfProgramsClosing2019_Result item in _context.usp_ST_Metrics_PeakVolumeOfProgramsClosing2019(customer, region))
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

        #endregion


        #region Dashboard Grid Methods

        public void GetSalesForecastDataByCustomer(string customer)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            DashboardSalesForecastList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_Reports_GetSalesForecastData(customer, td, res);
                    foreach (var item in queryResult)
                    {
                        _dashboardSalesForecast = new DashboardSalesForecastDataModel
                        {
                            Customer = item.Customer,
                            Sales2016 = item.Sales_2016,
                            Sales2017 = item.Sales_2017,
                            Sales2018 = item.Sales_2018,
                            Sales2019 = item.Sales_2019,
                            Sales2020 = item.Sales_2020,
                            Sales2021 = item.Sales_2021,
                            Sales2022 = item.Sales_2022
                        };
                        DashboardSalesForecastList.Add(_dashboardSalesForecast);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales forecast data.  {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetNewQuotesByCustomer(string customer)
        {
            var res = new ObjectParameter("Result", typeof(Int32));
            var td = new ObjectParameter("TranDT", typeof(DateTime));

            DashboardNewQuotesByCustomerList.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    var queryResult = _context.usp_ST_SalesLeadLog_Report_NewQuotesByCustomer(customer, td, res);
                    foreach (var item in queryResult.ToList())
                    {
                        _dashboardNewQuotesByCustomer = new DashboardNewQuotesByCustomerDataModel
                        {
                            QuoteStatus = item.QuoteStatus,
                            Customer = item.Customer,
                            Program = item.Program,
                            ApplicationName = item.ApplicationName,
                            SalesInitials = item.SalesInitials,
                            Sop = item.SOP,
                            Eop = item.EOP,
                            EeiPartNumber = item.EEIPartNumber,
                            //TotalQuotedSales = string.Format("{0:n0}", item.TotalQuotedSales),
                            TotalQuotedSales = item.TotalQuotedSales,
                            Notes = item.Notes,                         
                            Eau = item.EAU,
                            QuotePrice = item.QuotePrice,
                            QuotePricingDate = item.QuotePricingDate,
                            Awarded = item.Awarded,
                            MaterialPercentage = (item.MaterialPercentage > 0) ? string.Format("{0:P2}", item.MaterialPercentage) : ""
                        };
                        DashboardNewQuotesByCustomerList.Add(_dashboardNewQuotesByCustomer);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return new quote data for this customer.  {0}", error);
                _messageBox.ShowDialog();
            }
        }

        public void GetHitlistMsfDashboard(string customer, int? sopYear)
        {
            ListHitlistMsf.Clear();
            try
            {
                if (_context != null)
                {
                    _context.Dispose();
                    _context = new MONITOREntities();
                }

                if (_context != null)
                {
                    //var queryResult = _context.usp_ST_Report_Hitlist_MSF(customer, region, sopYear);            
                    var queryResult = _context.usp_ST_Report_Hitlist_MSF_Dashboard_New3(customer, sopYear);
                    foreach (var item in queryResult)
                    {
                        _hitlistMsfDataModel = new ReportHitlistMsfDataModel
                        {
                            Customer = item.Customer,
                            Program = item.Program,
                            EstYearlySales = item.EstYearlySales,
                            PeakYearlyVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            SOPYear = item.SOPYear,
                            LED_Harness = item.LED_Harness,
                            Application = item.Application,
                            Region = item.Region,
                            OEM = item.OEM,
                            Nameplate = item.NamePlate,
                            Component = item.Component,
                            SOP = item.SOP,
                            EOP = item.EOP,
                            Type = item.Type,
                            Price = item.Price,
                            Volume2017 = item.Volume2017,
                            Volume2018 = item.Volume2018,
                            Volume2019 = item.Volume2019,
                            Volume2020 = item.Volume2020,
                            Volume2021 = item.Volume2021,
                            Volume2022 = item.Volume2022,
                            ID = item.ID,
                            SalesLeadID = item.SalesLeadId,
                            SalesPerson = item.SalesPerson,
                            QuoteNumber = item.QuoteNumber,
                            EEIPartNumber = item.EEIPartNumber,
                            EAU = item.EAU,
                            ApplicationName = item.ApplicationName,
                            SalesInitials = item.SalesInitials,
                            QuotePrice = item.QuotePrice,
                            Awarded = item.Awarded,
                            QuoteStatus = item.QuoteStatus,
                            StraightMaterialCost = item.StraightMaterialCost,
                            TotalQuotedSales = item.TotalQuotedSales,
                            MsfVehicle = item.SalesForecastVehicle,
                            MsfEeiBasePart = item.SalesForecastEEIBasePart,
                            MsfSopYear = item.SalesForecastSopYear,
                            MsfEopYear = item.SalesForecastEopYear,
                            MsfTotalPeakYearlySales = (item.SalesForecastTotalPeakYearlySales.HasValue) ? item.SalesForecastTotalPeakYearlySales : 0,
                            MsfApplication = item.SalesForecastApplication
                        };
                        ListHitlistMsf.Add(_hitlistMsfDataModel);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Failed to return sales hitlist data.  Error: {0}", error);
                _messageBox.ShowDialog();
            }

            //ListHitlistMsf.Clear();
            //try
            //{
            //    if (_context != null)
            //    {
            //        _context.Dispose();
            //        _context = new MONITOREntities();
            //    }

            //    if (_context != null)
            //    {
            //        var queryResult = _context.usp_ST_Report_Hitlist_MSF_Dashboard(customer, sopYear);
            //        foreach (var item in queryResult)
            //        {
            //            _hitlistMsfDataModel = new ReportHitlistMsfDataModel
            //            {
            //                Customer = item.Customer,
            //                Program = item.Program,
            //                EstYearlySales = item.EstYearlySales,
            //                PeakYearlyVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
            //                SOPYear = item.SOPYear,
            //                LED_Harness = item.LED_Harness,
            //                Application = item.Application,
            //                Region = item.Region,
            //                OEM = item.OEM,
            //                Nameplate = item.NamePlate,
            //                Component = item.Component,
            //                SOP = item.SOP,
            //                EOP = item.EOP,
            //                Type = item.Type,
            //                Price = item.Price,
            //                Volume2017 = item.Volume2017,
            //                Volume2018 = item.Volume2018,
            //                Volume2019 = item.Volume2019,
            //                Volume2020 = item.Volume2020,
            //                Volume2021 = item.Volume2021,
            //                Volume2022 = item.Volume2022,
            //                ID = item.ID,
            //                SalesLeadID = item.SalesLeadId,
            //                SalesPerson = item.SalesPerson,
            //                QuoteNumber = item.QuoteNumber,
            //                EEIPartNumber = item.EEIPartNumber,
            //                EAU = item.EAU,
            //                ApplicationName = item.ApplicationName,
            //                SalesInitials = item.SalesInitials,
            //                QuotePrice = item.QuotePrice,
            //                Awarded = item.Awarded,
            //                QuoteStatus = item.QuoteStatus,
            //                StraightMaterialCost = item.StraightMaterialCost,
            //                SalesForecastVehicle = item.SalesForecastVehicle,
            //                TotalQuotedSales = item.TotalQuotedSales,
            //                SalesForecastEEIBasePart = item.SalesForecastEEIBasePart,
            //                SalesForecastTotalPeakYearlySales = (item.SalesForecastTotalPeakYearlySales.HasValue) ? item.SalesForecastTotalPeakYearlySales : 0
            //            };
            //            ListHitlistMsf.Add(_hitlistMsfDataModel);
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
            //    _messageBox.Message = string.Format("Failed to return sales hitlist data.  Error: {0}", error);
            //    _messageBox.ShowDialog();
            //}
        }

        public void GetSalesActivityHistoryByCustomer(string customer)
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
                    var queryResult = _context.usp_ST_Report_Hitlist_SalesActivityByCustomer(customer);
                    foreach (var item in queryResult)
                    {
                        _salesPersonActivityDataModel = new ReportSalesPersonActivityDataModel
                        {
                            LastSalesPerson = item.SalesPerson,
                            OEM = item.OEM,
                            Customer = item.Customer,
                            Program = item.Program,
                            Application = item.Application,
                            Type = item.Type,
                            Nameplate = item.Nameplate,
                            Region = item.Region,
                            SOP = item.SOP,
                            EOP = item.EOP,
                            PeakYearlyVolume = string.Format("{0:n0}", item.PeakYearlyVolume),
                            EstYearlySales = item.EstYearlySales,
                            Status = item.Status,
                            ActivityDate = item.ActivityDate,
                            Activity = item.Activity,
                            MeetingLocation = item.MeetingLocation,
                            ContactName = item.ContactName,
                            ContactPhoneNumber = item.ContactPhoneNumber,
                            ContactEmailAddress = item.ContactEmailAddress,
                            Duration = item.Duration,
                            Notes = item.Notes,
                            AwardedVolume = (item.AwardedVolume.HasValue) ? string.Format("{0:n0}", item.AwardedVolume) : "",
                            Price = item.Price,
                            SOPYear = item.SOPYear,
                            Component = item.Component,
                            LED_Harness = item.LED_Harness,
                            ID = Convert.ToInt32(item.ID),
                            SalesLeadID = item.RowID
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

        #endregion


    }
}
