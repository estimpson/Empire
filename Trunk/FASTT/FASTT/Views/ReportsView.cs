using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraCharts;
using DevExpress.XtraGrid;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraNavBar;
using FASTT.Controllers;
using FASTT.Controls;
using FASTT.Emumerators;

namespace FASTT.Views
{
    public partial class ReportsView : Form
    {
        #region Class Objects

        private readonly ReportsController _controller;
        private readonly ReportsNavigationController _navigationController;
        private ChartControl _chartControl;
        private ChartControl _chartControlLaunching;
        private ChartControl _chartControlClosing;
        private GridControl _gridControl;
        private GridView _gridView;
        private GridControl _gridControlActivity;
        private GridView _gridViewActivity;
        private readonly CustomMessageBox _messageBox;
        private GridControlEnum _gridControlEnum;
        
        #endregion


        #region Variables

        private string _reportName;
        private bool _isChart;
        private string _currentActivityHistoryReport;
        private int _year;

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

        private bool _isFormBeginState;
        public bool IsFormBeginState
        {
            get { return _isFormBeginState; }
            set 
            { 
                _isFormBeginState = value;
                mesClearGridSettings.Text = (value) ? "Clear All Grid Settings" : "Clear Grid Settings";
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
            _chartControlLaunching = new ChartControl {Dock = DockStyle.Fill};
            _chartControlClosing = new ChartControl {Dock = DockStyle.Fill};
            _gridControl = new GridControl();
            _gridView = new GridView();
            _messageBox = new CustomMessageBox();

            _gridControlEnum = GridControlEnum.None;
            IsFormBeginState = true;
        }

        private void ReportsView_Load(object sender, EventArgs e)
        {
            PopulateNavigationBar();

            lnkLblMinMax.LinkBehavior = linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            lblSelectCustomer.Visible = cbxReportCustomer.Visible =
                mesBtnGo.Visible = mesBtnExportChart.Visible = lblDoubleClick.Visible = 
                rbtnNorthAmerica.Visible = rbtnChina.Visible = tlpSplitCharts.Visible = false;

            rbtnNorthAmerica.Checked = true;

            Error = "";
        }

        #endregion


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
            SaveGridControlSettings();

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


        #region Activity Grid Control DoubleClick Event

        void _gridControlActivity_DoubleClick(object sender, EventArgs e)
        {
            int r = _gridViewActivity.GetSelectedRows()[0];
            if (r < 0) return;

            ModifySalesLead();
        }

        #endregion


        #region Button Click Events

        private void mesBtnExportChart_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(_reportName)) return;
            ExportToExcel();
        }

        private void mesClearGridSettings_Click(object sender, EventArgs e)
        {
            ClearGridSettings();
        }

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            string customer = cbxReportCustomer.Text;
            if (customer == "")
            {
                //_chartControl.Dispose();
                return;
            }
            ShowReport(_reportName);
        }

        #endregion  


        #region RadioButton Click Events

        private void rbtnNorthAmerica_CheckedChanged(object sender, EventArgs e)
        {
            if (_isFormBeginState) return;
            rbtnChina.Checked = (!rbtnNorthAmerica.Checked);

            tlpSplitCharts.Controls.Remove(_chartControlLaunching);
            tlpSplitCharts.Controls.Remove(_chartControlClosing);

            if (_chartControl != null) _chartControl.Dispose();
            if (_gridControl != null)
            {
                _gridControl.Dispose();
                _gridView.Dispose();
            }
            
            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            GetCustomersLaunchingClosing(_year);
        }

        private void rbtnChina_CheckedChanged(object sender, EventArgs e)
        {
            if (_isFormBeginState) return;
            rbtnNorthAmerica.Checked = (!rbtnChina.Checked);

            tlpSplitCharts.Controls.Remove(_chartControlLaunching);
            tlpSplitCharts.Controls.Remove(_chartControlClosing);

            if (_chartControl != null)
            {
                _chartControl.Dispose();
            }
            if (_gridControl != null)
            {
                _gridControl.Dispose();
                _gridView.Dispose();
            }
            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridViewActivity.Dispose();
            }

            GetCustomersLaunchingClosing(_year);
        }

        #endregion


        #region ComboBox Events

        private void cbxReportCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        #endregion


        #region NavBar Link Events

        void navBarControl1_LinkClicked(object sender, NavBarLinkEventArgs e)
        {
            _reportName = e.Link.Caption;
            IsFormBeginState = false;

            tlpSplitCharts.Visible = false;

            // Save the settings of the last opened and closed grid control
            if (_gridControlEnum != GridControlEnum.None)
            {
                SaveGridControlSettings();
                _gridControlEnum = GridControlEnum.None;
            }

            DisposeGridsCharts();

            // Populate the Customers dropdown list based on region and whether they have programs launching or closing in the selected year
            switch (_reportName)
            {
                case "Programs Launching/Closing 2017 Peak Volume":
                    _year = 2017;
                    GetCustomersLaunchingClosing(_year);
                    break;
                case "Programs Launching/Closing 2018 Peak Volume":
                    _year = 2018;
                    GetCustomersLaunchingClosing(_year);
                    break;
                case "Programs Launching/Closing 2019 Peak Volume":
                    _year = 2019;
                    GetCustomersLaunchingClosing(_year);
                    break;
                default:
                    ShowReport(_reportName);
                    break;
            }

            lblDoubleClick.Visible = (_reportName == "Top Leads by Volume" || _reportName == "Activity History Last 7 Days");
        }

        #endregion


        #region Methods

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
                _messageBox.Message = "No sales activity found.";
                _messageBox.ShowDialog();
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
            DisposeGridsCharts();
            if (_currentActivityHistoryReport == "History")
            {
                GetSalesActivityHistory();
            }
            else if (_currentActivityHistoryReport == "TopLeads")
            {
                GetTopLeads();
            }
        }

        private int PopulateNavigationBar()
        {
            string error;
            _navigationController.GetNavigationGroups(out error);
            if (error != "")
            {
                _messageBox.Message = error;
                _messageBox.ShowDialog();
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
                    _messageBox.Message = error;
                    _messageBox.ShowDialog();
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

        private void SaveGridControlSettings()
        {
            try
            {
                Directory.CreateDirectory(@"C:\FasttGridSettings");
            }
            catch (Exception ex)
            {
                _messageBox.Message = "Failed to create the directory where grid settings will be saved.  " + ex.Message;
                _messageBox.ShowDialog();
                return;
            }
            
            string fileName;
            switch (_gridControlEnum)
            {
                case GridControlEnum.None:
                    break;
                case GridControlEnum.ActivityHistory:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";
                    try
                    {
                        _gridControlActivity.MainView.SaveLayoutToXml(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
                    break;
                case GridControlEnum.TopLeads:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";
                    try
                    {
                        _gridControlActivity.MainView.SaveLayoutToXml(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
                    break;
                case GridControlEnum.OpenQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";
                    try
                    {
                        _gridControl.MainView.SaveLayoutToXml(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
                    break;
                case GridControlEnum.NewQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";
                    try
                    {
                        _gridControl.MainView.SaveLayoutToXml(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
                    break;
            }
        }

        private void GetCustomersLaunchingClosing(int year)
        {
            Cursor.Current = Cursors.WaitCursor;

            int result = 0;
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";

            cbxReportCustomer.DataSource = null;

            switch (year)
            {
                case 2017:
                    result = _controller.GetCustomersForProgramsLaunchingClosing2017(region);
                    break;
                case 2018:
                    result = _controller.GetCustomersForProgramsLaunchingClosing2018(region);
                    break;
                case 2019:
                    result = _controller.GetCustomersForProgramsLaunchingClosing2019(region);
                    break;
            }

            if (result != 1) return;
            cbxReportCustomer.DataSource = _controller.CustomersList;
            cbxReportCustomer.DisplayMember = "Customer";
            cbxReportCustomer.Text = "";

            lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = true;

            Cursor.Current = Cursors.Default;
        }

        private void ShowReport(string caption)
        {
            Cursor.Current = Cursors.WaitCursor;

            DisposeGridsCharts();

            switch (caption)
            {
                case "Total Sales Lead Activity Last 30 Days":
                    //lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;

                    //ShowTotalSalesLeadActivityForThirtyDays();
                    
                    //_isChart = false;
                    //_gridControlEnum = GridControlEnum.None;
                    //break;
                case "Activity History Last 7 Days":
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;

                    GetSalesActivityHistory();

                    _currentActivityHistoryReport = "History";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.ActivityHistory;
                    break;
                case "Top Leads by Volume":
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;

                    GetTopLeads();

                    _currentActivityHistoryReport = "TopLeads";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.TopLeads;
                    break;
                case "All Completed Quotes":
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;

                    GetOpenQuotes();
                    
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.OpenQuotes;
                    break;
                case "Quotes Opened in the Last 60 Days":
                    GetNewQuotes();
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.NewQuotes;
                    break;
                case "Number of Programs 2017-2019 by Customer":
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;
            
                    _chartControl = new ChartControl();
                    _chartControl.Dock = DockStyle.Fill;
                    pnlCanvas.Controls.Add(_chartControl);

                    ShowNumberOfProgramsLaunchingByCustomer();
                    
                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Peak Volume of Programs 2017-2019 by Customer":
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = rbtnNorthAmerica.Visible = rbtnChina.Visible = mesBtnGo.Visible = false;

                    _chartControl = new ChartControl{Dock = DockStyle.Fill};
                    pnlCanvas.Controls.Add(_chartControl);

                    ShowPeakVolumeOfProgramsLaunching();
                    
                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Programs Launching/Closing 2017 Peak Volume":
                    tlpSplitCharts.Visible = true;
                    _chartControlLaunching = new ChartControl {Dock = DockStyle.Fill};
                    _chartControlClosing = new ChartControl {Dock = DockStyle.Fill};
                    tlpSplitCharts.Controls.Add(_chartControlLaunching, 0, 0);
                    tlpSplitCharts.Controls.Add(_chartControlClosing, 0, 1);
                    
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2017);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2017);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Programs Launching/Closing 2018 Peak Volume":
                    tlpSplitCharts.Visible = true;
                    _chartControlLaunching = new ChartControl {Dock = DockStyle.Fill};
                    _chartControlClosing = new ChartControl {Dock = DockStyle.Fill};
                    tlpSplitCharts.Controls.Add(_chartControlLaunching, 0, 0);
                    tlpSplitCharts.Controls.Add(_chartControlClosing, 0, 1);

                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2018);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2018);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Programs Launching/Closing 2019 Peak Volume":
                    tlpSplitCharts.Visible = true;
                    _chartControlLaunching = new ChartControl {Dock = DockStyle.Fill};
                    _chartControlClosing = new ChartControl {Dock = DockStyle.Fill};
                    tlpSplitCharts.Controls.Add(_chartControlLaunching, 0, 0);
                    tlpSplitCharts.Controls.Add(_chartControlClosing, 0, 1);

                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2019);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2019);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
            }

            mesBtnExportChart.Visible = true;
            mesClearGridSettings.Visible = (caption == "Activity History Last 7 Days" || caption == "Top Leads by Volume" ||
                                            caption == "All Completed Quotes" || caption == "Quotes Opened in the Last 60 Days");

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

        private void DisposeGridsCharts()
        {
            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridControlActivity = null;
            }
            if (_gridViewActivity != null)
            {
                _gridViewActivity.Dispose();
                _gridViewActivity = null;
            }
            if (_gridControl != null)
            {
                _gridControl.Dispose();
                _gridControl = null;
            }
            if (_gridView != null)
            {
                _gridView.Dispose();
                _gridView = null;
            }
            if (_chartControl != null)
            {
                _chartControl.Dispose();
                _chartControl = null;
            }
            if (_chartControlLaunching != null)
            {
                tlpSplitCharts.Controls.Remove(_chartControlLaunching);
                _chartControlLaunching.Dispose();
                _chartControlLaunching = null;
            }
            if (_chartControlClosing != null)
            {
                tlpSplitCharts.Controls.Remove(_chartControlClosing);
                _chartControlClosing.Dispose();
                _chartControlClosing = null;
            }
        }

        private void ClearGridSettings()
        {
            if (_isFormBeginState)
            {
                // Delete all saved grid settings XML files
                try
                {
                    string sourceDir = @"C:\FasttGridSettings";
                    Directory.CreateDirectory(sourceDir);

                    string[] xmlList = Directory.GetFiles(sourceDir, "*.xml");
                    foreach (var file in xmlList) File.Delete(file);

                    _messageBox.Message = "Cleared layout settings for all grids.";
                    _messageBox.ShowDialog();
                }
                catch (Exception ex)
                {
                    _messageBox.Message = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                    _messageBox.ShowDialog();
                }
                return;
            }

            // Delete the grid settings XML file of the currently opened grid
            string fileName = "";
            switch (_gridControlEnum)
            {
                case GridControlEnum.ActivityHistory:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";

                    _gridViewActivity.ClearGrouping();
                    _gridViewActivity.ClearColumnsFilter();
                    _gridViewActivity.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.TopLeads:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";

                    _gridViewActivity.ClearGrouping();
                    _gridViewActivity.ClearColumnsFilter();
                    _gridViewActivity.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.OpenQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";

                    _gridView.ClearGrouping();
                    _gridView.ClearColumnsFilter();
                    _gridView.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.NewQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";

                    _gridView.ClearGrouping();
                    _gridView.ClearColumnsFilter();
                    _gridView.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;
                    break;
            }

            try
            {
                if (!File.Exists(fileName)) return;
                File.Delete(fileName);
            }
            catch (Exception ex)
            {
                _messageBox.Message = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                _messageBox.ShowDialog();
            }
        }

        #endregion


        #region Grid Query Methods

        private void GetOpenQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            _gridControl = new GridControl();
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            _gridView = new GridView();

            _gridControl.ViewCollection.Add(_gridView);
            _gridControl.MainView = _gridView;

            _gridView.GridControl = _gridControl;

            _gridControl.Dock = DockStyle.Fill;
            pnlCanvas.Controls.Add(_gridControl);


            _controller.GetOpenQuotes();
            if (!_controller.ListOpenQuotes.Any()) return;

            _gridControl.DataSource = _controller.ListOpenQuotes;
            //gridView1.Columns["Quote Number"].Visible = false;

            var view = _gridControl.MainView as GridView;
            view.OptionsBehavior.Editable = false;
            view.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            view.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";
            if (File.Exists(filePath)) _gridControl.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetNewQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            _gridControl = new GridControl();
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            _gridView = new GridView();

            _gridControl.ViewCollection.Add(_gridView);
            _gridControl.MainView = _gridView;

            _gridView.GridControl = _gridControl;

            _gridControl.Dock = DockStyle.Fill;
            pnlCanvas.Controls.Add(_gridControl);


            _controller.GetNewQuotes();
            if (!_controller.ListNewQuotes.Any()) return;

            _gridControl.DataSource = _controller.ListNewQuotes;

            var view = _gridControl.MainView as GridView;
            view.OptionsBehavior.Editable = false;
            view.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            view.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";
            if (File.Exists(filePath))
            {
                try
                {
                    _gridControl.MainView.RestoreLayoutFromXml(filePath);
                }
                catch (Exception ex)
                {
                    _messageBox.Message = "Failed to restore grid settings.  " + ex.Message;
                    _messageBox.ShowDialog();
                } 
            }

            Cursor.Current = Cursors.Default;
        }

        private void GetSalesActivityHistory()
        {           
            Cursor.Current = Cursors.WaitCursor;

            //DisposeGridsCharts();
            
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
            _gridViewActivity.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            _gridViewActivity.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";
            if (File.Exists(filePath)) _gridControlActivity.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetTopLeads()
        {
            Cursor.Current = Cursors.WaitCursor;

            //DisposeGridsCharts();

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
            _gridViewActivity.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            _gridViewActivity.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";
            if (File.Exists(filePath)) _gridControlActivity.MainView.RestoreLayoutFromXml(filePath);


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

            if (_gridControlActivity != null)
            {
                _gridControlActivity.Dispose();
                _gridControlActivity = null;
                _gridViewActivity.Dispose();
                _gridViewActivity = null;
            }
            if (_gridControl != null)
            {
                _gridControl.Dispose();
                _gridControl = null;
            }
            if (_chartControl != null)
            {
                _chartControl.Dispose();
                _chartControl = null;
            }
            if (_chartControlLaunching != null)
            {
                tlpSplitCharts.Controls.Remove(_chartControlLaunching);
                _chartControlLaunching.Dispose();
                _chartControlLaunching = null;
            }
            if (_chartControlClosing != null)
            {
                tlpSplitCharts.Controls.Remove(_chartControlClosing);
                _chartControlClosing.Dispose();
                _chartControlClosing = null;
            }

            _gridControl = new GridControl();
            //_gridControl.Dock = DockStyle.Fill;
            _gridControl.LookAndFeel.SkinName = "Visual Studio 2013 Dark";
            _gridControl.LookAndFeel.UseDefaultLookAndFeel = false;
            pnlCanvas.Controls.Add(_gridControl);

            _controller.GetTotalSalesActivityThirtyDays(out error);
            if (error != "")
            {
                _messageBox.Message = error;
                _messageBox.ShowDialog();
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

        void _chartControl_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
        {
            foreach (CrosshairElement element in e.CrosshairElements)
            {
                element.LabelElement.TextColor = Color.Black;
                element.LabelElement.Font = new Font("Tahoma", 10f, FontStyle.Bold);
                element.LabelElement.MarkerSize = new Size(10, 10);
            }
        }

        private void ShowNumberOfProgramsLaunchingByCustomer()
        {
            string error;
            _controller.GetProgramsLaunchingByCustomer(out error);
            if (error != "")
            {
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return;
            }
            _chartControl.DataSource = _controller.ProgramsLaunchingByCustomerList;

            _chartControl.CustomDrawCrosshair += _chartControl_CustomDrawCrosshair;

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
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return;
            }
            _chartControl.DataSource = _controller.PeakVolumeOfProgramsLaunchingList;

            _chartControl.CustomDrawCrosshair += _chartControl_CustomDrawCrosshair;

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
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";
            string customer = cbxReportCustomer.Text;

            _chartControlLaunching.CustomDrawCrosshair += _chartControlLaunching_CustomDrawCrosshair;
            _chartControlLaunching.ObjectSelected += _chartControlLaunching_ObjectSelected;

            string error;
            switch (year)
            {
                case 2017:
                    _controller.GetPeakVolumeOfProgramsLaunching2017ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    if (!_controller.PeakVolumeOfProgramsLaunching2017List.Any()) return;
                    _chartControlLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsLaunching2018ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    _chartControlLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsLaunching2019ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    _chartControlLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2019List;
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
            _chartControlLaunching.Series.Add(series1);
            _chartControlLaunching.Series.Add(series2);
            _chartControlLaunching.Series.Add(series3);
            _chartControlLaunching.Series.Add(series4);
            _chartControlLaunching.Series.Add(series5);


            _chartControlLaunching.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControlLaunching.Diagram as XYDiagram;
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
            _chartControlLaunching.Titles.Add(chartTitle);
        }

        void _chartControlLaunching_ObjectSelected(object sender, HotTrackEventArgs e)
        {
            string x = e.AdditionalObject.ToString();


            if (e.AdditionalObject is SeriesPoint)
            {
                var r = e.AdditionalObject as SeriesPoint;
                string b = r.Argument;
                string c = r.Values[0].ToString();
            }

            var o = e.AdditionalObject as AxisLabelItem;
            if (o != null)
            {
                string z = o.AxisValue.ToString();
            }
        }

        void _chartControlLaunching_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
        {
            foreach (CrosshairElement element in e.CrosshairElements)
            {
                element.LabelElement.TextColor = Color.Black;
                element.LabelElement.Font = new Font("Tahoma", 10f, FontStyle.Bold);
                element.LabelElement.MarkerSize = new Size(10, 10);
            }
        }

        private void ShowPeakVolumeOfProgramsClosingByCustomerByYear(int year)
        {
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";
            string customer = cbxReportCustomer.Text;

            _chartControlClosing.CustomDrawCrosshair += _chartControlClosing_CustomDrawCrosshair;

            string error;
            switch (year)
            {
                case 2017:
                    _controller.GetPeakVolumeOfProgramsClosing2017ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    _chartControlClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsClosing2018ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    _chartControlClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsClosing2019ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    _chartControlClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2019List;
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
            _chartControlClosing.Series.Add(series1);
            _chartControlClosing.Series.Add(series2);
            _chartControlClosing.Series.Add(series3);
            _chartControlClosing.Series.Add(series4);
            _chartControlClosing.Series.Add(series5);


            _chartControlClosing.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = _chartControlClosing.Diagram as XYDiagram;
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
            _chartControlClosing.Titles.Add(chartTitle);
        }

        void _chartControlClosing_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
        {
            foreach (CrosshairElement element in e.CrosshairElements)
            {
                element.LabelElement.TextColor = Color.Black;
                element.LabelElement.Font = new Font("Tahoma", 10f, FontStyle.Bold);
                element.LabelElement.MarkerSize = new Size(10, 10);
            }
        }
        
        #endregion


    }
}
