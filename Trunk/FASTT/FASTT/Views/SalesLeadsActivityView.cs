using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FASTT.Controllers;

namespace FASTT.Views
{
    public partial class SalesLeadsActivityView : Form
    {
        #region Class Objects

        private readonly SalesLeadsActivityController _activityController;

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

        public SalesLeadsActivityView()
        {
            InitializeComponent();

            _activityController = new SalesLeadsActivityController();
        }

        private void SalesLeadsView_Load(object sender, EventArgs e)
        {
            gridView1.OptionsBehavior.Editable = false;
            linkLblClose.LinkBehavior = LinkBehavior.NeverUnderline;
            Error = "";

            if (GetSalesLeads() == 0) Close();
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

        private void grdSalesLeads_DoubleClick(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];
            if (r < 0) return;

            ModifySalesLead();
        }

        #endregion


        #region Methods
        
        private int GetSalesLeads()
        {
            Cursor.Current = Cursors.WaitCursor;

            grdSalesLeads.DataSource = null;

            _activityController.GetSalesLeadsBySalesPerson(OperatorCode);
            if (!_activityController.SalesLeadList.Any()) return 0;

            grdSalesLeads.DataSource = _activityController.SalesLeadList;

            gridView1.Columns["ID"].Visible = false;

            Cursor.Current = Cursors.Default;

            gridView1.Focus();
            return 1;
        }

        private void ModifySalesLead()
        {
            int r = gridView1.GetSelectedRows()[0];

            string iD = (gridView1.GetRowCellValue(r, "ID") != null) ? gridView1.GetRowCellValue(r, "ID").ToString() : "";
            string customer = (gridView1.GetRowCellValue(r, "Customer") != null) ? gridView1.GetRowCellValue(r, "Customer").ToString() : "";
            string program = (gridView1.GetRowCellValue(r, "Program") != null) ? gridView1.GetRowCellValue(r, "Program").ToString() : "";
            string application = (gridView1.GetRowCellValue(r, "Application") != null) ? gridView1.GetRowCellValue(r, "Application").ToString() : "";
            string sop = (gridView1.GetRowCellValue(r, "Sop") != null) ? gridView1.GetRowCellValue(r, "Sop").ToString() : "";
            string volume = (gridView1.GetRowCellValue(r, "Volume") != null) ? gridView1.GetRowCellValue(r, "Volume").ToString() : "";

            //GetSalesLeadContactInfo(rowId);

            var form = new SalesLeadsHistoryView
                {
                    OperatorCode = OperatorCode,
                    SalesLeadId = Convert.ToInt32(iD),
                    Customer = customer,
                    Program = program,
                    Application = application,
                    Sop = sop,
                    Volume = volume
                };

            form.ShowDialog();
            GetSalesLeads();
        }

        //private void GetSalesLeadContactInfo(int rowId)
        //{
        //    _activityController.GetSalesLeadContactInfo(rowId);
        //}

        #endregion


    }
}
