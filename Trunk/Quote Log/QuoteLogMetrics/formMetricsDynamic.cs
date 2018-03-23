using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.XtraCharts;
using DevExpress.XtraNavBar;


namespace QuoteLogMetrics
{
    public partial class formMetricsDynamic : Form
    {
        private Metrics _metrics;

        private string _reportName;
        private ChartControl _chartControl;

        public formMetricsDynamic()
        {
            InitializeComponent();

            _metrics = new Metrics();
            _chartControl = new ChartControl();

            PopulateNavigationBar();
            _reportName = "";
        }

        
        private void PopulateNavigationBar()
        {
            string groupsResult = _metrics.GetNavigationGroups();
            if (groupsResult != "")
            {
                MessageBox.Show(groupsResult);
                return;
            }

            int i = 0;
            foreach (var group in _metrics.navigationGroups)
            {
                NavBarGroup newGroup = new NavBarGroup(group.NavigationGroup);

                navBarControl1.BeginUpdate();
                navBarControl1.Groups.Add(newGroup);
                newGroup.Expanded = (i < 4);  // Expand the top four groups
                navBarControl1.EndUpdate();


                // Inner loop to add this group's items
                string itemsResult = _metrics.GetNavigationGroupItems(group.NavigationGroup);
                if (itemsResult != "")
                {
                    MessageBox.Show(itemsResult);
                    return;
                }

                foreach (var menuItem in _metrics.navigationGroupItems)
                {
                    NavBarItem newItem = new NavBarItem(menuItem.NavItem);
                    newItem.Caption = menuItem.NavItem;

                    navBarControl1.BeginUpdate();
                    newGroup.ItemLinks.Add(newItem);
                    navBarControl1.EndUpdate();
                }
                i++;
            }

            // Specify the event handler which will be invoked when any link is clicked.
            navBarControl1.LinkClicked += new NavBarLinkEventHandler(navBarControl1_LinkClicked);
        }

        void navBarControl1_LinkClicked(object sender, NavBarLinkEventArgs e)
        {
            _reportName = e.Link.Caption;

            // Determine if this is an individual quote engineer chart
            if (_reportName.Contains("By Month") && !_reportName.Contains("RFQs") && !_reportName.Contains("Quotes"))
            {
                // Get the name of the quote engineer
                int i = _reportName.IndexOf("By Month");
                string name = _reportName.Substring(0, i - 1);
                ShowChartForIndividual(name);
                return;
            }
            ShowChart(_reportName);
        }

        private void ShowChartForIndividual(string name)
        {
            this.Cursor = Cursors.WaitCursor;

            _chartControl.Dispose();
            _chartControl = new ChartControl();
            _chartControl.Dock = DockStyle.Fill;
            pnlChart.Controls.Add(_chartControl);

            string result = _metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quoteRequestsPerMonth;

            // Create series for each Quote Engineer
            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, name));

            // Add series to chart
            _chartControl.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = string.Format("Quote Requests Received by Month for {0}", name);
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;

            this.Cursor = Cursors.Default;
        }

        private void ShowChart(string caption)
        {
            this.Cursor = Cursors.WaitCursor;

            _chartControl.Dispose();
            _chartControl = new ChartControl();
            _chartControl.Dock = DockStyle.Fill;
            pnlChart.Controls.Add(_chartControl);

            //_chartControl.Series.Clear();
            //_chartControl.Titles.Clear();
            //_chartControl.DataSource = null;

            switch (caption)
            {
                case "Total RFQs (Since 2007)":    
                    ShowTotalRFQs();
                    break;
                case "RFQs By Month (Five Years)":
                    ShowRFQsByMonth();
                    break;
                case "Completed RFQs (Current Year)":
                    ShowCompletedRFQs();
                    break;
                case "Completed Quotes By Estimator (Current Year)":
                    ShowCompletedQuotesByEstimator();
                    break;
                case "On Time Delivery (Current Year)":
                    ShowOnTimeDelivery();
                    break;
                case "On Time By Engineer (Current Year)":
                    ShowOnTimeDeliveryByQuoteEngineer();
                    break;
                case "Days Late (Current Year)":
                    ShowDaysLate();
                    break;
                case "Quotes Rcvd By Month (Current Year By Eng)":
                    ShowQuoteRequestsPerMonth();
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
                case "Quotes By Month (Current Year)":
                    ShowQuotesByMonthForCurrentYear();
                    break;
                case "Quotes By Month (Two Years)":
                    ShowQuotesByMonthForCurrentAndLastYear();
                    break;
            }
            this.Cursor = Cursors.Default;
        }

        private void ShowTotalRFQs()
        {
            string result = _metrics.GetTotalRFQs();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quotesPerYear;

            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteYear";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.Name = "Total Quotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            _chartControl.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "RFQ's Received";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowRFQsByMonth()
        {
            string result = _metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quotesPerMonth;

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
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);
            _chartControl.Series.Add(series3);
            _chartControl.Series.Add(series4);
            _chartControl.Series.Add(series5);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowCompletedRFQs()
        {
            string result = _metrics.GetCompletedRFQs();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.completedQuotes;

            Series series1 = new Series();
            series1.LegendText = "On Time";
            series1.ArgumentDataMember = "X";
            series1.ValueDataMembers[0] = "OnTime";
            //series1.Name = "Total Quotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            Series series2 = new Series();
            series2.LegendText = "Late";
            series2.ArgumentDataMember = "X";
            series2.ValueDataMembers[0] = "Late";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quotes Completed";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowCompletedQuotesByEstimator()
        {
            string result = _metrics.GetCompletedQuotesByEstimator();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.compQuotesByEstimator;

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
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Completed Quotes by Estimator " + DateTime.Now.Year.ToString();
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowOnTimeDelivery()
        {
            string result = _metrics.GetOnTimeDelivery();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Pie Series", ViewType.Pie);

            // Populate the series with points.
            series1.Points.Add(new SeriesPoint("On Time", _metrics.onTimeDelivery[0].OnTime));
            series1.Points.Add(new SeriesPoint("Late", _metrics.onTimeDelivery[0].Late));

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "On Time Delivery " + DateTime.Now.Year.ToString();
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visibility = DevExpress.Utils.DefaultBoolean.True;
        }

        private void ShowDaysLate()
        {
            string result = _metrics.GetDaysLate();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.onTimeDaysLateBreakdown;

            Series series1 = new Series();
            series1.ArgumentDataMember = "Category";
            series1.ValueDataMembers[0] = "NumberOfDaysLate";
            //series1.Name = "Category1";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);

            // Add series to chart
            _chartControl.Series.Add(series1);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Number of Days Late " + DateTime.Now.Year.ToString();
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowOnTimeDeliveryByQuoteEngineer()
        {
            string result = _metrics.GetOnTimeByEngineer();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a chart series for each active quote engineer
            _metrics.GetQuoteEngineerNames();
            int i = 0;
            foreach (var name in _metrics.quoteEngineerNames)
            {
                // Create pie series.
                Series series = new Series(name.FirstName, ViewType.Pie) { Name = name.FirstName };

                // Populate the series with points.
                series.Points.Add(new SeriesPoint(_metrics.onTimeByEngineer[i].OnTime, _metrics.onTimeByEngineer[i].OnTime));
                series.Points.Add(new SeriesPoint(_metrics.onTimeByEngineer[i].Late, _metrics.onTimeByEngineer[i].Late));

                // Access the view-type-specific options of the series.
                PieSeriesView seriesView = (PieSeriesView)series.View;

                // Show a title for the series.
                seriesView.Titles.Add(new SeriesTitle());
                seriesView.Titles[0].Text = series.Name;
                seriesView.Titles[0].Visibility = DevExpress.Utils.DefaultBoolean.True;


                // Adjust the point options of the series.
                series.Label.PointOptions.PointView = PointView.ArgumentAndValues;
                series.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
                series.Label.PointOptions.ValueNumericOptions.Precision = 0;

                // Add series to chart
                _chartControl.Series.Add(series);

                i++;
            }

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "On Time Delivery";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visibility = DevExpress.Utils.DefaultBoolean.False;
        }

        private void ShowQuoteRequestsPerMonth()
        {
            string result = _metrics.GetQuoteRequestsPerMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quoteRequestsPerMonth;


             // Create a chart series for each active quote engineer
            _metrics.GetQuoteEngineerNames();
            foreach (var name in _metrics.quoteEngineerNames)
            {
                // Create a series for each quote engineer
                Series series = new Series();

                series.Name = name.FirstName;
                series.ArgumentDataMember = "QuoteMonth";
                series.ValueDataMembers[0] = "NumberOfQuotes";
                series.ChangeView(DevExpress.XtraCharts.ViewType.Line);
                series.DataFilters.Add(new DataFilter("QuoteEngineer", "String", DataFilterCondition.Equal, name.FirstName));

                // Add series to chart
                _chartControl.Series.Add(series);
            }

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Requests Received by Month " + DateTime.Now.Year.ToString();
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowQuoteRequestsPerMonthSalesperson()
        {
            string result = _metrics.GetQuoteRequestsPerMonthSalesperson();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quoteRequestsPerMonthSalesperson;

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
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Quote Received by Month per Salesperson";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowCategories()
        {
            string result = _metrics.GetCategoryByQuantity();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Categories", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in _metrics.categoryByQuantity)
            {
                series1.Points.Add(new SeriesPoint(item.Category + " " + _metrics.categoryByQuantity[i].Quantity, _metrics.categoryByQuantity[i].Quantity));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Category by Quantity";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;
        }

        private void ShowTopCustomersByQuotes()
        {
            string result = _metrics.GetTopCustomersByQuotes();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Customers", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in _metrics.topCustomersByQuotes)
            {
                series1.Points.Add(new SeriesPoint(item.Customer + " " + _metrics.topCustomersByQuotes[i].QuotesReceived, _metrics.topCustomersByQuotes[i].QuotesReceived));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Top Customers By Quotes";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;
        }

        private void ShowTopCustomersBySales()
        {
            string result = _metrics.GetTopCustomersBySales();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("Customers", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in _metrics.topCustomersBySales)
            {
                series1.Points.Add(new SeriesPoint(item.Customer + " $" + String.Format("{0:#,#}", _metrics.topCustomersBySales[i].TotalSales), _metrics.topCustomersBySales[i].TotalSales));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Top Customers By Sales";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;
        }

        private void ShowTypeOfRequests()
        {
            string result = _metrics.GetTypeOfRequests();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }

            // Create a pie series.
            Series series1 = new Series("RequestTypes", ViewType.Pie);

            // Populate the series with points.
            int i = 0;
            foreach (var item in _metrics.typeOfRequests)
            {
                series1.Points.Add(new SeriesPoint(item.Requote + " " + _metrics.typeOfRequests[i].Quantity, _metrics.typeOfRequests[i].Quantity));
                i++;
            }

            // Adjust the point options of the series.
            series1.Label.PointOptions.PointView = PointView.ArgumentAndValues;
            series1.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Percent;
            series1.Label.PointOptions.ValueNumericOptions.Precision = 0;

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Type of Requests";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;
        }

        private void ShowTypeOfRequestsPerCustomer()
        {
            string result = _metrics.GetTypeOfRequestsPerCustomer();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.typeOfRequestsPerCustomer;

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
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Type of Requests by Customers";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowQuotesByMonthForCurrentYear()
        {
            string result = _metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quotesPerMonth;

            Series series1 = new Series();
            series1.ArgumentDataMember = "QuoteMonth";
            series1.ValueDataMembers[0] = "NumberOfQuotes";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year));

            // Add series to chart
            _chartControl.Series.Add(series1);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = DateTime.Now.Year.ToString() + " Quotes by Month";
            _chartControl.Titles.Add(chartTitle);

            _chartControl.Legend.Visible = false;
        }

        private void ShowQuotesByMonthForCurrentAndLastYear()
        {
            string result = _metrics.GetRFQsByMonth();
            if (result != "")
            {
                MessageBox.Show(result);
                return;
            }
            _chartControl.DataSource = _metrics.quotesPerMonth;

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
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            // Add title to chart
            ChartTitle chartTitle = new ChartTitle();
            chartTitle.Text = "Number of Quotes by Month";
            _chartControl.Titles.Add(chartTitle);
        }



        #region Export Report

        private void btnExportToExcel_Click(object sender, EventArgs e)
        {
            if (_reportName == "") return;
            ExportToExcel();
        }

        private void ExportToExcel()
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                //ofd.Filter = "*.xlxs|*.xlxs";
                if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    string filePath = ofd.FileName;
                    _chartControl.ExportToXlsx(filePath);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error thrown when attempting to export chart to Excel: " + ex.Message, "ExportToExcel() Exception"); 
            }
        }

        #endregion


    }
}
