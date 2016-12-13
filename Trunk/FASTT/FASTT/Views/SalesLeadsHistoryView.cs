using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FASTT.Controllers;
using FASTT.Controls;

namespace FASTT.Views
{
    public partial class SalesLeadsHistoryView : Form
    {
        #region Class Objects

        private readonly SalesLeadsHistoryController _controller;
        private readonly CustomMessageBox _messageBox;

        #endregion


        #region Properties

        public string OperatorCode { get; set; }
        public int SalesLeadId { get; set; }
        public int CombinedLightingId { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string Application { get; set; }
        public string Sop { get; set; }
        public string Eop { get; set; }
        public string Volume { get; set; }

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

        private ActivityType _type;

        #endregion


        #region Enums

        enum ActivityType
        {
            Copy,
            Edit,
            New
        }

        #endregion


        #region Constructor, Load

        public SalesLeadsHistoryView()
        {
            InitializeComponent();

            _controller = new SalesLeadsHistoryController();
            _messageBox = new CustomMessageBox();
        }

        private void SalesLeadsHistoryView_Load(object sender, EventArgs e)
        {
            gridView1.OptionsBehavior.Editable = false;
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            Error = "";

            lblHeaderInfo.Text = string.Format("{0}   {1}   {2}    SOP:  {3}    EOP:  {4}    VOL:  {5}", Customer, Program, Application, Sop, Eop, Volume);

            if (GetActivityHistory() == 0) Close();
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

        #endregion


        #region Grid DoubleClick Event

        private void grdSalesActivity_DoubleClick(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];
            if (r < 0) return;

            _type = ActivityType.Edit;
            SalesLeadActivity();
        }

        #endregion


        #region Button Click Events

        private void mesBtnCopy_Click(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];
            if (r < 0) return;

            string status = (gridView1.GetRowCellValue(r, "Status") != null) ? gridView1.GetRowCellValue(r, "Status").ToString() : "";
            if (status == "Awarded" || status == "Closed")
            {
                _messageBox.Message = "Cannot copy an Awarded or Closed activity.";
                _messageBox.ShowDialog();
                return;
            }

            _type = ActivityType.Copy;
            SalesLeadActivity();
        }

        private void mesBtnNew_Click(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];
            if (r < 0) return;

            //string status = (gridView1.GetRowCellValue(r, "Status") != null) ? gridView1.GetRowCellValue(r, "Status").ToString() : "";
            //if (status == "Awarded" || status == "Closed")
            //{
            //    _messageBox.Message = "Cannot create new activity entries for sales leads that have been awarded or closed.";
            //    _messageBox.ShowDialog();
            //    return;
            //}

            _type = ActivityType.New;
            SalesLeadActivity();
        }

        #endregion


        #region Methods

        private int GetActivityHistory()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdSalesActivity.DataSource = null;

            _controller.GetSalesActivityHistory(SalesLeadId);
            if (!_controller.SalesLeadHistoryList.Any()) return 0;

            grdSalesActivity.DataSource = _controller.SalesLeadHistoryList;

            gridView1.Columns["RowId"].Visible = false;
            gridView1.Columns["Duration"].Visible = false;

            Cursor.Current = Cursors.Default;

            gridView1.Focus();
            return 1;
        }

        private void SalesLeadActivity()
        {
            int r = gridView1.GetSelectedRows()[0];

            string activity = (gridView1.GetRowCellValue(r, "Activity") != null) ? gridView1.GetRowCellValue(r, "Activity").ToString() : "";
            string activityDate = (gridView1.GetRowCellValue(r, "ActivityDate") != null) ? gridView1.GetRowCellValue(r, "ActivityDate").ToString() : "";
            decimal duration = Convert.ToDecimal(gridView1.GetRowCellValue(r, "Duration"));
            string contactName = (gridView1.GetRowCellValue(r, "ContactName") != null) ? gridView1.GetRowCellValue(r, "ContactName").ToString() : "";
            string contactPhone = (gridView1.GetRowCellValue(r, "ContactPhoneNumber") != null) ? gridView1.GetRowCellValue(r, "ContactPhoneNumber").ToString() : "";
            string contactEmail = (gridView1.GetRowCellValue(r, "ContactEmailAddress") != null) ? gridView1.GetRowCellValue(r, "ContactEmailAddress").ToString() : "";
            string notes = (gridView1.GetRowCellValue(r, "Notes") != null) ? gridView1.GetRowCellValue(r, "Notes").ToString() : "";
            string quoteNumber = (gridView1.GetRowCellValue(r, "QuoteNumber") != null) ? gridView1.GetRowCellValue(r, "QuoteNumber").ToString() : "";
            string awarded = (gridView1.GetRowCellValue(r, "AwardedVolume") != null) ? gridView1.GetRowCellValue(r, "AwardedVolume").ToString() : "";
            string status = (gridView1.GetRowCellValue(r, "Status") != null) ? gridView1.GetRowCellValue(r, "Status").ToString() : "";
            int rowId = Convert.ToInt32(gridView1.GetRowCellValue(r, "RowId"));

            var form = new SalesLeadsActivityDetailsView();

            form.OperatorCode = OperatorCode;
            form.SalesLeadId = SalesLeadId;
            form.CombinedLightingId = CombinedLightingId;
            form.Customer = Customer;
            form.Program = Program;
            form.Application = Application;
            form.Sop = Sop;
            form.Eop = Eop;
            form.Volume = Volume;
            form.QuoteNumber = quoteNumber;
            form.AwardedVolume = awarded;

            form.Status = status;

            if (_type == ActivityType.Edit) form.ActivityRowId = rowId;
            if (_type == ActivityType.Edit) form.ActivityDate = activityDate;
            if (_type == ActivityType.Edit) form.Duration = duration;
            
            if (_type == ActivityType.Copy || _type == ActivityType.Edit) form.Activity = activity;
            if (_type == ActivityType.Copy || _type == ActivityType.Edit) form.ContactName = contactName;
            if (_type == ActivityType.Copy || _type == ActivityType.Edit) form.ContactPhone = contactPhone;
            if (_type == ActivityType.Copy || _type == ActivityType.Edit) form.ContactEmail = contactEmail;
            if (_type == ActivityType.Copy || _type == ActivityType.Edit) form.Notes = notes;

            form.SalesLeadClicked = false;

            form.ShowDialog();
            if (GetActivityHistory() == 0) Close(); // Refresh upon return
        }

        #endregion


    }
}
