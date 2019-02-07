using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using Telerik.Web.Data;
using Telerik.Web.Design;

public partial class NALReview : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void RadComboBox1_DataBound(object sender, EventArgs e)
    {

        DateTime? day0 = DateTime.Parse(RadComboBox1.SelectedValue.ToString());
        DateTime? day1 = day0.Value.AddDays(1);
        DateTime? day2 = day0.Value.AddDays(2);
        DateTime? day3 = day0.Value.AddDays(3);
        DateTime? day4 = day0.Value.AddDays(4);

        RadGridM.MasterTableView.Columns.FindByUniqueName("Day0ReleaseNo").HeaderText = day0.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns.FindByUniqueName("Day1ReleaseNo").HeaderText = day1.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[6].HeaderText = day2.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[7].HeaderText = day3.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[8].HeaderText = day4.Value.ToString("ddd M/d/yyy");


        SqlDataSourceM.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();

    }

    protected void  RadComboBox1_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        DateTime? day0 = DateTime.Parse(RadComboBox1.SelectedValue.ToString());
        DateTime? day1 = day0.Value.AddDays(1);
        DateTime? day2 = day0.Value.AddDays(2);
        DateTime? day3 = day0.Value.AddDays(3);
        DateTime? day4 = day0.Value.AddDays(4);

        RadGridM.MasterTableView.Columns.FindByUniqueName("Day0ReleaseNo").HeaderText = day0.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns.FindByUniqueName("Day1ReleaseNo").HeaderText = day1.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[6].HeaderText = day2.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[7].HeaderText = day3.Value.ToString("ddd M/d/yyy");
        RadGridM.MasterTableView.Columns[8].HeaderText = day4.Value.ToString("ddd M/d/yyy");

        SqlDataSourceM.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGridM.Rebind();

    }
    
    protected void RadGridM_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {

            GridDataItem item = e.Item as GridDataItem;
            RadGrid gridP = item["PastDueReleaseNo"].FindControl("RadGridP") as RadGrid;
            RadGrid grid0 = item["Day0ReleaseNo"].FindControl("RadGrid0") as RadGrid;
            RadGrid grid1 = item["Day1ReleaseNo"].FindControl("RadGrid1") as RadGrid;
            RadGrid grid2 = item["Day2ReleaseNo"].FindControl("RadGrid2") as RadGrid;
            RadGrid grid3 = item["Day3ReleaseNo"].FindControl("RadGrid3") as RadGrid;
            RadGrid grid4 = item["Day4ReleaseNo"].FindControl("RadGrid4") as RadGrid;

            SqlDataSourceP.SelectParameters[0].DefaultValue = item.GetDataKeyValue("PastDueReleaseNo").ToString();
            SqlDataSource0.SelectParameters[0].DefaultValue = item.GetDataKeyValue("Day0ReleaseNo").ToString();
            SqlDataSource1.SelectParameters[0].DefaultValue = item.GetDataKeyValue("Day1ReleaseNo").ToString();
            SqlDataSource2.SelectParameters[0].DefaultValue = item.GetDataKeyValue("Day2ReleaseNo").ToString();
            SqlDataSource3.SelectParameters[0].DefaultValue = item.GetDataKeyValue("Day3ReleaseNo").ToString();
            SqlDataSource4.SelectParameters[0].DefaultValue = item.GetDataKeyValue("Day4ReleaseNo").ToString();

            gridP.DataSource = SqlDataSourceP.Select(DataSourceSelectArguments.Empty);
            grid0.DataSource = SqlDataSource0.Select(DataSourceSelectArguments.Empty);
            grid1.DataSource = SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            grid2.DataSource = SqlDataSource2.Select(DataSourceSelectArguments.Empty);
            grid3.DataSource = SqlDataSource3.Select(DataSourceSelectArguments.Empty);
            grid4.DataSource = SqlDataSource4.Select(DataSourceSelectArguments.Empty);
 
            gridP.DataBind();
            grid0.DataBind();
            grid1.DataBind();
            grid2.DataBind();
            grid3.DataBind();
            grid4.DataBind();
        }
    }

    protected void RadGridP_PreRender(object sender, EventArgs e)
    {
        RadGrid gridPP = sender as RadGrid;
        if (gridPP.Items.Count == 0)
        {
            gridPP.Visible = false;       
        }
    }

    protected void RadGrid0_PreRender(object sender, EventArgs e)
    {
        RadGrid grid00 = sender as RadGrid;
        if (grid00.Items.Count == 0)
        {
            grid00.Visible = false;
        }
    }

    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        RadGrid grid11 = sender as RadGrid;
        if (grid11.Items.Count == 0)
        {
            grid11.Visible = false;
        }
    }

    protected void RadGrid2_PreRender(object sender, EventArgs e)
    {
        RadGrid grid22 = sender as RadGrid;
        if (grid22.Items.Count == 0)
        {
            grid22.Visible = false;
        }
    }

    protected void RadGrid3_PreRender(object sender, EventArgs e)
    {
        RadGrid grid33 = sender as RadGrid;
        if (grid33.Items.Count == 0)
        {
            grid33.Visible = false;
        }
    }

    protected void RadGrid4_PreRender(object sender, EventArgs e)
    {
        RadGrid grid44 = sender as RadGrid;
        if (grid44.Items.Count == 0)
        {
            grid44.Visible = false;
        }
    }
}