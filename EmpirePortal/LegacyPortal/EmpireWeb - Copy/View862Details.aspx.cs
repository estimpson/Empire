using System;
using System.Web.UI;
using System.Data;
using Telerik.Web.UI;
using Telerik.Web.Data;

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
        DateTime? day5 = day0.Value.AddDays(5);
        DateTime? day6 = day0.Value.AddDays(6);
       
        SqlDataSource2.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();

        RadGrid2.MasterTableView.Columns[3].HeaderText = day0.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[4].HeaderText = day1.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[5].HeaderText = day2.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[6].HeaderText = day3.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[7].HeaderText = day4.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[8].HeaderText = day5.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[9].HeaderText = day6.Value.ToShortDateString();
        RadGrid2.Rebind();

        SqlDataSource3.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGrid3.Rebind();

        SqlDataSource4.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGrid4.Rebind();

        SqlDataSource5.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGrid5.Rebind();
    }

    protected void  RadComboBox1_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        DateTime? day0 = DateTime.Parse(RadComboBox1.SelectedValue.ToString());
        DateTime? day1 = day0.Value.AddDays(1);
        DateTime? day2 = day0.Value.AddDays(2);
        DateTime? day3 = day0.Value.AddDays(3);
        DateTime? day4 = day0.Value.AddDays(4);
        DateTime? day5 = day0.Value.AddDays(5);
        DateTime? day6 = day0.Value.AddDays(6);

        RadGrid2.MasterTableView.Columns[3].HeaderText = day0.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[4].HeaderText = day1.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[5].HeaderText = day2.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[6].HeaderText = day3.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[7].HeaderText = day4.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[8].HeaderText = day5.Value.ToShortDateString();
        RadGrid2.MasterTableView.Columns[9].HeaderText = day6.Value.ToShortDateString();
        RadGrid2.Rebind();
    }

    protected void RadGrid2_PreRender(object sender, EventArgs e)
    {
        if (RadGrid2.SelectedIndexes.Count == 0 && RadGrid3.SelectedIndexes.Count == 0)
        {
            RadGrid2.SelectedIndexes.Add(0);
            RadGrid3.SelectedIndexes.Add(0);
           
        }
        if (RadGrid2.SelectedIndexes.Count == 0 && RadGrid4.SelectedIndexes.Count == 0)
        {
            RadGrid4.SelectedIndexes.Add(0);
        }
        if (RadGrid2.SelectedIndexes.Count == 0 && RadGrid5.SelectedIndexes.Count == 0)
        {
            RadGrid5.SelectedIndexes.Add(0);
        }
    }


    protected void RadGrid2_SelectedIndexChanged(object sender, EventArgs e)
    {
        SqlDataSource3.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGrid3.Rebind();
        SqlDataSource4.SelectParameters[0].DefaultValue = RadComboBox1.SelectedValue.ToString();
        RadGrid4.Rebind();

        //RadGrid5.Rebind();
    }
}