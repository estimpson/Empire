using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using System.Data.Entity;
using System.Data.Objects;
using DevExpress.XtraCharts;

namespace QuoteLogMetrics
{
    public class Metrics
    {
        private QuoteLogContext context = new QuoteLogContext();

        public List<TotalQuotesReceivedPerYear> quotesPerYear;
        public List<QuotesPerMonth> quotesPerMonth;
        public List<CompletedQuotes> completedQuotes;
        public List<QuotesCompletedByEstimator> compQuotesByEstimator;
        public List<OnTimeDelivery> onTimeDelivery;
        public List<OnTimeDaysLateBreakdown> onTimeDaysLateBreakdown; 
        public List<OnTimeByQuoteEngineer> onTimeByEngineer;
        public List<QuoteRequestsPerMonth> quoteRequestsPerMonth;
        public List<QuoteRequestsPerMonthSalesperson> quoteRequestsPerMonthSalesperson;
        public List<CategoryByQuantity> categoryByQuantity;
        public List<TopCustomersByQuotes> topCustomersByQuotes;
        public List<TopCustomersBySales> topCustomersBySales;
        public List<TypeOfRequests> typeOfRequests;
        public List<TypeOfRequestsPerCustomer> typeOfRequestsPerCustomer;
        public List<NavigationGroups> navigationGroups;
        public List<NavigationGroupItems> navigationGroupItems;
        public List<QuoteEngineersNames> quoteEngineerNames; 

        private string errorMessage = "Data could not be retrieved for chart.";

        public string GetTotalRFQs()
        {
            quotesPerYear = new List<TotalQuotesReceivedPerYear>();
            try
            {
                foreach (TotalQuotesReceivedPerYear result in context.usp_QT_Metrics_TotalQuotesReceivedPerYear())
                {
                    quotesPerYear.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetRFQsByMonth()
        {
            quotesPerMonth = new List<QuotesPerMonth>();
            try
            {
                foreach (QuotesPerMonth result in context.usp_QT_Metrics_QuotesPerMonth())
                {
                    quotesPerMonth.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetCompletedRFQs()
        {
            completedQuotes = new List<CompletedQuotes>();
            try
            {
                foreach (CompletedQuotes result in context.usp_QT_Metrics_CompletedQuotes())
                {
                    completedQuotes.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetCompletedQuotesByEstimator()
        {
            compQuotesByEstimator = new List<QuotesCompletedByEstimator>();
            try
            {
                foreach (QuotesCompletedByEstimator result in context.usp_QT_Metrics_QuotesCompletedByEstimator())
                {
                    compQuotesByEstimator.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetOnTimeDelivery()
        {
            onTimeDelivery = new List<OnTimeDelivery>();
            try
            {
                foreach (OnTimeDelivery result in context.usp_QT_Metrics_OnTimeDelivery())
                {
                    onTimeDelivery.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetDaysLate()
        {
            onTimeDaysLateBreakdown = new List<OnTimeDaysLateBreakdown>();
            try
            {
                foreach (OnTimeDaysLateBreakdown result in context.usp_QT_Metrics_OnTimeDaysLateBreakdown())
                {
                    onTimeDaysLateBreakdown.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetOnTimeByEngineer()
        {
            onTimeByEngineer = new List<OnTimeByQuoteEngineer>();
            try
            {
                foreach (OnTimeByQuoteEngineer result in context.usp_QT_Metrics_OnTimeByQuoteEngineer())
                {
                    onTimeByEngineer.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetQuoteRequestsPerMonth()
        {
            quoteRequestsPerMonth = new List<QuoteRequestsPerMonth>();
            try
            {
                foreach (QuoteRequestsPerMonth result in context.usp_QT_Metrics_QuoteRequestsPerMonth())
                {
                    quoteRequestsPerMonth.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetQuoteRequestsPerMonthSalesperson()
        {
            quoteRequestsPerMonthSalesperson = new List<QuoteRequestsPerMonthSalesperson>();
            try
            {
                foreach (QuoteRequestsPerMonthSalesperson result in context.usp_QT_Metrics_QuoteRequestsPerMonthSalesperson())
                {
                    quoteRequestsPerMonthSalesperson.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetCategoryByQuantity()
        {
            categoryByQuantity = new List<CategoryByQuantity>();
            try
            {
                foreach (CategoryByQuantity result in context.usp_QT_Metrics_CategoryByQuantity())
                {
                    categoryByQuantity.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetTopCustomersByQuotes()
        {
            topCustomersByQuotes = new List<TopCustomersByQuotes>();
            try
            {
                foreach (TopCustomersByQuotes result in context.usp_QT_Metrics_TopCustomersByQuotes())
                {
                    topCustomersByQuotes.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetTopCustomersBySales()
        {
            topCustomersBySales = new List<TopCustomersBySales>();
            try
            {
                foreach (TopCustomersBySales result in context.usp_QT_Metrics_TopCustomersBySales())
                {
                    topCustomersBySales.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetTypeOfRequests()
        {
            typeOfRequests = new List<TypeOfRequests>();
            try
            {
                foreach (TypeOfRequests result in context.usp_QT_Metrics_TypeOfRequests())
                {
                    typeOfRequests.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }

        public string GetTypeOfRequestsPerCustomer()
        {
            typeOfRequestsPerCustomer = new List<TypeOfRequestsPerCustomer>();
            try
            {
                foreach (TypeOfRequestsPerCustomer result in context.usp_QT_Metrics_TypeOfRequestsPerCustomer())
                {
                    typeOfRequestsPerCustomer.Add(result);
                }
                return "";
            }
            catch (Exception)
            {
                return errorMessage;
            }
        }



        public string GetQuoteEngineerNames()
        {
            quoteEngineerNames = new List<QuoteEngineersNames>();
            try
            {
                foreach (QuoteEngineersNames names in context.usp_QT_Metrics_GetQuoteEngineersNames())
                {
                    quoteEngineerNames.Add(names);
                }
                return "";
            }
            catch (Exception)
            {
                return "Failed to return Quote Engineer names. Error: " + errorMessage;
            }
        }



        #region Menu

        public string GetNavigationGroups()
        {
            navigationGroups = new List<NavigationGroups>();
            try
            {
                foreach (NavigationGroups item in context.usp_QT_Metrics_GetNavigationGroups())
                {
                    navigationGroups.Add(item);
                }
                return "";
            }
            catch (Exception)
            {
                return "Failed to return menu groups. Error: " + errorMessage;
            }
        }

        public string GetNavigationGroupItems(string navGroup)
        {
            navigationGroupItems = new List<NavigationGroupItems>();
            try
            {
                foreach (NavigationGroupItems item in context.usp_QT_Metrics_GetNavigationGroupItems(navGroup))
                {
                    navigationGroupItems.Add(item);
                }
                return "";
            }
            catch (Exception)
            {
                return "Failed to return menu items. Error: " + errorMessage;
            }
        }

        #endregion


    }
}
