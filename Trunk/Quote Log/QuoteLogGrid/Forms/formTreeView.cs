using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.XtraTreeList;
using DevExpress.XtraTreeList.Nodes;
using System.Drawing.Printing;
using QuoteLogGrid.Interfaces;
using QuoteLogData.Models;
using DevExpress.Data.Linq;
using System.Data.Objects;
using System.Data.Entity;

namespace QuoteLogGrid.Forms
{
    public partial class formTreeView : Form
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        public formTreeView()
        {
            InitializeComponent();
        }

        private void formTreeView_Load(object sender, EventArgs e)
        {
            ShowData();
        }

        public void ShowData()
        {
            try
            {
                // Query the database and copy records to local dbset
                Context.QuoteTreeLists.Load();

                // Bind
                treeList1.DataSource = null;
                treeList1.DataSource = Context.QuoteTreeLists.Local.ToBindingList();

                treeList1.ParentFieldName = "ParentQuoteID";
                treeList1.KeyFieldName = "RowID";
            }
            catch (Exception)
            {
                MessageBox.Show("Data could not be retrieved.", "Quote TreeList");
            }
        }


    }
}
