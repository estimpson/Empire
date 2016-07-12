using System;
using System.Drawing;
using System.Windows.Forms;
using FASTT.Controllers;
using FASTT.Controls;

namespace FASTT.Views
{
    public partial class SalesLeadsActivityDetailsView : Form
    {
        #region Class Objects

        private readonly SalesLeadsActivityDetailsController _controller;
        private readonly CustomMessageBox _messageBox;

        #endregion


        #region Properties

        public string OperatorCode { get; set; }
        public bool SalesLeadClicked { get; set; }

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

        public int? CombinedLightingId { get; set; }
        public int? SalesLeadId { get; set; }
        public int? ActivityRowId { get; set; }
        public string Customer { get; set; }
        public string Program { get; set; }
        public string Application { get; set; }
        public string Sop { get; set; }
        public string Volume { get; set; }
        public string Activity { get; set; }
        public string ActivityDate { get; set; }
        public decimal Duration { get; set; }
        public string ContactName { get; set; }
        public string ContactPhone { get; set; }
        public string ContactEmail { get; set; }
        public string Notes { get; set; }

        #endregion


        #region Constructor, Load

        public SalesLeadsActivityDetailsView()
        {
            InitializeComponent();

            _controller = new SalesLeadsActivityDetailsController();
            _messageBox = new CustomMessageBox();
        }

        private void SalesLeadsDetailsView_Load(object sender, EventArgs e)
        {
            SetDropDownLists();
            PopulateFields();
            PopulateSalesLeadContactInfo();

            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
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


        #region Button Click Events

        private void mesBtnSaveSalesLead_Click(object sender, EventArgs e)
        {
            SaveSalesLead();
        }

        #endregion


        #region Methods

        private void SetDropDownLists()
        {
            cbxSalesPersonActivity.Items.Add("");
            cbxSalesPersonActivity.Items.Add("Email");
            cbxSalesPersonActivity.Items.Add("Meeting");
            cbxSalesPersonActivity.Items.Add("Phone Call");

            cbxSalesLeadStatus.Items.Add("Open");
            cbxSalesLeadStatus.Items.Add("Closed");
        }

        private void PopulateFields()
        {
            mesTbxProgram.Text = Program;
            mesTbxApplication.Text = Application;
            mesTbxCustomer.Text = Customer;
            mesTbxSop.Text = Sop;
            mesTbxVolume.Text = Volume;
            cbxSalesPersonActivity.Text = Activity;
            if (ActivityDate != null) dtpCalendar.Value = Convert.ToDateTime(ActivityDate);
            mesTbxContactName.Text = ContactName;
            mesTbxContactEmail.Text = ContactEmail;
            mesTbxContactPhone.Text = ContactPhone;
            mesTbxNotes.Text = Notes;

            int hours = Convert.ToInt32(Math.Floor(Duration/60));
            int minutes = Convert.ToInt32(Duration%60);
            mesTbxHours.Text = hours.ToString();
            mesTbxMinutes.Text = minutes.ToString();

            cbxSalesLeadStatus.Text = "Open";
        }

        private void PopulateSalesLeadContactInfo()
        {
            if (SalesLeadClicked) // Arrived at this form from the sales lead form
            {
                _controller.GetSalesLeadContactInfo(Convert.ToInt32(SalesLeadId));
                mesTbxContactName.Text = _controller.ContactName;
                mesTbxContactPhone.Text = _controller.ContactPhone;
                mesTbxContactEmail.Text = _controller.ContactEmail;
            }
        }

        private void SaveSalesLead()
        {
            // Data validation
            if (cbxSalesLeadStatus.Text.Trim() == "")
            {
                _messageBox.Message = "You must select a Lead Status.";
                _messageBox.ShowDialog();
                return;
            }
            int salesLeadStatus = (cbxSalesLeadStatus.Text.Trim() == "Open") ? 0 : 1;

            string activity = cbxSalesPersonActivity.Text.Trim();
            if (activity == "" && salesLeadStatus == 0)
            {
                _messageBox.Message = "You must select an Activity.";
                _messageBox.ShowDialog();
                return;
            }
            decimal durationHrs;
            try
            {
                durationHrs = Convert.ToDecimal(mesTbxHours.Text.Trim());
            }
            catch (Exception)
            {
                _messageBox.Message = "Invalid duration hours.";
                _messageBox.ShowDialog();
                return;
            }
            if (durationHrs < 0)
            {
                _messageBox.Message = "Invalid duration hours.";
                _messageBox.ShowDialog();
                return;
            }
            decimal durationMns;
            try
            {
                durationMns = Convert.ToDecimal(mesTbxMinutes.Text.Trim());
            }
            catch (Exception)
            {
                _messageBox.Message = "Invalid duration minutes.";
                _messageBox.ShowDialog();
                return;
            }
            if (durationMns < 0)
            {
                _messageBox.Message = "Invalid duration minutes.";
                _messageBox.ShowDialog();
                return;
            }
            if (durationHrs == 0 && durationMns == 0)
            {
                _messageBox.Message = "You must enter the duration of the activity.";
                _messageBox.ShowDialog();
                return;
            }

            decimal duration = (durationHrs > 0) ? (durationHrs * 60) + durationMns : durationMns;
            DateTime activityDate = dtpCalendar.Value;
            string contactName = mesTbxContactName.Text.Trim();
            string contactPhoneNumber = mesTbxContactPhone.Text.Trim();
            string contactEmailAddress = mesTbxContactEmail.Text.Trim();
            string notes = mesTbxNotes.Text.Trim();

            DateTime? sop = null;
            if (Sop != string.Empty)
            {
                sop = Convert.ToDateTime(Sop);
            }

            int result = _controller.SaveSalesLeadActivity(OperatorCode, CombinedLightingId, SalesLeadId, salesLeadStatus, ActivityRowId, 
                activity, activityDate, contactName, contactPhoneNumber, contactEmailAddress, duration, notes);

            if (result == 1) Close();
        }

        #endregion


    }
}
