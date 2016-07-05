using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace RmaMaintenance.Views
{
    public partial class SerialsListView : Form
    {
        public SerialsListView()
        {
            InitializeComponent();

            SetPartsGridProperties();
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

        #endregion


        #region DataGridView Events

        private void dgvSerialsList_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            // Set grid row properties
            dgvSerialsList.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Black;
            dgvSerialsList.Rows[e.RowIndex].DefaultCellStyle.ForeColor = Color.FromArgb(240, 240, 240);
            dgvSerialsList.Rows[e.RowIndex].DefaultCellStyle.Font = new Font("Tahoma", 10);
            dgvSerialsList.Rows[e.RowIndex].DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 122, 204);
        }

        #endregion


        #region Methods

        private void SetPartsGridProperties()
        {
            dgvSerialsList.ColumnHeadersDefaultCellStyle.BackColor = Color.Black;
            dgvSerialsList.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(0, 122, 204);
            dgvSerialsList.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgvSerialsList.ColumnHeadersHeight = 30;
            dgvSerialsList.EnableHeadersVisualStyles = false;

            dgvSerialsList.ClearSelection();
        }

        #endregion


    }
}
