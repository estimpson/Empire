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
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid.Views.Base;
using System.IO;

namespace QuoteLogGrid.Views
{
    public partial class LayoutQuoteLogView : UserControl, IUserPanel
    {
        private readonly QuoteLogContext Context = new QuoteLogContext();

        public string QuoteNumber { get; set; }
        public string EEIPartNumber { get; set; }
        public string Customer { get; set; }
        public string ReceiptDate { get; set; }
        public string CustomerPartNumber { get; set; }
        public string RequestedDueDate { get; set; }
        public string EAU { get; set; }
        public string EEIPromisedDueDate { get; set; }
        public string ApplicationName { get; set; }
        public string ProgramManager { get; set; }
        public string EndUser { get; set; }
        public string ProductEngineer { get; set; }
        public string ModelYear { get; set; }
        public string Salesman { get; set; }
        public string Program { get; set; }
        public string CustomerRFQNumber { get; set; }
        public string Nameplate { get; set; }
        public string Target { get; set; }
        public string Requote { get; set; }
        public string Notes { get; set; }
        public string QuotePrice { get; set; }
        public int RowID { get; set; }

        public LayoutQuoteLogView()
        {
            InitializeComponent();
            InitGrid();
        }

        void InitGrid()
        {
        }

        public void ShowData()
        {
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
            SaveFileDialog sfd = new SaveFileDialog();
            sfd.DefaultExt = "xml";
            if (sfd.ShowDialog() == DialogResult.OK)
            {
                gridControl.MainView.SaveLayoutToXml(sfd.FileName);
            }
        }

        public void RestoreLayout()
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.DefaultExt = "xml";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    if (File.Exists(ofd.FileName))
                    {
                        gridControl.MainView.RestoreLayoutFromXml(ofd.FileName);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Layout could not be restored. Exception: " + ex.Message, "Error");
            }
        }

        public void PrintQuote()
        {
            gridControl.Print();
        }

        public void CopyQuote()
        {
            ColumnView view = gridControl.MainView as ColumnView;
            int r = view.GetSelectedRows()[0];

            QuoteNumber = view.GetRowCellValue(r, "QuoteNumber").ToString();
            if (view.GetRowCellValue(r, "EEIPartNumber") != null) EEIPartNumber = view.GetRowCellValue(r, "EEIPartNumber").ToString();
            if (view.GetRowCellValue(r, "Customer") != null) Customer = view.GetRowCellValue(r, "Customer").ToString();
            if (view.GetRowCellValue(r, "ReceiptDate") != null) ReceiptDate = view.GetRowCellValue(r, "ReceiptDate").ToString();
            if (view.GetRowCellValue(r, "CustomerPartNumber") != null) CustomerPartNumber = view.GetRowCellValue(r, "CustomerPartNumber").ToString();
            if (view.GetRowCellValue(r, "RequestedDueDate") != null) RequestedDueDate = view.GetRowCellValue(r, "RequestedDueDate").ToString();
            if (view.GetRowCellValue(r, "EAU") != null) EAU = view.GetRowCellValue(r, "EAU").ToString();
            if (view.GetRowCellValue(r, "EEIPromisedDueDate") != null) EEIPromisedDueDate = view.GetRowCellValue(r, "EEIPromisedDueDate").ToString();
            if (view.GetRowCellValue(r, "ApplicationName") != null) ApplicationName = view.GetRowCellValue(r, "ApplicationName").ToString();
            if (view.GetRowCellValue(r, "ProgramManagerInitials") != null) ProgramManager = view.GetRowCellValue(r, "ProgramManagerInitials").ToString();
            if (view.GetRowCellValue(r, "CustomerQuoteInitials") != null) EndUser = view.GetRowCellValue(r, "CustomerQuoteInitials").ToString();
            if (view.GetRowCellValue(r, "EngineeringInitials") != null) ProductEngineer = view.GetRowCellValue(r, "EngineeringInitials").ToString();
            if (view.GetRowCellValue(r, "ModelYear") != null) ModelYear = view.GetRowCellValue(r, "ModelYear").ToString();
            if (view.GetRowCellValue(r, "SalesInitials") != null) Salesman = view.GetRowCellValue(r, "SalesInitials").ToString();
            if (view.GetRowCellValue(r, "Program") != null) Program = view.GetRowCellValue(r, "Program").ToString();
            if (view.GetRowCellValue(r, "CustomerRFQNumber") != null) CustomerRFQNumber = view.GetRowCellValue(r, "CustomerRFQNumber").ToString();
            if (view.GetRowCellValue(r, "Nameplate") != null) Nameplate = view.GetRowCellValue(r, "Nameplate").ToString();
            //if (view.GetRowCellValue(r, "Target") != null) Target = view.GetRowCellValue(r, "Target").ToString();
            if (view.GetRowCellValue(r, "Requote") != null) Requote = view.GetRowCellValue(r, "Requote").ToString();
            if (view.GetRowCellValue(r, "Notes") != null) Notes = view.GetRowCellValue(r, "Notes").ToString();
            if (view.GetRowCellValue(r, "QuotePrice") != null) QuotePrice = view.GetRowCellValue(r, "QuotePrice").ToString();
        }


    }
}
