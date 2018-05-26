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
    public partial class FunctionsView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        private List<string> ReplacementList = new List<string>();

        public FunctionsView()
        {
            InitializeComponent();
        }

        public void ShowData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.vw_QT_Functions.Load();

                // Bind grid
                gridControl.DataSource = null;
                gridControl.DataSource = Context.vw_QT_Functions.Local.ToBindingList();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Data could not be retrieved.");
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
            gridView1.SaveLayoutToXml(@"C:\XtraGridViewLayouts\FunctionsView.xml");
        }

        public void RestoreLayout()
        {
            if (File.Exists(@"C:\XtraGridViewLayouts\FunctionsView.xml"))
            {
                gridView1.RestoreLayoutFromXml(@"C:\XtraGridViewLayouts\FunctionsView.xml");
            }
            else
            {
                MessageBox.Show("You have not saved a layout for this view yet.", "Message");
            }
        }

        public void ExportToExcel()
        {
        }

        private void gridControl_EmbeddedNavigator_ButtonClick(object sender, DevExpress.XtraEditors.NavigatorButtonClickEventArgs e)
        {
            if (e.Button.ButtonType == DevExpress.XtraEditors.NavigatorButtonType.Remove)
            {
                string DeleteFromTableName = "QT_Functions";

                int r = gridView1.GetSelectedRows()[0];
                string SelectedDeletingValue = gridView1.GetRowCellValue(r, "FunctionCode").ToString();

                Forms.formReplaceDeleted rd = new Forms.formReplaceDeleted(SetupTypes.Function, SelectedDeletingValue);
                if (rd.ShowDialog() == DialogResult.OK)
                {
                    string replacementString = DeleteFromTableName + "," + SelectedDeletingValue + "," + rd.SelectedReplacementValue;
                    ReplacementList.Add(replacementString);
                }
            }
        }


    }
}
