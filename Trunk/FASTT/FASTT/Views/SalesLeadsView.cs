﻿using System;
using System.Drawing;
using System.Windows.Forms;
using FASTT.Controllers;

namespace FASTT.Views
{
    public partial class SalesLeadsView : Form
    {
        #region Class Objects

        private readonly SalesLeadsController _controller;

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

        private bool _formLoading;
        public bool FormLoading
        {
            get { return _formLoading; }
            set
            {
                _formLoading = value;
                Cursor.Current = (value) ? Cursors.WaitCursor : Cursors.Default;
            }
        }

        #endregion


        #region Constructor, Load

        public SalesLeadsView()
        {
            InitializeComponent();

            _controller = new SalesLeadsController();
        }

        private void MnemonicsView_Load(object sender, EventArgs e)
        {
            GetCustomers();

            gridView1.OptionsBehavior.Editable = false;
            tlpGrid.Visible = false;
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


        #region ComboBox Events

        private void cbxParentCustomers_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_formLoading) return;
            GetGridDataByCustomer();
        }

        #endregion


        #region Grid Events

        private void grdSalesData_DoubleClick(object sender, EventArgs e)
        {
            int r = gridView1.GetSelectedRows()[0];
            if (r < 0) return;

            ModifySalesLead();
        }

        #endregion


        #region Methods

        private void GetCustomers()
        {
            FormLoading = true;

            string error;
            cbxCustomers.DataSource = _controller.GetCustomers(out error);
            cbxCustomers.DisplayMember = "Customer";

            FormLoading = false;
        }

        private void GetGridDataByCustomer()
        {
            string customer = cbxCustomers.Text;

            Cursor.Current = Cursors.WaitCursor;

            grdSalesData.DataSource = null;
            _controller.GetGridDataByCustomer(customer);
            //if (error == "") grdSalesData.DataSource = _controller.BindingSource;
            grdSalesData.DataSource = _controller.SalesLeadsList;

            //// Hide columns
            gridView1.Columns["ID"].Visible = false;

            // Toggle controls
            tlpGrid.Visible = (_controller.SalesLeadsList.Count > 0);

            Cursor.Current = Cursors.Default;

            gridView1.Focus();
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

            var form = new SalesLeadsActivityDetailsView
                {
                    OperatorCode = OperatorCode,
                    CombinedLightingId = Convert.ToInt32(iD),
                    Customer = customer,
                    Program = program,
                    Application = application,
                    Sop = sop,
                    Volume = volume,
                    SalesLeadClicked = true
                };

            form.ShowDialog();
        }
        
        #endregion


    }
}