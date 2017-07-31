using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogGrid.Interfaces;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using System.IO;

namespace QuoteLogGrid.Views
{
    public partial class FastQuoteLogView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();
        public FastQuoteLogView()
        {
            InitializeComponent();
            InitGrid();
        }

        void InitGrid()
        {
        }

        public void ShowData()
        {
            var source = new LinqInstantFeedbackSource()
                {
                    KeyExpression = "RowID"
                };
            source.GetQueryable += OnGetQueryable;
            gridControl.DataSource = source;
        }

        private void OnGetQueryable(object sender, GetQueryableEventArgs e)
        {
            e.QueryableSource = Context.QuoteLog;
        }

        public void SaveData()
        {
            Context.SaveChanges();
        }

        public void SaveLayout()
        {
            gridView1.SaveLayoutToXml(@"C:\XtraGridViewLayouts\FastQuoteLogView.xml");
        }

        public void RestoreLayout()
        {
            if (File.Exists(@"C:\XtraGridViewLayouts\FastQuoteLogView.xml"))
            {
                gridView1.RestoreLayoutFromXml(@"C:\XtraGridViewLayouts\FastQuoteLogView.xml");
            }
            else
            {
                MessageBox.Show("You have not saved a layout for this view yet.", "Message");
            }
        }

        public void ExportToExcel()
        {
        }


    }
}
