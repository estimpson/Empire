using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.XtraCharts;


namespace QuoteLogMetrics
{
    public partial class formMetrics : Form
    {
        private Metrics metrics;

        private String _reportName;

        public formMetrics()
        {
            InitializeComponent();

            metrics = new Metrics();
            _reportName = "";
            HideAllCharts();
        }

        private void formMetrics_Load(object sender, EventArgs e)
        {
        }

        private void HideAllCharts()
        {
            chartTotalRFQs.Visible = chartCompletedRFQs.Visible = chartRFQsByMonth.Visible =
                chartCompQuotesByEstimator.Visible = chartOnTimeDelivery.Visible = 
                chartOnTimeByEngineer.Visible = chartQuoteRequestsPerMonth.Visible = 
                chartRequestsByMonthForTony.Visible = chartRequestsByMonthForJoel.Visible =
                chartRequestsByMonthForSteve.Visible = chartRequestsByMonthForDeana.Visible = 
                chartRequestsByMonthForDerek.Visible = chartRequestsByMonthForMike.Visible = 
                chartQuoteRequestsSalesperson.Visible = chartCategoryByQuantity.Visible = 
                chartTopCustomersByQuotes.Visible = chartTopCustomersBySales.Visible = 
                chartTypeOfRequests.Visible = chartTypeOfRequestsPerCustomer.Visible = 
                chartQuotesCurrentYear.Visible = chartQuotesTwoYears.Visible = false;

            chartTotalRFQs.Dock = chartCompletedRFQs.Dock = chartRFQsByMonth.Dock =
                chartCompQuotesByEstimator.Dock = chartOnTimeDelivery.Dock = 
                chartOnTimeByEngineer.Dock = chartQuoteRequestsPerMonth.Dock = 
                chartRequestsByMonthForTony.Dock = chartRequestsByMonthForJoel.Dock =
                chartRequestsByMonthForSteve.Dock = chartRequestsByMonthForDeana.Dock = 
                chartRequestsByMonthForDerek.Dock = chartRequestsByMonthForMike.Dock = 
                chartQuoteRequestsSalesperson.Dock = chartCategoryByQuantity.Dock = 
                chartTopCustomersByQuotes.Dock = chartTopCustomersBySales.Dock = 
                chartTypeOfRequests.Dock = chartTypeOfRequestsPerCustomer.Dock = 
                chartQuotesCurrentYear.Dock = chartQuotesTwoYears.Dock = DockStyle.None;
        }

        private void navBarControl1_LinkClicked(object sender, DevExpress.XtraNavBar.NavBarLinkEventArgs e)
        {
            _reportName = e.Link.Item.Caption;
            ShowReport();
            ToggleCharts();
        }

        private void ToggleCharts()
        {
            HideAllCharts();

            switch (_reportName)
            {
                case "Total RFQs":
                    chartTotalRFQs.Visible = true;
                    chartTotalRFQs.Dock = DockStyle.Fill;
                    break;
                case "RFQs By Month":
                    chartRFQsByMonth.Visible = true;
                    chartRFQsByMonth.Dock = DockStyle.Fill;
                    break;
                case "Completed RFQs":
                    chartCompletedRFQs.Visible = true;
                    chartCompletedRFQs.Dock = DockStyle.Fill;
                    break;
                case "Completed Quotes By Estimator":
                    chartCompQuotesByEstimator.Visible = true;
                    chartCompQuotesByEstimator.Dock = DockStyle.Fill;
                    break;
                case "On Time Delivery":
                    chartOnTimeDelivery.Visible = true;
                    chartOnTimeDelivery.Dock = DockStyle.Fill;
                    break;
                case "On Time By Engineer":
                    chartOnTimeByEngineer.Visible = true;
                    chartOnTimeByEngineer.Dock = DockStyle.Fill;
                    break;
                case "Quotes Received By Month":
                    chartQuoteRequestsPerMonth.Visible = true;
                    chartQuoteRequestsPerMonth.Dock = DockStyle.Fill;
                    break;
                case "Tony By Month":
                    chartRequestsByMonthForTony.Visible = true;
                    chartRequestsByMonthForTony.Dock = DockStyle.Fill;
                    break;
                //case "Steve By Month":
                //    chartRequestsByMonthForSteve.Visible = true;
                //    chartRequestsByMonthForSteve.Dock = DockStyle.Fill;
                //    break;
                //case "Deana By Month":
                //    chartRequestsByMonthForDeana.Visible = true;
                //    chartRequestsByMonthForDeana.Dock = DockStyle.Fill;
                //    break;
                case "Joel By Month":
                    chartRequestsByMonthForJoel.Visible = true;
                    chartRequestsByMonthForJoel.Dock = DockStyle.Fill;
                    break;
                case "Derek By Month":
                    chartRequestsByMonthForDerek.Visible = true;
                    chartRequestsByMonthForDerek.Dock = DockStyle.Fill;
                    break;
                case "Mike By Month":
                    chartRequestsByMonthForMike.Visible = true;
                    chartRequestsByMonthForMike.Dock = DockStyle.Fill;
                    break;
                case "Quotes Received By Salesperson":
                    chartQuoteRequestsSalesperson.Visible = true;
                    chartQuoteRequestsSalesperson.Dock = DockStyle.Fill;
                    break;
                case "Category":
                    chartCategoryByQuantity.Visible = true;
                    chartCategoryByQuantity.Dock = DockStyle.Fill;
                    break;
                case "Top Customers By Quotes":
                    chartTopCustomersByQuotes.Visible = true;
                    chartTopCustomersByQuotes.Dock = DockStyle.Fill;
                    break;
                case "Top Customers By Sales":
                    chartTopCustomersBySales.Visible = true;
                    chartTopCustomersBySales.Dock = DockStyle.Fill;
                    break;
                case "Type":
                    chartTypeOfRequests.Visible = true;
                    chartTypeOfRequests.Dock = DockStyle.Fill;
                    break;
                case "Type By Customer":
                    chartTypeOfRequestsPerCustomer.Visible = true;
                    chartTypeOfRequestsPerCustomer.Dock = DockStyle.Fill;
                    break;
                case "Quotes By Month Current Year":
                    chartQuotesCurrentYear.Visible = true;
                    chartQuotesCurrentYear.Dock = DockStyle.Fill;
                    break;
                case "Quotes By Month Two Years":
                    chartQuotesTwoYears.Visible = true;
                    chartQuotesTwoYears.Dock = DockStyle.Fill;
                    break;
            }
        }

        private void ShowReport()
        {
            switch (_reportName)
            {
                case "Total RFQs":
                    ShowTotalRFQs();
                    break;
                case "RFQs By Month":
                    ShowRFQsByMonth();
                    break;
                case "Completed RFQs":
                    ShowCompletedRFQs();
                    break;
                case "Completed Quotes By Estimator":
                    ShowCompletedQuotesByEstimator();
                    break;
                case "On Time Delivery":
                    ShowOnTimeDelivery();
                    break;
                case "On Time By Engineer":
                    ShowOnTimeDeliveryByQuoteEngineer();
                    break;
                case "Quotes Received By Month":
                    ShowQuoteRequestsPerMonth();
                    break;
                case "Tony By Month":
                    ShowTonyByMonth();
                    break;
                //case "Steve By Month":
                //    ShowSteveByMonth();
                //    break;
                //case "Deana By Month":
                //    ShowDeanaByMonth();
                //    break;
                case "Joel By Month":
                    ShowJoelByMonth();
                    break;
                case "Derek By Month":
                    ShowDerekByMonth();
                    break;
                case "Mike By Month":
                    ShowMikeByMonth();
                    break;
                case "Quotes Received By Salesperson":
                    ShowQuoteRequestsPerMonthSalesperson();
                    break;
                case "Category":
                    ShowCategories();
                    break;
                case "Top Customers By Quotes":
                    ShowTopCustomersByQuotes();
                    break;
                case "Top Customers By Sales":
                    ShowTopCustomersBySales();
                    break;
                case "Type":
                    ShowTypeOfRequests();
                    break;
                case "Type By Customer":
                    ShowTypeOfRequestsPerCustomer();
                    break;
                case "Quotes By Month Current Year":
                    ShowQuotesByMonthForCurrentYear();
                    break;
                case "Quotes By Month Two Years":
                    ShowQuotesByMonthForCurrentAndLastYear();
                    break;
            }
        }

        private void ShowTotalRFQs()
        {
            chartTotalRFQs.Series.Clear();
            chartTotalRFQs.Titles.Clear();

            string result = metrics.GetTotalRFQs();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartTotalRFQs.DataSource = metrics.quotesPerYear;

            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteYear";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.Name = "Total Quotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            chartTotalRFQs.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "RFQ's Received";
            chartTotalRFQs.Titles.Add(chartTitle);
        }

        private void ShowRFQsByMonth()
        {
            chartRFQsByMonth.Series.Clear();
            chartRFQsByMonth.Titles.Clear();

            string result = metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartRFQsByMonth.DataSource = metrics.quotesPerMonth;

            // Create series for five years of data
            int currentYear = DateTime.Now.Year;

            Series series1 = new Series();
            series1.Name = currentYear.ToString();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series1.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, currentYear));

            Series series2 = new Series();
            series2.Name = (currentYear - 1).ToString();
            series2.ArgumentDataMember = "QuoteMonth";
            series2.ValueDataMembers[0] = "NumberOfQuotes";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series2.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, currentYear - 1));

            Series series3 = new Series();
            series3.Name = (currentYear - 2).ToString();
            series3.ArgumentDataMember = "QuoteMonth";
            series3.ValueDataMembers[0] = "NumberOfQuotes";
            series3.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series3.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, currentYear - 2));

            Series series4 = new Series();
            series4.Name = (currentYear - 3).ToString();
            series4.ArgumentDataMember = "QuoteMonth";
            series4.ValueDataMembers[0] = "NumberOfQuotes";
            series4.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series4.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, currentYear - 3));

            Series series5 = new Series();
            series5.Name = (currentYear - 4).ToString();
            series5.ArgumentDataMember = "QuoteMonth";
            series5.ValueDataMembers[0] = "NumberOfQuotes";
            series5.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series5.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, currentYear - 4));

            // Add series to chart
            chartRFQsByMonth.Series.Add(series1);
            chartRFQsByMonth.Series.Add(series2);
            chartRFQsByMonth.Series.Add(series3);
            chartRFQsByMonth.Series.Add(series4);
            chartRFQsByMonth.Series.Add(series5);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month";
            chartRFQsByMonth.Titles.Add(chartTitle);
        }

        private void ShowCompletedRFQs()
        {
            chartCompletedRFQs.Series.Clear();
            chartCompletedRFQs.Titles.Clear();
            
            string result = metrics.GetCompletedRFQs();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartCompletedRFQs.DataSource = metrics.completedQuotes;

            Series series1 = new Series();
            series1.LegendText = "On Time";
            series1.ArgumentDataMember = "OnTime";
            series1.ValueDataMembers[0] = "OnTime";
            //series1.Name = "Total Quotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            Series series2 = new Series();
            series2.LegendText = "Late";
            series2.ArgumentDataMember = "Late";
            series2.ValueDataMembers[0] = "Late";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            chartCompletedRFQs.Series.Add(series1);
            chartCompletedRFQs.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quotes Completed";
            chartCompletedRFQs.Titles.Add(chartTitle);
        }

        private void ShowCompletedQuotesByEstimator()
        {
            chartCompQuotesByEstimator.Series.Clear();
            chartCompQuotesByEstimator.Titles.Clear();

            string result = metrics.GetCompletedQuotesByEstimator();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartCompQuotesByEstimator.DataSource = metrics.compQuotesByEstimator;

            Series series1 = new Series();
            series1.LegendText = "On Time";
            series1.ArgumentDataMember = "QuoteEngineer";
            series1.ValueDataMembers[0] = "OnTime";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            Series series2 = new Series();
            series2.LegendText = "Late";
            series2.ArgumentDataMember = "QuoteEngineer";
            series2.ValueDataMembers[0] = "Late";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            chartCompQuotesByEstimator.Series.Add(series1);
            chartCompQuotesByEstimator.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Completed Quotes by Estimator " + DateTime.Now.Year.ToString();
            chartCompQuotesByEstimator.Titles.Add(chartTitle);
        }

        private void ShowOnTimeDelivery()
        {
            chartOnTimeDelivery.Series.Clear();
            chartOnTimeDelivery.Titles.Clear();

            string result = metrics.GetOnTimeDelivery();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Pie Series", ViewType.Pie);

            // Populate the series with points.
            series1.Points.Add(new SeriesPoint("On Time", metrics.onTimeDelivery[0].OnTime));
            series1.Points.Add(new SeriesPoint("Late", metrics.onTimeDelivery[0].Late));

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartOnTimeDelivery.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "On Time Delivery " + DateTime.Now.Year.ToString();
            chartOnTimeDelivery.Titles.Add(chartTitle);

            chartOnTimeDelivery.Legend.Visible = false;
        }

        private void ShowOnTimeDeliveryByQuoteEngineer()
        {
            chartOnTimeByEngineer.Series.Clear();
            chartOnTimeByEngineer.Titles.Clear();

            string result = metrics.GetOnTimeByEngineer();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create pie series.
            Series series0 = new Series("Tony", ViewType.Pie);
            //Series series1 = new Series("Steve", ViewType.Pie);
            //Series series2 = new Series("Deana", ViewType.Pie);
            Series series1 = new Series("Joel", ViewType.Pie);
            Series series2 = new Series("Derek", ViewType.Pie);
            Series series3 = new Series("Mike", ViewType.Pie);

            // Populate the series with points.
            series0.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[0].OnTime, metrics.onTimeByEngineer[0].OnTime));
            series0.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[0].Late, metrics.onTimeByEngineer[0].Late));
            //series0.Points.Add(new SeriesPoint("Late: " + metrics.onTimeByEngineer[0].Late, metrics.onTimeByEngineer[0].Late));

            series1.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[1].OnTime, metrics.onTimeByEngineer[1].OnTime));
            series1.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[1].Late, metrics.onTimeByEngineer[1].Late));

            series2.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[2].OnTime, metrics.onTimeByEngineer[2].OnTime));
            series2.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[2].Late, metrics.onTimeByEngineer[2].Late));

            series3.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[3].OnTime, metrics.onTimeByEngineer[3].OnTime));
            series3.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[3].Late, metrics.onTimeByEngineer[3].Late));

            //series4.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[4].OnTime, metrics.onTimeByEngineer[4].OnTime));
            //series4.Points.Add(new SeriesPoint(metrics.onTimeByEngineer[4].Late, metrics.onTimeByEngineer[4].Late));

            // Access the view-type-specific options of the series.
            PieSeriesView series0View = (PieSeriesView)series0.View;
            PieSeriesView series1View = (PieSeriesView)series1.View;
            PieSeriesView series2View = (PieSeriesView)series2.View;
            PieSeriesView series3View = (PieSeriesView)series3.View;
            //PieSeriesView series4View = (PieSeriesView)series4.View;
           
            // Show a title for the series.
            series0View.Titles.Add(new SeriesTitle());
            series0View.Titles[0].Text = series0.Name;

            series1View.Titles.Add(new SeriesTitle());
            series1View.Titles[0].Text = series1.Name;

            series2View.Titles.Add(new SeriesTitle());
            series2View.Titles[0].Text = series2.Name;

            series3View.Titles.Add(new SeriesTitle());
            series3View.Titles[0].Text = series3.Name;

            //series4View.Titles.Add(new SeriesTitle());
            //series4View.Titles[0].Text = series4.Name;

            // Adjust the point options of the series.
            series0.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series0.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series0.Label.PointOptions.ValueNumericOptions.Precision = 0;

            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            series2.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series2.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series2.Label.PointOptions.ValueNumericOptions.Precision = 0;

            series3.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series3.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series3.Label.PointOptions.ValueNumericOptions.Precision = 0;

            //series4.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            //series4.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            //series4.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartOnTimeByEngineer.Series.Add(series0);
            chartOnTimeByEngineer.Series.Add(series1);
            chartOnTimeByEngineer.Series.Add(series2);
            chartOnTimeByEngineer.Series.Add(series3);
            //chartOnTimeByEngineer.Series.Add(series4);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "On Time Delivery";
            chartOnTimeByEngineer.Titles.Add(chartTitle);

            chartOnTimeByEngineer.Legend.Visible = false;


            //// Specify a data filter to explode points.
            //series1View.ExplodedPointsFilters.Add(new SeriesPointFilter(SeriesPointKey.Value_1,
            //    DataFilterCondition.Equal, "Tony"));
            //series1View.ExplodedPointsFilters.Add(new SeriesPointFilter(SeriesPointKey.Argument,
            //    DataFilterCondition.Equal, "Tony"));
            //series1View.ExplodeMode = PieExplodeMode.UseFilters;
            //series1View.ExplodedDistancePercentage = 30;
            //series1View.RuntimeExploding = true;
            //series1View.HeightToWidthRatio = 99;

            //series1.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Steve"));
        }

        private void ShowQuoteRequestsPerMonth()
        {
            chartQuoteRequestsPerMonth.Series.Clear();
            chartQuoteRequestsPerMonth.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartQuoteRequestsPerMonth.DataSource = metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.Name = "Tony";
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Tony"));

            //Series series2 = new Series();
            //series2.Name = "Steve";
            //series2.ArgumentDataMember = "QuoteMonth";
            //series2.ValueDataMembers[0] = "NumberOfQuotes";
            //series2.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            //series2.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Steve"));

            //Series series3 = new Series();
            //series3.Name = "Deana";
            //series3.ArgumentDataMember = "QuoteMonth";
            //series3.ValueDataMembers[0] = "NumberOfQuotes";
            //series3.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            //series3.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Deana"));

            Series series2 = new Series();
            series2.Name = "Joel";
            series2.ArgumentDataMember = "QuoteMonth";
            series2.ValueDataMembers[0] = "NumberOfQuotes";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series2.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Joel"));

            Series series3 = new Series();
            series3.Name = "Derek";
            series3.ArgumentDataMember = "QuoteMonth";
            series3.ValueDataMembers[0] = "NumberOfQuotes";
            series3.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series3.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Derek"));

            Series series4 = new Series();
            series4.Name = "Mike";
            series4.ArgumentDataMember = "QuoteMonth";
            series4.ValueDataMembers[0] = "NumberOfQuotes";
            series4.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series4.DataFilters.Add(new DataFilter("QuoteEngineer", "System.String", DataFilterCondition.Equal, "Mike"));

            // Add series to chart
            chartQuoteRequestsPerMonth.Series.Add(series1);
            chartQuoteRequestsPerMonth.Series.Add(series2);
            chartQuoteRequestsPerMonth.Series.Add(series3);
            chartQuoteRequestsPerMonth.Series.Add(series4);
            //chartQuoteRequestsPerMonth.Series.Add(series5);
          
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month " + DateTime.Now.Year.ToString();
            chartQuoteRequestsPerMonth.Titles.Add(chartTitle);
        }

        private void ShowTonyByMonth()
        {
            chartRequestsByMonthForTony.Series.Clear();
            chartRequestsByMonthForTony.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartRequestsByMonthForTony.DataSource = metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Tony"));

            // Add series to chart
            chartRequestsByMonthForTony.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month for Tony";
            chartRequestsByMonthForTony.Titles.Add(chartTitle);

            chartRequestsByMonthForTony.Legend.Visible = false;
        }

        //private void ShowSteveByMonth()
        //{
        //    chartRequestsByMonthForSteve.Series.Clear();
        //    chartRequestsByMonthForSteve.Titles.Clear();

        //    string result = metrics.GetQuoteRequestsPerMonth();
        //    if (result != "")
        //    {
        //        MessageBox.Show(result);
        //        return;
        //    }
        //    chartRequestsByMonthForSteve.DataSource = metrics.quoteRequestsPerMonth;

        //    // Create series for each Quote Engineer
        //    Series series1 = new Series();
        //    series1.ArgumentDataMember = "QuoteMonth";
        //    series1.ValueDataMembers[0] = "NumberOfQuotes";
        //    series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
        //    series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Steve"));

        //    // Add series to chart
        //    chartRequestsByMonthForSteve.Series.Add(series1);

        //    ChartTitle chartTitle = new ChartTitle();
        //    chartTitle.Text = "Quote Requests Received by Month for Steve";
        //    chartRequestsByMonthForSteve.Titles.Add(chartTitle);

        //    chartRequestsByMonthForSteve.Legend.Visible = false;
        //}

        //private void ShowDeanaByMonth()
        //{
        //    chartRequestsByMonthForDeana.Series.Clear();
        //    chartRequestsByMonthForDeana.Titles.Clear();

        //    string result = metrics.GetQuoteRequestsPerMonth();
        //    if (result != "")
        //    {
        //        MessageBox.Show(result);
        //        return;
        //    }
        //    chartRequestsByMonthForDeana.DataSource = metrics.quoteRequestsPerMonth;

        //    // Create series for each Quote Engineer
        //    Series series1 = new Series();
        //    series1.ArgumentDataMember = "QuoteMonth";
        //    series1.ValueDataMembers[0] = "NumberOfQuotes";
        //    series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
        //    series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Deana"));

        //    // Add series to chart
        //    chartRequestsByMonthForDeana.Series.Add(series1);

        //    ChartTitle chartTitle = new ChartTitle();
        //    chartTitle.Text = "Quote Requests Received by Month for Deana";
        //    chartRequestsByMonthForDeana.Titles.Add(chartTitle);

        //    chartRequestsByMonthForDeana.Legend.Visible = false;
        //}

        private void ShowJoelByMonth()
        {
            chartRequestsByMonthForJoel.Series.Clear();
            chartRequestsByMonthForJoel.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartRequestsByMonthForJoel.DataSource = metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Joel"));

            // Add series to chart
            chartRequestsByMonthForJoel.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month for Joel";
            chartRequestsByMonthForJoel.Titles.Add(chartTitle);

            chartRequestsByMonthForJoel.Legend.Visible = false;
        }

        private void ShowDerekByMonth()
        {
            chartRequestsByMonthForDerek.Series.Clear();
            chartRequestsByMonthForDerek.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartRequestsByMonthForDerek.DataSource = metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Derek"));

            // Add series to chart
            chartRequestsByMonthForDerek.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month for Derek";
            chartRequestsByMonthForDerek.Titles.Add(chartTitle);

            chartRequestsByMonthForDerek.Legend.Visible = false;
        }

        private void ShowMikeByMonth()
        {
            chartRequestsByMonthForMike.Series.Clear();
            chartRequestsByMonthForMike.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartRequestsByMonthForMike.DataSource = metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, "Mike"));

            // Add series to chart
            chartRequestsByMonthForMike.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month for Mike";
            chartRequestsByMonthForMike.Titles.Add(chartTitle);

            chartRequestsByMonthForMike.Legend.Visible = false;
        }

        private void ShowQuoteRequestsPerMonthSalesperson()
        {
            chartQuoteRequestsSalesperson.Series.Clear();
            chartQuoteRequestsSalesperson.Titles.Clear();

            string result = metrics.GetQuoteRequestsPerMonthSalesperson();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartQuoteRequestsSalesperson.DataSource = metrics.quoteRequestsPerMonthSalesperson;

            // Create series for each Salesperson
            Series series1 = new Series();
            series1.Name = "Pat";
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series1.DataFilters.Add(new DataFilter("Salesperson", "String", DataFilterCondition.Equal, "Pat"));

            Series series2 = new Series();
            series2.Name = "Other";
            series2.ArgumentDataMember = "QuoteMonth";
            series2.ValueDataMembers[0] = "NumberOfQuotes";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Line);
            series2.DataFilters.Add(new DataFilter("Salesperson", "System.String", DataFilterCondition.Equal, "Other"));

            // Add series to chart
            chartQuoteRequestsSalesperson.Series.Add(series1);
            chartQuoteRequestsSalesperson.Series.Add(series2);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Received by Month per Salesperson";
            chartQuoteRequestsSalesperson.Titles.Add(chartTitle);
        }

        private void ShowCategories()
        {
            chartCategoryByQuantity.Series.Clear();
            chartCategoryByQuantity.Titles.Clear();

            string result = metrics.GetCategoryByQuantity();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Categories", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in metrics.categoryByQuantity)
            {
                series1.Points.Add(new SeriesPoint(item.Category + " " + metrics.categoryByQuantity[i].Quantity, metrics.categoryByQuantity[i].Quantity));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartCategoryByQuantity.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Category by Quantity";
            chartCategoryByQuantity.Titles.Add(chartTitle);

            chartCategoryByQuantity.Legend.Visible = false;
        }

        private void ShowTopCustomersByQuotes()
        {
            chartTopCustomersByQuotes.Series.Clear();
            chartTopCustomersByQuotes.Titles.Clear();

            string result = metrics.GetTopCustomersByQuotes();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Customers", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in metrics.topCustomersByQuotes)
            {
                series1.Points.Add(new SeriesPoint(item.Customer + " " + metrics.topCustomersByQuotes[i].QuotesReceived, metrics.topCustomersByQuotes[i].QuotesReceived));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartTopCustomersByQuotes.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Top Customers By Quotes";
            chartTopCustomersByQuotes.Titles.Add(chartTitle);

            chartTopCustomersByQuotes.Legend.Visible = false;
        }

        private void ShowTopCustomersBySales()
        {
            chartTopCustomersBySales.Series.Clear();
            chartTopCustomersBySales.Titles.Clear();

            string result = metrics.GetTopCustomersBySales();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Customers", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in metrics.topCustomersBySales)
            {
                series1.Points.Add(new SeriesPoint(item.Customer + " $" + String.Format("{0:#,#}", metrics.topCustomersBySales[i].TotalSales), metrics.topCustomersBySales[i].TotalSales));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartTopCustomersBySales.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Top Customers By Sales";
            chartTopCustomersBySales.Titles.Add(chartTitle);

            chartTopCustomersBySales.Legend.Visible = false;
        }

        private void ShowTypeOfRequests()
        {
            chartTypeOfRequests.Series.Clear();
            chartTypeOfRequests.Titles.Clear();

            string result = metrics.GetTypeOfRequests();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("RequestTypes", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in metrics.typeOfRequests)
            {
                series1.Points.Add(new SeriesPoint(item.Requote + " " + metrics.typeOfRequests[i].Quantity, metrics.typeOfRequests[i].Quantity));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            chartTypeOfRequests.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Type of Requests";
            chartTypeOfRequests.Titles.Add(chartTitle);

            chartTypeOfRequests.Legend.Visible = false;
        }

        private void ShowTypeOfRequestsPerCustomer()
        {
            chartTypeOfRequestsPerCustomer.Series.Clear();
            chartTypeOfRequestsPerCustomer.Titles.Clear();

            string result = metrics.GetTypeOfRequestsPerCustomer();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartTypeOfRequestsPerCustomer.DataSource = metrics.typeOfRequestsPerCustomer;

            Series series1 = new Series();
            series1.LegendText = "New Quotes";
            series1.ArgumentDataMember = "Customer";
            series1.ValueDataMembers[0] = "NewQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            Series series2 = new Series();
            series2.LegendText = "Re-Quotes";
            series2.ArgumentDataMember = "Customer";
            series2.ValueDataMembers[0] = "ReQuotes";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            chartTypeOfRequestsPerCustomer.Series.Add(series1);
            chartTypeOfRequestsPerCustomer.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Type of Requests by Customers";
            chartTypeOfRequestsPerCustomer.Titles.Add(chartTitle);
        }

        private void ShowQuotesByMonthForCurrentYear()
        {
            chartQuotesCurrentYear.Series.Clear();
            chartQuotesCurrentYear.Titles.Clear();

            string result = metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartQuotesCurrentYear.DataSource = metrics.quotesPerMonth;

            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year));

            // Add series to chart
            chartQuotesCurrentYear.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = DateTime.Now.Year.ToString() + " Quotes by Month";
            chartQuotesCurrentYear.Titles.Add(chartTitle);

            chartQuotesCurrentYear.Legend.Visible = false;
        }

        private void ShowQuotesByMonthForCurrentAndLastYear()
        {
            chartQuotesTwoYears.Series.Clear();
            chartQuotesTwoYears.Titles.Clear();

            string result = metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            chartQuotesTwoYears.DataSource = metrics.quotesPerMonth;

            Series series1 = new Series();
            series1.LegendText = DateTime.Now.Year.ToString();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year));

            Series series2 = new Series();
            series2.LegendText = Convert.ToString(DateTime.Now.Year - 1);
            series2.ArgumentDataMember = "QuoteMonth";
            series2.ValueDataMembers[0] = "NumberOfQuotes";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series2.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year - 1));

            // Add series to chart
            chartQuotesTwoYears.Series.Add(series1);
            chartQuotesTwoYears.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Number of Quotes by Month";
            chartQuotesTwoYears.Titles.Add(chartTitle);
        }



        private void btnExportToExcel_Click(object sender, EventArgs e)
        {
            if (_reportName == "") return;
            ExportToRTF();
        }

        private void ExportToRTF()
        {
            string filePath = "";

            OpenFileDialog ofd = new OpenFileDialog();
            //ofd.Filter = "*.xlxs|*.xlxs";
            if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                filePath = ofd.FileName;
            }

            switch (_reportName)
            {
                case "Total RFQs":
                    chartTotalRFQs.ExportToXlsx(filePath);
                    break;
                case "RFQs By Month":
                    chartRFQsByMonth.ExportToXlsx(filePath);
                    break;
                case "Completed RFQs":
                    chartCompletedRFQs.ExportToXlsx(filePath);
                    break;
                case "Completed Quotes By Estimator":
                    chartCompQuotesByEstimator.ExportToXlsx(filePath);
                    break;
                case "On Time Delivery":
                    chartOnTimeDelivery.ExportToXlsx(filePath);
                    break;
                case "On Time By Engineer":
                    chartOnTimeByEngineer.ExportToXlsx(filePath);
                    break;
                case "Quotes Received By Month":
                    chartQuoteRequestsPerMonth.ExportToXlsx(filePath);
                    break;
                case "Tony By Month":
                    chartRequestsByMonthForTony.ExportToXlsx(filePath);
                    break;
                //case "Steve By Month":
                //    chartRequestsByMonthForSteve.ExportToXlsx(filePath);
                //    break;
                //case "Deana By Month":
                //    chartRequestsByMonthForDeana.ExportToXlsx(filePath);
                //    break;
                case "Joel By Month":
                    chartRequestsByMonthForJoel.ExportToXlsx(filePath);
                    break;
                case "Derek By Month":
                    chartRequestsByMonthForDerek.ExportToXlsx(filePath);
                    break;
                case "Mike By Month":
                    chartRequestsByMonthForMike.ExportToXlsx(filePath);
                    break;
                case "Quotes Received By Salesperson":
                    chartQuoteRequestsSalesperson.ExportToXlsx(filePath);
                    break;
                case "Category":
                    chartCategoryByQuantity.ExportToXlsx(filePath);
                    break;
                case "Top Customers By Quotes":
                    chartTopCustomersByQuotes.ExportToXlsx(filePath);
                    break;
                case "Top Customers By Sales":
                    chartTopCustomersBySales.ExportToXlsx(filePath);
                    break;
                case "Type":
                    chartTypeOfRequests.ExportToXlsx(filePath);
                    break;
                case "Type By Customer":
                    chartTypeOfRequestsPerCustomer.ExportToXlsx(filePath);
                    break;
                case "Quotes By Month Current Year":
                    chartQuotesCurrentYear.ExportToXlsx(filePath);
                    break;
                case "Quotes By Month Two Years":
                    chartQuotesTwoYears.ExportToXlsx(filePath);
                    break;
            }
        }



    }
}
