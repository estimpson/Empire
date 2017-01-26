using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.Utils;
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
        private readonly CustomMessageBox _messageBox;
        private GridControlEnum _gridControlEnum;
        
        #endregion


        #region Variables

        private string _reportName;
        private string _currentActivityHistoryReport;
        private bool _isDashboardFull;
        private bool _isChart;
        private bool _isDatabinding;
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

        private bool _isDashboardIntro;
        public bool IsDashboardIntro
        {
            get { return _isDashboardIntro; }
            set 
            { 
                _isDashboardIntro = value;
                mesBtnShowDashboard.Visible = !value;
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
            _messageBox = new CustomMessageBox();

            _gridControlEnum = GridControlEnum.None;
        }

        private void ReportsView_Load(object sender, EventArgs e)
        {
            PopulateNavigationBar();

            lnkLblMinMax.LinkBehavior = linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;

            rbtnNorthAmerica.Checked = true;
            ControlScreenState(FormStateEnum.DashboardIntro);

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


        #region Button Click Events

        private void mesBtnShowDashboard_Click(object sender, EventArgs e)
        {
            // Save the settings of the last opened and closed grid control
            if (_gridControlEnum != GridControlEnum.None)
            {
                SaveGridControlSettings();
                _gridControlEnum = GridControlEnum.None;
            }

            ControlScreenState(FormStateEnum.DashboardIntro);
        }

        private void mesClearGridSettings_Click(object sender, EventArgs e)
        {
            ClearGridLayoutSettings();
        }

        private void mesBtnExportChart_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(_reportName)) return;
            ExportToExcel();
        }

        private void mesBtnGo_Click(object sender, EventArgs e)
        {
            string customer = cbxReportCustomer.Text;
            if (customer == "") return;

            ControlScreenState(FormStateEnum.ChartDual);

            ShowLaunchingClosingReport(_reportName);
        }

        #endregion


        #region RadioButton Click Events

        private void rbtnNorthAmerica_CheckedChanged(object sender, EventArgs e)
        {
            if (_isDashboardIntro) return;

            rbtnChina.Checked = (!rbtnNorthAmerica.Checked);
            RadioButtonAction();
        }

        private void rbtnChina_CheckedChanged(object sender, EventArgs e)
        {
            if (_isDashboardIntro) return;

            rbtnNorthAmerica.Checked = (!rbtnChina.Checked);
            RadioButtonAction();
        }

        #endregion


        #region ComboBox Events

        private void cbxReportCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_isDatabinding || cbxReportCustomer.Text.Trim() == "") return;

            if (_isDashboardIntro || _isDashboardFull)
            {
                ControlScreenState(FormStateEnum.DashboardFull);
                return;
            }
            mesBtnGo.Visible = (cbxReportCustomer.Text.Trim() != "");
        }

        #endregion




        #region NavBar Link Events

        void navBarControl1_LinkClicked(object sender, NavBarLinkEventArgs e)
        {
            _reportName = e.Link.Caption;

            // Save the settings of the last opened and closed grid control
            if (_gridControlEnum != GridControlEnum.None)
            {
                SaveGridControlSettings();
                _gridControlEnum = GridControlEnum.None;
            }

            switch (_reportName)
            {
                case "Programs Launching/Closing 2017 Peak Volume":
                    _year = 2017;
                    GetCustomersLaunchingClosingList(_year);
                    break;
                case "Programs Launching/Closing 2018 Peak Volume":
                    _year = 2018;
                    GetCustomersLaunchingClosingList(_year);
                    break;
                case "Programs Launching/Closing 2019 Peak Volume":
                    _year = 2019;
                    GetCustomersLaunchingClosingList(_year);
                    break;
                default:
                    ShowReport(_reportName);
                    break;
            }
        }

        #endregion


        #region Activity Grid Control DoubleClick Event

        private void grdActivity_DoubleClick(object sender, EventArgs e)
        {
            int r = grdViewActivity.GetSelectedRows()[0];
            if (r < 0) return;

            ModifySalesLead();
        }

        #endregion


        #region Methods

        private void RadioButtonAction()
        {
            Cursor.Current = Cursors.WaitCursor;

            if (_isDashboardIntro || _isDashboardFull)
            {
                GetDashboardCustomerList();
            }
            else if (tlpDashboard.Visible)
            {
                GetCustomersList();
            }
            else
            {
                GetCustomersLaunchingClosingList(_year);
            }

            Cursor.Current = Cursors.Default;
        }

        private void ModifySalesLead()
        {
            int r = grdViewActivity.GetSelectedRows()[0];

            string iD = (grdViewActivity.GetRowCellValue(r, "RowId") != null) ? grdViewActivity.GetRowCellValue(r, "RowId").ToString() : "";
            int combinedLightingStudyId = (grdViewActivity.GetRowCellValue(r, "CombinedLightingStudyId") != null) ? Convert.ToInt32(grdViewActivity.GetRowCellValue(r, "CombinedLightingStudyId")) : 0;
            string customer = (grdViewActivity.GetRowCellValue(r, "Customer") != null) ? grdViewActivity.GetRowCellValue(r, "Customer").ToString() : "";
            string program = (grdViewActivity.GetRowCellValue(r, "Program") != null) ? grdViewActivity.GetRowCellValue(r, "Program").ToString() : "";
            string application = (grdViewActivity.GetRowCellValue(r, "Application") != null) ? grdViewActivity.GetRowCellValue(r, "Application").ToString() : "";
            string sop = (grdViewActivity.GetRowCellValue(r, "SOP") != null) ? grdViewActivity.GetRowCellValue(r, "SOP").ToString() : "";
            string eop = (grdViewActivity.GetRowCellValue(r, "EOP") != null) ? grdViewActivity.GetRowCellValue(r, "EOP").ToString() : "";
            string volume = (grdViewActivity.GetRowCellValue(r, "PeakVolume") != null) ? grdViewActivity.GetRowCellValue(r, "PeakVolume").ToString() : "";

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
                        grdActivity.MainView.SaveLayoutToXml(fileName);
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
                        grdActivity.MainView.SaveLayoutToXml(fileName);
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
                        grdGeneral.MainView.SaveLayoutToXml(fileName);
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
                        grdGeneral.MainView.SaveLayoutToXml(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
                    break;
            }
        }

        private void GetCustomersLaunchingClosingList(int year)
        {
            Cursor.Current = Cursors.WaitCursor;

            int result = 0;

            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";

            // Populate the Customers dropdown list based on region and whether they have programs launching or closing in the selected year
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

            if (result == 0) return;
            _isDatabinding = true;
            cbxReportCustomer.DataSource = null;
            cbxReportCustomer.DataSource = _controller.CustomersList;
            cbxReportCustomer.DisplayMember = "Customer";
            cbxReportCustomer.Text = "";
            _isDatabinding = false;

            ControlScreenState(FormStateEnum.LaunchingClosingLinkClicked);

            Cursor.Current = Cursors.Default;
        }

        private void ShowReport(string caption)
        {
            Cursor.Current = Cursors.WaitCursor;

            switch (caption)
            {
                case "Activity History Last 7 Days":
                    ControlScreenState(FormStateEnum.ActivityGrid);

                    GetSalesActivityHistory();

                    _currentActivityHistoryReport = "History";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.ActivityHistory;
                    break;
                case "Top Leads by Volume":
                    ControlScreenState(FormStateEnum.ActivityGrid);

                    GetTopLeads();

                    _currentActivityHistoryReport = "TopLeads";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.TopLeads;
                    break;
                case "All Completed Quotes":
                    ControlScreenState(FormStateEnum.QuoteGrid);

                    GetOpenQuotes();
                    
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.OpenQuotes;
                    break;
                case "Quotes Opened in the Last 60 Days":
                    ControlScreenState(FormStateEnum.QuoteGrid);

                    GetNewQuotes();

                    _isChart = false;
                    _gridControlEnum = GridControlEnum.NewQuotes;
                    break;
                case "Number of Programs 2017-2019 by Customer":
                    ControlScreenState(FormStateEnum.ChartSingle);

                    ShowNumberOfProgramsLaunchingByCustomer();
                    
                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Peak Volume of Programs 2017-2019 by Customer":
                    ControlScreenState(FormStateEnum.ChartSingle);

                    ShowPeakVolumeOfProgramsLaunching();
                    
                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
            }
            Cursor.Current = Cursors.Default;
        }

        private void ShowLaunchingClosingReport(string caption)
        {
            Cursor.Current = Cursors.WaitCursor;

            switch (caption)
            {
                case "Programs Launching/Closing 2017 Peak Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2017);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2017);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Programs Launching/Closing 2018 Peak Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2018);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2018);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case "Programs Launching/Closing 2019 Peak Volume":
                    ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(2019);
                    ShowPeakVolumeOfProgramsClosingByCustomerByYear(2019);

                    _isChart = true;
                    _gridControlEnum = GridControlEnum.None;
                    break;
            }
            ControlScreenState(FormStateEnum.ChartDual);

            Cursor.Current = Cursors.Default;
        }

        private void ExportToExcel()
        {
            _messageBox.Message = "Locate the Excel file (.xlsx) where you want this data exported.";
            _messageBox.ShowDialog();

            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.Title = "Select the Excel file (.xlsx) you want to import the data into";
                ofd.Filter = "*.xlsx|*.xlsx";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    string filePath = ofd.FileName;

                    if (_isChart)
                    {
                        ccGeneral.ExportToXlsx(filePath);
                    }
                    else
                    {
                        grdGeneral.ExportToXlsx(filePath);
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

        private void ClearGridLayoutSettings()
        {
            if (_isDashboardIntro)
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

                    grdViewActivity.ClearGrouping();
                    grdViewActivity.ClearColumnsFilter();
                    grdViewActivity.ClearSorting();
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.TopLeads:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";

                    grdViewActivity.ClearGrouping();
                    grdViewActivity.ClearColumnsFilter();
                    grdViewActivity.ClearSorting();
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.OpenQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";

                    grdViewGeneral.ClearGrouping();
                    grdViewGeneral.ClearColumnsFilter();
                    grdViewGeneral.ClearSorting();
                    _gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.NewQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";

                    grdViewGeneral.ClearGrouping();
                    grdViewGeneral.ClearColumnsFilter();
                    grdViewGeneral.ClearSorting();
                    _gridControlEnum = GridControlEnum.None;
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

            grdViewGeneral.Columns.Clear();
            grdViewGeneral.GroupSummary.Clear();
            grdGeneral.DataSource = null;

            _controller.GetOpenQuotes();
            if (!_controller.ListOpenQuotes.Any()) return;

            grdGeneral.DataSource = _controller.ListOpenQuotes;

            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";


            // Make the group footers always visible
            grdViewGeneral.GroupFooterShowMode = GroupFooterShowMode.VisibleAlways;

            // Create and setup the first summary item
            var item = new GridGroupSummaryItem();
            item.FieldName = "TotalQuotedSales";
            item.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            item.DisplayFormat = " - Total Quoted Sales:  {0:c2}";
            item.ShowInGroupColumnFooter = gridView1.Columns["TotalQuotedSales"];
            grdViewGeneral.GroupSummary.Add(item);

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";
            if (File.Exists(filePath)) grdGeneral.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetNewQuotes()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdViewGeneral.Columns.Clear();
            grdViewGeneral.GroupSummary.Clear();
            grdGeneral.DataSource = null;

            _controller.GetNewQuotes();
            if (!_controller.ListNewQuotes.Any()) return;

            grdGeneral.DataSource = _controller.ListNewQuotes;

            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";

            // Make the group footers always visible
            grdViewGeneral.GroupFooterShowMode = GroupFooterShowMode.VisibleAlways;

            // Create and setup the first summary item
            var item = new GridGroupSummaryItem();
            item.FieldName = "TotalQuotedSales";
            item.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            item.DisplayFormat = " - Total Quoted Sales:  {0:c2}";
            item.ShowInGroupColumnFooter = gridView1.Columns["TotalQuotedSales"];
            grdViewGeneral.GroupSummary.Add(item);

            //// Create and setup the second summary item
            //GridGroupSummaryItem item1 = new GridGroupSummaryItem();
            //item1.FieldName = "UnitPrice";
            //item1.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            //item1.DisplayFormat = "Total {0:c2}";
            //item1.ShowInGroupColumnFooter = view.Columns["UnitPrice"];
            //view.GroupSummary.Add(item1);


            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";
            if (File.Exists(filePath))
            {
                try
                {
                    grdGeneral.MainView.RestoreLayoutFromXml(filePath);
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

            grdViewActivity.Columns.Clear();
            grdActivity.DataSource = null;
            
            _controller.GetSalesActivityHistory();
            if (!_controller.ListSalesPersonActivity.Any()) return;

            grdActivity.DataSource = _controller.ListSalesPersonActivity;

            grdViewActivity.OptionsBehavior.Editable = false;
            grdViewActivity.Columns["SalesPersonCode"].Visible = grdViewActivity.Columns["RowId"].Visible = grdViewActivity.Columns["CombinedLightingStudyId"].Visible = false;
            grdViewActivity.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetTopLeads()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdViewActivity.Columns.Clear();
            grdActivity.DataSource = null;

            _controller.GetTopLeads();
            if (!_controller.ListTopLeads.Any()) return;

            grdActivity.DataSource = _controller.ListTopLeads;

            grdViewActivity.OptionsBehavior.Editable = false;
            grdViewActivity.Columns["RowId"].Visible = grdViewActivity.Columns["CombinedLightingStudyId"].Visible = false;
            grdViewActivity.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["PeakVolumeSalesEstimate"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["PeakVolumeSalesEstimate"].DisplayFormat.FormatString = "c2";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);

            //view.OptionsBehavior.Editable = false;

            Cursor.Current = Cursors.Default;
        }

        #endregion


        #region Chart Query Methods

        private void ShowNumberOfProgramsLaunchingByCustomer()
        {
            string error;

            ccGeneral.DataSource = null;
            ccGeneral.Series.Clear();
            ccGeneral.Titles.Clear();
            _controller.GetProgramsLaunchingByCustomer(out error);
            if (error != "")
            {
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return;
            }
            ccGeneral.DataSource = _controller.ProgramsLaunchingByCustomerList;

            ccGeneral.CustomDrawCrosshair += _ccGeneral_CustomDrawCrosshair;

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
            ccGeneral.Series.Add(series1);
            ccGeneral.Series.Add(series2);

            ccGeneral.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = ccGeneral.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;

            // Allow commas
            ccGeneral.SeriesTemplate.Label.PointOptions.ValueNumericOptions.Format = NumericFormat.Number;

            // Add title to chart
            var chartTitle = new ChartTitle();
            chartTitle.Text = "Number of Programs Launching from 2017-2019 by Customer";
            ccGeneral.Titles.Add(chartTitle);
        }

        private void ShowPeakVolumeOfProgramsLaunching()
        {
            string error;

            ccGeneral.DataSource = null;
            ccGeneral.Series.Clear();
            ccGeneral.Titles.Clear();
            _controller.GetPeakVolumeOfProgramsLaunchingByCustomer(out error);
            if (error != "")
            {
                _messageBox.Message = error;
                _messageBox.ShowDialog();
                return;
            }
            ccGeneral.DataSource = _controller.PeakVolumeOfProgramsLaunchingList;

            ccGeneral.CustomDrawCrosshair += _ccGeneral_CustomDrawCrosshair;

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
            ccGeneral.Series.Add(series1);
            ccGeneral.Series.Add(series2);
            ccGeneral.Series.Add(series3);
            ccGeneral.Series.Add(series4);

            ccGeneral.Legend.Visible = false;
           
            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = ccGeneral.Diagram as XYDiagram;
            diagram.AxisY.Label.NumericOptions.Format = NumericFormat.Number;
            diagram.AxisY.Label.NumericOptions.Precision = 0;

            // Add title to chart
            var chartTitle = new ChartTitle();
            chartTitle.Text = "Peak Volume of Programs Launching from 2017-2019 by Customer";
            ccGeneral.Titles.Add(chartTitle);
        }

        void _ccGeneral_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
        {
            foreach (CrosshairElement element in e.CrosshairElements)
            {
                element.LabelElement.TextColor = Color.Black;
                element.LabelElement.Font = new Font("Tahoma", 10f, FontStyle.Bold);
                element.LabelElement.MarkerSize = new Size(10, 10);
            }
        }

        private void ShowPeakVolumeOfProgramsLaunchingByCustomerByYear(int year)
        {
            string error;
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";
            string customer = cbxReportCustomer.Text;

            ccLaunching.DataSource = null;
            ccLaunching.Series.Clear();
            ccLaunching.Titles.Clear();

            ccLaunching.CustomDrawCrosshair += _ccLaunching_CustomDrawCrosshair;
            ccLaunching.ObjectSelected += _ccLaunching_ObjectSelected;

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
                    ccLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsLaunching2018ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    ccLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsLaunching2019ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    ccLaunching.DataSource = _controller.PeakVolumeOfProgramsLaunching2019List;
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
            ccLaunching.Series.Add(series1);
            ccLaunching.Series.Add(series2);
            ccLaunching.Series.Add(series3);
            ccLaunching.Series.Add(series4);
            ccLaunching.Series.Add(series5);

            ccLaunching.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = ccLaunching.Diagram as XYDiagram;
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
            ccLaunching.Titles.Add(chartTitle);
        }

        void _ccLaunching_ObjectSelected(object sender, HotTrackEventArgs e)
        {
            // Testing ...
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

        void _ccLaunching_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
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
            string error;
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";
            string customer = cbxReportCustomer.Text;

            ccClosing.DataSource = null;
            ccClosing.Series.Clear();
            ccClosing.Titles.Clear();

            ccClosing.CustomDrawCrosshair += _ccClosing_CustomDrawCrosshair;

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
                    ccClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2017List;
                    break;
                case 2018:
                    _controller.GetPeakVolumeOfProgramsClosing2018ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    ccClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2018List;
                    break;
                case 2019:
                    _controller.GetPeakVolumeOfProgramsClosing2019ByCustomer(region, customer, out error);
                    if (error != "")
                    {
                        _messageBox.Message = error;
                        _messageBox.ShowDialog();
                        return;
                    }
                    ccClosing.DataSource = _controller.PeakVolumeOfProgramsClosing2019List;
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
            ccClosing.Series.Add(series1);
            ccClosing.Series.Add(series2);
            ccClosing.Series.Add(series3);
            ccClosing.Series.Add(series4);
            ccClosing.Series.Add(series5);


            ccClosing.Legend.Visible = false;

            // Cast the chart's diagram to the XYDiagram type, to access its axes.
            XYDiagram diagram = ccClosing.Diagram as XYDiagram;
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
            ccClosing.Titles.Add(chartTitle);
        }

        void _ccClosing_CustomDrawCrosshair(object sender, CustomDrawCrosshairEventArgs e)
        {
            foreach (CrosshairElement element in e.CrosshairElements)
            {
                element.LabelElement.TextColor = Color.Black;
                element.LabelElement.Font = new Font("Tahoma", 10f, FontStyle.Bold);
                element.LabelElement.MarkerSize = new Size(10, 10);
            }
        }
        
        #endregion


        #region Dashboard Methods

        private void GetDashboardCustomerList()
        {
            var custList = new List<string>();
            custList.Add("");
            custList.Add("ADAC");
            custList.Add("Flex-N-Gate");
            custList.Add("Hella");
            custList.Add("Magna");
            custList.Add("Magneti Marelli (ALC)");
            custList.Add("Koito (NAL)");
            custList.Add("Koito Tayih (NAL)");
            custList.Add("Shanghai Koito (NAL)");
            custList.Add("SL Corporation");
            custList.Add("Stanley");
            custList.Add("Valeo");
            custList.Add("Varroc");

            _isDatabinding = true;
            cbxReportCustomer.DataSource = null;
            cbxReportCustomer.DataSource = custList;
            _isDatabinding = false;
        }

        private void GetCustomersList()
        {
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";

            int result = _controller.GetAllLightingStudyCustomers(region);

            if (result == 0) return;
            _isDatabinding = true;
            cbxReportCustomer.DataSource = null;
            cbxReportCustomer.DataSource = _controller.CustomersList;
            cbxReportCustomer.DisplayMember = "Customer";
            cbxReportCustomer.Text = "";
            _isDatabinding = false;
        }
        
        private void GetSalesForecastData()
        {
            string customer = cbxReportCustomer.Text.Trim();

            grdDashboard1.DataSource = null;
            _controller.GetSalesForecastDataByCustomer(customer);
            if (!_controller.DashboardSalesForecastList.Any()) return;

            grdDashboard1.DataSource = _controller.DashboardSalesForecastList;

            grdViewDashboard1.OptionsBehavior.Editable = false;
            grdViewDashboard1.Columns["Sales2016"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2016"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2016"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2016"].Caption = "2016";
            grdViewDashboard1.Columns["Sales2017"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2017"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2017"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2017"].Caption = "2017";
            grdViewDashboard1.Columns["Sales2018"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2018"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2018"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2018"].Caption = "2018";
            grdViewDashboard1.Columns["Sales2019"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2019"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2019"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2019"].Caption = "2019";
            grdViewDashboard1.Columns["Sales2020"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2020"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2020"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2020"].Caption = "2020";
            grdViewDashboard1.Columns["Sales2021"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2021"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2021"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2021"].Caption = "2021";
            grdViewDashboard1.Columns["Sales2022"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard1.Columns["Sales2022"].DisplayFormat.FormatString = "c2";
            grdViewDashboard1.Columns["Sales2022"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard1.Columns["Sales2022"].Caption = "2022";

            // Make the group footers always visible
            grdViewDashboard1.GroupFooterShowMode = GroupFooterShowMode.VisibleAlways;

            //// Create and setup the first summary item
            //var item = new GridGroupSummaryItem();
            //item.FieldName = "";
            //item.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            //_gridView.GroupSummary.Add(item);

            //// Restore saved grid settings if they exist
            //string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";
            //if (File.Exists(filePath)) _gridControlActivity.MainView.RestoreLayoutFromXml(filePath);
        }

        private void GetRecentQuotesByCustomer()
        {
            string customer = cbxReportCustomer.Text.Trim();

            grdDashboard2.DataSource = null;
            _controller.GetNewQuotesByCustomer(customer);
            if (!_controller.DashboardNewQuotesByCustomerList.Any()) return;

            grdDashboard2.DataSource = _controller.DashboardNewQuotesByCustomerList;

            grdViewDashboard2.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard2.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";

            // Make the group footers always visible
            grdViewDashboard2.OptionsView.GroupFooterShowMode = GroupFooterShowMode.VisibleAlways;

            // Create and setup the first summary item
            var item = new GridGroupSummaryItem();
            item.FieldName = "TotalQuotedSales";
            item.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            item.DisplayFormat = "Total:  {0:c2}";
            item.ShowInGroupColumnFooter = grdViewDashboard2.Columns["TotalQuotedSales"];
            grdViewDashboard2.GroupSummary.Add(item);
        }

        private void GetSalesActivityHistoryByCustomer()
        {
            string customer = cbxReportCustomer.Text.Trim();

            grdDashboard3.DataSource = null;
            _controller.GetSalesActivityHistoryByCustomer(customer);
            if (!_controller.DashboardSalesPersonActivityByCustomerList.Any()) return;

            grdDashboard3.DataSource = _controller.DashboardSalesPersonActivityByCustomerList;

            grdViewDashboard3.OptionsBehavior.Editable = false;
            grdViewDashboard3.Columns["SalesPersonCode"].Visible = grdViewDashboard3.Columns["RowId"].Visible = grdViewDashboard3.Columns["CombinedLightingId"].Visible = false;
            grdViewDashboard3.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard3.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);
        }

        private void GetTopLeadsByCustomer()
        {
            string customer = cbxReportCustomer.Text.Trim();

            grdDashboard4.DataSource = null;
            _controller.GetTopLeadsByCustomer(customer);
            if (!_controller.DashboardTopLeadsByCustomerList.Any()) return;

            grdDashboard4.DataSource = _controller.DashboardTopLeadsByCustomerList;

            grdViewDashboard4.OptionsBehavior.Editable = false;
            grdViewDashboard4.Columns["RowId"].Visible = grdViewDashboard4.Columns["CombinedLightingId"].Visible = false;
            grdViewDashboard4.Columns["PeakVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["PeakVolume"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["PeakVolumeSalesEstimate"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["PeakVolumeSalesEstimate"].DisplayFormat.FormatString = "c2";

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);
        }

        #endregion


        
        
        private void ControlScreenState(FormStateEnum state)
        {
            switch (state)
            {
                case FormStateEnum.DashboardIntro:
                    IsDashboardIntro = true;
                    _isDashboardFull = false;

                    tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = ccGeneral.Visible = false;
                    wbDashboard.Visible = true;
                    wbDashboard.Dock = DockStyle.Fill;
                    wbDashboard.Navigate("http://evision/empireweb/SalesForecastSummarybyCustomer.aspx");

                    flpRadioButtons.Visible = mesBtnGo.Visible = mesBtnExportChart.Visible = false;
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesClearGridSettings.Visible = true;
                    lblInstructions.Text = "";

                    GetDashboardCustomerList();
                    break;
                case FormStateEnum.DashboardFull:
                    Cursor.Current = Cursors.WaitCursor;

                    IsDashboardIntro = false;
                    _isDashboardFull = true;

                    wbDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = ccGeneral.Visible = false;
                    tlpDashboard.Visible = true;
                    tlpDashboard.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = mesBtnGo.Visible = mesBtnExportChart.Visible = mesClearGridSettings.Visible = false;
                    lblSelectCustomer.Visible = cbxReportCustomer.Visible = true;
                    lblInstructions.Text = "";

                    // Row 1:  Grid - customer's sales forecasts (2016-2022)
                    GetSalesForecastData();

                    // Row 2:  Grid - recently quoted for this customer
                    GetRecentQuotesByCustomer();

                    // Row 3:  Grid - recent sales activity for this customer
                    GetSalesActivityHistoryByCustomer();

                    // Row 4:  Grid - top 10 sales leads by "estimated yearly sales"
                    GetTopLeadsByCustomer();

                    Cursor.Current = Cursors.Default;
                    break;
                case FormStateEnum.ChartSingle:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = false;
                    ccGeneral.Visible = true;
                    ccGeneral.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnGo.Visible = mesClearGridSettings.Visible = false;
                    mesBtnExportChart.Visible = true;
                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.LaunchingClosingLinkClicked:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = ccGeneral.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = false;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnGo.Visible = true;
                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.ChartDual:
                    tlpSplitCharts.Visible = true;
                    _isDashboardFull = false;

                    tlpSplitCharts.Dock = DockStyle.Fill;

                    mesBtnExportChart.Visible = false;
                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.ActivityGrid:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdGeneral.Visible = ccGeneral.Visible = false;
                    grdActivity.Visible = true;
                    grdActivity.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnGo.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = true;
                    lblInstructions.Text = "Double-click a row to see all activity history for a sales lead.";
                    break;    
                case FormStateEnum.QuoteGrid:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = ccGeneral.Visible = false;
                    grdGeneral.Visible = true;
                    grdGeneral.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnGo.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = true;
                    lblInstructions.Text = "";
                    break;
            }
        }


    }
}
