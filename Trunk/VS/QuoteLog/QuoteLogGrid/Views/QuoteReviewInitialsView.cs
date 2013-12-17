﻿using System;
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

namespace QuoteLogGrid.Views
{
    public partial class QuoteReviewInitialsView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        public QuoteReviewInitialsView()
        {
            InitializeComponent();
        }

        public void ShowData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.QuoteReviewInitials.Load();

                // Bind grid
                gridControl1.DataSource = null;
                gridControl1.DataSource = Context.QuoteReviewInitials.Local.ToBindingList();

                gridView1.Columns[0].Visible = false;
            }
            catch (Exception)
            {
                MessageBox.Show("Data could not be retrieved.", "Quote Review Initials");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        public void SaveData()
        {
            gridView1.PostEditor();
            gridView1.UpdateCurrentRow();

            Context.SaveChanges();
        }

        public void SaveLayout()
        {
        }

        public void RestoreLayout()
        {
        }


    }
}
