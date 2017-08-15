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
    public partial class CustomersView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        private List<string> ReplacementList = new List<string>();

        public CustomersView()
        {
            InitializeComponent();
        }

        public void ShowData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.Customers.Load();

                // Bind grid
                gridControl.DataSource = null;
                gridControl.DataSource = Context.Customers.Local.ToBindingList();

                gridView1.Columns[0].Visible = false;
            }
            catch (Exception)
            {
                MessageBox.Show("Data could not be retrieved.", "Customers");
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        public void SaveData()
        { 
            ObjectParameter result = new ObjectParameter("Result", typeof(Int32));
            ObjectParameter tranDt = new ObjectParameter("TranDT", typeof(DateTime));

            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;

            gridView1.PostEditor();
            gridView1.UpdateCurrentRow();

            Context.SaveChanges();

            // If deletes were made, update all quotes that are using the deleted value with the new value
            if (ReplacementList.Count > 0)
            {
                foreach (var item in ReplacementList)
                {
                    string[] vals = item.Split(',');
                    try
                    {
                        // deleting value, replacing value
                        Context.usp_QT_ReplaceQuoteLogValues(vals[0], vals[1], vals[2], tranDt, result);
                    }
                    catch (Exception ex)
                    {
                        if (ex.InnerException != null) MessageBox.Show(ex.InnerException.ToString().Remove(ex.InnerException.ToString().IndexOf("at System.")), "Error");
                    }
                }
            }
            System.Windows.Forms.Cursor.Current = Cursors.Default;
        }

        public void SaveLayout()
        {
        }

        public void RestoreLayout()
        {
        }

        public void ExportToExcel()
        {
        }

        private void gridControl_EmbeddedNavigator_ButtonClick(object sender, DevExpress.XtraEditors.NavigatorButtonClickEventArgs e)
        {
            if (e.Button.ButtonType == DevExpress.XtraEditors.NavigatorButtonType.Remove)
            {
                string DeleteFromTableName = "QT_Customers";

                int r = gridView1.GetSelectedRows()[0];
                string SelectedDeletingValue = gridView1.GetRowCellValue(r, "CustomerCode").ToString();

                Forms.formReplaceDeleted rd = new Forms.formReplaceDeleted(SetupTypes.Customer, SelectedDeletingValue);
                if(rd.ShowDialog() == DialogResult.OK)
                {
                    string replacementString = DeleteFromTableName + "," + SelectedDeletingValue + "," + rd.SelectedReplacementValue;
                    ReplacementList.Add(replacementString);
                }
            }
        }




    }
}