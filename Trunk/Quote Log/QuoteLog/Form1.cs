using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using DevExpress.Skins;
using DevExpress.LookAndFeel;
using DevExpress.UserSkins;
using DevExpress.Data.Linq;
using DevExpress.XtraGrid.Views.Grid;
using System.Data.Objects;
using QuoteLogGrid.Interfaces;
using System.IO;
using QuoteLogMetrics;

namespace QuoteLog
{
    public partial class Form1 : XtraForm
    {
        IUserPanel myVisiblePanel;

        public Form1()
        {
            InitializeComponent();

            BandedGridViewItem.Visible = FasterGridViewItem.Visible = navBarItem1.Visible = false;

            ShowPanel("Simple Grid View");
        }

        private void NavBarItemClicked(object sender, DevExpress.XtraNavBar.NavBarLinkEventArgs e)
        {
            String caption = e.Link.Item.Caption;
            ShowPanel(caption);
        }

        private void ShowPanel(String caption)
        {
            foreach (Control c in splitContainerControl.Panel2.Controls)
            {
                if ((c is Panel || c is XtraPanel || c is UserControl) && c.Tag != null)
                {
                    c.Visible = false;
                    c.Dock = DockStyle.Fill;
                    if (c is IUserPanel && c.Tag.ToString() == caption)
                    {
                        (c as IUserPanel).ShowData();
                        myVisiblePanel = c as IUserPanel;
                    }
                    c.Visible = c.Tag.ToString() == caption;
                }
            }
        }

        private void iSave_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            myVisiblePanel.SaveData();
        }

        private void iSaveLayout_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            if (myVisiblePanel == null) return;
            myVisiblePanel.SaveLayout();
        }

        private void iRestoreLayout_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            if (myVisiblePanel == null) return;
            myVisiblePanel.RestoreLayout();
        }

        private void iMetrics_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            //QuoteLogMetrics.formMetrics chartForm = new QuoteLogMetrics.formMetrics();
            QuoteLogMetrics.formMetricsDynamic chartForm = new formMetricsDynamic();
            chartForm.ShowDialog();
        }

        private void iTreeList_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            QuoteLogGrid.Forms.formTreeView treeView = new QuoteLogGrid.Forms.formTreeView();
            treeView.ShowDialog();
        }

        private void iRequestNewSegment_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            QuoteLogGrid.Forms.formNewSegmentRequest newSegment = new QuoteLogGrid.Forms.formNewSegmentRequest();
            newSegment.ShowDialog();
        }


    }
}