using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
           
    }


    protected void ASPxButton1_Click(object sender, EventArgs e)
    {
    //    DataGrid1_KomaxProductionbyPeriod.UnGroup(DataGrid1_KomaxProductionbyPeriod.Columns["from_loc"]);
        DataGrid1_KomaxProductionbyPeriod.Columns.Clear(); 
        DataGrid1_KomaxProductionbyPeriod.AutoGenerateColumns = true;
        SDS_KomaxProduction1.DataBind();
        DataGrid1_KomaxProductionbyPeriod.DataBind();

    }

    protected void DataGrid1_KomaxProductionbyPeriod_DataBound(object sender, EventArgs e)
    {
        {
            DataGrid1_KomaxProductionbyPeriod.Settings.ShowFooter = true;

            //  DataGrid1_KomaxProductionbyPeriod.GroupBy(DataGrid1_KomaxProductionbyPeriod.Columns["from_loc"]);
            foreach (GridViewColumn column in DataGrid1_KomaxProductionbyPeriod.Columns)
         
            //if (column.GetType() == typeof(System.Single)
            //  || column.GetType() == typeof(System.Double)
            //  || column.GetType() == typeof(System.Decimal)
            //  || column.GetType() == typeof(System.Byte)
            //  || column.GetType() == typeof(System.Int16)
            //  || column.GetType() == typeof(System.Int32)
            //  || column.GetType() == typeof(System.Int64))
            if (column.Index > 0)
            {
                DataGrid1_KomaxProductionbyPeriod.DataColumns[column.Index].PropertiesEdit.DisplayFormatString = "N0";
                    DataGrid1_KomaxProductionbyPeriod.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, column.Name.ToString());
                    //DataGrid1_KomaxProductionbyPeriod.TotalSummary[column.Name.ToString()].ShowInColumn = column.Name.ToString();
            }
            //else
            //{
            //    DataGrid1_KomaxProductionbyPeriod.DataColumns[column.Index].PropertiesEdit.DisplayFormatString = "N0";
            //        DataGrid1_KomaxProductionbyPeriod.TotalSummary[column.Name.ToString()].FieldName = column.Name.ToString();
            //        DataGrid1_KomaxProductionbyPeriod.TotalSummary[column.Name.ToString()].SummaryType = DevExpress.Data.SummaryItemType.Sum;
            //        DataGrid1_KomaxProductionbyPeriod.TotalSummary[column.Name.ToString()].ShowInColumn = column.Name.ToString();
            //    }
        }
    }
}