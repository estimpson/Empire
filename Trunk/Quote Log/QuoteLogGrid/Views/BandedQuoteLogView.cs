using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuoteLogData.Models;
using QuoteLogGrid.Interfaces;
using DevExpress.Data.Linq;
using DevExpress.XtraEditors.Controls;
using System.IO;

namespace QuoteLogGrid.Views
{
    public partial class BandedQuoteLogView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();
        public BandedQuoteLogView()
        {
            InitializeComponent();
            InitGrid();
        }

        void InitGrid()
        {
        }

        public void ShowData()
        {
            var x = Context.GetApplicationCodes();

            ApplicationRepositoryItemLookUpEdit.DataSource = x.ToList();
            ApplicationRepositoryItemLookUpEdit.DisplayMember = "ApplicationCode";
            ApplicationRepositoryItemLookUpEdit.Columns.Add(new LookUpColumnInfo("ApplicationCode"));

            gridControl.DataSource = new LinqServerModeSource()
                {
                    ElementType = typeof(QuoteEntry),
                    KeyExpression = "RowID",
                    QueryableSource = Context.QuoteLog
                };
        }

        public void SaveData()
        {
            Context.SaveChanges();
        }

        public void SaveLayout()
        {
            QuoteLogMasterGridView.SaveLayoutToXml(@"C:\XtraGridViewLayouts\BandedQuoteLogView.xml");
        }

        public void RestoreLayout()
        {
            if (File.Exists(@"C:\XtraGridViewLayouts\BandedQuoteLogView.xml"))
            {
                QuoteLogMasterGridView.RestoreLayoutFromXml(@"C:\XtraGridViewLayouts\BandedQuoteLogView.xml");
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
