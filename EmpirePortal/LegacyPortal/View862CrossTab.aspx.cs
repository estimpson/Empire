using System;
using System.Web.UI;
using System.Data;
using Telerik.Web.UI;
using Telerik.Web.Data;

public partial class NALReview : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataView dvSql = (DataView)SqlDataSource3.Select(DataSourceSelectArguments.Empty);
        foreach (DataRowView drvSql in dvSql)
        {
            RadDateTimePicker1.SelectedDate = (DateTime.Parse(drvSql["Day0"].ToString()));
        }



    }

    //protected void Page_PreRender(object sender, EventArgs e)
    //{
    //    if (RadGrid2.SelectedIndexes.Count == 0)
    //        RadGrid2.SelectedIndexes.Add(0);
    //    if (RadGrid3.SelectedIndexes.Count == 0)
    //    {
    //        RadGrid3.Rebind();
    //        RadGrid3.SelectedIndexes.Add(0);
    //    }
    //}

    //protected void RadGrid2_ItemCommand(object sender, GridCommandEventArgs e)
    //{
    //    RadGrid3.SelectedIndexes.Clear();
    //}

    protected void RadComboBox1_DataBound(object sender, EventArgs e)
    {
        SqlDataSource2.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        SqlDataSource3.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();

        RadGrid2.Rebind(); 
    }


    protected void SqlDataSource3_Selecting(object sender, System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs e)
    {
        e.Command.Parameters[0].Value = RadComboBox1.SelectedValue.ToString();
    }
}