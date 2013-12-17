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
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraGrid.Views.Grid;
using System.IO;

namespace QuoteLogGrid.Views
{
    public partial class ApplicationsView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        private List<string> ReplacementList = new List<string>();

        public ApplicationsView()
        {
            InitializeComponent();
        }

        public void ShowData()
        {
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Query the database and copy records to local dbset
                Context.Applications.Load();

                // Bind grid
                gridControl.DataSource = null;
                gridControl.DataSource = Context.Applications.Local.ToBindingList();

                gridView1.Columns[0].Visible = false;
            }
            catch (Exception)
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
            //gridView1.SaveLayoutToXml(@"C:\XtraGridViewLayouts\ApplicationsView.xml");
        }

        public void RestoreLayout()
        {
            //if (File.Exists(@"C:\XtraGridViewLayouts\ApplicationsView.xml"))
            //{
            //    gridView1.RestoreLayoutFromXml(@"C:\XtraGridViewLayouts\ApplicationsView.xml");
            //}
            //else
            //{
            //    MessageBox.Show("You have not saved a layout for this view yet.", "Message");
            //}
        }


        private void gridView1_ValidatingEditor(object sender, BaseContainerValidateEditorEventArgs e)
        {
            //GridView view = sender as GridView;
            //if (view.FocusedColumn.FieldName == "ApplicationName")
            //{
            //    //Get the currently edited value 
            //    string code = e.Value.ToString();
            //    
            //    // Check for allowable length
            //    if (code.Length > 50)
            //    {
            //        e.Valid = false;
            //        e.ErrorText = "Maximum characters allowed = 50.";
            //    }
            //
            //    // Check for duplicate values
            //    for (int i = 0; i < gridView1.RowCount -1; i++)
			//    {
            //        if (code == gridView1.GetRowCellValue(i, "ApplicationName").ToString() &&  i != gridView1.FocusedRowHandle)
            //       {
            //           e.Valid = false;
            //            e.ErrorText = "Duplicate entries are not allowed.";
            //        }
			//    }
            //}
        }

        private void gridView1_InvalidValueException(object sender, InvalidValueExceptionEventArgs e)
        {
            ////Do not perform any default action 
            //e.ExceptionMode = DevExpress.XtraEditors.Controls.ExceptionMode.DisplayError;
            ////Show the message with the error text specified 
            //MessageBox.Show(e.ErrorText);
        }

        private void gridControl_EmbeddedNavigator_ButtonClick(object sender, DevExpress.XtraEditors.NavigatorButtonClickEventArgs e)
        {
            if (e.Button.ButtonType == DevExpress.XtraEditors.NavigatorButtonType.Remove)
            {
                string DeleteFromTableName = "QT_Applications";

                int r = gridView1.GetSelectedRows()[0];
                string SelectedDeletingValue = gridView1.GetRowCellValue(r, "ApplicationCode").ToString();

                Forms.formReplaceDeleted rd = new Forms.formReplaceDeleted(SetupTypes.Applications, SelectedDeletingValue);
                if (rd.ShowDialog() == DialogResult.OK)
                {
                    string replacementString = DeleteFromTableName + "," + SelectedDeletingValue + "," + rd.SelectedReplacementValue;
                    ReplacementList.Add(replacementString);
                }
            }
        }


    }
}
