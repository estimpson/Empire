using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraCharts;
using DevExpress.XtraGrid;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraNavBar;
using FASTT.Controllers;
using FASTT.Controls;

namespace FASTT.Views
{
    public partial class ReportsView : Form
    {
        #region Class Objects

        private readonly ReportsController _controller;
        private readonly ReportsNavigationController _navigationController;
        private ChartControl _chartControl;
        private GridControl _gridControl;
        private GridControl _gridControlActivity;
        private GridView _gridViewActivity;
        private readonly CustomMessageBox _messageBox;
        
        #endregion


        #region Variables

        private string _reportName;
        private bool _dataBinding;
        private bool _isChart;
        private string _currentActivityHistoryReport;

        #endregion
       

        #region Properties

        public string OperatorCode { get; set; }

        private string _error;
        public string Error
        {
            get { return _error; }
            set
            {
                _error = lblErrorMessage.Text = value;
                lblErrorMessage.Visible = (_error != "");
            }
        }

        #endregion


        #region Constructor, Load

        public ReportsView()
        {
            InitializeComponent();

            _controller = new ReportsController();
            _navigationController = new ReportsNavigationController();
            _chartControl = new ChartControl();
            _gridControl = new GridControl();
            _messageBox = new CustomMessageBox();
        }

        private void ReportsView_Load(object sender, EventArgs e)
        {
            PopulateNavigationBar();

            lnkLblMinMax.LinkBehavior = linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnExportChart.Visible = lblDoubleClick.Visible = false;

            Error = "";
        }

        #endregion



        void _gridControlActivity_DoubleClick(object sender, EventArgs e)
        {
            int r = _gridViewActivity.GetSelectedRows()[0];
            if (r < 0) return;

            ModifySalesLead();
        }

        private void ModifySalesLead()
        {
            int r = _gridViewActivity.GetSelectedRows()[0];

            string iD = (_gridViewActivity.GetRowCellValue(r, "RowId") != null) ? _gridViewActivity.GetRowCellValue(r, "RowId").ToString() : "";
            int combinedLightingStudyId = (_gridViewActivity.GetRowCellValue(r, "CombinedLightingStudyId") != null) ? Convert.ToInt32(_gridViewActivity.GetRowCellValue(r, "CombinedLightingStudyId")) : 0;
            string customer = (_gridViewActivity.GetRowCellValue(r, "Customer") != null) ? _gridViewActivity.GetRowCellValue(r, "Customer").ToString() : "";
            string program = (_gridViewActivity.GetRowCellValue(r, "Program") != null) ? _gridViewActivity.GetRowCellValue(r, "Program").ToString() : "";
            string application = (_gridViewActivity.GetRowCellValue(r, "Application") != null) ? _gridViewActivity.GetRowCellValue(r, "Application").ToString() : "";
            string sop = (_gridViewActivity.GetRowCellValue(r, "SOP") != null) ? _gridViewActivity.GetRowCellValue(r, "SOP").ToString() : "";
            string eop = (_gridViewActivity.GetRowCellValue(r, "EOP") != null) ? _gridViewActivity.GetRowCellValue(r, "EOP").ToString() : "";
            string volume = (_gridViewActivity.GetRowCellValue(r, "PeakVolume") != null) ? _gridViewActivity.GetRowCellValue(r, "PeakVolume").ToString() : "";

            if (iD == "")
            {
                MessageBox.Show("No sales activity found.", "Message");
                return;
            }

            var form = new SalesLeadsHistoryView
            {
                OperatorCode = OperatorCode,
                SalesLeadId = Convert.ToInt32(iD),
                CombinedLightingId = combinedLightingStudyId,
                Customer = customer,
                Program = program,
                Application = application,
                Sop = sop,
                Eop = eop,
                Volume = volume,
            };

            form.ShowDialog();

            // Refresh grid data
            if (_currentActivityHistoryReport == "History")
            {
                GetSalesActivityHistory();
            }
            else if (_currentActivityHistoryReport == "TopLeads")
            {
                GetTopLeads();
            }
        }


        #region Panel Events

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            int thickness = 2;
            int halfThickness = thickness / 2;
            using (var p = new Pen(Color.FromArgb(0, 122, 204), thickness))
            {
                e.Graphics.DrawRectangle(p, new Rectangle(halfThickness,
                                                          halfThickness,
                                                          panel1.ClientSize.Width - thickness,
                                                          panel1.ClientSize.Height - thickness));
            }
        }

        #endregion


        #region LinkLabel Events

        private void linkLblClose_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Close();
        }

        private void linkLblClose_MouseEnter(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = Color.Red;
        }

        private void linkLblClose_MouseLeave(object sender, EventArgs e)
        {
            linkLblClose.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }


        private void lnkLblMinMax_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (this.WindowState == FormWindowState.Maximized)
            {
                this.WindowState = FormWindowState.Normal;
            }
            else
            {
                this.WindowState = FormWindowState.Maximized;
            }
        }

        private void lnkLblMinMax_MouseEnter(object sender, EventArgs e)
        {
            lnkLblMinMax.LinkColor = Color.Red;
        }

        private void lnkLblMinMax_MouseLeave(object sender, EventArgs e)
        {
            lnkLblMinMax.LinkColor = ColorTranslator.FromHtml("0,122,204");
        }

        #endregion


        #region Button Click Events

        private void mesBtnExportChart_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(_reportName)) return;
            ExportToExcel();
        }

        #endregion  


        #region ComboBox Events

        private void cbxReportCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_dataBinding) return;

            string customer = cbxReportCustomer.Text;
            if (customer == "")
            { 
                _chartControl.Dispose();
                return;
            }
            ShowChart(_reportName);
        }

        #endregion


        #region NavBar Link Events

        void navBarControl1_LinkClicked(object sender, NavBarLinkEventArgs e)
        {
            _reportName = e.Link.Caption;

            //// Determine if this is an individual quote engineer chart
            //if (_reportName.Contains("By Month") && !_reportName.Contains("RFQs") && !_reportName.Contains("Quotes"))
            //{
            //    // Get the name of the quote engineer
            //    int i = _reportName.IndexOf("By Month");
            //    string name = _reportName.Substring(0, i - 1);
            //    ShowChartForIndividual(name);
            //    return;
            //}

            if (_reportName == "Programs Launching 2017 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersLaunching(2017);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else if (_reportName == "Programs Launching 2018 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersLaunching(2018);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else if (_reportName == "Programs Launching 2019 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersLaunching(2019);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else if (_reportName == "Programs Closing 2017 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersClosing(2017);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else if (_reportName == "Programs Closing 2018 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersClosing(2018);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else if (_reportName == "Programs Closing 2019 Peak Yearly Volume")
            {
                if (_chartControl != null) _chartControl.Dispose();
                if (_gridControl != null) _gridControl.Dispose();
                if (_gridControlActivity != null)
                {
                    _gridControlActivity.Dispose();
                    _gridViewActivity.Dispose();
                }

                _dataBinding = true;
                GetCustomersClosing(2019);
                _dataBinding = false;

                lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                _chartControl.Dispose();
            }
            else
            {
                //cbxReportCustomer.SelectedIndex = 0;
                ShowChart(_reportName);
            }

            lblDoubleClick.Visible = (_reportName == "Top Leads by Volume" || _reportName == "Activity History Last 7 Days");
        }
        #endregion


        #region Methods

        private int PopulateNavigationBar()
        {
            string error;
            _navigationController.GetNavigationGroups(out error);
            if (error != "")
            {
                MessageBox.Show(error);
                return 0;
            }

            int i = 0;
            foreach (var group in _navigationController.NavigationGroupsList)
            {
                var newGroup = new NavBarGroup(group.NavigationGroup);

                navBarControl1.BeginUpdate();
                navBarControl1.Groups.Add(newGroup);
                newGroup.Expanded = (i < 4);  // Expand the top four groups
                navBarControl1.EndUpdate();


                // Inner loop to add this group's items
                _navigationController.GetNavigationGroupItems(group.NavigationGroup, out error);
                if (error != "")
                {
                    MessageBox.Show(error);
                    return 0;
                }

                foreach (var menuItem in _navigationController.NavigationItemsList)
                {
                    var newItem = new NavBarItem(menuItem.NavigationItem) {Caption = menuItem.NavigationItem};

                    navBarControl1.BeginUpdate();
                    newGroup.ItemLinks.Add(newItem);
                    navBarControl1.EndUpdate();
                }
                i++;
            }

            // Specify the event handler which will be invoked when any link is clicked.
            navBarControl1.LinkClicked += navBarControl1_LinkClicked;

            return 1;
        }

        private void GetCustomersLaunching(int year)
        {
            int result = 0;
            cbxReportCustomer.DataSource = null;

            switch (year)
            {
                case 2017:
                    result = _controller.GetCustomersForProgramsLaunching2017();
                    break;
                case 2018:
                    result = _controller.GetCustomersForProgramsLaunching2018();
                    break;
                case 2019:
                    result = _controller.GetCustomersForProgramsLaunching2019();
                    break;
            }

            if (result == 1)
            {
                cbxReportCustomer.DataSource = _controller.CustomersList;
                cbxReportCustomer.DisplayMember = "Customer";
                cbxReportCustomer.Text = "";
            }
        }

        private void GetCustomersClosing(int year)
        {
            int result = 0;
            cbxReportCustomer.DataSource = null;

            switch (year)
            {
                case 2017:
                    result = _controller.GetCustomersForProgramsClosing2017();
                    break;
                case 2018:
                    result = _controller.GetCustomersForProgramsClosing2018();
                    break;
                case 2019:
                    result = _controller.GetCustomersForProgramsClosing2019();
                    break;
            }

            if (result == 1)
            {
                cbxReportCustomer.DataSource = _controller.CustomersList;
                cbxReportCustomer.DisplayMember = "Customer";
                cbxReportCustomer.Text = "";
            }
        }

        private void ShowChart(string caption)
        {
            Cursor.Current = Cursors.WaitCursor;

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }
            _gridControl.Dispose();
            _chartControl.Dispose();

            _chartControl = new ChartControl();
            _chartControl.Dock = DockStyle.Fill;
            pnlCanvas.Controls.Add(_chartControl);

            //_chartControl.Series.Clear();
            //_chartControl.Titles.Clear();
            //_chartControl.DataSource = null;

            switch (caption)
            {
                case "Total Sales Lead Activity Last 30 Days":
                    ShowTotalSalesLeadActivityForThirtyDays();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = false;
                    break;
                case "Activity History Last 7 Days":
                    _currentActivityHistoryReport = "History";
                    GetSalesActivityHistory();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = false;
                    break;
                case "Top Leads by Volume":
                    _currentActivityHistoryReport = "TopLeads";
                    GetTopLeads();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = false;
                    break;
                case "All Open Quotes":
                    GetOpenQuotes();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = false;
                    break;
                case "Quotes Opened in the Last 7 Days":
                    GetNewQuotes();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = false;
                    break;
                case "Number of Programs 2017-2019 by Customer":
                    ShowNumberOfProgramsLaunchingByCustomer();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = true;
                    break;
                case "Peak Volume of Programs 2017-2019 by Customer":
                    ShowPeakVolumeOfProgramsLaunching();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = false;
                    _isChart = true;
                    break;
                case "Programs Launching 2017 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2017);
                    _isChart = true;
                    break;
                case "Programs Launching 2018 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2018);
                    _isChart = true;
                    break;
                case "Programs Launching 2019 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2019);
                    _isChart = true;
                    break;
                case "Programs Closing 2017 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2017);
                    _isChart = true;
                    break;
                case "Programs Closing 2018 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2018);
                    _isChart = true;
                    break;
                case "Programs Closing 2019 Peak Yearly Volume":
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2019);
                    _isChart = true;
                    break;
            }

            mesBtnExportChart.Visible = true;

            Cursor.Current = Cursors.Default;
        }

        private void ExportToExcel()
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.Filter = "*.xlxs|*.xlxs";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    string filePath = ofd.FileName;

                    if (_isChart)
                    {
                        _chartControl.ExportToXlsx(filePath);
                    }
                    else
                    {
                        _gridControl.ExportToXlsx(filePath);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                _messageBox.Message = string.Format("Error thrown when attempting to export to Excel: {0}", error);
                _messageBox.ShowDialog();
            }
        }

        #endregion


        #region Grid Query Methods

        private void GetOpenQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            _chartControl.Dispose();
            _gridControl.Dispose();

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            _gridControl = new GridControl();
            _gridControl.Dock = DockStyle.Fill;
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            pnlCanvas.Controls.Add(_gridControl);

            _controller.GetOpenQuotes();
            if (!_controller.ListOpenQuotes.Any()) return;

            _gridControl.DataSource = _controller.ListOpenQuotes;
            //gridView1.Columns["Quote Number"].Visible = false;

            var view = _gridControl.MainView as GridView;
            view.OptionsBehavior.Editable = false;

            Cursor.Current = Cursors.Default;
        }

        private void GetNewQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            _chartControl.Dispose();
            _gridControl.Dispose();

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            _gridControl = new GridControl();
            _gridControl.Dock = DockStyle.Fill;
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            pnlCanvas.Controls.Add(_gridControl);

            _controller.GetNewQuotes();
            if (!_controller.ListNewQuotes.Any()) return;

            _gridControl.DataSource = _controller.ListNewQuotes;

            var view = _gridControl.MainView as GridView;
            view.OptionsBehavior.Editable = false;

            Cursor.Current = Cursors.Default;
        }

        private void GetSalesActivityHistory()
        {           
            Cursor.Current = Cursors.WaitCursor;

            _chartControl.Dispose();
            _gridControl.Dispose();

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }
            
            _gridControlActivity = new GridControl();
            _gridControlActivity.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControlActivity.LookAndFeel.UseDefaultLookAndFeel = false;
            _gridViewActivity = new GridView();

            _gridControlActivity.ViewCollection.Add(_gridViewActivity);
            _gridControlActivity.MainView = _gridViewActivity;

            _gridViewActivity.GridControl = _gridControlActivity;

            _gridControlActivity.DoubleClick += _gridControlActivity_DoubleClick;
            
            _gridControlActivity.Dock = DockStyle.Fill;
            pnlCanvas.Controls.Add(_gridControlActivity);


            _controller.GetSalesActivityHistory();
            if (!_controller.ListSalesPersonActivity.Any()) return;

            _gridControlActivity.DataSource = _controller.ListSalesPersonActivity;

            _gridViewActivity.OptionsBehavior.Editable = false;
            _gridViewActivity.Columns["SalesPersonCode"].Visible = 
                _gridViewActivity.Columns["RowId"].Visible = _gridViewActivity.Columns["CombinedLightingStudyId"].Visible = false;

            Cursor.Current = Cursors.Default;
        }

        private void GetTopLeads()
        {
            Cursor.Current = Cursors.WaitCursor;

            _chartControl.Dispose();
            _gridControl.Dispose();

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            _gridControlActivity = new GridControl();
            _gridControlActivity.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControlActivity.LookAndFeel.UseDefaultLookAndFeel = false;
            _gridViewActivity = new GridView();

            _gridControlActivity.ViewCollection.Add(_gridViewActivity);
            _gridControlActivity.MainView = _gridViewActivity;

            _gridViewActivity.GridControl = _gridControlActivity;

            _gridControlActivity.DoubleClick += _gridControlActivity_DoubleClick;

            _gridControlActivity.Dock = DockStyle.Fill;
            pnlCanvas.Controls.Add(_gridControlActivity);


            _controller.GetTopLeads();
            if (!_controller.ListTopLeads.Any()) return;

            _gridControlActivity.DataSource = _controller.ListTopLeads;

            _gridViewActivity.OptionsBehavior.Editable = false;
            _gridViewActivity.Columns["RowId"].Visible = _gridViewActivity.Columns["CombinedLightingStudyId"].Visible = false;


            //_gridControl = new GridControl();
            //_gridControl.Dock = DockStyle.Fill;
            //pnlCanvas.Controls.Add(_gridControl);

            //_controller.GetTopLeads();
            //if (!_controller.ListTopLeads.Any()) return;

            //_gridControl.DataSource = _controller.ListTopLeads;

            //var view = _gridControl.MainView as GridView;
            //view.OptionsBehavior.Editable = false;

            Cursor.Current = Cursors.Default;
        }

        private void ShowTotalSalesLeadActivityForThirtyDays()
        {
            string error;
            Cursor.Current = Cursors.WaitCursor;

            _chartControl.Dispose();
            _gridControl.Dispose();

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            _gridControl = new GridControl();
            //_gridControl.Dock = DockStyle.Fill;
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            pnlCanvas.Controls.Add(_gridControl);

            _controller.GetTotalSalesActivityThirtyDays(out error);
            if (error != "")
            {
                MessageBox.Show(error);
                return;
            }
            if (!_controller.TotalSalesActivityThirtyDaysList.Any()) return;

            _gridControl.DataSource = _controller.TotalSalesActivityThirtyDaysList;

            var view = _gridControl.MainView as GridView;
            view.OptionsBehavior.Editable = false;

            Cursor.Current = Cursors.Default;
        }

        #endregion


        #region Chart Query Methods

        private void ShowNumberOfProgramsLaunchingByCustomer()
        {
            string error;
            _controller.GetProgramsLaunchingByCustomer(out error);
            if (error != "")
            {
                MessageBox.Show(error);
                return;
            }
            _chartControl.DataSource = _controller.ProgramsLaunchingByCustomerList;


            var series1 = new Series();
            series1.LegendText = "HeadLamps";
            series1.Name = "HeadLamps";
            series1.ArgumentDataMember = "Customer";
            series1.ValueDataMembers[0] = "HeadLampCount";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series1.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series1.CrosshairLabelPattern = "{S}: {V:N0}";
            //series1.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year));

            var series2 = new Series();
            series2.LegendText = "TailLamps";
            series2.Name = "TailLamps";
            series2.ArgumentDataMember = "Customer";
            series2.ValueDataMembers[0] = "TailLampCount";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.Bar);
            series2.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series2.CrosshairLabelPattern = "{S}: {V:N0}";
            //series2.DataFilters.Add(new DataFilter("QuoteYear", "System.Int32", DataFilterCondition.Equal, DateTime.Now.Year - 1));

            // Add series to chart
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);

            _chartControl.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControl.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;

            // Allow commas
            _chartControl.SeriesTemplate.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Number;

            // Add title to chart
            var chartTitle = new ChartTitle();
            chartTitle.Text = "Number of Programs Launching from 2017-2019 by Customer";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowPeakVolumeOfProgramsLaunching()
        {
            string error;
            _controller.GetPeakVolumeOfProgramsLaunchingByCustomer(out error);
            if (error != "")
            {
                MessageBox.Show(error);
                return;
            }
            _chartControl.DataSource = _controller.PeakVolumeOfProgramsLaunchingList;


            var series1 = new Series();
            series1.LegendText = "Halogen HeadLamps";
            series1.Name = "Halogen HeadLamps";
            series1.ArgumentDataMember = "Customer";
            series1.ValueDataMembers[0] = "HalogenHeadLampPeakVolume";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series1.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series1.CrosshairLabelPattern = "{S}: {V:N0}";

            var series2 = new Series();
            series2.LegendText = "LED HeadLamps";
            series2.Name = "LED HeadLamps";
            series2.ArgumentDataMember = "Customer";
            series2.ValueDataMembers[0] = "LedHeadLampPeakVolume";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series2.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series2.CrosshairLabelPattern = "{S}: {V:N0}";

            var series3 = new Series();
            series3.LegendText = "Conventional TailLamps";
            series3.Name = "Conventional TailLamps";
            series3.ArgumentDataMember = "Customer";
            series3.ValueDataMembers[0] = "ConventionalTailLampPeakVolume";
            series3.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series3.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series3.CrosshairLabelPattern = "{S}: {V:N0}";

            var series4 = new Series();
            series4.LegendText = "LED TailLamps";
            series4.Name = "LED TailLamps";
            series4.ArgumentDataMember = "Customer";
            series4.ValueDataMembers[0] = "LedTailLampPeakVolume";
            series4.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series4.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series4.CrosshairLabelPattern = "{S}: {V:N0}";

            // Add series to chart
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);
            _chartControl.Series.Add(series3);
            _chartControl.Series.Add(series4);

            _chartControl.Legend.Visible = false;
           
            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControl.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;

            // Add title to chart
            var chartTitle = new ChartTitle();
            chartTitle.Text = "Peak Volume of Programs Launching from 2017-2019 by Customer";
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(int year)
        {
            string customer = cbxReportCustomer.Text;

            string error;
            switch (year)
            {
                case 2017:
                    _controller.GetPeakVolumeOfProgramsLaunching2017ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsLaunching2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsLaunching2018ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsLaunching2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsLaunching2019ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsLaunching2019List;
                    break;
            }
       
            var series1 = new Series();
            series1.LegendText = "Halogen HeadLamps";
            series1.Name = "Halogen HeadLamps";
            series1.ArgumentDataMember = "Program";
            series1.ValueDataMembers[0] = "HalogenHeadlampPeakVolume";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series1.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series1.CrosshairLabelPattern = "{S}: {V:N0}";

            var series2 = new Series();
            series2.LegendText = "LED HeadLamps";
            series2.Name = "LED HeadLamps";
            series2.ArgumentDataMember = "Program";
            series2.ValueDataMembers[0] = "LedHeadlampPeakVolume";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series2.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series2.CrosshairLabelPattern = "{S}: {V:N0}";

            var series3 = new Series();
            series3.LegendText = "Xenon HeadLamps";
            series3.Name = "Xenon HeadLamps";
            series3.ArgumentDataMember = "Program";
            series3.ValueDataMembers[0] = "XenonHeadlampPeakVolume";
            series3.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series3.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series3.CrosshairLabelPattern = "{S}: {V:N0}";

            var series4 = new Series();
            series4.LegendText = "Conventional TailLamps";
            series4.Name = "Conventional TailLamps";
            series4.ArgumentDataMember = "Program";
            series4.ValueDataMembers[0] = "ConventionalTaillampPeakVolume";
            series4.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series4.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series4.CrosshairLabelPattern = "{S}: {V:N0}";

            var series5 = new Series();
            series5.LegendText = "LED TailLamps";
            series5.Name = "LED TailLamps";
            series5.ArgumentDataMember = "Program";
            series5.ValueDataMembers[0] = "LedTaillampPeakVolume";
            series5.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series5.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series5.CrosshairLabelPattern = "{S}: {V:N0}";


            // Add series to chart
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);
            _chartControl.Series.Add(series3);
            _chartControl.Series.Add(series4);
            _chartControl.Series.Add(series5);


            _chartControl.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControl.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;
            diagram.Rotated = true;


            // Add title to chart
            var chartTitle = new ChartTitle();
            switch (year)
            {
                case 2017:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Launching in 2017", customer);
                    break;
                case 2018:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Launching in 2018", customer);
                    break;
                case 2019:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Launching in 2019", customer);
                    break;
            }
            _chartControl.Titles.Add(chartTitle);
        }

        private void ShowPeakVolumeOfProgramsClosingByCustomerByYear(int year)
        {
            string customer = cbxReportCustomer.Text;

            string error;
            switch (year)
            {
                case 2017:
                    _controller.GetPeakVolumeOfProgramsClosing2017ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsClosing2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsClosing2018ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsClosing2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsClosing2019ByCustomer(customer, out error);
                    if (error != "")
                    {
                        MessageBox.Show(error);
                        return;
                    }
                    _chartControl.DataSource = _controller.PeakVolumeOfProgramsClosing2019List;
                    break;
            }
            
            var series1 = new Series();
            series1.LegendText = "Halogen HeadLamps";
            series1.Name = "Halogen HeadLamps";
            series1.ArgumentDataMember = "Program";
            series1.ValueDataMembers[0] = "HalogenHeadlampPeakVolume";
            series1.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series1.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series1.CrosshairLabelPattern = "{S}: {V:N0}";

            var series2 = new Series();
            series2.LegendText = "LED HeadLamps";
            series2.Name = "LED HeadLamps";
            series2.ArgumentDataMember = "Program";
            series2.ValueDataMembers[0] = "LedHeadlampPeakVolume";
            series2.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series2.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series2.CrosshairLabelPattern = "{S}: {V:N0}";

            var series3 = new Series();
            series3.LegendText = "Xenon HeadLamps";
            series3.Name = "Xenon HeadLamps";
            series3.ArgumentDataMember = "Program";
            series3.ValueDataMembers[0] = "XenonHeadlampPeakVolume";
            series3.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series3.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series3.CrosshairLabelPattern = "{S}: {V:N0}";

            var series4 = new Series();
            series4.LegendText = "Conventional TailLamps";
            series4.Name = "Conventional TailLamps";
            series4.ArgumentDataMember = "Program";
            series4.ValueDataMembers[0] = "ConventionalTaillampPeakVolume";
            series4.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series4.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series4.CrosshairLabelPattern = "{S}: {V:N0}";

            var series5 = new Series();
            series5.LegendText = "LED TailLamps";
            series5.Name = "LED TailLamps";
            series5.ArgumentDataMember = "Program";
            series5.ValueDataMembers[0] = "LedTaillampPeakVolume";
            series5.ChangeView(DevExpress.XtraCharts.ViewType.StackedBar);
            series5.LegendPointOptions.ValueNumericOptions.Format = NumericFormat.Number;
            series5.CrosshairLabelPattern = "{S}: {V:N0}";


            // Add series to chart
            _chartControl.Series.Add(series1);
            _chartControl.Series.Add(series2);
            _chartControl.Series.Add(series3);
            _chartControl.Series.Add(series4);
            _chartControl.Series.Add(series5);


            _chartControl.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControl.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;
            diagram.Rotated = true;


            // Add title to chart
            var chartTitle = new ChartTitle();
            switch (year)
            {
                case 2017:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Closing in 2017", customer);
                    break;
                case 2018:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Closing in 2018", customer);
                    break;
                case 2019:
                    chartTitle.Text = string.Format("Peak Volume of {0} Programs Closing in 2019", customer);
                    break;
            }
            _chartControl.Titles.Add(chartTitle);
        }
        
        #endregion


    }
}
