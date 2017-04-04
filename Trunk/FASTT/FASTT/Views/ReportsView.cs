using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Windows.Forms;
using DevExpress.Utils;
using DevExpress.XtraCharts;
using DevExpress.XtraGrid;
using DevExpress.XtraGrid.Views.Base;
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
        private bool _restoreGridSettings;

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
            string customer = cbxReportCustomer.Text.Trim();
            if (customer == "") return;

            // Both the hitlist grid and the launching/closing charts use the filter header, so determine which to show
            if (_gridControlEnum == GridControlEnum.Hitlist)
            {
                GetHitlist();
                ControlScreenState(FormStateEnum.ActivityGridHitlist);
            }
            else
            {
                ControlScreenState(FormStateEnum.ChartDual);
                ShowLaunchingClosingReport(_reportName);
            }
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
            if (_isDatabinding) return;

            string customer = cbxReportCustomer.Text.Trim();
            if (customer == "") return;

            if (_isDashboardIntro || _isDashboardFull)
            {
                ControlScreenState(FormStateEnum.DashboardFull);
                return;
            }
            if (_gridControlEnum == GridControlEnum.Hitlist)
            {
                string fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_Hitlist.xml";
                //ClearGridColumnWidths(fileName);

                // Hit list has a SOP filter option that needs to be populated
                GetHitlistCustomerSops();
            }
            mesBtnGo.Visible = (cbxReportCustomer.Text.Trim() != "");
        }

        #endregion


        #region Grid RowCellStyle Events

        private void grdViewActivity_RowCellStyle(object sender, RowCellStyleEventArgs e)
        {
            if (e.Column.FieldName == "QuoteNumber" || e.Column.FieldName == "EAU" || e.Column.FieldName == "EEIPartNumber"
                || e.Column.FieldName == "ApplicationName" || e.Column.FieldName == "SalesInitials" || e.Column.FieldName == "QuotePrice"
                || e.Column.FieldName == "Awarded" || e.Column.FieldName == "QuoteStatus" || e.Column.FieldName == "StraightMaterialCost"
                || e.Column.FieldName == "TotalQuotedSales")
            {
                e.Appearance.ForeColor = Color.PaleGreen;
            }
        }

        private void grdViewDashboard4_RowCellStyle(object sender, RowCellStyleEventArgs e)
        {
            if (e.Column.FieldName == "QuoteNumber" || e.Column.FieldName == "EAU" || e.Column.FieldName == "EEIPartNumber"
                || e.Column.FieldName == "ApplicationName" || e.Column.FieldName == "SalesInitials" || e.Column.FieldName == "QuotePrice" 
                || e.Column.FieldName == "Awarded" || e.Column.FieldName == "QuoteStatus" || e.Column.FieldName == "StraightMaterialCost"
                || e.Column.FieldName == "TotalQuotedSales")
            {
                e.Appearance.ForeColor = Color.PaleGreen;
            }
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
                    lblSelectSop.Visible = cbxSOP.Visible = false;
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
                    lblSelectSop.Visible = cbxSOP.Visible = false;
                    lblInstructions.Text = "";

                    // Row 1:  Grid - customer's sales forecasts (2016-2022)
                    GetSalesForecastData();

                    // Row 2:  Grid - recently quoted for this customer
                    GetRecentQuotesByCustomer();

                    // Row 3:  Grid - recent sales activity for this customer
                    GetSalesActivityHistoryByCustomer();

                    // Row 4:  Grid - sales leads (Hitlist)
                    GetHitlistMsfByCustomer();

                    Cursor.Current = Cursors.Default;
                    break;
                case FormStateEnum.ChartSingle:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = false;
                    ccGeneral.Visible = true;
                    ccGeneral.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = lblSelectSop.Visible = 
                        cbxSOP.Visible = mesBtnGo.Visible = mesClearGridSettings.Visible = false;
                    mesBtnExportChart.Visible = true;
                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.LaunchingClosingLinkClicked:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = grdGeneral.Visible = ccGeneral.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = false;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = mesBtnGo.Visible = true;
                    lblSelectSop.Visible = cbxSOP.Visible = false;
                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.ChartDual:
                    tlpSplitCharts.Visible = true;
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

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = lblSelectSop.Visible = cbxSOP.Visible = mesBtnGo.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = true;
                    lblInstructions.Text = "Double-click a row to see all activity history for a sales lead.";
                    break;
                case FormStateEnum.HitlistLinkClicked:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdGeneral.Visible = grdActivity.Visible = ccGeneral.Visible = false;
                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = lblSelectSop.Visible = cbxSOP.Visible = mesBtnGo.Visible = true;

                    rbtnNorthAmerica.Checked = true;
                    cbxReportCustomer.Text = "";
                    cbxSOP.DataSource = null;

                    lblInstructions.Text = "";
                    break;
                case FormStateEnum.ActivityGridHitlist:
                    grdActivity.Visible = true;
                    grdActivity.Dock = DockStyle.Fill;

                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = true;
                    //lblInstructions.Text = "Double-click a row to see all activity history for a sales lead.";
                    break;
                case FormStateEnum.QuoteGrid:
                    IsDashboardIntro = false;
                    _isDashboardFull = false;

                    wbDashboard.Visible = tlpDashboard.Visible = tlpSplitCharts.Visible = grdActivity.Visible = ccGeneral.Visible = false;
                    grdGeneral.Visible = true;
                    grdGeneral.Dock = DockStyle.Fill;

                    flpRadioButtons.Visible = lblSelectCustomer.Visible = cbxReportCustomer.Visible = lblSelectSop.Visible = cbxSOP.Visible = mesBtnGo.Visible = false;
                    mesBtnExportChart.Visible = mesClearGridSettings.Visible = true;
                    lblInstructions.Text = "";
                    break;
            }
        }

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
            else if (_gridControlEnum == GridControlEnum.Hitlist)
            {
                grdActivity.DataSource = null; 
                GetHitlistCustomers();
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

            int hitListId = (grdViewActivity.GetRowCellValue(r, "ID") != null) ? Convert.ToInt32(grdViewActivity.GetRowCellValue(r, "ID")) : 0;
            int salesLeadId = (grdViewActivity.GetRowCellValue(r, "SalesLeadID") != null) ? Convert.ToInt32(grdViewActivity.GetRowCellValue(r, "SalesLeadID")) : 0;
            string customer = (grdViewActivity.GetRowCellValue(r, "Customer") != null) ? grdViewActivity.GetRowCellValue(r, "Customer").ToString() : "";
            string program = (grdViewActivity.GetRowCellValue(r, "Program") != null) ? grdViewActivity.GetRowCellValue(r, "Program").ToString() : "";
            string application = (grdViewActivity.GetRowCellValue(r, "Application") != null) ? grdViewActivity.GetRowCellValue(r, "Application").ToString() : "";
            string sop = (grdViewActivity.GetRowCellValue(r, "SOP") != null) ? grdViewActivity.GetRowCellValue(r, "SOP").ToString() : "";
            string eop = (grdViewActivity.GetRowCellValue(r, "EOP") != null) ? grdViewActivity.GetRowCellValue(r, "EOP").ToString() : "";
            string volume = (grdViewActivity.GetRowCellValue(r, "PeakYearlyVolume") != null) ? grdViewActivity.GetRowCellValue(r, "PeakYearlyVolume").ToString() : "";

            if (salesLeadId == 0)
            {
                _messageBox.Message = "No sales activity found.";
                _messageBox.ShowDialog();
                return;
            }

            var form = new SalesLeadsHistoryView
            {
                OperatorCode = OperatorCode,
                SalesLeadId = salesLeadId,
                HitlistId = hitListId,
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
                _restoreGridSettings = false;
                GetSalesActivityHistory();
            }
            else if (_currentActivityHistoryReport == "HitList")
            {
                _restoreGridSettings = false;
                GetHitlist();
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
                case GridControlEnum.Hitlist:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_Hitlist.xml";
                    try
                    {
                        grdActivity.MainView.SaveLayoutToXml(fileName);

                        //ClearGridColumnWidths(fileName);
                    }
                    catch (Exception ex)
                    {
                        _messageBox.Message = "Failed to save grid settings.  " + ex.Message;
                        _messageBox.ShowDialog();
                    }
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
                case GridControlEnum.NewQuotesSevenDays:
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
                case GridControlEnum.NewQuotesSixtyDays:
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

        //private void ClearGridColumnWidths(string fileName)
        //{
        //    var doc = new XmlDocument();
        //    doc.Load(fileName);
        //    XmlElement root = doc.DocumentElement;
        //    XmlNodeList nodes = root.SelectNodes("property");
        //    foreach (XmlNode node in nodes)
        //    {
        //        if (node.ChildNodes.Count < 1) continue;
        //        foreach (XmlNode childNode1 in node.ChildNodes)
        //        {
        //            if (childNode1.ChildNodes.Count < 1) continue;
        //            foreach (XmlNode childNode2 in childNode1.ChildNodes)
        //            {
        //                if (childNode2.Attributes == null) continue;
        //                if (childNode2.Attributes[0].Value == "Width")
        //                {
        //                    childNode2.InnerText = "";
        //                }
        //            }
        //        }
        //    }
        //    doc.Save(fileName);
        //}

        private void GetHitlistCustomers()
        {
            Cursor.Current = Cursors.WaitCursor;

            cbxSOP.DataSource = null;
            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";

            int result = _controller.GetHitListCustomers(region);
            if (result == 0) return;

            _isDatabinding = true;
            cbxReportCustomer.DataSource = null;
            cbxReportCustomer.DataSource = _controller.HitlistCustomersList;
            cbxReportCustomer.DisplayMember = "Customer";
            cbxReportCustomer.Text = "";
            _isDatabinding = false;

            //ControlScreenState(FormStateEnum.LaunchingClosingLinkClicked);

            Cursor.Current = Cursors.Default;
        }

        private void GetHitlistCustomerSops()
        {
            Cursor.Current = Cursors.WaitCursor;

            cbxSOP.DataSource = null;
            string customer = cbxReportCustomer.Text.Trim();

            int result = _controller.GetHitListCustomerSops(customer);
            if (result == 0) return;

            _isDatabinding = true;
            cbxSOP.DataSource = null;
            cbxSOP.DataSource = _controller.HitlistCustomerSopsList;
            cbxSOP.DisplayMember = "SOPYear";
            cbxSOP.Text = "";
            _isDatabinding = false;

            Cursor.Current = Cursors.Default;
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
                case "Sales Hit List":
                    ControlScreenState(FormStateEnum.HitlistLinkClicked);

                    _restoreGridSettings = true;
                    GetHitlistCustomers();

                    _currentActivityHistoryReport = "HitList";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.Hitlist;
                    break;
                case "Activity History Last 7 Days":
                    ControlScreenState(FormStateEnum.ActivityGrid);

                    _restoreGridSettings = true;
                    GetSalesActivityHistory();

                    _currentActivityHistoryReport = "History";
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.ActivityHistory;
                    break;
                case "Top Leads by Volume":
                    //ControlScreenState(FormStateEnum.ActivityGrid);

                    //GetTopLeads();

                    //_currentActivityHistoryReport = "TopLeads";
                    //_isChart = false;
                    //_gridControlEnum = GridControlEnum.TopLeads;
                    //break;
                case "All Completed Quotes":
                    ControlScreenState(FormStateEnum.QuoteGrid);

                    _restoreGridSettings = true;
                    GetOpenQuotes();
                    
                    _isChart = false;
                    _gridControlEnum = GridControlEnum.OpenQuotes;
                    break;
                case "Quotes Opened in the Last 7 Days":
                    ControlScreenState(FormStateEnum.QuoteGrid);

                    _restoreGridSettings = true;
                    GetNewQuotes(7);

                    _isChart = false;
                    _gridControlEnum = GridControlEnum.NewQuotesSevenDays;
                    break;
                case "Quotes Opened in the Last 60 Days":
                    ControlScreenState(FormStateEnum.QuoteGrid);

                    _restoreGridSettings = true;
                    GetNewQuotes(60);

                    _isChart = false;
                    _gridControlEnum = GridControlEnum.NewQuotesSixtyDays;
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
                case GridControlEnum.Hitlist:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_Hitlist.xml";

                    grdViewActivity.ClearGrouping();
                    grdViewActivity.ClearColumnsFilter();
                    grdViewActivity.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;

                    _restoreGridSettings = false;
                    GetHitlist();
                    break;
                case GridControlEnum.ActivityHistory:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";

                    grdViewActivity.ClearGrouping();
                    grdViewActivity.ClearColumnsFilter();
                    grdViewActivity.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;

                    _restoreGridSettings = false;
                    GetSalesActivityHistory();
                    break;
                case GridControlEnum.TopLeads:
                    //fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_TopLeads.xml";

                    //grdViewActivity.ClearGrouping();
                    //grdViewActivity.ClearColumnsFilter();
                    //grdViewActivity.ClearSorting();
                    ////_gridControlEnum = GridControlEnum.None;
                    break;
                case GridControlEnum.OpenQuotes:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";

                    grdViewGeneral.ClearGrouping();
                    grdViewGeneral.ClearColumnsFilter();
                    grdViewGeneral.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;

                    _restoreGridSettings = false;
                    GetOpenQuotes();
                    break;
                case GridControlEnum.NewQuotesSevenDays:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";

                    grdViewGeneral.ClearGrouping();
                    grdViewGeneral.ClearColumnsFilter();
                    grdViewGeneral.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;

                    _restoreGridSettings = false;
                    GetNewQuotes(7);
                    break;
                case GridControlEnum.NewQuotesSixtyDays:
                    fileName = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_NewQuotes.xml";

                    grdViewGeneral.ClearGrouping();
                    grdViewGeneral.ClearColumnsFilter();
                    grdViewGeneral.ClearSorting();
                    //_gridControlEnum = GridControlEnum.None;

                    _restoreGridSettings = false;
                    GetNewQuotes(60);
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

            grdViewGeneral.OptionsView.ColumnAutoWidth = false;
            grdViewGeneral.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewGeneral.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c0";
            grdViewGeneral.Columns["TotalQuotedSales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["Eau"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["Eau"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["Eau"].DisplayFormat.FormatString = "n0";
            grdViewGeneral.Columns["QuotePrice"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["QuotePrice"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["QuotePrice"].DisplayFormat.FormatString = "n2";

            grdViewGeneral.Columns["Customer"].Width = 100;
            grdViewGeneral.Columns["Program"].Width = 100;
            grdViewGeneral.Columns["Status"].Width = 90;
            grdViewGeneral.Columns["ApplicationName"].Width = 200;
            grdViewGeneral.Columns["SalesInitials"].Width = 80;
            grdViewGeneral.Columns["Sop"].Width = 80;
            grdViewGeneral.Columns["Eop"].Width = 80;
            grdViewGeneral.Columns["EeiPartNumber"].Width = 130;
            grdViewGeneral.Columns["TotalQuotedSales"].Width = 120;
            grdViewGeneral.Columns["QuotePrice"].Width = 80;
            grdViewGeneral.Columns["QuotePricingDate"].Width = 120;
            grdViewGeneral.Columns["Awarded"].Width = 60;
            grdViewGeneral.Columns["Eau"].Width = 70;
            grdViewGeneral.Columns["Notes"].Width = 300;
            grdViewGeneral.Columns["MaterialPercentage"].Width = 120;


            // Make the group footers always visible
            grdViewGeneral.GroupFooterShowMode = GroupFooterShowMode.VisibleAlways;

            // Create and setup the first summary item
            var item = new GridGroupSummaryItem();
            item.FieldName = "TotalQuotedSales";
            item.SummaryType = DevExpress.Data.SummaryItemType.Sum;
            item.DisplayFormat = " - Total Quoted Sales:  {0:c2}";
            item.ShowInGroupColumnFooter = gridView1.Columns["TotalQuotedSales"];
            grdViewGeneral.GroupSummary.Add(item);

            if (!_restoreGridSettings)
            {
                Cursor.Current = Cursors.Default;
                return;
            }

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_OpenQuotes.xml";
            if (File.Exists(filePath)) grdGeneral.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetNewQuotes(int numberOfDays)
        {
            Cursor.Current = Cursors.WaitCursor;

            grdViewGeneral.Columns.Clear();
            grdViewGeneral.GroupSummary.Clear();
            grdGeneral.DataSource = null;

            _controller.GetNewQuotes(numberOfDays);
            if (!_controller.ListNewQuotes.Any()) return;

            grdGeneral.DataSource = _controller.ListNewQuotes;

            grdViewGeneral.OptionsView.ColumnAutoWidth = false;
            grdViewGeneral.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewGeneral.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c0";
            grdViewGeneral.Columns["TotalQuotedSales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["Eau"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["Eau"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["Eau"].DisplayFormat.FormatString = "n0";
            grdViewGeneral.Columns["QuotePrice"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewGeneral.Columns["QuotePrice"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewGeneral.Columns["QuotePrice"].DisplayFormat.FormatString = "n2";

            grdViewGeneral.Columns["Customer"].Width = 100;
            grdViewGeneral.Columns["Program"].Width = 100;
            grdViewGeneral.Columns["QuoteStatus"].Width = 90;
            grdViewGeneral.Columns["ApplicationName"].Width = 200;
            grdViewGeneral.Columns["SalesInitials"].Width = 80;
            grdViewGeneral.Columns["Sop"].Width = 80;
            grdViewGeneral.Columns["Eop"].Width = 80;
            grdViewGeneral.Columns["EeiPartNumber"].Width = 130;
            grdViewGeneral.Columns["TotalQuotedSales"].Width = 120;
            grdViewGeneral.Columns["QuotePrice"].Width = 80;
            grdViewGeneral.Columns["QuotePricingDate"].Width = 120;
            grdViewGeneral.Columns["Awarded"].Width = 60;
            grdViewGeneral.Columns["Eau"].Width = 70;
            grdViewGeneral.Columns["Notes"].Width = 300;
            grdViewGeneral.Columns["MaterialPercentage"].Width = 120;


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

            if (!_restoreGridSettings)
            {
                Cursor.Current = Cursors.Default;
                return;
            }

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

            grdViewActivity.OptionsView.ColumnAutoWidth = false;
            grdViewActivity.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewActivity.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewActivity.OptionsBehavior.Editable = false;
            grdViewActivity.Columns["ID"].Visible = grdViewActivity.Columns["SalesLeadID"].Visible = false;

            grdViewActivity.Columns["EstYearlySales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["EstYearlySales"].DisplayFormat.FormatString = "c0";
            grdViewActivity.Columns["Price"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Price"].DisplayFormat.FormatString = "c2";
            grdViewActivity.Columns["PeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["PeakYearlyVolume"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["AwardedVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["AwardedVolume"].DisplayFormat.FormatString = "n0";

            grdViewActivity.Columns["EstYearlySales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Price"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["PeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["SOPYear"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["AwardedVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;

            grdViewActivity.Columns["Customer"].Width = 120;
            grdViewActivity.Columns["Program"].Width = 100;
            grdViewActivity.Columns["EstYearlySales"].Width = 120;
            grdViewActivity.Columns["PeakYearlyVolume"].Width = 130;
            grdViewActivity.Columns["SOPYear"].Width = 70;
            grdViewActivity.Columns["Application"].Width = 200;
            grdViewActivity.Columns["Region"].Width = 100;
            grdViewActivity.Columns["OEM"].Width = 100;
            grdViewActivity.Columns["SOP"].Width = 80;
            grdViewActivity.Columns["EOP"].Width = 80;
            grdViewActivity.Columns["Type"].Width = 120;
            grdViewActivity.Columns["Nameplate"].Width = 110;
            grdViewActivity.Columns["Price"].Width = 60;
            grdViewActivity.Columns["AwardedVolume"].Width = 120;
            grdViewActivity.Columns["Component"].Width = 90;
            grdViewActivity.Columns["LED_Harness"].Width = 90;
            grdViewActivity.Columns["Status"].Width = 80;
            grdViewActivity.Columns["ActivityDate"].Width = 150;
            grdViewActivity.Columns["Activity"].Width = 100;
            grdViewActivity.Columns["MeetingLocation"].Width = 120;
            grdViewActivity.Columns["ContactName"].Width = 120;
            grdViewActivity.Columns["ContactPhoneNumber"].Width = 150;
            grdViewActivity.Columns["ContactEmailAddress"].Width = 150;
            grdViewActivity.Columns["Duration"].Width = 100;
            grdViewActivity.Columns["Notes"].Width = 220;
            grdViewActivity.Columns["LastSalesPerson"].Width = 140;


            if (!_restoreGridSettings)
            {
                Cursor.Current = Cursors.Default;
                return;
            }

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_ActivityHistory.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);

            Cursor.Current = Cursors.Default;
        }

        private void GetHitlist()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdViewActivity.Columns.Clear();
            grdActivity.DataSource = null;

            string region = (rbtnNorthAmerica.Checked) ? "North America" : "China";
            string customer = cbxReportCustomer.Text.Trim();
            string sop = cbxSOP.Text.Trim();
            int? iSop = null;
            if (sop != "") iSop = Convert.ToInt16(sop);
            
            _controller.GetHitlist(region, customer, iSop);
            if (!_controller.ListHitlistMsf.Any()) return;

            grdActivity.DataSource = _controller.ListHitlistMsf;

            grdViewActivity.OptionsView.ColumnAutoWidth = false;
            grdViewActivity.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewActivity.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewActivity.OptionsBehavior.Editable = false;
            grdViewActivity.Columns["ID"].Visible = false;
            grdViewActivity.Columns["SalesLeadID"].Visible = false;
            grdViewActivity.Columns["EstYearlySales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["EstYearlySales"].DisplayFormat.FormatString = "c0";
            grdViewActivity.Columns["Price"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Price"].DisplayFormat.FormatString = "c2";
            grdViewActivity.Columns["PeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["PeakYearlyVolume"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2017"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2017"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2018"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2018"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2019"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2019"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2020"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2020"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2021"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2021"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["Volume2022"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["Volume2022"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["EAU"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["EAU"].DisplayFormat.FormatString = "n0";
            grdViewActivity.Columns["QuotePrice"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["QuotePrice"].DisplayFormat.FormatString = "c2";
            grdViewActivity.Columns["StraightMaterialCost"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["StraightMaterialCost"].DisplayFormat.FormatString = "c2";
            grdViewActivity.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";
            grdViewActivity.Columns["SalesForecastPeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewActivity.Columns["SalesForecastPeakYearlyVolume"].DisplayFormat.FormatString = "c0";

            grdViewActivity.Columns["EstYearlySales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Price"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["PeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["SOPYear"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2017"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2018"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2019"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2020"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2021"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["Volume2022"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["EAU"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["QuotePrice"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["StraightMaterialCost"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["TotalQuotedSales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewActivity.Columns["SalesForecastPeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;

            //grdViewActivity.Columns["Customer"].BestFit();
            //grdViewActivity.Columns["Program"].BestFit();
            //grdViewActivity.Columns["EstYearlySales"].BestFit();
            //grdViewActivity.Columns["PeakYearlyVolume"].BestFit();
            //grdViewActivity.Columns["SOPYear"].BestFit();
            //grdViewActivity.Columns["LED_Harness"].BestFit();
            //grdViewActivity.Columns["Application"].BestFit();
            //grdViewActivity.Columns["Region"].BestFit();
            //grdViewActivity.Columns["OEM"].BestFit();
            //grdViewActivity.Columns["SOP"].BestFit();
            //grdViewActivity.Columns["EOP"].BestFit();
            //grdViewActivity.Columns["Nameplate"].BestFit();
            //grdViewActivity.Columns["Component"].BestFit();
            //grdViewActivity.Columns["Type"].BestFit();
            //grdViewActivity.Columns["Price"].BestFit();
            //grdViewActivity.Columns["Volume2017"].BestFit();
            //grdViewActivity.Columns["Volume2018"].BestFit();
            //grdViewActivity.Columns["Volume2019"].BestFit();
            //grdViewActivity.Columns["Volume2020"].BestFit();
            //grdViewActivity.Columns["Volume2021"].BestFit();
            //grdViewActivity.Columns["Volume2022"].BestFit();
            //grdViewActivity.Columns["QuoteNumber"].BestFit();

            grdViewActivity.Columns["Customer"].Width = 160;
            grdViewActivity.Columns["Program"].Width = 100;
            grdViewActivity.Columns["EstYearlySales"].Width = 120;
            grdViewActivity.Columns["PeakYearlyVolume"].Width= 120;
            grdViewActivity.Columns["SOPYear"].Width = 70;
            grdViewActivity.Columns["LED_Harness"].Width = 90;
            grdViewActivity.Columns["Application"].Width = 180;
            grdViewActivity.Columns["Region"].Width = 100;
            grdViewActivity.Columns["OEM"].Width = 100;
            grdViewActivity.Columns["SOP"].Width = 80;
            grdViewActivity.Columns["EOP"].Width = 80;
            grdViewActivity.Columns["Nameplate"].Width = 120;
            grdViewActivity.Columns["Component"].Width = 90;
            grdViewActivity.Columns["Type"].Width = 130;
            grdViewActivity.Columns["Price"].Width = 60;
            grdViewActivity.Columns["Volume2017"].Width = 80;
            grdViewActivity.Columns["Volume2018"].Width = 80;
            grdViewActivity.Columns["Volume2019"].Width = 80;
            grdViewActivity.Columns["Volume2020"].Width = 80;
            grdViewActivity.Columns["Volume2021"].Width = 80;
            grdViewActivity.Columns["Volume2022"].Width = 80;
            grdViewActivity.Columns["QuoteNumber"].Width = 100;
            grdViewActivity.Columns["EEIPartNumber"].Width = 130;
            grdViewActivity.Columns["EAU"].Width = 70;
            grdViewActivity.Columns["ApplicationName"].Width = 100;
            grdViewActivity.Columns["SalesInitials"].Width = 80;
            grdViewActivity.Columns["QuotePrice"].Width = 80;
            grdViewActivity.Columns["Awarded"].Width = 60;
            grdViewActivity.Columns["QuoteStatus"].Width = 90;
            grdViewActivity.Columns["StraightMaterialCost"].Width = 140;
            grdViewActivity.Columns["TotalQuotedSales"].Width = 120;
            grdViewActivity.Columns["SalesForecastEEIBasePart"].Width = 200;
            grdViewActivity.Columns["SalesForecastPeakYearlyVolume"].Width = 200;
            grdViewActivity.Columns["SalesForecastApplication"].Width = 400;
            grdViewActivity.Columns["SalesPerson"].Width = 120;
        

            if (!_restoreGridSettings)
            {
                Cursor.Current = Cursors.Default;
                return;
            }

            // Restore saved grid settings if they exist
            string filePath = @"C:\FasttGridSettings\XtraGrid_SaveLayoutToXML_Hitlist.xml";
            if (File.Exists(filePath)) grdActivity.MainView.RestoreLayoutFromXml(filePath);

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

            grdViewDashboard1.OptionsView.ColumnAutoWidth = false;
            grdViewDashboard1.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewDashboard1.HorzScrollVisibility = ScrollVisibility.Always;

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

            grdViewDashboard1.Columns["Customer"].Width = 110;
            grdViewDashboard1.Columns["Sales2016"].Width = 130;
            grdViewDashboard1.Columns["Sales2017"].Width = 130;
            grdViewDashboard1.Columns["Sales2018"].Width = 130;
            grdViewDashboard1.Columns["Sales2019"].Width = 130;
            grdViewDashboard1.Columns["Sales2020"].Width = 130;
            grdViewDashboard1.Columns["Sales2021"].Width = 130;
            grdViewDashboard1.Columns["Sales2022"].Width = 130;

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

            grdViewDashboard2.OptionsView.ColumnAutoWidth = false;
            grdViewDashboard2.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewDashboard2.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewDashboard2.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard2.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c0";
            grdViewDashboard2.Columns["TotalQuotedSales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard2.Columns["Eau"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard2.Columns["Eau"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard2.Columns["Eau"].DisplayFormat.FormatString = "n0";
            grdViewDashboard2.Columns["QuotePrice"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard2.Columns["QuotePrice"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard2.Columns["QuotePrice"].DisplayFormat.FormatString = "n2";

            grdViewDashboard2.Columns["QuoteStatus"].Width = 100;
            grdViewDashboard2.Columns["Customer"].Width = 110;
            grdViewDashboard2.Columns["Program"].Width = 100;
            grdViewDashboard2.Columns["ApplicationName"].Width = 230;
            grdViewDashboard2.Columns["SalesInitials"].Width = 90;
            grdViewDashboard2.Columns["Sop"].Width = 90;
            grdViewDashboard2.Columns["Eop"].Width = 90;
            grdViewDashboard2.Columns["EeiPartNumber"].Width = 150;
            grdViewDashboard2.Columns["TotalQuotedSales"].Width = 130;
            grdViewDashboard2.Columns["Notes"].Width = 210;
            grdViewDashboard2.Columns["Eau"].Width = 80;
            grdViewDashboard2.Columns["QuotePrice"].Width = 90;
            grdViewDashboard2.Columns["QuotePricingDate"].Width = 130;
            grdViewDashboard2.Columns["Awarded"].Width = 70;
            grdViewDashboard2.Columns["MaterialPercentage"].Width = 130;


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

            grdViewDashboard3.Columns.Clear();
            grdDashboard3.DataSource = null;

            _controller.GetSalesActivityHistoryByCustomer(customer);
            if (!_controller.ListSalesPersonActivity.Any()) return;

            grdDashboard3.DataSource = _controller.ListSalesPersonActivity;

            grdViewDashboard3.OptionsView.ColumnAutoWidth = false;
            grdViewDashboard3.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewDashboard3.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewDashboard3.OptionsBehavior.Editable = false;
            grdViewDashboard3.Columns["ID"].Visible = grdViewDashboard3.Columns["SalesLeadID"].Visible = false;

            grdViewDashboard3.Columns["EstYearlySales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard3.Columns["EstYearlySales"].DisplayFormat.FormatString = "c0";
            grdViewDashboard3.Columns["Price"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard3.Columns["Price"].DisplayFormat.FormatString = "c2";
            grdViewDashboard3.Columns["PeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard3.Columns["PeakYearlyVolume"].DisplayFormat.FormatString = "n0";
            grdViewDashboard3.Columns["AwardedVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard3.Columns["AwardedVolume"].DisplayFormat.FormatString = "n0";

            grdViewDashboard3.Columns["EstYearlySales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard3.Columns["Price"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard3.Columns["PeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard3.Columns["SOPYear"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard3.Columns["AwardedVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;

            grdViewDashboard3.Columns["Customer"].Width = 120;
            grdViewDashboard3.Columns["Program"].Width = 100;
            grdViewDashboard3.Columns["EstYearlySales"].Width = 120;
            grdViewDashboard3.Columns["PeakYearlyVolume"].Width = 130;
            grdViewDashboard3.Columns["SOPYear"].Width = 70;
            grdViewDashboard3.Columns["Application"].Width = 200;
            grdViewDashboard3.Columns["Region"].Width = 100;
            grdViewDashboard3.Columns["OEM"].Width = 100;
            grdViewDashboard3.Columns["SOP"].Width = 80;
            grdViewDashboard3.Columns["EOP"].Width = 80;
            grdViewDashboard3.Columns["Type"].Width = 120;
            grdViewDashboard3.Columns["Nameplate"].Width = 110;
            grdViewDashboard3.Columns["Price"].Width = 60;
            grdViewDashboard3.Columns["AwardedVolume"].Width = 120;
            grdViewDashboard3.Columns["Component"].Width = 90;
            grdViewDashboard3.Columns["LED_Harness"].Width = 90;
            grdViewDashboard3.Columns["Status"].Width = 80;
            grdViewDashboard3.Columns["ActivityDate"].Width = 150;
            grdViewDashboard3.Columns["Activity"].Width = 100;
            grdViewDashboard3.Columns["MeetingLocation"].Width = 120;
            grdViewDashboard3.Columns["ContactName"].Width = 120;
            grdViewDashboard3.Columns["ContactPhoneNumber"].Width = 150;
            grdViewDashboard3.Columns["ContactEmailAddress"].Width = 150;
            grdViewDashboard3.Columns["Duration"].Width = 100;
            grdViewDashboard3.Columns["Notes"].Width = 220;
            grdViewDashboard3.Columns["LastSalesPerson"].Width = 140;
        }

        private void GetHitlistMsfByCustomer()
        {
            string customer = cbxReportCustomer.Text.Trim();
            int? sop = null;

            grdViewDashboard4.Columns.Clear();
            grdDashboard4.DataSource = null;

            _controller.GetHitlistMsfDashboard(customer, sop);
            if (!_controller.ListHitlistMsf.Any()) return;

            grdDashboard4.DataSource = _controller.ListHitlistMsf;

            grdViewDashboard4.OptionsView.ColumnAutoWidth = false;
            grdViewDashboard4.ScrollStyle = ScrollStyleFlags.LiveHorzScroll | ScrollStyleFlags.LiveVertScroll;
            grdViewDashboard4.HorzScrollVisibility = ScrollVisibility.Always;

            grdViewDashboard4.OptionsBehavior.Editable = false;
            grdViewDashboard4.Columns["ID"].Visible = false;
            grdViewDashboard4.Columns["SalesLeadID"].Visible = false;
            grdViewDashboard4.Columns["EstYearlySales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["EstYearlySales"].DisplayFormat.FormatString = "c0";
            grdViewDashboard4.Columns["Price"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Price"].DisplayFormat.FormatString = "c2";
            grdViewDashboard4.Columns["PeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["PeakYearlyVolume"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2017"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2017"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2018"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2018"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2019"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2019"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2020"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2020"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2021"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2021"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["Volume2022"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["Volume2022"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["EAU"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["EAU"].DisplayFormat.FormatString = "n0";
            grdViewDashboard4.Columns["QuotePrice"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["QuotePrice"].DisplayFormat.FormatString = "c2";
            grdViewDashboard4.Columns["StraightMaterialCost"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["StraightMaterialCost"].DisplayFormat.FormatString = "c2";
            grdViewDashboard4.Columns["TotalQuotedSales"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["TotalQuotedSales"].DisplayFormat.FormatString = "c2";
            grdViewDashboard4.Columns["SalesForecastPeakYearlyVolume"].DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            grdViewDashboard4.Columns["SalesForecastPeakYearlyVolume"].DisplayFormat.FormatString = "c0";

            grdViewDashboard4.Columns["EstYearlySales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Price"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["PeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["SOPYear"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2017"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2018"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2019"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2020"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2021"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["Volume2022"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["EAU"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["QuotePrice"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["StraightMaterialCost"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["TotalQuotedSales"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;
            grdViewDashboard4.Columns["SalesForecastPeakYearlyVolume"].AppearanceCell.TextOptions.HAlignment = HorzAlignment.Near;

            grdViewDashboard4.Columns["Customer"].Width = 160;
            grdViewDashboard4.Columns["Program"].Width = 100;
            grdViewDashboard4.Columns["EstYearlySales"].Width = 120;
            grdViewDashboard4.Columns["PeakYearlyVolume"].Width = 120;
            grdViewDashboard4.Columns["SOPYear"].Width = 70;
            grdViewDashboard4.Columns["LED_Harness"].Width = 90;
            grdViewDashboard4.Columns["Application"].Width = 180;
            grdViewDashboard4.Columns["Region"].Width = 100;
            grdViewDashboard4.Columns["OEM"].Width = 100;
            grdViewDashboard4.Columns["SOP"].Width = 80;
            grdViewDashboard4.Columns["EOP"].Width = 80;
            grdViewDashboard4.Columns["Nameplate"].Width = 120;
            grdViewDashboard4.Columns["Component"].Width = 90;
            grdViewDashboard4.Columns["Type"].Width = 130;
            grdViewDashboard4.Columns["Price"].Width = 60;
            grdViewDashboard4.Columns["Volume2017"].Width = 80;
            grdViewDashboard4.Columns["Volume2018"].Width = 80;
            grdViewDashboard4.Columns["Volume2019"].Width = 80;
            grdViewDashboard4.Columns["Volume2020"].Width = 80;
            grdViewDashboard4.Columns["Volume2021"].Width = 80;
            grdViewDashboard4.Columns["Volume2022"].Width = 80;
            grdViewDashboard4.Columns["QuoteNumber"].Width = 100;
            grdViewDashboard4.Columns["EEIPartNumber"].Width = 130;
            grdViewDashboard4.Columns["EAU"].Width = 70;
            grdViewDashboard4.Columns["ApplicationName"].Width = 130;
            grdViewDashboard4.Columns["SalesInitials"].Width = 80;
            grdViewDashboard4.Columns["QuotePrice"].Width = 80;
            grdViewDashboard4.Columns["Awarded"].Width = 60;
            grdViewDashboard4.Columns["QuoteStatus"].Width = 90;
            grdViewDashboard4.Columns["StraightMaterialCost"].Width = 140;
            grdViewDashboard4.Columns["TotalQuotedSales"].Width = 120;
            grdViewDashboard4.Columns["SalesForecastEEIBasePart"].Width = 200;
            grdViewDashboard4.Columns["SalesForecastPeakYearlyVolume"].Width = 200;
            grdViewDashboard4.Columns["SalesPerson"].Width = 120;
        }

        #endregion



    }
}
