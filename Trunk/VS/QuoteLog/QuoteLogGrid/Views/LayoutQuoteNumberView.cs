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
using System.Data.Objects;
using System.Data.Entity;
using DevExpress.XtraGrid.Views.Grid;
using System.IO;

namespace QuoteLogGrid.Views
{
    public partial class LayoutQuoteNumberView : UserControl, IUserPanel
    {
        public LayoutQuoteNumberView()
        {
            InitializeComponent();

            this.Leave += LayoutQuoteNumberView_Leave;
        }

        public void LayoutQuoteNumberView_Leave(object sender, EventArgs e)
        {
            if (FormClosed != null) // check for listener
            {
                FormClosed();
            }
        }
        public delegate void FormClosedEventHandler();
        public event FormClosedEventHandler FormClosed;

        public void ShowData() {}

        public void SaveData()
        {

        }

        public void SaveLayout() {}

        public void RestoreLayout() {}

        private void btnAbort_Click(object sender, EventArgs e)
        {

        }

        private void LayoutQuoteNumberView_Leave_1(object sender, EventArgs e)
        {
            string y = "y";
        }




    }
}
